#!/usr/bin/env bun

/**
 * Image Generation CLI Tool
 *
 * Backends:
 *   gemini-flash  →  gemini-2.5-flash-image              (generateContent — fast, free tier)
 *   gemini-pro    →  gemini-3.1-flash-image-preview      (generateContent — best quality, 4K)
 *   gpt-image-1   →  OpenAI gpt-image-1.5                (SOTA, best text rendering)
 *
 * Usage:  bun Generate.ts --prompt "..." [options]
 * Env:    loaded from ~/.claude/.env (never overwrites existing shell env vars)
 */

import { existsSync, mkdirSync, readFileSync, unlinkSync, writeFileSync } from 'fs';
import { homedir } from 'os';
import { basename, dirname, extname, join } from 'path';

import { GoogleGenAI } from '@google/genai';
import OpenAI from 'openai';

// ─── Types ────────────────────────────────────────────────────────────────────

type ModelAlias = 'gemini-flash' | 'gemini-pro' | 'gpt-image-1';
type GeminiSize = '1K' | '2K' | '4K';
type OpenAISize = '1024x1024' | '1536x1024' | '1024x1536';
type AspectRatio = '1:1' | '16:9' | '9:16' | '2:3' | '3:2' | '3:4' | '4:3' | '4:5' | '5:4' | '21:9';
type ImageFormat = 'png' | 'jpeg' | 'webp' | 'gif' | 'unknown';

interface CliArgs {
  readonly model: ModelAlias;
  readonly prompt: string;
  readonly size: GeminiSize | OpenAISize | undefined;
  readonly aspectRatio: AspectRatio | undefined;
  readonly output: string | undefined;
  readonly referenceImages: readonly string[];
  readonly transparent: boolean;
  readonly removeBg: boolean;
  readonly addBg: string | undefined;
  readonly thumbnail: boolean;
  readonly creativeVariations: number;
  readonly help: boolean;
}

// ─── Constants ────────────────────────────────────────────────────────────────

const GEMINI_FLASH_MODEL = 'gemini-2.5-flash-image';           // generateContent — fast, free tier
const GEMINI_PRO_MODEL = 'gemini-3.1-flash-image-preview';     // generateContent — best quality Gemini native
const IMAGEN_FALLBACK_MODEL = 'imagen-4.0-generate-001';       // predict (generateImages) — Imagen 4 Standard
const OPENAI_MODEL = 'gpt-image-1.5';

const DEFAULT_OUTPUT_DIR = join(homedir(), 'prj', 'art-skill', 'outputs');
const THUMBNAIL_BG_COLOR = '#F6F3EB';
const MAX_REFERENCE_IMAGES = 14;

// Aspect ratios natively supported by Imagen (others require prompt-based hinting)
const IMAGEN_NATIVE_RATIOS = new Set<string>(['1:1', '9:16', '16:9', '3:4', '4:3']);

const VALID_MODELS = new Set<ModelAlias>(['gemini-flash', 'gemini-pro', 'gpt-image-1']);
const VALID_GEMINI_SIZES = new Set<string>(['1K', '2K', '4K']);
const VALID_OPENAI_SIZES = new Set<string>(['1024x1024', '1536x1024', '1024x1536']);
const VALID_ASPECT_RATIOS = new Set<string>([
  '1:1', '16:9', '9:16', '2:3', '3:2', '3:4', '4:3', '4:5', '5:4', '21:9',
]);

// ─── Environment ──────────────────────────────────────────────────────────────

function loadEnvFile(envPath: string): void {
  if (!existsSync(envPath)) return;

  const content = readFileSync(envPath, 'utf-8');
  for (const raw of content.split('\n')) {
    const line = raw.trim();
    if (!line || line.startsWith('#')) continue;

    const eqIdx = line.indexOf('=');
    if (eqIdx === -1) continue;

    const key = line.slice(0, eqIdx).trim();
    let value = line.slice(eqIdx + 1).trim();

    // Strip surrounding single or double quotes
    if (
      value.length >= 2 &&
      ((value.startsWith('"') && value.endsWith('"')) ||
        (value.startsWith("'") && value.endsWith("'")))
    ) {
      value = value.slice(1, -1);
    }

    // Shell env vars take precedence; never overwrite
    if (key && !(key in process.env)) {
      process.env[key] = value;
    }
  }
}

// ─── Image Format Detection (magic bytes) ─────────────────────────────────────

function detectImageFormat(data: Uint8Array): ImageFormat {
  if (data.length < 4) return 'unknown';

  // PNG:  89 50 4E 47
  if (data[0] === 0x89 && data[1] === 0x50 && data[2] === 0x4e && data[3] === 0x47) return 'png';

  // JPEG: FF D8 FF
  if (data[0] === 0xff && data[1] === 0xd8 && data[2] === 0xff) return 'jpeg';

  // WebP: RIFF????WEBP
  if (
    data[0] === 0x52 && data[1] === 0x49 && data[2] === 0x46 && data[3] === 0x46 &&
    data.length >= 12 &&
    data[8] === 0x57 && data[9] === 0x45 && data[10] === 0x42 && data[11] === 0x50
  ) {
    return 'webp';
  }

  // GIF: 47 49 46 38
  if (data[0] === 0x47 && data[1] === 0x49 && data[2] === 0x46 && data[3] === 0x38) return 'gif';

  return 'unknown';
}

const FORMAT_EXT: Record<ImageFormat, string> = {
  png: '.png', jpeg: '.jpg', webp: '.webp', gif: '.gif', unknown: '.bin',
};

const FORMAT_MIME: Record<ImageFormat, string> = {
  png: 'image/png', jpeg: 'image/jpeg', webp: 'image/webp',
  gif: 'image/gif', unknown: 'application/octet-stream',
};

// ─── Help ─────────────────────────────────────────────────────────────────────

function printHelp(): void {
  const txt = `
Image Generation CLI

USAGE
  bun Generate.ts --prompt <text> [options]

OPTIONS
  --model <model>
      Backend model (default: gemini-flash)
        gemini-flash  →  gemini-2.5-flash-image (fast, free tier)
        gemini-pro    →  gemini-3.1-flash-image-preview (best quality, 4K)
        gpt-image-1   →  OpenAI gpt-image-1.5 (SOTA, best text rendering)

  --prompt <text>
      Generation prompt (required)

  --size <size>
      Gemini: 1K | 2K | 4K                    (default: 2K)
      OpenAI: 1024x1024 | 1536x1024 | 1024x1536  (default: 1024x1024)

  --aspect-ratio <ratio>
      Gemini only (default: 16:9)
        1:1 | 16:9 | 9:16 | 2:3 | 3:2 | 3:4 | 4:3 | 4:5 | 5:4 | 21:9

  --output <path>
      Output file path (default: ~/prj/art-skill/outputs/<timestamp>.png)

  --reference-image <path>
      Reference image path — Gemini only, max ${MAX_REFERENCE_IMAGES}, repeatable

  --transparent
      Add transparency instructions to prompt

  --remove-bg
      Remove background via remove.bg API after generation (needs REMOVEBG_API_KEY)

  --add-bg <#hex>
      Composite transparent image onto a solid hex background using ImageMagick
      Example: --add-bg "#F6F3EB"

  --thumbnail
      Save both a transparent version and a thumbnail with ${THUMBNAIL_BG_COLOR} background.
      Implies transparent background request. Combine with --remove-bg for clean edges.

  --creative-variations <N>
      Generate N independent variations  (1–10, default: 1)

  --help, -h
      Show this help message

ENVIRONMENT  (loaded from ~/.claude/.env)
  GOOGLE_API_KEY      Gemini / Imagen
  OPENAI_API_KEY      gpt-image-1 (uses gpt-image-1.5)
  REMOVEBG_API_KEY    --remove-bg

EXAMPLES
  bun Generate.ts --prompt "red apple on white table" --model gemini-flash
  bun Generate.ts --prompt "futuristic city at night" --model gpt-image-1 --size 1536x1024
  bun Generate.ts --prompt "product logo" --transparent --thumbnail --model gemini-flash
  bun Generate.ts --prompt "logo" --remove-bg --add-bg "#F6F3EB" --model gemini-flash
  bun Generate.ts --prompt "abstract art" --creative-variations 4 --aspect-ratio 1:1
  bun Generate.ts --model gemini-pro --prompt "portrait" --reference-image photo.jpg --aspect-ratio 9:16
`.trimStart();
  process.stdout.write(txt + '\n');
}

// ─── CLI Parsing ──────────────────────────────────────────────────────────────

function parseArgs(argv: string[]): CliArgs {
  let model: ModelAlias = 'gemini-flash';
  let prompt = '';
  let size: GeminiSize | OpenAISize | undefined;
  let aspectRatio: AspectRatio | undefined;
  let output: string | undefined;
  const referenceImages: string[] = [];
  let transparent = false;
  let removeBg = false;
  let addBg: string | undefined;
  let thumbnail = false;
  let creativeVariations = 1;
  let help = false;

  /** Consume the next argument or throw a clear error. */
  const consume = (flag: string, i: number): string => {
    if (i + 1 >= argv.length) throw new Error(`${flag} requires a value`);
    return argv[i + 1];
  };

  let i = 0;
  while (i < argv.length) {
    const arg = argv[i];

    switch (arg) {
      case '--help':
      case '-h':
        help = true;
        break;

      case '--model': {
        const v = consume('--model', i++);
        if (!VALID_MODELS.has(v as ModelAlias)) {
          throw new Error(
            `Invalid --model "${v}". Valid values: gemini-flash | gemini-pro | gpt-image-1`,
          );
        }
        model = v as ModelAlias;
        break;
      }

      case '--prompt':
        prompt = consume('--prompt', i++);
        break;

      case '--size': {
        const v = consume('--size', i++);
        if (!VALID_GEMINI_SIZES.has(v) && !VALID_OPENAI_SIZES.has(v)) {
          throw new Error(
            `Invalid --size "${v}". Gemini: 1K|2K|4K  OpenAI: 1024x1024|1536x1024|1024x1536`,
          );
        }
        size = v as GeminiSize | OpenAISize;
        break;
      }

      case '--aspect-ratio': {
        const v = consume('--aspect-ratio', i++);
        if (!VALID_ASPECT_RATIOS.has(v)) {
          throw new Error(
            `Invalid --aspect-ratio "${v}". Valid: ${[...VALID_ASPECT_RATIOS].join(' | ')}`,
          );
        }
        aspectRatio = v as AspectRatio;
        break;
      }

      case '--output':
        output = consume('--output', i++);
        break;

      case '--reference-image': {
        const p = consume('--reference-image', i++);
        if (referenceImages.length >= MAX_REFERENCE_IMAGES) {
          throw new Error(`Maximum of ${MAX_REFERENCE_IMAGES} reference images allowed`);
        }
        if (!existsSync(p)) throw new Error(`Reference image not found: ${p}`);
        referenceImages.push(p);
        break;
      }

      case '--transparent':
        transparent = true;
        break;

      case '--remove-bg':
        removeBg = true;
        break;

      case '--add-bg': {
        const hex = consume('--add-bg', i++);
        if (!/^#[0-9A-Fa-f]{6}$/.test(hex)) {
          throw new Error(`Invalid --add-bg color "${hex}". Expected format: #RRGGBB`);
        }
        addBg = hex;
        break;
      }

      case '--thumbnail':
        thumbnail = true;
        break;

      case '--creative-variations': {
        const raw = consume('--creative-variations', i++);
        const n = Number.parseInt(raw, 10);
        if (Number.isNaN(n) || n < 1 || n > 10) {
          throw new Error('--creative-variations must be an integer between 1 and 10');
        }
        creativeVariations = n;
        break;
      }

      default:
        throw new Error(`Unknown argument: "${arg}". Run with --help for usage.`);
    }

    i++;
  }

  return Object.freeze({
    model, prompt, size, aspectRatio, output,
    referenceImages: Object.freeze(referenceImages),
    transparent, removeBg, addBg, thumbnail,
    creativeVariations, help,
  });
}

// ─── Output Path ──────────────────────────────────────────────────────────────

function resolveOutputPath(
  args: Pick<CliArgs, 'output'>,
  variationIndex: number,
  totalCount: number,
): string {
  const varSuffix = totalCount > 1 ? `_v${variationIndex + 1}` : '';

  if (args.output) {
    const dir = dirname(args.output);
    const ext = extname(args.output) || '.png';
    const name = basename(args.output, ext);
    return join(dir, `${name}${varSuffix}${ext}`);
  }

  // Default: ~/prj/art-skill/outputs/<ISO-timestamp><varSuffix>.png
  const ts = new Date().toISOString().replace(/[:T]/g, '-').replace(/\..+$/, '');
  return join(DEFAULT_OUTPUT_DIR, `${ts}${varSuffix}.png`);
}

function ensureParentDir(filePath: string): void {
  const dir = dirname(filePath);
  if (!existsSync(dir)) mkdirSync(dir, { recursive: true });
}

/** Replace or append suffix before the file extension. */
function withSuffix(filePath: string, suffix: string): string {
  const ext = extname(filePath);
  const base = ext ? filePath.slice(0, -ext.length) : filePath;
  return `${base}${suffix}${ext || '.png'}`;
}

// ─── Gemini Backend ───────────────────────────────────────────────────────────

function buildGeminiPrompt(args: CliArgs): string {
  const parts: string[] = [args.prompt];

  // Transparency — implied by either --transparent or --thumbnail
  if (args.transparent || args.thumbnail) {
    parts.push(
      'IMPORTANT: Generate the image with a fully transparent background (no background ' +
      'elements at all). The output must be a PNG file with a proper alpha channel.',
    );
  }

  // Size hint (Gemini sizes only; OpenAI sizes are API params, not prompt hints)
  const effectiveSize = VALID_GEMINI_SIZES.has(args.size ?? '') ? (args.size as GeminiSize) : '2K';
  const sizeLabels: Record<GeminiSize, string> = {
    '1K': '1024 × 1024 pixels',
    '2K': '2048 × 2048 pixels',
    '4K': '4096 × 4096 pixels',
  };
  parts.push(`Target resolution: ${sizeLabels[effectiveSize]}.`);

  // Aspect ratio hint in prompt (used for Flash, and as supplementary for Imagen)
  const effectiveRatio = args.aspectRatio ?? '16:9';
  parts.push(`Aspect ratio: ${effectiveRatio}.`);

  return parts.join('\n\n');
}

function buildInlineImageParts(imagePaths: readonly string[]): Array<{
  inlineData: { mimeType: string; data: string };
}> {
  return imagePaths.map((p) => {
    const raw = readFileSync(p);
    const format = detectImageFormat(raw);
    const mimeType = FORMAT_MIME[format] === 'application/octet-stream'
      ? 'image/png'  // safe fallback for unrecognised files
      : FORMAT_MIME[format];
    return { inlineData: { mimeType, data: raw.toString('base64') } };
  });
}

async function callGeminiGenerateContent(
  modelId: string,
  prompt: string,
  referenceImages: readonly string[],
  apiKey: string,
): Promise<Buffer[]> {
  const ai = new GoogleGenAI({ apiKey });

  const refParts = buildInlineImageParts(referenceImages);
  const parts = [...refParts, { text: prompt }];

  const response = await ai.models.generateContent({
    model: modelId,
    contents: [{ role: 'user', parts }],
    config: { responseModalities: ['IMAGE', 'TEXT'] },
  });

  const images: Buffer[] = [];
  for (const candidate of (response.candidates ?? [])) {
    for (const part of (candidate.content?.parts ?? [])) {
      const data = part.inlineData?.data;
      if (data) images.push(Buffer.from(data, 'base64'));
    }
  }
  return images;
}

async function callImagen(
  prompt: string,
  count: number,
  aspectRatio: AspectRatio | undefined,
  apiKey: string,
  modelOverride?: string,
): Promise<Buffer[]> {
  const ai = new GoogleGenAI({ apiKey });
  const model = modelOverride ?? IMAGEN_FALLBACK_MODEL;

  const requestedRatio = aspectRatio ?? '16:9';
  const imageAspectRatio = IMAGEN_NATIVE_RATIOS.has(requestedRatio) ? requestedRatio : '1:1';

  if (!IMAGEN_NATIVE_RATIOS.has(requestedRatio)) {
    console.warn(
      `  Warning: Aspect ratio "${requestedRatio}" is not natively supported by Imagen. ` +
      `Falling back to 1:1. Natively supported: ${[...IMAGEN_NATIVE_RATIOS].join(', ')}`,
    );
  }

  const response = await ai.models.generateImages({
    model,
    prompt,
    config: {
      numberOfImages: Math.min(count, 4), // Imagen cap per request
      aspectRatio: imageAspectRatio,
    },
  });

  const images: Buffer[] = [];
  for (const generated of (response.generatedImages ?? [])) {
    const bytes = generated.image?.imageBytes;
    if (!bytes) continue;
    // imageBytes is Uint8Array in current SDK; future versions might return base64 string
    images.push(typeof bytes === 'string' ? Buffer.from(bytes, 'base64') : Buffer.from(bytes));
  }
  return images;
}

async function generateWithGemini(args: CliArgs): Promise<Buffer[]> {
  const apiKey = process.env['GOOGLE_API_KEY'];
  if (!apiKey) {
    throw new Error('GOOGLE_API_KEY is required for Gemini models. Add it to ~/.claude/.env.');
  }

  if (args.referenceImages.length > 0 && args.model !== 'gemini-flash') {
    console.warn(
      '  Warning: Reference images are only used with gemini-flash ' +
      '(the Imagen backend does not accept reference images).',
    );
  }

  const prompt = buildGeminiPrompt(args);
  const count = args.creativeVariations;
  const collected: Buffer[] = [];

  if (args.model === 'gemini-flash') {
    // Flash generateContent returns ~1 image per call; loop for N variations
    for (let attempt = 0; attempt < count && collected.length < count; attempt++) {
      const batch = await callGeminiGenerateContent(
        GEMINI_FLASH_MODEL, prompt, args.referenceImages, apiKey,
      );
      collected.push(...batch);
    }
  } else {
    // gemini-pro: use gemini-3.1-flash-image-preview via generateContent
    // Falls back to Imagen 4 Standard via generateImages if the native model fails.
    for (let attempt = 0; attempt < count && collected.length < count; attempt++) {
      try {
        const batch = await callGeminiGenerateContent(
          GEMINI_PRO_MODEL, prompt, args.referenceImages, apiKey,
        );
        collected.push(...batch);
      } catch (err) {
        const msg = err instanceof Error ? err.message : String(err);
        console.warn(`  ${GEMINI_PRO_MODEL} failed (${msg}), falling back to ${IMAGEN_FALLBACK_MODEL} via generateImages…`);
        const remaining = count - collected.length;
        const batch = await callImagen(prompt, Math.min(remaining, 4), args.aspectRatio, apiKey);
        collected.push(...batch);
        break; // Imagen handles batching internally
      }
    }
  }

  return collected.slice(0, count);
}

// ─── OpenAI Backend ───────────────────────────────────────────────────────────

async function generateWithOpenAI(args: CliArgs): Promise<Buffer[]> {
  const apiKey = process.env['OPENAI_API_KEY'];
  if (!apiKey) {
    throw new Error('OPENAI_API_KEY is required for gpt-image-1. Add it to ~/.claude/.env.');
  }

  const openai = new OpenAI({ apiKey });

  const wantsTransparent = args.transparent || args.thumbnail;

  let prompt = args.prompt;
  if (wantsTransparent) {
    prompt +=
      '\n\nGenerate with a fully transparent background. ' +
      'Output as PNG with alpha channel transparency.';
  }

  const rawSize = args.size as string | undefined;
  const size: '1024x1024' | '1536x1024' | '1024x1536' =
    rawSize && VALID_OPENAI_SIZES.has(rawSize)
      ? (rawSize as '1024x1024' | '1536x1024' | '1024x1536')
      : '1024x1024';

  // Build params — include gpt-image-1 specific `background` when transparency is needed.
  // The `background` key is typed in recent openai@4 but cast to avoid version skew issues.
  const params = {
    model: OPENAI_MODEL,
    prompt,
    n: args.creativeVariations,
    size,
    ...(wantsTransparent ? { background: 'transparent' } : {}),
  } as Parameters<typeof openai.images.generate>[0];

  const response = await openai.images.generate(params);

  const images: Buffer[] = [];
  for (const item of (response.data ?? [])) {
    if (item.b64_json) {
      images.push(Buffer.from(item.b64_json, 'base64'));
    } else if (item.url) {
      const res = await fetch(item.url);
      if (!res.ok) throw new Error(`Failed to fetch image from OpenAI URL: HTTP ${res.status}`);
      images.push(Buffer.from(await res.arrayBuffer()));
    }
  }
  return images;
}

// ─── Post-processing ──────────────────────────────────────────────────────────

async function callRemoveBg(imageData: Buffer, apiKey: string): Promise<Buffer> {
  process.stdout.write('  → remove.bg: removing background…\n');

  const form = new FormData();
  form.append('image_file', new Blob([imageData]), 'image.png');
  form.append('size', 'auto');

  const res = await fetch('https://api.remove.bg/v1.0/removebg', {
    method: 'POST',
    headers: { 'X-Api-Key': apiKey },
    body: form,
  });

  if (!res.ok) {
    const body = await res.text();
    throw new Error(`remove.bg API error (HTTP ${res.status}): ${body}`);
  }

  return Buffer.from(await res.arrayBuffer());
}

/**
 * Use ImageMagick to flatten a transparent PNG onto a solid background colour.
 * Tries the `magick` binary first (ImageMagick 7+) then `convert` (ImageMagick 6).
 */
async function flattenWithColor(
  imageData: Buffer,
  hexColor: string,
  outputPath: string,
): Promise<void> {
  ensureParentDir(outputPath);

  const tempPath = `${outputPath}.__imgtmp__.png`;
  writeFileSync(tempPath, imageData);

  let lastError = 'ImageMagick not found.';

  for (const binary of ['magick', 'convert']) {
    const proc = Bun.spawn(
      [binary, '-background', hexColor, '-flatten', tempPath, outputPath],
      { stderr: 'pipe', stdout: 'pipe' },
    );

    // Collect stderr concurrently while the process runs
    const stderrPromise = new Response(proc.stderr as ReadableStream<Uint8Array>).text();
    const exitCode = await proc.exited;
    const stderrText = await stderrPromise;

    if (exitCode === 0) {
      try { unlinkSync(tempPath); } catch { /* best-effort */ }
      return;
    }

    // If the binary was simply not found, try the next one
    const notFound =
      stderrText.toLowerCase().includes('not found') ||
      stderrText.toLowerCase().includes('no such file') ||
      stderrText.trim() === '';

    if (!notFound) {
      try { unlinkSync(tempPath); } catch { /* best-effort */ }
      throw new Error(`ImageMagick (${binary}) error: ${stderrText.trim()}`);
    }

    lastError = `"${binary}" not found`;
  }

  try { unlinkSync(tempPath); } catch { /* best-effort */ }
  throw new Error(
    `${lastError}. Install ImageMagick: brew install imagemagick  (or apt install imagemagick)`,
  );
}

// ─── Saving with Post-processing ──────────────────────────────────────────────

/**
 * Correct the output file extension based on detected magic bytes.
 * We never downgrade .png → .jpg because the user might deliberately want PNG,
 * but we will fix clearly wrong extensions for non-PNG formats.
 */
function resolveExtension(filePath: string, imageData: Buffer): string {
  const format = detectImageFormat(imageData);
  if (format === 'unknown') return filePath;

  const currentExt = extname(filePath).toLowerCase();
  const correctExt = FORMAT_EXT[format];

  // If the file has no extension, append the detected one
  if (!currentExt) return `${filePath}${correctExt}`;

  // For non-PNG detected formats that clearly mismatch, fix the extension
  if (format !== 'png' && currentExt !== correctExt) {
    return filePath.slice(0, -currentExt.length) + correctExt;
  }

  return filePath;
}

async function saveImage(
  imageData: Buffer,
  basePath: string,
  args: CliArgs,
  label: string,
): Promise<void> {
  const outputPath = resolveExtension(basePath, imageData);
  ensureParentDir(outputPath);

  // Step 1: optionally strip the background
  let processed = imageData;
  if (args.removeBg) {
    const key = process.env['REMOVEBG_API_KEY'];
    if (!key) {
      throw new Error('REMOVEBG_API_KEY is required for --remove-bg. Add it to ~/.claude/.env.');
    }
    processed = await callRemoveBg(imageData, key);
  }

  // Step 2: choose output mode
  if (args.thumbnail) {
    // Save raw transparent version
    const transparentPath = withSuffix(outputPath, '_transparent');
    writeFileSync(transparentPath, processed);
    process.stdout.write(`  ${label}transparent  →  ${transparentPath}\n`);

    // Create thumbnail by compositing onto brand background
    const thumbnailPath = withSuffix(outputPath, '_thumbnail');
    await flattenWithColor(processed, THUMBNAIL_BG_COLOR, thumbnailPath);
    process.stdout.write(`  ${label}thumbnail    →  ${thumbnailPath}\n`);
  } else if (args.addBg) {
    await flattenWithColor(processed, args.addBg, outputPath);
    process.stdout.write(`  ${label}→  ${outputPath}\n`);
  } else {
    writeFileSync(outputPath, processed);
    process.stdout.write(`  ${label}→  ${outputPath}\n`);
  }
}

// ─── Main ─────────────────────────────────────────────────────────────────────

async function main(): Promise<void> {
  // Load env from ~/.claude/.env (shell env vars take precedence)
  loadEnvFile(join(homedir(), '.claude', '.env'));

  // Bun sets process.argv[0]='bun', process.argv[1]='<script>'
  const rawArgv = process.argv.slice(2);

  let args: CliArgs;
  try {
    args = parseArgs(rawArgv);
  } catch (err) {
    process.stderr.write(`Error: ${(err as Error).message}\nRun with --help for usage.\n`);
    process.exit(1);
  }

  if (args.help) {
    printHelp();
    return;
  }

  if (!args.prompt.trim()) {
    process.stderr.write('Error: --prompt is required and cannot be empty.\nRun with --help for usage.\n');
    process.exit(1);
  }

  // Warn about silently ignored flags
  if (args.aspectRatio && args.model === 'gpt-image-1') {
    console.warn('Warning: --aspect-ratio is ignored for gpt-image-1.');
  }
  if (args.referenceImages.length > 0 && args.model === 'gpt-image-1') {
    console.warn('Warning: --reference-image is ignored for gpt-image-1.');
  }
  if (args.size && VALID_GEMINI_SIZES.has(args.size) && args.model === 'gpt-image-1') {
    console.warn(`Warning: Gemini size "${args.size}" is ignored for gpt-image-1. Use 1024x1024 | 1536x1024 | 1024x1536.`);
  }
  if (args.size && VALID_OPENAI_SIZES.has(args.size) && args.model !== 'gpt-image-1') {
    console.warn(`Warning: OpenAI size "${args.size}" is ignored for Gemini models. Use 1K | 2K | 4K.`);
  }

  const count = args.creativeVariations;
  const modelDisplay =
    args.model === 'gemini-flash' ? GEMINI_FLASH_MODEL
    : args.model === 'gemini-pro' ? `${GEMINI_PRO_MODEL} (fallback: ${IMAGEN_FALLBACK_MODEL})`
    : OPENAI_MODEL;

  process.stdout.write(
    `Generating ${count > 1 ? `${count} variations` : 'image'} with ${modelDisplay}…\n`,
  );

  let images: Buffer[];
  try {
    images = args.model === 'gpt-image-1'
      ? await generateWithOpenAI(args)
      : await generateWithGemini(args);
  } catch (err) {
    process.stderr.write(`Generation failed: ${(err as Error).message}\n`);
    process.exit(1);
  }

  if (images.length === 0) {
    process.stderr.write('Error: The model returned no images.\n');
    process.exit(1);
  }

  process.stdout.write('\n');

  let saved = 0;
  for (let idx = 0; idx < images.length; idx++) {
    const outPath = resolveOutputPath(args, idx, images.length);
    const label = images.length > 1 ? `[${idx + 1}/${images.length}] ` : '';
    try {
      await saveImage(images[idx], outPath, args, label);
      saved++;
    } catch (err) {
      process.stderr.write(`  Failed to save image ${idx + 1}: ${(err as Error).message}\n`);
    }
  }

  process.stdout.write(`\nDone — ${saved} of ${images.length} image(s) saved.\n`);
}

main().catch((err: unknown) => {
  process.stderr.write(`Fatal error: ${(err as Error).message}\n`);
  process.exit(1);
});
