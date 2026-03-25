---
title: Never Store or Log Secrets and Hash Tokens
impact: CRITICAL
impactDescription: Prevents credential leakage and supports compliance requirements.
tags: ops, security, secrets, logging
---

## Never Store or Log Secrets and Hash Tokens

Do not persist raw tokens or print them in logs; hash before storage/comparison.

**Incorrect python code:**

```python
logger.info("received api token", extra={"token": api_token})
db_token = APIToken(value=api_token)
```

**Correct python code:**

```python
token_hash = hashlib.sha256(api_token.encode("utf-8")).hexdigest()
logger.info("received api token", extra={"token_hash_prefix": token_hash[:8]})
db_token = APIToken(hash=token_hash)
```

Reference: [OWASP Secrets Management Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html)

