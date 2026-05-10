---
name: cb-visualizer
description: Turn raw textbook chapter content (including PDFs) into digestible visual study material — concept maps, model flowcharts, comparison tables, Cornell-style summaries, and exam-prep slide decks. Use whenever the user pastes or points to a chapter, PDF, lecture transcript, lecture slides, or set of notes about consumer behaviour, marketing, or another social-science topic and asks to "summarize", "explain", "study", "make a mind map", "compare theories", "prep for the exam", "analyse the case", or simply asks to make sense of dense academic text. Handles multi-language source material (German Skripts, English textbooks, etc.) and reads PDFs directly via the Read tool. Tuned by default for Consumer Behaviour but the `subject` knob retargets every command to other subjects (microeconomics, organizational behaviour, psychology, etc.) without code changes. Always prefer this skill over generic summarization when the input is a textbook chapter or a study-oriented question — it produces rendered HTML pages, not chat-window prose.
license: MIT
metadata:
  author: zizo
  version: "0.2.0"
  upstream: nicobailon/visual-explainer (skeleton bundled — see NOTICE.md)
  subject: "consumer behaviour"
  audience: "undergraduate / exam prep"
  language: "en"
  default_aesthetic: "editorial"
---

# CB Visualizer — Study Notes That Argue Visually

This skill is **fully self-contained**. It bundles the rendering skeleton from `nicobailon/visual-explainer` (MIT) — the four reference HTML templates, the CSS patterns library, the Mermaid/Chart.js theming guide, the responsive-nav pattern, and the slide engine — and layers a Consumer Behaviour pedagogy on top of it.

When generating any HTML page, **read the relevant bundled template first** (in `./templates/`) and the relevant reference (in `./references/`) — don't generate from memory. The templates encode hard-won decisions about typography, theme variables, Mermaid containers with zoom/pan, and responsive layout that you should not try to recreate.

## When to use which command

The user rarely asks for the right command by name. Map intent to command:

| User says… | Run |
|---|---|
| "summarize / make notes / digest this chapter" | `commands/summarize-chapter.md` (1-page Cornell HTML) |
| "explain this chapter / break it down / walk me through it" | `commands/explain-chapter.md` (multi-section visual page) |
| "mind map / concept map / show me how it all connects" | `commands/concept-map.md` (Mermaid `mindmap`) |
| "explain the [Howard-Sheth / EKB / Maslow / …] model" | `commands/model-deep-dive.md` |
| "compare X and Y / which model …" | `commands/compare-theories.md` (data table) |
| "I have an exam / quiz me / flashcards / cram" | `commands/exam-prep.md` (slide deck + Q&A) |
| "apply this to [case]" or pastes a case | `commands/case-study.md` |

If the user just pastes raw chapter text without a verb, default to **`explain-chapter`** — it's the most useful starting point.

## Customization knobs (frontmatter)

The frontmatter `metadata` block is intentionally a configuration surface. You do **not** need to fork the skill to retarget it:

- **`subject`** — controls vocabulary, which canonical models in `references/cb-models.md` are loaded, and the kind of examples to invent. For non-default subjects, look for `references/<subject>-models.md` first; if absent, gracefully fall back to extracting models *from the source text itself* and tell the user no curated reference exists yet.
- **`audience`** — `undergraduate` keeps language plain and adds analogies; `postgraduate` keeps citations and methodological caveats; `exam prep` strips theory it can't be tested on and amplifies definitions, common traps, and exam-style questions.
- **`language`** — produced output language. Definitions and exam questions translate; model names stay canonical (Howard-Sheth, EKB) since that's what graders will recognise.
- **`default_aesthetic`** — `editorial` (serif headlines, generous whitespace, deep navy + gold) is the safe default for academic material. `paper-ink` (warm cream `#faf7f5`, terracotta + sage) is the alternative. **Never use** software-themed aesthetics (Blueprint, IDE-inspired, Terminal, Neon Dashboard) — they reframe academic content as engineering and confuse students.

When the user says "use editorial" or "make it warmer / more like paper", they're flipping this knob. Apply it without re-asking.

See `references/customization.md` for retargeting to other subjects in detail.

## Reading source material

Source material can arrive as raw pasted text, file paths, URLs, or — most commonly for university courses — PDFs (Skripts, lecture handouts, scanned book chapters).

### PDFs

Use the `Read` tool with the `pages` parameter. The tool reads PDFs natively but caps each call at 20 pages. For anything bigger than 10 pages you must specify pages explicitly (e.g. `pages: "1-20"`).

For long Skripts (50+ pages, often 100-200 pages of compiled course material), follow the **TOC-first protocol**:

1. **Index pass** — read pages 1-5 to find the table of contents / Inhaltsverzeichnis. Capture chapter boundaries (start page → end page) into a working list. Don't try to summarise yet.
2. **Confirm scope with the user** — show the chapter list, ask which chapter (or chapters) to work on now. Don't process the whole Skript silently — students study chapter by chapter, and a 150-page super-summary is useless.
3. **Per-chapter pass** — for the selected chapter(s), read the actual page range in 20-page chunks. Concatenate mentally into the chapter's full text, *then* run the requested command on it.
4. **Page-citation discipline** — when the page produces a definition or a model, cite the source page in small caption text under the visual (e.g. "Skript S. 47"). Students cross-reference back to the original. This isn't decoration — it's pedagogically essential.

### Multi-language sources

Course material is often German, French, Spanish, etc. even when the student wants English notes. Detect the source language from the first chunk read. By default:

- **Definitions and named-theory blocks** — keep the original-language version *and* provide an English (or `language` knob) translation underneath. The student needs both: the German version for matching the exam phrasing, the English for understanding.
- **Model names** — keep canonical English names (Howard-Sheth, EKB, Theory of Planned Behavior) since that's what every academic source uses regardless of the textbook's language.
- **Cue questions and summaries** — produce in the `language` knob's value (default English).
- **The page's body language** — match `language`. If the user wants German output (for a German-language exam), set `language: de` and produce headings, summary, and cue questions in German.

If the user pastes German text and asks for "study notes in English", flip naturally — translate definitions, keep terms.

## Workflow (every command builds on this)

### 1. Read the source like a student, not a parser

Before generating anything, read the entire input and answer four questions in your head:

1. **What is this chapter actually about?** One sentence. If you can't, you don't understand it yet — re-read.
2. **What models, frameworks, or named theories appear?** List them. Cross-reference against `references/cb-models.md` — if a model is in the canon, you have a curated way to draw it. If it's novel to this textbook, extract its structure from the prose.
3. **What examples does the textbook use?** Keep them. Students remember "the family planning a Hawaii vacation" longer than abstract definitions. Real examples beat invented ones.
4. **What would a professor actually test?** Definitions, model stages, distinctions between competing theories, application to cases. Anchor the visual output around testable knowledge.

### 2. Choose the visual treatment per content type

This is where most "AI summaries" fail — they pick one format (usually bullets) and apply it to everything. Map content type to format intentionally:

| Content type | Visual treatment | Why |
|---|---|---|
| Process model with stages (EKB, AIDA, customer journey, adoption curve) | Mermaid `flowchart TD` with named stages and feedback loops | Linear stages with arrows is *exactly* what flowcharts are for |
| System model with internal/external variables (Howard-Sheth, Black Box, Bettman) | Mermaid `flowchart TD` with `subgraph` boundaries for input / process / output | Subgraphs visually argue "this is inside the consumer's mind, this isn't" |
| Hierarchy or taxonomy (Maslow's needs, types of involvement, segmentation bases) | Mermaid `mindmap` or pyramid CSS | Hierarchy *is* the meaning |
| Competing theories | HTML data table with rows = dimensions (focus, year, key insight, criticism, when to apply) | Enables side-by-side scanning, the way exams demand it |
| Definitions / key terms | Glossary table with sticky header + bolded term | Searchable, copy-pasteable for flashcards |
| Cause–effect, conditioning (Pavlov, Skinner) | Mermaid `flowchart LR` with labeled arrows for stimulus / response / reinforcement | The directionality is the lesson |
| Self-test / exam questions | Cornell-style two-column layout (cue → answer) with answers collapsed by default | Forces active recall, not passive re-reading |
| Real-world cases | Lead paragraph with the case, then a flowchart showing how a theory applies, then a callout with the lesson | Mirrors how case-method exams are graded |

### 3. Apply pedagogy, not just design

Three principles that separate study material from decoration:

- **Dual-coding** — pair every key idea with a visual. A definition next to its diagram. A model name next to its flowchart. The cognitive science is settled: words + images outperform either alone for retention.
- **Active recall over passive review** — every page should give the student something to *do*: a question to answer, a comparison to make, a blank to fill. Pages they read once and never return to are worth less than pages that quiz them.
- **Spaced-repetition-friendly atomicity** — produce content in chunks small enough to become single flashcards. One concept per card. The exam-prep command should explicitly emit a list of flashcard-ready Q/A pairs at the bottom.

See `references/study-patterns.md` for the Cornell-format HTML template, dual-coding pairings, active recall question stems, and spaced-repetition export format.

### 4. Aesthetic constraints (non-negotiable)

These are the "don'ts" that make academic study material look academic:

- **No emoji icons in section headers**, ever. They make textbook material look like a TikTok carousel and signal "AI generated this".
- **No software/IDE framing**. Don't call sections "modules", don't show three-dot terminal chrome on quote blocks, don't use `mono` font for body text. The reader is studying psychology, not reading a README.
- **No gradient text** on headings, no glowing shadows, no neon palettes. Editorial means restraint.
- **Citations matter**. When the source attributes an idea to "Howard and Sheth (1969)" or "Maslow (1943)", carry the citation through to the visual. Removing it makes the page feel like a Wikipedia summary instead of study material.
- **Body type ≥ 16px and line-height ≥ 1.6.** Students read these pages for hours. AI-default 14px is hostile.

### 5. Deliver

This skill is **project-scoped to `~/prj/cb/`** — it is only available when Claude Code runs inside that project (linked via `.claude/skills/cb-visualizer`). All output stays inside the project alongside the source PDFs.

Write to `~/prj/cb/output/cb-<chapter-slug>.html` (or `cb-<chapter-slug>-deck.html` for slide output). The `output/` directory is the canonical location and already exists — create it if missing. Open in browser:

- macOS: `open ~/prj/cb/output/<filename>`
- Linux: `xdg-open ~/prj/cb/output/<filename>`

If running from a different working directory than `~/prj/cb`, still write to the absolute path `~/prj/cb/output/` — never to `~/.agent/diagrams/`, the current working directory, or anywhere else.

Tell the user the file path and which command generated it.

If the user asked for "all of it" or pastes a long chapter without a specific verb, generate **two** outputs in sequence: a `summarize-chapter` 1-pager *first* (so they have something usable in 30 seconds) followed by `explain-chapter` for depth.

## Available commands

Each is documented in `./commands/`:

- `explain-chapter.md` — multi-section visual page that walks through the whole chapter
- `summarize-chapter.md` — Cornell-style single-page summary, exam-ready
- `concept-map.md` — Mermaid mindmap of every key term and how they relate
- `model-deep-dive.md` — single model rendered as flowchart + definition + example + criticism
- `compare-theories.md` — comparison table across N theories on dimensions that matter
- `exam-prep.md` — slide deck with definitions, examples, common traps, and Q&A
- `case-study.md` — apply theories from the chapter to a real or hypothetical case

## References (subject-pedagogy layer)

- `references/cb-models.md` — canonical Consumer Behaviour models with ready-to-paste Mermaid templates and the standard structure for each (definition, diagram, example, criticism, exam questions)
- `references/study-patterns.md` — Cornell HTML template, dual-coding pairings, active-recall question stems by Bloom level, spaced-repetition flashcard export format
- `references/customization.md` — how to retarget the skill for other subjects (microeconomics, OB, psychology) by adding a new `references/<subject>-models.md` and tweaking the `subject` frontmatter knob

## References (rendering skeleton, bundled from visual-explainer MIT)

Read these *before* generating HTML — they encode the typography, theming, and layout patterns the templates depend on:

- `references/css-patterns.md` — depth tiers (hero / elevated / default / recessed), animations, prose accent elements, link styling, code block patterns, Mermaid container with zoom/pan, overflow protection
- `references/libraries.md` — Mermaid theming (`themeVariables`, ELK layout, font scaling), Chart.js setup, font pairings (DM Sans + Fira Code, IBM Plex Sans + IBM Plex Mono, Instrument Serif + JetBrains Mono, etc.)
- `references/responsive-nav.md` — sticky sidebar TOC for desktop, horizontal scrollable nav for mobile (use for any chapter page with 4+ sections)
- `references/slide-patterns.md` — slide engine CSS, the 10 slide types, transitions, the 4 slide presets (Midnight Editorial, Warm Signal, Terminal Mono, Swiss Clean — never Terminal Mono for academic material)

## Templates (bundled, MIT)

Read the matching template before generating HTML. Don't compose page CSS from scratch — start from the right template and modify:

- `templates/architecture.html` — CSS Grid cards with palette and depth tiers (use for Black Box, multi-component models, dashboard-style chapter overviews)
- `templates/mermaid-flowchart.html` — Mermaid container with full zoom/pan/expand controls, ELK layout, theme variables (use for *every* model deep-dive, decision-process diagram, and concept map)
- `templates/data-table.html` — sticky header tables with status indicators and KPIs (use for `compare-theories`, glossaries, exam Q&A summary tables)
- `templates/slide-deck.html` — slide engine for `exam-prep` — 10 slide types, navigation, presets

The templates use software-domain examples in their content (architecture diagrams, code review). **Use the layout, CSS variables, and structure — replace the example content with consumer-behaviour material.**

## Quality checks before delivering

- **The cover-and-recall test**: cover the right column of the page. Can the student answer the cue questions on the left? If no cue questions exist, the page is a poster, not study material.
- **The professor test**: would a professor recognise this as faithful to the source? Invented definitions, mis-attributed models, and dropped citations all fail this test.
- **The exam test**: pick three plausible exam questions for this chapter. Could the student answer them using only this page? If not, what's missing?
- **The aesthetic test**: does it look like academic material, or like an AI-generated landing page? If a Roboto/Inter font, gradient text, or emoji icon snuck in, regenerate.
