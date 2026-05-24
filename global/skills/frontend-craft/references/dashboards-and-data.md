# Dashboards and Data

Data-dense product UI has its own craft. The goal is *comprehension speed*, not decoration:
a viewer should read the most important number first and trust every figure on screen.

## Density and layout

- **Lead with the answer.** A dashboard exists to answer a question — surface the headline
  metric or status before the supporting detail. Don't open with a row of equal-weight
  cards that forces the eye to hunt.
- **Establish a hierarchy of three tiers:** the primary KPI(s), supporting trends, and
  drill-down detail. Size, position, and weight should encode that tier order.
- Density is appropriate here — generous marketing whitespace wastes a power user's screen.
  Use a tight, consistent grid (a bento/12-col grid works well) and align everything to it.
- Group related metrics; separate unrelated ones with space or a divider, not a card around
  every single number (cards-in-cards is a classic tell — see review checklist).

## KPI / metric cards

A good metric card answers: *what is it, what's the value, is that good, and versus what?*

- Label (what) · value (large, `tabular-nums`) · delta vs. a baseline (with direction +
  sign) · optional sparkline or period.
- Encode the delta with **text/icon/sign, not color alone** — red/green is invisible to
  ~8% of men. Color reinforces; it never carries the meaning by itself.
- Keep units and precision consistent across a row so values are scannable.

## Numbers and tables

- `font-variant-numeric: tabular-nums` on every column of figures so digits align and
  columns don't jitter as values change.
- **Right-align numbers, left-align text**, header alignment matching its column.
- Round to a sensible precision; don't show six decimals because the data has them. State
  the unit once (column header) rather than on every cell.
- Zebra striping or a subtle row hover beats heavy gridlines. Give rows real vertical
  padding — cramped tables are hard to scan.
- For long tables: sticky header, a clear empty state, and a loading state (skeleton rows,
  not a centered spinner that collapses layout).
- Format with locale-aware tools (`Intl.NumberFormat`) for thousands separators, currency,
  and percentages — don't hand-roll string formatting.

## Choosing the right chart

Match the chart to the *question*, not to what looks impressive:

| Question | Chart |
| --- | --- |
| How does a value change over time? | Line (or area for cumulative) |
| How do categories compare? | Bar / column |
| What's the part-to-whole split? | Stacked bar, or treemap for many parts |
| How are two variables related? | Scatter |
| Where is activity concentrated (time/geo)? | Heatmap |
| Single value against a target? | Gauge / bullet / big number + delta |

- **Avoid pie charts beyond ~3–4 slices** (and never for precise comparison — bars win).
  Avoid dual-axis charts unless the two series genuinely share a frame.
- Start bar-chart axes at zero; truncating exaggerates differences and misleads.
- Label directly where possible instead of forcing a legend round-trip; keep ≤ ~6 series
  per chart before it turns to spaghetti.
- A clear data table often beats a chart for exact lookup. Use a chart for the *shape* of
  the data, a table for the *values*.

## Charts must be accessible too

- Don't rely on color alone to distinguish series — vary pattern, dash, marker, or label,
  and use a color-blind-safe palette.
- Give the chart a text alternative: a caption or summary stating the takeaway, and/or an
  associated data table for screen-reader users.
- Ensure interactive points/tooltips are keyboard-reachable, or provide the same
  information in an accessible static form.
- Respect `prefers-reduced-motion` for entrance/transition animation on charts.

## Implementation notes

- Prefer the project's existing chart library; don't add a second one. If none exists and
  the need is simple, lightweight SVG or a small library beats pulling in a heavy
  dependency for one sparkline.
- Reserve space for charts/media so async data doesn't shift the layout (set explicit
  dimensions or aspect-ratio).
