---
title: Mock at Boundaries, Not Internals
impact: HIGH
impactDescription: tests remain valid during refactoring, catch real integration bugs
tags: test, mock, boundaries, integration, refactoring
---

## Mock at Boundaries, Not Internals

Mock external dependencies (HTTP clients, databases, message queues) at the boundary, not internal implementation details. Tests that mock internals break during refactoring even when behavior is preserved.

**Incorrect (mocking internal implementation):**

```python
def test_process_document(mocker: MockerFixture) -> None:
    # Mocking private methods — breaks if implementation changes
    mocker.patch.object(DocumentProcessor, "_extract_text", return_value="content")
    mocker.patch.object(DocumentProcessor, "_split_chunks", return_value=["chunk1"])
    mocker.patch.object(DocumentProcessor, "_embed_chunks", return_value=[[0.1, 0.2]])

    processor = DocumentProcessor()
    result = processor.process(Document(content=b"pdf-bytes"))
    assert result.chunks == ["chunk1"]
```

**Correct (mocking at boundaries):**

```python
def test_process_document(
    mock_embedding_client: Mock, mock_db: Mock
) -> None:
    # Mock the external service boundary
    mock_embedding_client.embed.return_value = [[0.1, 0.2, 0.3]]

    processor = DocumentProcessor(
        embedding_client=mock_embedding_client,
        db=mock_db,
    )
    result = processor.process(Document(content=b"pdf-bytes"))

    assert len(result.chunks) > 0
    mock_embedding_client.embed.assert_called_once()
    mock_db.store_chunks.assert_called_once()
```

Better yet, use fakes or in-memory implementations for unit tests:

```python
def test_process_document() -> None:
    processor = DocumentProcessor(
        embedding_client=FakeEmbeddingClient(),
        db=InMemoryChunkStore(),
    )
    result = processor.process(Document(content=b"pdf-bytes"))
    assert len(result.chunks) > 0
```
