---
title: Use Specific Assertions
impact: MEDIUM-HIGH
impactDescription: better failure messages, catches exact failure modes
tags: test, assertions, specific, pytest, failure-messages
---

## Use Specific Assertions

Use specific assertions (`assert x == y`, `assert x in collection`) instead of bare `assert x` or truthiness checks. Specific assertions produce better failure messages and catch the exact failure mode.

**Incorrect (vague assertions):**

```python
def test_fetch_documents() -> None:
    docs = fetch_documents(namespace_id="ns-1")
    assert docs  # Only checks truthiness — fails with "assert []"
    assert len(docs)  # Same problem — "assert 0"
    assert docs[0].title  # Only checks non-empty — no expected value


def test_create_user() -> None:
    user = create_user(name="Alice", email="alice@example.com")
    assert user  # Just checks it's not None
    assert user.name  # Doesn't verify the actual name
```

**Correct (specific assertions):**

```python
def test_fetch_documents() -> None:
    docs = fetch_documents(namespace_id="ns-1")
    assert len(docs) == 3
    assert docs[0].title == "Getting Started"
    assert all(doc.namespace_id == "ns-1" for doc in docs)


def test_create_user() -> None:
    user = create_user(name="Alice", email="alice@example.com")
    assert user.name == "Alice"
    assert user.email == "alice@example.com"
    assert user.id is not None
```

For exception testing, use `pytest.raises` with `match`:

```python
def test_invalid_namespace_raises() -> None:
    with pytest.raises(NamespaceNotFoundError, match="ns-999"):
        fetch_documents(namespace_id="ns-999")
```
