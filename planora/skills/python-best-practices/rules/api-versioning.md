---
title: Version APIs Explicitly
impact: MEDIUM
impactDescription: enables breaking changes without disrupting existing clients
tags: api, versioning, backward-compatibility, migration, headers
---

## Version APIs Explicitly

Version your APIs from the start to enable non-breaking evolution. Use URL path prefixes, headers, or a combination. Define a clear strategy and apply it consistently.

**Incorrect (no versioning, breaking changes affect all clients):**

```python
# No version — any change breaks all clients
@router.get("/documents/{doc_id}")
async def get_document(doc_id: str) -> DocumentResponse:
    ...

# Later, changing the response shape breaks existing clients
@router.get("/documents/{doc_id}")
async def get_document(doc_id: str) -> DocumentResponseV2:  # Breaks clients expecting V1
    ...
```

**Correct (versioned API):**

```python
# Version via URL prefix
v1_router = APIRouter(prefix="/v1")
v2_router = APIRouter(prefix="/v2")


@v1_router.get("/documents/{doc_id}")
async def get_document_v1(doc_id: str) -> DocumentResponseV1:
    doc = await service.get(doc_id)
    return DocumentResponseV1.model_validate(doc)


@v2_router.get("/documents/{doc_id}")
async def get_document_v2(doc_id: str) -> DocumentResponseV2:
    doc = await service.get(doc_id)
    return DocumentResponseV2.model_validate(doc)


# Or version via header (vRAGmate pattern)
@router.get("/documents/{doc_id}")
async def get_document(
    doc_id: str,
    api_version: str = Header(default="1.0", alias="X-API-Version"),
) -> DocumentResponseV1 | DocumentResponseV2:
    doc = await service.get(doc_id)
    if api_version.startswith("2"):
        return DocumentResponseV2.model_validate(doc)
    return DocumentResponseV1.model_validate(doc)
```

Reference: [FastAPI Bigger Applications](https://fastapi.tiangolo.com/tutorial/bigger-applications/)
