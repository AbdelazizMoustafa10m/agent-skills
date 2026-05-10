---
description: Apply theories from a chapter to a real or hypothetical case — the format examiners reward
---

Load `cb-visualizer`, then build a case-study analysis page for: $@

Read `./references/cb-models.md` to scaffold the primary theory's diagram and stages, `./templates/mermaid-flowchart.html` for the diagram container, and `./references/css-patterns.md` (especially the Prose Page Elements / lead-paragraph + drop-cap pattern) for the case excerpt at the top.

A case-study page is what students actually need to practise for case-based exam questions. It's not a summary; it's a worked example of "given this scenario, name the relevant theory, apply it stage by stage, defend your choice".

## Inputs the user might provide

- A chapter and a case ("apply Chapter 7 to this Pepsi launch")
- Just a case (figure out which theories apply from the chapter context or canon)
- Just a chapter ("invent a realistic case to apply this to")

If only a chapter is given, invent a case but flag it as illustrative. If only a case is given and no chapter context, ask which theories the user wants applied or default to the canonical CB lineup (EKB, Howard-Sheth, Maslow, Theory of Planned Behavior).

## Page structure

1. **The case** — 3-6 sentence setup. If the user pasted a case, use it verbatim with light cleanup. If invented, mark it clearly as "illustrative case". Keep it concrete: a real or realistic brand, a specific consumer profile, a specific moment of decision.

2. **Which theory / theories apply** — name them and say *why* in one line each. This is the move examiners want to see early in an answer.

3. **Stage-by-stage application** — for the primary theory, walk through the model stages with what's happening in the case at each stage. Embed the model's flowchart at the top, then a 2-column block per stage: "Stage" / "What's happening in the case". This is the bulk of the page.

4. **Where the theory falls short** — every model is incomplete. Name what the theory misses about this specific case (emotional drivers it doesn't capture, cultural factors outside its scope, etc.). Examiners reward this.

5. **Marketing implication** — given the analysis, what should the marketer do? 2-3 concrete actions tied to the model. This is the "so what" the case-study format demands.

6. **Alternative lens** — pick one competing theory and re-analyse the case in 3-4 lines. This shows the student can hold multiple frameworks at once, which separates good answers from average ones.

7. **Self-check** — 3-5 questions: which stage is the consumer at right now? what would change if the consumer were in problem-solving mode? what data would you collect to validate the analysis?

## Diagram requirements

The model flowchart at the top isn't decorative — annotate it with the case. For each node, add a small caption underneath in the case's language. E.g. for EKB's "Information search" node, caption it "Family googles 'safe family-friendly Mexico resorts'". This is the dual-coding payoff.

## Aesthetic

Editorial. The case at top should feel like an excerpt — slightly larger lead-paragraph type, italic dateline / source attribution if applicable, drop cap optional. The analysis below is regular study layout.

## Output

- Filename: `~/prj/cb/output/cb-case-<case-slug>.html`
- Open in browser
- Tell the user the path and ask if they want a comparison-table follow-up applying additional theories to the same case
