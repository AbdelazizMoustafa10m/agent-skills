---
title: Never Concatenate User Input into SQL
impact: CRITICAL
impactDescription: Eliminates SQL injection risks and improves query plan stability.
tags: db, security, sql
---

## Never Concatenate User Input into SQL

Always use bound parameters when executing SQL statements.

**Incorrect python code:**

```python
query = f"SELECT * FROM jobs WHERE namespace_id = '{namespace_id}'"
rows = await session.execute(text(query))
```

**Correct python code:**

```python
stmt = text("SELECT * FROM jobs WHERE namespace_id = :namespace_id")
rows = await session.execute(stmt, {"namespace_id": namespace_id})
```

Reference: [SQLAlchemy - bound parameters](https://docs.sqlalchemy.org/en/20/core/sqlelement.html#sqlalchemy.sql.expression.bindparam)

