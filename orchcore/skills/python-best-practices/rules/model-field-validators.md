---
title: Use field_validator Over root_validator
impact: MEDIUM
impactDescription: clearer validation, better error messages per field
tags: model, Pydantic, validator, field-validator, validation
---

## Use field_validator Over root_validator

Use `@field_validator` for field-specific validation and `@model_validator` only when validation requires multiple fields. This produces clearer error messages tied to specific fields.

**Incorrect (root_validator for single-field logic):**

```python
from pydantic import model_validator


class UserCreate(BaseModel):
    name: str
    email: str
    age: int

    @model_validator(mode="after")
    def validate_fields(self) -> "UserCreate":
        if not self.name.strip():
            raise ValueError("Name cannot be blank")
        if "@" not in self.email:
            raise ValueError("Invalid email")
        if self.age < 0:
            raise ValueError("Age must be positive")
        return self
```

**Correct (field_validator for per-field logic):**

```python
from pydantic import field_validator


class UserCreate(BaseModel):
    name: str
    email: str
    age: int

    @field_validator("name")
    @classmethod
    def name_must_not_be_blank(cls, v: str) -> str:
        if not v.strip():
            raise ValueError("Name cannot be blank")
        return v.strip()

    @field_validator("email")
    @classmethod
    def email_must_be_valid(cls, v: str) -> str:
        if "@" not in v:
            raise ValueError("Invalid email format")
        return v.lower()

    @field_validator("age")
    @classmethod
    def age_must_be_positive(cls, v: int) -> int:
        if v < 0:
            raise ValueError("Age must be non-negative")
        return v
```

Use `@model_validator` only when cross-field validation is needed:

```python
    @model_validator(mode="after")
    def end_date_after_start(self) -> "DateRange":
        if self.end_date <= self.start_date:
            raise ValueError("end_date must be after start_date")
        return self
```

Reference: [Pydantic validators](https://docs.pydantic.dev/latest/concepts/validators/)
