---
title: Ensure Test Independence and Isolation
impact: HIGH
impactDescription: prevents flaky tests and hidden inter-test dependencies
tags: test, isolation, independence, fixtures, flaky, state
---

## Ensure Test Independence and Isolation

Every test must be independent -- it should pass regardless of execution order and should not depend on state left by other tests. Use fixtures for setup, and clean up after each test.

**Incorrect (tests depend on shared mutable state):**

```python
# Module-level mutable state — tests affect each other
_documents: list[Document] = []


def test_add_document() -> None:
    _documents.append(Document(id="1", title="Test"))
    assert len(_documents) == 1


def test_list_documents() -> None:
    # Depends on test_add_document running first!
    assert len(_documents) == 1
    assert _documents[0].title == "Test"


def test_clear_documents() -> None:
    _documents.clear()
    assert len(_documents) == 0
    # Now test_list_documents fails if run after this
```

**Correct (each test is self-contained):**

```python
@pytest.fixture
def document_store() -> DocumentStore:
    """Fresh store for each test."""
    return InMemoryDocumentStore()


def test_add_document(document_store: DocumentStore) -> None:
    document_store.add(Document(id="1", title="Test"))
    assert document_store.count() == 1


def test_list_documents(document_store: DocumentStore) -> None:
    document_store.add(Document(id="1", title="First"))
    document_store.add(Document(id="2", title="Second"))
    assert document_store.count() == 2


def test_empty_store(document_store: DocumentStore) -> None:
    assert document_store.count() == 0  # Always passes — fresh fixture
```

For database tests, use transactions that roll back:

```python
@pytest.fixture
async def db_session(engine: AsyncEngine) -> AsyncGenerator[AsyncSession, None]:
    async with engine.connect() as conn:
        transaction = await conn.begin()
        session = AsyncSession(bind=conn)
        yield session
        await transaction.rollback()
```
