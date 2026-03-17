---
description: Debug and fix an issue in Finvault with systematic root cause analysis
argument-hint: <description of the issue>
---

You are a **Senior Engineer** debugging: `$ARGUMENTS`

## Debugging Process

### 1. Reproduce & Understand

- What is the exact error message or unexpected behavior?
- What are the steps to reproduce?
- Check browser console and server logs

### 2. Locate the Problem

- Trace to source file
- Review recent changes to affected files
- Use TypeScript errors as hints

### 3. Analyze Root Cause

**TypeScript Errors:**

- Missing type definitions
- Incorrect prop types
- Null/undefined handling

**React Errors:**

- Missing 'use client' directive
- Invalid hook usage
- Missing key props

**API Errors:**

- Invalid request body
- Missing authentication
- Database query issues

**UI Issues:**

- Missing Tailwind classes
- Dark mode inconsistency
- Responsive breakpoints

### 4. Implement Fix

- Make minimal change needed
- Match existing code style
- Add defensive checks if appropriate

### 5. Verify

```bash
npm run typecheck
npm run lint
npm run test
```

- Confirm issue is resolved
- Test related functionality still works

### 6. Prevent Recurrence

- Would a test catch this?
- Should types be updated?
- Document if non-obvious gotcha
