---
title: Prevent Circular Import Dependencies
impact: HIGH
impactDescription: prevents ImportError at runtime, clarifies dependency graph
tags: architecture, circular, imports, dependencies, refactoring
---

## Prevent Circular Import Dependencies

Circular imports indicate tangled responsibilities. Resolve them by extracting shared types into a separate module, using dependency inversion, or restructuring the dependency graph.

**Incorrect (circular dependency):**

```python
# user_service.py
from document_service import DocumentService  # Imports document_service

class UserService:
    def __init__(self, doc_service: DocumentService) -> None:
        self._doc_service = doc_service

    async def delete_user(self, user_id: str) -> None:
        await self._doc_service.delete_user_documents(user_id)


# document_service.py
from user_service import UserService  # Circular! Imports user_service

class DocumentService:
    def __init__(self, user_service: UserService) -> None:
        self._user_service = user_service

    async def get_owner(self, doc_id: str) -> User:
        doc = await self._get_doc(doc_id)
        return await self._user_service.get_user(doc.owner_id)
```

**Correct (break cycle with Protocol):**

```python
# protocols.py — shared interface, no circular dependency
from typing import Protocol

class DocumentDeleter(Protocol):
    async def delete_user_documents(self, user_id: str) -> None: ...

class UserLookup(Protocol):
    async def get_user(self, user_id: str) -> User: ...


# user_service.py
class UserService:
    def __init__(self, doc_deleter: DocumentDeleter) -> None:
        self._doc_deleter = doc_deleter

    async def delete_user(self, user_id: str) -> None:
        await self._doc_deleter.delete_user_documents(user_id)


# document_service.py
class DocumentService:
    def __init__(self, user_lookup: UserLookup) -> None:
        self._user_lookup = user_lookup
```
