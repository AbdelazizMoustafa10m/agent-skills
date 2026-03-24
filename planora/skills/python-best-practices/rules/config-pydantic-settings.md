---
title: Use Pydantic Settings for Configuration
impact: MEDIUM
impactDescription: type-safe config, automatic env var parsing, validation at startup
tags: config, pydantic-settings, environment, validation, startup
---

## Use Pydantic Settings for Configuration

Use `pydantic-settings` to load and validate configuration from environment variables and files. This catches configuration errors at startup rather than at runtime.

**Incorrect (manual environment variable parsing):**

```python
import os

# No validation, wrong types silently pass
DATABASE_URL = os.environ.get("DATABASE_URL", "")
MAX_WORKERS = os.environ.get("MAX_WORKERS", "4")  # Still a string!
DEBUG = os.environ.get("DEBUG", "false")  # "false" is truthy as a string
TIMEOUT = os.environ.get("TIMEOUT")  # None if not set — crashes later

if DEBUG:  # Always truthy! "false" is a non-empty string
    enable_debug()
```

**Correct (pydantic-settings):**

```python
from pydantic_settings import BaseSettings, SettingsConfigDict


class ServiceConfig(BaseSettings):
    model_config = SettingsConfigDict(
        env_prefix="APP_",
        env_file=".env",
        frozen=True,
    )

    database_url: str
    max_workers: int = 4
    debug: bool = False
    timeout: float = 30.0
    log_level: str = "INFO"


# Validates at startup — fails fast with clear error messages
config = ServiceConfig()

# All fields are correctly typed
assert isinstance(config.max_workers, int)
assert isinstance(config.debug, bool)  # "false" → False correctly
```

Reference: [pydantic-settings](https://docs.pydantic.dev/latest/concepts/pydantic_settings/)
