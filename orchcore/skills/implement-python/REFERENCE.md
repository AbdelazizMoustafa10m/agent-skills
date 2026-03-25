# Python Production Patterns Reference

## Contents
- [Python 3.12+ Patterns](#python-312-patterns-current-standard)
- [Python 3.13+ Features](#python-313-features-when-available)
- [Design Principles](#design-principles) (with GOOD/BAD examples)
- [Testing Patterns](#testing-patterns)
- [Common Mistakes](#common-mistakes)
- [Code Smells → Solutions](#code-smells--solutions)
- [Self-Review Decision Tree](#self-review-decision-tree)

## Python 3.12+ Patterns (Current Standard)

### Type Hints
```python
# Native syntax (3.9+)
def process(items: list[str]) -> dict[str, int]: ...

# Union syntax (3.10+)
def find(id: int) -> User | None: ...

# Self type (3.11+)
from typing import Self
class Builder:
    def add(self, item: str) -> Self: ...
```

### Match Statements (3.10+)
```python
def handle_response(response: dict) -> str:
    match response:
        case {"status": "success", "data": data}:
            return f"Got: {data}"
        case {"status": "error", "message": msg}:
            return f"Error: {msg}"
        case _:
            raise ValueError("Unknown response format")
```

### Exception Groups (3.11+)
```python
def validate_all(items: list[str]) -> None:
    errors = []
    for i, item in enumerate(items):
        if not item.strip():
            errors.append(ValueError(f"Item {i} is empty"))
    if errors:
        raise ExceptionGroup("Validation failed", errors)
```

### TaskGroup (3.11+)
```python
import asyncio

async def fetch_all(urls: list[str]) -> list[bytes]:
    results = []
    async with asyncio.TaskGroup() as tg:
        for url in urls:
            tg.create_task(fetch_one(url, results))
    return results
```

## Python 3.13+ Features (When Available)

### TypeIs (Better Type Narrowing)
```python
from typing import TypeIs

def is_str_list(x: object) -> TypeIs[list[str]]:
    return isinstance(x, list) and all(isinstance(i, str) for i in x)
```

### ReadOnly TypedDict
```python
from typing import TypedDict, ReadOnly

class User(TypedDict):
    id: ReadOnly[int]
    name: str
```

### Type Parameter Defaults
```python
from typing import TypeVar, Generic
T = TypeVar('T', default=str)

class Container(Generic[T]):
    def __init__(self, value: T) -> None:
        self.value = value
```

### Deprecation Decorator
```python
from warnings import deprecated

@deprecated("Use process_v2() instead")
def process(data: bytes) -> str:
    return data.decode()
```

## Design Principles

### Single Responsibility (SRP)
```python
# GOOD: Separate concerns
class UserRepository:
    def save(self, user: User) -> None: ...
    def find(self, user_id: int) -> User | None: ...

class UserNotifier:
    def send_welcome(self, user: User) -> None: ...

# BAD: Mixed concerns - class has two reasons to change
class UserManager:
    def save(self, user: User) -> None: ...
    def send_welcome(self, user: User) -> None: ...  # Wrong!
```

### Dependency Injection
```python
from typing import Protocol

class Sender(Protocol):
    def send(self, msg: str) -> None: ...

# GOOD: Dependency injected - testable, swappable
class NotificationService:
    def __init__(self, sender: Sender) -> None:
        self._sender = sender

# BAD: Hard-coded dependency - hard to test
class NotificationService:
    def __init__(self) -> None:
        self._sender = EmailSender()  # Tightly coupled!
```

### Fail-Fast Validation
```python
# GOOD: Validate at entry, clear error messages
def transfer(amount: float, source: str, target: str) -> None:
    if amount <= 0:
        raise ValueError(f"Amount must be positive, got {amount}")
    if source == target:
        raise ValueError("Cannot transfer to same account")
    # ... proceed

# BAD: No validation, silent failures
def transfer(amount: float, source: str, target: str) -> None:
    # Proceeds with negative amounts, same account transfers...
    do_transfer(amount, source, target)
```

### Encapsulation
```python
# GOOD: Private state, controlled access
class Account:
    def __init__(self, balance: float) -> None:
        self._balance = balance

    @property
    def balance(self) -> float:
        return self._balance

# BAD: Public state, anyone can modify
class Account:
    def __init__(self, balance: float) -> None:
        self.balance = balance  # Can be set to -1000!
```

### Pure Functions (Testability)
```python
# GOOD: Pure function - same input always gives same output
def calculate_discount(price: float, rate: float) -> float:
    return price * (1 - rate)

# BAD: Impure - has side effects, harder to test
def calculate_discount(price: float, rate: float) -> float:
    result = price * (1 - rate)
    print(f"Discount: {result}")  # Side effect!
    save_to_database(result)      # Side effect!
    return result
```

### Portability
```python
# GOOD: Cross-platform, configurable
from pathlib import Path
config_path = Path.home() / ".config" / "myapp" / "settings.json"

# BAD: Platform-specific, hard-coded
config_path = "/home/user/.config/myapp/settings.json"
```

### Immutable Object Modification
```python
from copy import replace
from dataclasses import dataclass

@dataclass(frozen=True)
class Config:
    host: str
    port: int

old = Config("localhost", 8000)
new = replace(old, port=9000)
```

## Testing Patterns

### Naming Convention
```python
# File: test_<module_name>.py
# Function: test_<action>_<scenario>

async def test_transfer_success() -> None: ...
async def test_transfer_insufficient_funds() -> None: ...
async def test_transfer_invalid_amount() -> None: ...
```

### Triple Test Pattern
Every function should have three test variants:

```python
# 1. Success case
@pytest.mark.asyncio
async def test_create_user_success(client: Client) -> None:
    """Test successful user creation."""
    result = await client.create_user(valid_user)
    assert result.id is not None

# 2. Error status codes (parametrized)
@pytest.mark.asyncio
@pytest.mark.parametrize("status_code", [400, 401, 403, 404, 500])
async def test_create_user_error_codes(
    client: Client, status_code: int
) -> None:
    """Test error handling for various HTTP codes."""
    with pytest.raises(ClientError) as exc:
        await client.create_user(invalid_user)
    assert exc.value.status_code == status_code

# 3. Exception handling
@pytest.mark.asyncio
@pytest.mark.parametrize(
    ("exc_class", "message"),
    [(TimeoutError, "Request timed out"), (ConnectionError, "Network error")],
)
async def test_create_user_exceptions(
    client: Client, exc_class: type[Exception], message: str
) -> None:
    """Test exception handling."""
    with pytest.raises(ClientError) as exc:
        await client.create_user(user)
    assert message in str(exc.value)
```

### Testing DO and DON'T

**DO:**
```python
# Type hints on test functions
async def test_add_item(client: Client, item: Item) -> None:

# Use fixtures for reusability
@pytest.fixture
def valid_user() -> User:
    return User(name="test", email="test@example.com")

# Use context managers for mocking
with patch("module.Client.request", return_value=mock_response):
    result = await client.method()

# Verify mock calls explicitly
mock.assert_called_once_with(url="/users", method="POST", json=data)

# Use context managers for cleanup
@contextmanager
def temporary_user(client):
    user = client.create_user(data)
    try:
        yield user
    finally:
        client.delete_user(user.id)
```

**DON'T:**
```python
# Don't use sleep - use retry/polling
time.sleep(5)  # BAD - use tenacity or similar

# Don't hardcode test data inline
async def test_bad():
    data = {"name": "test"}  # Move to fixture

# Don't test private methods
assert obj._internal_method()  # Test public interface only

# Don't skip cleanup on errors
result = client.create(item)
# ... test ...
client.delete(result.id)  # Use try/finally or context manager

# Don't catch bare exceptions in tests
except:  # Use specific exception types
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| `typing.Optional[X]` | Use `X \| None` |
| `typing.List[str]` | Use `list[str]` |
| `from __future__ import annotations` | Only if targeting <3.10 |
| Catching generic `Exception` | Catch specific exceptions |
| `print()` for logging | Use `logging` module |
| String path concatenation | Use `pathlib.Path` |
| Hard-coded configuration | Use environment variables |

## Code Smells → Solutions

| Smell | Principle Violated | Fix |
|-------|-------------------|-----|
| God class doing everything | SRP | Split into focused classes |
| Public fields everywhere | Encapsulation | Private fields + properties |
| Hard-coded dependencies | Loose Coupling | Dependency injection |
| Giant if/else for types | Extensibility | Strategy/polymorphism |
| Hard-coded paths | Portability | Config + pathlib |
| Silent failures | Defensibility | Fail-fast with exceptions |
| 500-line function | Maintainability | Break into smaller functions |
| Copy-pasted code | DRY | Extract to function |
| Unused "future" code | YAGNI | Delete it |

## Self-Review Decision Tree

```
Class doing more than one thing?
├─ Yes → Split it (SRP)
└─ No → ✓

Can clients modify internal state?
├─ Yes → Make it private (Encapsulation)
└─ No → ✓

Creating dependencies inside class?
├─ Yes → Inject them (Loose Coupling)
└─ No → ✓

Hard-coded paths or platform assumptions?
├─ Yes → Use pathlib and config (Portability)
└─ No → ✓

Accepting input without validation?
├─ Yes → Validate and fail-fast (Defensibility)
└─ No → ✓

Hard to test?
├─ Yes → Separate logic from I/O (Testability)
└─ No → ✓

Adding abstractions "just in case"?
├─ Yes → Remove it (YAGNI)
└─ No → ✓

Repeating this logic elsewhere?
├─ Yes → Extract it (DRY)
└─ No → ✓
```
