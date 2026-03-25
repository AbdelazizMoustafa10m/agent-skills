---
title: Apply Timeouts and Respect Cancellation
impact: HIGH
impactDescription: Prevents hung requests and preserves system capacity under partial outages.
tags: async, timeout, cancellation
---

## Apply Timeouts and Respect Cancellation

Wrap network/database awaits with timeouts and re-raise cancellation errors.

**Incorrect python code:**

```python
async def call_service(client: QueryClient, query: str) -> QueryResult:
    try:
        return await client.search(query)
    except Exception:
        return QueryResult.empty()
```

**Correct python code:**

```python
async def call_service(client: QueryClient, query: str) -> QueryResult:
    try:
        async with asyncio.timeout(5):
            return await client.search(query)
    except asyncio.CancelledError:
        raise
    except TimeoutError as exc:
        raise QueryTimeoutError("query service timed out") from exc
```

Reference: [asyncio.timeout](https://docs.python.org/3/library/asyncio-task.html#timeouts)

