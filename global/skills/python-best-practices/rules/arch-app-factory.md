---
title: Use Application Factory Pattern
impact: HIGH
impactDescription: enables testing with different configs, prevents import-time side effects
tags: architecture, factory, FastAPI, application, startup
---

## Use Application Factory Pattern

Create FastAPI applications via a `get_app()` factory function rather than at module level. This prevents import-time side effects, enables testing with different configurations, and supports proper lifespan management.

**Incorrect (module-level app creation):**

```python
# app.py — side effects at import time
from fastapi import FastAPI

app = FastAPI(title="Document Service")

# Database connection happens at import — breaks tests
engine = create_engine(settings.database_url)
session_factory = sessionmaker(engine)

@app.get("/documents/{doc_id}")
async def get_document(doc_id: str):
    # Uses module-level session_factory
    ...
```

**Correct (factory pattern):**

```python
# app.py
from fastapi import FastAPI
from contextlib import asynccontextmanager


def get_app(config: ServiceConfig | None = None) -> FastAPI:
    config = config or ServiceConfig()

    @asynccontextmanager
    async def lifespan(app: FastAPI):
        # Startup: initialize connections
        engine = create_async_engine(config.database_url)
        app.state.session_factory = async_sessionmaker(engine)
        yield
        # Shutdown: clean up
        await engine.dispose()

    app = FastAPI(title="Document Service", lifespan=lifespan)
    app.include_router(document_router)
    return app
```

In tests, create the app with test configuration:

```python
@pytest.fixture
def app() -> FastAPI:
    return get_app(config=ServiceConfig(database_url="sqlite+aiosqlite://"))
```
