---
title: Use Union Syntax with Pipe Operator
impact: MEDIUM
impactDescription: cleaner syntax, consistent with Python 3.10+ standards
tags: typing, union, Optional, pipe-operator, PEP604
---

## Use Union Syntax with Pipe Operator

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
