---
title: Use Walrus Operator to Avoid Redundant Computation
impact: LOW-MEDIUM
impactDescription: avoids duplicate function calls and improves clarity
tags: style, walrus, assignment-expression, PEP572, optimization
---

## Use Walrus Operator to Avoid Redundant Computation

Use the walrus operator (`:=`) when you need to both test and use a value. This eliminates duplicate function calls and makes the intent clearer.

**Incorrect (duplicate computation):**

```python
def process_response(response: httpx.Response) -> dict[str, Any]:
    if response.json().get("data"):
        return transform(response.json().get("data"))
    return {}


def find_match(text: str, patterns: list[re.Pattern[str]]) -> str | None:
    for pattern in patterns:
        if pattern.search(text):
            return pattern.search(text).group()
    return None
```

**Correct (walrus operator):**

```python
def process_response(response: httpx.Response) -> dict[str, Any]:
    if data := response.json().get("data"):
        return transform(data)
    return {}


def find_match(text: str, patterns: list[re.Pattern[str]]) -> str | None:
    for pattern in patterns:
        if match := pattern.search(text):
            return match.group()
    return None
```

Use sparingly — only when it genuinely reduces duplication. Do not use in complex expressions where it hurts readability.

Reference: [PEP 572 - Assignment Expressions](https://peps.python.org/pep-0572/)
