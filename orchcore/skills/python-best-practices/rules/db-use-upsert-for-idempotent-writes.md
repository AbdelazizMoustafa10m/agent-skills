---
title: Use Upsert Patterns for Idempotent Writes
impact: HIGH
impactDescription: Prevents duplicate rows and simplifies retried processing semantics.
tags: db, upsert, idempotency
---

## Use Upsert Patterns for Idempotent Writes

For retry-prone paths, use database-level upsert semantics keyed by stable identifiers.

**Incorrect python code:**

```python
session.add(JobEvent(event_id=event_id, payload=payload))
await session.commit()
```

**Correct python code:**

```python
stmt = insert(JobEvent).values(event_id=event_id, payload=payload)
stmt = stmt.on_conflict_do_nothing(index_elements=[JobEvent.event_id])
await session.execute(stmt)
await session.commit()
```

Reference: [SQLAlchemy PostgreSQL ON CONFLICT](https://docs.sqlalchemy.org/en/20/dialects/postgresql.html#insert-on-conflict-upsert)

