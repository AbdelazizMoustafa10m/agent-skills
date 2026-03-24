---
title: Use Comprehensions for Simple Transformations
impact: MEDIUM-HIGH
impactDescription: reduces boilerplate, more idiomatic and readable
tags: style, comprehension, list, dict, loop, transformation
---

## Use Comprehensions for Simple Transformations

Use list, dict, and set comprehensions for simple mapping and filtering operations instead of manual loops with append/add. Comprehensions are more Pythonic, often faster, and clearly express intent.

**Incorrect (manual loop for simple transformation):**

```python
def get_active_user_emails(users: list[User]) -> list[str]:
    emails = []
    for user in users:
        if user.is_active:
            emails.append(user.email)
    return emails


def build_lookup(items: list[Item]) -> dict[str, Item]:
    lookup = {}
    for item in items:
        lookup[item.id] = item
    return lookup
```

**Correct (comprehension):**

```python
def get_active_user_emails(users: list[User]) -> list[str]:
    return [user.email for user in users if user.is_active]


def build_lookup(items: list[Item]) -> dict[str, Item]:
    return {item.id: item for item in items}
```

Do not use comprehensions for complex logic with side effects or multiple statements — use a loop instead.
