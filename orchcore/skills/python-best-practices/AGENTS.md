# Python Best Practices for Production Microservices

> **Version:** 1.0.0 | **Organization:** vRAGmate Engineering | **Date:** February 2026
>
> Comprehensive Python best practices guide for production microservices, designed for AI agents and LLMs. Contains 55 rules across 10 categories, prioritized by impact from critical (code simplification, type safety, error handling) to incremental (configuration, security). Each rule includes detailed explanations, real-world examples comparing incorrect vs. correct implementations, and specific impact descriptions to guide automated refactoring and code generation. Derived from senior engineering review patterns on a Python 3.12+ FastAPI/Pydantic/SQLAlchemy monorepo.
>
> **References:**
> - https://docs.python.org/3/whatsnew/3.12.html
> - https://docs.pydantic.dev/latest/
> - https://fastapi.tiangolo.com/
> - https://docs.sqlalchemy.org/en/20/
> - https://docs.pytest.org/en/stable/
> - https://docs.astral.sh/ruff/
> - https://mypy.readthedocs.io/en/stable/
> - https://peps.python.org/pep-0695/
> - https://peps.python.org/pep-0484/

---

## Table of Contents

### 1. Code Simplification & DRY (CRITICAL)
- [1.1 Never Use Mutable Default Arguments](#11-never-use-mutable-default-arguments)
- [1.2 Use Comprehensions for Simple Transformations](#12-use-comprehensions-for-simple-transformations)
- [1.3 Use Early Returns to Reduce Nesting](#13-use-early-returns-to-reduce-nesting)
- [1.4 Extract Repeated Code into Helper Functions](#14-extract-repeated-code-into-helper-functions)
- [1.5 Remove Redundant Else After Return](#15-remove-redundant-else-after-return)
- [1.6 Use F-strings for String Formatting](#16-use-f-strings-for-string-formatting)
- [1.7 Use Conditional Expressions for Simple Assignments](#17-use-conditional-expressions-for-simple-assignments)
- [1.8 Use Walrus Operator to Avoid Redundant Computation](#18-use-walrus-operator-to-avoid-redundant-computation)

### 2. Type Safety & Annotations (CRITICAL)
- [2.1 Annotate All Function Signatures](#21-annotate-all-function-signatures)
- [2.2 Use Built-in Generic Collections](#22-use-built-in-generic-collections)
- [2.3 Use Narrow Types Over Broad Ones](#23-use-narrow-types-over-broad-ones)
- [2.4 Use PEP 695 Type Alias Syntax](#24-use-pep-695-type-alias-syntax)
- [2.5 Use StrEnum for String Enumerations](#25-use-strenum-for-string-enumerations)
- [2.6 Use TypedDict for Structured Dictionaries](#26-use-typeddict-for-structured-dictionaries)
- [2.7 Use Union Syntax with Pipe Operator](#27-use-union-syntax-with-pipe-operator)

### 3. Error Handling (HIGH)
- [3.1 Include Context in Error Messages](#31-include-context-in-error-messages)
- [3.2 Define Custom Exception Hierarchies](#32-define-custom-exception-hierarchies)
- [3.3 Never Silently Swallow Exceptions](#33-never-silently-swallow-exceptions)
- [3.4 Use Exception Chaining with raise...from](#34-use-exception-chaining-with-raisefrom)
- [3.5 Catch Specific Exceptions](#35-catch-specific-exceptions)

### 4. Testing Best Practices (HIGH)
- [4.1 Structure Tests with Arrange-Act-Assert](#41-structure-tests-with-arrange-act-assert)
- [4.2 Use Specific Assertions](#42-use-specific-assertions)
- [4.3 Use Async Fixtures Properly](#43-use-async-fixtures-properly)
- [4.4 Use Factory Functions for Test Data](#44-use-factory-functions-for-test-data)
- [4.5 Use Fixtures Instead of setUp/tearDown](#45-use-fixtures-instead-of-setupteardown)
- [4.6 Ensure Test Independence and Isolation](#46-ensure-test-independence-and-isolation)
- [4.7 Mock at Boundaries, Not Internals](#47-mock-at-boundaries-not-internals)
- [4.8 Use Parametrize for Multiple Test Cases](#48-use-parametrize-for-multiple-test-cases)

### 5. Architecture & Structure (HIGH)
- [5.1 Use Application Factory Pattern](#51-use-application-factory-pattern)
- [5.2 Prevent Circular Import Dependencies](#52-prevent-circular-import-dependencies)
- [5.3 Inject Dependencies, Don't Import Globals](#53-inject-dependencies-dont-import-globals)
- [5.4 Define Narrow Protocols and Interfaces](#54-define-narrow-protocols-and-interfaces)
- [5.5 Respect Layer Boundaries in Imports](#55-respect-layer-boundaries-in-imports)
- [5.6 One Module, One Responsibility](#56-one-module-one-responsibility)

### 6. Pydantic & Data Models (MEDIUM-HIGH)
- [6.1 Use Model Attributes, Not Dict Access](#61-use-model-attributes-not-dict-access)
- [6.2 Use model_config Dict, Not Inner Config Class](#62-use-model_config-dict-not-inner-config-class)
- [6.3 Use Discriminated Unions for Polymorphism](#63-use-discriminated-unions-for-polymorphism)
- [6.4 Use field_validator Over root_validator](#64-use-field_validator-over-root_validator)
- [6.5 Use Frozen Models for Immutable Data](#65-use-frozen-models-for-immutable-data)

### 7. Naming & Readability (MEDIUM)
- [7.1 Don't Shadow Built-in Names or Outer Variables](#71-dont-shadow-built-in-names-or-outer-variables)
- [7.2 Prefix Booleans with is/has/should/can](#72-prefix-booleans-with-ishasshouldcan)
- [7.3 Follow PEP 8 Naming Conventions Strictly](#73-follow-pep-8-naming-conventions-strictly)
- [7.4 Use Descriptive Names Over Abbreviations](#74-use-descriptive-names-over-abbreviations)

### 8. FastAPI & API Design (MEDIUM)
- [8.1 Use Depends() for Shared Logic](#81-use-depends-for-shared-logic)
- [8.2 Always Define Response Models](#82-always-define-response-models)
- [8.3 Use Router Factory Pattern](#83-use-router-factory-pattern)
- [8.4 Use Explicit HTTP Status Codes](#84-use-explicit-http-status-codes)
- [8.5 Version APIs Explicitly](#85-version-apis-explicitly)

### 9. Async & Concurrency (LOW-MEDIUM)
- [9.1 Never Call Blocking Code in Async Functions](#91-never-call-blocking-code-in-async-functions)
- [9.2 Use Async Context Managers for Resource Cleanup](#92-use-async-context-managers-for-resource-cleanup)
- [9.3 Use asyncio.gather for Independent Operations](#93-use-asynciogather-for-independent-operations)
- [9.4 Use TaskGroup for Structured Concurrency](#94-use-taskgroup-for-structured-concurrency)

### 10. Configuration & Security (LOW-MEDIUM)
- [10.1 Separate Configuration by Environment](#101-separate-configuration-by-environment)
- [10.2 Never Hardcode Secrets or Credentials](#102-never-hardcode-secrets-or-credentials)
- [10.3 Use Pydantic Settings for Configuration](#103-use-pydantic-settings-for-configuration)

---

## 1. Code Simplification & DRY

**Impact:** CRITICAL
**Description:** Redundant code, unnecessary complexity, and DRY violations are the most common review findings. Simplifying code yields the largest maintainability and readability gains.

---

### 1.1 Never Use Mutable Default Arguments

Never use mutable objects (lists, dicts, sets) as default argument values. Python evaluates default arguments once at function definition time, so all calls share the same mutable object, leading to subtle bugs.

**Incorrect (mutable default argument):**

```python
def add_item(item: str, items: list[str] = []) -> list[str]:
    items.append(item)
    return items

# Bug: second call sees first call's data
result1 = add_item("a")  # ["a"]
result2 = add_item("b")  # ["a", "b"] — unexpected!


def create_config(overrides: dict[str, Any] = {}) -> dict[str, Any]:
    overrides["timestamp"] = datetime.now()
    return overrides
```

**Correct (None sentinel with factory):**

```python
def add_item(item: str, items: list[str] | None = None) -> list[str]:
    if items is None:
        items = []
    items.append(item)
    return items

result1 = add_item("a")  # ["a"]
result2 = add_item("b")  # ["b"] — correct!


def create_config(overrides: dict[str, Any] | None = None) -> dict[str, Any]:
    config = overrides if overrides is not None else {}
    config["timestamp"] = datetime.now()
    return config
```

Reference: [Python FAQ - Mutable Default Arguments](https://docs.python.org/3/faq/programming.html#why-are-default-values-shared-between-objects)

---

### 1.2 Use Comprehensions for Simple Transformations

Use list, dict, and set comprehensions for simple mapping and filtering operations instead of manual loops with append/add. Comprehensions are more Pythonic, often faster, and clearly express intent.

**Incorrect (manual loop for simple transformation):**

```python
def get_active_user_emails(users: list[User]) -> list[str]:
    emails = []
    for user in users:
        if user.is_active:
            emails.append(user.email)
    return emails


def build_lookup(items: list[Item]) -> dict[str, Item]:
    lookup = {}
    for item in items:
        lookup[item.id] = item
    return lookup
```

**Correct (comprehension):**

```python
def get_active_user_emails(users: list[User]) -> list[str]:
    return [user.email for user in users if user.is_active]


def build_lookup(items: list[Item]) -> dict[str, Item]:
    return {item.id: item for item in items}
```

Do not use comprehensions for complex logic with side effects or multiple statements — use a loop instead.

---

### 1.3 Use Early Returns to Reduce Nesting

Return early when preconditions fail or results are determined, rather than wrapping logic in deeply nested if/else blocks. This reduces indentation levels and makes the main logic path immediately visible.

**Incorrect (deeply nested with late return):**

```python
def process_document(document: Document | None, user: User) -> ProcessingResult:
    if document is not None:
        if user.has_permission("read"):
            if document.status == DocumentStatus.READY:
                content = document.extract_content()
                if content:
                    result = transform(content)
                    return ProcessingResult(data=result, status="success")
                else:
                    return ProcessingResult(data=None, status="empty")
            else:
                return ProcessingResult(data=None, status="not_ready")
        else:
            return ProcessingResult(data=None, status="forbidden")
    else:
        return ProcessingResult(data=None, status="not_found")
```

**Correct (early returns, flat structure):**

```python
def process_document(document: Document | None, user: User) -> ProcessingResult:
    if document is None:
        return ProcessingResult(data=None, status="not_found")

    if not user.has_permission("read"):
        return ProcessingResult(data=None, status="forbidden")

    if document.status != DocumentStatus.READY:
        return ProcessingResult(data=None, status="not_ready")

    content = document.extract_content()
    if not content:
        return ProcessingResult(data=None, status="empty")

    result = transform(content)
    return ProcessingResult(data=result, status="success")
```

Reference: [PEP 8 - Programming Recommendations](https://peps.python.org/pep-0008/#programming-recommendations)

---

### 1.4 Extract Repeated Code into Helper Functions

When the same logic appears in multiple places, extract it into a shared helper function. This prevents copy-paste bugs and ensures changes only need to happen in one place.

**Incorrect (duplicated validation logic):**

```python
class UserRouter:
    async def create_user(self, request: CreateUserRequest) -> User:
        if not request.email or "@" not in request.email:
            raise HTTPException(status_code=422, detail="Invalid email")
        if len(request.name) < 2:
            raise HTTPException(status_code=422, detail="Name too short")
        # ... create logic

    async def update_user(self, user_id: str, request: UpdateUserRequest) -> User:
        if not request.email or "@" not in request.email:
            raise HTTPException(status_code=422, detail="Invalid email")
        if len(request.name) < 2:
            raise HTTPException(status_code=422, detail="Name too short")
        # ... update logic
```

**Correct (extracted helper):**

```python
def _validate_user_fields(email: str, name: str) -> None:
    if not email or "@" not in email:
        raise HTTPException(status_code=422, detail="Invalid email")
    if len(name) < 2:
        raise HTTPException(status_code=422, detail="Name too short")


class UserRouter:
    async def create_user(self, request: CreateUserRequest) -> User:
        _validate_user_fields(request.email, request.name)
        # ... create logic

    async def update_user(self, user_id: str, request: UpdateUserRequest) -> User:
        _validate_user_fields(request.email, request.name)
        # ... update logic
```

---

### 1.5 Remove Redundant Else After Return

When a branch ends with `return`, `raise`, `continue`, or `break`, the `else` clause is redundant. Remove it to reduce indentation and simplify the code.

**Incorrect (redundant else after return):**

```python
def get_user_role(user: User) -> str:
    if user.is_admin:
        return "admin"
    else:
        if user.is_moderator:
            return "moderator"
        else:
            return "viewer"


def validate_input(value: str) -> str:
    if not value:
        raise ValueError("Value cannot be empty")
    else:
        return value.strip()
```

**Correct (no redundant else):**

```python
def get_user_role(user: User) -> str:
    if user.is_admin:
        return "admin"
    if user.is_moderator:
        return "moderator"
    return "viewer"


def validate_input(value: str) -> str:
    if not value:
        raise ValueError("Value cannot be empty")
    return value.strip()
```

Reference: [Ruff SIM108 - Use ternary operator](https://docs.astral.sh/ruff/rules/#flake8-simplicity-sim)

---

### 1.6 Use F-strings for String Formatting

Use f-strings for all string interpolation. They are more readable, more concise, and faster than `.format()` or `%` formatting. Use them consistently throughout the codebase.

**Incorrect (mixed formatting styles):**

```python
def log_operation(user: str, action: str, resource_id: int) -> str:
    return "User {} performed {} on resource {}".format(user, action, resource_id)


def build_url(host: str, port: int, path: str) -> str:
    return "%s:%d/%s" % (host, port, path)


def describe_error(code: int, message: str) -> str:
    return "Error " + str(code) + ": " + message
```

**Correct (f-strings):**

```python
def log_operation(user: str, action: str, resource_id: int) -> str:
    return f"User {user} performed {action} on resource {resource_id}"


def build_url(host: str, port: int, path: str) -> str:
    return f"{host}:{port}/{path}"


def describe_error(code: int, message: str) -> str:
    return f"Error {code}: {message}"
```

For complex expressions inside f-strings, assign to a variable first for readability.

Reference: [PEP 498 - Literal String Interpolation](https://peps.python.org/pep-0498/)

---

### 1.7 Use Conditional Expressions for Simple Assignments

Use Python's conditional expression (`x if condition else y`) for simple value assignments instead of full if/else blocks. This makes the assignment nature of the code immediately clear.

**Incorrect (full if/else block for simple assignment):**

```python
def get_display_name(user: User) -> str:
    if user.nickname:
        name = user.nickname
    else:
        name = user.full_name
    return name


def get_timeout(is_retry: bool) -> float:
    if is_retry:
        timeout = 30.0
    else:
        timeout = 10.0
    return timeout
```

**Correct (conditional expression):**

```python
def get_display_name(user: User) -> str:
    return user.nickname if user.nickname else user.full_name


def get_timeout(is_retry: bool) -> float:
    return 30.0 if is_retry else 10.0
```

Do not use conditional expressions for complex logic or when readability suffers. If the expression exceeds ~80 characters, prefer an if/else block.

---

### 1.8 Use Walrus Operator to Avoid Redundant Computation

Use the walrus operator (`:=`) when you need to both test and use a value. This eliminates duplicate function calls and makes the intent clearer.

**Incorrect (duplicate computation):**

```python
def process_response(response: httpx.Response) -> dict[str, Any]:
    if response.json().get("data"):
        return transform(response.json().get("data"))
    return {}


def find_match(text: str, patterns: list[re.Pattern[str]]) -> str | None:
    for pattern in patterns:
        if pattern.search(text):
            return pattern.search(text).group()
    return None
```

**Correct (walrus operator):**

```python
def process_response(response: httpx.Response) -> dict[str, Any]:
    if data := response.json().get("data"):
        return transform(data)
    return {}


def find_match(text: str, patterns: list[re.Pattern[str]]) -> str | None:
    for pattern in patterns:
        if match := pattern.search(text):
            return match.group()
    return None
```

Use sparingly — only when it genuinely reduces duplication. Do not use in complex expressions where it hurts readability.

Reference: [PEP 572 - Assignment Expressions](https://peps.python.org/pep-0572/)

---

## 2. Type Safety & Annotations

**Impact:** CRITICAL
**Description:** Strict typing catches bugs at development time, enables IDE support, and makes code self-documenting. Python 3.12+ syntax should be used consistently.

---

### 2.1 Annotate All Function Signatures

Every function and method must have complete type annotations for all parameters and the return type. This enables mypy to catch type errors, improves IDE support, and serves as machine-readable documentation.

**Incorrect (missing or incomplete annotations):**

```python
def fetch_documents(namespace_id, limit=10):
    # What types? What does it return?
    results = db.query(namespace_id, limit)
    return results


class DocumentService:
    def process(self, doc, options=None):
        if options and options.get("validate"):
            self.validate(doc)
        return doc
```

**Correct (complete annotations):**

```python
def fetch_documents(namespace_id: str, limit: int = 10) -> list[Document]:
    results = db.query(namespace_id, limit)
    return results


class DocumentService:
    def process(self, doc: Document, options: ProcessingOptions | None = None) -> Document:
        if options and options.validate:
            self.validate(doc)
        return doc
```

Reference: [PEP 484 - Type Hints](https://peps.python.org/pep-0484/)

---

### 2.2 Use Built-in Generic Collections

Use built-in types `list`, `dict`, `set`, `tuple`, `frozenset` directly as generics instead of importing from `typing`. The `typing` versions are deprecated since Python 3.9.

**Incorrect (importing from typing):**

```python
from typing import Dict, FrozenSet, List, Set, Tuple


def get_namespaces() -> List[str]:
    return ["default", "production"]


def build_index(docs: List[Document]) -> Dict[str, Document]:
    return {doc.id: doc for doc in docs}


def get_coordinates() -> Tuple[float, float]:
    return (0.0, 0.0)


unique_tags: Set[str] = {"python", "fastapi"}
```

**Correct (built-in generics):**

```python
def get_namespaces() -> list[str]:
    return ["default", "production"]


def build_index(docs: list[Document]) -> dict[str, Document]:
    return {doc.id: doc for doc in docs}


def get_coordinates() -> tuple[float, float]:
    return (0.0, 0.0)


unique_tags: set[str] = {"python", "fastapi"}
```

Reference: [PEP 585 - Type Hinting Generics In Standard Collections](https://peps.python.org/pep-0585/)

---

### 2.3 Use Narrow Types Over Broad Ones

Use the most specific type that accurately describes the data. Avoid `Any`, `object`, `dict`, or bare `list` when a more precise type exists. Narrow types catch more bugs and make code self-documenting.

**Incorrect (overly broad types):**

```python
from typing import Any


def process_event(event: dict) -> Any:
    return event.get("data")


def store_items(items: list) -> None:
    for item in items:
        db.save(item)


config: dict[str, Any] = {"timeout": 30, "retries": 3}
```

**Correct (narrow, specific types):**

```python
def process_event(event: IngestEvent) -> ProcessingResult:
    return ProcessingResult(data=event.data)


def store_items(items: list[Document]) -> None:
    for item in items:
        db.save(item)


config: ServiceConfig = ServiceConfig(timeout=30, retries=3)
```

Use `Any` only at true system boundaries (e.g., deserializing unknown JSON from external APIs). Even then, validate and narrow immediately.

---

### 2.4 Use PEP 695 Type Alias Syntax

In Python 3.12+, use the new `type` statement for type aliases and the new generic syntax for generic classes and functions. This is more concise and provides better static analysis support.

**Incorrect (legacy TypeAlias and TypeVar):**

```python
from typing import TypeAlias, TypeVar

DocumentId: TypeAlias = str
JsonDict: TypeAlias = dict[str, Any]

T = TypeVar("T")
K = TypeVar("K")
V = TypeVar("V")


def first(items: list[T]) -> T | None:
    return items[0] if items else None


class Registry(dict[K, V]):
    def get_or_create(self, key: K, factory: Callable[[], V]) -> V:
        if key not in self:
            self[key] = factory()
        return self[key]
```

**Correct (PEP 695 syntax):**

```python
type DocumentId = str
type JsonDict = dict[str, Any]


def first[T](items: list[T]) -> T | None:
    return items[0] if items else None


class Registry[K, V](dict[K, V]):
    def get_or_create(self, key: K, factory: Callable[[], V]) -> V:
        if key not in self:
            self[key] = factory()
        return self[key]
```

Reference: [PEP 695 - Type Parameter Syntax](https://peps.python.org/pep-0695/)

---

### 2.5 Use StrEnum for String Enumerations

Use `StrEnum` (Python 3.11+) for string constants instead of plain strings or string literals. StrEnum values are valid strings, work with pattern matching, and provide type safety with IDE autocompletion.

**Incorrect (plain string constants):**

```python
# No type safety, easy to mistype
STATUS_PENDING = "pending"
STATUS_RUNNING = "running"
STATUS_COMPLETED = "completed"
STATUS_FAILED = "failed"


def update_job(job_id: str, status: str) -> None:
    if status == "pendng":  # Typo — no error, silent bug
        schedule_job(job_id)
```

**Correct (StrEnum):**

```python
from enum import StrEnum


class JobStatus(StrEnum):
    PENDING = "pending"
    RUNNING = "running"
    COMPLETED = "completed"
    FAILED = "failed"


def update_job(job_id: str, status: JobStatus) -> None:
    match status:
        case JobStatus.PENDING:
            schedule_job(job_id)
        case JobStatus.RUNNING:
            monitor_job(job_id)
        case JobStatus.COMPLETED:
            finalize_job(job_id)
        case JobStatus.FAILED:
            retry_job(job_id)


# Works as a string too
assert JobStatus.PENDING == "pending"  # True
print(f"Job status: {JobStatus.RUNNING}")  # "Job status: running"
```

Reference: [Python 3.11 - StrEnum](https://docs.python.org/3/library/enum.html#enum.StrEnum)

---

### 2.6 Use TypedDict for Structured Dictionaries

When a dictionary has a known, fixed structure, use `TypedDict` instead of `dict[str, Any]`. This provides type checking for key access and catches missing or misspelled keys.

**Incorrect (untyped dictionary):**

```python
def create_health_response(status: str, checks: list) -> dict[str, Any]:
    return {
        "status": status,
        "checks": checks,
        "timestamp": datetime.now().isoformat(),
    }


# Caller has no idea what keys exist
response = create_health_response("ok", [])
print(response["statsu"])  # Typo — no type error, KeyError at runtime
```

**Correct (TypedDict):**

```python
class HealthResponse(TypedDict):
    status: str
    checks: list[HealthCheck]
    timestamp: str


def create_health_response(status: str, checks: list[HealthCheck]) -> HealthResponse:
    return HealthResponse(
        status=status,
        checks=checks,
        timestamp=datetime.now().isoformat(),
    )


response = create_health_response("ok", [])
print(response["statsu"])  # mypy error: TypedDict "HealthResponse" has no key "statsu"
```

For optional keys, use `total=False` or `NotRequired`:

```python
class QueryParams(TypedDict, total=False):
    limit: int
    offset: int
    filter: str
```

Reference: [PEP 589 - TypedDict](https://peps.python.org/pep-0589/)

---

### 2.7 Use Union Syntax with Pipe Operator

Use `X | Y` instead of `Union[X, Y]` and `X | None` instead of `Optional[X]`. The pipe syntax is more readable and is the standard in Python 3.10+.

**Incorrect (legacy Optional and Union):**

```python
from typing import Optional, Union


def find_user(user_id: str) -> Optional[User]:
    return db.get(user_id)


def parse_value(raw: Union[str, int, float]) -> Union[str, float]:
    if isinstance(raw, int):
        return float(raw)
    return raw
```

**Correct (pipe operator):**

```python
def find_user(user_id: str) -> User | None:
    return db.get(user_id)


def parse_value(raw: str | int | float) -> str | float:
    if isinstance(raw, int):
        return float(raw)
    return raw
```

Reference: [PEP 604 - Allow writing union types as X | Y](https://peps.python.org/pep-0604/)

---

## 3. Error Handling

**Impact:** HIGH
**Description:** Proper error handling prevents silent failures, provides meaningful diagnostics, and ensures predictable behavior in production systems.

---

### 3.1 Include Context in Error Messages

Always include relevant context (IDs, values, states) in error messages. A message like "Not found" is useless for debugging — include what was not found, where it was looked for, and what was searched.

**Incorrect (vague error messages):**

```python
def get_namespace(namespace_id: str) -> Namespace:
    result = db.query(Namespace).filter_by(id=namespace_id).first()
    if not result:
        raise NamespaceNotFoundError("Namespace not found")


def validate_document(doc: Document) -> None:
    if doc.size > MAX_SIZE:
        raise ValidationError("Document too large")
    if doc.format not in SUPPORTED_FORMATS:
        raise ValidationError("Unsupported format")
```

**Correct (context-rich error messages):**

```python
def get_namespace(namespace_id: str) -> Namespace:
    result = db.query(Namespace).filter_by(id=namespace_id).first()
    if not result:
        raise NamespaceNotFoundError(
            f"Namespace with id={namespace_id!r} not found"
        )


def validate_document(doc: Document) -> None:
    if doc.size > MAX_SIZE:
        raise ValidationError(
            f"Document {doc.id!r} size {doc.size} exceeds maximum {MAX_SIZE}"
        )
    if doc.format not in SUPPORTED_FORMATS:
        raise ValidationError(
            f"Document {doc.id!r} format {doc.format!r} not in {SUPPORTED_FORMATS}"
        )
```

---

### 3.2 Define Custom Exception Hierarchies

Define custom exception classes that form a hierarchy for your domain. This enables callers to catch at the right level of granularity — a specific error, a category of errors, or all domain errors.

**Incorrect (using built-in exceptions for domain errors):**

```python
def ingest_document(doc: Document) -> None:
    if not doc.content:
        raise ValueError("Empty document")  # Indistinguishable from other ValueErrors
    if doc.format not in SUPPORTED_FORMATS:
        raise TypeError("Bad format")  # Misleading exception type
    if not has_quota(doc.namespace_id):
        raise RuntimeError("Quota exceeded")  # Too generic
```

**Correct (custom exception hierarchy):**

```python
class VRAGmateError(Exception):
    """Base exception for all domain errors."""


class IngestionError(VRAGmateError):
    """Base for ingestion-related errors."""


class EmptyDocumentError(IngestionError):
    """Document has no extractable content."""


class UnsupportedFormatError(IngestionError):
    """Document format is not supported."""


class QuotaExceededError(VRAGmateError):
    """Resource quota has been exceeded."""


def ingest_document(doc: Document) -> None:
    if not doc.content:
        raise EmptyDocumentError(f"Document {doc.id!r} has no content")
    if doc.format not in SUPPORTED_FORMATS:
        raise UnsupportedFormatError(
            f"Format {doc.format!r} not in {SUPPORTED_FORMATS}"
        )
    if not has_quota(doc.namespace_id):
        raise QuotaExceededError(
            f"Namespace {doc.namespace_id!r} has exceeded its quota"
        )
```

Callers can now catch at the desired level:

```python
try:
    ingest_document(doc)
except IngestionError:
    # Handle any ingestion error
except VRAGmateError:
    # Handle any domain error
```

---

### 3.3 Never Silently Swallow Exceptions

Never catch an exception and do nothing with it. At minimum, log the exception. Silent exception swallowing creates invisible bugs that are extremely difficult to diagnose in production.

**Incorrect (swallowed exceptions):**

```python
def send_notification(user_id: str, message: str) -> None:
    try:
        email_client.send(user_id, message)
    except Exception:
        pass  # Silently fails — user never gets notified, no one knows


def update_cache(key: str, value: str) -> None:
    try:
        cache.set(key, value)
    except Exception:
        ...  # Same problem with ellipsis
```

**Correct (exceptions handled explicitly):**

```python
def send_notification(user_id: str, message: str) -> None:
    try:
        email_client.send(user_id, message)
    except ConnectionError:
        logger.warning(
            "Failed to send notification to user %s, will retry", user_id, exc_info=True
        )
        retry_queue.enqueue(user_id, message)


def update_cache(key: str, value: str) -> None:
    try:
        cache.set(key, value)
    except CacheConnectionError:
        logger.warning("Cache update failed for key %s", key, exc_info=True)
        # Cache miss is acceptable — operation continues without caching
```

If an exception is truly expected and safe to ignore, document WHY:

```python
def cleanup_temp_file(path: Path) -> None:
    try:
        path.unlink()
    except FileNotFoundError:
        pass  # File already cleaned up by another process — this is expected
```

---

### 3.4 Use Exception Chaining with raise...from

When catching one exception and raising another, always use `raise NewException(...) from original_exception`. This preserves the full exception chain, making debugging significantly easier.

**Incorrect (exception chain lost):**

```python
def load_model(path: str) -> Model:
    try:
        data = json.loads(Path(path).read_text())
        return Model(**data)
    except json.JSONDecodeError:
        raise ModelLoadError(f"Invalid JSON in {path}")  # Original traceback lost
    except KeyError as e:
        raise ModelLoadError(f"Missing field: {e}")  # Chain broken


def connect_database(url: str) -> Engine:
    try:
        return create_engine(url)
    except OperationalError:
        raise DatabaseError("Cannot connect to database")
```

**Correct (exception chaining preserved):**

```python
def load_model(path: str) -> Model:
    try:
        data = json.loads(Path(path).read_text())
        return Model(**data)
    except json.JSONDecodeError as exc:
        raise ModelLoadError(f"Invalid JSON in {path}") from exc
    except KeyError as exc:
        raise ModelLoadError(f"Missing field: {exc}") from exc


def connect_database(url: str) -> Engine:
    try:
        return create_engine(url)
    except OperationalError as exc:
        raise DatabaseError("Cannot connect to database") from exc
```

Use `raise ... from None` only when you explicitly want to suppress the original exception chain (rare).

Reference: [PEP 3134 - Exception Chaining](https://peps.python.org/pep-3134/)

---

### 3.5 Catch Specific Exceptions

Always catch specific exception types. Never use bare `except:` or `except Exception:` as a catch-all. Broad exception handlers mask real bugs, swallow keyboard interrupts, and make debugging extremely difficult.

**Incorrect (overly broad exception handling):**

```python
def fetch_document(doc_id: str) -> Document | None:
    try:
        response = client.get(f"/documents/{doc_id}")
        return Document.model_validate(response.json())
    except:  # Catches SystemExit, KeyboardInterrupt, everything
        return None


def parse_config(path: str) -> dict[str, Any]:
    try:
        with open(path) as f:
            return yaml.safe_load(f)
    except Exception:  # Catches FileNotFoundError, PermissionError, yaml errors — all silently
        return {}
```

**Correct (specific exceptions):**

```python
def fetch_document(doc_id: str) -> Document | None:
    try:
        response = client.get(f"/documents/{doc_id}")
        response.raise_for_status()
        return Document.model_validate(response.json())
    except httpx.HTTPStatusError:
        logger.warning("Document %s not found", doc_id)
        return None
    except ValidationError as exc:
        logger.error("Invalid document data for %s: %s", doc_id, exc)
        raise


def parse_config(path: str) -> dict[str, Any]:
    try:
        with open(path) as f:
            return yaml.safe_load(f)
    except FileNotFoundError:
        logger.info("Config file %s not found, using defaults", path)
        return {}
    except yaml.YAMLError as exc:
        raise ConfigurationError(f"Invalid YAML in {path}") from exc
```

Reference: [PEP 8 - Programming Recommendations](https://peps.python.org/pep-0008/#programming-recommendations)

---

## 4. Testing Best Practices

**Impact:** HIGH
**Description:** Well-structured tests with proper fixtures, parametrization, and assertions improve reliability and reduce maintenance cost.

---

### 4.1 Structure Tests with Arrange-Act-Assert

Structure every test with three clear phases: **Arrange** (set up preconditions), **Act** (execute the behavior under test), and **Assert** (verify the outcome). Separate phases with blank lines.

**Incorrect (phases mixed together):**

```python
def test_document_ingestion(db: Database) -> None:
    service = IngestionService(db)
    doc = Document(id="test-1", content="hello", format=DocumentFormat.PDF)
    assert service.ingest(doc).status == IngestionStatus.COMPLETED
    assert db.get(Document, "test-1") is not None
    assert db.get(Document, "test-1").chunk_count > 0
    service2 = IngestionService(db)
    assert service2.get_status("test-1") == IngestionStatus.COMPLETED
```

**Correct (clear AAA structure):**

```python
def test_document_ingestion(db: Database) -> None:
    # Arrange
    service = IngestionService(db)
    doc = Document(id="test-1", content="hello", format=DocumentFormat.PDF)

    # Act
    result = service.ingest(doc)

    # Assert
    assert result.status == IngestionStatus.COMPLETED
    stored_doc = db.get(Document, "test-1")
    assert stored_doc is not None
    assert stored_doc.chunk_count > 0
```

For async tests, the same structure applies:

```python
async def test_async_query(query_service: QueryService) -> None:
    # Arrange
    query = "What is vRAGmate?"

    # Act
    response = await query_service.execute(query, namespace_id="ns-1")

    # Assert
    assert response.answer is not None
    assert len(response.sources) > 0
```

---

### 4.2 Use Specific Assertions

Use specific assertions (`assert x == y`, `assert x in collection`) instead of bare `assert x` or truthiness checks. Specific assertions produce better failure messages and catch the exact failure mode.

**Incorrect (vague assertions):**

```python
def test_fetch_documents() -> None:
    docs = fetch_documents(namespace_id="ns-1")
    assert docs  # Only checks truthiness — fails with "assert []"
    assert len(docs)  # Same problem — "assert 0"
    assert docs[0].title  # Only checks non-empty — no expected value


def test_create_user() -> None:
    user = create_user(name="Alice", email="alice@example.com")
    assert user  # Just checks it's not None
    assert user.name  # Doesn't verify the actual name
```

**Correct (specific assertions):**

```python
def test_fetch_documents() -> None:
    docs = fetch_documents(namespace_id="ns-1")
    assert len(docs) == 3
    assert docs[0].title == "Getting Started"
    assert all(doc.namespace_id == "ns-1" for doc in docs)


def test_create_user() -> None:
    user = create_user(name="Alice", email="alice@example.com")
    assert user.name == "Alice"
    assert user.email == "alice@example.com"
    assert user.id is not None
```

For exception testing, use `pytest.raises` with `match`:

```python
def test_invalid_namespace_raises() -> None:
    with pytest.raises(NamespaceNotFoundError, match="ns-999"):
        fetch_documents(namespace_id="ns-999")
```

---

### 4.3 Use Async Fixtures Properly

Use `pytest-asyncio` with proper fixture scoping. Mark async fixtures and tests correctly, and use `AsyncExitStack` for managing multiple async context managers in fixtures.

**Incorrect (common async fixture mistakes):**

```python
# Missing pytest.mark.asyncio or wrong mode
async def test_query_service(query_service):  # Not marked as async test
    result = await query_service.execute("test query")
    assert result


# Fixture doesn't properly clean up async resources
@pytest.fixture
async def db_session():
    session = await create_session()
    return session  # Session never closed!


# Blocking call in async fixture
@pytest.fixture
async def config():
    return load_config_sync()  # Blocks the event loop
```

**Correct (proper async fixtures):**

```python
import pytest
from contextlib import AsyncExitStack


@pytest.fixture
async def db_session() -> AsyncGenerator[AsyncSession, None]:
    async with async_session_factory() as session:
        yield session
        await session.rollback()


@pytest.fixture
async def service_stack() -> AsyncGenerator[ServiceStack, None]:
    async with AsyncExitStack() as stack:
        db = await stack.enter_async_context(create_db_connection())
        cache = await stack.enter_async_context(create_cache_connection())
        yield ServiceStack(db=db, cache=cache)


@pytest.mark.asyncio
async def test_query_service(db_session: AsyncSession) -> None:
    service = QueryService(db_session)
    result = await service.execute("test query")
    assert result.answer is not None
```

Configure `pytest-asyncio` mode in `pyproject.toml`:

```toml
[tool.pytest.ini_options]
asyncio_mode = "auto"
```

Reference: [pytest-asyncio documentation](https://pytest-asyncio.readthedocs.io/)

---

### 4.4 Use Factory Functions for Test Data

Create factory functions that produce test objects with sensible defaults. Tests only specify the fields relevant to the test case, making test intent immediately clear.

**Incorrect (full object construction in every test):**

```python
def test_document_title_validation() -> None:
    doc = Document(
        id="test-1",
        title="",  # This is what we're testing
        content="Some content",
        format=DocumentFormat.PDF,
        namespace_id="ns-1",
        created_at=datetime(2024, 1, 1),
        updated_at=datetime(2024, 1, 1),
        owner_id="user-1",
        chunk_count=0,
        status=DocumentStatus.PENDING,
    )
    with pytest.raises(ValidationError):
        validate_document(doc)


def test_document_content_validation() -> None:
    doc = Document(
        id="test-2",
        title="Valid Title",
        content="",  # This is what we're testing
        format=DocumentFormat.PDF,
        namespace_id="ns-1",
        created_at=datetime(2024, 1, 1),
        updated_at=datetime(2024, 1, 1),
        owner_id="user-1",
        chunk_count=0,
        status=DocumentStatus.PENDING,
    )
    with pytest.raises(ValidationError):
        validate_document(doc)
```

**Correct (factory function with defaults):**

```python
def make_document(**overrides: Any) -> Document:
    defaults = {
        "id": f"test-{uuid4().hex[:8]}",
        "title": "Test Document",
        "content": "Default test content",
        "format": DocumentFormat.PDF,
        "namespace_id": "ns-1",
        "created_at": datetime(2024, 1, 1),
        "updated_at": datetime(2024, 1, 1),
        "owner_id": "user-1",
        "chunk_count": 0,
        "status": DocumentStatus.PENDING,
    }
    return Document(**(defaults | overrides))


def test_document_title_validation() -> None:
    doc = make_document(title="")
    with pytest.raises(ValidationError):
        validate_document(doc)


def test_document_content_validation() -> None:
    doc = make_document(content="")
    with pytest.raises(ValidationError):
        validate_document(doc)
```

---

### 4.5 Use Fixtures Instead of setUp/tearDown

Use pytest fixtures instead of `setUp`/`tearDown` methods. Fixtures are composable, have explicit dependency declaration, support multiple scopes, and can be shared across test modules.

**Incorrect (setUp/tearDown pattern):**

```python
class TestDocumentService(unittest.TestCase):
    def setUp(self):
        self.db = create_test_database()
        self.service = DocumentService(self.db)
        self.test_doc = Document(id="test-1", content="hello")
        self.db.save(self.test_doc)

    def tearDown(self):
        self.db.clear()
        self.db.close()

    def test_get_document(self):
        result = self.service.get("test-1")
        assert result == self.test_doc

    def test_delete_document(self):
        self.service.delete("test-1")
        assert self.service.get("test-1") is None
```

**Correct (pytest fixtures):**

```python
@pytest.fixture
def db():
    database = create_test_database()
    yield database
    database.clear()
    database.close()


@pytest.fixture
def document_service(db: Database) -> DocumentService:
    return DocumentService(db)


@pytest.fixture
def sample_document(db: Database) -> Document:
    doc = Document(id="test-1", content="hello")
    db.save(doc)
    return doc


def test_get_document(
    document_service: DocumentService, sample_document: Document
) -> None:
    result = document_service.get("test-1")
    assert result == sample_document


def test_delete_document(
    document_service: DocumentService, sample_document: Document
) -> None:
    document_service.delete("test-1")
    assert document_service.get("test-1") is None
```

Reference: [pytest fixtures](https://docs.pytest.org/en/stable/how-to/fixtures.html)

---

### 4.6 Ensure Test Independence and Isolation

Every test must be independent -- it should pass regardless of execution order and should not depend on state left by other tests. Use fixtures for setup, and clean up after each test.

**Incorrect (tests depend on shared mutable state):**

```python
# Module-level mutable state — tests affect each other
_documents: list[Document] = []


def test_add_document() -> None:
    _documents.append(Document(id="1", title="Test"))
    assert len(_documents) == 1


def test_list_documents() -> None:
    # Depends on test_add_document running first!
    assert len(_documents) == 1
    assert _documents[0].title == "Test"


def test_clear_documents() -> None:
    _documents.clear()
    assert len(_documents) == 0
    # Now test_list_documents fails if run after this
```

**Correct (each test is self-contained):**

```python
@pytest.fixture
def document_store() -> DocumentStore:
    """Fresh store for each test."""
    return InMemoryDocumentStore()


def test_add_document(document_store: DocumentStore) -> None:
    document_store.add(Document(id="1", title="Test"))
    assert document_store.count() == 1


def test_list_documents(document_store: DocumentStore) -> None:
    document_store.add(Document(id="1", title="First"))
    document_store.add(Document(id="2", title="Second"))
    assert document_store.count() == 2


def test_empty_store(document_store: DocumentStore) -> None:
    assert document_store.count() == 0  # Always passes — fresh fixture
```

For database tests, use transactions that roll back:

```python
@pytest.fixture
async def db_session(engine: AsyncEngine) -> AsyncGenerator[AsyncSession, None]:
    async with engine.connect() as conn:
        transaction = await conn.begin()
        session = AsyncSession(bind=conn)
        yield session
        await transaction.rollback()
```

---

### 4.7 Mock at Boundaries, Not Internals

Mock external dependencies (HTTP clients, databases, message queues) at the boundary, not internal implementation details. Tests that mock internals break during refactoring even when behavior is preserved.

**Incorrect (mocking internal implementation):**

```python
def test_process_document(mocker: MockerFixture) -> None:
    # Mocking private methods — breaks if implementation changes
    mocker.patch.object(DocumentProcessor, "_extract_text", return_value="content")
    mocker.patch.object(DocumentProcessor, "_split_chunks", return_value=["chunk1"])
    mocker.patch.object(DocumentProcessor, "_embed_chunks", return_value=[[0.1, 0.2]])

    processor = DocumentProcessor()
    result = processor.process(Document(content=b"pdf-bytes"))
    assert result.chunks == ["chunk1"]
```

**Correct (mocking at boundaries):**

```python
def test_process_document(
    mock_embedding_client: Mock, mock_db: Mock
) -> None:
    # Mock the external service boundary
    mock_embedding_client.embed.return_value = [[0.1, 0.2, 0.3]]

    processor = DocumentProcessor(
        embedding_client=mock_embedding_client,
        db=mock_db,
    )
    result = processor.process(Document(content=b"pdf-bytes"))

    assert len(result.chunks) > 0
    mock_embedding_client.embed.assert_called_once()
    mock_db.store_chunks.assert_called_once()
```

Better yet, use fakes or in-memory implementations for unit tests:

```python
def test_process_document() -> None:
    processor = DocumentProcessor(
        embedding_client=FakeEmbeddingClient(),
        db=InMemoryChunkStore(),
    )
    result = processor.process(Document(content=b"pdf-bytes"))
    assert len(result.chunks) > 0
```

---

### 4.8 Use Parametrize for Multiple Test Cases

Use `@pytest.mark.parametrize` to test multiple inputs and expected outputs with a single test function. This eliminates copy-pasted test functions that differ only in their data.

**Incorrect (duplicated test functions):**

```python
def test_parse_document_pdf():
    result = parse_document("test.pdf", b"%PDF-content")
    assert result.format == DocumentFormat.PDF
    assert result.content is not None


def test_parse_document_html():
    result = parse_document("test.html", b"<html>content</html>")
    assert result.format == DocumentFormat.HTML
    assert result.content is not None


def test_parse_document_markdown():
    result = parse_document("test.md", b"# Title\nContent")
    assert result.format == DocumentFormat.MARKDOWN
    assert result.content is not None
```

**Correct (parametrized test):**

```python
@pytest.mark.parametrize(
    ("filename", "content", "expected_format"),
    [
        ("test.pdf", b"%PDF-content", DocumentFormat.PDF),
        ("test.html", b"<html>content</html>", DocumentFormat.HTML),
        ("test.md", b"# Title\nContent", DocumentFormat.MARKDOWN),
    ],
)
def test_parse_document(
    filename: str, content: bytes, expected_format: DocumentFormat
) -> None:
    result = parse_document(filename, content)
    assert result.format == expected_format
    assert result.content is not None
```

Use `pytest.param(..., id="descriptive-name")` for complex cases to improve test output readability.

Reference: [pytest parametrize](https://docs.pytest.org/en/stable/how-to/parametrize.html)

---

## 5. Architecture & Structure

**Impact:** HIGH
**Description:** Clean module boundaries, dependency injection, and layered architecture reduce coupling and enable independent service evolution.

---

### 5.1 Use Application Factory Pattern

Create FastAPI applications via a `get_app()` factory function rather than at module level. This prevents import-time side effects, enables testing with different configurations, and supports proper lifespan management.

**Incorrect (module-level app creation):**

```python
# app.py — side effects at import time
from fastapi import FastAPI

app = FastAPI(title="Document Service")

# Database connection happens at import — breaks tests
engine = create_engine(settings.database_url)
session_factory = sessionmaker(engine)

@app.get("/documents/{doc_id}")
async def get_document(doc_id: str):
    # Uses module-level session_factory
    ...
```

**Correct (factory pattern):**

```python
# app.py
from fastapi import FastAPI
from contextlib import asynccontextmanager


def get_app(config: ServiceConfig | None = None) -> FastAPI:
    config = config or ServiceConfig()

    @asynccontextmanager
    async def lifespan(app: FastAPI):
        # Startup: initialize connections
        engine = create_async_engine(config.database_url)
        app.state.session_factory = async_sessionmaker(engine)
        yield
        # Shutdown: clean up
        await engine.dispose()

    app = FastAPI(title="Document Service", lifespan=lifespan)
    app.include_router(document_router)
    return app
```

In tests, create the app with test configuration:

```python
@pytest.fixture
def app() -> FastAPI:
    return get_app(config=ServiceConfig(database_url="sqlite+aiosqlite://"))
```

---

### 5.2 Prevent Circular Import Dependencies

Circular imports indicate tangled responsibilities. Resolve them by extracting shared types into a separate module, using dependency inversion, or restructuring the dependency graph.

**Incorrect (circular dependency):**

```python
# user_service.py
from document_service import DocumentService  # Imports document_service

class UserService:
    def __init__(self, doc_service: DocumentService) -> None:
        self._doc_service = doc_service

    async def delete_user(self, user_id: str) -> None:
        await self._doc_service.delete_user_documents(user_id)


# document_service.py
from user_service import UserService  # Circular! Imports user_service

class DocumentService:
    def __init__(self, user_service: UserService) -> None:
        self._user_service = user_service

    async def get_owner(self, doc_id: str) -> User:
        doc = await self._get_doc(doc_id)
        return await self._user_service.get_user(doc.owner_id)
```

**Correct (break cycle with Protocol):**

```python
# protocols.py — shared interface, no circular dependency
from typing import Protocol

class DocumentDeleter(Protocol):
    async def delete_user_documents(self, user_id: str) -> None: ...

class UserLookup(Protocol):
    async def get_user(self, user_id: str) -> User: ...


# user_service.py
class UserService:
    def __init__(self, doc_deleter: DocumentDeleter) -> None:
        self._doc_deleter = doc_deleter

    async def delete_user(self, user_id: str) -> None:
        await self._doc_deleter.delete_user_documents(user_id)


# document_service.py
class DocumentService:
    def __init__(self, user_lookup: UserLookup) -> None:
        self._user_lookup = user_lookup
```

---

### 5.3 Inject Dependencies, Don't Import Globals

Pass dependencies through constructors or function parameters instead of importing global singletons. This enables testing with fakes, swapping implementations, and understanding what a class actually depends on.

**Incorrect (importing global singletons):**

```python
# Hard-coded dependency on global singleton
from app.database import db_session
from app.cache import redis_client
from app.config import settings


class UserService:
    async def get_user(self, user_id: str) -> User:
        cached = await redis_client.get(f"user:{user_id}")
        if cached:
            return User.model_validate_json(cached)
        result = await db_session.execute(
            select(UserModel).where(UserModel.id == user_id)
        )
        return User.model_validate(result.scalar_one())
```

**Correct (injected dependencies):**

```python
class UserService:
    def __init__(
        self,
        session: AsyncSession,
        cache: CacheClient,
    ) -> None:
        self._session = session
        self._cache = cache

    async def get_user(self, user_id: str) -> User:
        cached = await self._cache.get(f"user:{user_id}")
        if cached:
            return User.model_validate_json(cached)
        result = await self._session.execute(
            select(UserModel).where(UserModel.id == user_id)
        )
        return User.model_validate(result.scalar_one())


# In FastAPI, wire dependencies with Depends()
async def get_user_service(
    session: AsyncSession = Depends(get_session),
    cache: CacheClient = Depends(get_cache),
) -> UserService:
    return UserService(session=session, cache=cache)
```

---

### 5.4 Define Narrow Protocols and Interfaces

Use Python `Protocol` classes to define narrow interfaces that describe only the methods a consumer needs. This reduces coupling and makes it easy to provide test doubles.

**Incorrect (depending on broad class):**

```python
# Consumer depends on the entire DatabaseClient class
class ReportGenerator:
    def __init__(self, db: DatabaseClient) -> None:
        self._db = db  # Only uses db.query() but depends on full class

    def generate(self, report_id: str) -> Report:
        rows = self._db.query(f"SELECT * FROM reports WHERE id = '{report_id}'")
        return Report.from_rows(rows)
```

**Correct (narrow Protocol):**

```python
from typing import Protocol


class QueryExecutor(Protocol):
    def query(self, sql: str) -> list[Row]: ...


class ReportGenerator:
    def __init__(self, db: QueryExecutor) -> None:
        self._db = db

    def generate(self, report_id: str) -> Report:
        rows = self._db.query(f"SELECT * FROM reports WHERE id = '{report_id}'")
        return Report.from_rows(rows)


# Easy to test with a minimal fake
class FakeQueryExecutor:
    def __init__(self, rows: list[Row]) -> None:
        self._rows = rows

    def query(self, sql: str) -> list[Row]:
        return self._rows
```

Reference: [PEP 544 - Protocols](https://peps.python.org/pep-0544/)

---

### 5.5 Respect Layer Boundaries in Imports

Maintain clear import direction: routers -> services -> repositories -> models. Inner layers should never import from outer layers. This ensures each layer can be tested and changed independently.

**Incorrect (import direction violated):**

```python
# repositories/document_repo.py — importing from router layer!
from routers.document_router import DocumentResponse  # Wrong direction

class DocumentRepository:
    async def get(self, doc_id: str) -> DocumentResponse:  # Returns router-level type
        row = await self.session.execute(...)
        return DocumentResponse(id=row.id, title=row.title)


# services/user_service.py — importing from another service's internals
from services.notification_service import _format_email  # Private internal
```

**Correct (clean layer boundaries):**

```python
# models/document.py — shared domain types
class Document(BaseModel):
    id: str
    title: str
    content: str


# repositories/document_repo.py — returns domain types
class DocumentRepository:
    async def get(self, doc_id: str) -> Document:
        row = await self.session.execute(...)
        return Document(id=row.id, title=row.title, content=row.content)


# routers/document_router.py — converts to response types
class DocumentResponse(BaseModel):
    id: str
    title: str

@router.get("/documents/{doc_id}")
async def get_document(doc_id: str, repo: DocumentRepository = Depends()) -> DocumentResponse:
    doc = await repo.get(doc_id)
    return DocumentResponse(id=doc.id, title=doc.title)
```

---

### 5.6 One Module, One Responsibility

Each module should have one clear responsibility. When a module handles multiple unrelated concerns, it becomes hard to understand, test, and modify without side effects.

**Incorrect (module doing too many things):**

```python
# services/document_service.py — does everything
class DocumentService:
    async def create_document(self, doc: CreateDocumentRequest) -> Document:
        # Validation logic
        if not doc.title:
            raise ValidationError("Title required")
        # Database logic
        db_doc = DocumentModel(title=doc.title, content=doc.content)
        self.session.add(db_doc)
        await self.session.commit()
        # Notification logic
        await self.email_client.send(doc.owner, "Document created")
        # Metrics logic
        self.metrics.increment("documents_created")
        # Cache logic
        await self.cache.set(f"doc:{db_doc.id}", db_doc)
        return Document.model_validate(db_doc)
```

**Correct (separated responsibilities):**

```python
# services/document_service.py — orchestration only
class DocumentService:
    def __init__(
        self,
        repository: DocumentRepository,
        notifier: DocumentNotifier,
        metrics: MetricsClient,
    ) -> None:
        self._repository = repository
        self._notifier = notifier
        self._metrics = metrics

    async def create_document(self, doc: CreateDocumentRequest) -> Document:
        document = await self._repository.create(doc)
        await self._notifier.on_created(document)
        self._metrics.increment("documents_created")
        return document


# repositories/document_repository.py — data access only
class DocumentRepository:
    async def create(self, doc: CreateDocumentRequest) -> Document: ...
```

---

## 6. Pydantic & Data Models

**Impact:** MEDIUM-HIGH
**Description:** Pydantic v2 patterns for validation, serialization, and configuration ensure data integrity at system boundaries.

---

### 6.1 Use Model Attributes, Not Dict Access

Access Pydantic model data via attribute access (`model.field`), not dict-style access (`model["field"]` or `model.dict()["field"]`). Attribute access is type-checked and provides IDE autocompletion.

**Incorrect (dict-style access on models):**

```python
def process_document(doc: Document) -> str:
    data = doc.model_dump()
    title = data["title"]  # No type checking
    namespace = data.get("namespace_id", "default")  # Returns Any
    return f"{namespace}/{title}"


def summarize_results(results: list[QueryResult]) -> list[str]:
    return [r.__dict__["answer"] for r in results]  # Fragile, untyped
```

**Correct (attribute access):**

```python
def process_document(doc: Document) -> str:
    title = doc.title  # Type-checked as str
    namespace = doc.namespace_id  # Type-checked, IDE autocompletes
    return f"{namespace}/{title}"


def summarize_results(results: list[QueryResult]) -> list[str]:
    return [r.answer for r in results]  # Type-checked, clean
```

Use `model_dump()` only at serialization boundaries (API responses, database writes):

```python
@router.get("/documents/{doc_id}")
async def get_document(doc_id: str) -> dict[str, Any]:
    doc = await service.get(doc_id)
    return doc.model_dump()  # Serialization boundary — appropriate
```

---

### 6.2 Use model_config Dict, Not Inner Config Class

In Pydantic v2, use `model_config = ConfigDict(...)` instead of the deprecated inner `class Config`. This is the standard approach and avoids deprecation warnings.

**Incorrect (deprecated inner Config class):**

```python
class ServiceSettings(BaseModel):
    host: str
    port: int
    debug: bool = False

    class Config:  # Deprecated in Pydantic v2
        env_prefix = "SERVICE_"
        frozen = True
        str_strip_whitespace = True
```

**Correct (ConfigDict):**

```python
from pydantic import ConfigDict


class ServiceSettings(BaseModel):
    model_config = ConfigDict(
        frozen=True,
        str_strip_whitespace=True,
    )

    host: str
    port: int
    debug: bool = False
```

For settings with environment variable loading, use `pydantic-settings`:

```python
from pydantic_settings import BaseSettings, SettingsConfigDict


class ServiceSettings(BaseSettings):
    model_config = SettingsConfigDict(
        env_prefix="SERVICE_",
        frozen=True,
    )

    host: str
    port: int
    debug: bool = False
```

Reference: [Pydantic v2 migration](https://docs.pydantic.dev/latest/migration/)

---

### 6.3 Use Discriminated Unions for Polymorphism

When a field can be one of several model types, use discriminated unions with a literal type field. This provides fast, unambiguous deserialization and clear error messages.

**Incorrect (plain Union, ambiguous):**

```python
class EmailNotification(BaseModel):
    recipient: str
    subject: str
    body: str


class SlackNotification(BaseModel):
    channel: str
    body: str  # Overlapping field names — Pydantic can't distinguish


class NotificationRequest(BaseModel):
    notification: EmailNotification | SlackNotification  # Ambiguous union
```

**Correct (discriminated union):**

```python
from typing import Annotated, Literal
from pydantic import Discriminator, Tag


class EmailNotification(BaseModel):
    type: Literal["email"] = "email"
    recipient: str
    subject: str
    body: str


class SlackNotification(BaseModel):
    type: Literal["slack"] = "slack"
    channel: str
    body: str


class NotificationRequest(BaseModel):
    notification: Annotated[
        EmailNotification | SlackNotification,
        Discriminator("type"),
    ]


# Clean deserialization
request = NotificationRequest.model_validate({
    "notification": {"type": "email", "recipient": "user@example.com", "subject": "Hi", "body": "Hello"}
})
assert isinstance(request.notification, EmailNotification)
```

Reference: [Pydantic discriminated unions](https://docs.pydantic.dev/latest/concepts/unions/#discriminated-unions)

---

### 6.4 Use field_validator Over root_validator

Use `@field_validator` for field-specific validation and `@model_validator` only when validation requires multiple fields. This produces clearer error messages tied to specific fields.

**Incorrect (root_validator for single-field logic):**

```python
from pydantic import model_validator


class UserCreate(BaseModel):
    name: str
    email: str
    age: int

    @model_validator(mode="after")
    def validate_fields(self) -> "UserCreate":
        if not self.name.strip():
            raise ValueError("Name cannot be blank")
        if "@" not in self.email:
            raise ValueError("Invalid email")
        if self.age < 0:
            raise ValueError("Age must be positive")
        return self
```

**Correct (field_validator for per-field logic):**

```python
from pydantic import field_validator


class UserCreate(BaseModel):
    name: str
    email: str
    age: int

    @field_validator("name")
    @classmethod
    def name_must_not_be_blank(cls, v: str) -> str:
        if not v.strip():
            raise ValueError("Name cannot be blank")
        return v.strip()

    @field_validator("email")
    @classmethod
    def email_must_be_valid(cls, v: str) -> str:
        if "@" not in v:
            raise ValueError("Invalid email format")
        return v.lower()

    @field_validator("age")
    @classmethod
    def age_must_be_positive(cls, v: int) -> int:
        if v < 0:
            raise ValueError("Age must be non-negative")
        return v
```

Use `@model_validator` only when cross-field validation is needed:

```python
    @model_validator(mode="after")
    def end_date_after_start(self) -> "DateRange":
        if self.end_date <= self.start_date:
            raise ValueError("end_date must be after start_date")
        return self
```

Reference: [Pydantic validators](https://docs.pydantic.dev/latest/concepts/validators/)

---

### 6.5 Use Frozen Models for Immutable Data

Use `model_config = ConfigDict(frozen=True)` for data objects that should not be mutated after creation. This prevents accidental modification, enables hashing, and makes models safe for use as dict keys or set members.

**Incorrect (mutable model leads to bugs):**

```python
class QueryResult(BaseModel):
    query: str
    answer: str
    sources: list[str]
    score: float


# Bug: accidental mutation
result = QueryResult(query="test", answer="response", sources=["doc1"], score=0.95)
result.score = 0.0  # Silently mutates — might corrupt cached results
```

**Correct (frozen model):**

```python
from pydantic import ConfigDict


class QueryResult(BaseModel):
    model_config = ConfigDict(frozen=True)

    query: str
    answer: str
    sources: list[str]
    score: float


result = QueryResult(query="test", answer="response", sources=["doc1"], score=0.95)
result.score = 0.0  # ValidationError: Instance is frozen

# Use model_copy for modifications
updated = result.model_copy(update={"score": 0.8})
```

Reference: [Pydantic frozen models](https://docs.pydantic.dev/latest/concepts/config/#frozen)

---

## 7. Naming & Readability

**Impact:** MEDIUM
**Description:** Clear, consistent naming reduces cognitive load and makes code intent immediately apparent to readers and AI agents.

---

### 7.1 Don't Shadow Built-in Names or Outer Variables

Never use names that shadow Python built-ins (`id`, `type`, `list`, `dict`, `input`, `format`, `hash`, `range`, `filter`, `map`) or variables from outer scopes. Shadowing creates subtle bugs where the wrong binding is used.

**Incorrect (shadowing built-ins and outer scope):**

```python
def process_items(list: list[str]) -> dict:  # Shadows built-in list and dict
    id = generate_id()  # Shadows built-in id
    type = determine_type(list)  # Shadows built-in type
    input = get_user_input()  # Shadows built-in input
    format = "json"  # Shadows built-in format
    return {"id": id, "type": type, "items": list}


filter = "active"  # Module-level shadow

def get_filtered(items: list[str]) -> list[str]:
    return [i for i in items if i == filter]  # Uses module shadow
```

**Correct (unique, descriptive names):**

```python
def process_items(items: list[str]) -> dict[str, Any]:
    item_id = generate_id()
    item_type = determine_type(items)
    user_input = get_user_input()
    output_format = "json"
    return {"id": item_id, "type": item_type, "items": items}


active_filter = "active"


def get_filtered(items: list[str]) -> list[str]:
    return [item for item in items if item == active_filter]
```

Common built-ins that get shadowed: `id`, `type`, `list`, `dict`, `set`, `input`, `format`, `hash`, `range`, `filter`, `map`, `open`, `file`, `dir`, `help`, `object`, `next`, `iter`.

Reference: [Ruff A001-A003 - builtin shadowing](https://docs.astral.sh/ruff/rules/#flake8-builtins-a)

---

### 7.2 Prefix Booleans with is/has/should/can

Name boolean variables and functions with prefixes that make their true/false nature immediately clear: `is_`, `has_`, `should_`, `can_`, `was_`, `needs_`.

**Incorrect (ambiguous boolean names):**

```python
class Document(BaseModel):
    active: bool  # Active what? Is it active? Was it active?
    error: bool  # Is this an error flag or error presence?
    ready: bool
    public: bool


def check_permission(user: User, resource: str) -> bool:
    ...  # Does it check or does it return permission status?


def validate(doc: Document) -> bool:
    ...  # Does it validate or return validation status?
```

**Correct (clear boolean prefixes):**

```python
class Document(BaseModel):
    is_active: bool
    has_error: bool
    is_ready: bool
    is_public: bool


def has_permission(user: User, resource: str) -> bool:
    ...


def is_valid(doc: Document) -> bool:
    ...


# In function calls, the intent is immediately clear
if document.is_active and not document.has_error:
    if has_permission(user, document.id):
        process(document)
```

---

### 7.3 Follow PEP 8 Naming Conventions Strictly

Follow PEP 8 naming conventions without exception: `snake_case` for functions/variables/modules, `PascalCase` for classes, `UPPER_SNAKE_CASE` for constants. Inconsistent casing confuses readers and breaks tooling expectations.

**Incorrect (mixed casing conventions):**

```python
MaxRetries = 3  # Looks like a class
documentService = DocumentService()  # camelCase variable
def GetDocuments(namespaceId: str) -> list:  # PascalCase function, camelCase param
    ...

class document_parser:  # snake_case class
    def ParseContent(self, Raw_Data: bytes) -> str:  # Mixed casing
        ...
```

**Correct (consistent PEP 8 casing):**

```python
MAX_RETRIES = 3  # UPPER_SNAKE_CASE constant
document_service = DocumentService()  # snake_case variable


def get_documents(namespace_id: str) -> list[Document]:  # snake_case function
    ...


class DocumentParser:  # PascalCase class
    def parse_content(self, raw_data: bytes) -> str:  # snake_case method
        ...
```

Reference: [PEP 8 - Naming Conventions](https://peps.python.org/pep-0008/#naming-conventions)

---

### 7.4 Use Descriptive Names Over Abbreviations

Use clear, descriptive names that convey purpose. Avoid single-letter variables (except `i`/`j` in short loops), cryptic abbreviations, and names that require context to understand.

**Incorrect (cryptic abbreviations):**

```python
def proc_doc(d, ns, cfg):
    r = d.get_c()
    if not r:
        return None
    t = cfg.get("t", 30)
    res = svc.q(ns, r, timeout=t)
    return res


def calc_emb(txt, mdl, bs=32):
    embs = []
    for i in range(0, len(txt), bs):
        b = txt[i:i + bs]
        e = mdl.encode(b)
        embs.extend(e)
    return embs
```

**Correct (descriptive names):**

```python
def process_document(
    document: Document, namespace_id: str, config: QueryConfig
) -> QueryResult | None:
    content = document.get_content()
    if not content:
        return None
    timeout = config.get("timeout", 30)
    result = query_service.query(namespace_id, content, timeout=timeout)
    return result


def calculate_embeddings(
    texts: list[str], model: EmbeddingModel, batch_size: int = 32
) -> list[list[float]]:
    embeddings: list[list[float]] = []
    for start in range(0, len(texts), batch_size):
        batch = texts[start:start + batch_size]
        batch_embeddings = model.encode(batch)
        embeddings.extend(batch_embeddings)
    return embeddings
```

---

## 8. FastAPI & API Design

**Impact:** MEDIUM
**Description:** Consistent API patterns with proper response models, dependency injection, and versioning enable reliable service interfaces.

---

### 8.1 Use Depends() for Shared Logic

Use FastAPI's `Depends()` for shared concerns like authentication, database sessions, pagination, and configuration. This eliminates duplication and makes dependencies explicit and testable.

**Incorrect (duplicated logic in every endpoint):**

```python
@router.get("/documents")
async def list_documents(request: Request):
    token = request.headers.get("Authorization", "").replace("Bearer ", "")
    if not token:
        raise HTTPException(status_code=401)
    user = await verify_token(token)
    if not user:
        raise HTTPException(status_code=401)
    session = async_session_factory()
    try:
        result = await session.execute(select(DocumentModel).where(DocumentModel.owner_id == user.id))
        return result.scalars().all()
    finally:
        await session.close()


@router.get("/namespaces")
async def list_namespaces(request: Request):
    token = request.headers.get("Authorization", "").replace("Bearer ", "")
    if not token:
        raise HTTPException(status_code=401)
    user = await verify_token(token)
    if not user:
        raise HTTPException(status_code=401)
    session = async_session_factory()
    try:
        result = await session.execute(select(NamespaceModel).where(NamespaceModel.owner_id == user.id))
        return result.scalars().all()
    finally:
        await session.close()
```

**Correct (shared dependencies):**

```python
async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(HTTPBearer()),
) -> User:
    user = await verify_token(credentials.credentials)
    if not user:
        raise HTTPException(status_code=401, detail="Invalid token")
    return user


async def get_session() -> AsyncGenerator[AsyncSession, None]:
    async with async_session_factory() as session:
        yield session


@router.get("/documents")
async def list_documents(
    user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session),
) -> list[DocumentResponse]:
    result = await session.execute(
        select(DocumentModel).where(DocumentModel.owner_id == user.id)
    )
    return [DocumentResponse.model_validate(doc) for doc in result.scalars()]


@router.get("/namespaces")
async def list_namespaces(
    user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session),
) -> list[NamespaceResponse]:
    result = await session.execute(
        select(NamespaceModel).where(NamespaceModel.owner_id == user.id)
    )
    return [NamespaceResponse.model_validate(ns) for ns in result.scalars()]
```

Reference: [FastAPI Dependencies](https://fastapi.tiangolo.com/tutorial/dependencies/)

---

### 8.2 Always Define Response Models

Always specify `response_model` on FastAPI endpoints or use typed return annotations. This ensures consistent API responses, generates accurate OpenAPI documentation, and prevents accidentally leaking internal fields.

**Incorrect (no response model, leaks internal fields):**

```python
@router.get("/documents/{doc_id}")
async def get_document(doc_id: str, db: AsyncSession = Depends(get_session)):
    result = await db.execute(select(DocumentModel).where(DocumentModel.id == doc_id))
    doc = result.scalar_one_or_none()
    if not doc:
        raise HTTPException(status_code=404)
    return doc  # Leaks internal DB fields: _sa_instance_state, created_by, internal_flags
```

**Correct (explicit response model):**

```python
class DocumentResponse(BaseModel):
    id: str
    title: str
    format: DocumentFormat
    created_at: datetime
    namespace_id: str


@router.get("/documents/{doc_id}")
async def get_document(
    doc_id: str, db: AsyncSession = Depends(get_session)
) -> DocumentResponse:
    result = await db.execute(select(DocumentModel).where(DocumentModel.id == doc_id))
    doc = result.scalar_one_or_none()
    if not doc:
        raise HTTPException(status_code=404, detail=f"Document {doc_id!r} not found")
    return DocumentResponse(
        id=doc.id,
        title=doc.title,
        format=doc.format,
        created_at=doc.created_at,
        namespace_id=doc.namespace_id,
    )
```

Reference: [FastAPI Response Model](https://fastapi.tiangolo.com/tutorial/response-model/)

---

### 8.3 Use Router Factory Pattern

Create routers via factory functions that accept dependencies as parameters. This enables testing with different configurations and keeps the dependency graph explicit.

**Incorrect (module-level router with implicit dependencies):**

```python
# routers/documents.py
from app.services import document_service  # Implicit global dependency

router = APIRouter(prefix="/documents")


@router.get("/{doc_id}")
async def get_document(doc_id: str) -> DocumentResponse:
    doc = await document_service.get(doc_id)  # Hard to test
    return DocumentResponse.model_validate(doc)
```

**Correct (router factory):**

```python
# routers/documents.py
def create_document_router(service: DocumentService) -> APIRouter:
    router = APIRouter(prefix="/documents")

    @router.get("/{doc_id}")
    async def get_document(doc_id: str) -> DocumentResponse:
        doc = await service.get(doc_id)
        return DocumentResponse.model_validate(doc)

    @router.get("/")
    async def list_documents(namespace_id: str) -> list[DocumentResponse]:
        docs = await service.list(namespace_id)
        return [DocumentResponse.model_validate(d) for d in docs]

    return router


# app.py
def get_app() -> FastAPI:
    app = FastAPI()
    document_service = DocumentService(...)
    app.include_router(create_document_router(document_service))
    return app
```

In tests:

```python
def test_get_document():
    fake_service = FakeDocumentService()
    router = create_document_router(fake_service)
    app = FastAPI()
    app.include_router(router)
    client = TestClient(app)
    response = client.get("/documents/test-1")
    assert response.status_code == 200
```

---

### 8.4 Use Explicit HTTP Status Codes

Always specify the correct HTTP status code for each endpoint. Use `status_code` parameter and `status.HTTP_*` constants. Don't rely on FastAPI's default 200 for all responses.

**Incorrect (default 200 for everything):**

```python
@router.post("/documents")
async def create_document(request: CreateDocumentRequest) -> DocumentResponse:
    doc = await service.create(request)
    return DocumentResponse.model_validate(doc)  # Returns 200, should be 201


@router.delete("/documents/{doc_id}")
async def delete_document(doc_id: str) -> dict:
    await service.delete(doc_id)
    return {"message": "deleted"}  # Returns 200 with body, should be 204
```

**Correct (explicit status codes):**

```python
from starlette import status


@router.post(
    "/documents",
    status_code=status.HTTP_201_CREATED,
)
async def create_document(request: CreateDocumentRequest) -> DocumentResponse:
    doc = await service.create(request)
    return DocumentResponse.model_validate(doc)


@router.delete(
    "/documents/{doc_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
async def delete_document(doc_id: str) -> None:
    await service.delete(doc_id)


@router.post(
    "/documents/{doc_id}/process",
    status_code=status.HTTP_202_ACCEPTED,
)
async def process_document(doc_id: str) -> JobResponse:
    job = await service.start_processing(doc_id)
    return JobResponse.model_validate(job)
```

Common status codes: `201` (created), `202` (accepted/async), `204` (no content), `404` (not found), `409` (conflict), `422` (validation error).

---

### 8.5 Version APIs Explicitly

Version your APIs from the start to enable non-breaking evolution. Use URL path prefixes, headers, or a combination. Define a clear strategy and apply it consistently.

**Incorrect (no versioning, breaking changes affect all clients):**

```python
# No version — any change breaks all clients
@router.get("/documents/{doc_id}")
async def get_document(doc_id: str) -> DocumentResponse:
    ...

# Later, changing the response shape breaks existing clients
@router.get("/documents/{doc_id}")
async def get_document(doc_id: str) -> DocumentResponseV2:  # Breaks clients expecting V1
    ...
```

**Correct (versioned API):**

```python
# Version via URL prefix
v1_router = APIRouter(prefix="/v1")
v2_router = APIRouter(prefix="/v2")


@v1_router.get("/documents/{doc_id}")
async def get_document_v1(doc_id: str) -> DocumentResponseV1:
    doc = await service.get(doc_id)
    return DocumentResponseV1.model_validate(doc)


@v2_router.get("/documents/{doc_id}")
async def get_document_v2(doc_id: str) -> DocumentResponseV2:
    doc = await service.get(doc_id)
    return DocumentResponseV2.model_validate(doc)


# Or version via header (vRAGmate pattern)
@router.get("/documents/{doc_id}")
async def get_document(
    doc_id: str,
    api_version: str = Header(default="1.0", alias="X-API-Version"),
) -> DocumentResponseV1 | DocumentResponseV2:
    doc = await service.get(doc_id)
    if api_version.startswith("2"):
        return DocumentResponseV2.model_validate(doc)
    return DocumentResponseV1.model_validate(doc)
```

Reference: [FastAPI Bigger Applications](https://fastapi.tiangolo.com/tutorial/bigger-applications/)

---

## 9. Async & Concurrency

**Impact:** LOW-MEDIUM
**Description:** Correct async patterns prevent blocking, enable parallelism, and ensure proper resource cleanup in concurrent systems.

---

### 9.1 Never Call Blocking Code in Async Functions

Never call synchronous blocking operations (file I/O, CPU-heavy computation, `time.sleep()`, synchronous HTTP) inside async functions. This blocks the entire event loop, preventing all other coroutines from executing.

**Incorrect (blocking calls in async context):**

```python
import time
import requests


async def process_document(doc_id: str) -> ProcessingResult:
    # Blocks the event loop for the entire file read
    with open(f"/data/{doc_id}.pdf", "rb") as f:
        content = f.read()

    # Blocks the event loop during HTTP call
    response = requests.post("https://api.example.com/parse", data=content)

    # Blocks the event loop
    time.sleep(5)

    return ProcessingResult(data=response.json())
```

**Correct (non-blocking alternatives):**

```python
import asyncio
import aiofiles
import httpx


async def process_document(doc_id: str) -> ProcessingResult:
    # Async file I/O
    async with aiofiles.open(f"/data/{doc_id}.pdf", "rb") as f:
        content = await f.read()

    # Async HTTP client
    async with httpx.AsyncClient() as client:
        response = await client.post("https://api.example.com/parse", content=content)

    # Async sleep
    await asyncio.sleep(5)

    return ProcessingResult(data=response.json())
```

For unavoidable sync code, run in a thread pool:

```python
async def process_cpu_heavy(data: bytes) -> Result:
    loop = asyncio.get_running_loop()
    result = await loop.run_in_executor(None, cpu_heavy_function, data)
    return result
```

---

### 9.2 Use Async Context Managers for Resource Cleanup

Always use `async with` for resources that need cleanup (database sessions, HTTP clients, file handles). This ensures cleanup happens even if exceptions occur, preventing connection leaks.

**Incorrect (manual resource management):**

```python
async def query_database(query: str) -> list[Row]:
    session = await create_session()
    try:
        result = await session.execute(text(query))
        rows = result.fetchall()
        return rows
    except Exception:
        raise
    finally:
        await session.close()  # Easy to forget, verbose


async def fetch_data(url: str) -> dict:
    client = httpx.AsyncClient()
    response = await client.get(url)
    data = response.json()
    await client.aclose()  # If get() raises, client is never closed!
    return data
```

**Correct (async context managers):**

```python
async def query_database(query: str) -> list[Row]:
    async with async_session_factory() as session:
        result = await session.execute(text(query))
        return result.fetchall()


async def fetch_data(url: str) -> dict[str, Any]:
    async with httpx.AsyncClient() as client:
        response = await client.get(url)
        return response.json()
```

For custom resources, implement `__aenter__` and `__aexit__` or use `@asynccontextmanager`:

```python
from contextlib import asynccontextmanager


@asynccontextmanager
async def managed_connection(url: str) -> AsyncGenerator[Connection, None]:
    conn = await connect(url)
    try:
        yield conn
    finally:
        await conn.close()
```

---

### 9.3 Use asyncio.gather for Independent Operations

When multiple async operations are independent (don't depend on each other's results), use `asyncio.gather()` to run them concurrently. Sequential awaits waste time waiting for I/O that could overlap.

**Incorrect (sequential awaits for independent operations):**

```python
async def get_document_details(doc_id: str) -> DocumentDetails:
    document = await document_service.get(doc_id)
    chunks = await chunk_service.get_by_document(doc_id)
    embeddings = await embedding_service.get_by_document(doc_id)
    permissions = await permission_service.get_for_document(doc_id)
    # Total time: sum of all four calls
    return DocumentDetails(
        document=document, chunks=chunks,
        embeddings=embeddings, permissions=permissions,
    )
```

**Correct (concurrent with asyncio.gather):**

```python
import asyncio


async def get_document_details(doc_id: str) -> DocumentDetails:
    document, chunks, embeddings, permissions = await asyncio.gather(
        document_service.get(doc_id),
        chunk_service.get_by_document(doc_id),
        embedding_service.get_by_document(doc_id),
        permission_service.get_for_document(doc_id),
    )
    # Total time: max of the four calls (not sum)
    return DocumentDetails(
        document=document, chunks=chunks,
        embeddings=embeddings, permissions=permissions,
    )
```

For error handling, use `return_exceptions=True` or `asyncio.TaskGroup` (Python 3.11+):

```python
async def get_document_details(doc_id: str) -> DocumentDetails:
    async with asyncio.TaskGroup() as tg:
        doc_task = tg.create_task(document_service.get(doc_id))
        chunks_task = tg.create_task(chunk_service.get_by_document(doc_id))

    return DocumentDetails(document=doc_task.result(), chunks=chunks_task.result())
```

Reference: [asyncio.gather](https://docs.python.org/3/library/asyncio-task.html#asyncio.gather)

---

### 9.4 Use TaskGroup for Structured Concurrency

Use `asyncio.TaskGroup` (Python 3.11+) instead of manually managing tasks. TaskGroup automatically cancels remaining tasks if any task fails and aggregates exceptions properly.

**Incorrect (manual task management):**

```python
async def ingest_documents(doc_ids: list[str]) -> list[IngestionResult]:
    tasks = []
    for doc_id in doc_ids:
        task = asyncio.create_task(ingest_single(doc_id))
        tasks.append(task)

    results = []
    for task in tasks:
        try:
            result = await task
            results.append(result)
        except Exception:
            # Other tasks keep running even after failure
            # No automatic cleanup
            pass
    return results
```

**Correct (TaskGroup with automatic cancellation):**

```python
async def ingest_documents(doc_ids: list[str]) -> list[IngestionResult]:
    results: list[IngestionResult] = []

    async with asyncio.TaskGroup() as tg:
        for doc_id in doc_ids:
            tg.create_task(ingest_single(doc_id))

    # All tasks completed successfully (or ExceptionGroup raised)
    return results
```

For cases where partial failure is acceptable:

```python
async def ingest_documents_best_effort(
    doc_ids: list[str],
) -> list[IngestionResult]:
    results = await asyncio.gather(
        *(ingest_single(doc_id) for doc_id in doc_ids),
        return_exceptions=True,
    )
    return [r for r in results if not isinstance(r, BaseException)]
```

Reference: [asyncio.TaskGroup](https://docs.python.org/3/library/asyncio-task.html#asyncio.TaskGroup)

---

## 10. Configuration & Security

**Impact:** LOW-MEDIUM
**Description:** Externalized configuration and secure defaults prevent secrets leakage and enable environment-specific deployments.

---

### 10.1 Separate Configuration by Environment

Use environment-specific configuration with clear defaults for development. Never use production values as defaults, and make it impossible to accidentally connect to production from a development environment.

**Incorrect (production config mixed with defaults):**

```python
class Config:
    DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://prod-server:5432/proddb")
    REDIS_URL = os.getenv("REDIS_URL", "redis://prod-redis:6379")
    QDRANT_URL = os.getenv("QDRANT_URL", "https://qdrant.prod.internal")
    DEBUG = True  # Debug mode on by default — dangerous in production
```

**Correct (safe defaults, explicit environments):**

```python
from pydantic_settings import BaseSettings, SettingsConfigDict


class ServiceConfig(BaseSettings):
    model_config = SettingsConfigDict(
        env_prefix="APP_",
        env_file=".env",
    )

    # Safe defaults point to localhost / development
    database_url: str = "postgresql://localhost:5432/devdb"
    redis_url: str = "redis://localhost:6379"
    qdrant_url: str = "http://localhost:6333"
    debug: bool = False  # Off by default — must be explicitly enabled
    environment: str = "development"

    @property
    def is_production(self) -> bool:
        return self.environment == "production"
```

Use `.env` template files checked into version control:

```bash
# .env.template (committed, no real secrets)
APP_DATABASE_URL=postgresql://localhost:5432/devdb
APP_ENVIRONMENT=development
APP_DEBUG=true

# .env.local (gitignored, real values)
APP_DATABASE_URL=postgresql://actual-dev-server:5432/devdb
APP_API_KEY=dev-key-abc123
```

---

### 10.2 Never Hardcode Secrets or Credentials

Never hardcode API keys, passwords, tokens, or connection strings in source code. Use environment variables, secret managers, or configuration files excluded from version control.

**Incorrect (hardcoded secrets):**

```python
# Secrets committed to version control
DATABASE_URL = "postgresql://admin:secretpassword123@db.prod.internal/mydb"
API_KEY = "sk-abc123def456"
JWT_SECRET = "my-super-secret-jwt-key"


def get_client() -> httpx.AsyncClient:
    return httpx.AsyncClient(
        headers={"Authorization": "Bearer sk-abc123def456"}
    )
```

**Correct (externalized secrets):**

```python
from pydantic import SecretStr
from pydantic_settings import BaseSettings


class ServiceSecrets(BaseSettings):
    database_url: SecretStr
    api_key: SecretStr
    jwt_secret: SecretStr


secrets = ServiceSecrets()  # Loaded from environment variables


def get_client() -> httpx.AsyncClient:
    return httpx.AsyncClient(
        headers={"Authorization": f"Bearer {secrets.api_key.get_secret_value()}"}
    )
```

Using `SecretStr` prevents accidental logging:

```python
print(secrets.api_key)  # SecretStr('**********') — safe
print(secrets.api_key.get_secret_value())  # Explicit access required
```

Ensure `.env` files with real secrets are in `.gitignore`:

```gitignore
.env.local
.env.production
*.key
*.pem
```

---

### 10.3 Use Pydantic Settings for Configuration

Use `pydantic-settings` to load and validate configuration from environment variables and files. This catches configuration errors at startup rather than at runtime.

**Incorrect (manual environment variable parsing):**

```python
import os

# No validation, wrong types silently pass
DATABASE_URL = os.environ.get("DATABASE_URL", "")
MAX_WORKERS = os.environ.get("MAX_WORKERS", "4")  # Still a string!
DEBUG = os.environ.get("DEBUG", "false")  # "false" is truthy as a string
TIMEOUT = os.environ.get("TIMEOUT")  # None if not set — crashes later

if DEBUG:  # Always truthy! "false" is a non-empty string
    enable_debug()
```

**Correct (pydantic-settings):**

```python
from pydantic_settings import BaseSettings, SettingsConfigDict


class ServiceConfig(BaseSettings):
    model_config = SettingsConfigDict(
        env_prefix="APP_",
        env_file=".env",
        frozen=True,
    )

    database_url: str
    max_workers: int = 4
    debug: bool = False
    timeout: float = 30.0
    log_level: str = "INFO"


# Validates at startup — fails fast with clear error messages
config = ServiceConfig()

# All fields are correctly typed
assert isinstance(config.max_workers, int)
assert isinstance(config.debug, bool)  # "false" → False correctly
```

Reference: [pydantic-settings](https://docs.pydantic.dev/latest/concepts/pydantic_settings/)
