---
title: Avoid Unjustified Optional Types
impact: HIGH
impactDescription: Reduces dead checks and enforces clearer contracts at boundaries.
tags: typing, optional, mypy
---

## Avoid Unjustified Optional Types

Do not annotate values as optional unless `None` is a real, expected state in the contract.

**Incorrect python code:**

```python
def build_namespace_url(base_url: str, namespace_id: str | None) -> str:
    if namespace_id is None:
        raise ValueError("namespace_id is required")
    return f"{base_url}/namespaces/{namespace_id}"
```

**Correct python code:**

```python
def build_namespace_url(base_url: str, namespace_id: str) -> str:
    return f"{base_url}/namespaces/{namespace_id}"
```

Reference: [mypy kind of types - Optional types and strict optional](https://mypy.readthedocs.io/en/stable/kinds_of_types.html#optional-types-and-the-none-type)

