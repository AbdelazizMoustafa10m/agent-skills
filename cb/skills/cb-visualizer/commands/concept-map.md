---
description: Generate a Mermaid mindmap of every key term and how they relate
---

Load `cb-visualizer`, then build a concept map for: $@

If the input is a PDF, follow the TOC-first protocol from SKILL.md. Read `./templates/mermaid-flowchart.html` (zoom/pan/expand container) and `./references/libraries.md` (Mermaid theming, ELK layout, fontSize tuning for big maps) before composing.

A concept map is **not** a glossary. It shows hierarchy and relationship: what's a parent concept, what's a sibling, what's a special case, what depends on what. The output is a Mermaid `mindmap` (hierarchy) or `flowchart TD` (richer cross-links) embedded in an HTML page with the standard `diagram-shell` zoom/pan controls from visual-explainer.

## Choose the right Mermaid type

- **`mindmap`** — when the structure is genuinely hierarchical (one chapter root → 4-6 themes → 3-5 sub-concepts each → leaves). This is the right choice 80% of the time for textbook chapters because they're written hierarchically.
- **`flowchart TD`** with `subgraph` clusters — when there are meaningful cross-links between branches (e.g. "perception" feeds into "attitude formation" feeds into "decision making"). Use labelled edges to name the relationship.

If unsure, start with `mindmap`. Adding cross-links is easy if a re-render is needed.

## Construction process

1. **Inventory every named term** in the source — definitions, models, frameworks, biases, types, stages. Don't filter yet.
2. **Group into 4-7 themes**. Reasonable groupings for a typical CB chapter: external influences (culture, social class, family, reference groups), internal influences (perception, learning, motivation, attitude, personality), decision process (problem recognition, search, evaluation, purchase, post-purchase), models (named theories tying it together).
3. **Drop terms that aren't load-bearing.** A concept map with 60 leaves is unreadable. Aim for 25-40 leaves total. The student can drill into any branch via `model-deep-dive` later.
4. **Add the relationships that aren't strictly hierarchical** as cross-links if using `flowchart TD`. Cap at ~8 cross-links — more becomes spaghetti.

## Annotation

Each leaf should be 1-3 words (the term itself). Don't put definitions inline — that's what the glossary in `summarize-chapter` is for. The map shows *structure*; the glossary shows *meaning*; the model deep-dives show *mechanism*. Keep the responsibilities separate.

If the user wants definitions surfaced too, output the map at top and a glossary table below — don't cram definitions into the diagram.

## Mermaid theming

Use `theme: 'base'` with custom `themeVariables` matching the editorial palette (deep navy `#1e3a5f`, gold `#d4a73a`, ink `#1a1a1a`, paper `#faf7f5`). Bigger `fontSize` (18-20px) since concept maps are read whole. Set `INITIAL_ZOOM` to 1.4-1.6 if the map has 25+ leaves.

## Output

- Filename: `~/prj/cb/output/cb-<chapter-slug>-map.html`
- Single page, single diagram, `diagram-shell` with zoom/pan/expand controls, click-to-expand opens full-screen in new tab
- Open in browser

If the chapter is too sprawling for one map, split into one map per theme and offer a "Section maps" follow-up rather than producing an unreadable mega-map.
