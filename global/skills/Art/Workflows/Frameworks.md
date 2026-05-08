# Frameworks -- Visual Mental Models

> Generate hand-drawn visual frameworks that communicate complex mental models,
> matrices, spectrums, and relational diagrams using organic geometry and brand colors.

---

## When to Use

- Explaining tradeoffs between two or more dimensions (2x2 matrix)
- Showing overlapping concepts (Venn diagrams)
- Illustrating hierarchies or priority layers (pyramids)
- Mapping a spectrum or continuum between extremes
- Comparing categories with shared and unique properties

---

## Framework Types

### 2x2 Matrix
- Two axes, four quadrants
- Each quadrant labeled with a concept or archetype
- Optimal/target quadrant highlighted in Coral (#D67056)
- Secondary quadrants in Teal (#70B8AD) or Tan (#E6CCAB)
- Example: Security vs. Convenience, Speed vs. Quality

### Venn Diagram
- 2 or 3 overlapping circles
- Each circle represents a distinct concept or capability
- Overlap zones show synthesis or intersection
- Center overlap (the "sweet spot") in Coral (#D67056)
- Individual circles in Teal (#70B8AD), Muted Blue (#5D95C6), Mustard (#EAB64D)
- Example: Capability Venn (Skills + Interest + Market Need)

### Pyramid / Hierarchy
- 3-5 tiers stacked vertically
- Base = foundational / broad concepts
- Apex = aspirational / refined concepts
- Top tier in Coral (#D67056), middle tiers in Teal/Tan, base in Dark Grey Blue (#2C313A)
- Example: Maslow-style need hierarchies, strategy pyramids

### Spectrum / Continuum
- Horizontal or vertical gradient bar
- Two poles labeled at each end
- Key positions marked along the spectrum
- Primary marker in Coral (#D67056), secondary markers in Teal (#70B8AD)
- Example: Centralized vs. Decentralized, Simple vs. Complex

### Radar / Spider Chart
- 4-8 axes radiating from center
- Polygon shape shows profile across dimensions
- Fill area in semi-transparent Coral
- Axis labels in Dark Charcoal (#222222)
- Example: Team skill assessment, product feature comparison

---

## Brand Color System

| Role              | Color                  | Hex       | Usage                              |
|-------------------|------------------------|-----------|------------------------------------|
| Background        | Warm Cream             | #F6F3EB   | Canvas / page background           |
| Primary Zone      | Coral/Orange           | #D67056   | Optimal quadrant, sweet spot, apex |
| Secondary Zone    | Teal                   | #70B8AD   | Supporting areas, secondary paths  |
| Tertiary Zone     | Tan/Sand               | #E6CCAB   | Neutral areas, backgrounds         |
| Highlight         | Mustard Yellow         | #EAB64D   | Callouts, annotations, emphasis    |
| Text / Lines      | Dark Charcoal          | #222222   | Labels, axis lines, borders        |
| Accent Info       | Muted Blue             | #5D95C6   | Informational zones, data points   |
| Deep Background   | Dark Grey Blue         | #2C313A   | Contrast panels, dark sections     |

---

## 3-Tier Typography System

All text references the JetBrainsMono Nerd Font family:

### Tier 1 -- Title
- JetBrainsMono Nerd Font ExtraBold
- Large size, used for the framework title at top
- Color: Dark Charcoal (#222222) or white on dark backgrounds

### Tier 2 -- Labels
- JetBrainsMono Nerd Font Medium
- Medium size, used for axis labels, quadrant names, circle labels
- Color: Dark Charcoal (#222222) or brand accent matching the zone

### Tier 3 -- Annotations
- JetBrainsMono Nerd Font Light or Regular
- Small size, used for descriptions, notes, sub-labels
- Color: Dark Charcoal (#222222) at 70% opacity or Muted Blue (#5D95C6)

---

## Visual Style Guidelines

1. **Hand-drawn organic geometry**: Lines should feel slightly imperfect, as if
   sketched on paper. Gentle wobble on borders, soft rounded corners.
2. **Warm textured background**: Use #F6F3EB as canvas with subtle paper grain.
3. **Soft shadows**: Light drop shadows behind shapes for depth, never harsh.
4. **No rigid grids**: Shapes can breathe, overlap slightly, feel natural.
5. **Iconography**: Small hand-drawn icons can annotate quadrants or zones
   (e.g., a small lock icon for "security", a lightning bolt for "speed").
6. **Arrows and connectors**: Sketchy, slightly curved arrows rather than
   straight mechanical lines.

---

## Prompt Template

```
A hand-drawn visual framework diagram on a warm cream (#F6F3EB) textured paper background.

Framework type: [2x2 matrix | Venn diagram | pyramid | spectrum | radar chart]
Topic: [TOPIC DESCRIPTION]

Structure:
- [AXIS_1 / CIRCLE_1 / TIER_1]: [Label and description]
- [AXIS_2 / CIRCLE_2 / TIER_2]: [Label and description]
- [QUADRANT / OVERLAP / LEVEL details as needed]

Visual style: Organic hand-drawn geometry with slightly wobbly lines, sketchy borders,
and soft rounded shapes. Feels like a whiteboard sketch refined into a polished illustration.

Color coding:
- Primary/optimal zone: Coral (#D67056) with soft fill
- Secondary zones: Teal (#70B8AD) with lighter fill
- Neutral/base zones: Tan (#E6CCAB) or Muted Blue (#5D95C6)
- Highlight callouts: Mustard Yellow (#EAB64D)
- All text and lines: Dark Charcoal (#222222)

Typography (JetBrainsMono Nerd Font):
- Title: ExtraBold, large, centered at top
- Zone/axis labels: Medium weight, clearly positioned
- Annotations: Light weight, small, tucked near relevant zones

Include small hand-drawn icons relevant to each zone or concept.
Soft drop shadows behind major shapes. No harsh mechanical lines.
```

---

## Generation Command

```bash
bun run ~/.claude/skills/Art/Tools/Generate.ts \
  --model gemini-pro \
  --prompt "[PROMPT]" \
  --size 2K \
  --aspect-ratio 16:9 \
  --output ~/prj/art-skill/outputs/[name].png
```

### Recommended Aspect Ratios

| Framework Type | Aspect Ratio | Reason                          |
|----------------|--------------|---------------------------------|
| 2x2 Matrix     | 1:1          | Square symmetry for 4 quadrants |
| Venn Diagram   | 1:1 or 4:3   | Circular shapes need room       |
| Pyramid        | 9:16 or 3:4  | Vertical orientation            |
| Spectrum       | 16:9 or 21:9 | Horizontal flow                 |
| Radar Chart    | 1:1          | Radial symmetry                 |

---

## Validation Checklist

Before delivering, verify:

- [ ] Framework type matches the concept being communicated
- [ ] Background is Warm Cream (#F6F3EB) with subtle texture
- [ ] Coral (#D67056) is used for the primary/optimal zone only
- [ ] Teal (#70B8AD) used for secondary zones, not competing with Coral
- [ ] All text is legible against its background color
- [ ] Typography follows 3-tier hierarchy (title, labels, annotations)
- [ ] Hand-drawn organic style is maintained (no rigid mechanical shapes)
- [ ] Small icons or illustrations support the labels
- [ ] Axis labels or zone names are clear and correctly positioned
- [ ] No more than 6-8 distinct zones to avoid visual clutter
- [ ] Soft shadows present, no harsh borders
- [ ] Output saved to ~/prj/art-skill/outputs/
- [ ] No voice notifications triggered

---

## Examples

### Example 1: Security vs. Convenience Matrix

**Framework:** 2x2 Matrix
**Axes:** X = Convenience (Low to High), Y = Security (Low to High)
**Quadrants:**
- Top-right (Coral): "Sweet Spot" -- High security + High convenience
- Top-left (Teal): "Fortress" -- High security, low convenience
- Bottom-right (Tan): "Easy Target" -- Low security, high convenience
- Bottom-left (Dark Grey Blue): "Worst Case" -- Low security, low convenience

### Example 2: Capability Venn

**Framework:** 3-circle Venn
**Circles:**
- Circle A (Muted Blue): "What you're good at"
- Circle B (Teal): "What the world needs"
- Circle C (Mustard): "What you love doing"
- Center overlap (Coral): "Your calling"

### Example 3: Strategy Pyramid

**Framework:** 4-tier Pyramid
**Tiers (top to bottom):**
- Apex (Coral): "Vision"
- Tier 2 (Teal): "Strategy"
- Tier 3 (Tan): "Tactics"
- Base (Dark Grey Blue): "Operations"

### Example 4: Complexity Spectrum

**Framework:** Spectrum
**Poles:** Simple (left) to Complex (right)
**Markers:**
- "Script" (far left, Teal)
- "Application" (center-left, Muted Blue)
- "Platform" (center-right, Mustard)
- "Ecosystem" (far right, Coral)

---

## Notes

- When the user's concept doesn't clearly fit one framework type, suggest
  the best match and explain why.
- Combine frameworks when appropriate (e.g., a 2x2 matrix with a Venn
  overlay in the optimal quadrant).
- Always prioritize clarity over decoration. The framework should communicate
  the mental model in under 5 seconds of viewing.
- For complex topics, consider generating a series of related frameworks
  rather than cramming everything into one image.
