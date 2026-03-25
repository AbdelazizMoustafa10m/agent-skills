---
title: Map Recoverable Database Failures to HTTP 503
impact: CRITICAL
impactDescription: Prevents masking transient infra issues as permanent client errors.
tags: error, database, fastapi, http
---

## Map Recoverable Database Failures to HTTP 503

Translate recoverable backend outages (timeouts, connection drops) to `503 Service Unavailable`.

**Incorrect python code:**

```python
from fastapi import HTTPException


async def get_job_or_fail(session: AsyncSession, job_id: str) -> Job:
    try:
        return await load_job(session, job_id)
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc))
```

**Correct python code:**

```python
from fastapi import HTTPException
from sqlalchemy.exc import DBAPIError, OperationalError


async def get_job_or_fail(session: AsyncSession, job_id: str) -> Job:
    try:
        return await load_job(session, job_id)
    except (OperationalError, DBAPIError) as exc:
        raise HTTPException(status_code=503, detail="database temporarily unavailable") from exc
```

Reference: [RFC 9110 503 Service Unavailable](https://www.rfc-editor.org/rfc/rfc9110#name-503-service-unavailable)

