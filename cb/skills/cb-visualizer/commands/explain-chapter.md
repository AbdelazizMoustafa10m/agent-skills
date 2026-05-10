---
description: Walk through a textbook chapter as a multi-section visual HTML page (default when user pastes a chapter without a specific verb)
---

Load the `cb-visualizer` skill, then generate a multi-section visual study page for: $@

If $@ is empty, ask for the chapter text, path, or URL.

If the input is a PDF path, follow the TOC-first protocol from SKILL.md (Reading source material → PDFs): index pages 1-5 to find chapter boundaries, confirm scope with the user, then read the target chapter in 20-page chunks via the `Read` tool's `pages` parameter. Don't fabricate content — the page must be faithful to the source.

Read `./templates/architecture.html` (CSS Grid cards), `./templates/mermaid-flowchart.html` (for any embedded model diagrams), `./references/css-patterns.md`, `./references/libraries.md`, and `./references/responsive-nav.md` (for the sticky TOC) before composing the HTML. Replace the templates' software-flavoured example content with the chapter's actual content.

## Page structure (in this order)

1. **Hero / chapter header**
   - Chapter number + title from the source
   - One-sentence "what this chapter is really about" (your synthesis, not the textbook's blurb)
   - Three to five learning objectives — extract from the source if listed, otherwise infer from section headings

2. **At-a-glance** (sticky/anchored on desktop)
   - Concept map — small embedded Mermaid `mindmap` showing every named term in the chapter and how it groups
   - Reading time + recommended study time (≈ 2-3× reading time for active study)

3. **Section walkthroughs** — one card per major section in the chapter, in source order. Each card has:
   - Section title (matches the textbook heading exactly so the student can cross-reference)
   - **Plain-English explanation** — 2-4 sentences in your own words. Don't copy the textbook prose; rephrase as if explaining to a smart friend.
   - **The visual** — pick the right format for the content (flowchart for a process model, table for competing definitions, hierarchy for a taxonomy — see the SKILL.md mapping table). Every section that introduces a model **must** have a diagram, not just text.
   - **Textbook example** — preserve the example the textbook uses (with attribution if it's a real brand or case). If none, invent one that's culturally generic and clearly labelled "example".
   - **Why it matters** — one-line connection to marketing practice or the next section. This is what makes the chapter cohere.

4. **Key terms glossary** — HTML table, sticky header, columns: Term · Definition · Example · Where it appears (section ref). Sort alphabetically. This is the highest-traffic part of the page during exam revision.

5. **Models & frameworks deep-dive** — for each named model in the chapter, embed a labelled Mermaid diagram and a 4-row table: definition · key insight · when it applies · criticism / limitation. Use `references/cb-models.md` templates if the model is in the canon.

6. **Common confusions / exam traps** — callout boxes for places students typically mix things up. Examples that recur in CB: classical vs operant conditioning, EKB vs Howard-Sheth, attitudes vs intentions, segmentation vs targeting vs positioning.

7. **Self-check questions** — 6-10 active-recall questions covering definitions, model stages, comparisons, and one application question. Answers in `<details>` tags so the student must commit before peeking.

8. **Sources & further reading** — preserve any citations from the source. Don't invent URLs.

## Constraints

- **Length budget**: aim for a page the student can scroll in 5-7 minutes. Cut, don't cram. If the chapter is huge (60+ pages), produce sections 1-4 in full and offer to follow up with `model-deep-dive` or `case-study` for specific parts rather than ballooning this page.
- **Aesthetic**: editorial by default — Instrument Serif or Crimson Pro headlines, IBM Plex Sans body, deep navy + gold accents. Or paper-ink (warm cream + terracotta + sage). Never Blueprint, IDE, Terminal, or Neon.
- **No emoji** in section headers. Use the `section__num` numbered-badge pattern from visual-explainer's `css-patterns.md` instead.
- **Citations preserved**. If the source says "Howard and Sheth (1969)", carry that through.
- **Body ≥ 16px, line-height ≥ 1.6.** This page exists to be read for an hour, not glanced at.

## Output

- Filename: `~/prj/cb/output/cb-<chapter-slug>.html` (slug from chapter title, e.g. `cb-ch07-attitudes.html`)
- Open in browser via `open` (macOS) or `xdg-open` (Linux)
- Tell the user the path and which command produced it. If the page exceeded the length budget, say so and offer follow-up commands.
