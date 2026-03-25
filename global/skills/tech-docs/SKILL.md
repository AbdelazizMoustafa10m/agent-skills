---
name: tech-docs
description: >
  Generate professional Architecture Documents, Software Design Documents (SDD/TDD), and
  Architecture Decision Records (ADRs) using SOTA templates based on C4+arc42, Google-style
  design docs, and Structured MADR formats. Use this skill whenever the user wants to create,
  write, or generate any technical documentation including: architecture documents, system design
  docs, software design documents, technical design documents, design docs, ADRs, decision records,
  RFCs, or technical specifications. Also trigger when the user says things like "document this
  decision", "write up the architecture", "create a design doc for this feature", "I need an ADR",
  or asks to document technical decisions, system design, or architecture. Even if they just say
  "document this" in a technical context, this skill likely applies.
---

# Tech Docs: Architecture, Design, and Decision Documentation

You are generating professional technical documentation. This skill supports three document types,
each serving a distinct purpose in the documentation hierarchy:

| Document | Purpose | Audience | Lifecycle |
|---|---|---|---|
| **Architecture Document** | System-wide structure, boundaries, and major choices | Architects, leads, new joiners | Stable; updated when structure changes |
| **Design Document (SDD/TDD)** | Implementation plan for a specific feature/change | Engineers building the feature + reviewers | Change-driven; written before implementation |
| **ADR** | Capture the "why" behind a single architectural decision | Current team + future maintainers | Immutable once accepted; superseded, never deleted |

## Step 1: Determine Document Type

If the user hasn't specified, determine from context:
- Talking about a **specific decision** (database choice, framework, pattern) → **ADR**
- Planning a **feature, service, or major change** → **Design Document**
- Describing the **overall system** or onboarding documentation → **Architecture Document**

Ask if ambiguous: "Would you like an ADR (single decision), a Design Doc (feature plan), or an Architecture Document (system overview)?"

## Step 2: Gather Context

Before generating, understand the project:

1. **Read the codebase** — scan the project structure, README, existing docs, and any `docs/adr/` or `docs/design/` directories to understand the system
2. **Check for existing ADRs** — if generating an ADR, find the next sequential number
3. **Ask the user** about anything you can't determine from code:
   - For ADRs: What decision needs to be made? What options are being considered?
   - For Design Docs: What feature/change? What problem does it solve?
   - For Architecture Docs: What system? What level of detail (MVP, production, comprehensive)?

## Step 3: Generate the Document

Read the appropriate reference template and generate the document:

- **ADR** → Read `references/adr-template.md` for full template guidance
- **Design Document** → Read `references/design-doc-template.md` for full template guidance
- **Architecture Document** → Read `references/architecture-template.md` for full template guidance

### Key principles for all document types

**Trade-offs over prescriptions.** The most valuable part of any technical document is the explicit
statement of what was gained and what was sacrificed. Every design choice involves trade-offs —
document them honestly. "We chose X, accepting Y as a consequence" is more useful than "We chose X
because it's better."

**Why before What.** Always explain the problem and motivation before presenting the solution.
A reader who understands why a decision matters can evaluate whether the chosen approach still
makes sense as circumstances change.

**Concrete and measurable.** Prefer "p99 latency < 200ms" over "fast." Prefer "supports 50K
concurrent users" over "scalable." Quantified targets make documents actionable and reviewable.

**Diagrams as code.** Use Mermaid syntax for all diagrams so they render in GitHub/GitLab and
are version-controllable. Every architecture doc should have at least a C4 Context diagram and
a Container diagram.

**Docs-as-code.** Documents live in the repo alongside the code they describe. Store ADRs in
`docs/adr/` (or `decisions/`), design docs in `docs/design/`, and the architecture doc at
`docs/architecture.md`. This makes them discoverable, reviewable in PRs, and versioned.

## Step 4: File Placement

Suggest appropriate file placement based on project conventions:

```
docs/
├── architecture.md              # System architecture (one per system)
├── design/                      # Feature/change design docs
│   ├── YYYY-MM-DD-feature-name.md
│   └── ...
└── adr/                         # Decision records (immutable log)
    ├── 001-decision-title.md
    ├── 002-decision-title.md
    └── ...
```

If the project already has a different convention (e.g., `decisions/`, `docs/decisions/`), follow
the existing pattern.

## ADR Format Selection

ADRs come in multiple formats. Default to **Structured MADR** but adapt based on context:

| Format | When to use | Complexity |
|---|---|---|
| **Structured MADR** (default) | Teams needing traceability, automation, or compliance | High |
| **MADR** | Good balance of structure and simplicity for most teams | Medium |
| **Classic Nygard** | Simple human-readable records, minimal overhead | Low |
| **Y-statement** | Ultra-fast capture of tactical, low-risk decisions | Minimal |

If the user says "quick ADR" or "simple ADR", use Classic Nygard or Y-statement format.
If the user mentions compliance, audit, or machine-readable, use Structured MADR.

## Architecture Document Detail Levels

Scale the architecture document to the project's maturity:

- **MVP / Prototype**: Executive Summary + System Context (C4 L1) + Key ADRs only
- **Production Service**: Add Building Blocks (C4 L2-L3) + Deployment + Cross-Cutting Concerns
- **Complex System**: Full template with all sections

Ask the user or infer from the codebase which level is appropriate.
