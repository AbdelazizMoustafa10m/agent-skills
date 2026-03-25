---
title: Use asyncio.gather for Independent Operations
impact: MEDIUM-HIGH
impactDescription: executes concurrent I/O in parallel instead of sequentially
tags: async, gather, concurrency, parallel, performance
---

## Use asyncio.gather for Independent Operations

When multiple async operations are independent (don't depend on each other's results), use `asyncio.gather()` to run them concurrently. Sequential awaits waste time waiting for I/O that could overlap.

**Incorrect (sequential awaits for independent operations):**

```python
async def get_document_details(doc_id: str) -> DocumentDetails:
    document = await document_service.get(doc_id)
    chunks = await chunk_service.get_by_document(doc_id)
    embeddings = await embedding_service.get_by_document(doc_id)
    permissions = await permission_service.get_for_document(doc_id)
    # Total time: sum of all four calls
    return DocumentDetails(
        document=document, chunks=chunks,
        embeddings=embeddings, permissions=permissions,
    )
```

**Correct (concurrent with asyncio.gather):**

```python
import asyncio


async def get_document_details(doc_id: str) -> DocumentDetails:
    document, chunks, embeddings, permissions = await asyncio.gather(
        document_service.get(doc_id),
        chunk_service.get_by_document(doc_id),
        embedding_service.get_by_document(doc_id),
        permission_service.get_for_document(doc_id),
    )
    # Total time: max of the four calls (not sum)
    return DocumentDetails(
        document=document, chunks=chunks,
        embeddings=embeddings, permissions=permissions,
    )
```

For error handling, use `return_exceptions=True` or `asyncio.TaskGroup` (Python 3.11+):

```python
async def get_document_details(doc_id: str) -> DocumentDetails:
    async with asyncio.TaskGroup() as tg:
        doc_task = tg.create_task(document_service.get(doc_id))
        chunks_task = tg.create_task(chunk_service.get_by_document(doc_id))

    return DocumentDetails(document=doc_task.result(), chunks=chunks_task.result())
```

Reference: [asyncio.gather](https://docs.python.org/3/library/asyncio-task.html#asyncio.gather)
