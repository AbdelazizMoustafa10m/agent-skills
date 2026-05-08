# Visualize - General-Purpose Visualization Workflow

## Purpose

This is the **catch-all** visualization workflow. It handles any visual request
that does not clearly map to a specialized workflow. It also serves as the
**router** that can redirect to a more specific workflow when a match is found.

---

## When to Use

- The user asks to "visualize" something without specifying a format.
- The request does not clearly fit Taxonomies, TechnicalDiagrams, Timelines,
  or YouTubeThumbnailChecklist.
- Requests for infographics, comparison visuals, concept illustrations,
  abstract representations, data-driven graphics, or custom layouts.

---

## Decision Tree - Route or Create

Before generating anything, evaluate the request against specialized workflows:

```
User Request
    |
    |-- Contains "taxonomy", "classify", "grid", "periodic table", "matrix"?
    |       --> Route to Taxonomies.md
    |
    |-- Contains "architecture", "flow", "pipeline", "diagram", "system"?
    |       --> Route to TechnicalDiagrams.md
    |
    |-- Contains "timeline", "history", "chronolog", "roadmap", "milestones"?
    |       --> Route to Timelines.md
    |
    |-- Contains "thumbnail", "YouTube", "video cover"?
    |       --> Route to YouTubeThumbnailChecklist.md
    |
    |-- None of the above match?
            --> Continue with this workflow (general visualization)
```

**If routing to another workflow:** Tell the user which workflow is being used
and follow that workflow's instructions entirely.

---

## Brand Palette Reference

| Token            | Hex       | Usage                                |
|------------------|-----------|--------------------------------------|
| Background       | `#F6F3EB` | Canvas fill                          |
| Coral (accent)   | `#D67056` | Primary emphasis, key elements       |
| Teal             | `#70B8AD` | Secondary emphasis, supporting       |
| Tan / Sand       | `#E6CCAB` | Backgrounds, fills, borders          |
| Mustard Yellow   | `#EAB64D` | Highlights, callouts, warnings       |
| Muted Blue       | `#5D95C6` | Tertiary data, links, references     |
| Dark Grey Blue   | `#2C313A` | Borders, text emphasis, containers   |
| Text             | `#222222` | All body text                        |

**Font:** JetBrainsMono Nerd Font.

---

## Brand Color Application Rules

These rules apply to ALL visualizations regardless of type:

### Rule 1: Warm Cream Canvas
Every image starts with a `#F6F3EB` background. No exceptions. No grid dots.

### Rule 2: Maximum Two Accent Colors per Visual
Pick at most two from {Coral, Teal, Mustard, Muted Blue} as accent colors.
The rest of the palette serves as supporting neutrals.

### Rule 3: Coral is Always Primary
If only one accent is needed, use Coral `#D67056`. It is the brand's signature.

### Rule 4: Teal is Always Secondary
If a second accent is needed, use Teal `#70B8AD`.

### Rule 5: Strategic Color Use
Most of the visual should be neutral (cream, white, sand, dark grey blue).
Color draws the eye - use it only where attention is needed.

### Rule 6: Text Contrast
Body text is always `#222222` on light backgrounds. On Coral or Dark Grey Blue
fills, text switches to `#FFFFFF`.

### Rule 7: Hand-Drawn Aesthetic
Unless the user explicitly requests polished/corporate style, default to
Excalidraw-style hand-drawn lines and slightly imperfect shapes.

---

## Visualization Types (General)

### Comparison / Versus

Side-by-side or overlapping layout comparing two concepts.

- Left side: Coral `#D67056` accent.
- Right side: Teal `#70B8AD` accent.
- "VS" badge in center: Mustard `#EAB64D`.
- Shared attributes in the overlap zone: Sand `#E6CCAB`.

### Concept Map / Mind Map

Central concept radiating outward.

- Center node: Coral `#D67056` fill.
- Level 1 branches: Teal `#70B8AD` connector lines.
- Level 2+ branches: Sand `#E6CCAB` connector lines.
- Node fills: white/cream with `#2C313A` borders.

### Infographic / Stats Layout

Vertical scrolling layout with sections.

- Section dividers: Sand `#E6CCAB` horizontal lines.
- Key stat numbers: Coral `#D67056`, 64 px bold.
- Icons / illustrations: Teal `#70B8AD`.
- Section titles: 28 px bold, `#222222`.

### Venn Diagram

Two or three overlapping circles.

- Circle 1: Coral `#D67056` at 30% opacity.
- Circle 2: Teal `#70B8AD` at 30% opacity.
- Circle 3 (if needed): Mustard `#EAB64D` at 30% opacity.
- Overlap zones: natural color blending.
- Labels: 20 px, `#222222`.

### Quote / Text Visual

Stylized text on a visual background.

- Background: `#F6F3EB` with subtle texture.
- Quote text: 36 px bold, `#222222`.
- Attribution: 18 px, `#2C313A`.
- Decorative accent: Coral `#D67056` quotation marks or underline.
- Optional border: `#D67056` thin line.

### Abstract / Artistic

Conceptual visualization with artistic flair.

- Dominant color: Coral `#D67056`.
- Supporting: Teal `#70B8AD`.
- Background: `#F6F3EB`.
- Style: hand-drawn, watercolor-adjacent, sketch.
- Text overlay (if any): `#222222`.

### Chart / Graph Visualization

For data-driven requests (bar charts, pie charts, etc.).

- Bar/slice 1: Coral `#D67056`.
- Bar/slice 2: Teal `#70B8AD`.
- Bar/slice 3: Mustard `#EAB64D`.
- Bar/slice 4: Muted Blue `#5D95C6`.
- Bar/slice 5: Sand `#E6CCAB`.
- Axes and gridlines: `#2C313A` at 40% opacity.
- Background: `#F6F3EB`.

---

## Typography Hierarchy

| Tier      | Size   | Weight   | Color     | Use                          |
|-----------|--------|----------|-----------|------------------------------|
| Hero      | 64 px  | Black    | `#222222` | Key stat, hero number        |
| Title     | 44 px  | Bold     | `#222222` | Visual title                 |
| Subtitle  | 28 px  | SemiBold | `#2C313A` | Section headers              |
| Body      | 20 px  | Regular  | `#222222` | Labels, descriptions         |
| Caption   | 14 px  | Light    | `#2C313A` | Footnotes, sources           |

All text uses **JetBrainsMono Nerd Font**.

---

## Prompt Template (General)

```
A hand-drawn [VISUAL TYPE] visualization on warm cream (#F6F3EB) background.
NO grid dots. Excalidraw sketch aesthetic with slightly imperfect lines.

Topic: [TOPIC]
Key elements: [LIST ELEMENTS]

Color application:
- Primary emphasis: coral #D67056
- Secondary emphasis: teal #70B8AD
- Supporting fills: sand #E6CCAB
- Highlights: mustard #EAB64D
- Borders and text emphasis: dark grey blue #2C313A
- Body text: dark charcoal #222222
- Most shapes: white/cream fill with strategic color accents only

Typography (JetBrainsMono Nerd Font):
- Title: 44px bold at top
- Section headers: 28px semibold
- Labels: 20px regular
- Captions: 14px light

[ADDITIONAL DETAILS SPECIFIC TO THE VISUAL TYPE]

Clean, minimal, hand-drawn feel. No photographic elements.
2K resolution.
```

---

## Generation Command

```bash
bun run ~/.claude/skills/Art/Tools/Generate.ts \
  --model gemini-pro \
  --prompt "[PROMPT]" \
  --size 2K \
  --aspect-ratio [ratio] \
  --output ~/prj/art-skill/outputs/viz-[slug].png
```

### Aspect Ratio Guide

| Visual Type             | Recommended Ratio | Notes                  |
|-------------------------|-------------------|------------------------|
| Comparison / VS         | 16:9              | Wide side-by-side      |
| Concept / Mind Map      | 1:1               | Radial layout          |
| Infographic             | 9:16              | Tall vertical scroll   |
| Venn Diagram            | 1:1               | Circular layout        |
| Quote / Text            | 1:1 or 4:5        | Social media ready     |
| Abstract / Artistic     | 16:9              | Landscape              |
| Chart / Graph           | 16:9 or 4:3       | Standard chart ratio   |

- Available models: `gemini-flash`, `gemini-pro`, `gpt-image-1`.

---

## Step-by-Step Workflow

1. **Evaluate the request** against the decision tree above. Route if a
   specialized workflow matches.

2. **If staying in this workflow**, identify the visualization type from the
   list above (Comparison, Concept Map, Infographic, Venn, Quote, Abstract,
   Chart, or custom).

3. **Ask clarifying questions** if needed:
   - What is the main message or insight?
   - What elements should be emphasized (Coral treatment)?
   - Any specific layout preference?
   - Target platform (determines aspect ratio)?

4. **Apply color rules.** Follow the seven brand color application rules.

5. **Build the prompt.** Use the general template, add type-specific details.

6. **Choose aspect ratio** from the guide above.

7. **Generate the image.**

8. **Validate** against the checklist below.

9. **Iterate** if needed.

---

## Examples

### Example 1 - Concept Map of Machine Learning

**Command:**
```bash
bun run ~/.claude/skills/Art/Tools/Generate.ts \
  --model gemini-pro \
  --prompt "A hand-drawn concept map of Machine Learning on warm cream (#F6F3EB). NO grid. Center node 'Machine Learning' in coral #D67056. Level 1 branches: Supervised, Unsupervised, Reinforcement in teal #70B8AD. Level 2: specific algorithms as white/cream nodes with #2C313A borders. JetBrainsMono Nerd Font. Excalidraw style. 2K." \
  --size 2K \
  --aspect-ratio 1:1 \
  --output ~/prj/art-skill/outputs/viz-ml-concept-map.png
```

### Example 2 - Python vs JavaScript Comparison

**Command:**
```bash
bun run ~/.claude/skills/Art/Tools/Generate.ts \
  --model gemini-pro \
  --prompt "A hand-drawn side-by-side comparison of Python vs JavaScript on warm cream (#F6F3EB). NO grid. Left side: Python with coral #D67056 accent. Right side: JavaScript with teal #70B8AD accent. VS badge in center: mustard #EAB64D. Compare: typing, speed, ecosystem, learning curve, use cases. JetBrainsMono Nerd Font. Excalidraw style. 2K." \
  --size 2K \
  --aspect-ratio 16:9 \
  --output ~/prj/art-skill/outputs/viz-python-vs-javascript.png
```

### Example 3 - Startup Metrics Infographic

**Command:**
```bash
bun run ~/.claude/skills/Art/Tools/Generate.ts \
  --model gemini-pro \
  --prompt "A hand-drawn vertical infographic of startup metrics on warm cream (#F6F3EB). NO grid. Key stats in coral #D67056 at 64px: $2.5M ARR, 150% growth, 50K users. Section dividers in sand #E6CCAB. Icons in teal #70B8AD. JetBrainsMono Nerd Font. Excalidraw style. 2K." \
  --size 2K \
  --aspect-ratio 9:16 \
  --output ~/prj/art-skill/outputs/viz-startup-metrics.png
```

---

## Validation Checklist

Before delivering the image, verify every item:

- [ ] **Routing check:** Confirmed this does not belong to a specialized workflow.
- [ ] **Background** is warm cream `#F6F3EB` with NO grid dots.
- [ ] **Primary emphasis** uses Coral `#D67056`.
- [ ] **Secondary emphasis** uses Teal `#70B8AD`.
- [ ] **Maximum two accent colors** are used (Rule 2).
- [ ] **Most shapes** are neutral (white, cream, sand).
- [ ] **Text contrast** is maintained (dark on light, white on dark fills).
- [ ] **Typography** follows the hierarchy.
- [ ] **Font** is JetBrainsMono Nerd Font (specified in prompt).
- [ ] **Hand-drawn aesthetic** is present (unless user requested polished).
- [ ] **Labels** are legible at output resolution.
- [ ] **Aspect ratio** matches the visual type and target platform.
- [ ] **Output path** is `~/prj/art-skill/outputs/viz-[slug].png`.
- [ ] **No photographic** elements unless explicitly requested.
- [ ] **No voice notification** is triggered.
- [ ] **Message / insight** is clear at a glance.

---

## Troubleshooting

| Issue                          | Fix                                             |
|--------------------------------|-------------------------------------------------|
| Visual is too busy             | Reduce elements, increase whitespace             |
| Colors overwhelm the visual    | Limit to 2 accents, more neutral fills           |
| Wrong visual type chosen       | Re-evaluate against decision tree                |
| Text unreadable                | Increase font size, simplify layout              |
| Looks too corporate / rigid    | Add "hand-drawn, sketch, imperfect lines"        |
| Output looks photographic      | Add "no photos, illustration only, flat design"  |

---

## Notes

- This workflow is the **default fallback**. When in doubt, use this one.
- If you realize mid-generation that a specialized workflow would be better,
  switch to it and start over.
- For multi-part visuals (e.g., "create a set of 3 related graphics"), generate
  each one separately with consistent styling.
- Always save outputs to `~/prj/art-skill/outputs/` with the `viz-` prefix.
- Keep prompts under 500 words for best model performance.
