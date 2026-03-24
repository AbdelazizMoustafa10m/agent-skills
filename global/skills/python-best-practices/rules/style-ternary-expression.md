---
title: Use Conditional Expressions for Simple Assignments
impact: MEDIUM
impactDescription: reduces 4 lines to 1, improves scannability
tags: style, ternary, conditional, assignment, simplification
---

## Use Conditional Expressions for Simple Assignments

Use Python's conditional expression (`x if condition else y`) for simple value assignments instead of full if/else blocks. This makes the assignment nature of the code immediately clear.

**Incorrect (full if/else block for simple assignment):**

```python
def get_display_name(user: User) -> str:
    if user.nickname:
        name = user.nickname
    else:
        name = user.full_name
    return name


def get_timeout(is_retry: bool) -> float:
    if is_retry:
        timeout = 30.0
    else:
        timeout = 10.0
    return timeout
```

**Correct (conditional expression):**

```python
def get_display_name(user: User) -> str:
    return user.nickname if user.nickname else user.full_name


def get_timeout(is_retry: bool) -> float:
    return 30.0 if is_retry else 10.0
```

Do not use conditional expressions for complex logic or when readability suffers. If the expression exceeds ~80 characters, prefer an if/else block.
