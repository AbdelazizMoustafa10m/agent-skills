---
title: Use Early Returns to Reduce Nesting
impact: CRITICAL
impactDescription: eliminates deeply nested code, improves readability
tags: style, early-return, nesting, readability, control-flow
---

## Use Early Returns to Reduce Nesting

Return early when preconditions fail or results are determined, rather than wrapping logic in deeply nested if/else blocks. This reduces indentation levels and makes the main logic path immediately visible.

**Incorrect (deeply nested with late return):**

```python
def process_document(document: Document | None, user: User) -> ProcessingResult:
    if document is not None:
        if user.has_permission("read"):
            if document.status == DocumentStatus.READY:
                content = document.extract_content()
                if content:
                    result = transform(content)
                    return ProcessingResult(data=result, status="success")
                else:
                    return ProcessingResult(data=None, status="empty")
            else:
                return ProcessingResult(data=None, status="not_ready")
        else:
            return ProcessingResult(data=None, status="forbidden")
    else:
        return ProcessingResult(data=None, status="not_found")
```

**Correct (early returns, flat structure):**

```python
def process_document(document: Document | None, user: User) -> ProcessingResult:
    if document is None:
        return ProcessingResult(data=None, status="not_found")

    if not user.has_permission("read"):
        return ProcessingResult(data=None, status="forbidden")

    if document.status != DocumentStatus.READY:
        return ProcessingResult(data=None, status="not_ready")

    content = document.extract_content()
    if not content:
        return ProcessingResult(data=None, status="empty")

    result = transform(content)
    return ProcessingResult(data=result, status="success")
```

Reference: [PEP 8 - Programming Recommendations](https://peps.python.org/pep-0008/#programming-recommendations)
