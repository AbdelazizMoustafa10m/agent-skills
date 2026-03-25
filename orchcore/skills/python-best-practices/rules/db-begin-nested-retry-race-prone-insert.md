---
title: Use begin_nested Retry for Race-Prone Inserts
impact: CRITICAL
impactDescription: Handles uniqueness races safely without dropping requests.
tags: db, sqlalchemy, transactions, concurrency
---

## Use begin_nested Retry for Race-Prone Inserts

When unique keys can race, wrap insert in `begin_nested()` and retry known integrity failures.

**Incorrect python code:**

```python
async def ensure_namespace(session: AsyncSession, name: str) -> Namespace:
    namespace = Namespace(name=name)
    session.add(namespace)
    await session.commit()
    return namespace
```

**Correct python code:**

```python
from sqlalchemy.exc import IntegrityError


async def ensure_namespace(session: AsyncSession, name: str) -> Namespace:
    for _ in range(2):
        try:
            async with session.begin_nested():
                namespace = Namespace(name=name)
                session.add(namespace)
                await session.flush()
            return namespace
        except IntegrityError:
            existing = await get_namespace_by_name(session, name)
            if existing is not None:
                return existing
    raise RuntimeError("failed to ensure namespace")
```

Reference: [SQLAlchemy SAVEPOINT / begin_nested](https://docs.sqlalchemy.org/en/20/orm/session_transaction.html#using-savepoint)

