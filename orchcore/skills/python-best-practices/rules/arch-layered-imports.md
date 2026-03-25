---
title: Respect Layer Boundaries in Imports
impact: MEDIUM-HIGH
impactDescription: prevents tight coupling between architectural layers
tags: architecture, layers, imports, boundaries, coupling
---

## Respect Layer Boundaries in Imports

Maintain clear import direction: routers -> services -> repositories -> models. Inner layers should never import from outer layers. This ensures each layer can be tested and changed independently.

**Incorrect (import direction violated):**

```python
# repositories/document_repo.py — importing from router layer!
from routers.document_router import DocumentResponse  # Wrong direction

class DocumentRepository:
    async def get(self, doc_id: str) -> DocumentResponse:  # Returns router-level type
        row = await self.session.execute(...)
        return DocumentResponse(id=row.id, title=row.title)


# services/user_service.py — importing from another service's internals
from services.notification_service import _format_email  # Private internal
```

**Correct (clean layer boundaries):**

```python
# models/document.py — shared domain types
class Document(BaseModel):
    id: str
    title: str
    content: str


# repositories/document_repo.py — returns domain types
class DocumentRepository:
    async def get(self, doc_id: str) -> Document:
        row = await self.session.execute(...)
        return Document(id=row.id, title=row.title, content=row.content)


# routers/document_router.py — converts to response types
class DocumentResponse(BaseModel):
    id: str
    title: str

@router.get("/documents/{doc_id}")
async def get_document(doc_id: str, repo: DocumentRepository = Depends()) -> DocumentResponse:
    doc = await repo.get(doc_id)
    return DocumentResponse(id=doc.id, title=doc.title)
```
