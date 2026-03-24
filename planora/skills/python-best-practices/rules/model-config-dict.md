---
title: Use model_config Dict, Not Inner Config Class
impact: MEDIUM
impactDescription: Pydantic v2 standard, avoids deprecation warnings
tags: model, Pydantic, config, ConfigDict, migration
---

## Use model_config Dict, Not Inner Config Class

In Pydantic v2, use `model_config = ConfigDict(...)` instead of the deprecated inner `class Config`. This is the standard approach and avoids deprecation warnings.

**Incorrect (deprecated inner Config class):**

```python
class ServiceSettings(BaseModel):
    host: str
    port: int
    debug: bool = False

    class Config:  # Deprecated in Pydantic v2
        env_prefix = "SERVICE_"
        frozen = True
        str_strip_whitespace = True
```

**Correct (ConfigDict):**

```python
from pydantic import ConfigDict


class ServiceSettings(BaseModel):
    model_config = ConfigDict(
        frozen=True,
        str_strip_whitespace=True,
    )

    host: str
    port: int
    debug: bool = False
```

For settings with environment variable loading, use `pydantic-settings`:

```python
from pydantic_settings import BaseSettings, SettingsConfigDict


class ServiceSettings(BaseSettings):
    model_config = SettingsConfigDict(
        env_prefix="SERVICE_",
        frozen=True,
    )

    host: str
    port: int
    debug: bool = False
```

Reference: [Pydantic v2 migration](https://docs.pydantic.dev/latest/migration/)
