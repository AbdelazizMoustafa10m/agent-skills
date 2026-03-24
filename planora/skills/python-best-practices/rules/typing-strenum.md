---
title: Use StrEnum for String Enumerations
impact: MEDIUM
impactDescription: type-safe string constants with IDE autocompletion
tags: typing, StrEnum, enum, constants, Python311
---

## Use StrEnum for String Enumerations

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
