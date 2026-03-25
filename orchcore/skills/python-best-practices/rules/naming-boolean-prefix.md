---
title: Prefix Booleans with is/has/should/can
impact: MEDIUM
impactDescription: makes boolean intent immediately clear at call sites
tags: naming, boolean, prefix, readability, convention
---

## Prefix Booleans with is/has/should/can

Name boolean variables and functions with prefixes that make their true/false nature immediately clear: `is_`, `has_`, `should_`, `can_`, `was_`, `needs_`.

**Incorrect (ambiguous boolean names):**

```python
class Document(BaseModel):
    active: bool  # Active what? Is it active? Was it active?
    error: bool  # Is this an error flag or error presence?
    ready: bool
    public: bool


def check_permission(user: User, resource: str) -> bool:
    ...  # Does it check or does it return permission status?


def validate(doc: Document) -> bool:
    ...  # Does it validate or return validation status?
```

**Correct (clear boolean prefixes):**

```python
class Document(BaseModel):
    is_active: bool
    has_error: bool
    is_ready: bool
    is_public: bool


def has_permission(user: User, resource: str) -> bool:
    ...


def is_valid(doc: Document) -> bool:
    ...


# In function calls, the intent is immediately clear
if document.is_active and not document.has_error:
    if has_permission(user, document.id):
        process(document)
```
