#!/usr/bin/env python3
"""Mechanical slop scan for agent documents (checklist.md, pass 3).

Flags the typography, vocabulary, and filler patterns that the ship gate
bans. Works on codepoints, not shell character classes, because grep bracket
expressions byte-match multibyte characters on Git Bash and BSD grep and
false-positive on unrelated text.

What it skips, so quoted BAD examples do not trip the scan:
- fenced code blocks (``` or ~~~), except invisible-character checks
- inline code spans (`...`), except invisible-character checks

Emphasis words (MUST, NEVER, ...) are counted and reported as notes, not
findings; whether the survivors are load-bearing is a judgment call the
reading pass makes.

Usage: python slop_scan.py FILE [FILE ...]
Exit codes: 0 no findings, 1 findings, 2 usage or read error.
"""

import re
import sys

# Visible typography tells. Skipped inside code, where they may be quoted.
VISIBLE_CHARS = {
    "—": "em dash",
    "–": "en dash",
    "‘": "curly quote",
    "’": "curly quote",
    "“": "curly quote",
    "”": "curly quote",
    "…": "ellipsis character (write ... if needed)",
    "→": "arrow character (write -> instead)",
}

# Invisible or corrupt characters break shells and diffs. Flagged everywhere,
# including code blocks.
INVISIBLE_CHARS = {
    " ": "non-breaking space",
    " ": "narrow non-breaking space",
    "​": "zero-width space",
    "﻿": "byte order mark",
    "�": "replacement character (encoding damage)",
}

VOCAB = re.compile(
    r"\b(leverage[sd]?|utiliz\w*|delv\w*|robust\w*|seamless\w*|comprehensive\w*"
    r"|holistic\w*|crucial\w*|pivotal\w*|underscor\w*|showcas\w*|facilitat\w*"
    r"|intricate\w*|tapestry|garner\w*|foster\w*|vibrant|testament"
    r"|substrate|bedrock|nexus|locus|flywheel|north star|endgame|paradigm\w*|scaffolding"
    r"|ensure that|it is important to note|in order to|due to the fact"
    r"|serves as|stands as)\b",
    re.IGNORECASE,
)

HEDGES = re.compile(
    r"\b(might possibly|could potentially|may want to consider"
    r"|try to make sure|generally speaking)\b",
    re.IGNORECASE,
)

NOT_JUST = re.compile(r"\bnot (just|only)\b.*\bbut\b", re.IGNORECASE)

EMPHASIS = re.compile(r"\b(CRITICAL|IMPORTANT|MUST|NEVER|ALWAYS|MANDATORY|REQUIRED)\b")

DIVIDER = re.compile(r"^\s*(={3,}|\*{3,}|-{4,}|_{4,})\s*$")

INLINE_CODE = re.compile(r"`[^`]*`")


def is_emoji(ch: str) -> bool:
    cp = ord(ch)
    return (
        0x1F300 <= cp <= 0x1FAFF
        or 0x2600 <= cp <= 0x27BF
        or cp == 0xFE0F
    )


def scan(path: str) -> tuple[int, int]:
    """Return (findings, emphasis_count) for one file."""
    try:
        with open(path, encoding="utf-8", errors="replace") as f:
            lines = f.read().splitlines()
    except OSError as exc:
        print(f"{path}: cannot read: {exc}", file=sys.stderr)
        return (-1, 0)

    findings = 0
    emphasis = 0
    in_fence = False

    for ln, line in enumerate(lines, start=1):
        if re.match(r"^\s*(```|~~~)", line):
            in_fence = not in_fence
            continue

        for col, ch in enumerate(line, start=1):
            if ch in INVISIBLE_CHARS:
                print(f"{path}:{ln}:{col}: {INVISIBLE_CHARS[ch]}")
                findings += 1

        if in_fence:
            continue

        prose = INLINE_CODE.sub("", line)

        for col, ch in enumerate(prose, start=1):
            if ch in VISIBLE_CHARS:
                print(f"{path}:{ln}:{col}: {VISIBLE_CHARS[ch]}")
                findings += 1
            elif is_emoji(ch):
                print(f"{path}:{ln}:{col}: emoji")
                findings += 1

        for label, pattern in (
            ("AI vocabulary", VOCAB),
            ("stacked hedge", HEDGES),
            ("'not just X but Y' framing", NOT_JUST),
        ):
            for m in pattern.finditer(prose):
                print(f"{path}:{ln}: {label}: {m.group(0)!r}")
                findings += 1

        if DIVIDER.match(prose):
            print(f"{path}:{ln}: decorative divider")
            findings += 1

        for m in EMPHASIS.finditer(prose):
            print(f"{path}:{ln}: note: emphasis word {m.group(0)}")
            emphasis += 1

    return (findings, emphasis)


def main(argv: list[str]) -> int:
    if len(argv) < 2:
        print(__doc__, file=sys.stderr)
        return 2

    total = 0
    for path in argv[1:]:
        findings, emphasis = scan(path)
        if findings < 0:
            return 2
        total += findings
        print(f"{path}: {findings} findings, {emphasis} emphasis words")

    return 1 if total else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
