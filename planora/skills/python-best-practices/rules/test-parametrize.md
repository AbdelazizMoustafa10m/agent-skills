---
title: Use Parametrize for Multiple Test Cases
impact: HIGH
impactDescription: eliminates test duplication, covers more cases with less code
tags: test, parametrize, pytest, duplication, coverage
---

## Use Parametrize for Multiple Test Cases

Use `@pytest.mark.parametrize` to test multiple inputs and expected outputs with a single test function. This eliminates copy-pasted test functions that differ only in their data.

**Incorrect (duplicated test functions):**

```python
def test_parse_document_pdf():
    result = parse_document("test.pdf", b"%PDF-content")
    assert result.format == DocumentFormat.PDF
    assert result.content is not None


def test_parse_document_html():
    result = parse_document("test.html", b"<html>content</html>")
    assert result.format == DocumentFormat.HTML
    assert result.content is not None


def test_parse_document_markdown():
    result = parse_document("test.md", b"# Title\nContent")
    assert result.format == DocumentFormat.MARKDOWN
    assert result.content is not None
```

**Correct (parametrized test):**

```python
@pytest.mark.parametrize(
    ("filename", "content", "expected_format"),
    [
        ("test.pdf", b"%PDF-content", DocumentFormat.PDF),
        ("test.html", b"<html>content</html>", DocumentFormat.HTML),
        ("test.md", b"# Title\nContent", DocumentFormat.MARKDOWN),
    ],
)
def test_parse_document(
    filename: str, content: bytes, expected_format: DocumentFormat
) -> None:
    result = parse_document(filename, content)
    assert result.format == expected_format
    assert result.content is not None
```

Use `pytest.param(..., id="descriptive-name")` for complex cases to improve test output readability.

Reference: [pytest parametrize](https://docs.pytest.org/en/stable/how-to/parametrize.html)
