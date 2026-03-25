---
title: Use Factory Functions for Test Data
impact: MEDIUM-HIGH
impactDescription: reduces test setup noise, makes test intent clear
tags: test, factory, fixtures, test-data, builder-pattern
---

## Use Factory Functions for Test Data

Create factory functions that produce test objects with sensible defaults. Tests only specify the fields relevant to the test case, making test intent immediately clear.

**Incorrect (full object construction in every test):**

```python
def test_document_title_validation() -> None:
    doc = Document(
        id="test-1",
        title="",  # This is what we're testing
        content="Some content",
        format=DocumentFormat.PDF,
        namespace_id="ns-1",
        created_at=datetime(2024, 1, 1),
        updated_at=datetime(2024, 1, 1),
        owner_id="user-1",
        chunk_count=0,
        status=DocumentStatus.PENDING,
    )
    with pytest.raises(ValidationError):
        validate_document(doc)


def test_document_content_validation() -> None:
    doc = Document(
        id="test-2",
        title="Valid Title",
        content="",  # This is what we're testing
        format=DocumentFormat.PDF,
        namespace_id="ns-1",
        created_at=datetime(2024, 1, 1),
        updated_at=datetime(2024, 1, 1),
        owner_id="user-1",
        chunk_count=0,
        status=DocumentStatus.PENDING,
    )
    with pytest.raises(ValidationError):
        validate_document(doc)
```

**Correct (factory function with defaults):**

```python
def make_document(**overrides: Any) -> Document:
    defaults = {
        "id": f"test-{uuid4().hex[:8]}",
        "title": "Test Document",
        "content": "Default test content",
        "format": DocumentFormat.PDF,
        "namespace_id": "ns-1",
        "created_at": datetime(2024, 1, 1),
        "updated_at": datetime(2024, 1, 1),
        "owner_id": "user-1",
        "chunk_count": 0,
        "status": DocumentStatus.PENDING,
    }
    return Document(**(defaults | overrides))


def test_document_title_validation() -> None:
    doc = make_document(title="")
    with pytest.raises(ValidationError):
        validate_document(doc)


def test_document_content_validation() -> None:
    doc = make_document(content="")
    with pytest.raises(ValidationError):
        validate_document(doc)
```
