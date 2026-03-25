---
title: Use PEP 695 Type Alias Syntax
impact: MEDIUM-HIGH
impactDescription: cleaner syntax, better tooling support in Python 3.12+
tags: typing, PEP695, type-alias, Python312, generics
---

## Use PEP 695 Type Alias Syntax

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
