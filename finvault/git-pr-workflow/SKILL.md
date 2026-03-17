---
name: git-pr-workflow
description: Review branch diff, derive a descriptive commit message, run pipeline and formatting checks, then commit, push, and open a PR with gh using .github/PULL_REQUEST_TEMPLATE.md.
---

# Git PR Workflow

Use this skill when the user asks to prepare changes for git, commit, push, and open a PR.

## Required Sequence

1. Confirm branch context and inspect diffs.
2. Draft a descriptive commit message from actual code changes.
3. Run `./run_pipeline_checks.sh` before staging/committing.
4. If formatting issues are reported, run `npm run format`, then rerun pipeline checks.
5. Only if checks pass: stage, commit, push.
6. Create PR with `gh` using `.github/PULL_REQUEST_TEMPLATE.md`.

Do not skip or reorder these steps.

## 1. Branch and Diff Review

Run:

```bash
git branch --show-current
git status --short
git diff --stat
git diff
git diff --staged
```

Rules:

- If branch is `main` or `master`, stop and ask the user for confirmation before committing.
- If there are no changes, stop and report no-op.
- Use the diff to understand what changed before writing commit/PR text.

## 2. Commit Message Construction

Create a commit message from the diff, not from guesswork.

Use Conventional Commits style:

- Title format: `<type>(<scope>): <summary>`
- Common types: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`
- Summary: imperative, specific, <= 72 chars
- Optional body: short bullets describing key changes and rationale

Examples:

- `feat(import): validate german decimal CSV amounts`
- `fix(api): prevent null category crash in transaction route`
- `refactor(services): split portfolio valuation by provider`

## 3. Mandatory Pre-Commit Checks

Before `git add` or `git commit`, run:

```bash
./run_pipeline_checks.sh
```

If checks fail due formatting/style issues, run:

```bash
npm run format
./run_pipeline_checks.sh
```

Rules:

- If pipeline still fails after formatting, stop and report failures.
- Never commit or push when required checks fail.
- If `./run_pipeline_checks.sh` is missing or not executable, stop and report.

## Test Failure Handling (Special Case)

If tests fail ONLY due to:

- **Environment issues**: Missing `DATABASE_URL` or `DIRECT_URL` environment variables
- **Performance issues**: Slow test execution on development machines (e.g., MacBook)

And ALL of these checks pass:

- `npm run format` (or equivalent formatting)
- `npm run typecheck`
- `npm run lint`
- `npx prisma generate`

Then:

1. Note the test failure reason in your report
2. Continue with staging, committing, and pushing
3. Include a note in the PR body about the skipped tests and why

This allows development to continue while flagging test failures for CI/CD resolution where the environment is properly configured.

## 4. Stage and Commit

Only after all checks pass:

```bash
git add -A
git commit -m "<title>" -m "<body>"
```

If commit is rejected because there is nothing to commit, report and stop.

## 5. Push Branch

Push current branch:

```bash
branch="$(git branch --show-current)"
git push --set-upstream origin "$branch" || git push origin "$branch"
```

## 6. Create PR with Template

1. Read `.github/PULL_REQUEST_TEMPLATE.md`.
2. Prepare a filled PR body from that template (replace placeholders with actual details).
3. Create PR with `gh`:

```bash
branch="$(git branch --show-current)"
base="$(gh repo view --json defaultBranchRef -q .defaultBranchRef.name)"
gh pr create --base "$base" --head "$branch" --title "<pr-title>" --body-file "/tmp/pr-body.md"
```

Rules:

- PR title must match the actual change and be specific.
- PR body must follow the repository template sections.
- If `gh` auth fails, stop and report exact remediation (`gh auth login`).

## Final Report Format

Return:

1. Branch name
2. Commit title used
3. Pipeline check result
4. Push result
5. PR URL
