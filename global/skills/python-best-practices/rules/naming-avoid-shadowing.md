---
title: Don't Shadow Built-in Names or Outer Variables
impact: MEDIUM-HIGH
impactDescription: prevents subtle bugs where wrong variable is referenced
tags: naming, shadowing, builtins, scope, bugs
---

## Don't Shadow Built-in Names or Outer Variables

Never use names that shadow Python built-ins (`id`, `type`, `list`, `dict`, `input`, `format`, `hash`, `range`, `filter`, `map`) or variables from outer scopes. Shadowing creates subtle bugs where the wrong binding is used.

**Incorrect (shadowing built-ins and outer scope):**

```python
def process_items(list: list[str]) -> dict:  # Shadows built-in list and dict
    id = generate_id()  # Shadows built-in id
    type = determine_type(list)  # Shadows built-in type
    input = get_user_input()  # Shadows built-in input
    format = "json"  # Shadows built-in format
    return {"id": id, "type": type, "items": list}


filter = "active"  # Module-level shadow

def get_filtered(items: list[str]) -> list[str]:
    return [i for i in items if i == filter]  # Uses module shadow
```

**Correct (unique, descriptive names):**

```python
def process_items(items: list[str]) -> dict[str, Any]:
    item_id = generate_id()
    item_type = determine_type(items)
    user_input = get_user_input()
    output_format = "json"
    return {"id": item_id, "type": item_type, "items": items}


active_filter = "active"


def get_filtered(items: list[str]) -> list[str]:
    return [item for item in items if item == active_filter]
```

Common built-ins that get shadowed: `id`, `type`, `list`, `dict`, `set`, `input`, `format`, `hash`, `range`, `filter`, `map`, `open`, `file`, `dir`, `help`, `object`, `next`, `iter`.

Reference: [Ruff A001-A003 - builtin shadowing](https://docs.astral.sh/ruff/rules/#flake8-builtins-a)
