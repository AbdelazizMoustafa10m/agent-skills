# YouTube Thumbnail Checklist - Thumbnail Creation Workflow

## Purpose

Create YouTube-optimized thumbnails using the **ComposeThumbnail** tool (ImageMagick
based). This workflow handles dynamic headshot positioning, text overlays with brand
colors, border styling, and ensures thumbnails meet YouTube best practices.

---

## When to Use

- The user asks for a **YouTube thumbnail**, **video cover**, or **click-worthy image**.
- Any 1280x720 composition with text overlay and optional headshot.
- Requests mentioning "thumbnail" in the context of video content.

---

## Canvas Specification

| Property       | Value            |
|----------------|------------------|
| Width          | 1280 px          |
| Height         | 720 px           |
| Aspect Ratio   | 16:9             |
| Border         | 8 px solid Coral `#D67056` (all sides) |
| Background     | `#F6F3EB` (Warm Cream) or generated art |
| Format         | PNG               |

---

## Brand Palette Reference

| Token            | Hex       | Usage                                       |
|------------------|-----------|---------------------------------------------|
| Background       | `#F6F3EB` | Canvas base / safe fallback                 |
| Coral (accent)   | `#D67056` | Border, primary text, key emphasis          |
| Teal             | `#70B8AD` | Subtitle text, secondary accents            |
| Tan / Sand       | `#E6CCAB` | Text background overlays, soft accents      |
| Mustard Yellow   | `#EAB64D` | Highlight words, badges, "NEW" tags         |
| Muted Blue       | `#5D95C6` | Alternative subtitle color, tech topics     |
| Dark Grey Blue   | `#2C313A` | Text shadow, dark overlays, contrast panels |
| Text             | `#222222` | Body text on light backgrounds              |

**Font:** JetBrainsMono Nerd Font.

---

## Title and Subtitle Color Options

### Title (Large Text) Options

| Option             | Color     | Best For                              |
|--------------------|-----------|---------------------------------------|
| **Default**        | `#FFFFFF` | On dark/busy backgrounds              |
| **Coral Bold**     | `#D67056` | On light/cream backgrounds            |
| **Dark Charcoal**  | `#222222` | On light backgrounds, high contrast   |
| **Mustard Pop**    | `#EAB64D` | Attention-grabbing, highlight words   |

### Subtitle (Smaller Text) Options

| Option             | Color     | Best For                              |
|--------------------|-----------|---------------------------------------|
| **Teal**           | `#70B8AD` | Default subtitle, good contrast       |
| **Muted Blue**     | `#5D95C6` | Tech/dev topics, calm tone            |
| **Sand**           | `#E6CCAB` | Subtle subtitle on dark backgrounds   |
| **White**          | `#FFFFFF` | On dark overlays                      |
| **Dark Charcoal**  | `#222222` | On light backgrounds                  |

### Text Shadow / Outline

All text should include a shadow or outline for readability:
- **On light backgrounds:** `#2C313A` drop shadow, 2 px offset, 4 px blur.
- **On dark backgrounds:** `#000000` drop shadow, 2 px offset, 4 px blur.
- **Alternative:** 3 px `#2C313A` text stroke/outline for maximum contrast.

---

## Headshot Positioning

Dynamic headshot placement with three primary positions:

### Left Position
- Headshot anchored to left edge.
- X offset: 40 px from left.
- Y offset: centered vertically or bottom-aligned.
- Text content: right 60% of canvas.
- Best for: reading left-to-right narrative.

### Center Position
- Headshot centered horizontally.
- Y offset: bottom-aligned (head at ~40% from top).
- Text content: top portion of canvas.
- Best for: "talking head" style, personal brand focus.

### Right Position
- Headshot anchored to right edge.
- X offset: 40 px from right.
- Y offset: centered vertically or bottom-aligned.
- Text content: left 60% of canvas.
- Best for: text-first layouts, the user reads title then sees face.

### Headshot Specifications
- Format: PNG with transparent background (preferred).
- Minimum resolution: 400x400 px.
- Cutout style: waist-up or shoulders-up.
- Optional border: 4 px `#D67056` Coral outline around the cutout.

---

## Layout Templates

### Template A: Title Left, Headshot Right

```
+--[8px Coral Border]------------------------------------------+
|                                                               |
|   [TITLE - 2 lines max]              [HEADSHOT - right side] |
|   72px Bold, White/#D67056                                    |
|                                                               |
|   [SUBTITLE - 1 line]                                        |
|   36px, Teal #70B8AD                                          |
|                                                               |
|                              [Optional badge: Mustard #EAB64D]|
+---------------------------------------------------------------+
```

### Template B: Headshot Left, Title Right

```
+--[8px Coral Border]------------------------------------------+
|                                                               |
|   [HEADSHOT - left side]        [TITLE - 2 lines max]        |
|                                 72px Bold, White/#D67056      |
|                                                               |
|                                 [SUBTITLE - 1 line]           |
|                                 36px, Teal #70B8AD            |
|                                                               |
+---------------------------------------------------------------+
```

### Template C: Centered Headshot, Top Title

```
+--[8px Coral Border]------------------------------------------+
|                                                               |
|            [TITLE - centered, 1-2 lines]                      |
|            72px Bold, White/#D67056                            |
|                                                               |
|            [SUBTITLE - centered]                              |
|            36px, Teal #70B8AD                                  |
|                                                               |
|              [HEADSHOT - centered, bottom-aligned]             |
+---------------------------------------------------------------+
```

### Template D: Text Only (No Headshot)

```
+--[8px Coral Border]------------------------------------------+
|                                                               |
|            [TITLE - centered, 1-3 lines]                      |
|            84px Bold, White/#D67056                            |
|                                                               |
|            [SUBTITLE - centered]                              |
|            42px, Teal #70B8AD                                  |
|                                                               |
|    [Optional icon/emoji centered below]                       |
+---------------------------------------------------------------+
```

---

## Typography Specification

| Element      | Size    | Weight | Font                      | Max Lines |
|--------------|---------|--------|---------------------------|-----------|
| Title        | 72 px   | Bold   | JetBrainsMono Nerd Font   | 2         |
| Subtitle     | 36 px   | Medium | JetBrainsMono Nerd Font   | 1         |
| Badge        | 24 px   | Bold   | JetBrainsMono Nerd Font   | 1         |
| Watermark    | 16 px   | Light  | JetBrainsMono Nerd Font   | 1         |

### Title Rules
- Maximum 5-7 words (shorter is better for thumbnails).
- ALL CAPS or Title Case (user preference, default ALL CAPS).
- Line break at natural phrase boundary.
- Leading: 1.1x font size.

### Subtitle Rules
- Maximum 3-5 words.
- Sentence case.
- Provides context the title cannot.

---

## Background Options

### Option 1: Solid Brand Color
Use `#F6F3EB` warm cream or `#2C313A` dark grey blue as a flat background.

### Option 2: Generated Art Background
Use the art generation tool to create a background image first, then composite:

```bash
bun run ~/.claude/skills/Art/Tools/Generate.ts \
  --model gemini-pro \
  --prompt "[BACKGROUND PROMPT - abstract, blurred, relevant to topic]" \
  --size 2K \
  --aspect-ratio 16:9 \
  --output ~/prj/art-skill/outputs/thumb-bg-[slug].png
```

### Option 3: Gradient Background
Dark Grey Blue `#2C313A` to Coral `#D67056` diagonal gradient.

### Option 4: Split Background
Left half one color, right half another. Useful for comparison/VS thumbnails.

---

## ComposeThumbnail Tool Usage

The ComposeThumbnail tool uses ImageMagick to composite layers. After generating
any background art, build the final thumbnail:

### Layer Order (bottom to top)
1. Background (solid color, gradient, or generated art)
2. Optional dark overlay (for text readability)
3. Border (8 px Coral `#D67056`)
4. Headshot (if provided)
5. Title text
6. Subtitle text
7. Optional badge / tag
8. Optional watermark

### Key ImageMagick Operations
- **Border:** `-bordercolor '#D67056' -border 8`
- **Text shadow:** Use `-shadow` or draw text twice with offset.
- **Headshot composite:** `-geometry +X+Y -composite`
- **Text overlay:** `-font 'JetBrainsMono-Nerd-Font-Bold'` with `-annotate`

---

## Step-by-Step Workflow

1. **Gather requirements.** Ask the user:
   - Video title / topic?
   - Preferred title text (short, punchy)?
   - Subtitle text?
   - Headshot image path (or no headshot)?
   - Headshot position (left, center, right)?
   - Background preference (solid, art, gradient)?
   - Any specific color preferences from the palette?

2. **Choose a template** (A, B, C, or D) based on headshot availability
   and position preference.

3. **Select title/subtitle colors** from the options tables above.

4. **Generate background** if art background is chosen.

5. **Compose the thumbnail** using ImageMagick / ComposeThumbnail tool.

6. **Validate** against the checklist below.

7. **Iterate** based on user feedback.

---

## Generation Command (for art backgrounds)

```bash
bun run ~/.claude/skills/Art/Tools/Generate.ts \
  --model gemini-pro \
  --prompt "[BACKGROUND PROMPT]" \
  --size 2K \
  --aspect-ratio 16:9 \
  --output ~/prj/art-skill/outputs/thumb-bg-[slug].png
```

Final thumbnail output always goes to:
```
~/prj/art-skill/outputs/thumbnail-[slug].png
```

Available models: `gemini-flash`, `gemini-pro`, `gpt-image-1`.

---

## Examples

### Example 1 - Tech Tutorial Thumbnail

**Title:** "STOP USING CONSOLE.LOG"
**Subtitle:** "Debug like a pro"
**Headshot:** Right position
**Background:** Dark Grey Blue `#2C313A`
**Title Color:** Coral `#D67056`
**Subtitle Color:** Teal `#70B8AD`
**Border:** 8 px Coral `#D67056`

### Example 2 - Comparison Thumbnail

**Title:** "REACT vs SVELTE"
**Subtitle:** "2026 Edition"
**Headshot:** Center position
**Background:** Split - left `#5D95C6`, right `#D67056`
**Title Color:** White `#FFFFFF`
**Subtitle Color:** Mustard `#EAB64D`
**Border:** 8 px Coral `#D67056`

### Example 3 - News/Update Thumbnail

**Title:** "EVERYTHING NEW"
**Subtitle:** "Claude 5 Deep Dive"
**Headshot:** Left position
**Background:** Generated abstract art in brand colors
**Title Color:** White `#FFFFFF`
**Subtitle Color:** Sand `#E6CCAB`
**Badge:** "NEW" in Mustard `#EAB64D` rounded rectangle
**Border:** 8 px Coral `#D67056`

---

## Validation Checklist - YouTube Best Practices

Before delivering the thumbnail, verify every item:

### Technical Requirements
- [ ] **Canvas size** is exactly 1280 x 720 pixels.
- [ ] **Aspect ratio** is 16:9.
- [ ] **File format** is PNG.
- [ ] **File size** is under 2 MB.
- [ ] **Border** is 8 px solid Coral `#D67056` on all sides.

### Visual Quality
- [ ] **Title text** is readable at phone-screen size (imagine 160x90 px).
- [ ] **Title** is 7 words or fewer.
- [ ] **Subtitle** is 5 words or fewer.
- [ ] **Text has shadow/outline** for contrast against background.
- [ ] **Headshot** (if present) is properly positioned and not cropped awkwardly.
- [ ] **Headshot** does not overlap with text.
- [ ] **Colors** are from the brand palette only.
- [ ] **Font** is JetBrainsMono Nerd Font.

### YouTube-Specific
- [ ] **Bottom-right corner** is clear (YouTube places timestamp there).
- [ ] **No misleading** or clickbait elements the user did not request.
- [ ] **High contrast** between text and background.
- [ ] **Emotional trigger** - the thumbnail evokes curiosity, surprise, or value.
- [ ] **Consistent with brand** - follows the warm cream + coral + teal identity.

### Output
- [ ] **Output path** is `~/prj/art-skill/outputs/thumbnail-[slug].png`.
- [ ] **No voice notification** is triggered.

---

## Troubleshooting

| Issue                            | Fix                                            |
|----------------------------------|------------------------------------------------|
| Text unreadable at small size    | Increase font size, reduce word count          |
| Headshot overlaps text           | Adjust position offsets, resize headshot        |
| Background too busy for text     | Add semi-transparent dark overlay behind text   |
| Border not visible               | Ensure border is drawn AFTER all compositing    |
| Colors look off-brand            | Double-check hex values against palette table   |
| File too large                   | Compress PNG or reduce generated art resolution |
| Title wraps to 3+ lines         | Shorten title to 5 words max                   |

---

## Notes

- YouTube thumbnails are seen at extremely small sizes on mobile. Always
  preview the design mentally at 160x90 pixels.
- Faces in thumbnails increase click-through rate. Encourage headshot use.
- Bright colors (Coral, Mustard) perform better for CTR than muted tones.
- Keep the bottom-right 15% of the canvas relatively clear for the video
  duration overlay that YouTube adds.
- Always save outputs to `~/prj/art-skill/outputs/` with the `thumbnail-` prefix.
- The ComposeThumbnail tool handles the final ImageMagick compositing. Use the
  art generation tool only for background art when needed.
