---
title: Use Narrow Types Over Broad Ones
impact: CRITICAL
impactDescription: catches incorrect usage at type-check time
tags: typing, narrow, specific, Any, broad-types
---

## Use Narrow Types Over Broad Ones

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
