# Python Best Practices (Merged)

A structured repository for creating and maintaining Python Best Practices optimized for agents and LLMs. This is the merged super-skill combining the best rules from two independently generated skill sets.

## Structure

- `rules/` - Individual rule files (one per rule)
  - `_sections.md` - Section metadata (titles, impacts, descriptions)
  - `_template.md` - Template for creating new rules
  - `area-description.md` - Individual rule files
- `metadata.json` - Document metadata (version, organization, abstract)
- __`AGENTS.md`__ - Compiled output with all rules expanded
- __`SKILL.md`__ - Skill definition with frontmatter and quick reference
- `MERGE_NOTES.md` - Detailed notes on merge decisions

## Rule File Structure

Each rule file follows this structure:

```markdown
---
title: Rule Title Here
impact: MEDIUM
impactDescription: Optional description
tags: tag1, tag2, tag3
---

## Rule Title Here

Brief explanation of the rule and why it matters.

**Incorrect (description of what's wrong):**

\```python
# Bad code example
\```

**Correct (description of what's right):**

\```python
# Good code example
\```

Reference: [Link](https://example.com)
```

## Creating a New Rule

1. Copy `rules/_template.md` to `rules/area-description.md`
2. Choose the appropriate area prefix:
   - `style-` for Code Simplification & DRY (Section 1)
   - `typing-` for Type Safety & Annotations (Section 2)
   - `error-` for Error Handling & Resilience (Section 3)
   - `test-` for Testing Best Practices (Section 4)
   - `arch-` for Architecture & Structure (Section 5)
   - `model-` for Pydantic & Data Models (Section 6)
   - `naming-` for Naming & Readability (Section 7)
   - `api-` for FastAPI & API Design (Section 8)
   - `async-` for Async & Concurrency (Section 9)
   - `db-` for Database & ORM Patterns (Section 10)
   - `config-` for Configuration & Security (Section 11)
   - `ops-` for Operations & Quality Gates (Section 12)
3. Fill in the frontmatter and content
4. Ensure you have clear incorrect/correct examples
5. Rules are sorted alphabetically by title within each section

## Impact Levels

- `CRITICAL` - Highest priority, major quality/correctness gains
- `HIGH` - Significant improvements to reliability and maintainability
- `MEDIUM-HIGH` - Moderate-high gains in code quality
- `MEDIUM` - Moderate improvements to readability and consistency
- `LOW-MEDIUM` - Incremental improvements for specific scenarios
- `LOW` - Minor optimizations and edge cases

## File Naming Convention

- Files starting with `_` are special (templates, metadata)
- Rule files: `area-description.md` (e.g., `style-early-return.md`)
- Section is automatically inferred from filename prefix
- Rules are sorted alphabetically by title within each section

## Contributing

When adding or modifying rules:

1. Use the correct filename prefix for your section
2. Follow the `_template.md` structure
3. Include clear incorrect/correct examples with explanations
4. Add appropriate tags
5. Use Python 3.12+ syntax in all examples

## Source

Merged from two independently generated skill sets, both derived from senior engineering review patterns on a Python 3.12+ FastAPI/Pydantic/SQLAlchemy microservices monorepo.
