---
name: audit-branch
description: Thoroughly audits all Python files changed on a branch against 65 Python best-practice rules across 12 categories. Use when reviewing a branch for code quality, standards compliance, or before opening a PR. Triggers on requests to audit, review, or check a branch against coding standards.
argument-hint: [branch-name (default current branch)]
disable-model-invocation: true
allowed-tools: Read, Grep, Glob, Bash, Agent
---

# Python Branch Audit

Perform a thorough, detailed audit of all Python files changed on a branch against the project's 65 Python best-practice rules.

## Target Branch

The branch to audit is: **$ARGUMENTS**

If no branch name was provided, audit the **current branch** against `main`.

## Step 1: Identify Changed Files

Run `git diff --name-only main...HEAD -- '*.py'` (or replace `main` with the appropriate base branch) to get all Python files changed on this branch. If a specific branch name was given as an argument, first check it out or diff against it.

If there are no Python file changes, report that and stop.

## Step 2: Read All Rule Files

Read every rule file from `.claude/skills/python-best-practices/rules/` (excluding `_template.md` and `_sections.md`). There are 65 rules across 12 categories. You MUST check every single rule — do not skip any.

The 12 categories (in priority order) are:

| # | Category | Impact | Prefix | Count |
|---|----------|--------|--------|-------|
| 1 | Code Simplification & DRY | CRITICAL | `style-` | 7 |
| 2 | Type Safety & Annotations | CRITICAL | `typing-` | 8 |
| 3 | Error Handling & Resilience | HIGH | `error-` | 8 |
| 4 | Testing Best Practices | HIGH | `test-` | 8 |
| 5 | Architecture & Structure | HIGH | `arch-` | 7 |
| 6 | Pydantic & Data Models | MEDIUM-HIGH | `model-` | 5 |
| 7 | Naming & Readability | MEDIUM | `naming-` | 3 |
| 8 | FastAPI & API Design | MEDIUM | `api-` | 5 |
| 9 | Async & Concurrency | MEDIUM | `async-` | 6 |
| 10 | Database & ORM Patterns | MEDIUM | `db-` | 3 |
| 11 | Configuration & Security | LOW-MEDIUM | `config-` | 3 |
| 12 | Operations & Quality Gates | LOW-MEDIUM | `ops-` | 2 |

## Step 3: Audit Every Changed File

For each changed Python file:

1. **Read the full file content** (not just the diff — context matters for architecture, import, and pattern rules).
2. **Check every one of the 65 rules** against the file. For each rule, determine if there is a violation.
3. **Record violations** with:
   - Rule ID (e.g., `style-early-return`)
   - Rule title
   - Impact level (CRITICAL / HIGH / MEDIUM-HIGH / MEDIUM / LOW-MEDIUM)
   - Exact file path and line number(s) (`file.py:42`)
   - Description of the violation
   - The offending code snippet (keep it short, 1-5 lines)
   - Suggested fix (concrete code, not vague advice)

Use multiple Explore agents in parallel to audit files concurrently when there are many changed files.

## Step 4: Generate the Audit Report

Present findings in the following format:

---

### Branch Audit Report: `<branch-name>`

**Files audited:** N
**Total findings:** N
**Critical:** N | **High:** N | **Medium-High:** N | **Medium:** N | **Low-Medium:** N

#### Summary Table

| # | Rule ID | Impact | File | Line(s) | Description |
|---|---------|--------|------|----------|-------------|
| 1 | `rule-id` | IMPACT | `file.py` | L42 | Brief description |
| ... | ... | ... | ... | ... | ... |

---

Then, for each finding, provide a **detailed section**:

#### Finding N: `rule-id` — Rule Title [IMPACT]

**File:** `path/to/file.py:42`

**Violation:** Clear explanation of what is wrong and why it matters.

**Current code:**
```python
# the offending code
```

**Suggested fix:**
```python
# the corrected code
```

---

### Category Breakdown

For each of the 12 categories, report:
- How many rules were checked
- How many violations found
- List of passing rules (to confirm they were checked)

### Rules with No Violations

List all rules that had zero violations across all files, confirming complete coverage.

---

## Important Instructions

- **Be thorough**: Check ALL 65 rules against EVERY changed file. Do not skip rules because they "probably don't apply."
- **Read full files**: Many rules (architecture, imports, circular dependencies) require understanding the full file, not just changed lines.
- **Be specific**: Always include exact line numbers, exact code snippets, and concrete fixes. Never say "consider reviewing" — say exactly what is wrong and how to fix it.
- **Check test files too**: Test files should be audited against `test-*` rules AND general rules (style, typing, naming).
- **No false positives**: Only report actual violations. If code is correct, say so. If a rule doesn't apply to a file (e.g., `api-*` rules for a non-API file), note it as N/A for that file.
- **Prioritize by impact**: Present CRITICAL findings first, then HIGH, then MEDIUM-HIGH, etc.
- **Cross-file analysis**: Some rules (circular imports, layer boundaries, DRY) require looking at relationships between files. Do this.
- **Confirm coverage**: At the end, list every rule ID and whether it found violations or passed clean. This proves all 65 rules were checked.
