---
title: Separate Configuration by Environment
impact: MEDIUM
impactDescription: prevents accidental production changes in development
tags: config, environment, separation, deployment, safety
---

## Separate Configuration by Environment

Use environment-specific configuration with clear defaults for development. Never use production values as defaults, and make it impossible to accidentally connect to production from a development environment.

**Incorrect (production config mixed with defaults):**

```python
class Config:
    DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://prod-server:5432/proddb")
    REDIS_URL = os.getenv("REDIS_URL", "redis://prod-redis:6379")
    QDRANT_URL = os.getenv("QDRANT_URL", "https://qdrant.prod.internal")
    DEBUG = True  # Debug mode on by default — dangerous in production
```

**Correct (safe defaults, explicit environments):**

```python
from pydantic_settings import BaseSettings, SettingsConfigDict


class ServiceConfig(BaseSettings):
    model_config = SettingsConfigDict(
        env_prefix="APP_",
        env_file=".env",
    )

    # Safe defaults point to localhost / development
    database_url: str = "postgresql://localhost:5432/devdb"
    redis_url: str = "redis://localhost:6379"
    qdrant_url: str = "http://localhost:6333"
    debug: bool = False  # Off by default — must be explicitly enabled
    environment: str = "development"

    @property
    def is_production(self) -> bool:
        return self.environment == "production"
```

Use `.env` template files checked into version control:

```bash
# .env.template (committed, no real secrets)
APP_DATABASE_URL=postgresql://localhost:5432/devdb
APP_ENVIRONMENT=development
APP_DEBUG=true

# .env.local (gitignored, real values)
APP_DATABASE_URL=postgresql://actual-dev-server:5432/devdb
APP_API_KEY=dev-key-abc123
```
