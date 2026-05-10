---
description: Generate a slide deck (HTML) optimised for last-minute exam revision — definitions, model stages, common traps, Q&A
---

Load `cb-visualizer`, then produce an exam-prep deck for: $@

Read `./templates/slide-deck.html` (the slide engine, navigation, all 10 slide types) and `./references/slide-patterns.md` (presets, narrative arc, composition variety rules) before composing. The slide engine and CSS go straight into the output HTML — don't re-invent them. If the input is a PDF, follow the TOC-first protocol from SKILL.md.

The use case: student has 1-3 days before the exam and has already read the material. They want a high-density visual revision aid they can flip through in 30-45 minutes and re-flip the morning of the exam.

## Deck structure

Plan the slide sequence before writing HTML. A good 18-25-slide deck for one chapter:

1. **Title slide** — chapter name, exam date if known, a single visual anchor (model diagram or hero word)
2. **What this chapter is really about** — one slide, three lines max
3. **Learning objectives** — bullet list of what the exam can ask
4. **Concept map** — full Mermaid mindmap, one slide
5–N. **One slide per major concept**, each with:
   - Term + canonical definition (verbatim from textbook if it's a memorise-this term, otherwise paraphrased)
   - One-line plain-English explanation
   - Concrete example
   - Why an examiner cares (hint at the kind of question)
6. **One slide per major model** with the full diagram + 4-bullet structure recap
7. **Theory comparison slide** — the comparison table from `compare-theories`, condensed
8. **Common confusions** — 3-5 pairs of concepts students mix up, with the distinction made sharp
9. **Q&A slides** — 8-12 retrieval questions, one per slide, **answer hidden until click** (use a button or `<details>` styled to fill the slide)
10. **Cheat sheet** — final slide, single-page glossary of the must-memorise definitions
11. **Closing slide** — "good luck" with 3 strategy tips: read the question twice, name the model before applying it, write criticism even if not asked

## Slide composition rules (from visual-explainer's slide-patterns)

- One slide = one viewport. No scrolling within a slide.
- Vary composition: don't put 5 centred slides in a row. Alternate centred / left-heavy / split / full-bleed / edge-aligned.
- Typography is 2-3× larger than a scrolling page. Body around 28px, headlines around 56-72px.
- One accent colour, used for emphasis only.
- No emoji. No gradient text. No glow shadows.

## Aesthetic

Pick one of the four slide presets from visual-explainer's `slide-patterns.md` and commit:

- **Midnight Editorial** (deep navy + warm gold + serif headlines) — for psychology/behaviour-heavy chapters
- **Warm Signal** (cream + terracotta + sage) — for social/cultural chapters
- **Swiss Clean** (white + ink black + single accent) — for high-density definitional chapters
- **Terminal Mono** — **forbidden** for academic decks; reads as engineering material

## Q&A slide pattern

Every question slide must:
- Show only the question by default
- Reveal the answer on a click or keypress
- Use a layout that visually separates "question" (top, large type) from "answer" (bottom, with a subtle divider)
- Include a one-line "what this tests" tag at the bottom of the answer (e.g. "Tests: Howard-Sheth stage identification")

## Output

- Filename: `~/prj/cb/output/cb-<chapter-slug>-exam-deck.html`
- Self-contained HTML using the slide engine from `visual-explainer/templates/slide-deck.html`
- Open in browser; the user navigates with arrow keys

After delivering, suggest follow-ups:
- "Want flashcards exported for Anki/Mochi?" (if yes, add a final slide with the semicolon-separated Q;A export from `summarize-chapter`)
- "Want a 1-page printable summary too?" (run `summarize-chapter`)
