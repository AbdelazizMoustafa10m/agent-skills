---
title: Extract Repeated Code into Helper Functions
impact: CRITICAL
impactDescription: eliminates copy-paste bugs, centralizes logic changes
tags: style, DRY, duplication, refactoring, helper-function
---

## Extract Repeated Code into Helper Functions

When the same logic appears in multiple places, extract it into a shared helper function. This prevents copy-paste bugs and ensures changes only need to happen in one place.

**Incorrect (duplicated validation logic):**

```python
class UserRouter:
    async def create_user(self, request: CreateUserRequest) -> User:
        if not request.email or "@" not in request.email:
            raise HTTPException(status_code=422, detail="Invalid email")
        if len(request.name) < 2:
            raise HTTPException(status_code=422, detail="Name too short")
        # ... create logic

    async def update_user(self, user_id: str, request: UpdateUserRequest) -> User:
        if not request.email or "@" not in request.email:
            raise HTTPException(status_code=422, detail="Invalid email")
        if len(request.name) < 2:
            raise HTTPException(status_code=422, detail="Name too short")
        # ... update logic
```

**Correct (extracted helper):**

```python
def _validate_user_fields(email: str, name: str) -> None:
    if not email or "@" not in email:
        raise HTTPException(status_code=422, detail="Invalid email")
    if len(name) < 2:
        raise HTTPException(status_code=422, detail="Name too short")


class UserRouter:
    async def create_user(self, request: CreateUserRequest) -> User:
        _validate_user_fields(request.email, request.name)
        # ... create logic

    async def update_user(self, user_id: str, request: UpdateUserRequest) -> User:
        _validate_user_fields(request.email, request.name)
        # ... update logic
```
