---
title: Use Frozen Models for Immutable Data
impact: MEDIUM-HIGH
impactDescription: prevents accidental mutation, enables hashing and caching
tags: model, Pydantic, frozen, immutable, safety
---

## Use Frozen Models for Immutable Data

Use `model_config = ConfigDict(frozen=True)` for data objects that should not be mutated after creation. This prevents accidental modification, enables hashing, and makes models safe for use as dict keys or set members.

**Incorrect (mutable model leads to bugs):**

```python
class QueryResult(BaseModel):
    query: str
    answer: str
    sources: list[str]
    score: float


# Bug: accidental mutation
result = QueryResult(query="test", answer="response", sources=["doc1"], score=0.95)
result.score = 0.0  # Silently mutates — might corrupt cached results
```

**Correct (frozen model):**

```python
from pydantic import ConfigDict


class QueryResult(BaseModel):
    model_config = ConfigDict(frozen=True)

    query: str
    answer: str
    sources: list[str]
    score: float


result = QueryResult(query="test", answer="response", sources=["doc1"], score=0.95)
result.score = 0.0  # ValidationError: Instance is frozen

# Use model_copy for modifications
updated = result.model_copy(update={"score": 0.8})
```

Reference: [Pydantic frozen models](https://docs.pydantic.dev/latest/concepts/config/#frozen)
