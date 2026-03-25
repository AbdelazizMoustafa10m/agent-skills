---
title: Use TaskGroup for Structured Concurrency
impact: LOW-MEDIUM
impactDescription: automatic cancellation on failure, cleaner error handling
tags: async, TaskGroup, structured-concurrency, Python311, cancellation
---

## Use TaskGroup for Structured Concurrency

Use `asyncio.TaskGroup` (Python 3.11+) instead of manually managing tasks. TaskGroup automatically cancels remaining tasks if any task fails and aggregates exceptions properly.

**Incorrect (manual task management):**

```python
async def ingest_documents(doc_ids: list[str]) -> list[IngestionResult]:
    tasks = []
    for doc_id in doc_ids:
        task = asyncio.create_task(ingest_single(doc_id))
        tasks.append(task)

    results = []
    for task in tasks:
        try:
            result = await task
            results.append(result)
        except Exception:
            # Other tasks keep running even after failure
            # No automatic cleanup
            pass
    return results
```

**Correct (TaskGroup with automatic cancellation):**

```python
async def ingest_documents(doc_ids: list[str]) -> list[IngestionResult]:
    results: list[IngestionResult] = []

    async with asyncio.TaskGroup() as tg:
        for doc_id in doc_ids:
            tg.create_task(ingest_single(doc_id))

    # All tasks completed successfully (or ExceptionGroup raised)
    return results
```

For cases where partial failure is acceptable:

```python
async def ingest_documents_best_effort(
    doc_ids: list[str],
) -> list[IngestionResult]:
    results = await asyncio.gather(
        *(ingest_single(doc_id) for doc_id in doc_ids),
        return_exceptions=True,
    )
    return [r for r in results if not isinstance(r, BaseException)]
```

Reference: [asyncio.TaskGroup](https://docs.python.org/3/library/asyncio-task.html#asyncio.TaskGroup)
