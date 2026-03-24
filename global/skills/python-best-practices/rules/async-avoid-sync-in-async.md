---
title: Never Call Blocking Code in Async Functions
impact: CRITICAL
impactDescription: prevents event loop starvation, maintains concurrency
tags: async, blocking, sync, event-loop, performance
---

## Never Call Blocking Code in Async Functions

Never call synchronous blocking operations (file I/O, CPU-heavy computation, `time.sleep()`, synchronous HTTP) inside async functions. This blocks the entire event loop, preventing all other coroutines from executing.

**Incorrect (blocking calls in async context):**

```python
import time
import requests


async def process_document(doc_id: str) -> ProcessingResult:
    # Blocks the event loop for the entire file read
    with open(f"/data/{doc_id}.pdf", "rb") as f:
        content = f.read()

    # Blocks the event loop during HTTP call
    response = requests.post("https://api.example.com/parse", data=content)

    # Blocks the event loop
    time.sleep(5)

    return ProcessingResult(data=response.json())
```

**Correct (non-blocking alternatives):**

```python
import asyncio
import aiofiles
import httpx


async def process_document(doc_id: str) -> ProcessingResult:
    # Async file I/O
    async with aiofiles.open(f"/data/{doc_id}.pdf", "rb") as f:
        content = await f.read()

    # Async HTTP client
    async with httpx.AsyncClient() as client:
        response = await client.post("https://api.example.com/parse", content=content)

    # Async sleep
    await asyncio.sleep(5)

    return ProcessingResult(data=response.json())
```

For unavoidable sync code, run in a thread pool:

```python
async def process_cpu_heavy(data: bytes) -> Result:
    loop = asyncio.get_running_loop()
    result = await loop.run_in_executor(None, cpu_heavy_function, data)
    return result
```
