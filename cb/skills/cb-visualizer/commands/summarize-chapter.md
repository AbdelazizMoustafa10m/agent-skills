---
description: Generate a Cornell-style 1-page exam-ready HTML summary of a chapter
---

Load `cb-visualizer`, then generate a Cornell-format 1-page summary for: $@

If the input is a PDF, follow the TOC-first protocol from SKILL.md. Read `./references/study-patterns.md` (Cornell HTML scaffold, cue authoring rules) and `./references/css-patterns.md` (typography, depth tiers) before composing.

The Cornell method (Walter Pauk, Cornell University) splits a page into three zones — a wide notes area, a narrow cue/question column, and a summary band. It works because the cue column is built for active recall: cover the notes, read a cue, retrieve the answer. Your job is to render this on a single HTML page that fits one viewport when printed at A4 landscape.

## Page layout

```
┌──────────────────────────────────────────────────────────────┐
│  Chapter title · Source · Date                               │
├──────────┬───────────────────────────────────────────────────┤
│          │                                                   │
│  CUES    │  NOTES                                            │
│ (25-30%) │  (70-75%)                                         │
│          │                                                   │
│  retrieval│  - bullets, definitions, models                  │
│  questions│  - small inline diagrams (Mermaid OK)            │
│  + key    │  - tables for comparisons                        │
│  terms    │  - one example per concept                       │
│          │                                                   │
├──────────┴───────────────────────────────────────────────────┤
│  SUMMARY  (3-5 sentences in plain language, your synthesis)  │
└──────────────────────────────────────────────────────────────┘
```

## Content rules

- **Right column (notes)** holds the substance: definitions, model stages, named theories with attribution, the textbook's example for each, and small inline diagrams. Use sub-headings that match the chapter's section titles. Bullets, not paragraphs. Inline Mermaid diagrams are encouraged for models — keep them small (≤ 6 nodes) since they share space with text.
- **Left column (cues)** is *not* a list of topics. It's a list of **questions** that force retrieval. Good cue forms: "Define X.", "What are the N stages of …?", "Compare X and Y.", "Why does …?", "Give an example of …". Aim for 8-15 cues per page. Each cue should align horizontally with the part of the notes that answers it — when the student covers the notes, the cue must still make sense alone.
- **Summary band** is your synthesis in 3-5 sentences. Not a list of topics covered — an actual answer to "what was this chapter about and why does it matter?". This is the comprehension check; if you can't write the summary in plain language, you don't understand the chapter yet.

## Aesthetic

Editorial by default — paper-feel cream background `#faf7f5` or off-white `#fafaf9`, deep ink body text, single accent colour (terracotta `#c2410c` or deep navy `#1e3a5f`) used only for cue questions and the summary border. No card shadows. The page should feel like a printed study sheet, not a web app.

## Active-recall affordance

Wrap each notes block in a `<details>` element keyed off the cue, so the student can hide the notes and try to answer from the cue alone. Include a "Hide all answers" toggle button at the top that closes every `<details>` at once. This single feature is what separates a Cornell summary from a poster.

## Spaced-repetition: in-page flip-cards (primary) + import block (secondary)

Past iterations of this skill emitted a giant black `<pre>` block of `Question;Answer` lines for Anki/Mochi import. That dominated the page visually, broke the editorial aesthetic, and was useless for any student who doesn't already use a spaced-repetition tool. **Don't do that anymore.** Render two layered affordances instead:

1. **In-page flip-cards (primary).** After the summary band, render a `Flashcards` section with a responsive grid (`grid-template-columns: repeat(auto-fit, minmax(260px, 1fr))`) of clickable cards — one per cue. Each card shows the **question on the front**; clicking (or pressing Space/Enter when focused) toggles to reveal the **answer on the back**. Use a CSS 3D flip (`transform: rotateY(180deg)` on `.is-flipped`, `transform-style: preserve-3d`, `backface-visibility: hidden`) or, if 3D feels too playful for the editorial tone, a simple swap that hides Q and shows A in place. Either way: keep the cards on the same cream paper, with a soft border and a small uppercase chip — `Frage` on the front, `Antwort` on the back (translate via the `language` knob). Add two toolbar buttons above the grid: `Alle umdrehen` and `Alle zurücksetzen`. Cards must be `<button>` elements (or have `role="button"`, `tabindex="0"`, keyboard handlers) so the page is keyboard- and screen-reader-accessible.
2. **Anki / Mochi import block (secondary).** Below the flip-card grid, place a *collapsed* `<details>` element with summary text like `Als Anki / Mochi importieren — anzeigen`. Inside, render the same Q/A pairs as a `<pre>Question;Answer</pre>` text block plus a one-line hint about how to import. This keeps the import-friendly format available without making it the visual centerpiece.

Atomicity rule: one cue → one flip-card → one import line. The card content should mirror the cue and the answer the student should be able to retrieve from the matching notes block. Aim for the same 8–15 count as the cue column; if the chapter is unusually large you may include a few additional sub-questions, but never split a single concept into multiple cards.

## Output

- Filename: `~/prj/cb/output/cb-<chapter-slug>-summary.html`
- Open in browser
- Print preview should fit on one A4 page in landscape — verify by sizing the page-level container with `max-width: 297mm; aspect-ratio: 297 / 210;`
