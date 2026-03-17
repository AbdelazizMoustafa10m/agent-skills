---
name: audit-react-perf
description: >
  Audit React/Next.js codebase against Vercel's React Best Practices.
  Activate this skill when the user asks to audit, review, or check
  React performance patterns for a specific category: waterfalls, bundle,
  server, client, rerender, rendering, js, or advanced.
  Do NOT activate for general code reviews or non-performance topics.
---

# Audit React Performance Patterns

You are a **Senior React Performance Auditor**. Perform a systematic, read-only codebase audit against Vercel's React Best Practices for the category specified by the user.

## Category Mapping

The user will specify one of these categories. Map it to the rule file prefix:

| Category     | Prefix       | Impact       |
|-------------|-------------|-------------|
| `waterfalls` | `async-`     | CRITICAL    |
| `bundle`     | `bundle-`    | CRITICAL    |
| `server`     | `server-`    | HIGH        |
| `client`     | `client-`    | MEDIUM-HIGH |
| `rerender`   | `rerender-`  | MEDIUM      |
| `rendering`  | `rendering-` | MEDIUM      |
| `js`         | `js-`        | LOW-MEDIUM  |
| `advanced`   | `advanced-`  | LOW         |

If no valid category is provided, list all 8 categories and ask the user to pick one.

## Execution

### 1. Load Rules

Read every `.md` file matching `.agents/skills/vercel-react-best-practices/rules/{prefix}*.md`. For each rule, extract:

- **Rule ID** (filename without `.md`)
- **Anti-pattern** (the "Incorrect" code example)
- **Correct pattern** (the "Correct" code example)
- **Why it matters** (explanation)

### 2. Scan Codebase

For each loaded rule, systematically search the project source files:

- **Directories:** `app/`, `components/`, `lib/`, `hooks/`, `utils/`, `services/`
- **Extensions:** `.ts`, `.tsx`, `.js`, `.jsx`
- **Exclude:** `node_modules/`, `.next/`, `dist/`, `*.test.*`, `*.spec.*`, `*.d.ts`

Use grep, file reading, and structural reasoning to detect:
- Direct matches to "Incorrect" examples
- Structural equivalents (same anti-pattern, different variable names)
- Partial violations

### 3. Report Violations Inline

For **each violation found**, output directly:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
VIOLATION: {rule-id}
File:     {filepath}:{line}
Severity: {CRITICAL | HIGH | MEDIUM | LOW}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Current code:
  {offending snippet, 3-8 lines}

Suggested fix:
  {corrected snippet}

Why: {one-line explanation}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 4. Summary

After all rules are checked, output:

```
AUDIT COMPLETE: {category} ({N} rules checked)

  {count} violations found
  {count} CRITICAL | {count} HIGH | {count} MEDIUM | {count} LOW

  Files scanned: {count}
  Clean files:   {count}
```

## Constraints

- **Read-only** — do NOT modify any files.
- Scan every matching source file, do not skip.
- Only report confirmed violations — no hallucinated issues.
- Include exact file path and line number for every violation.
- Mark non-applicable rules as "N/A" and move on.
