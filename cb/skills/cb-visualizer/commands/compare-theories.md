---
description: Side-by-side comparison table across multiple theories on the dimensions that matter for exam answers
---

Load `cb-visualizer`, then build a comparison table for: $@

Read `./templates/data-table.html` (sticky-header table, status indicators, KPI patterns) and `./references/cb-models.md` (the curated criticism and "best applied to" lines for each canonical theory) before composing.

The user might say "compare EKB and Howard-Sheth", "all the consumer behaviour models", or just "compare them" with an implicit set from the current chapter. Resolve which theories first, then proceed. If unclear, list candidates and ask.

## Why a table

Exams reward students who can articulate **how theories differ**, not just describe each one. The cognitive move is: hold N theories in mind and pivot across a fixed set of dimensions. A table is the only format that scales to that.

## Required columns

| Dimension | What goes here |
|---|---|
| Theory | Name + year + originators |
| One-line claim | The single thing this theory asserts that the others don't |
| Decision-making view | Rational / cognitive / emotional / social / habitual |
| Key constructs | The 3-5 named variables in the model (e.g. for Howard-Sheth: stimuli, perceptual constructs, learning constructs, outputs) |
| Stages or structure | Numbered stages if applicable, or "non-staged" |
| Best applied to | Product category / context where this model is most useful |
| Criticism | The standard critique a textbook would mention |
| Exam tip | What examiners typically ask about this theory |

If the user wants a different set of dimensions (e.g. "compare on cultural sensitivity"), honour that — but include "One-line claim" and "Criticism" regardless, since they're the most testable.

## Visual treatment

- Real `<table>`, not CSS Grid. Tables get accessibility, copy-paste behaviour, and column alignment for free.
- Sticky `<thead>` so headers stay visible on long tables.
- First column (theory name) sticky on horizontal scroll.
- Row hover highlight.
- Status indicators where relevant (e.g. "Decision-making view" cells use small coloured dots — terracotta for rational, sage for emotional, deep blue for cognitive — so the student can scan visually).

After the table, optionally include a **dimension-spotlight** section: for one or two dimensions where the theories disagree most, write a 2-3 sentence prose comparison. This is what the student would actually write in an exam answer.

## Aesthetic

Editorial. Body type ≥ 16px, line-height ≥ 1.6. Tables look like tables, not like dashboards — no gradient backgrounds in cells, no animated row reveals.

## Output

- Filename: `~/prj/cb/output/cb-compare-<theories-slug>.html` (e.g. `cb-compare-ekb-howard-sheth-nicosia.html`)
- Open in browser
