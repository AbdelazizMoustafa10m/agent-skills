---
description: Fetch PR review feedback with gh, validate findings, and fix only valid issues
argument-hint: <pr-number>
allowed-tools: ["Bash", "Glob", "Grep", "Read", "Edit", "Write", "MultiEdit"]
---

You are running the **PR Fixer** workflow for Finvault.

PR number: `$ARGUMENTS`

## Goal

Use GitHub CLI to collect PR review feedback, evaluate each point for validity, and implement fixes only for valid findings.

## Rules

- Do not use any external scripts for digesting comments.
- Use `gh` commands directly in this session.
- If `$ARGUMENTS` is empty, ask for the PR number and stop.
- If `gh` is not authenticated or PR is not accessible, report the exact blocker and stop.
- Do not commit or push unless the user explicitly asks.
- Ignore purely stylistic suggestions unless they align with existing project conventions or documented standards.
- Before the final user report, post resolution replies to review comments via `gh`.

## Workflow

### 1. Collect review data with `gh`

Run these commands (replace `<PR>` with `$ARGUMENTS`):

```bash
gh pr view <PR> --json number,title,url,author,baseRefName,headRefName,reviewDecision
gh pr view <PR> --comments
gh api repos/$(gh repo view --json nameWithOwner -q .nameWithOwner)/pulls/<PR>/comments --paginate
gh api repos/$(gh repo view --json nameWithOwner -q .nameWithOwner)/pulls/<PR>/reviews --paginate
```

### 2. Build an in-session review digest

Create a structured list of unique findings with:

- source (`review comment`, `line comment`, `PR conversation`)
- file and line (if available)
- requested change
- severity (`critical`, `important`, `minor`)
- validity decision (`valid`, `invalid`, `unclear`)
- short rationale

Deduplicate semantically similar comments.

### 3. Validate before editing

For each finding, check:

- Is it factually correct against current code?
- Is it in scope for this PR?
- Does fixing it risk regression?
- Is there already a fix in the branch?

Only proceed with findings marked `valid`.

### 4. Implement valid fixes

- Apply minimal, targeted edits.
- Preserve existing architecture and style.
- If a finding is `unclear`, ask the user before changing behavior.

### 5. Verify changes

Run project checks relevant to touched files (prefer full check when feasible):

```bash
npm run format
npm run typecheck
npm run lint
npm run test
```

If full tests are too heavy or fail for unrelated reasons, run targeted checks and state exactly what was run.

### 6. Post review comment resolutions with `gh`

Before presenting your final report to the user, reply to each actionable review comment with its resolution status.

Use concise resolution labels:

- `fixed`
- `not valid`
- `ignored`
- `not worth fixing`
- `already addressed`
- `needs clarification`

For inline PR review comments (`pulls/<PR>/comments`):

```bash
gh api repos/$(gh repo view --json nameWithOwner -q .nameWithOwner)/pulls/comments/<COMMENT_ID>/replies -f body='<reply>'
```

Reply template:

`[pr-fix] Status: <label>. Resolution: <short reason>.`

If direct reply is not supported for a feedback item (for example, non-inline review text), add a single PR comment summarizing those unresolved/non-threaded items:

```bash
gh pr comment <PR> --body '<summary>'
```

Do not post duplicate replies for the same comment within the same run.

### 7. Final report format

Return:

1. `Valid + fixed` items (with file paths)
2. `Valid but not fixed` items (with blocker)
3. `Invalid / skipped` items (with reason)
4. Verification results (commands + pass/fail summary)
5. Review reply log (comment ids + posted status, and any posting failures)
6. Optional next actions (only if needed)
