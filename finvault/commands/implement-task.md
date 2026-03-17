---
description: Orchestrate task implementation with specialized subagents (backend + testing)
argument-hint: <task-number e.g. T-001>
---

# Task Implementation Orchestrator

You are the **Orchestrator** for implementing task `$ARGUMENTS` in Finvault. You coordinate specialized subagents to complete the full implementation cycle.

## Workflow Overview

```
┌─────────────────────────────────────────────────────────────────┐
│  1. PRE-FLIGHT CHECKS (Orchestrator)                           │
│     - Check PROGRESS.md for task status                        │
│     - Verify dependencies are complete                         │
│     - Read task specification                                  │
├─────────────────────────────────────────────────────────────────┤
│  2. IMPLEMENTATION (spawn backend-engineer subagent)           │
│     - Implement API routes, services, database changes         │
│     - Run typecheck and lint                                   │
├─────────────────────────────────────────────────────────────────┤
│  3. TESTING (spawn testing-engineer subagent)                  │
│     - Write unit tests for new functionality                   │
│     - Verify acceptance criteria                               │
│     - Run full test suite                                      │
├─────────────────────────────────────────────────────────────────┤
│  4. FINAL VERIFICATION (Orchestrator)                          │
│     - npm run typecheck                                        │
│     - npm run lint                                             │
│     - npm run test                                             │
│     - npm run build                                            │
├─────────────────────────────────────────────────────────────────┤
│  5. UPDATE PROGRESS (Orchestrator)                             │
│     - Update PROGRESS.md with completion status                │
└─────────────────────────────────────────────────────────────────┘
```

---

## Step 1: Pre-Flight Checks

### 1.1 Check Progress Status

Read `/docs/tasks/PROGRESS.md` to check:

- Is task `$ARGUMENTS` already completed? → **STOP and report**
- Which dependency tasks are completed?
- Current project status

### 1.2 Read Task Specification

Read `/docs/tasks/$ARGUMENTS-*.md` to understand:

- Full requirements and acceptance criteria
- Dependencies on other tasks
- Technical specifications
- Priority and effort estimate

### 1.3 Verify Dependencies

Cross-reference with PROGRESS.md:

- All blocking tasks must be marked complete
- If dependencies incomplete → **STOP and report blockers**

### 1.4 Review PRD Context (if referenced)

If task references PRD sections, read `/docs/PRD-PrivacyFirst-Finance-App.md` for context.

---

## Step 2: Spawn Backend Engineer Subagent

**Use the Task tool to spawn the backend-engineer subagent:**

```
Task(
  subagent_type: "backend-engineer",
  description: "Implement $ARGUMENTS backend",
  prompt: """
  Implement task $ARGUMENTS for Finvault.

  TASK SPECIFICATION:
  [Include full task spec from /docs/tasks/$ARGUMENTS-*.md]

  REQUIREMENTS:
  1. Follow TypeScript strict mode (no `any` types)
  2. Use Zod for all validation
  3. Enable RLS on any new database tables
  4. Never log sensitive data

  After implementation, run:
  - npm run typecheck
  - npm run lint

  Report back with:
  - Summary of what was implemented
  - Files created/modified
  - Any database changes
  - API endpoints added
  """
)
```

**Wait for backend-engineer to complete before proceeding.**

---

## Step 3: Spawn Testing Engineer Subagent

**Use the Task tool to spawn the testing-engineer subagent:**

```
Task(
  subagent_type: "testing-engineer",
  description: "Test $ARGUMENTS implementation",
  prompt: """
  Write tests for task $ARGUMENTS implementation in Finvault.

  TASK SPECIFICATION:
  [Include full task spec from /docs/tasks/$ARGUMENTS-*.md]

  IMPLEMENTATION SUMMARY:
  [Include summary from backend-engineer]

  REQUIREMENTS:
  1. Write unit tests in __tests__/ directory
  2. Cover all acceptance criteria
  3. Test edge cases and error handling
  4. Use proper TypeScript types (no `as any`)

  After writing tests, run:
  - npm run test
  - npm run typecheck
  - npm run lint

  Report back with:
  - Test files created
  - Coverage areas
  - Acceptance criteria verified
  - Any issues found
  """
)
```

**Wait for testing-engineer to complete before proceeding.**

---

## Step 4: Final Verification

Run the complete verification suite:

```bash
npm run typecheck    # Must pass with 0 errors
npm run lint         # Must pass with 0 warnings
npm run test         # All tests must pass
npm run build        # Production build must succeed
```

**If any verification fails:**

1. Identify the issue
2. Spawn appropriate subagent to fix
3. Re-run verification

---

## Step 5: Update PROGRESS.md

After all verification passes, update `/docs/tasks/PROGRESS.md`:

### 5.1 Update Summary Table

Increment "Completed" count, decrement "Not Started" or "In Progress"

### 5.2 Add Completion Entry

```markdown
### $ARGUMENTS: <Task Title>

- **Status:** ✅ Completed
- **Date:** <YYYY-MM-DD>
- **Effort:** <actual time spent>

**What was built:**

- <Key deliverable 1>
- <Key deliverable 2>

**Files created/modified:**

- `path/to/file.ts` - Description

**Verification:**

- `npm run build` ✅
- `npm run lint` ✅
- `npm run typecheck` ✅
- `npm run test` ✅
```

### 5.3 Update Task Lists

- Remove task checkbox from "Not Started Tasks" section
- Add any follow-up notes to Notes section

---

## Output Format

Provide final summary:

```markdown
## Task $ARGUMENTS Implementation Complete

### Summary

[Brief description of what was accomplished]

### Backend Implementation

[Summary from backend-engineer]

### Testing

[Summary from testing-engineer]

### Files Changed

- Created: [list]
- Modified: [list]

### Verification Results

- Typecheck: ✅/❌
- Lint: ✅/❌
- Tests: ✅/❌
- Build: ✅/❌

### PROGRESS.md Updated

- Status: ✅ Completed
- Date: YYYY-MM-DD

### Follow-up Items

- [Any discovered issues or future improvements]
```

---

## Error Handling

### If Dependencies Not Met

```
BLOCKED: Task $ARGUMENTS requires completion of:
- T-XXX: [status]
- T-YYY: [status]

Please complete blocking tasks first.
```

### If Already Completed

```
SKIPPED: Task $ARGUMENTS is already marked as completed in PROGRESS.md
Completed on: [date]
```

### If Verification Fails

1. Identify specific failure
2. Spawn appropriate subagent with fix instructions
3. Re-run verification
4. Repeat until all checks pass

---

## Subagent Coordination Notes

- **backend-engineer**: Handles API routes, services, database, business logic
- **testing-engineer**: Handles unit tests, integration tests, acceptance verification

**Both subagents share:**

- Same TypeScript strict mode requirements
- Same project structure knowledge
- Same security constraints (no sensitive data logging)
