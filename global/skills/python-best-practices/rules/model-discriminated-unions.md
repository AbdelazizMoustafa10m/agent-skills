---
title: Use Discriminated Unions for Polymorphism
impact: MEDIUM-HIGH
impactDescription: type-safe deserialization, better error messages
tags: model, Pydantic, union, discriminator, polymorphism
---

## Use Discriminated Unions for Polymorphism

When a field can be one of several model types, use discriminated unions with a literal type field. This provides fast, unambiguous deserialization and clear error messages.

**Incorrect (plain Union, ambiguous):**

```python
class EmailNotification(BaseModel):
    recipient: str
    subject: str
    body: str


class SlackNotification(BaseModel):
    channel: str
    body: str  # Overlapping field names — Pydantic can't distinguish


class NotificationRequest(BaseModel):
    notification: EmailNotification | SlackNotification  # Ambiguous union
```

**Correct (discriminated union):**

```python
from typing import Annotated, Literal
from pydantic import Discriminator, Tag


class EmailNotification(BaseModel):
    type: Literal["email"] = "email"
    recipient: str
    subject: str
    body: str


class SlackNotification(BaseModel):
    type: Literal["slack"] = "slack"
    channel: str
    body: str


class NotificationRequest(BaseModel):
    notification: Annotated[
        EmailNotification | SlackNotification,
        Discriminator("type"),
    ]


# Clean deserialization
request = NotificationRequest.model_validate({
    "notification": {"type": "email", "recipient": "user@example.com", "subject": "Hi", "body": "Hello"}
})
assert isinstance(request.notification, EmailNotification)
```

Reference: [Pydantic discriminated unions](https://docs.pydantic.dev/latest/concepts/unions/#discriminated-unions)
