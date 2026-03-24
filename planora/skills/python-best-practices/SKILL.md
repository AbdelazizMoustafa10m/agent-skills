---
name: python-best-practices
description: Python 3.12+ best practices for production microservices, derived from senior engineering review patterns. This skill should be used when writing, reviewing, or refactoring Python code to ensure quality, type safety, and maintainability. Triggers on tasks involving Python functions, classes, FastAPI endpoints, Pydantic models, pytest tests, async code, database operations, or code quality improvements.
---

# Python Best Practices

Comprehensive quality and maintainability guide for Python 3.12+ production microservices, derived from senior engineering code review patterns. Contains 65 rules across 12 categories, prioritized by impact to guide automated refactoring and code generation.

## When to Apply

Reference these guidelines when:
- Writing new Python functions, classes, or modules
- Implementing FastAPI endpoints or Pydantic models
- Writing or reviewing pytest tests
- Refactoring existing Python code for quality
- Reviewing code for type safety, error handling, or naming issues
- Working with async/await patterns
- Writing database queries or ORM operations
- Configuring service observability or quality gates

## Rule Categories by Priority

| Priority | Category | Impact | Prefix | Rules |
|----------|----------|--------|--------|-------|
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

## Quick Reference

### 1. Code Simplification & DRY (CRITICAL)

- `style-early-return` - Use early returns to reduce nesting
- `style-comprehension-over-loop` - Use comprehensions for simple transformations
- `style-ternary-expression` - Use conditional expressions for simple assignments
- `style-walrus-operator` - Use walrus operator to avoid redundant computation
- `style-extract-duplicate-logic` - Extract repeated code into helper functions
- `style-avoid-mutable-defaults` - Never use mutable default arguments
- `style-use-utc-aware-datetime` - Use UTC-aware timestamps everywhere

### 2. Type Safety & Annotations (CRITICAL)

- `typing-pep695-syntax` - Use PEP 695 type alias syntax (Python 3.12+)
- `typing-narrow-types` - Use narrow types over broad ones
- `typing-narrow-unions` - Narrow union types with isinstance checks
- `typing-union-syntax` - Use union syntax with pipe operator
- `typing-typed-dict` - Use TypedDict for structured dictionaries
- `typing-strenum` - Use StrEnum for string enumerations
- `typing-avoid-unjustified-optional` - Avoid Optional when None is not valid
- `typing-avoid-cast-misuse` - Avoid cast() and type: ignore misuse

### 3. Error Handling & Resilience (HIGH)

- `error-specific-exceptions` - Catch specific exceptions, never bare except
- `error-raise-from` - Use exception chaining with raise...from
- `error-context-in-messages` - Include context in error messages
- `error-custom-exceptions` - Define custom exception hierarchies
- `error-dont-swallow` - Never silently swallow exceptions
- `error-http-error-mapping` - Map domain exceptions to HTTP status codes
- `error-transient-retry-with-jitter` - Retry transient errors with backoff and jitter
- `error-db-errors-to-503` - Map recoverable DB errors to HTTP 503

### 4. Testing Best Practices (HIGH)

- `test-parametrize` - Use parametrize for multiple test cases
- `test-fixtures-over-setup` - Use fixtures instead of setUp/tearDown
- `test-assert-specific` - Use specific assertions
- `test-arrange-act-assert` - Structure tests with Arrange-Act-Assert
- `test-mock-boundaries` - Mock at boundaries, not internals
- `test-factory-pattern` - Use factory functions for test data
- `test-async-fixtures` - Use async fixtures properly
- `test-isolation` - Ensure test independence and isolation

### 5. Architecture & Structure (HIGH)

- `arch-single-responsibility` - One module, one responsibility
- `arch-dependency-injection` - Inject dependencies, don't import globals
- `arch-interface-segregation` - Define narrow protocols and interfaces
- `arch-app-factory` - Use application factory pattern
- `arch-layered-imports` - Respect layer boundaries in imports
- `arch-avoid-circular-imports` - Prevent circular import dependencies
- `arch-add-otel-spans-on-client-ops` - Add OpenTelemetry spans to client operations

### 6. Pydantic & Data Models (MEDIUM-HIGH)

- `model-frozen-models` - Use frozen models for immutable data
- `model-field-validators` - Use field_validator over root_validator
- `model-config-dict` - Use model_config dict, not inner Config class
- `model-discriminated-unions` - Use discriminated unions for polymorphism
- `model-avoid-dict-access` - Use model attributes, not dict access

### 7. Naming & Readability (MEDIUM)

- `naming-descriptive-variables` - Use descriptive names over abbreviations
- `naming-boolean-prefix` - Prefix booleans with is/has/should/can
- `naming-avoid-shadowing` - Don't shadow built-in names or outer variables

### 8. FastAPI & API Design (MEDIUM)

- `api-response-models` - Always define response models
- `api-dependency-injection` - Use Depends() for shared logic
- `api-status-codes` - Use explicit HTTP status codes
- `api-router-factory` - Use router factory pattern
- `api-versioning` - Version APIs explicitly

### 9. Async & Concurrency (MEDIUM)

- `async-gather-independent` - Use asyncio.gather for independent operations
- `async-avoid-sync-in-async` - Never call blocking code in async functions
- `async-context-managers` - Use async context managers for resource cleanup
- `async-task-groups` - Use TaskGroup for structured concurrency
- `async-timeouts-and-cancellation` - Apply timeouts and respect cancellation
- `async-close-session-only-if-local` - Close sessions only if created locally

### 10. Database & ORM Patterns (MEDIUM)

- `db-begin-nested-retry-race-prone-insert` - Use begin_nested retry for race-prone inserts
- `db-never-concatenate-sql-input` - Never concatenate user input into SQL
- `db-use-upsert-for-idempotent-writes` - Use upsert for idempotent writes

### 11. Configuration & Security (LOW-MEDIUM)

- `config-pydantic-settings` - Use pydantic-settings for configuration
- `config-no-secrets-in-code` - Never hardcode secrets or credentials
- `config-environment-separation` - Separate configuration by environment

### 12. Operations & Quality Gates (LOW-MEDIUM)

- `ops-run-quality-gates-before-pr` - Run full quality gates before PR
- `ops-never-log-secrets-hash-tokens` - Never log secrets, hash tokens first

## How to Use

Read individual rule files for detailed explanations and code examples:

```
rules/style-early-return.md
rules/typing-pep695-syntax.md
rules/db-begin-nested-retry-race-prone-insert.md
```

Each rule file contains:
- Brief explanation of why it matters
- Incorrect code example with explanation
- Correct code example with explanation
- Additional context and references

## Full Compiled Document

For the complete guide with all rules expanded: `AGENTS.md`
