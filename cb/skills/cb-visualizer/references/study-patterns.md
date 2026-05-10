# Study Patterns — How to Make Visual Output Actually Teach

This file explains the cognitive-science-backed patterns the skill uses, with HTML/CSS recipes you can copy. The goal is to ensure every page enables **active recall** and **dual-coding**, not just passive reading.

## Why these patterns matter

The empirical record is clear: the techniques that move exam scores are *active recall*, *spaced repetition*, *interleaving*, and *dual-coding*. Highlighting and re-reading don't. So every page this skill produces should give the student something to *do* — answer a hidden question, compare two theories, place a concept on a map — not just something to *look at*.

## Pattern 1 — Cornell layout

Walter Pauk's Cornell method (Cornell University, 1950s) splits a page into a wide notes area, a narrow cue/question column, and a summary band. The cue column is what makes the method work: cover the notes, read a cue, retrieve the answer.

### Minimal HTML scaffold

```html
<article class="cornell">
  <header>
    <h1>Chapter 7 · Attitude Formation and Change</h1>
    <p class="meta">Source: Schiffman & Wisenblit (12e) · Notes: 2026-05-06</p>
    <button id="hide-all">Hide all answers</button>
  </header>

  <main class="cornell__body">
    <aside class="cornell__cues">
      <details><summary>Define an attitude.</summary>
        <p class="cue-answer">A learned predisposition to behave in a consistently favourable or unfavourable way toward a given object.</p>
      </details>
      <!-- one <details> per cue, aligned with the notes block on the right -->
    </aside>

    <section class="cornell__notes">
      <!-- bullets, mini diagrams, definitions, examples -->
    </section>
  </main>

  <footer class="cornell__summary">
    <h2>Summary</h2>
    <p>3-5 sentences in your own words.</p>
  </footer>
</article>
```

### CSS skeleton

```css
.cornell {
  max-width: 297mm;
  margin: 2rem auto;
  padding: 2rem;
  background: #faf7f5;
  color: #1a1a1a;
  font-family: "IBM Plex Sans", system-ui, sans-serif;
  font-size: 16px;
  line-height: 1.65;
}
.cornell__body { display: grid; grid-template-columns: 28% 72%; gap: 2rem; }
.cornell__cues details { padding: 0.5rem 0; border-bottom: 1px solid rgba(0,0,0,0.08); }
.cornell__cues summary { font-weight: 600; cursor: pointer; color: #c2410c; }
.cornell__cues .cue-answer { margin-top: 0.5rem; font-size: 0.95em; color: #444; }
.cornell__summary { margin-top: 2rem; padding: 1rem 1.25rem; border-left: 4px solid #c2410c; background: #fff; }
```

### Cue authoring rules

A cue is a **question that forces retrieval**, not a topic label. Compare:

- ❌ "Attitudes" (a label — gives away nothing to retrieve)
- ✅ "Define an attitude." (forces retrieval)
- ✅ "What are the three components of an attitude?" (forces structured retrieval)
- ✅ "Compare the tri-component and multi-attribute attitude models." (forces synthesis)

Rotate question forms across the page: define, list, compare, explain why, give an example. Mixing forms is what spaced-repetition researchers call *interleaving*, and it improves transfer to novel exam questions.

## Pattern 2 — Dual-coding pairings

Allan Paivio's dual-coding theory: words + images outperform either alone for recall. The skill's job is to ensure every load-bearing concept has both.

| Concept type | Word channel | Image channel |
|---|---|---|
| Definition | The textbook definition | A small icon or sketch capturing the concept (no emoji — use inline SVG or a tiny conceptual diagram) |
| Process model | Stage names + verbs | A flowchart with arrows |
| Hierarchy | Levels named | Pyramid or nested boxes (CSS) |
| Comparison | A table of dimensions | Coloured dots or icons in cells for at-a-glance scanning |
| Cause-effect | "X causes Y because Z" | Arrow with the label |
| Example | A real or invented case | A photograph (if available) or a labelled scene description |

When in doubt: if a section has only words, you've failed the dual-coding test. Add a diagram, a table, or at minimum a coloured highlight that visually maps the structure.

## Pattern 3 — Active-recall question stems by Bloom level

Roughly mapped to Bloom's taxonomy. Use higher levels for postgraduate audiences; mix all levels for undergrad.

- **Remember**: Define …, List …, Identify …, State the …, What is the …
- **Understand**: Explain …, Summarise …, Why does …, In your own words, …
- **Apply**: How would you use …, Apply X to this case, Show how …
- **Analyse**: Compare X and Y, What's the difference between …, Why is X criticised for …
- **Evaluate**: Which model better explains …, What's the weakness of …, Which would you recommend and why
- **Create**: Design a marketing campaign that uses …, Propose a research study to test …

Aim for at least one question from "Apply" or higher on every chapter page — the Remember-only pages don't move exam scores enough to be worth the effort.

## Pattern 4 — Spaced-repetition export (two-format pattern)

Flashcards have two audiences: the **student** (who reads them on the page during revision) and the **import tool** (Anki / Mochi / RemNote, which needs strict one-card-per-line TSV). One representation can't serve both well — long answers clip in monospace blocks, but wrapping the TSV breaks the import format. Render both:

### 4a. Readable cards list (primary)

A styled list of cards above the import block. This is what the student actually reads. Each card is its own row with the question on the left and answer on the right (or stacked on narrow screens). Long German/multilingual answers wrap naturally. No clipping.

```html
<section class="flashcards">
  <header class="flashcards__head">
    <h2>Flashcards</h2>
    <button class="flashcards__hide-all" type="button">Hide all answers</button>
  </header>
  <ol class="flashcards__list">
    <li class="flashcard">
      <details>
        <summary class="flashcard__q">Define an attitude.</summary>
        <p class="flashcard__a">A learned predisposition to behave in a consistently favourable or unfavourable way toward a given object.</p>
      </details>
    </li>
    <!-- one <li> per card -->
  </ol>
</section>
```

```css
.flashcard { padding: 0.85rem 1rem; border-bottom: 1px solid rgba(0,0,0,0.08); }
.flashcard__q { font-weight: 600; cursor: pointer; color: var(--accent); }
.flashcard__a { margin-top: 0.5rem; font-size: 0.97em; color: var(--text); line-height: 1.6; }
.flashcard summary { list-style: none; }
.flashcard summary::after { content: "  ▾"; opacity: 0.5; }
.flashcard[open] summary::after { content: "  ▴"; }
```

Each card is a `<details>` so the student can hide the answer and force retrieval. The "Hide all answers" button at the top closes every `<details>` at once via JS — single most useful affordance for active recall. Aim for 12-20 cards per chapter.

### 4b. Anki/Mochi import block (secondary, collapsed)

After the readable list, in a collapsed `<details>` block, emit the raw TSV. **Critical CSS**: keep `white-space: pre` (not `pre-wrap` — wrapping breaks the import format) and add `overflow-x: auto` so long German lines scroll horizontally instead of clipping. Add a "Copy" button that copies the raw text to clipboard.

```html
<details class="flashcards__import">
  <summary>Anki / Mochi import (TSV, separator <code>;</code>)</summary>
  <div class="import-actions">
    <button type="button" data-copy-target="#anki-tsv">Copy</button>
    <small>Paste into Anki → File → Import. Field separator: <code>;</code></small>
  </div>
  <pre id="anki-tsv"><code>Frage;Antwort
Was illustriert die Praxis-Episode mit Sophie und Max?;Selektive Wahrnehmung: gleicher Ort, andere Reize beachtet — Aufmerksamkeit + Involvement steuern, was ins Gedächtnis gelangt.
Erkläre den Unterschied zwischen S-R- und S-O-R-Modell.;S-R: Stimulus löst direkt Reaktion aus. S-O-R: Organismus zwischengeschaltet — innere mentale Prozesse moderieren die Reaktion.
</code></pre>
</details>
```

```css
.flashcards__import pre {
  /* one card = one line; never wrap or the import breaks */
  white-space: pre;
  /* but DO let the user scroll horizontally to read long German answers */
  overflow-x: auto;
  max-width: 100%;
  padding: 1rem 1.25rem;
  background: #1a1a1a;
  color: #f5d27a;
  font-family: "IBM Plex Mono", ui-monospace, monospace;
  font-size: 0.85rem;
  line-height: 1.55;
  border-radius: 6px;
}
.flashcards__import code { white-space: inherit; }
.import-actions { display: flex; gap: 0.75rem; align-items: center; margin: 0.5rem 0; }
```

The two-format pattern matters because the readable list teaches retrieval *now*, while the import block extends that retrieval into spaced-repetition *later*. Without the readable list, the student has to mentally parse semicolons. Without the import block, they re-read instead of using SRS — and the evidence on re-reading is bleak.

### 4c. Card-authoring rules

- **One concept per card.** "List the three components of the tri-component attitude model" is fine; "Explain attitudes and intentions and TPB" is not — split it.
- **No semicolons in the answer text.** Replace with em-dashes or commas. A semicolon in the answer breaks the import.
- **Atomic answers ≤ 200 characters.** Longer answers don't fit on a flashcard and should be re-decomposed into multiple cards.
- **Match the page's language.** If the page body is German (matching exam phrasing), the cards are German. If the user explicitly wanted bilingual cards, render two cards per concept — one DE, one EN — not a mixed answer.

## Pattern 5 — Aesthetic that signals "study material"

The visual language of academic study notes is constrained for good reason. Apply these defaults unless the user overrides:

- **Background**: warm cream `#faf7f5` (paper-ink) or off-white `#fafaf9`. Not white. White feels like a screen; cream feels like paper and reduces glare on long reads.
- **Body type**: a humanist serif for reading (Crimson Pro, Source Serif, Bitter) or a quality humanist sans (IBM Plex Sans, DM Sans). Body size ≥ 16px, line-height ≥ 1.6, max line length ~70ch.
- **Headlines**: Instrument Serif, EB Garamond, Crimson Pro for editorial. Bricolage Grotesque or Plus Jakarta Sans for a more modern feel. Never Inter, Roboto, Arial.
- **Accents**: one or two colours, used for cues, callouts, and section borders only. Terracotta `#c2410c`, sage `#65a30d`, deep navy `#1e3a5f`, gold `#d4a73a` are the safe academic palette. Avoid violet/indigo defaults.
- **No shadow on cards**, no gradients, no glow. The page should look like it could be printed and given to a student in a tutor's office.
- **No emoji** in headers. Use a numbered badge (`section__num`) or a coloured dot.

## Pattern 6 — Question slides for exam prep

The exam-prep deck's Q&A slides need to enforce retrieval before reveal. The pattern:

```html
<section class="slide slide--qa" data-slide-type="qa">
  <div class="slide__question">
    <small>Question 7 · Tests: Howard-Sheth stage identification</small>
    <h2>A consumer is buying a new laptop for the first time and is comparing six brands. Which level of problem-solving best fits?</h2>
  </div>
  <button class="slide__reveal" aria-expanded="false">Reveal answer</button>
  <div class="slide__answer" hidden>
    <p>Extensive problem-solving — the consumer has no brand comprehension and is heavily searching and comparing.</p>
  </div>
</section>
```

The reveal button matters. Showing the answer alongside the question converts retrieval into recognition, and recognition is far weaker for retention. Force the click.

## Pattern 7 — When to suggest the next command

After delivering, suggest the natural next step:

- After `summarize-chapter`: "Want a slide deck for last-minute revision? Run `/cb-visualizer:exam-prep`."
- After `explain-chapter`: "Want a 1-page cheat sheet too? Run `/cb-visualizer:summarize-chapter`."
- After `model-deep-dive` on one model: "Want to compare this with [adjacent model]? Run `/cb-visualizer:compare-theories`."
- After `concept-map`: "Want to drill into one of these branches? Run `/cb-visualizer:model-deep-dive [name]`."

This is what makes the skill feel like a coherent study system rather than a grab-bag of one-shot generators.
