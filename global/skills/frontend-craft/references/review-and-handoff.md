# Review and Handoff

For audits, significant revisions, and pre-ship validation. Evidence beats scoring theater
— a prioritized backlog with file/line citations is more useful than a number out of 100.

## Inspection order

1. Confirm target, route, code ownership, and the requested scope.
2. Read existing tokens, components, copy sources, and the relevant implementation.
3. Inspect a rendered surface/screenshot when possible, at ≥1 narrow and 1 wide width.
4. Trace the primary interaction with keyboard and relevant pointer/touch behavior.
5. Apply the accessibility gates (see `accessibility-gates.md`) **before** aesthetics.
6. Check direction, structural clarity, truthful content, states, motion, assets,
   responsive behavior, and performance risk.
7. Run the repo's focused validation, or state why it was unavailable.

## The AI-slop / anti-pattern checklist

These are the concrete "tells" that mark a UI as generic machine output. Flag a pattern
**only when it weakens *this* interface** — context decides. (Conventional product
patterns, a single font family, a centered layout, or a familiar color are *not* faults
without evidence they harm purpose, usability, or the originality a brand surface needs.)

Visual tells:

- Inter / Roboto / Arial / system default as the *brand* face on a brand surface (fine in
  product UI for performance).
- **Any purple/violet or pale "baby blue"** — as gradient, accent, brand color, CTA, focus
  ring, or chart series. The purple→blue gradient is the single most common AI signature,
  but solid violet (`#7c3aed`-style) and pale blue (`#8fc0ff`-style) are out too. This is a
  hard default (see Palette preference in `direction-and-systems.md`) — flag it as P2 system
  drift whenever it appears without an explicit brand mandate.
- Pure black (`#000`) or pure gray (`oklch(_ 0 _)`) for large areas — real surfaces carry a
  tint (chroma ≥ ~0.005).
- Gray text on a colored background — looks washed out and dead; use a darker shade of the
  background hue or a transparency.
- Everything wrapped in a card; cards nested inside cards.
- A rounded-square icon tile stamped above every heading.
- Emoji used as UI icons (use an SVG set — Lucide, Heroicons, Phosphor).
- Side-tab colored left borders and ambient dark "glow" boxes.
- Bounce/elastic easing; animation on everything.

Structural / content tells:

- The same hero → 3 equal feature cards → testimonial → CTA skeleton regardless of brief
  (see macrostructure variety in `direction-and-systems.md`).
- Repeated equal-weight cards where the information actually has hierarchy.
- Invented metrics, logos, testimonials, screenshots, or unsupported claims.
- Lorem ipsum or "Welcome to your dashboard!" filler copy.

Quality tells:

- Raw one-off styling that bypasses the established token/component system.
- Low contrast, invisible focus, hover-only actions, ambiguous controls, missing
  loading/empty/error states.
- Cramped padding, lines longer than ~75ch, skipped heading levels, touch targets under
  the 24px AA floor.

## Severity

| Level | Meaning | Example |
| --- | --- | --- |
| P0 | Blocks the primary task, security, or safe use. | Cannot submit or escape a required flow. |
| P1 | Release-blocking usability/accessibility defect. | Keyboard-inoperable action, missing visible focus, failing required contrast. |
| P2 | Material quality or maintainability defect. | Broken narrow layout, missing loading/empty state, system drift. |
| P3 | Polish with limited user harm. | Minor rhythm or optical-alignment correction. |

## Audit report shape

Lead with findings, ordered P0→P3. For each:

```markdown
**[P1] Short finding title** — `path/to/file:line` or rendered target
Impact:   which user/task is affected and how
Evidence: what was observed or measured
Fix:      the concrete correction
Standard: WCAG anchor or project/design-system rule, when applicable
```

Then: concrete positives worth preserving; assumptions/evidence gaps (unrendered surfaces,
unmeasured contrast); and the validation actually performed. Avoid a numeric design-health
score unless the user explicitly wants one.

## Pre-delivery checklist

Walk this before declaring an implementation done. It's the floor, not the ceiling:

- [ ] Real content — no invented metrics, logos, testimonials, or lorem ipsum.
- [ ] All relevant states present: default, hover, `:focus-visible`, active, disabled,
      loading, error, success, **empty**, long content, narrow viewport.
- [ ] Keyboard: every action reachable and operable; focus order logical; focus visible on
      every surface; no traps.
- [ ] Contrast: body ≥ 4.5:1, large text/UI ≥ 3:1; meaning never carried by color alone.
- [ ] Responsive at ~390px and ~1280px; usable at 200% zoom; no `user-scalable=no`.
- [ ] `prefers-reduced-motion` honored; no bounce/elastic; UI feedback ≤ ~500ms.
- [ ] Icons are SVG (not emoji); icon-only controls have accessible names.
- [ ] `cursor: pointer` on clickable non-link controls; hover/transition 100–300ms.
- [ ] Numbers use `tabular-nums` and are correctly aligned; data is locale-formatted.
- [ ] Typography: ≤ 2–3 families, semantic size tokens, body in `rem`, measure ≤ ~75ch.
- [ ] Color built on semantic roles; neutrals tinted; no pure `#000`/`#fff` flats.
- [ ] No purple/violet and no pale "baby blue" anywhere (unless the brand explicitly mandates it).
- [ ] No layout shift — media/fonts have reserved space; `font-display` set.
- [ ] Reused existing tokens/components; no parallel design system introduced.
- [ ] Lint/typecheck/tests/build for the edited surface pass (or the gap is stated).

## Implementation review loop

After implementing: compare against the direction brief and the existing system; check
semantics, focus, state coverage, contrast, reflow, reduced motion, and content truth;
check hierarchy, spacing rhythm, type measure, asset/icon consistency, and unintended
generic filler; patch material issues and re-render; report which surfaces and commands you
checked.

## Handoff notes

For a completed design-to-code implementation, communicate:

- The direction and the user need it serves.
- Components/tokens/assets added or reused.
- Responsive and interactive states implemented.
- Accessibility evidence and the manual checks still outstanding.
- Build/test/lint results and any unverified risks.

When the user wants to persist a direction, produce a concise `DESIGN.md` in the project's
conventions — name canonical tokens and components and the accessibility commitments,
rather than freezing a one-page visual recipe that will rot.
