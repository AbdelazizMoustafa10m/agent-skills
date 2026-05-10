# Customization — Retargeting the Skill to Other Subjects

The skill is built around a `subject` knob in `SKILL.md`'s frontmatter. Flipping it from `consumer behaviour` to `microeconomics`, `organizational behaviour`, `cognitive psychology`, or any other study subject should *just work* for `summarize-chapter`, `concept-map`, `compare-theories`, `exam-prep`, and `case-study` — those commands are subject-agnostic by design. Only the model-specific knowledge (in `cb-models.md`) is hard-coded.

There are three retargeting paths, in order of effort:

## Path 1 — One-off override (zero edits)

The user invokes a command and tells the model in-prompt to treat the input as a different subject:

```
/cb-visualizer:summarize-chapter Treat this as Chapter 3 of an Organizational Behaviour textbook (not Consumer Behaviour). Source:

<paste chapter>
```

The skill's commands respect that framing. Use this when the user has occasional cross-subject material and doesn't want a separate skill.

## Path 2 — Per-conversation knob flip

Override the `subject` (and optionally `audience`, `default_aesthetic`) at the start of a conversation:

```
For this session, run cb-visualizer with:
  subject: microeconomics
  audience: postgraduate
  default_aesthetic: paper-ink
```

The model treats those as the active configuration for the conversation. This is the right path when the user is studying a different subject for an entire session but doesn't want to fork the skill.

## Path 3 — Add a curated reference for the new subject (recommended for ongoing use)

The most powerful path — and the one that makes the skill substantially better for the new subject — is to add a `references/<subject>-models.md` file alongside `cb-models.md`. The format is identical:

```
# Canonical <Subject> Models

## Table of contents
1. [Model name (year)](#anchor)
...

## Model name (year)

**Originator(s)**: …
**One-line claim**: …
**Best applied to**: …

### Key constructs / stages
- …

### Mermaid template

\`\`\`
flowchart TD
  …
\`\`\`

### Standard criticisms
- …

### Exam-ready questions
- …
```

Then update `SKILL.md`'s frontmatter `subject:` to the new subject. The `model-deep-dive` and `compare-theories` commands automatically prefer the curated reference over invented content.

### Examples of subjects that fit the existing scaffolding

- **Microeconomics** — supply/demand curves, elasticity, consumer surplus, indifference curves, game theory matrices. Canonical models: utility maximisation, marginal analysis, prisoner's dilemma, Bertrand vs Cournot competition.
- **Organizational Behaviour** — motivation theories (Maslow, Herzberg, McGregor X/Y, Vroom expectancy), group dynamics (Tuckman stages), leadership models (situational leadership, transformational vs transactional), organisational culture (Schein levels, Hofstede dimensions).
- **Cognitive Psychology** — memory models (Atkinson-Shiffrin, Baddeley working memory), attention (Broadbent filter, Treisman attenuation), decision-making (dual-process / Kahneman System 1/2, prospect theory), learning (classical, operant — already in cb-models.md).
- **Marketing Strategy** — Porter's Five Forces, BCG matrix, Ansoff matrix, STP, 4Ps/7Ps, AIDA, customer journey, RACE framework.
- **Strategic Management** — VRIO, PESTEL, SWOT, value chain, generic strategies, Mintzberg's 10 schools.
- **International Business** — Hofstede's cultural dimensions, Trompenaars, GLOBE, Uppsala internationalisation model, Dunning's eclectic paradigm.
- **Sociology** — functionalism / conflict theory / symbolic interactionism, Bourdieu's capital, Goffman's dramaturgy.

For any of these, building a curated `<subject>-models.md` takes 1-2 hours and pays back every subsequent study session.

## What stays the same regardless of subject

- The Cornell layout in `summarize-chapter`
- The dual-coding rule (every concept gets a visual)
- The active-recall question stems by Bloom level
- The spaced-repetition export format
- The aesthetic constraints (no emoji headers, body ≥ 16px, no software framing, citations preserved)
- The "deliver a 1-pager fast then a deep page" two-step when a chapter is pasted without a verb

## What needs subject-specific tuning

- The list of models in `references/<subject>-models.md`
- The diagram type defaults — e.g. economics defaults to graphs (Chart.js for supply/demand, indifference curves) more than CB does
- The example pool — the cultural register of "the family booking a Mexico vacation" doesn't transfer to econometrics

## Anti-patterns when retargeting

- **Don't** rewrite the SKILL.md commands. They're subject-agnostic on purpose.
- **Don't** delete `cb-models.md` when adding a new subject — keeping multiple curated references in the same skill is fine and useful for cross-subject students.
- **Don't** invent diagrams for models you can't verify from the source. Mark reconstructions clearly.
- **Don't** import software-development aesthetic conventions (terminal windows, IDE chrome, code-block dot chrome on quotes) into humanities/social-science material.

## When a separate skill makes more sense

If you find yourself maintaining 4+ curated subject references in one skill and the SKILL.md grows to accommodate subject-specific quirks (different default diagrams, different citation styles, different audience profiles), fork into per-subject skills (`oh-visualizer`, `econ-visualizer`, etc.) sharing a common parent style guide. The cost of a new skill is low and the cost of an overgrown SKILL.md is high.
