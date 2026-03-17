---
description: Orchestrate frontend/UI task implementation using specialized subagents (frontend-engineer + testing-engineer)
argument-hint: <task-number e.g. T-056>
---

# Frontend Implementation Orchestrator

You are the **Orchestrator** coordinating the implementation of frontend task `$ARGUMENTS` for Finvault using specialized subagents.

## Workflow Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│  ORCHESTRATOR (You)                                             │
├─────────────────────────────────────────────────────────────────┤
│  1. PRE-FLIGHT CHECKS                                           │
│     - Read PROGRESS.md → Check if completed/blocked             │
│     - Read task spec → Understand UI requirements               │
│     - Verify dependencies → Ensure blockers resolved            │
├─────────────────────────────────────────────────────────────────┤
│  2. SPAWN: frontend-engineer                                    │
│     └─► Implements React components, pages, styling             │
│         └─► Returns: files created, design choices, states      │
├─────────────────────────────────────────────────────────────────┤
│  3. SPAWN: testing-engineer                                     │
│     └─► Writes component tests, verifies acceptance criteria    │
│         └─► Returns: test coverage, verification status         │
├─────────────────────────────────────────────────────────────────┤
│  4. FINAL VERIFICATION                                          │
│     - npm run typecheck ✓                                       │
│     - npm run lint ✓                                            │
│     - npm run test ✓                                            │
│     - npm run build ✓                                           │
├─────────────────────────────────────────────────────────────────┤
│  5. UPDATE PROGRESS.md                                          │
│     - Mark task complete with design notes                      │
└─────────────────────────────────────────────────────────────────┘
```

---

## Step 1: Pre-Flight Checks

### 1.1 Read Progress Log

```
Read: /docs/tasks/PROGRESS.md
```

Check for:

- Is `$ARGUMENTS` already completed? → **STOP**: Report "Task already completed on [date]"
- Current project status
- Which dependency tasks are done

### 1.2 Read Task Specification

```
Read: /docs/tasks/$ARGUMENTS-*.md
```

(Use glob pattern to find the task file)

Extract:

- UI/UX requirements
- Acceptance criteria
- Design specifications or mockups
- Edge cases and states to handle

### 1.3 Verify Dependencies

Cross-reference dependencies with PROGRESS.md:

- All blocking tasks must show ✅ Completed
- If any blocker is incomplete → **STOP**: Report blockers

---

## Step 2: Spawn Frontend Engineer Subagent

**Use the Task tool to spawn the frontend-engineer agent:**

```typescript
Task({
  subagent_type: "frontend-engineer",
  description: "Implement $ARGUMENTS UI",
  prompt: `
Implement frontend task $ARGUMENTS for Finvault.

## TASK SPECIFICATION
[Paste full task specification here]

## REQUIREMENTS
1. Complete design thinking BEFORE coding
2. TypeScript strict mode
3. shadcn/ui + Tailwind CSS
4. All states: loading, empty, error
5. WCAG 2.1 AA accessibility

## REPORT
Provide summary with design choices and files created.
`,
})
```

**Wait for completion. Capture the implementation summary.**

---

## Step 3: Spawn Testing Engineer Subagent

**Use the Task tool to spawn the testing-engineer agent:**

```typescript
Task({
  subagent_type: "testing-engineer",
  description: "Test $ARGUMENTS UI",
  prompt: `
Write tests for frontend task $ARGUMENTS.

## IMPLEMENTATION SUMMARY
[Paste summary from frontend-engineer]

## REQUIREMENTS
1. React Testing Library component tests
2. Test all UI states
3. Test user interactions
4. Verify acceptance criteria

## REPORT
Provide test files and coverage summary.
`,
})
```

**Wait for completion. Capture the test summary.**

---

## Step 4: Final Verification

Run the complete verification suite:

```bash
npm run typecheck    # Must pass with 0 errors
npm run lint         # Must pass with 0 warnings
npm run test         # All tests must pass
npm run build        # Production build must succeed
```

### If Any Check Fails:

1. Identify the specific failure
2. Spawn the appropriate subagent with fix instructions
3. Re-run verification

---

## Step 5: Update PROGRESS.md

After ALL verification passes:

```markdown
### $ARGUMENTS: <Task Title>

- **Status:** ✅ Completed
- **Date:** YYYY-MM-DD
- **Effort:** <actual>

**What was built:**

- <UI component/page>

**Design choices:**

- Aesthetic direction: [direction]
- Memorable element: [description]

**Files:**

- `path/to/component.tsx`

**Verification:**

- Build: ✅ | Lint: ✅ | Types: ✅ | Tests: ✅
- Dark: ✅ | Light: ✅ | Responsive: ✅
- A11y: ✅ | Keyboard: ✅
```

---

## Output Format

```markdown
# Task $ARGUMENTS Complete

## Summary

[What was accomplished]

## Frontend Implementation

[Summary from frontend-engineer]

- Aesthetic Direction: [choice]
- Memorable Element: [description]

## Testing

[Summary from testing-engineer]

## Verification Results

| Check     | Status |
| --------- | ------ |
| Typecheck | ✅/❌  |
| Lint      | ✅/❌  |
| Tests     | ✅/❌  |
| Build     | ✅/❌  |

## PROGRESS.md Updated

- Status: ✅ Completed
```

---

## Subagent Reference

| Subagent            | Responsibility                                |
| ------------------- | --------------------------------------------- |
| `frontend-engineer` | UI components, styling, states, accessibility |
| `testing-engineer`  | Component tests, interaction tests            |
