---
title: Always Define Response Models
impact: MEDIUM-HIGH
impactDescription: ensures consistent API contracts, enables auto-documentation
tags: api, FastAPI, response-model, OpenAPI, contract
---

## Always Define Response Models

Always specify `response_model` on FastAPI endpoints or use typed return annotations. This ensures consistent API responses, generates accurate OpenAPI documentation, and prevents accidentally leaking internal fields.

**Incorrect (no response model, leaks internal fields):**

```python
@router.get("/documents/{doc_id}")
async def get_document(doc_id: str, db: AsyncSession = Depends(get_session)):
    result = await db.execute(select(DocumentModel).where(DocumentModel.id == doc_id))
    doc = result.scalar_one_or_none()
    if not doc:
        raise HTTPException(status_code=404)
    return doc  # Leaks internal DB fields: _sa_instance_state, created_by, internal_flags
```

**Correct (explicit response model):**

```python
class DocumentResponse(BaseModel):
    id: str
    title: str
    format: DocumentFormat
    created_at: datetime
    namespace_id: str


@router.get("/documents/{doc_id}")
async def get_document(
    doc_id: str, db: AsyncSession = Depends(get_session)
) -> DocumentResponse:
    result = await db.execute(select(DocumentModel).where(DocumentModel.id == doc_id))
    doc = result.scalar_one_or_none()
    if not doc:
        raise HTTPException(status_code=404, detail=f"Document {doc_id!r} not found")
    return DocumentResponse(
        id=doc.id,
        title=doc.title,
        format=doc.format,
        created_at=doc.created_at,
        namespace_id=doc.namespace_id,
    )
```

Reference: [FastAPI Response Model](https://fastapi.tiangolo.com/tutorial/response-model/)
