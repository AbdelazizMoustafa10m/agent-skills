---
title: Use Exception Chaining with raise...from
impact: HIGH
impactDescription: preserves full error context for debugging
tags: error, chaining, raise-from, traceback, debugging
---

## Use Exception Chaining with raise...from

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
