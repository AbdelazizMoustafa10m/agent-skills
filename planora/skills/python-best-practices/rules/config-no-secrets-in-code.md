---
title: Never Hardcode Secrets or Credentials
impact: CRITICAL
impactDescription: prevents credential leaks in version control
tags: config, security, secrets, credentials, environment-variables
---

## Never Hardcode Secrets or Credentials

Never hardcode API keys, passwords, tokens, or connection strings in source code. Use environment variables, secret managers, or configuration files excluded from version control.

**Incorrect (hardcoded secrets):**

```python
# Secrets committed to version control
DATABASE_URL = "postgresql://admin:secretpassword123@db.prod.internal/mydb"
API_KEY = "sk-abc123def456"
JWT_SECRET = "my-super-secret-jwt-key"


def get_client() -> httpx.AsyncClient:
    return httpx.AsyncClient(
        headers={"Authorization": "Bearer sk-abc123def456"}
    )
```

**Correct (externalized secrets):**

```python
from pydantic import SecretStr
from pydantic_settings import BaseSettings


class ServiceSecrets(BaseSettings):
    database_url: SecretStr
    api_key: SecretStr
    jwt_secret: SecretStr


secrets = ServiceSecrets()  # Loaded from environment variables


def get_client() -> httpx.AsyncClient:
    return httpx.AsyncClient(
        headers={"Authorization": f"Bearer {secrets.api_key.get_secret_value()}"}
    )
```

Using `SecretStr` prevents accidental logging:

```python
print(secrets.api_key)  # SecretStr('**********') — safe
print(secrets.api_key.get_secret_value())  # Explicit access required
```

Ensure `.env` files with real secrets are in `.gitignore`:

```gitignore
.env.local
.env.production
*.key
*.pem
```
