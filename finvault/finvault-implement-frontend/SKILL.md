---
name: finvault-implement-frontend
description: Implement a Finvault frontend task end-to-end with preflight checks, UI implementation, testing, and verification. Use for T-XXX frontend tasks; not for review-only requests.
---

# Finvault Frontend Task Implementation

Use this skill when the user asks to implement a frontend task (usually `T-XXX`).

## 1. Pre-Flight Checks

1. Read `/docs/tasks/PROGRESS.md`.
2. Read `/docs/tasks/<TASK_ID>-*.md`.
3. Verify dependencies for the task are complete.
4. If already completed or blocked by dependencies, report and stop.

## 2. Implement UI

- Follow task acceptance criteria exactly.
- Use TypeScript strict mode (no `any`).
- Use shadcn/ui + Tailwind patterns used in this repo.
- Cover loading, empty, and error states.
- Meet WCAG 2.1 AA basics (keyboard + focus + labels).

## 3. Testing

- Add/update component and interaction tests.
- Validate acceptance criteria with tests where practical.

## 4. Final Verification

Run:

```bash
npm run typecheck
npm run lint
npm run test
npm run build
```

If any check fails, fix and re-run.

## 5. Progress Update

Update `/docs/tasks/PROGRESS.md` when complete:

- Status: completed
- Date
- Brief implementation notes
- Files changed
- Verification status

## Output Format

Provide:

1. Task summary
2. Frontend implementation highlights
3. Tests added/updated
4. Verification results (typecheck/lint/test/build)
5. `PROGRESS.md` update details

## Notes

If subagents are available, you may delegate implementation/testing. If not, execute the full workflow directly.
