---
title: Avoid cast and type-ignore Misuse
impact: HIGH
impactDescription: Prevents hiding real type bugs and keeps strict mode trustworthy.
tags: typing, mypy, cast, type-ignore
---

## Avoid cast and type-ignore Misuse

Use `cast(...)` or `# type: ignore[...]` only when runtime evidence is proven and documented.

**Incorrect python code:**

```python
from typing import cast


def get_payload(data: object) -> dict[str, str]:
    return cast(dict[str, str], data)  # blind cast


value = maybe_get_value()  # type: ignore[assignment]
```

**Correct python code:**

```python
def get_payload(data: object) -> dict[str, str]:
    if not isinstance(data, dict):
        raise TypeError("payload must be a dict")
    if not all(isinstance(k, str) and isinstance(v, str) for k, v in data.items()):
        raise TypeError("payload keys and values must be str")
    return data
```

Reference: [mypy common issues - casts and ignores](https://mypy.readthedocs.io/en/stable/common_issues.html)

