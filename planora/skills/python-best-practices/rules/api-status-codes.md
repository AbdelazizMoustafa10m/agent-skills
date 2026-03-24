---
title: Use Explicit HTTP Status Codes
impact: MEDIUM
impactDescription: correct semantics, accurate OpenAPI documentation
tags: api, FastAPI, status-code, HTTP, semantics
---

## Use Explicit HTTP Status Codes

Always specify the correct HTTP status code for each endpoint. Use `status_code` parameter and `status.HTTP_*` constants. Don't rely on FastAPI's default 200 for all responses.

**Incorrect (default 200 for everything):**

```python
@router.post("/documents")
async def create_document(request: CreateDocumentRequest) -> DocumentResponse:
    doc = await service.create(request)
    return DocumentResponse.model_validate(doc)  # Returns 200, should be 201


@router.delete("/documents/{doc_id}")
async def delete_document(doc_id: str) -> dict:
    await service.delete(doc_id)
    return {"message": "deleted"}  # Returns 200 with body, should be 204
```

**Correct (explicit status codes):**

```python
from starlette import status


@router.post(
    "/documents",
    status_code=status.HTTP_201_CREATED,
)
async def create_document(request: CreateDocumentRequest) -> DocumentResponse:
    doc = await service.create(request)
    return DocumentResponse.model_validate(doc)


@router.delete(
    "/documents/{doc_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
async def delete_document(doc_id: str) -> None:
    await service.delete(doc_id)


@router.post(
    "/documents/{doc_id}/process",
    status_code=status.HTTP_202_ACCEPTED,
)
async def process_document(doc_id: str) -> JobResponse:
    job = await service.start_processing(doc_id)
    return JobResponse.model_validate(job)
```

Common status codes: `201` (created), `202` (accepted/async), `204` (no content), `404` (not found), `409` (conflict), `422` (validation error).
