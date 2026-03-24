---
name: implement-python
description: Implements production-grade, type-safe, maintainable Python code. Use when writing new modules, refactoring existing code, or ensuring strict mypy/ruff/pylint compliance. Applies to requests mentioning "production-ready", "professional", "high-quality", "implement this plan", or "write Python code".
---

# Production-Grade Python Implementation

## Overview

Production Python means: **type-safe, defensive, simple, and modern**. Never over-engineer. Implement exactly what's requested.

## The Iron Law

```
IMPLEMENT EXACTLY WHAT WAS REQUESTED. NOTHING MORE.
```

**Violations:**
- Creating documentation files not requested
- Adding features "for completeness"
- Building abstractions for hypothetical futures
- Adding tests when only implementation was requested

## Thinking Protocol

Before writing code, think through:

```
1. REQUIREMENTS: What exactly is being asked?
2. SCOPE: What is NOT being asked? (Don't build it)
3. DESIGN: Which principles apply? (SRP, DI, encapsulation)
4. TYPES: What type hints and validations are needed?
5. TESTABILITY: Can this be tested without complex mocks?
6. SIMPLICITY CHECK: Am I over-engineering?
```

**Self-check questions:**
- Can I describe each class in one sentence without "and"?
- Can I test this without mocking 5 things?
- If I change internals, will client code break?
- Are my functions pure (no side effects) where possible?

## Quick Reference

| Principle | Pattern |
|-----------|---------|
| Type hints | All signatures, use `X \| None` not `Optional[X]` |
| Validation | Fail-fast at function entry |
| Dependencies | Inject via `Protocol`, don't instantiate |
| Private state | Underscore prefix, expose via `@property` |
| Paths | Always `pathlib.Path`, never string concat |
| Errors | Specific exceptions, clear messages |
| Pure functions | Prefer no side effects, separate I/O from logic |

## Implementation Checklist

- [ ] Uses native type syntax (`list[str]` not `List[str]`)
- [ ] Input validation at function entry
- [ ] Specific exceptions with clear messages
- [ ] Dependencies injected, not instantiated
- [ ] Private members use underscore prefix
- [ ] Pure functions where possible (no side effects)
- [ ] Business logic separated from I/O
- [ ] Easy to unit test without complex mocks
- [ ] No over-engineering (YAGNI)
- [ ] No files/features not requested

## Output Format

**Always deliver:**
1. Code with type hints
2. Verification commands (`uv run mypy --strict`, `uv run ruff check`)

**Only if requested:** Tests, documentation, additional modules

## Verification Workflow

Copy and complete this checklist:

```
- [ ] uv run mypy --strict
- [ ] uv run ruff check
- [ ] uv run pylint (if configured)
```

Fix all issues before marking complete.

## Red Flags - STOP and Simplify

If you're about to:
- Create a file that wasn't requested
- Add "nice to have" features
- Build abstractions for "future extensibility"
- Add documentation when only code was requested
- Create multiple modules when one suffices

**STOP. Delete the extra. Implement only what's needed.**

## Reference

For version-specific features and detailed patterns, see `REFERENCE.md` in this directory.
