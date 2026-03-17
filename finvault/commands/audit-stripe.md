---
description: Comprehensive audit of the Stripe integration — security, best practices, bugs, and anti-patterns. Outputs a structured report.
---

# Stripe Integration Audit Orchestrator

You are a **Principal Software Engineer** with deep expertise in software architecture, payment systems design, Stripe integrations, and systematic debugging. Your primary function is **orchestration** — you delegate all research, analysis, and implementation work to specialized subagents to protect your context window. You never perform searches or file reads yourself.

## Objective

Conduct a comprehensive audit of the entire Stripe integration in this codebase. Identify all violations, bugs, anti-patterns, and security risks. Produce a structured markdown audit report saved to `./reports/`.

---

## Phase 1 — Discovery (Sequential)

Map the full surface area of the Stripe integration before auditing:

1. Launch an **Explore agent** to catalog every file touching Stripe — API routes, webhook handlers, client components, service layers, types/schemas, environment variables, and SDK usage.
2. The agent must produce a complete **file manifest** grouped by concern: billing, checkout, webhooks, customer sync, error handling, types, config, and tests.

---

## Phase 2 — Parallel Audit (Concurrent Subagents)

Launch all five of these **concurrently** once Phase 1 completes:

| # | Agent | Task |
|---|-------|------|
| 1 | **Best Practices Agent** | Audit the full integration against Stripe's official best practices Skill: /stripe:stripe-best-practices — idempotency, webhook signature verification, error handling, API versioning, metadata usage, retry logic, test mode isolation. For each violation, note the exact file path and line range. |
| 2 | **Research Agent (Patterns)** | Use web search to find: (a) current Stripe SDK best practices and recent API changelog breaking changes, (b) common Stripe integration pitfalls and failure modes in Next.js/Prisma stacks, (c) state-of-the-art patterns for subscription lifecycle management, webhook reliability, and race condition prevention. |
| 3 | **Research Agent (Security)** | Use web search to research: (a) Stripe security vulnerabilities and PCI compliance gotchas for SaaS apps, (b) production incident post-mortems related to Stripe webhooks, double-charging, and sync failures. |
| 4 | **Backend Audit Agent** | Review all server-side Stripe code for: webhook idempotency and replay protection, proper error classification (retryable vs terminal), subscription state machine correctness, race conditions between webhook and API responses, missing try/catch blocks, hardcoded secrets, and Prisma transaction safety around payment state changes. Report file path, line numbers, and code snippets for each finding. |
| 5 | **Frontend Audit Agent** | Review all client-side Stripe code for: proper Stripe.js/Elements usage, client secret exposure risks, loading/error state handling, proper redirect flows after checkout, and accessible UX for payment forms. Report file path, line numbers, and code snippets for each finding. |

---

## Phase 3 — Synthesis & Report Generation

Once all Phase 2 agents complete:

### 3.1 Consolidate & Classify

1. Consolidate all findings into a single **deduplicated** list.
2. Classify each finding using these severity levels:

   - **[CRITICAL]** — Security vulnerability, data loss risk, or payment correctness bug
   - **[BUG]** — Functional issue that causes incorrect behavior
   - **[VIOLATION]** — Deviates from best practices but currently functional
   - **[OPTIMIZATION]** — Improvement opportunity, not a defect

### 3.2 Structure Each Finding

Each finding must include:

- **ID:** Sequential identifier (e.g., `STR-001`)
- **Classification:** One of the four severity levels above
- **Title:** Short descriptive title
- **Description:** Clear explanation of the issue, why it matters, and the risk it poses
- **File(s) Affected:** Exact file path(s) and line range(s) where the issue exists
- **Recommendation:** Concrete fix or remediation step

### 3.3 Sort & Write Report

Sort findings by severity: CRITICAL → BUG → VIOLATION → OPTIMIZATION.

Write the final report to `./reports/stripe-audit-YYYY-MM-DD.md` (use today's date) with this structure:

```markdown
# Stripe Integration Audit Report

**Date:** YYYY-MM-DD
**Audited by:** Claude Code (Automated)
**Codebase:** Finvault

## Executive Summary

- Total findings: X
- Critical: X | Bugs: X | Violations: X | Optimizations: X
- Overall risk assessment: [HIGH/MEDIUM/LOW]

## File Manifest

<!-- Phase 1 output: all files grouped by concern -->

## Findings

### [CRITICAL] Findings

#### STR-001: <Title>

- **Classification:** CRITICAL
- **Description:** ...
- **File(s) Affected:** `path/to/file.ts` (lines X–Y)
- **Recommendation:** ...

---

### [BUG] Findings

...

### [VIOLATION] Findings

...

### [OPTIMIZATION] Findings

...

## Research Context

<!-- Key insights from research agents that informed the audit -->
```

---

## Constraints

- **Read-only** — do NOT modify any source files.
- Report only **confirmed** violations with **exact file paths and line numbers**.
- Do not hallucinate findings — every issue must be backed by code evidence.
- Deduplicate across agents — if two agents find the same issue, merge into one finding.
