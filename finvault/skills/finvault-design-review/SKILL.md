---
name: finvault-design-review
description: Run a UI polish and design-quality review for an implemented Finvault task (typically T-XXX). Use for hierarchy/consistency/a11y/state audits before shipping, not initial implementation.
---

# Finvault Design Review + Polish Gate

Use this skill after a task UI exists and needs production-grade visual/a11y polish.

## Mission

Elevate implemented UI quality without scope creep.

## Key Principle: Iterate in Layers

1. Structure and layout
2. Typography and spacing
3. Colors and depth
4. States and interactions

## Required Inputs

1. Task spec: `/docs/tasks/<TASK_ID>-*.md`
2. Progress log: `/docs/tasks/PROGRESS.md`
3. Implemented UI code for the task
4. Existing patterns in `/components/ui/`

## Step 1: Design Contract (Before Edits)

Write a brief contract (8-12 lines) covering:

- Aesthetic direction
- Grid/layout rule
- Spacing scale
- Typography (include `tabular-nums` for money)
- Color strategy
- Component identity (radius/borders/shadows)
- Motion policy
- Accessibility baseline

Do not edit code before this contract exists.

## Step 2: Issue Discovery Checklist

Review first, then fix.

Visual hierarchy/composition:

- One clear primary action per surface
- Consistent spacing rhythm and alignment
- Intentional depth hierarchy

Typography:

- Consistent heading scale
- Readable line length/line height
- `tabular-nums` for financial values
- Consistent currency/decimal formatting

Color/theming/depth:

- Intentional surfaces (not flat defaults)
- Strong dark/light mode contrast
- Theme token usage vs ad-hoc overrides

Component consistency:

- Consistent button/input/card/table patterns
- No near-miss alignment issues

States and resilience:

- Loading, empty, error, no-results states
- Disabled states are distinct and accessible
- Long content overflow handled

Accessibility (non-negotiable):

- Visible focus everywhere
- Full keyboard navigation
- ARIA labels for icon-only controls
- WCAG AA contrast

## Step 3: Visual Feedback Loop (Max 3 Iterations)

For each iteration:

1. Capture current desktop and mobile screenshots.
2. Compare against design contract.
3. Document specific critique.
4. Apply smallest possible code changes.
5. Re-capture screenshots.

Focus test: Tab through every interactive element. If any lacks visible focus, treat review as blocked until fixed.

Responsive order:

1. Desktop (1440)
2. Mobile (390)
3. Tablet (768)

## Step 4: Fix Priority

1. Theme tokens (`globals.css`)
2. Shared component variants
3. Layout wrappers/containers
4. Per-component fixes

## Step 5: Verification

Run:

```bash
npm run typecheck
npm run lint
npm run build
```

Manual checks:

- Dark mode
- Light mode
- Mobile/tablet/desktop
- Keyboard navigation
- Visible focus on all interactive controls

## Required Output

- Final design contract
- Issues found by category
- Changes made with file paths
- Before/after summary
- Verification results (typecheck/lint/build/manual)
- Follow-ups if needed

## Blockers

Report blocked if any of these remain:

- Missing visible focus on interactive controls
- WCAG AA contrast failures
- Missing loading/error states for async data
- Build/typecheck/lint failing after edits
