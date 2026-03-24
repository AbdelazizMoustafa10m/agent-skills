---
title: Close Sessions Only If Created Locally
impact: HIGH
impactDescription: Prevents caller-owned session breakage and hidden resource leaks.
tags: async, session, lifecycle
---

## Close Sessions Only If Created Locally

When accepting optional session injection, close the session only if this function created it.

**Incorrect python code:**

```python
async def get_namespace(namespace_id: str, _session: AsyncSession | None = None) -> Namespace:
    session = _session or AsyncSession()
    try:
        return await _fetch_namespace(session, namespace_id)
    finally:
        await session.close()
```

**Correct python code:**

```python
async def get_namespace(namespace_id: str, _session: AsyncSession | None = None) -> Namespace:
    session = _session or AsyncSession()
    try:
        return await _fetch_namespace(session, namespace_id)
    finally:
        if _session is None:
            await session.close()
```

Reference: [SQLAlchemy AsyncSession](https://docs.sqlalchemy.org/en/20/orm/extensions/asyncio.html)

