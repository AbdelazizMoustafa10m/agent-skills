# Annotated Screenshots — Hand-Drawn Editorial Annotations Workflow

> Real screenshots enhanced with hand-drawn editorial annotations.
> The voice is direct and human — "look at this", not "please observe the following".

---

## Brand Identity

| Token | Hex | Role |
|---|---|---|
| Warm Cream | `#F6F3EB` | Annotation background panels, callout fills |
| Coral/Orange | `#D67056` | **Critical annotations** — errors, warnings, "fix this" |
| Tan/Sand | `#E6CCAB` | Soft highlights, subtle emphasis areas |
| Teal | `#70B8AD` | **Helpful annotations** — tips, good patterns, "nice" |
| Dark Charcoal | `#222222` | Primary annotation text, arrows, lines |
| Muted Blue | `#5D95C6` | Informational callouts, neutral annotations |
| Dark Grey Blue | `#2C313A` | Screenshot overlay dimming |
| Mustard Yellow | `#EAB64D` | Attention markers, exclamation emphasis |

**Font:** Clean monospace technical font like JetBrains Mono (JetBrainsMono Nerd Font)

---

## Overview

This workflow takes real screenshots and overlays hand-drawn editorial annotations in brand colors. The style is informal, opinionated, and human — think margin notes from a sharp colleague, not formal documentation callouts.

The annotation style mimics hand-drawn marks: slightly imperfect circles, arrows with character, wobbly underlines. This is deliberate — it signals "a human looked at this and had thoughts."

---

## Annotation Vocabulary

### Mark Types

| Mark | Drawn With | Purpose |
|---|---|---|
| **Circle** | Hand-drawn oval, 2-3px stroke | Highlight a specific element |
| **Arrow** | Curved line with arrowhead, slightly wobbly | Point at something, connect annotation to target |
| **Underline** | Wavy or straight underline | Emphasize text in the screenshot |
| **Cross-out** | X marks or strikethrough | "This is wrong" or "remove this" |
| **Bracket** | Curly brace or square bracket in margin | Group related elements |
| **Highlight** | Semi-transparent rectangle overlay | Draw attention to a region |
| **Checkmark** | Hand-drawn check | "This is correct" or "good" |
| **Exclamation** | Hand-drawn `!` or `!!` | Urgency, importance |
| **Question mark** | Hand-drawn `?` | Uncertainty, "is this right?" |
| **Numbering** | Circled numbers 1, 2, 3... | Sequential steps or priority order |

### Color Coding

| Color | Meaning | Use When |
|---|---|---|
| **Coral (#D67056)** | Critical | Errors, bugs, anti-patterns, "this is the issue" |
| **Teal (#70B8AD)** | Helpful | Good patterns, tips, "do more of this" |
| **Mustard (#EAB64D)** | Warning | Not broken but risky, "watch out" |
| **Muted Blue (#5D95C6)** | Informational | Neutral observations, context, "FYI" |
| **Dark Charcoal (#222222)** | Structural | Labels, step numbers, connecting lines |

---

## Workflow Steps

### Step 1: CAPTURE

**Goal:** Obtain the screenshot to annotate.

**Options:**
- User provides a screenshot file path
- User provides a URL to screenshot (use a screenshot tool)
- User provides an image already in `~/prj/art-skill/outputs/`

Verify the screenshot exists and is readable:
```bash
file ~/prj/art-skill/outputs/screenshot-source.png
sips -g pixelWidth -g pixelHeight ~/prj/art-skill/outputs/screenshot-source.png
```

If the screenshot needs cropping or resizing first:
```bash
# Crop to region of interest (x, y, width, height)
sips --cropToHeightWidth [HEIGHT] [WIDTH] ~/prj/art-skill/outputs/screenshot-source.png --out ~/prj/art-skill/outputs/screenshot-cropped.png
```

---

### Step 2: ANALYZE

**Goal:** Identify what needs annotation and determine the editorial voice.

Read the context from the user:
1. **What is the screenshot showing?** (UI, code, terminal, dashboard, error)
2. **What is the editorial intent?** (explain, critique, praise, compare, teach)
3. **Who is the audience?** (junior dev, team lead, blog reader, client)
4. **What specific elements need annotation?** (list them)

For each element to annotate, determine:
```
Element: [DESCRIPTION]
  Location: [WHERE in the screenshot — top-left, center, etc.]
  Mark type: [circle, arrow, underline, etc.]
  Color: [Coral/Teal/Mustard/Blue/Charcoal]
  Voice: [The annotation text — keep it editorial and direct]
```

#### Editorial Voice Guide

**DO write like this:**
- "this is the issue"
- "nope"
- "^ nice pattern here"
- "why is this hardcoded?"
- "this breaks on mobile"
- "chef's kiss"
- "TODO: fix before deploy"
- "see how clean this is?"

**DON'T write like this:**
- "Please note that this component has an issue"
- "The following element demonstrates an anti-pattern"
- "It should be observed that..."
- "One might consider..."

---

### Step 3: COMPOSE

**Goal:** Plan the annotation layout to avoid clutter and maintain readability.

#### Layout Rules

1. **Annotations live in margins when possible** — don't cover the screenshot content
2. **If the screenshot needs a wider canvas**, extend the background with Warm Cream (#F6F3EB) on one or both sides
3. **Arrows connect margin annotations to targets** — keep arrows clean and non-overlapping
4. **Maximum 7 annotations per screenshot** — if you need more, split into multiple annotated screenshots
5. **Number annotations in reading order** (top-to-bottom, left-to-right) when there are 3+
6. **Critical (Coral) annotations get visual priority** — larger text, bolder marks
7. **Dim non-annotated regions slightly** with a semi-transparent Dark Grey Blue (#2C313A) overlay at 15-20% opacity to focus attention

#### Canvas Extension

If annotations need more room:
```
Original screenshot: [WIDTH] x [HEIGHT]
Extended canvas: [WIDTH + MARGIN] x [HEIGHT + MARGIN]
Margin fill: Warm Cream (#F6F3EB)
Margin side: right (for most annotations) or bottom (for comparison annotations)
```

---

### Step 4: GENERATE ANNOTATIONS

**Goal:** Create the annotated image using image generation.

#### Prompt Template for Annotation Overlay

```
Editorial hand-drawn annotation overlay on a screenshot.

The screenshot shows [DESCRIPTION OF SCREENSHOT CONTENT].

Annotations to add (hand-drawn style, slightly imperfect, human-feel):

1. [MARK TYPE] in [COLOR NAME] ([HEX]) at [LOCATION]: "[ANNOTATION TEXT]"
2. [MARK TYPE] in [COLOR NAME] ([HEX]) at [LOCATION]: "[ANNOTATION TEXT]"
3. ...

Style: Hand-drawn marks with character — wobbly circles, curved arrows, natural handwriting feel. Text in clean monospace technical font like JetBrains Mono. Annotation background panels in warm cream (#F6F3EB) with subtle shadow.

Critical annotations use coral (#D67056). Helpful annotations use teal (#70B8AD). Warning annotations use mustard yellow (#EAB64D). Informational annotations use muted blue (#5D95C6). Structural elements use dark charcoal (#222222).

The annotations should feel like a sharp colleague reviewed this and scribbled their thoughts directly on the screenshot.
```

#### Generation Command

```bash
bun run ~/.claude/skills/Art/Tools/Generate.ts \
  --model gemini-pro \
  --prompt "[ANNOTATION PROMPT]" \
  --size 2K \
  --aspect-ratio 16:9 \
  --output ~/prj/art-skill/outputs/annotated-screenshot.png
```

For quick iterations during composition:
```bash
bun run ~/.claude/skills/Art/Tools/Generate.ts \
  --model gemini-flash \
  --prompt "[ANNOTATION PROMPT]" \
  --size 2K \
  --aspect-ratio 16:9 \
  --output ~/prj/art-skill/outputs/annotated-screenshot-draft.png
```

---

### Step 5: COMPOSITE WORKFLOW (Optional)

**Goal:** For complex annotations, layer the annotations programmatically over the real screenshot.

This approach is useful when:
- You need pixel-perfect placement of annotations on a real screenshot
- The screenshot content must remain unaltered
- You want to iterate on annotations without regenerating the base

#### Composite Approach

1. **Generate annotation layer only** (transparent background):
```bash
bun run ~/.claude/skills/Art/Tools/Generate.ts \
  --model gemini-pro \
  --prompt "Hand-drawn editorial annotations on transparent background: [ANNOTATION DESCRIPTIONS]. Coral (#D67056) for critical marks, teal (#70B8AD) for helpful marks. Wobbly circles, curved arrows, monospace text callouts. NO screenshot content — annotations only on transparent background." \
  --size 2K \
  --aspect-ratio 16:9 \
  --output ~/prj/art-skill/outputs/annotation-layer.png
```

2. **Composite using ImageMagick** (if available):
```bash
composite -gravity center \
  ~/prj/art-skill/outputs/annotation-layer.png \
  ~/prj/art-skill/outputs/screenshot-source.png \
  ~/prj/art-skill/outputs/annotated-composite.png
```

3. **Or composite using Python/Pillow:**
```python
from PIL import Image
base = Image.open("~/prj/art-skill/outputs/screenshot-source.png")
overlay = Image.open("~/prj/art-skill/outputs/annotation-layer.png").resize(base.size)
base.paste(overlay, (0, 0), overlay)
base.save("~/prj/art-skill/outputs/annotated-composite.png")
```

#### Multi-Screenshot Composite

For tutorials or step-by-step guides that need multiple annotated screenshots in a single image:

```bash
# Generate each annotated screenshot
bun run ~/.claude/skills/Art/Tools/Generate.ts \
  --model gemini-pro \
  --prompt "[STEP 1 ANNOTATED SCREENSHOT PROMPT]" \
  --size 2K \
  --aspect-ratio 4:3 \
  --output ~/prj/art-skill/outputs/step-1-annotated.png

bun run ~/.claude/skills/Art/Tools/Generate.ts \
  --model gemini-pro \
  --prompt "[STEP 2 ANNOTATED SCREENSHOT PROMPT]" \
  --size 2K \
  --aspect-ratio 4:3 \
  --output ~/prj/art-skill/outputs/step-2-annotated.png

# Stitch vertically with step numbers
# (use ImageMagick or similar)
convert ~/prj/art-skill/outputs/step-1-annotated.png \
        ~/prj/art-skill/outputs/step-2-annotated.png \
        -append ~/prj/art-skill/outputs/multi-step-annotated.png
```

---

### Step 6: OPTIMIZE

**Goal:** Prepare final files for web delivery.

```bash
# Resize to web-friendly width
sips --resampleWidth 1200 ~/prj/art-skill/outputs/annotated-screenshot.png \
  --out ~/prj/art-skill/outputs/annotated-screenshot-web.png

# Convert to WebP
cwebp -q 88 ~/prj/art-skill/outputs/annotated-screenshot-web.png \
  -o ~/prj/art-skill/outputs/annotated-screenshot-web.webp

# Create thumbnail for preview
sips --resampleWidth 480 ~/prj/art-skill/outputs/annotated-screenshot.png \
  --out ~/prj/art-skill/outputs/annotated-screenshot-thumb.png
```

Higher quality setting (88) because screenshots with text need more detail than illustrations.

---

### Step 7: VALIDATE

**Goal:** Verify the annotated screenshot meets all standards.

#### Validation Checklist

**Annotation Quality:**
- [ ] All identified elements have annotations
- [ ] No more than 7 annotations per image
- [ ] Annotations don't obscure critical screenshot content
- [ ] Editorial voice is direct and human, not formal
- [ ] Text is legible at the final output size

**Color Compliance:**
- [ ] Critical annotations use Coral (#D67056)
- [ ] Helpful annotations use Teal (#70B8AD)
- [ ] Warning annotations use Mustard Yellow (#EAB64D)
- [ ] Informational annotations use Muted Blue (#5D95C6)
- [ ] Extended canvas areas use Warm Cream (#F6F3EB)
- [ ] Text annotations use Dark Charcoal (#222222) or appropriate color

**Mark Style:**
- [ ] Marks look hand-drawn (not pixel-perfect geometric)
- [ ] Arrows are curved and have character
- [ ] Circles are slightly imperfect ovals
- [ ] Text uses monospace font styling
- [ ] Annotation panels have subtle shadows or borders

**Layout:**
- [ ] Annotations are numbered in reading order (if 3+)
- [ ] No overlapping annotations
- [ ] Margin space is used effectively
- [ ] Visual hierarchy: critical > warning > helpful > informational

**Technical:**
- [ ] Web-optimized version created (1200px width)
- [ ] WebP conversion completed
- [ ] Thumbnail created
- [ ] All files in `~/prj/art-skill/outputs/`
- [ ] Screenshot content is still readable beneath annotations

#### Failure Protocol

If annotations obscure content → extend canvas and recompose.
If color coding is wrong → regenerate with corrected color assignments.
If voice is too formal → rewrite annotations in editorial style and regenerate.

---

## Quick Reference

### Minimal Invocation
```
Annotate this screenshot: ~/prj/art-skill/outputs/my-screenshot.png
Points to annotate:
1. The login button is too small (critical)
2. Nice use of whitespace here (helpful)
```

### Full Invocation
```
Annotate this screenshot with editorial voice:
Source: ~/prj/art-skill/outputs/my-screenshot.png
Context: Code review of a React component
Audience: Junior developer

Annotations:
1. CRITICAL: The useEffect has no dependency array (line 15)
2. HELPFUL: Good extraction of this custom hook (line 8)
3. WARNING: This inline style should be a CSS class (line 22)
4. INFO: This pattern is called "render props" (line 30)

Use composite workflow for pixel-perfect placement.
```

---

## Examples

### Example 1: Code Review Screenshot

**Annotations:**
1. Coral circle around `useEffect(() => {...})` — "missing deps array!!"
2. Teal checkmark next to `const { data } = useQuery(...)` — "^ clean"
3. Mustard underline on `style={{color: 'red'}}` — "inline styles... really?"
4. Charcoal arrow from margin note to function signature — "rename this — `handleClick` tells me nothing"

### Example 2: UI Screenshot

**Annotations:**
1. Coral arrow pointing to tiny button — "this fails touch targets (44px min)"
2. Teal bracket around card layout — "great visual hierarchy"
3. Muted Blue circle on navigation — "consider breadcrumbs here"
4. Mustard highlight on contrast issue — "fails WCAG AA — check contrast"

### Example 3: Terminal Output

**Annotations:**
1. Coral cross-out on error line — "this is the root cause ←"
2. Teal highlight on successful build step — "this part works fine"
3. Charcoal numbered sequence — "read in this order: 3 → 1 → 2"
