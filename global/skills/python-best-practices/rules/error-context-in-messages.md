---
title: Include Context in Error Messages
impact: HIGH
impactDescription: enables faster debugging without reproducing the issue
tags: error, messages, context, debugging, diagnostics
---

## Include Context in Error Messages

Always include relevant context (IDs, values, states) in error messages. A message like "Not found" is useless for debugging — include what was not found, where it was looked for, and what was searched.

**Incorrect (vague error messages):**

```python
def get_namespace(namespace_id: str) -> Namespace:
    result = db.query(Namespace).filter_by(id=namespace_id).first()
    if not result:
        raise NamespaceNotFoundError("Namespace not found")


def validate_document(doc: Document) -> None:
    if doc.size > MAX_SIZE:
        raise ValidationError("Document too large")
    if doc.format not in SUPPORTED_FORMATS:
        raise ValidationError("Unsupported format")
```

**Correct (context-rich error messages):**

```python
def get_namespace(namespace_id: str) -> Namespace:
    result = db.query(Namespace).filter_by(id=namespace_id).first()
    if not result:
        raise NamespaceNotFoundError(
            f"Namespace with id={namespace_id!r} not found"
        )


def validate_document(doc: Document) -> None:
    if doc.size > MAX_SIZE:
        raise ValidationError(
            f"Document {doc.id!r} size {doc.size} exceeds maximum {MAX_SIZE}"
        )
    if doc.format not in SUPPORTED_FORMATS:
        raise ValidationError(
            f"Document {doc.id!r} format {doc.format!r} not in {SUPPORTED_FORMATS}"
        )
```
