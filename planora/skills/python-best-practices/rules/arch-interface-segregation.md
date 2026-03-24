---
title: Define Narrow Protocols and Interfaces
impact: MEDIUM-HIGH
impactDescription: reduces coupling, allows partial implementations
tags: architecture, Protocol, interface, typing, ISP
---

## Define Narrow Protocols and Interfaces

Use Python `Protocol` classes to define narrow interfaces that describe only the methods a consumer needs. This reduces coupling and makes it easy to provide test doubles.

**Incorrect (depending on broad class):**

```python
# Consumer depends on the entire DatabaseClient class
class ReportGenerator:
    def __init__(self, db: DatabaseClient) -> None:
        self._db = db  # Only uses db.query() but depends on full class

    def generate(self, report_id: str) -> Report:
        rows = self._db.query(f"SELECT * FROM reports WHERE id = '{report_id}'")
        return Report.from_rows(rows)
```

**Correct (narrow Protocol):**

```python
from typing import Protocol


class QueryExecutor(Protocol):
    def query(self, sql: str) -> list[Row]: ...


class ReportGenerator:
    def __init__(self, db: QueryExecutor) -> None:
        self._db = db

    def generate(self, report_id: str) -> Report:
        rows = self._db.query(f"SELECT * FROM reports WHERE id = '{report_id}'")
        return Report.from_rows(rows)


# Easy to test with a minimal fake
class FakeQueryExecutor:
    def __init__(self, rows: list[Row]) -> None:
        self._rows = rows

    def query(self, sql: str) -> list[Row]:
        return self._rows
```

Reference: [PEP 544 - Protocols](https://peps.python.org/pep-0544/)
