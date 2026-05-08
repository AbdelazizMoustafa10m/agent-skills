# Remove Background -- Background Removal from Images

> Remove backgrounds from images using the remove.bg API, producing transparent
> PNG files suitable for compositing, overlays, and layered designs.

---

## When to Use

- Isolating subjects from their backgrounds for compositing
- Creating transparent PNGs for overlays on branded materials
- Preparing images for use in other Art skill workflows
- Batch processing multiple images for a project
- Cleaning up generated images that need transparent backgrounds

---

## Prerequisites

### API Key Setup

The remove.bg API key must be stored in `~/.claude/.env`:

```
REMOVEBG_API_KEY=your_api_key_here
```

To verify the key is configured:

```bash
grep REMOVEBG_API_KEY ~/.claude/.env
```

If the key is missing, the user needs to:
1. Sign up at https://www.remove.bg/
2. Get an API key from their account dashboard
3. Add it to `~/.claude/.env`

---

## Basic Usage

### Single Image Background Removal

```bash
# Load API key from .env
export $(grep REMOVEBG_API_KEY ~/.claude/.env | xargs)

# Remove background via remove.bg API
curl -s \
  -H "X-Api-Key: ${REMOVEBG_API_KEY}" \
  -F "image_file=@[INPUT_PATH]" \
  -F "size=auto" \
  -F "format=png" \
  -o [OUTPUT_PATH] \
  https://api.remove.bg/v1.0/removebg
```

### Parameters

| Parameter      | Value       | Description                                   |
|----------------|-------------|-----------------------------------------------|
| `image_file`   | `@filepath` | Path to the input image file                  |
| `image_url`    | URL string  | Alternative: provide a URL instead of file    |
| `size`         | `auto`      | Auto-detect best size (default)               |
|                | `preview`   | Small preview (up to 0.25 megapixels)         |
|                | `full`      | Full resolution (uses more credits)           |
|                | `regular`   | Up to 10 megapixels                           |
| `format`       | `png`       | PNG with transparency (recommended)           |
|                | `zip`       | ZIP archive containing PNG                    |
|                | `jpg`       | JPEG (no transparency)                        |
| `type`         | `auto`      | Auto-detect subject type                      |
|                | `person`    | Optimize for people                           |
|                | `product`   | Optimize for products/objects                 |
|                | `car`       | Optimize for cars                             |
| `bg_color`     | hex color   | Add solid background color (e.g., `#F6F3EB`) |
| `bg_image_url` | URL string  | Add background image from URL                 |

---

## Standard Workflow

### Step 1: Validate Input

```bash
# Check the input file exists and is an image
file [INPUT_PATH]
```

Supported input formats: PNG, JPG, JPEG, WEBP, BMP

### Step 2: Remove Background

```bash
export $(grep REMOVEBG_API_KEY ~/.claude/.env | xargs)

curl -s \
  -H "X-Api-Key: ${REMOVEBG_API_KEY}" \
  -F "image_file=@[INPUT_PATH]" \
  -F "size=auto" \
  -F "format=png" \
  -F "type=auto" \
  -o ~/prj/art-skill/outputs/[name]-nobg.png \
  https://api.remove.bg/v1.0/removebg
```

### Step 3: Verify Transparency

After removal, verify the output has an alpha channel (transparency):

```bash
# Check if the output has an alpha channel using sips (macOS)
sips --getProperty hasAlpha ~/prj/art-skill/outputs/[name]-nobg.png
```

Expected output: `hasAlpha: yes`

Alternative verification with `file`:

```bash
file ~/prj/art-skill/outputs/[name]-nobg.png
```

Should show `PNG image data` with mention of RGBA or alpha.

### Step 4: Check Dimensions

```bash
sips --getProperty pixelWidth --getProperty pixelHeight \
  ~/prj/art-skill/outputs/[name]-nobg.png
```

---

## Verify API Response

The API returns HTTP status codes. Check for errors:

```bash
export $(grep REMOVEBG_API_KEY ~/.claude/.env | xargs)

# Capture HTTP status code alongside the response
HTTP_STATUS=$(curl -s -w "%{http_code}" \
  -H "X-Api-Key: ${REMOVEBG_API_KEY}" \
  -F "image_file=@[INPUT_PATH]" \
  -F "size=auto" \
  -F "format=png" \
  -o ~/prj/art-skill/outputs/[name]-nobg.png \
  https://api.remove.bg/v1.0/removebg)

echo "HTTP Status: $HTTP_STATUS"
```

| Status | Meaning                                           |
|--------|---------------------------------------------------|
| 200    | Success -- image processed                        |
| 400    | Bad request -- check input file format            |
| 402    | Insufficient credits -- top up account            |
| 403    | Authentication failed -- check API key            |
| 429    | Rate limit exceeded -- wait and retry             |

---

## Batch Processing

### Process All Images in a Directory

```bash
export $(grep REMOVEBG_API_KEY ~/.claude/.env | xargs)

INPUT_DIR="[INPUT_DIRECTORY]"
OUTPUT_DIR=~/prj/art-skill/outputs

mkdir -p "$OUTPUT_DIR"

for img in "$INPUT_DIR"/*.{png,jpg,jpeg,webp}; do
  [ -f "$img" ] || continue

  filename=$(basename "$img")
  name="${filename%.*}"

  echo "Processing: $filename"

  curl -s \
    -H "X-Api-Key: ${REMOVEBG_API_KEY}" \
    -F "image_file=@${img}" \
    -F "size=auto" \
    -F "format=png" \
    -o "${OUTPUT_DIR}/${name}-nobg.png" \
    https://api.remove.bg/v1.0/removebg

  echo "  -> ${name}-nobg.png"
done

echo "Batch processing complete."
```

### Process a List of Specific Files

```bash
export $(grep REMOVEBG_API_KEY ~/.claude/.env | xargs)

FILES=(
  "~/prj/art-skill/outputs/image1.png"
  "~/prj/art-skill/outputs/image2.png"
  "~/prj/art-skill/outputs/image3.png"
)

for img in "${FILES[@]}"; do
  img=$(eval echo "$img")
  [ -f "$img" ] || { echo "Skipping (not found): $img"; continue; }

  filename=$(basename "$img")
  name="${filename%.*}"

  echo "Processing: $filename"

  curl -s \
    -H "X-Api-Key: ${REMOVEBG_API_KEY}" \
    -F "image_file=@${img}" \
    -F "size=auto" \
    -F "format=png" \
    -o ~/prj/art-skill/outputs/"${name}-nobg.png" \
    https://api.remove.bg/v1.0/removebg

  echo "  -> ${name}-nobg.png"
done
```

---

## Adding Custom Backgrounds

### Solid Brand Color Background

After removing the background, you can composite onto a brand color:

```bash
export $(grep REMOVEBG_API_KEY ~/.claude/.env | xargs)

# Remove background and add brand color in one step
curl -s \
  -H "X-Api-Key: ${REMOVEBG_API_KEY}" \
  -F "image_file=@[INPUT_PATH]" \
  -F "size=auto" \
  -F "format=png" \
  -F "bg_color=#F6F3EB" \
  -o ~/prj/art-skill/outputs/[name]-branded.png \
  https://api.remove.bg/v1.0/removebg
```

### Brand Color Options

| Background     | Hex       | Use Case                         |
|----------------|-----------|----------------------------------|
| Warm Cream     | #F6F3EB   | Default brand background         |
| Coral/Orange   | #D67056   | Bold accent background           |
| Teal           | #70B8AD   | Cool secondary background        |
| Tan/Sand       | #E6CCAB   | Warm neutral background          |
| Dark Grey Blue | #2C313A   | Dark mode / contrast background  |
| Mustard Yellow | #EAB64D   | Highlight / attention background |

---

## Integration with Other Workflows

### Prepare Images for Frameworks

```bash
# 1. Generate a framework diagram
bun run ~/.claude/skills/Art/Tools/Generate.ts \
  --model gemini-pro \
  --prompt "[framework prompt]" \
  --size 2K \
  --aspect-ratio 1:1 \
  --output ~/prj/art-skill/outputs/framework-raw.png

# 2. If needed, remove background for compositing
export $(grep REMOVEBG_API_KEY ~/.claude/.env | xargs)

curl -s \
  -H "X-Api-Key: ${REMOVEBG_API_KEY}" \
  -F "image_file=@$HOME/prj/art-skill/outputs/framework-raw.png" \
  -F "size=auto" \
  -F "format=png" \
  -o ~/prj/art-skill/outputs/framework-nobg.png \
  https://api.remove.bg/v1.0/removebg
```

### Prepare Subject Photos for Recipe Cards or Maps

Remove backgrounds from photos or icons that will be placed into
recipe cards, maps, or stat cards as overlays.

---

## Troubleshooting

### Common Issues

#### "Authentication failed" (403)
- **Cause**: Invalid or missing API key
- **Fix**: Verify the key in `~/.claude/.env`:
  ```bash
  grep REMOVEBG_API_KEY ~/.claude/.env
  ```
- **Fix**: Ensure the key is correctly formatted with no extra spaces
- **Fix**: Test the key directly:
  ```bash
  export $(grep REMOVEBG_API_KEY ~/.claude/.env | xargs)
  echo "Key length: ${#REMOVEBG_API_KEY}"
  ```

#### "Insufficient credits" (402)
- **Cause**: Account has no remaining credits
- **Fix**: Check credit balance at https://www.remove.bg/dashboard
- **Fix**: Free accounts get limited credits; upgrade if needed
- **Workaround**: Use `size=preview` for lower-credit usage

#### Output file is not transparent
- **Cause**: Format set to `jpg` instead of `png`
- **Fix**: Always use `-F "format=png"` for transparency
- **Verify**: `sips --getProperty hasAlpha [output].png`

#### Output file is very small / low quality
- **Cause**: `size=preview` was used
- **Fix**: Use `size=auto` or `size=full` for better quality
- **Note**: `size=full` uses more API credits

#### "Could not detect foreground" or poor results
- **Cause**: Low contrast between subject and background
- **Fix**: Try specifying the type explicitly:
  ```bash
  -F "type=person"   # for photos of people
  -F "type=product"  # for product photos
  -F "type=car"      # for vehicle photos
  ```

#### curl returns empty file or error JSON
- **Cause**: API returned an error in JSON format instead of an image
- **Diagnose**: Check if output is JSON:
  ```bash
  file ~/prj/art-skill/outputs/[name]-nobg.png
  # If it says "ASCII text" or "JSON", it's an error response
  cat ~/prj/art-skill/outputs/[name]-nobg.png
  ```

#### Rate limiting (429)
- **Cause**: Too many requests in a short period
- **Fix**: Add a delay between batch requests:
  ```bash
  sleep 2  # Add between curl calls in batch loops
  ```

### Checking API Credit Balance

```bash
export $(grep REMOVEBG_API_KEY ~/.claude/.env | xargs)

curl -s \
  -H "X-Api-Key: ${REMOVEBG_API_KEY}" \
  https://api.remove.bg/v1.0/account | python3 -m json.tool
```

This returns account details including remaining credits.

---

## Output Naming Convention

Follow this naming pattern for consistency:

| Scenario             | Input Name       | Output Name              |
|----------------------|------------------|--------------------------|
| Basic removal        | `photo.png`      | `photo-nobg.png`         |
| With brand bg        | `photo.png`      | `photo-branded.png`      |
| Batch item           | `item-03.jpg`    | `item-03-nobg.png`       |
| For compositing      | `subject.png`    | `subject-nobg.png`       |

All outputs go to `~/prj/art-skill/outputs/` unless otherwise specified.

---

## Quick Reference

```bash
# Load key
export $(grep REMOVEBG_API_KEY ~/.claude/.env | xargs)

# Basic removal (most common)
curl -s -H "X-Api-Key: ${REMOVEBG_API_KEY}" \
  -F "image_file=@INPUT.png" -F "size=auto" -F "format=png" \
  -o ~/prj/art-skill/outputs/OUTPUT-nobg.png \
  https://api.remove.bg/v1.0/removebg

# With brand background
curl -s -H "X-Api-Key: ${REMOVEBG_API_KEY}" \
  -F "image_file=@INPUT.png" -F "size=auto" -F "format=png" \
  -F "bg_color=#F6F3EB" \
  -o ~/prj/art-skill/outputs/OUTPUT-branded.png \
  https://api.remove.bg/v1.0/removebg

# Verify transparency
sips --getProperty hasAlpha ~/prj/art-skill/outputs/OUTPUT-nobg.png

# Check credits
curl -s -H "X-Api-Key: ${REMOVEBG_API_KEY}" \
  https://api.remove.bg/v1.0/account | python3 -m json.tool
```

No voice notifications for any of these operations.
