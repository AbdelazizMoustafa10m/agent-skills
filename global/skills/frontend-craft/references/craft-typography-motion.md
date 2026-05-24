# Craft: Typography, Spacing, Motion

The concrete execution layer. This is where "looks designed" comes from.

## Typography

### Modular scale and hierarchy

The most common amateur tell is too many sizes, too close together (14, 15, 16, 18…) —
muddy hierarchy. **Use fewer sizes with more contrast.** A 5-step system covers most UI:

| Role | Typical | Use |
| --- | --- | --- |
| xs | 0.75rem | captions, legal |
| sm | 0.875rem | secondary UI, metadata |
| base | 1rem | body |
| lg | 1.25–1.5rem | subheadings, lead |
| xl+ | 2–4rem | headlines, hero |

Pick one ratio and commit: 1.25 (major third), 1.333 (perfect fourth), or 1.5. Name tokens
semantically (`--text-body`, `--text-heading`), never by value (`--font-size-16`).

### Readability and measure

- Constrain body measure to ~45–75 characters: `max-width: 65ch`.
- Line-height scales *inversely* with line length — narrow columns want tighter leading,
  wide columns want more.
- Minimum 16px body text; size body in `rem`/`em` so it respects the user's browser
  setting. Never `px` for body, never `user-scalable=no`.
- Pick paragraph spacing **or** first-line indent — never both. Digital usually wants
  space.

### Light-on-dark compensation

Light text on dark reads heavier and tighter than the inverse. Fix three axes together,
not one: bump line-height by 0.05–0.1, add 0.01–0.02em letter-spacing, and optionally step
body weight up one notch (or *down* in true dark mode — see the dark-mode note in
direction-and-systems.md). All-caps labels need 5–12% letter-spacing (`letter-spacing:
0.05em`–`0.12em`); capitals collide at default spacing.

### Font selection and pairing

- The hue of "modern" is *not* a geometric sans. The most modern move is often not using
  the font everyone else is using. Avoid reflexes: a tech tool rarely needs a serif "for
  warmth"; a kids' product doesn't need a rounded display face; an editorial brief doesn't
  need the same expressive serif as everyone else right now.
- **You often don't need a second font.** One well-chosen family in multiple weights gives
  cleaner hierarchy than two competing faces. Add a second only for genuine contrast
  (display headline + body), and contrast on a real axis: serif+sans, geometric+humanist,
  condensed+wide. Never pair two faces that are *similar but not identical* — tension
  without hierarchy.
- System fonts are underrated where performance > personality:
  `-apple-system, BlinkMacSystemFont, "Segoe UI", system-ui` — native look, zero load.

### Fluid type — for content, not product

`clamp(min, preferred, max)` scales headings smoothly with the viewport. Use it for
**headings/display on marketing/content pages**. Use **fixed `rem` scales for app UIs and
dashboards** — no major product design system (Material, Polaris, Primer, Carbon) uses
fluid type in product UI; fixed scales give the spatial predictability dense layouts need.
Body text stays fixed everywhere.

```css
/* bound the ratio: max ≤ ~2.5× min, or zoom/reflow breaks */
h1 { font-size: clamp(2rem, 1.2rem + 4vw, 4rem); }
```

### Web font loading (kill the layout shift)

```css
@font-face {
  font-family: 'Brand'; src: url('brand.woff2') format('woff2');
  font-display: swap;        /* or 'optional' when zero CLS matters more than branding */
}
```

Match a fallback's metrics (`size-adjust`, `ascent-override`, `descent-override`) to
minimize shift — tools like Fontaine compute these. Preload only the critical above-the-
fold weight. Use a variable font for 3+ weights (one file, fractional control,
`font-optical-sizing: auto`); static is fine for 1–2.

### OpenType and rendering polish — cheap, high-signal

```css
.data-table { font-variant-numeric: tabular-nums; }   /* align columns of numbers */
.price      { font-variant-numeric: tabular-nums; }
h1, h2, h3  { text-wrap: balance; }                    /* even heading line lengths */
article p   { text-wrap: pretty; }                     /* fewer orphans in prose */
body        { font-optical-sizing: auto; font-kerning: normal; }
code        { font-variant-ligatures: none; }
```

## Spacing and rhythm

- Drive vertical spacing from a single base unit. If body is 16px with `line-height: 1.5`
  (=24px), prefer spacing values that are multiples/fractions of that base — text and space
  share one mathematical foundation, which reads as harmony.
- Use a small, consistent spacing scale (e.g. 4 / 8 / 12 / 16 / 24 / 32 / 48 / 64) as
  tokens; don't hand-pick one-off pixel gaps.
- Negative space is a feature, not waste. Cramped padding and equal-weight everything are
  the fastest way to look generic.

## Motion

Motion should clarify cause-and-effect and reward attention — never decorate or stall.

### Duration: the 100 / 300 / 500 guide

| Duration | Use |
| --- | --- |
| 100–150ms | instant feedback — button press, toggle, color change |
| 200–300ms | state changes — menu, tooltip, hover |
| 300–500ms | layout changes — accordion, modal, drawer |
| 500–800ms | entrances — page load, hero reveal |

Exit ≈ 75% of enter duration. Keep UI *feedback* under ~500ms; the ~80ms perceptual
threshold is the target for micro-interactions (under it feels instant).

### Easing: don't use plain `ease`

```css
--ease-out-quart: cubic-bezier(0.25, 1, 0.5, 1);   /* refined default — entrances */
--ease-out-expo:  cubic-bezier(0.16, 1, 0.3, 1);   /* snappier */
--ease-in:        cubic-bezier(0.7, 0, 0.84, 0);   /* elements leaving */
--ease-in-out:    cubic-bezier(0.65, 0, 0.35, 1);  /* there-and-back toggles */
```

Exponential/quart curves mimic real deceleration. **Avoid bounce and elastic** — trendy in
2015, now reads as dated and amateurish; overshoot draws attention to the animation, not
the content.

### Materials beyond transform/opacity

Transform + opacity are reliable defaults, not the whole palette. Premium moments may use
blur/`backdrop-filter` (focus pulls, glass, depth), clip-path/masks (wipes, reveals), or
shadow/glow/color-filter (energy, affordance). The hard rule isn't "transform & opacity
only" — it's: avoid casually animating layout-driving properties (`width`, `height`, `top`,
`left`, margin), keep expensive effects bounded to small areas, and confirm it stays smooth
on the target viewport.

### Staggering

```css
.item { animation: rise 500ms var(--ease-out-quart) backwards;
        animation-delay: calc(var(--i, 0) * 50ms); }   /* style="--i:0/1/2…" */
```

Cap total stagger (~10 items × 50ms = 500ms). For long lists, shrink the per-item delay or
cap the animated count.

### Reduced motion is not optional

Vestibular disorders affect a large share of adults. Offer a calmer alternative, not just
removal — a crossfade still communicates the change:

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after { animation-duration: .01ms !important; transition-duration: .01ms !important; }
}
```

Preserve functional motion (progress, loading, focus indicators) — just drop spatial
movement. Don't use `will-change` preemptively; only on `:hover`/`.animating`. For
scroll-triggered reveals use IntersectionObserver and unobserve after firing once.

### Perceived performance

What it *feels* like beats what it measures. Begin transitions immediately (skeletons),
reveal content progressively, and use optimistic UI for low-stakes actions (not payments or
destructive ones). A spinner that never resolves is worse than honest progressive content.
