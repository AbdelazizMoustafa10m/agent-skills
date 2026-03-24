---
title: Use UTC-Aware Timestamps Everywhere
impact: HIGH
impactDescription: Prevents timezone drift and inconsistent ordering across services.
tags: style, datetime, utc
---

## Use UTC-Aware Timestamps Everywhere

Use timezone-aware UTC timestamps (`datetime.now(UTC)`) for stored and exchanged values.

**Incorrect python code:**

```python
from datetime import datetime


def mark_processed(job: Job) -> None:
    job.processed_at = datetime.now()  # naive local time
```

**Correct python code:**

```python
from datetime import UTC, datetime


def mark_processed(job: Job) -> None:
    job.processed_at = datetime.now(UTC)
```

Reference: [Python datetime aware vs naive objects](https://docs.python.org/3/library/datetime.html#aware-and-naive-objects)

