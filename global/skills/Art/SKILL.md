---
name: Art
description: Generate illustrations, technical diagrams, mermaid flowcharts, infographics, header images, thumbnails, comics, and visual content. USE THIS SKILL whenever the user mentions art, header images, visualizations, mermaid, flowchart, technical diagram, infographic, YouTube thumbnails, annotated screenshots, aphorisms, comics, comparisons, D3 dashboards, essay illustration, frameworks, maps, recipe cards, remove background, stats, taxonomies, timelines, visualize, generate image, compose thumbnail, generate prompt, blog header, editorial illustration, charcoal sketch, conceptual map, quote card, stat card, process recipe, classification grid, or any visual content creation task.
---

# Art Skill

Complete visual content system for creating illustrations, diagrams, and visual content.

## Brand Identity

All visuals use this color palette and typography:

### Color Palette

| Role | Color | Hex |
|------|-------|-----|
| **Background** | Warm Cream | `#F6F3EB` |
| **Main Accent** | Coral/Orange | `#D67056` |
| **Secondary** | Tan/Sand | `#E6CCAB` |
| **Teal** | Teal | `#70B8AD` |
| **Text** | Dark Charcoal | `#222222` |
| **Muted Blue** | Muted Blue | `#5D95C6` |
| **Dark Grey Blue** | Dark Grey Blue | `#2C313A` |
| **Mustard Yellow** | Mustard Yellow | `#EAB64D` |

### Typography

**Font:** JetBrainsMono Nerd Font — monospace, technical, clean.

Use JetBrainsMono for all text in generated images where possible. When instructing image generation models, describe it as: "clean monospace technical font like JetBrains Mono".

---

## Output Location

```
ALL GENERATED IMAGES GO TO: ~/prj/art-skill/outputs/
```

Never output directly to project directories. User previews in Finder/Preview before use.

---

## Workflow Routing

Route to the appropriate workflow based on the request:

| Request Type | Workflow |
|-------------|----------|
| Remove background from image | `Workflows/RemoveBackground.md` |
| YouTube thumbnail checklist | `Workflows/YouTubeThumbnailChecklist.md` |
| Blog header or editorial illustration | `Workflows/Essay.md` |
| D3.js interactive chart or dashboard | `Workflows/D3Dashboards.md` |
| Visualization or unsure which format | `Workflows/Visualize.md` |
| Mermaid flowchart or sequence diagram | `Workflows/Mermaid.md` |
| Technical or architecture diagram | `Workflows/TechnicalDiagrams.md` |
| Taxonomy or classification grid | `Workflows/Taxonomies.md` |
| Timeline or chronological progression | `Workflows/Timelines.md` |
| Framework or 2x2 matrix | `Workflows/Frameworks.md` |
| Comparison or X vs Y | `Workflows/Comparisons.md` |
| Annotated screenshot | `Workflows/AnnotatedScreenshots.md` |
| Recipe card or step-by-step | `Workflows/RecipeCards.md` |
| Aphorism or quote card | `Workflows/Aphorisms.md` |
| Conceptual map or territory | `Workflows/Maps.md` |
| Stat card or big number visual | `Workflows/Stats.md` |
| Comic or sequential panels | `Workflows/Comics.md` |

---

## Image Generation

### Available Models

| Model | CLI Flag | Backend | Best For | Cost |
|-------|----------|---------|----------|------|
| **Gemini Flash** (default) | `--model gemini-flash` | Gemini 2.0 Flash | Fast drafts, iteration, free tier | Free / very cheap |
| **Imagen 4 Ultra** | `--model gemini-pro` | Imagen 4 Ultra | Highest quality Google model | ~$0.06/image |
| **GPT Image 1.5** | `--model gpt-image-1` | OpenAI GPT-image-1.5 | Best text rendering, latest OpenAI | ~$0.03-$0.20/image |

**How to choose:**
- Start with `gemini-flash` (free, fast) for drafts and iteration
- Use `gemini-pro` for final production images (highest quality)
- Use `gpt-image-1` when you need excellent text/typography in the image

### Model-Specific Size Requirements

| Model | `--size` format | Valid values | Default |
|-------|----------------|--------------|---------|
| `gemini-flash` | Resolution tier | `1K`, `2K`, `4K` | `2K` |
| `gemini-pro` | Resolution tier | `1K`, `2K`, `4K` | `2K` |
| `gpt-image-1` | Pixel dimensions | `1024x1024`, `1536x1024`, `1024x1536` | `1024x1024` |

For Gemini models, use `--aspect-ratio` separately (defaults to `16:9`).

---

## Configuration

### API Keys (`~/.claude/.env`)

```bash
# Required: at least one of these
GOOGLE_API_KEY=your-key      # For gemini-flash and gemini-pro
OPENAI_API_KEY=your-key      # For gpt-image-1

# Optional
REMOVEBG_API_KEY=your-key    # For --remove-bg background removal
```

### Output Directory

Default: `~/prj/art-skill/outputs/`. Override per-image with `--output /path/to/file.png`.

### Default Model

The CLI defaults to `gemini-flash`. To use a different model, pass `--model` on each call. The workflows will select the best model for each task type automatically.

### Generation Command

```bash
bun run "$ART_SKILL_DIR/Tools/Generate.ts" \
  --model gemini-pro \
  --prompt "[PROMPT]" \
  --size 2K \
  --aspect-ratio 1:1 \
  --output ~/prj/art-skill/outputs/image-name.png
```

> **Note:** `$ART_SKILL_DIR` is provided in your prompt context. If not set, the Art skill directory is at the project-level `.claude/skills/Art/` relative to the project root.

### Multiple Reference Images (Gemini Only)

```bash
bun run "$ART_SKILL_DIR/Tools/Generate.ts" \
  --model gemini-pro \
  --prompt "..." \
  --reference-image ref1.jpg \
  --reference-image ref2.jpg \
  --size 2K \
  --aspect-ratio 16:9 \
  --output ~/prj/art-skill/outputs/styled-image.png
```

### Post-Processing Flags

| Flag | Effect |
|------|--------|
| `--remove-bg` | Remove background (needs REMOVEBG_API_KEY) |
| `--thumbnail` | Generate transparent + thumbnail with `#F6F3EB` background |
| `--add-bg "#F6F3EB"` | Add brand background to transparent image |
| `--transparent` | Request transparent background from model |

**API keys in:** `~/.claude/.env` or shell environment variables.

---

## Content Analysis (Deep Understanding)

Before generating editorial illustrations (Essay workflow), perform a **24-point narrative analysis** of the content. This replaces the need for external CSE skills.

### How to Run Content Analysis

Read the content thoroughly and produce a 24-item story explanation:

1. **Setup** (items 1-4): What's the context? Who's involved? What's the status quo?
2. **Tension** (items 5-10): What's the problem? What's at stake? What's changing?
3. **Development** (items 11-18): How does the argument build? What evidence? What examples?
4. **Resolution** (items 19-22): What's the conclusion? What should change?
5. **Significance** (items 23-24): Why does this matter? What's the "wow" factor?

This analysis reveals:
- The complete narrative arc
- Key metaphors and imagery
- The emotional journey
- What the piece is REALLY about
- The visual story to tell

---

## Examples

**Example 1: Blog header image**
```
User: "create a header for my RAG architecture post"
-> Invokes ESSAY workflow
-> Runs 24-point content analysis
-> Generates charcoal sketch with brand colors
-> Saves to ~/prj/art-skill/outputs/
```

**Example 2: Technical architecture diagram**
```
User: "make a diagram showing the RAG pipeline"
-> Invokes TECHNICALDIAGRAMS workflow
-> Creates structured architecture visual
-> Outputs PNG with brand styling
```

**Example 3: Comparison visualization**
```
User: "visualize naive RAG vs advanced RAG"
-> Invokes COMPARISONS workflow
-> Creates side-by-side visual
-> Brand colors with labeled elements
```
