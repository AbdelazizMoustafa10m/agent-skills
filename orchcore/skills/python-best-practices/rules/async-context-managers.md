---
title: Use Async Context Managers for Resource Cleanup
impact: HIGH
impactDescription: prevents resource leaks in async code
tags: async, context-manager, cleanup, resources, with
---

## Use Async Context Managers for Resource Cleanup

Always use `async with` for resources that need cleanup (database sessions, HTTP clients, file handles). This ensures cleanup happens even if exceptions occur, preventing connection leaks.

**Incorrect (manual resource management):**

```python
async def query_database(query: str) -> list[Row]:
    session = await create_session()
    try:
        result = await session.execute(text(query))
        rows = result.fetchall()
        return rows
    except Exception:
        raise
    finally:
        await session.close()  # Easy to forget, verbose


async def fetch_data(url: str) -> dict:
    client = httpx.AsyncClient()
    response = await client.get(url)
    data = response.json()
    await client.aclose()  # If get() raises, client is never closed!
    return data
```

**Correct (async context managers):**

```python
async def query_database(query: str) -> list[Row]:
    async with async_session_factory() as session:
        result = await session.execute(text(query))
        return result.fetchall()


async def fetch_data(url: str) -> dict[str, Any]:
    async with httpx.AsyncClient() as client:
        response = await client.get(url)
        return response.json()
```

For custom resources, implement `__aenter__` and `__aexit__` or use `@asynccontextmanager`:

```python
from contextlib import asynccontextmanager


@asynccontextmanager
async def managed_connection(url: str) -> AsyncGenerator[Connection, None]:
    conn = await connect(url)
    try:
        yield conn
    finally:
        await conn.close()
```
