---
title: Never Silently Swallow Exceptions
impact: CRITICAL
impactDescription: prevents hidden failures that corrupt data silently
tags: error, swallow, silent, logging, pass
---

## Never Silently Swallow Exceptions

Never catch an exception and do nothing with it. At minimum, log the exception. Silent exception swallowing creates invisible bugs that are extremely difficult to diagnose in production.

**Incorrect (swallowed exceptions):**

```python
def send_notification(user_id: str, message: str) -> None:
    try:
        email_client.send(user_id, message)
    except Exception:
        pass  # Silently fails — user never gets notified, no one knows


def update_cache(key: str, value: str) -> None:
    try:
        cache.set(key, value)
    except Exception:
        ...  # Same problem with ellipsis
```

**Correct (exceptions handled explicitly):**

```python
def send_notification(user_id: str, message: str) -> None:
    try:
        email_client.send(user_id, message)
    except ConnectionError:
        logger.warning(
            "Failed to send notification to user %s, will retry", user_id, exc_info=True
        )
        retry_queue.enqueue(user_id, message)


def update_cache(key: str, value: str) -> None:
    try:
        cache.set(key, value)
    except CacheConnectionError:
        logger.warning("Cache update failed for key %s", key, exc_info=True)
        # Cache miss is acceptable — operation continues without caching
```

If an exception is truly expected and safe to ignore, document WHY:

```python
def cleanup_temp_file(path: Path) -> None:
    try:
        path.unlink()
    except FileNotFoundError:
        pass  # File already cleaned up by another process — this is expected
```
