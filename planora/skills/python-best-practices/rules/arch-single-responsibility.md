---
title: One Module, One Responsibility
impact: HIGH
impactDescription: reduces coupling, enables independent changes
tags: architecture, SRP, module, responsibility, cohesion
---

## One Module, One Responsibility

Each module should have one clear responsibility. When a module handles multiple unrelated concerns, it becomes hard to understand, test, and modify without side effects.

**Incorrect (module doing too many things):**

```python
# services/document_service.py — does everything
class DocumentService:
    async def create_document(self, doc: CreateDocumentRequest) -> Document:
        # Validation logic
        if not doc.title:
            raise ValidationError("Title required")
        # Database logic
        db_doc = DocumentModel(title=doc.title, content=doc.content)
        self.session.add(db_doc)
        await self.session.commit()
        # Notification logic
        await self.email_client.send(doc.owner, "Document created")
        # Metrics logic
        self.metrics.increment("documents_created")
        # Cache logic
        await self.cache.set(f"doc:{db_doc.id}", db_doc)
        return Document.model_validate(db_doc)
```

**Correct (separated responsibilities):**

```python
# services/document_service.py — orchestration only
class DocumentService:
    def __init__(
        self,
        repository: DocumentRepository,
        notifier: DocumentNotifier,
        metrics: MetricsClient,
    ) -> None:
        self._repository = repository
        self._notifier = notifier
        self._metrics = metrics

    async def create_document(self, doc: CreateDocumentRequest) -> Document:
        document = await self._repository.create(doc)
        await self._notifier.on_created(document)
        self._metrics.increment("documents_created")
        return document


# repositories/document_repository.py — data access only
class DocumentRepository:
    async def create(self, doc: CreateDocumentRequest) -> Document: ...
```
