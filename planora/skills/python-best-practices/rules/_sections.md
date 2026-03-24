# Sections

This file defines all sections, their ordering, impact levels, and descriptions.
The section ID (in parentheses) is the filename prefix used to group rules.

---

## 1. Code Simplification & DRY (style)

**Impact:** CRITICAL
**Description:** Redundant code, unnecessary complexity, and DRY violations are the most common review findings. Simplifying code yields the largest maintainability and readability gains.

## 2. Type Safety & Annotations (typing)

**Impact:** CRITICAL
**Description:** Strict typing catches bugs at development time, enables IDE support, and makes code self-documenting. Python 3.12+ syntax should be used consistently.

## 3. Error Handling & Resilience (error)

**Impact:** HIGH
**Description:** Proper error handling prevents silent failures, provides meaningful diagnostics, maps domain errors to correct HTTP semantics, and retries transient failures safely.

## 4. Testing Best Practices (test)

**Impact:** HIGH
**Description:** Well-structured tests with proper fixtures, parametrization, and assertions improve reliability and reduce maintenance cost.

## 5. Architecture & Structure (arch)

**Impact:** HIGH
**Description:** Clean module boundaries, dependency injection, layered architecture, and observability instrumentation reduce coupling and enable independent service evolution.

## 6. Pydantic & Data Models (model)

**Impact:** MEDIUM-HIGH
**Description:** Pydantic v2 patterns for validation, serialization, and configuration ensure data integrity at system boundaries.

## 7. Naming & Readability (naming)

**Impact:** MEDIUM
**Description:** Clear, consistent naming reduces cognitive load and makes code intent immediately apparent to readers and AI agents.

## 8. FastAPI & API Design (api)

**Impact:** MEDIUM
**Description:** Consistent API patterns with proper response models, dependency injection, and versioning enable reliable service interfaces.

## 9. Async & Concurrency (async)

**Impact:** MEDIUM
**Description:** Correct async patterns prevent blocking, enable parallelism, enforce timeouts, manage session lifecycle, and ensure proper resource cleanup in concurrent systems.

## 10. Database & ORM Patterns (db)

**Impact:** MEDIUM
**Description:** SQLAlchemy async patterns that are race-safe, idempotent, and injection-safe for production database operations.

## 11. Configuration & Security (config)

**Impact:** LOW-MEDIUM
**Description:** Externalized configuration and secure defaults prevent secrets leakage and enable environment-specific deployments.

## 12. Operations & Quality Gates (ops)

**Impact:** LOW-MEDIUM
**Description:** Operational correctness requires secret hygiene in logs, mandatory quality gate execution, and telemetry wiring before code reaches review.
