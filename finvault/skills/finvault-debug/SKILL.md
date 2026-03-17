---
name: finvault-debug
description: Debug and fix Finvault issues with systematic root-cause analysis. Use when users report errors, broken behavior, regressions, or failing flows. Do not use for net-new feature implementation.
---

# Finvault Debug Workflow

Use this skill when the user asks to diagnose or fix an issue. Treat the user-provided issue details as the debugging target.

## 1. Reproduce and Understand

- Confirm the exact error message or unexpected behavior.
- Identify reproducible steps.
- Check browser console and server logs.

## 2. Locate the Problem

- Trace to the source file or service.
- Review recent changes in affected files.
- Use TypeScript and lint output as hints.

## 3. Analyze Root Cause

TypeScript errors:

- Missing type definitions
- Incorrect prop or function types
- Null or undefined handling gaps

React errors:

- Missing `'use client'` where hooks/events are used
- Invalid hook usage
- Missing `key` props in lists

API errors:

- Invalid request payload
- Missing auth/authorization
- Database query issues

UI issues:

- Missing/incompatible Tailwind classes
- Dark-mode inconsistencies
- Responsive breakpoint regressions

## 4. Implement the Fix

- Make the smallest safe change.
- Match existing project conventions.
- Add defensive checks where appropriate.

## 5. Verify

Run:

```bash
npm run typecheck
npm run lint
npm run test
```

- Confirm the issue is resolved.
- Confirm related functionality still works.

## 6. Prevent Recurrence

- Add or update tests where useful.
- Tighten types/schemas if weak typing enabled the bug.
- Document non-obvious gotchas when needed.
