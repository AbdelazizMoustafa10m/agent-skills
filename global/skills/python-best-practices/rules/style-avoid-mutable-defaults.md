---
title: Never Use Mutable Default Arguments
impact: CRITICAL
impactDescription: prevents shared-state bugs across function calls
tags: style, mutable, default, argument, bug, gotcha
---

## Never Use Mutable Default Arguments

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
