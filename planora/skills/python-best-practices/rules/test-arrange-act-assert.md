---
title: Structure Tests with Arrange-Act-Assert
impact: MEDIUM
impactDescription: consistent structure improves readability and maintenance
tags: test, AAA, arrange, act, assert, structure, readability
---

## Structure Tests with Arrange-Act-Assert

Structure every test with three clear phases: **Arrange** (set up preconditions), **Act** (execute the behavior under test), and **Assert** (verify the outcome). Separate phases with blank lines.

**Incorrect (phases mixed together):**

```python
def test_document_ingestion(db: Database) -> None:
    service = IngestionService(db)
    doc = Document(id="test-1", content="hello", format=DocumentFormat.PDF)
    assert service.ingest(doc).status == IngestionStatus.COMPLETED
    assert db.get(Document, "test-1") is not None
    assert db.get(Document, "test-1").chunk_count > 0
    service2 = IngestionService(db)
    assert service2.get_status("test-1") == IngestionStatus.COMPLETED
```

**Correct (clear AAA structure):**

```python
def test_document_ingestion(db: Database) -> None:
    # Arrange
    service = IngestionService(db)
    doc = Document(id="test-1", content="hello", format=DocumentFormat.PDF)

    # Act
    result = service.ingest(doc)

    # Assert
    assert result.status == IngestionStatus.COMPLETED
    stored_doc = db.get(Document, "test-1")
    assert stored_doc is not None
    assert stored_doc.chunk_count > 0
```

For async tests, the same structure applies:

```python
async def test_async_query(query_service: QueryService) -> None:
    # Arrange
    query = "What is vRAGmate?"

    # Act
    response = await query_service.execute(query, namespace_id="ns-1")

    # Assert
    assert response.answer is not None
    assert len(response.sources) > 0
```
