---
title: Use Fixtures Instead of setUp/tearDown
impact: HIGH
impactDescription: composable, explicit dependencies, better isolation
tags: test, fixtures, setup, teardown, pytest, composition
---

## Use Fixtures Instead of setUp/tearDown

Use pytest fixtures instead of `setUp`/`tearDown` methods. Fixtures are composable, have explicit dependency declaration, support multiple scopes, and can be shared across test modules.

**Incorrect (setUp/tearDown pattern):**

```python
class TestDocumentService(unittest.TestCase):
    def setUp(self):
        self.db = create_test_database()
        self.service = DocumentService(self.db)
        self.test_doc = Document(id="test-1", content="hello")
        self.db.save(self.test_doc)

    def tearDown(self):
        self.db.clear()
        self.db.close()

    def test_get_document(self):
        result = self.service.get("test-1")
        assert result == self.test_doc

    def test_delete_document(self):
        self.service.delete("test-1")
        assert self.service.get("test-1") is None
```

**Correct (pytest fixtures):**

```python
@pytest.fixture
def db():
    database = create_test_database()
    yield database
    database.clear()
    database.close()


@pytest.fixture
def document_service(db: Database) -> DocumentService:
    return DocumentService(db)


@pytest.fixture
def sample_document(db: Database) -> Document:
    doc = Document(id="test-1", content="hello")
    db.save(doc)
    return doc


def test_get_document(
    document_service: DocumentService, sample_document: Document
) -> None:
    result = document_service.get("test-1")
    assert result == sample_document


def test_delete_document(
    document_service: DocumentService, sample_document: Document
) -> None:
    document_service.delete("test-1")
    assert document_service.get("test-1") is None
```

Reference: [pytest fixtures](https://docs.pytest.org/en/stable/how-to/fixtures.html)
