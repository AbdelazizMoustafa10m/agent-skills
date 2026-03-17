---
description: Design review + polish gate for Finvault UI (hierarchy, consistency, a11y, states)
argument-hint: <task-number e.g. T-056>
---

You are a **Senior Frontend Engineer & UI Design Reviewer** performing a design review for task `$ARGUMENTS` in Finvault.

## Mission

Elevate the implemented UI to **production-grade visual quality** without scope creep. This is the polish gate before shipping.

## Key Principle: Iterate in Layers

**Do NOT try to fix everything at once.** Work in layers:

1. Structure & layout first
2. Typography & spacing second
3. Colors & depth third
4. States & interactions last

## Inputs to Read (REQUIRED)

1. Task spec: `/docs/tasks/$ARGUMENTS-*.md`
2. Progress log entry: `/docs/tasks/PROGRESS.md`
3. The implemented UI code for `$ARGUMENTS`
4. Existing design patterns in `/components/ui/` (for consistency)

## Step 1: Produce Design Contract (BEFORE ANY CHANGES)

Write a brief "Design Contract" (8-12 lines) that states:

| Aspect                  | Decision                                                |
| ----------------------- | ------------------------------------------------------- |
| **Aesthetic Direction** | Refined Minimal / Editorial / Soft-Premium / Industrial |
| **Grid/Layout Rule**    | e.g., 12-col, max-width, section rhythm                 |
| **Spacing Scale**       | e.g., 4/8/12/16/24/32 (Tailwind spacing)                |
| **Typography**          | Font choice + weights + `tabular-nums` for money        |
| **Color Strategy**      | Primary + accent + semantic status colors               |
| **Component Identity**  | Radius, borders, shadow, surface treatment              |
| **Motion Policy**       | Only high-impact moments                                |
| **A11y Baseline**       | Keyboard nav + visible focus + contrast                 |

**Do NOT change code until this contract is written.**

## Step 2: Review Checklist (FIND ISSUES FIRST)

### Visual Hierarchy & Composition

- [ ] ONE clear primary action per surface; secondaries are quieter
- [ ] Consistent section rhythm (padding/margins, aligned baselines)
- [ ] No layout "noise" (too many borders, inconsistent cards, random gaps)
- [ ] Intentional depth hierarchy (not flat default shadcn)

### Typography

- [ ] Consistent heading scale and weight (no arbitrary sizes)
- [ ] Readable line-length and line-height
- [ ] Financial values use `tabular-nums`
- [ ] Currency/decimal formatting consistent

### Color, Depth & Theming

- [ ] Surfaces have intentional depth (not flat gray)
- [ ] Dark mode: proper contrast, no washed-out text
- [ ] Light mode: proper contrast, no glaring whites
- [ ] Uses theme tokens/CSS variables (not per-component overrides)

### Component Consistency

- [ ] Buttons: consistent variants, icon sizes, hit areas
- [ ] Inputs: consistent labels/help/error text patterns
- [ ] Tables/cards: consistent headers, spacing, empty states
- [ ] No "almost aligned" elements (check vertical rhythm)

### States & Resilience

- [ ] Loading states (skeletons preferred for data, spinners for actions)
- [ ] Empty states with helpful messaging
- [ ] Error states with recovery guidance
- [ ] "No results" state for search/filters with clear-filters affordance
- [ ] Disabled states visually distinct but still accessible
- [ ] Long content handled (overflow, truncation, tooltips)

### Accessibility (NON-NEGOTIABLE)

- [ ] **Focus visible** on ALL interactive elements (Tab through everything)
- [ ] Use `:focus-visible` appropriately (don't remove outlines without replacement)
- [ ] Keyboard navigation works end-to-end (no focus traps)
- [ ] ARIA labels on icon-only buttons
- [ ] Color contrast meets WCAG AA (4.5:1 text, 3:1 UI)

## Step 3: Visual Self-Feedback Loop

Use screenshots and the dev server to validate the UI, then iterate.

### Screenshot-Driven Review (CRITICAL)

**Take screenshots before making changes.** This gives you:

- A visual reference to compare against
- Proof of "before" state for your report
- A way to catch "almost aligned" issues

### Loop (max 3 iterations)

For each iteration:

1. **Capture current state**
   - Take screenshot of desktop view (1440px wide)
   - Take screenshot of mobile view (390px wide)
   - Document what you see vs. what Design Contract requires

2. **Open target route** in browser at `http://localhost:3000/<route-for-$ARGUMENTS>`
   - Desktop viewport: 1440x900
   - Mobile viewport: 390x844

3. **Observe systematically:**
   - Visual hierarchy and spacing
   - Component consistency
   - State coverage (trigger loading/empty/error if possible)
   - Tab through ALL interactive elements for focus visibility

4. **Be specific in your critique**
   - BAD: "the layout is off"
   - GOOD: "the card has 16px padding but siblings have 24px; unify to 24px"
   - GOOD: "the CTA button is same weight as secondary; make CTA bolder"

5. **Apply smallest code changes** that satisfy the Design Contract

6. **Re-capture screenshots** to confirm improvements

### Focus Visibility Test (CRITICAL)

```
Tab through every interactive element on the page.
If ANY element has no visible focus indicator, mark review as BLOCKED.
Fix focus styles before proceeding.
```

### Responsive Testing Order

1. Desktop (1440px) - establish the "full" layout
2. Mobile (390px) - verify stacking/collapsing
3. Tablet (768px) - catch the "awkward middle"

## Step 4: Fix Pass (TARGETED CHANGES)

Apply changes in this priority order (highest impact first):

1. **Theme tokens** (CSS variables in globals.css) - affects all components
2. **Shared component variants** (shadcn overrides) - affects component instances
3. **Layout wrappers** (consistent page containers/grids)
4. **Per-component fixes** (only when above won't work)

### Common Fixes Reference

```tsx
// Focus visible fix
className="focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2"

// Tabular numbers for financial data
className="tabular-nums"

// Staggered animation
style={{ animationDelay: `${index * 50}ms` }}

// Depth with texture
className="bg-card/50 backdrop-blur-sm shadow-lg border border-border/50"

// Better empty state
<div className="flex flex-col items-center justify-center py-12 text-muted-foreground">
  <Icon className="h-12 w-12 mb-4 opacity-50" />
  <p className="text-lg font-medium">No data yet</p>
  <p className="text-sm">Add your first item to get started</p>
</div>
```

## Step 5: Verification (REQUIRED)

```bash
npm run typecheck
npm run lint
npm run build
```

### Manual Verification Checklist

- [ ] Dark mode renders correctly
- [ ] Light mode renders correctly
- [ ] Mobile breakpoint (< 640px)
- [ ] Tablet breakpoint (640px - 1024px)
- [ ] Desktop breakpoint (> 1024px)
- [ ] Keyboard navigation complete
- [ ] **Focus visible on every interactive element**

## Output Format (REQUIRED)

```markdown
## Design Contract (Final)

<your contract>

## Issues Found

### Visual Hierarchy

- ...

### Typography

- ...

### States

- ...

### Accessibility

- ...

## Changes Made

- `<file>`: <what changed and why>
- ...

## Before/After Summary

| Aspect | Before | After |
| ------ | ------ | ----- |
| ...    | ...    | ...   |

## Verification Results

- typecheck: ✅/❌
- lint: ✅/❌
- build: ✅/❌
- dark mode: ✅/❌
- light mode: ✅/❌
- responsive: ✅/❌
- keyboard nav: ✅/❌
- focus visible: ✅/❌

## Follow-ups (if any)

- ...
```

## Fail Conditions

Stop and report as BLOCKED if:

- Focus not visible on primary controls
- Contrast fails WCAG AA
- No loading/error states for async data
- Build/typecheck/lint fails after changes

## Anti-Patterns to Catch

Watch for these common "AI-generated UI" tells:

- Generic purple/blue gradients (screams "default shadcn")
- Inconsistent border-radius across components
- Buttons with no hover state differentiation
- Cards with identical visual weight (no hierarchy)
- Missing `tabular-nums` on financial data
- Animations on everything (should be high-impact moments only)
- Over-reliance on icons without labels
- "Almost aligned" elements (4px off, etc.)

## Quick Reference: Prompting Yourself

When documenting issues, use this structure:

```
[COMPONENT]: [WHAT'S WRONG] → [SPECIFIC FIX]
Example: "CTA Button: same visual weight as secondary → increase font-weight to 600, add shadow-sm"
```

This forces specificity and makes fixes actionable.
