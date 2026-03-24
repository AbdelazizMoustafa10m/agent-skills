---
title: Use Descriptive Names Over Abbreviations
impact: MEDIUM
impactDescription: reduces cognitive load, makes code self-documenting
tags: naming, readability, variables, descriptive, abbreviations
---

## Use Descriptive Names Over Abbreviations

Use clear, descriptive names that convey purpose. Avoid single-letter variables (except `i`/`j` in short loops), cryptic abbreviations, and names that require context to understand.

**Incorrect (cryptic abbreviations):**

```python
def proc_doc(d, ns, cfg):
    r = d.get_c()
    if not r:
        return None
    t = cfg.get("t", 30)
    res = svc.q(ns, r, timeout=t)
    return res


def calc_emb(txt, mdl, bs=32):
    embs = []
    for i in range(0, len(txt), bs):
        b = txt[i:i + bs]
        e = mdl.encode(b)
        embs.extend(e)
    return embs
```

**Correct (descriptive names):**

```python
def process_document(
    document: Document, namespace_id: str, config: QueryConfig
) -> QueryResult | None:
    content = document.get_content()
    if not content:
        return None
    timeout = config.get("timeout", 30)
    result = query_service.query(namespace_id, content, timeout=timeout)
    return result


def calculate_embeddings(
    texts: list[str], model: EmbeddingModel, batch_size: int = 32
) -> list[list[float]]:
    embeddings: list[list[float]] = []
    for start in range(0, len(texts), batch_size):
        batch = texts[start:start + batch_size]
        batch_embeddings = model.encode(batch)
        embeddings.extend(batch_embeddings)
    return embeddings
```
