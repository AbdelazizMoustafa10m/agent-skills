---
title: Use Router Factory Pattern
impact: MEDIUM-HIGH
impactDescription: enables dependency injection, testable route configuration
tags: api, FastAPI, router, factory, modularity, testing
---

## Use Router Factory Pattern

Create routers via factory functions that accept dependencies as parameters. This enables testing with different configurations and keeps the dependency graph explicit.

**Incorrect (module-level router with implicit dependencies):**

```python
# routers/documents.py
from app.services import document_service  # Implicit global dependency

router = APIRouter(prefix="/documents")


@router.get("/{doc_id}")
async def get_document(doc_id: str) -> DocumentResponse:
    doc = await document_service.get(doc_id)  # Hard to test
    return DocumentResponse.model_validate(doc)
```

**Correct (router factory):**

```python
# routers/documents.py
def create_document_router(service: DocumentService) -> APIRouter:
    router = APIRouter(prefix="/documents")

    @router.get("/{doc_id}")
    async def get_document(doc_id: str) -> DocumentResponse:
        doc = await service.get(doc_id)
        return DocumentResponse.model_validate(doc)

    @router.get("/")
    async def list_documents(namespace_id: str) -> list[DocumentResponse]:
        docs = await service.list(namespace_id)
        return [DocumentResponse.model_validate(d) for d in docs]

    return router


# app.py
def get_app() -> FastAPI:
    app = FastAPI()
    document_service = DocumentService(...)
    app.include_router(create_document_router(document_service))
    return app
```

In tests:

```python
def test_get_document():
    fake_service = FakeDocumentService()
    router = create_document_router(fake_service)
    app = FastAPI()
    app.include_router(router)
    client = TestClient(app)
    response = client.get("/documents/test-1")
    assert response.status_code == 200
```
