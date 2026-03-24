---
title: Narrow Union Types Explicitly
impact: MEDIUM-HIGH
impactDescription: Removes ambiguous branches and prevents runtime attribute errors.
tags: typing, unions, isinstance
---

## Narrow Union Types Explicitly

Check concrete runtime type before accessing type-specific members.

**Incorrect python code:**

```python
def get_actor_id(actor: User | ServiceAccount) -> str:
    return actor.user_id
```

**Correct python code:**

```python
def get_actor_id(actor: User | ServiceAccount) -> str:
    if isinstance(actor, User):
        return actor.user_id
    return actor.service_account_id
```

Reference: [typing narrowing](https://typing.python.org/en/latest/guides/type_narrowing.html)

