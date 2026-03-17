---
description: Convert a pasted reference image into a clean, production-ready SVG React component. Provide the icon name and category as the argument (e.g. "dashboard sidebar").
argument-hint: <icon-name> <category: sidebar|landing|dashboard>
---

# Convert Icon Reference Image to SVG

You are an expert SVG icon designer converting a reference image into a production-ready SVG React component for FinVault.

## Input

**Arguments:** `$ARGUMENTS`

Parse the arguments:
- **First word** = icon name in kebab-case (e.g., `dashboard`, `budget-alerts`, `net-worth`)
- **Second word** = category (`sidebar`, `landing`, or `dashboard`)

If arguments are missing or incomplete, ask the user to provide both the icon name and category.

**The user will paste the reference image directly into the chat.** Analyze it using your vision capabilities. If no image is present in the conversation, ask the user to paste one.

---

## Step 1 — Analyze the Pasted Image

Study the pasted reference image carefully. Describe what you see before writing any code — the shapes, composition, spacing, and overall design intent. This ensures you understand the icon before attempting to recreate it.

---

## Step 2 — Determine Stroke Width from Category

| Category | strokeWidth |
|----------|-------------|
| `sidebar` | `1.5` |
| `landing` | `1.5` |
| `dashboard` | `2` |

Default to `1.5` if the category is unclear.

---

## Step 3 — Study Existing Icons for Consistency

Before generating the SVG, check if any icons already exist in `components/icons/custom/`. Read 1-2 existing files to match their code style, naming conventions, and SVG structure. If none exist yet, proceed with the template in Step 5.

---

## Step 4 — Design the SVG

Look at the reference image and mentally decompose it into clean geometric primitives. Follow this thinking process:

### 4a. Identify the Shapes

List every distinct visual element you see in the reference image:
- What are the primary shapes? (rectangles, circles, lines, arcs, paths)
- What is the spatial relationship between elements?
- What is the overall composition and bounding area?

### 4b. Plan the SVG Elements

For each shape, decide the best SVG primitive:
- Simple rectangles: use `<rect>` with small `rx` for subtle rounding
- Circles/ellipses: use `<circle>` or `<ellipse>`
- Straight lines: use `<line>` or `<path>` with `M`/`L` commands
- Curves: use `<path>` with `C` (cubic bezier) or `Q` (quadratic) commands
- Complex shapes: use `<path>` combining multiple commands

**Prefer semantic SVG elements** (`<rect>`, `<circle>`, `<line>`) over `<path>` when the shape is a simple primitive. This produces cleaner, more readable, and more maintainable code.

### 4c. Map to 24x24 Coordinate Space

All coordinates must fit within the `0 0 24 24` viewBox:
- The icon content should occupy roughly the center 16x16 area (coordinates ~4 to ~20) for proper padding
- Use whole numbers or single-decimal values (e.g., `4.5`, `12`, `19.5`) — avoid excessive precision
- Ensure minimum 1.5-unit gaps between separate elements for clarity at small sizes

### 4d. Write the SVG

Now construct the SVG markup. Follow these rules **exactly**:

**MANDATORY attributes on `<svg>`:**
- `viewBox="0 0 24 24"`
- `fill="none"`
- `stroke="currentColor"` (NEVER hardcode a color)
- `strokeWidth={1.5}` or `{2}` per category
- `strokeLinecap="round"`
- `strokeLinejoin="round"`
- NO `width`, `height`, `class`, `id`, `style`, or `data-*` attributes

**MANDATORY rules for child elements:**
- NO `transform`, `filter`, `mask`, `clipPath`, `gradient`, `defs`, or `use` elements
- NO `class`, `id`, `style`, or `data-*` attributes on any element
- If a small filled dot/circle is semantically meaningful, use `fill="currentColor"` and `stroke="none"` on just that element
- All other elements inherit `fill="none"` and `stroke="currentColor"` from the parent `<svg>`
- Coordinates must be clean and human-readable — round to at most 1 decimal place
- Minimize total element count — combine strokes into a single `<path>` when they share the same attributes and are logically connected

**Design intent — DO NOT literally trace pixels:**
- Interpret the visual *concept* from the reference image
- Recreate it as clean, geometric SVG — simpler is better
- The result must be clearly recognizable at 16x16 CSS pixels
- Fewer anchor points = better. Aim for the minimum geometry that captures the design
- Match the FinVault aesthetic: precision, elegance, generous negative space

---

## Step 5 — Write the React Component

Derive the file name and component name from the icon name argument:
- `dashboard` -> file: `dashboard-icon.tsx`, component: `DashboardIcon`
- `budget-alerts` -> file: `budget-alerts-icon.tsx`, component: `BudgetAlertsIcon`
- `net-worth` -> file: `net-worth-icon.tsx`, component: `NetWorthIcon`

Create the file at `components/icons/custom/<file-name>.tsx` using this exact template structure:

```tsx
import type { SVGProps } from "react"

export function ComponentNameIcon(props: SVGProps<SVGSVGElement>) {
  return (
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth={STROKE_WIDTH}
      strokeLinecap="round"
      strokeLinejoin="round"
      {...props}
    >
      {/* SVG elements here */}
    </svg>
  )
}
```

Replace `ComponentNameIcon`, `STROKE_WIDTH`, and the comment with actual values.

---

## Step 6 — Self-Validation Checklist

After writing the file, mentally verify every item. If ANY check fails, edit the file to fix it immediately:

1. `viewBox` is exactly `"0 0 24 24"`
2. No `width` or `height` on the `<svg>` element
3. `stroke="currentColor"` — no hardcoded colors anywhere
4. `strokeWidth` matches category (1.5 for sidebar/landing, 2 for dashboard)
5. `strokeLinecap="round"` and `strokeLinejoin="round"` present
6. `fill="none"` on `<svg>` (except intentional small filled accents on individual elements)
7. `{...props}` is spread on the `<svg>` element
8. No `transform`, `filter`, `mask`, `clipPath`, `gradient`, `defs`, `use` anywhere
9. No `class`, `id`, `style`, or `data-*` attributes on any element
10. All coordinates are clean numbers (max 1 decimal place)
11. The icon would be recognizable at 16x16px — not too complex or detailed
12. The paths are geometric and minimal — not a noisy pixel trace

---

## Step 7 — Run Type Check

```bash
npx tsc --noEmit --strict components/icons/custom/<file-name>.tsx 2>&1 | head -20
```

If there are type errors, fix them.

---

## Output

Report to the user:
1. The icon name and what it represents
2. A brief description of the SVG design choices (2-3 sentences)
3. The file path where the component was saved
4. Confirmation that all validation checks passed
