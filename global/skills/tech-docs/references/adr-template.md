# ADR Reference Templates

This file contains templates for all four ADR formats. Use the format that matches the user's
needs (see SKILL.md for selection guidance). Always fill in project-specific content based on
the codebase and user's description — never leave placeholder brackets in the final output.

## Table of Contents

- [Format 1: Structured MADR (Default)](#format-1-structured-madr)
- [Format 2: MADR (Lightweight)](#format-2-madr)
- [Format 3: Classic Nygard](#format-3-classic-nygard)
- [Format 4: Y-Statement](#format-4-y-statement)
- [Writing Guidance](#writing-guidance)
- [Reviewer Checklist](#reviewer-checklist)

---

## Format 1: Structured MADR

Use this format when teams need machine-readable metadata, traceability, compliance tracking,
or automated tooling integration. The YAML frontmatter makes it queryable by tools and AI
assistants.

```markdown
---
id: ADR-NNN
title: [Outcome-focused title: "Use X" not "X vs Y?"]
status: PROPOSED | ACCEPTED | DEPRECATED | SUPERSEDED
date: YYYY-MM-DD
decision_makers: [names]
consulted: [names — people whose input was sought]
informed: [names — people who need to know the outcome]
confidence: HIGH | MEDIUM | LOW
tags: [database, security, infrastructure, api, etc.]
related_decisions: [ADR-NNN, ADR-NNN]
supersedes: [ADR-NNN, if applicable]
superseded_by: [ADR-NNN, if applicable]
---

# ADR-NNN: [Title]

## Status

[PROPOSED | ACCEPTED | DEPRECATED | SUPERSEDED by ADR-NNN]

## Context and Problem Statement

[2-3 paragraphs describing the situation that requires a decision. Include:]
- What system or component is affected?
- What problem or opportunity prompted this decision?
- What constraints exist (technical, business, regulatory)?

### Business Context

- [Current state and projected growth]
- [Team capabilities and expertise]
- [Regulatory or compliance requirements]
- [Cost constraints]

## Decision Drivers

| Driver | Priority | Why It Matters |
|---|---|---|
| [Driver 1] | Critical / High / Medium / Low | [Impact explanation] |
| [Driver 2] | ... | ... |
| [Driver 3] | ... | ... |

## Considered Options

### Option 1: [Name] (CHOSEN)

**Overview:** [1-2 sentence description]

**Pros:**
- [Benefit with concrete justification]

**Cons:**
- [Drawback with concrete impact]

**Risk Assessment:**
| Risk Type | Level | Detail |
|---|---|---|
| Technical | Low / Medium / High | [Specific technical risk] |
| Schedule | Low / Medium / High | [Impact on timeline] |
| Ecosystem | Low / Medium / High | [Vendor, community, maturity risk] |

**Trade-offs:**
- [What we gain vs. what we give up]

---

### Option 2: [Name]

**Overview:** [1-2 sentence description]

**Pros:**
- [Benefit]

**Cons:**
- [Drawback]

**Why not chosen:**
- [Specific reason tied to decision drivers]

---

### Option 3: [Name] (if applicable)

[Same structure as Option 2]

## Decision

**We have decided to [clear statement of the decision].**

### Implementation Details

- [Key implementation specifics]
- [Configuration, versions, deployment approach]
- [Integration points]

### When to Revisit This Decision

- [Specific trigger condition 1 — e.g., "If write QPS exceeds 100K"]
- [Specific trigger condition 2 — e.g., "If schema changes become frequent"]
- [Specific trigger condition 3 — e.g., "If cost exceeds $X/month"]

## Consequences

### Positive

- [Benefit with concrete impact]

### Negative

- [Cost or risk with concrete impact]

### Neutral

- [Changes that are neither clearly positive nor negative]

## Validation and Monitoring

| Success Metric | Target | How to Measure |
|---|---|---|
| [Metric 1] | [Target] | [Measurement method] |
| [Metric 2] | [Target] | [Measurement method] |

**Review Schedule:**
- [Frequency]: [What to check]
- Annually: Reassess decision against alternatives

## Related Decisions

- **ADR-NNN:** [Title](./NNN-title.md) — [relationship: enables, constrains, supersedes]

## References

- [Resources that informed this decision]

## Audit Log

| Date | Auditor | Finding | Action |
|---|---|---|---|
| YYYY-MM-DD | [Name] | [Finding] | [Action taken] |

## Approval

| Role | Name | Date |
|---|---|---|
| [Tech Lead / Architect] | [Name] | YYYY-MM-DD |
| [Security / Compliance] | [Name] | YYYY-MM-DD |

## Document History

| Version | Date | Author | Changes |
|---|---|---|---|
| 1.0 | YYYY-MM-DD | [Author] | Initial version (PROPOSED) |
```

---

## Format 2: MADR

Use this format for most teams. Balances structure with simplicity. No YAML frontmatter
required, but sections ensure consistent coverage.

```markdown
# ADR-NNN: [Outcome-focused title]

**Status:** PROPOSED | ACCEPTED | DEPRECATED | SUPERSEDED by ADR-NNN
**Date:** YYYY-MM-DD
**Decision Makers:** [Names]
**Consulted:** [Names]
**Informed:** [Names]

## Context and Problem Statement

[Describe the situation and the problem that needs a decision. 2-3 paragraphs.]

## Decision Drivers

- [Driver 1 — why it matters]
- [Driver 2 — why it matters]
- [Driver 3 — why it matters]

## Considered Options

1. [Option 1 — chosen]
2. [Option 2]
3. [Option 3]

## Decision Outcome

**Chosen option:** "[Option 1]", because [1-2 sentence justification tied to drivers].

### Positive Consequences

- [Benefit]

### Negative Consequences

- [Cost or risk]

## Pros and Cons of the Options

### [Option 1]

- Good, because [reason]
- Bad, because [reason]

### [Option 2]

- Good, because [reason]
- Bad, because [reason]

### [Option 3]

- Good, because [reason]
- Bad, because [reason]

## Related Decisions

- [ADR-NNN: Title](./NNN-title.md)

## Notes

[Any additional context, discussion highlights, or future considerations]
```

---

## Format 3: Classic Nygard

Use this format for simple, human-readable records. Minimal overhead, fast to write. Ideal
when the team values brevity and the decision is straightforward.

```markdown
# ADR-NNN: [Short title]

**Date:** YYYY-MM-DD
**Status:** Proposed | Accepted | Deprecated | Superseded by ADR-NNN

## Context

[What is the issue that we are seeing that is motivating this decision or change? Describe the
forces at play — technical, business, organizational.]

## Decision

[What is the change that we are proposing and/or doing? State in active voice:
"We will use PostgreSQL for all new services."]

## Consequences

[What becomes easier or more difficult because of this change? Include both positive and
negative consequences.]

### Alternatives Considered

[Brief summary of options rejected and why. Keep to 2-3 sentences per alternative.]
```

---

## Format 4: Y-Statement

Use this format for ultra-fast capture of tactical, low-risk decisions. The entire ADR is a
single structured sentence. Best for decisions that need to be recorded but don't warrant
a full analysis.

```markdown
# ADR-NNN: [Short title]

**Date:** YYYY-MM-DD
**Status:** Accepted

In the context of [situation/system area],
facing [the problem or requirement],
we decided for [chosen option]
and neglected [rejected alternatives],
to achieve [desired outcome/quality],
accepting [trade-off or downside],
because [brief justification].
```

---

## Writing Guidance

### Title Conventions
- Use outcome-focused titles: "Use PostgreSQL for Order Data" not "PostgreSQL vs MongoDB?"
- Start with a verb: Use, Adopt, Implement, Migrate, Replace
- Keep under 60 characters

### Status Lifecycle
```
PROPOSED → ACCEPTED → [lives indefinitely]
                    → DEPRECATED (no longer relevant)
                    → SUPERSEDED by ADR-NNN (replaced by newer decision)
```
Never delete an accepted ADR. If a decision changes, create a new ADR that supersedes the old one.

### Filing Convention
- Store in `docs/adr/` or `decisions/` with sequential numbering
- Filename format: `NNN-kebab-case-title.md` (e.g., `001-use-postgresql.md`)
- To find the next number, check existing files in the ADR directory

### Content Tips
- **One decision per ADR.** If you're covering two decisions, split into two ADRs.
- **Write at decision time**, not retroactively. Context is freshest during the decision.
- **Be honest about consequences.** Every decision has trade-offs — document them.
- **Include rejected alternatives.** The reasoning behind rejections is often more valuable than the choice itself.
- **Keep it concise.** 2-4 pages max. Longer ADRs indicate scope creep.
- **Link to design docs** for implementation details rather than duplicating content.

---

## Reviewer Checklist

Use this checklist when reviewing an ADR for completeness and quality:

- [ ] **Problem is clear** — A new team member can understand why this decision was needed
- [ ] **Decision drivers are listed** — The factors that matter most are explicit
- [ ] **Options are complete** — At least 2 realistic alternatives are compared
- [ ] **Pros/cons are balanced** — Not a sales pitch for the chosen option
- [ ] **Trade-offs are explicit** — What we gain AND what we sacrifice
- [ ] **Consequences are honest** — Both positive and negative outcomes documented
- [ ] **Revisit triggers exist** — Conditions that would invalidate the decision
- [ ] **Title is outcome-focused** — States what we're doing, not the question
- [ ] **Status and metadata are set** — Date, decision makers, status are filled in
- [ ] **Stored correctly** — In `docs/adr/` with sequential numbering
