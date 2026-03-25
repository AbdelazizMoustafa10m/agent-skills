---
title: Use TypedDict for Structured Dictionaries
impact: MEDIUM-HIGH
impactDescription: adds type safety to dict structures without full model overhead
tags: typing, TypedDict, dictionary, structured-data
---

## Use TypedDict for Structured Dictionaries

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
