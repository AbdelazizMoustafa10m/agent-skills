---
title: Define Custom Exception Hierarchies
impact: MEDIUM-HIGH
impactDescription: enables precise error handling per domain
tags: error, custom-exceptions, hierarchy, domain, exception-classes
---

## Define Custom Exception Hierarchies

Define custom exception classes that form a hierarchy for your domain. This enables callers to catch at the right level of granularity — a specific error, a category of errors, or all domain errors.

**Incorrect (using built-in exceptions for domain errors):**

```python
def ingest_document(doc: Document) -> None:
    if not doc.content:
        raise ValueError("Empty document")  # Indistinguishable from other ValueErrors
    if doc.format not in SUPPORTED_FORMATS:
        raise TypeError("Bad format")  # Misleading exception type
    if not has_quota(doc.namespace_id):
        raise RuntimeError("Quota exceeded")  # Too generic
```

**Correct (custom exception hierarchy):**

```python
class VRAGmateError(Exception):
    """Base exception for all domain errors."""


class IngestionError(VRAGmateError):
    """Base for ingestion-related errors."""


class EmptyDocumentError(IngestionError):
    """Document has no extractable content."""


class UnsupportedFormatError(IngestionError):
    """Document format is not supported."""


class QuotaExceededError(VRAGmateError):
    """Resource quota has been exceeded."""


def ingest_document(doc: Document) -> None:
    if not doc.content:
        raise EmptyDocumentError(f"Document {doc.id!r} has no content")
    if doc.format not in SUPPORTED_FORMATS:
        raise UnsupportedFormatError(
            f"Format {doc.format!r} not in {SUPPORTED_FORMATS}"
        )
    if not has_quota(doc.namespace_id):
        raise QuotaExceededError(
            f"Namespace {doc.namespace_id!r} has exceeded its quota"
        )
```

Callers can now catch at the desired level:

```python
try:
    ingest_document(doc)
except IngestionError:
    # Handle any ingestion error
except VRAGmateError:
    # Handle any domain error
```
