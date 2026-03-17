---
name: finvault-review
description: Review Finvault code changes for correctness, security, type safety, and test coverage. Use for PR/code review requests, not for implementing new features.
---

# Finvault Code Review

Use this skill for review-only tasks. Prioritize findings over summaries.

## Output Structure

## 1. Summary

- What changed and why it matters.

## 2. Correctness

- Does the implementation satisfy acceptance criteria?
- Are edge cases handled?
- Are runtime failures possible?

## 3. Type Safety

- Are types explicit and correct?
- Any `any` usage that should be narrowed?
- Are Zod schemas used where validation is required?

## 4. Security Concerns

- Is all user input validated?
- Is sensitive data absent from logs?
- Are secrets/API keys handled safely?
- If DB changes exist, is RLS handled correctly?

## 5. Performance

- Avoidable re-renders?
- Missing caching where applicable (React Query)?
- Inefficient database queries?

## 6. Code Quality

- Consistent with repository patterns?
- Error handling and loading states present?
- Accessibility basics covered (keyboard nav, ARIA, focus)?

## 7. Testing

- Are tests added/updated for new behavior?
- Do existing tests still cover critical paths?

## 8. Follow-up Items

- Actionable TODOs with file paths.
