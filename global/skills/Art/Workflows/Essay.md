# Essay — Blog Header / Editorial Illustration Workflow

> Charcoal architectural sketch technique applied to content-relevant subjects.
> Every image blends hand-drawn warmth with structured editorial clarity.

---

## Brand Identity

| Token | Hex | Role |
|---|---|---|
| Warm Cream | `#F6F3EB` | Background / negative space |
| Coral/Orange | `#D67056` | Warm/human elements, emphasis, protagonist energy |
| Tan/Sand | `#E6CCAB` | Secondary wash, soft transitions |
| Teal | `#70B8AD` | Tech/cold elements, structural lines, contrast accent |
| Dark Charcoal | `#222222` | Text, primary sketch lines, shadows |
| Muted Blue | `#5D95C6` | Subtle depth, atmospheric perspective |
| Dark Grey Blue | `#2C313A` | Deep shadows, dramatic contrast areas |
| Mustard Yellow | `#EAB64D` | Highlight sparks, attention markers |

**Font:** Clean monospace technical font like JetBrains Mono (JetBrainsMono Nerd Font)

---

## Overview

This workflow produces editorial illustrations for blog posts and essays. The technique is **charcoal architectural sketch** — loose, gestural charcoal strokes forming the structure, with brand-color washes and accents layered on top. Every image must contain both **Coral (#D67056)** and **Teal (#70B8AD)** elements.

The workflow is fully self-contained. No external skills or APIs are required beyond the image generation tool.

---

## 8 Mandatory Steps

### Step 1: UNDERSTAND

**Goal:** Parse the essay/article to extract its core thesis, audience, and tone.

1. Read the full essay text (or URL content).
2. Identify:
   - **Core thesis** — one sentence summarizing the argument
   - **Target audience** — who reads this (developers, designers, managers, general)
   - **Emotional register** — serious, playful, urgent, reflective, provocative
   - **Key metaphors** — any visual language already present in the text
   - **Content domain** — technology, culture, business, philosophy, etc.
3. Write a brief (3-5 sentence) creative brief capturing the above.

**Output:** A creative brief document stored in working memory.

---

### Step 2: CONTENT ANALYSIS (24-Point Narrative Beat Extraction)

**Goal:** Decompose the essay into 24 narrative beats across 5 arc segments.

This is a built-in analysis step — no external Content Structure Engine or skill is needed. Perform the analysis inline.

#### Arc Segments

| Segment | Beats | Purpose |
|---|---|---|
| **Setup** | 1–5 | Establish the world, introduce the problem |
| **Tension** | 6–10 | Raise stakes, present conflict or contradiction |
| **Development** | 11–16 | Explore solutions, build argument, provide evidence |
| **Resolution** | 17–21 | Arrive at insight, propose answer, synthesize |
| **Significance** | 22–24 | Why it matters, call to action, lasting impression |

#### How to Extract Beats

For each beat, produce:
```
Beat [N]: [One-line summary]
  Visual potential: [What could this look like as a sketch?]
  Emotion: [What feeling does this evoke?]
  Color affinity: Coral / Teal / Both
```

Read through the essay paragraph by paragraph. Map each major idea shift to a beat. If the essay has fewer than 24 distinct ideas, subdivide the most complex sections. If it has more, merge the least visually distinctive beats.

#### Select the Hero Beat

From the 24 beats, select **one hero beat** that:
- Has the strongest visual potential
- Captures the emotional core of the essay
- Can be rendered as a single compelling charcoal sketch
- Benefits from both Coral (human/warm) and Teal (tech/structural) elements

**Output:** 24-beat breakdown + selected hero beat with rationale.

---

### Step 3: EMOTION

**Goal:** Define the emotional palette that will guide color intensity, stroke weight, and composition energy.

Map the hero beat's emotion to visual parameters:

| Emotion | Charcoal Weight | Color Wash Intensity | Composition Energy |
|---|---|---|---|
| Urgent / Alarming | Heavy, dark strokes | High saturation washes | Diagonal, asymmetric |
| Reflective / Calm | Light, feathered strokes | Pale, translucent washes | Centered, balanced |
| Playful / Creative | Varied, gestural strokes | Bright, layered washes | Dynamic, scattered |
| Technical / Precise | Clean, architectural strokes | Controlled, geometric washes | Grid-aligned, ordered |
| Provocative / Bold | Aggressive, overlapping strokes | Contrasting, saturated washes | Off-center, cropped |

Define:
1. **Primary emotion** — the dominant feeling
2. **Charcoal technique** — stroke style (loose gestural, tight architectural, crosshatch, etc.)
3. **Wash approach** — how Coral and Teal washes are applied (splatter, gradient, geometric overlay)
4. **Energy level** — 1 (meditative) to 10 (explosive)

**Output:** Emotion brief with visual parameter selections.

---

### Step 4: COMPOSITION

**Goal:** Design the spatial layout of the illustration.

Choose a composition framework:

| Framework | Best For | Structure |
|---|---|---|
| **Central Subject** | Portrait, single concept | Subject centered, washes radiating outward |
| **Split Horizon** | Contrast, before/after | Horizontal division, Coral above/Teal below (or inverse) |
| **Architectural Perspective** | Systems, processes | Vanishing point, structural lines in charcoal |
| **Scattered Elements** | Complex ideas, ecosystems | Multiple small sketches with connecting wash lines |
| **Close-Up Detail** | Intimate, technical | Zoomed-in subject, heavy charcoal detail |
| **Panoramic** | Scale, journey, timeline | Wide aspect, horizontal movement |

Define:
1. **Framework selection** with rationale
2. **Subject placement** — rule of thirds, golden ratio, or centered
3. **Coral zone** — where warm/human elements live in the composition
4. **Teal zone** — where tech/structural elements live
5. **Negative space** — areas of Warm Cream (#F6F3EB) breathing room
6. **Aspect ratio** — typically `16:9` for blog headers, `4:3` for editorial

**Output:** Composition plan with spatial mapping of color zones.

---

### Step 5: PROMPT

**Goal:** Craft the image generation prompt using all analysis from Steps 1–4.

#### Prompt Template

```
[COMPOSITION FRAMEWORK] charcoal architectural sketch on warm cream (#F6F3EB) paper background.

Subject: [HERO BEAT VISUAL DESCRIPTION]

Technique: [CHARCOAL TECHNIQUE from Step 3] charcoal strokes forming the primary structure.
Coral/orange (#D67056) watercolor wash applied to [CORAL ZONE DESCRIPTION — warm, human, emotional elements].
Teal (#70B8AD) watercolor wash applied to [TEAL ZONE DESCRIPTION — technical, structural, cold elements].

Additional accents: tan/sand (#E6CCAB) soft transitions between zones, dark charcoal (#222222) line work for definition, hints of mustard yellow (#EAB64D) at focal points.

Mood: [PRIMARY EMOTION], [ENERGY LEVEL description].
Style: Editorial illustration, sophisticated, hand-drawn with selective color. Clean monospace technical font like JetBrains Mono for any text elements.

Negative space preserved in warm cream areas. No photorealistic rendering — maintain the sketch quality throughout.
Both coral and teal must be visibly present in the final image.
```

#### Prompt Refinement Rules

1. Keep the prompt under 500 words
2. Lead with composition, then subject, then technique
3. Always explicitly name both Coral and Teal with hex values
4. Specify what NOT to include (photorealism, 3D rendering, cartoon style)
5. End with the dual-color mandate

**Output:** Final generation prompt, ready for the tool.

---

### Step 6: GENERATE

**Goal:** Produce the illustration using the image generation tool.

#### Standard Generation

```bash
bun run ~/.claude/skills/Art/Tools/Generate.ts \
  --model gemini-pro \
  --prompt "[FINAL PROMPT FROM STEP 5]" \
  --size 2K \
  --aspect-ratio 16:9 \
  --output ~/prj/art-skill/outputs/essay-header.png
```

#### With --thumbnail Flag

When `--thumbnail` is specified, generate TWO versions:

**Version 1: Transparent background (for flexible compositing)**
```bash
bun run ~/.claude/skills/Art/Tools/Generate.ts \
  --model gemini-pro \
  --prompt "[PROMPT] with transparent background, subject only, no background fill" \
  --size 2K \
  --aspect-ratio 16:9 \
  --output ~/prj/art-skill/outputs/essay-header-transparent.png
```

**Version 2: Branded background**
```bash
bun run ~/.claude/skills/Art/Tools/Generate.ts \
  --model gemini-pro \
  --prompt "[PROMPT] on solid warm cream (#F6F3EB) background" \
  --size 2K \
  --aspect-ratio 16:9 \
  --output ~/prj/art-skill/outputs/essay-header-branded.png
```

#### Model Selection Guide

| Model | When to Use |
|---|---|
| `gemini-pro` | Default. Best quality for editorial illustrations |
| `gemini-flash` | Quick drafts, iteration, testing composition ideas |
| `gpt-image-1` | Alternative style, different interpretation of the prompt |

**Output:** Generated PNG file(s) in `~/prj/art-skill/outputs/`.

---

### Step 7: OPTIMIZE

**Goal:** Resize, convert, and create optimized versions for web delivery.

#### 7a. Resize to 1024px Width

```bash
# Resize main image to 1024px wide, maintaining aspect ratio
sips --resampleWidth 1024 ~/prj/art-skill/outputs/essay-header.png --out ~/prj/art-skill/outputs/essay-header-1024.png
```

#### 7b. Convert to WebP

```bash
# Convert to WebP for optimal web delivery
cwebp -q 85 ~/prj/art-skill/outputs/essay-header-1024.png -o ~/prj/art-skill/outputs/essay-header-1024.webp
```

If `cwebp` is not available, use `sips`:
```bash
sips -s format png ~/prj/art-skill/outputs/essay-header-1024.png --out ~/prj/art-skill/outputs/essay-header-1024.webp
```

Or use ImageMagick if installed:
```bash
convert ~/prj/art-skill/outputs/essay-header-1024.png -quality 85 ~/prj/art-skill/outputs/essay-header-1024.webp
```

#### 7c. Create Optimized Thumbnails

```bash
# Small thumbnail (400px) for cards/previews
sips --resampleWidth 400 ~/prj/art-skill/outputs/essay-header.png --out ~/prj/art-skill/outputs/essay-header-thumb-400.png
cwebp -q 80 ~/prj/art-skill/outputs/essay-header-thumb-400.png -o ~/prj/art-skill/outputs/essay-header-thumb-400.webp

# Medium thumbnail (600px) for grids
sips --resampleWidth 600 ~/prj/art-skill/outputs/essay-header.png --out ~/prj/art-skill/outputs/essay-header-thumb-600.png
cwebp -q 82 ~/prj/art-skill/outputs/essay-header-thumb-600.png -o ~/prj/art-skill/outputs/essay-header-thumb-600.webp
```

#### 7d. If --thumbnail Flag Was Used

Also optimize the transparent and branded versions:
```bash
# Optimize transparent version
sips --resampleWidth 1024 ~/prj/art-skill/outputs/essay-header-transparent.png --out ~/prj/art-skill/outputs/essay-header-transparent-1024.png

# Optimize branded version
sips --resampleWidth 1024 ~/prj/art-skill/outputs/essay-header-branded.png --out ~/prj/art-skill/outputs/essay-header-branded-1024.png
cwebp -q 85 ~/prj/art-skill/outputs/essay-header-branded-1024.png -o ~/prj/art-skill/outputs/essay-header-branded-1024.webp
```

**Output:** Optimized files in multiple sizes and formats.

---

### Step 8: VALIDATE

**Goal:** Run the full validation checklist to ensure the output meets all brand and quality standards.

#### Validation Checklist

**Brand Compliance:**
- [ ] Background uses or evokes Warm Cream (#F6F3EB)
- [ ] Coral/Orange (#D67056) is visibly present in the image
- [ ] Teal (#70B8AD) is visibly present in the image
- [ ] Coral is used for warm/human/emotional elements
- [ ] Teal is used for tech/structural/cold elements
- [ ] Dark Charcoal (#222222) used for primary line work
- [ ] Any text uses clean monospace technical font styling

**Technique Compliance:**
- [ ] Image reads as charcoal sketch, not photorealistic or digital
- [ ] Watercolor wash effect is visible (not flat color fills)
- [ ] Negative space / warm cream breathing room is preserved
- [ ] Stroke variation is present (not uniform line weight)

**Content Compliance:**
- [ ] Hero beat from the essay is recognizable in the image
- [ ] Emotional register matches the essay tone
- [ ] Image would make sense as a blog header for this specific essay
- [ ] No misleading visual metaphors

**Technical Compliance:**
- [ ] Full-size image generated at 2K resolution
- [ ] 1024px resized version created
- [ ] WebP conversion completed
- [ ] Thumbnail(s) created (400px and/or 600px)
- [ ] If --thumbnail: transparent version exists
- [ ] If --thumbnail: branded background version exists
- [ ] All files saved to `~/prj/art-skill/outputs/`

**Composition Compliance:**
- [ ] Chosen composition framework is executed correctly
- [ ] Subject placement follows the defined spatial plan
- [ ] Coral and Teal zones are spatially separated as planned
- [ ] Aspect ratio matches specification (16:9 or 4:3)

#### Failure Protocol

If any checklist item fails:
1. Identify the specific failure
2. Determine which step (1–7) produced the error
3. Re-execute from that step with corrected parameters
4. Re-validate

**Output:** Completed checklist with pass/fail for each item, plus final file manifest.

---

## Quick Reference

### Minimal Invocation
```
Generate a blog header for this essay: [PASTE ESSAY TEXT OR URL]
```

### Full Invocation
```
Generate a blog header for this essay with --thumbnail flag:
[PASTE ESSAY TEXT OR URL]

Preferred composition: [FRAMEWORK]
Preferred emotion: [EMOTION]
Aspect ratio: 16:9
```

### Output Files Manifest

| File | Purpose |
|---|---|
| `essay-header.png` | Full-size original (2K) |
| `essay-header-1024.png` | Web-ready resized |
| `essay-header-1024.webp` | Optimized web delivery |
| `essay-header-thumb-400.webp` | Small thumbnail |
| `essay-header-thumb-600.webp` | Medium thumbnail |
| `essay-header-transparent.png` | Transparent BG (if --thumbnail) |
| `essay-header-branded.png` | Branded BG (if --thumbnail) |

---

## Examples

### Example 1: Technical Essay on Microservices

**Creative Brief:** Essay argues microservices create more problems than they solve. Audience: senior developers. Tone: provocative. Metaphor: "distributed monolith" as tangled architecture.

**Hero Beat (Beat 8 — Tension):** The moment the reader realizes their "clean" microservice architecture is actually a distributed monolith — tangled service lines replacing tangled code.

**Prompt:**
```
Architectural perspective charcoal sketch on warm cream (#F6F3EB) paper background.

Subject: A grand architectural blueprint dissolving into tangled threads. Clean building columns on the left fragment into chaotic interconnected lines on the right. Small human figures stand bewildered at the transition point.

Technique: Tight architectural charcoal strokes on the left becoming loose, frantic gestural strokes on the right.
Coral/orange (#D67056) watercolor wash on the human figures and the ordered architectural section — warmth of intention.
Teal (#70B8AD) watercolor wash on the tangled thread section — cold complexity of the system.

Additional accents: tan/sand (#E6CCAB) transition zone between order and chaos, dark charcoal (#222222) structural lines, hints of mustard yellow (#EAB64D) on the bewildered figures' faces.

Mood: Provocative, energy level 7/10.
Style: Editorial illustration, sophisticated, hand-drawn with selective color. No photorealistic rendering.
Both coral and teal must be visibly present.
```

### Example 2: Reflective Essay on Learning to Code

**Hero Beat (Beat 19 — Resolution):** The quiet satisfaction of finally understanding recursion — a mirror reflecting a mirror, each reflection slightly different.

**Prompt:**
```
Central subject charcoal sketch on warm cream (#F6F3EB) paper background.

Subject: A person sitting at a desk, reflected in a series of mirrors that recede into infinity. Each reflection shows the person at a different stage — confused, struggling, then smiling. The mirrors form a gentle spiral.

Technique: Light, feathered charcoal strokes. Delicate crosshatching for the mirror frames.
Coral/orange (#D67056) watercolor wash on the person and their closest reflections — human warmth of the learning journey.
Teal (#70B8AD) watercolor wash on the deeper reflections and the spiral structure — the elegant logic of recursion.

Additional accents: tan/sand (#E6CCAB) soft glow around each mirror frame, dark charcoal (#222222) for the figure outlines, muted blue (#5D95C6) atmospheric depth in the furthest reflections.

Mood: Reflective, calm. Energy level 3/10.
Style: Editorial illustration, contemplative, hand-drawn. Clean monospace font for any visible code snippets.
Both coral and teal must be visibly present.
```
