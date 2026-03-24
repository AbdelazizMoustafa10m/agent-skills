---
title: Add OpenTelemetry Spans to Client Operations
impact: HIGH
impactDescription: Improves traceability across service boundaries and incident triage.
tags: architecture, observability, opentelemetry
---

## Add OpenTelemetry Spans to Client Operations

Wrap external client operations with spans so cross-service traces are complete.

**Incorrect python code:**

```python
async def get_namespace(self, namespace_id: str) -> Namespace:
    response = await self._session.get(f"{self._base_url}/namespaces/{namespace_id}")
    return Namespace.model_validate_json(response.text)
```

**Correct python code:**

```python
@_tracer.start_as_current_span("namespace_client.get_namespace")
async def get_namespace(self, namespace_id: str) -> Namespace:
    response = await self._session.get(f"{self._base_url}/namespaces/{namespace_id}")
    return Namespace.model_validate_json(response.text)
```

Reference: [OpenTelemetry Python instrumentation](https://opentelemetry.io/docs/languages/python/instrumentation/)

