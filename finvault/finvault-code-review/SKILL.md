---
name: finvault-code-review
description: Perform Finvault PR reviews with severity-calibrated findings for Next.js 15, Prisma, Supabase RLS, Zod validation, and privacy/security constraints.
---

# Finvault Code Review Skill

Use this skill when reviewing pull requests for Finvault.

## Scope

Focus on high-signal findings in this order:

1. Security and privacy regressions
2. Type safety and nullability
3. Error handling and resilience
4. API and database correctness
5. Test coverage gaps

## Review Workflow

1. Gather PR context and changed files
2. Check architectural and data-access patterns
3. Review code quality by severity
4. Verify tests for changed logic and error paths
5. Summarize findings with concrete fixes

## Severity Model

- `critical`: security vulnerabilities, auth bypass, sensitive data exposure, data loss risks
- `high`: missing safeguards in business logic, unsafe DB/API patterns, major type-safety gaps
- `medium`: missing tests, API consistency issues, performance risks
- `low`: readability and maintainability issues
- `suggestion`: optional improvements

## Required References

- `../../review/rules/finvault-patterns.md`
- `../../review/rules/review-checklist.md`
- `../../review/prompts/full-review.md`
- `../../review/prompts/security-review.md`
- `../../copilot-instructions.md`
- `../../../AGENTS.md`

## Output Expectations

- Prefer concise, actionable findings with file/line references.
- For `critical` and `high`, always include a suggested fix.
- Avoid duplicate findings and style-only noise already covered by CI.
