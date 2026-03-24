---
title: Use Async Fixtures Properly
impact: MEDIUM
impactDescription: prevents event loop errors and test hangs
tags: test, async, fixtures, pytest-asyncio, event-loop
---

## Use Async Fixtures Properly

Use `pytest-asyncio` with proper fixture scoping. Mark async fixtures and tests correctly, and use `AsyncExitStack` for managing multiple async context managers in fixtures.

**Incorrect (common async fixture mistakes):**

```python
# Missing pytest.mark.asyncio or wrong mode
async def test_query_service(query_service):  # Not marked as async test
    result = await query_service.execute("test query")
    assert result


# Fixture doesn't properly clean up async resources
@pytest.fixture
async def db_session():
    session = await create_session()
    return session  # Session never closed!


# Blocking call in async fixture
@pytest.fixture
async def config():
    return load_config_sync()  # Blocks the event loop
```

**Correct (proper async fixtures):**

```python
import pytest
from contextlib import AsyncExitStack


@pytest.fixture
async def db_session() -> AsyncGenerator[AsyncSession, None]:
    async with async_session_factory() as session:
        yield session
        await session.rollback()


@pytest.fixture
async def service_stack() -> AsyncGenerator[ServiceStack, None]:
    async with AsyncExitStack() as stack:
        db = await stack.enter_async_context(create_db_connection())
        cache = await stack.enter_async_context(create_cache_connection())
        yield ServiceStack(db=db, cache=cache)


@pytest.mark.asyncio
async def test_query_service(db_session: AsyncSession) -> None:
    service = QueryService(db_session)
    result = await service.execute("test query")
    assert result.answer is not None
```

Configure `pytest-asyncio` mode in `pyproject.toml`:

```toml
[tool.pytest.ini_options]
asyncio_mode = "auto"
```

Reference: [pytest-asyncio documentation](https://pytest-asyncio.readthedocs.io/)
