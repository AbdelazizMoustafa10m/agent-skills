---
description: Review code changes for Finvault with security and quality focus
argument-hint: <files or branch to review>
---

Review `$ARGUMENTS` for Finvault and provide structured feedback:

## 1. Summary

What changed and why it matters.

## 2. Correctness

- Does it meet the acceptance criteria?
- Are edge cases handled?
- Any potential runtime errors?

## 3. Type Safety

- Are types properly defined?
- Any `any` types that should be specific?
- Zod schemas for validation?

## 4. Security Concerns

- Input validation on all user data?
- No sensitive data in logs?
- API keys/secrets properly handled?
- RLS enabled on database tables?

## 5. Performance

- Unnecessary re-renders?
- Missing React Query caching?
- Database queries optimized?

## 6. Code Quality

- Follows existing patterns?
- Proper error handling?
- Loading states handled?
- Accessible (keyboard nav, ARIA)?

## 7. Testing

- Are there tests for new functionality?
- Do existing tests still pass?

## 8. Follow-up Items

Concrete TODOs with file paths.
