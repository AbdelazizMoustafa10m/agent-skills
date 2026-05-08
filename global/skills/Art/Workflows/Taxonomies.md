# Taxonomies - Visual Classification Grids

## Purpose

Generate visual taxonomies, classification grids, periodic-table layouts, matrices,
and hierarchical tree diagrams. Every output uses the brand palette on a warm cream
canvas with hand-drawn, slightly imperfect line work.

---

## When to Use

- The user asks to **classify**, **categorize**, or **organize** items visually.
- Requests for periodic tables, matrices, grids, or hierarchical trees.
- Comparative layouts where items belong to named groups or tiers.

---

## Brand Palette Reference

| Token            | Hex       | Usage                              |
|------------------|-----------|------------------------------------|
| Background       | `#F6F3EB` | Canvas / card fill                 |
| Coral (accent)   | `#D67056` | **Category 1** headers & borders   |
| Teal             | `#70B8AD` | **Category 2** headers & borders   |
| Tan / Sand       | `#E6CCAB` | Tertiary fills, divider lines      |
| Mustard Yellow   | `#EAB64D` | Highlights, badges, callouts       |
| Muted Blue       | `#5D95C6` | Optional Category 3 or links       |
| Dark Grey Blue   | `#2C313A` | Heavy borders, section separators  |
| Text             | `#222222` | Body copy                          |

**Font:** JetBrainsMono Nerd Font (all text layers).

---

## Layout Styles

### 1. Periodic Table Grid

- Rectangular cells arranged in rows/columns.
- Each cell: icon or emoji top-left, short label centered, atomic-number-style
  index bottom-right.
- Hand-drawn rounded corners with slight wobble.
- Row headers in **Coral `#D67056`**, column headers in **Teal `#70B8AD`**.
- Empty cells filled with `#F6F3EB` (background).

### 2. Matrix / Comparison Grid

- Two axes labelled clearly (e.g., Complexity vs. Impact).
- Quadrant fills use light tints of brand colors at ~15 % opacity.
- Items placed as hand-drawn sticky notes inside quadrants.
- Axis labels in **Dark Grey Blue `#2C313A`**, bold.

### 3. Hierarchical Tree

- Root node at top, children fan downward.
- Connector lines: slightly wavy, 2 px, `#E6CCAB`.
- Level 0 (root): `#D67056` filled node.
- Level 1: `#70B8AD` filled nodes.
- Level 2+: `#F6F3EB` nodes with `#2C313A` border.
- Node labels in `#222222`.

---

## Typography Hierarchy (3 Tiers)

| Tier    | Size   | Weight   | Color     | Use                        |
|---------|--------|----------|-----------|----------------------------|
| H1      | 48 px  | Bold     | `#222222` | Chart title                |
| H2      | 28 px  | SemiBold | `#D67056` | Category / group headers   |
| Body    | 18 px  | Regular  | `#222222` | Cell labels, descriptions  |

All text uses **JetBrainsMono Nerd Font**.

---

## Prompt Template

Use the following template. Replace bracketed placeholders with actual values.

```
A hand-drawn visual taxonomy grid on a warm cream (#F6F3EB) background.
Style: Excalidraw / whiteboard sketch with slightly imperfect lines.

Layout: [periodic table grid | matrix | hierarchical tree]
Topic: [TOPIC]
Categories: [LIST CATEGORIES]

Color mapping:
- Category 1 headers and borders: coral #D67056
- Category 2 headers and borders: teal #70B8AD
- Tertiary accents: sand #E6CCAB
- Highlight badges: mustard #EAB64D
- Body text: dark charcoal #222222

Typography (JetBrainsMono Nerd Font):
- Title: 48px bold
- Group headers: 28px semibold
- Cell labels: 18px regular

Each cell contains an icon and a short label.
No photographic elements. No grid dots on the background.
High detail, 2K resolution.
```

---

## Generation Command

```bash
bun run ~/.claude/skills/Art/Tools/Generate.ts \
  --model gemini-pro \
  --prompt "[PROMPT]" \
  --size 2K \
  --aspect-ratio 16:9 \
  --output ~/prj/art-skill/outputs/taxonomy-[slug].png
```

- Default aspect ratio: **16:9** (best for grid layouts).
- For tall hierarchical trees, switch to **9:16** or **3:4**.
- Available models: `gemini-flash`, `gemini-pro`, `gpt-image-1`.

---

## Step-by-Step Workflow

1. **Clarify the taxonomy.** Ask the user:
   - What is the topic / domain?
   - How many categories or groups?
   - Preferred layout style (grid, matrix, tree)?
   - Number of items (affects cell size).

2. **Map categories to colors.**
   - First two categories always get Coral and Teal.
   - Third category may use Muted Blue `#5D95C6`.
   - Additional categories cycle through Mustard, then Tan.

3. **Build the prompt.** Fill in the template above.

4. **Generate the image** using the command above.

5. **Validate** using the checklist below.

6. **Iterate** if any checklist item fails. Adjust prompt and regenerate.

---

## Aspect Ratio Guide

| Layout              | Recommended Ratio | Notes                     |
|---------------------|-------------------|---------------------------|
| Periodic table      | 16:9              | Wide grid                 |
| Matrix (2x2)        | 1:1               | Square quadrants          |
| Matrix (3x3+)       | 16:9              | More columns than rows    |
| Hierarchical tree   | 9:16 or 3:4       | Tall vertical trees       |
| Radial taxonomy     | 1:1               | Circular layout           |

---

## Examples

### Example 1 - Programming Paradigm Taxonomy

**Prompt excerpt:**
```
A hand-drawn periodic table of programming paradigms on warm cream (#F6F3EB).
Categories: Imperative (coral #D67056), Declarative (teal #70B8AD),
Multi-paradigm (mustard #EAB64D).
Cells include: C, Java, Python, Haskell, SQL, Prolog, Rust, Lisp...
```

**Command:**
```bash
bun run ~/.claude/skills/Art/Tools/Generate.ts \
  --model gemini-pro \
  --prompt "A hand-drawn periodic table of programming paradigms..." \
  --size 2K \
  --aspect-ratio 16:9 \
  --output ~/prj/art-skill/outputs/taxonomy-programming-paradigms.png
```

### Example 2 - Design Pattern Hierarchy

**Prompt excerpt:**
```
A hierarchical tree of software design patterns on warm cream (#F6F3EB).
Root: Design Patterns. Level 1: Creational (coral), Structural (teal),
Behavioral (muted blue #5D95C6). Level 2: individual patterns as leaf nodes.
```

**Command:**
```bash
bun run ~/.claude/skills/Art/Tools/Generate.ts \
  --model gemini-pro \
  --prompt "A hierarchical tree of software design patterns..." \
  --size 2K \
  --aspect-ratio 3:4 \
  --output ~/prj/art-skill/outputs/taxonomy-design-patterns.png
```

---

## Validation Checklist

Before delivering the image, verify every item:

- [ ] **Background** is warm cream `#F6F3EB` with NO grid dots.
- [ ] **Category 1** elements use Coral `#D67056`.
- [ ] **Category 2** elements use Teal `#70B8AD`.
- [ ] **Typography** follows the 3-tier hierarchy (H1, H2, Body).
- [ ] **Font** is JetBrainsMono Nerd Font (or closest match in prompt).
- [ ] **Line style** is hand-drawn / slightly imperfect, not rigid.
- [ ] **All items** requested by the user are present in the grid.
- [ ] **Labels** are legible at the output resolution.
- [ ] **Aspect ratio** matches the layout style.
- [ ] **Output path** is `~/prj/art-skill/outputs/taxonomy-[slug].png`.
- [ ] **No photographic** or stock-image elements are present.
- [ ] **Color contrast** passes basic readability (dark text on light fills).
- [ ] **No voice notification** is triggered.

---

## Troubleshooting

| Issue                        | Fix                                              |
|------------------------------|--------------------------------------------------|
| Text too small to read       | Reduce item count or increase resolution          |
| Colors look washed out       | Ensure hex values are exact in prompt             |
| Grid lines too perfect       | Add "hand-drawn, sketch style, imperfect lines"  |
| Wrong number of cells        | Explicitly state cell count in prompt             |
| Model ignores color mapping  | Move color instructions to start of prompt        |

---

## Notes

- For taxonomies with more than 30 items, consider splitting into multiple
  images or using a larger canvas (switch `--size` to `4K` if supported).
- If the user does not specify a layout, default to **periodic table grid**.
- Always save outputs to `~/prj/art-skill/outputs/` with a descriptive slug.
