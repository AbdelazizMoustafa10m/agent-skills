# Accessibility Gates

Treat WCAG 2.2 Level A and AA as the release floor for web interfaces, then apply stronger
usability recommendations where practical. Do not describe a preferred practice as a
normative WCAG requirement — accuracy matters, because overclaiming erodes trust.

Official references:

- WCAG 2.2 — <https://www.w3.org/TR/WCAG22/>
- Understanding SC 2.4.7 Focus Visible —
  <https://www.w3.org/WAI/WCAG22/Understanding/focus-visible.html>

## Required review gates

| Concern | Release check | WCAG 2.2 anchors |
| --- | --- | --- |
| Structure & text alternatives | Landmarks/headings/labels used correctly; useful alternatives for meaningful non-text content; reading order preserved. | 1.1.1, 1.3.1, 1.3.2 |
| Text contrast | Normal text ≥ 4.5:1; large text (≥18px or 14px bold) ≥ 3:1, per criterion exceptions. | 1.4.3 |
| Component & graphic contrast | Essential component boundaries, states, and meaningful graphics meet 3:1 against adjacent colors. | 1.4.11 |
| Reflow & scaling | Usable without 2-D scrolling at the reflow condition; browser zoom not disabled. | 1.4.4, 1.4.10 |
| Keyboard operation | All functions operable from keyboard without traps; focus order follows task/visual logic. | 2.1.1, 2.1.2, 2.4.3 |
| Visible focus | Every keyboard-operable control has a mode where focus is visible, stays visible, and is not hidden behind sticky UI. | 2.4.7, 2.4.11 |
| Pointer interaction | Non-drag alternative for dragging; targets meet the 24×24 CSS px AA minimum or its exception. | 2.5.7, 2.5.8 |
| Forms & status | Labels/instructions, error identification, accessible name/role/value, and programmatically exposed status messages where needed. | 3.3.1, 3.3.2, 4.1.2, 4.1.3 |

**Target size, stated precisely:** the AA floor (SC 2.5.8) is **24×24 CSS px** with
exceptions. Prefer ~**44×44 CSS px** for important touch controls when layout permits —
that is a *usability target* aligned with the enhanced criterion, not the AA floor. Don't
conflate the two.

## Focus implementation

Never strip outlines without an equally clear replacement. Prefer `:focus-visible` so
keyboard users get an explicit indicator without forcing a ring on every pointer click:

```css
:where(a, button, input, select, textarea, [tabindex]):focus-visible {
  outline: 2px solid var(--focus-ring);
  outline-offset: 2px;
}
```

- Verify the ring against *each* surface where the control appears (it must clear both
  light and dark surfaces, and any colored CTA).
- Keep focused elements visible when sticky headers, cookie banners, or panels overlap —
  use `scroll-margin-top` so anchored focus isn't tucked under a sticky bar.
- Test focus *order* with the keyboard. CSS presence alone does not prove correctness.

## Interaction and content checks

- Use native `<a>`, `<button>`, `<input>`, `<dialog>`, and disclosure semantics before
  rebuilding their behavior on generic elements.
- Give icon-only controls an accessible name; keep it aligned with any visible label.
- Associate inputs and errors programmatically; never rely on placeholder text or color
  alone. (Color-blindness affects ~8% of men — never encode meaning in color only; pair it
  with text, icon, or shape.)
- Announce async success/error/loading via a live region when a screen-reader user would
  otherwise miss the change.
- Provide keyboard alternatives for gesture-only or custom widgets.
- Informative `alt` for content images; empty `alt=""` for purely decorative ones.
- Placeholder text still needs 4.5:1 — the ubiquitous pale-gray placeholder usually fails.

## Motion and responsive usability

Inclusive quality beyond a single AA criterion:

- Respect `prefers-reduced-motion` for non-essential animation; never block interaction
  behind choreography.
- Don't hide essential actions behind hover.
- Test narrow widths, text growth, long translated labels, empty/error/loading states, and
  orientation changes when relevant.
- Ensure sticky/fixed UI never obscures focused controls or required content.

## Verification evidence

For edited interactive UI, combine:

1. Static inspection of semantics, names, state attributes, tokens, and CSS.
2. Keyboard traversal and visible-focus inspection in a rendered view when available.
3. Contrast measurement for changed color pairs (a checker, or compute from token values
   and record the limit).
4. Representative narrow and wide rendering.
5. The repo's existing automated checks, lint, tests, or build when present. An automated
   pass (axe-core, Lighthouse, `eslint-plugin-jsx-a11y`) catches a *subset* — useful for
   regressions, never sufficient on its own.

**Never claim WCAG conformance solely because an automated scan passed.** Roughly a third
of success criteria require human judgment (meaningful alt text, logical focus order,
sensible reading sequence).
