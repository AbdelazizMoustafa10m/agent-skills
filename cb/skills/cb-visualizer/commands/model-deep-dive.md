---
description: Render a single model (Howard-Sheth, EKB, Maslow, etc.) as a labelled flowchart with definition, example, criticism, and exam questions
---

Load `cb-visualizer`, then produce a deep-dive page for the model: $@

Read `./references/cb-models.md` first — if the model is in the canon you have a curated diagram + criticism + Q&A scaffold. Read `./templates/mermaid-flowchart.html` for the zoom/pan container and `./references/libraries.md` for Mermaid `subgraph` theming.

If $@ is empty, ask which model. If the model name is in `references/cb-models.md`, use the curated template (definition, canonical diagram, attribution, criticism). Otherwise, derive everything from the source the user provides — never invent a model that isn't in the source or the canon.

## Page structure

1. **Header** — model name, year, originators (e.g. "Howard-Sheth Model · 1969 · John Howard & Jagdish Sheth")
2. **One-line essence** — what does this model claim, in plain English? Example: "The Howard-Sheth model claims consumer decisions are problem-solving, and consumers move from extensive to limited to routinized problem-solving as they learn about a product category."
3. **The diagram** — Mermaid `flowchart TD` (or `LR` only if the model is genuinely linear). Label every node and every edge. Use `subgraph` to mark conceptual zones (e.g. "Inputs", "Hypothetical Constructs", "Outputs", "Exogenous Variables" for Howard-Sheth). Don't omit feedback loops — they're often the model's most important claim.
4. **Stage-by-stage walkthrough** — one card per stage / construct, in source order. Each card: name, what happens here, what the textbook example shows for this stage, why it matters. This is where the student builds the mental model.
5. **Worked example** — a full pass through the model with a concrete consumer + product. If the textbook has one, use it. Otherwise invent a generic example (e.g. first-time laptop buyer, family vacation booking) and label it as illustrative.
6. **Criticism / limitation** — every CB model has known critiques (too rational, too many variables, weak empirical validation, ignores emotion, ignores culture). Include them. Pretending a model is unchallenged makes the student weaker on the exam, where critique questions are common.
7. **Exam-ready Q&A** — 5-8 questions covering: definition, stage identification, application to a scenario, comparison to a competing model, critique. Answers in `<details>`.

## Diagram quality bar

- Every arrow has a label if the relationship isn't obvious (e.g. "feedback", "moderates", "input to").
- Subgraph titles use the model's own terminology — for Howard-Sheth that's "Inputs / Perceptual Constructs / Learning Constructs / Outputs / Exogenous". Don't substitute generic terms.
- For multi-level models (extensive / limited / routinized problem-solving), show the levels, not just one path.
- Mermaid `theme: 'base'` with editorial palette. Bigger `fontSize` (18-20px) for legibility.

## When the model isn't in `references/cb-models.md`

Derive the diagram from the source. Be explicit in a callout: "This diagram is reconstructed from the chapter — verify against the textbook figure". Better an honest reconstruction than a confident hallucination.

## Output

- Filename: `~/prj/cb/output/cb-model-<model-slug>.html` (e.g. `cb-model-howard-sheth.html`)
- Open in browser
- Tell the user the path
