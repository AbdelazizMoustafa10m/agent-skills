---
title: Retry Transient Errors with Backoff and Jitter
impact: HIGH
impactDescription: Reduces synchronized retry storms and improves success under temporary failures.
tags: error, retry, resilience
---

## Retry Transient Errors with Backoff and Jitter

Retry only transient failures with bounded exponential backoff and random jitter.

**Incorrect python code:**

```python
async def fetch_with_retry(client: QueryClient, query: str) -> QueryResult:
    for _ in range(5):
        try:
            return await client.search(query)
        except Exception:
            await asyncio.sleep(0.1)
    raise RuntimeError("search failed")
```

**Correct python code:**

```python
import random


async def fetch_with_retry(client: QueryClient, query: str) -> QueryResult:
    max_attempts = 4
    for attempt in range(max_attempts):
        try:
            return await client.search(query)
        except (TimeoutError, ConnectionError):
            if attempt == max_attempts - 1:
                raise
            delay = (2**attempt) * 0.1 + random.uniform(0, 0.05)
            await asyncio.sleep(delay)
```

Reference: [AWS - Exponential Backoff and Jitter](https://aws.amazon.com/builders-library/timeouts-retries-and-backoff-with-jitter/)
