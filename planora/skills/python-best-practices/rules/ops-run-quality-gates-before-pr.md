---
title: Run Full Quality Gates Before Opening PR
impact: HIGH
impactDescription: Catches formatting, typing, security, and test regressions early.
tags: ops, ci, quality
---

## Run Full Quality Gates Before Opening PR

Execute formatting, linting, typing, security scan, and unit tests before review.

**Incorrect python code:**

```python
def pre_pr_commands() -> list[str]:
    return ["uv run pytest -q"]
```

**Correct python code:**

```python
def pre_pr_commands() -> list[str]:
    return [
        "uv run ruff format",
        "uv run ruff check --fix",
        "uv run mypy --pretty",
        "uv run bandit -c pyproject.toml -r .",
        "uv run pytest --without-integration --without-e2e",
    ]
```

Reference: [Bandit docs](https://bandit.readthedocs.io/en/latest/)
