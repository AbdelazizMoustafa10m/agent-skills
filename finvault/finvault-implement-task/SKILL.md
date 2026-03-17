---
name: finvault-implement-task
description: Implement a Finvault backend/full-stack task end-to-end with dependency checks, implementation, tests, verification, and progress updates. Use for T-XXX implementation requests.
---

# Finvault Task Implementation

Use this skill for backend or full-stack task implementation (typically `T-XXX`).

## 1. Pre-Flight

1. Check `/docs/tasks/PROGRESS.md` for existing status.
2. Read `/docs/tasks/<TASK_ID>-*.md` fully.
3. Verify dependency tasks are complete.
4. If blocked or already complete, report and stop.

## 2. Implementation

- Implement task scope only.
- Keep TypeScript strict (`any` is not allowed).
- Validate inputs with Zod.
- For DB changes: align Prisma schema/types and RLS expectations.
- Do not log sensitive financial/authentication data.

## 3. Testing

- Add/update unit/integration tests for acceptance criteria.
- Cover edge cases and error paths.

## 4. Verification

Run:

```bash
npm run typecheck
npm run lint
npm run test
npm run build
```

Fix failures and rerun until clean.

## 5. Progress Log Update

Update `/docs/tasks/PROGRESS.md` with:

- Completed status
- Date
- What was built
- Files changed
- Verification outcomes

## Output Format

Provide:

1. Task completion summary
2. Implementation details
3. Tests and coverage notes
4. Verification results
5. `PROGRESS.md` update details

## Notes

If subagents are available, delegation is allowed; otherwise perform all steps directly.
