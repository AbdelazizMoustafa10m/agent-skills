---
title: Catch Specific Exceptions
impact: CRITICAL
impactDescription: prevents masking real bugs, enables targeted recovery
tags: error, exceptions, catch, specific, bare-except
---

## Catch Specific Exceptions

Always catch specific exception types. Never use bare `except:` or `except Exception:` as a catch-all. Broad exception handlers mask real bugs, swallow keyboard interrupts, and make debugging extremely difficult.

**Incorrect (overly broad exception handling):**

```python
def fetch_document(doc_id: str) -> Document | None:
    try:
        response = client.get(f"/documents/{doc_id}")
        return Document.model_validate(response.json())
    except:  # Catches SystemExit, KeyboardInterrupt, everything
        return None


def parse_config(path: str) -> dict[str, Any]:
    try:
        with open(path) as f:
            return yaml.safe_load(f)
    except Exception:  # Catches FileNotFoundError, PermissionError, yaml errors — all silently
        return {}
```

**Correct (specific exceptions):**

```python
def fetch_document(doc_id: str) -> Document | None:
    try:
        response = client.get(f"/documents/{doc_id}")
        response.raise_for_status()
        return Document.model_validate(response.json())
    except httpx.HTTPStatusError:
        logger.warning("Document %s not found", doc_id)
        return None
    except ValidationError as exc:
        logger.error("Invalid document data for %s: %s", doc_id, exc)
        raise


def parse_config(path: str) -> dict[str, Any]:
    try:
        with open(path) as f:
            return yaml.safe_load(f)
    except FileNotFoundError:
        logger.info("Config file %s not found, using defaults", path)
        return {}
    except yaml.YAMLError as exc:
        raise ConfigurationError(f"Invalid YAML in {path}") from exc
```

Reference: [PEP 8 - Programming Recommendations](https://peps.python.org/pep-0008/#programming-recommendations)
