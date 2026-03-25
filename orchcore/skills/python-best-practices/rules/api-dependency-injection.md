---
title: Use Depends() for Shared Logic
impact: HIGH
impactDescription: eliminates duplication, enables testing, centralizes cross-cutting concerns
tags: api, FastAPI, Depends, dependency-injection, middleware
---

## Use Depends() for Shared Logic

Use FastAPI's `Depends()` for shared concerns like authentication, database sessions, pagination, and configuration. This eliminates duplication and makes dependencies explicit and testable.

**Incorrect (duplicated logic in every endpoint):**

```python
@router.get("/documents")
async def list_documents(request: Request):
    token = request.headers.get("Authorization", "").replace("Bearer ", "")
    if not token:
        raise HTTPException(status_code=401)
    user = await verify_token(token)
    if not user:
        raise HTTPException(status_code=401)
    session = async_session_factory()
    try:
        result = await session.execute(select(DocumentModel).where(DocumentModel.owner_id == user.id))
        return result.scalars().all()
    finally:
        await session.close()


@router.get("/namespaces")
async def list_namespaces(request: Request):
    token = request.headers.get("Authorization", "").replace("Bearer ", "")
    if not token:
        raise HTTPException(status_code=401)
    user = await verify_token(token)
    if not user:
        raise HTTPException(status_code=401)
    session = async_session_factory()
    try:
        result = await session.execute(select(NamespaceModel).where(NamespaceModel.owner_id == user.id))
        return result.scalars().all()
    finally:
        await session.close()
```

**Correct (shared dependencies):**

```python
async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(HTTPBearer()),
) -> User:
    user = await verify_token(credentials.credentials)
    if not user:
        raise HTTPException(status_code=401, detail="Invalid token")
    return user


async def get_session() -> AsyncGenerator[AsyncSession, None]:
    async with async_session_factory() as session:
        yield session


@router.get("/documents")
async def list_documents(
    user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session),
) -> list[DocumentResponse]:
    result = await session.execute(
        select(DocumentModel).where(DocumentModel.owner_id == user.id)
    )
    return [DocumentResponse.model_validate(doc) for doc in result.scalars()]


@router.get("/namespaces")
async def list_namespaces(
    user: User = Depends(get_current_user),
    session: AsyncSession = Depends(get_session),
) -> list[NamespaceResponse]:
    result = await session.execute(
        select(NamespaceModel).where(NamespaceModel.owner_id == user.id)
    )
    return [NamespaceResponse.model_validate(ns) for ns in result.scalars()]
```

Reference: [FastAPI Dependencies](https://fastapi.tiangolo.com/tutorial/dependencies/)
