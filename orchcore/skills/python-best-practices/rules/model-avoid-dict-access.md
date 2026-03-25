---
title: Use Model Attributes, Not Dict Access
impact: MEDIUM
impactDescription: enables type checking and IDE autocompletion
tags: model, Pydantic, attributes, dict-access, type-safety
---

## Use Model Attributes, Not Dict Access

Access Pydantic model data via attribute access (`model.field`), not dict-style access (`model["field"]` or `model.dict()["field"]`). Attribute access is type-checked and provides IDE autocompletion.

**Incorrect (dict-style access on models):**

```python
def process_document(doc: Document) -> str:
    data = doc.model_dump()
    title = data["title"]  # No type checking
    namespace = data.get("namespace_id", "default")  # Returns Any
    return f"{namespace}/{title}"


def summarize_results(results: list[QueryResult]) -> list[str]:
    return [r.__dict__["answer"] for r in results]  # Fragile, untyped
```

**Correct (attribute access):**

```python
def process_document(doc: Document) -> str:
    title = doc.title  # Type-checked as str
    namespace = doc.namespace_id  # Type-checked, IDE autocompletes
    return f"{namespace}/{title}"


def summarize_results(results: list[QueryResult]) -> list[str]:
    return [r.answer for r in results]  # Type-checked, clean
```

Use `model_dump()` only at serialization boundaries (API responses, database writes):

```python
@router.get("/documents/{doc_id}")
async def get_document(doc_id: str) -> dict[str, Any]:
    doc = await service.get(doc_id)
    return doc.model_dump()  # Serialization boundary — appropriate
```
