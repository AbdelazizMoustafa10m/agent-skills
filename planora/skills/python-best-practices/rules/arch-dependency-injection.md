---
title: Inject Dependencies, Don't Import Globals
impact: HIGH
impactDescription: enables testing, swapping implementations
tags: architecture, DI, dependency-injection, testing, coupling
---

## Inject Dependencies, Don't Import Globals

Pass dependencies through constructors or function parameters instead of importing global singletons. This enables testing with fakes, swapping implementations, and understanding what a class actually depends on.

**Incorrect (importing global singletons):**

```python
# Hard-coded dependency on global singleton
from app.database import db_session
from app.cache import redis_client
from app.config import settings


class UserService:
    async def get_user(self, user_id: str) -> User:
        cached = await redis_client.get(f"user:{user_id}")
        if cached:
            return User.model_validate_json(cached)
        result = await db_session.execute(
            select(UserModel).where(UserModel.id == user_id)
        )
        return User.model_validate(result.scalar_one())
```

**Correct (injected dependencies):**

```python
class UserService:
    def __init__(
        self,
        session: AsyncSession,
        cache: CacheClient,
    ) -> None:
        self._session = session
        self._cache = cache

    async def get_user(self, user_id: str) -> User:
        cached = await self._cache.get(f"user:{user_id}")
        if cached:
            return User.model_validate_json(cached)
        result = await self._session.execute(
            select(UserModel).where(UserModel.id == user_id)
        )
        return User.model_validate(result.scalar_one())


# In FastAPI, wire dependencies with Depends()
async def get_user_service(
    session: AsyncSession = Depends(get_session),
    cache: CacheClient = Depends(get_cache),
) -> UserService:
    return UserService(session=session, cache=cache)
```
