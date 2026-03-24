---
title: Use Explicit Domain-to-HTTP Error Mapping
impact: HIGH
impactDescription: Keeps API behavior predictable and client handling reliable.
tags: error, fastapi, api-design
---

## Use Explicit Domain-to-HTTP Error Mapping

Map known domain exceptions to explicit status codes instead of generic 500 handlers.

**Incorrect python code:**

```python
@router.get("/namespaces/{namespace_id}")
async def get_namespace(namespace_id: str) -> NamespaceResponse:
    namespace = await service.get_namespace(namespace_id)
    return NamespaceResponse.model_validate(namespace)
```

**Correct python code:**

```python
@router.get("/namespaces/{namespace_id}")
async def get_namespace(namespace_id: str) -> NamespaceResponse:
    try:
        namespace = await service.get_namespace(namespace_id)
    except NamespaceNotFoundError as exc:
        raise HTTPException(status_code=404, detail="namespace not found") from exc
    except NamespacePermissionError as exc:
        raise HTTPException(status_code=403, detail="forbidden") from exc
    return NamespaceResponse.model_validate(namespace)
```

Reference: [FastAPI - Handling Errors](https://fastapi.tiangolo.com/tutorial/handling-errors/)

