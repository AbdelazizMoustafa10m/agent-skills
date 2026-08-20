#!/usr/bin/env python3
"""Mechanical slop scan for the unslop skill.

Detects the surface patterns from references/patterns.md that code finds
more reliably than instructions: typography artifacts, phrase templates,
word lists, and density statistics. It is a detector, not a judge: every
finding is evidence for the editor to inspect, never a target of zero
(see SKILL.md, "Treat the pattern catalog as diagnostic clues, not
banned tokens").

Severity tiers:
- TELL: integrity artifacts (invisible or corrupt characters) and
  explicit model self-references ("as of my last training update").
  These are the only near-certain findings.
- CANDIDATE: everything else, including curly quotes, emoji, chatbot
  phrasing, and vocabulary. All of these occur in legitimate human
  writing (word processors emit curly quotes; people end emails with
  "let me know"); judge each in context. File-level density findings
  (em-dash crutch, boldface overuse, rule-of-three cadence, uniform
  rhythm, vocabulary clusters) are also candidates.

What it skips, so out-of-scope material does not trip the scan:
- YAML frontmatter, fenced code blocks, and inline code spans
  (invisible characters are still checked everywhere)
- Markdown blockquote lines, because the skill leaves them unchanged;
  inline quotations within prose are still scanned
- link destinations and bare URLs

Phrase checks run on whole paragraphs, so hard-wrapped phrases are
found; findings report the line where the match starts. Output is
capped at 5 examples per category, then summarized.

Deliberate exclusions (kept out to protect signal quality):
- hyphenated compound modifiers ("third-party", "data-driven"):
  standard English; flagging them pushes grammatically wrong edits
- ultra-common words ("key", "actually", "vector", "surface"): the
  false-positive flood would erode trust in every other finding;
  moderately common words ("robust", "enhance") are reported only as
  a file-level cluster when several occur close together
- synonym cycling, false ranges beyond narrow templates, and headings
  restated by their first sentence: they need semantic judgment the
  editor applies from the pattern reference

Usage: python slop_scan.py FILE [FILE ...]
       python slop_scan.py -          (read text from stdin)
Requires Python 3.11+.
Exit codes: 0 scan completed (with or without findings), 2 usage or
read error. Findings never fail the command; they are advisory.
"""

from __future__ import annotations

import io
import re
import statistics
import sys
from bisect import bisect_right
from dataclasses import dataclass, field
from enum import StrEnum


class Severity(StrEnum):
    TELL = "TELL"
    CANDIDATE = "CANDIDATE"


@dataclass(frozen=True, slots=True)
class Check:
    category: str
    severity: Severity
    pattern: re.Pattern[str]


@dataclass(frozen=True, slots=True)
class Finding:
    line: int  # 0 means the finding applies to the whole file
    severity: Severity
    category: str
    excerpt: str
    col: int = 0


@dataclass(slots=True)
class FileReport:
    findings: list[Finding] = field(default_factory=list)
    notes: list[str] = field(default_factory=list)
    words: int = 0


def _check(category: str, severity: Severity, pattern: str) -> Check:
    return Check(category, severity, re.compile(pattern, re.IGNORECASE))


# Invisible or corrupt characters break shells and diffs. Flagged
# everywhere, including code blocks and frontmatter.
INVISIBLE_CHARS: dict[str, str] = {
    " ": "non-breaking space",
    " ": "narrow non-breaking space",
    "​": "zero-width space",
    "﻿": "byte order mark",
    "�": "replacement character (encoding damage)",
}

# Typography that word processors and chat models both emit. Candidates,
# not proof of machine authorship; house style may want them kept.
TYPOGRAPHY_CHARS: dict[str, str] = {
    "‘": "curly quote",
    "’": "curly quote",
    "“": "curly quote",
    "”": "curly quote",
    "…": "ellipsis character",
    "→": "arrow character",
    "⇒": "arrow character",
}

DASHES = ("—", "–")
# zero-width joiner and variation selector-16 glue emoji sequences
EMOJI_CONTINUATION = frozenset({"‍", "️"})

# Phrase checks run on paragraph-joined prose (hard wraps do not hide
# a phrase). Only explicit model self-references stay TELL.
PHRASE_CHECKS: tuple[Check, ...] = (
    _check(
        "model self-reference",
        Severity.TELL,
        r"\b(as of my (last|latest) (training )?(update|data)"
        r"|as of my knowledge cutoff|as an ai( language)? model)\b",
    ),
    _check(
        "chatbot artifact",
        Severity.CANDIDATE,
        r"\b(i hope this helps|let me know if|of course!|certainly!"
        r"|would you like me to|let'?s dive in|without further ado"
        r"|here'?s what you need to know)",
    ),
    _check(
        "sycophancy",
        Severity.CANDIDATE,
        r"\b(great question|excellent question|great point|excellent point"
        r"|you'?re absolutely right)\b",
    ),
    _check(
        "vague sourcing disclaimer",
        Severity.CANDIDATE,
        r"\b(while specific details are (limited|scarce)"
        r"|based on available information|not extensively documented)\b",
    ),
    _check(
        "AI vocabulary",
        Severity.CANDIDATE,
        r"\b(delv\w+|tapestry|testament|myriad|plethora|garner\w*|boasts"
        r"|interplay|intricacies|holistic\w*|paradigm\w*|utiliz\w+)\b",
    ),
    _check(
        "abstract metaphor jargon",
        Severity.CANDIDATE,
        r"\b(substrate|bedrock|nexus|locus|flywheel|north star|endgame"
        r"|gold-plating)\b",
    ),
    _check(
        "inflated significance",
        Severity.CANDIDATE,
        r"\b(stands as a testament|serves as a (testament|reminder)"
        r"|plays a (vital|crucial|pivotal|significant|key) role"
        r"|pivotal moment|underscores (its|the) (importance|significance)"
        r"|highlights (its|the) (importance|significance)|reflects broader"
        r"|evolving landscape|indelible mark|deeply rooted"
        r"|setting the stage for|enduring legacy|key turning point"
        r"|watershed moment|rich cultural heritage"
        r"|marks a (significant|major) (shift|step|milestone))\b",
    ),
    _check(
        "promotional language",
        Severity.CANDIDATE,
        r"\b(nestled|breathtaking|must-visit|stunning|renowned"
        r"|groundbreaking|in the heart of|natural beauty|state-of-the-art"
        r"|cutting-edge|world-class|best-in-class|game-chang\w+"
        r"|revolutioniz\w+|transformative|unparalleled|unleash\w*"
        r"|unlock the|elevate your|commitment to excellence)\b",
    ),
    _check(
        "vague attribution",
        Severity.CANDIDATE,
        r"\b(experts (believe|say|argue|agree)|studies (show|suggest)"
        r"|research suggests|industry reports|observers have (noted|cited)"
        r"|some critics argue|many (users|people) (say|report|believe)"
        r"|it is widely (believed|regarded)|sources say)\b",
    ),
    _check(
        "superficial -ing tail",
        Severity.CANDIDATE,
        r",\s*(highlighting|underscoring|emphasizing|ensuring|reflecting"
        r"|symbolizing|showcasing|fostering|cultivating|encompassing"
        r"|demonstrating|solidifying|cementing|contributing to)\b",
    ),
    _check(
        "copula avoidance",
        Severity.CANDIDATE,
        r"\b(serves as|stands as|functions as)\b",
    ),
    _check(
        "negative parallelism",
        Severity.CANDIDATE,
        r"\bnot (just|only|merely)\b[^.!?]{0,80}\bbut\b"
        r"|\bit'?s not (?:just |only |merely )?about\b[^.!?]{0,60}\bit'?s\b"
        r"|, no \w+( \w+)?\.",
    ),
    _check(
        "false range",
        Severity.CANDIDATE,
        r"\beverything from\b"
        r"|\bfrom \w+[^.!?]{0,40} to \w+[^.!?]{0,40}, from\b",
    ),
    _check(
        "filler phrase",
        Severity.CANDIDATE,
        r"\b(in order to|due to the fact that|at this point in time"
        r"|in the event that|has the ability to|it is important to note"
        r"|it'?s worth noting|needless to say)\b",
    ),
    _check(
        "hedge stack",
        Severity.CANDIDATE,
        r"\b(could potentially|might possibly|may potentially"
        r"|it could be argued that|arguably might|may want to consider"
        r"|might have some)\b",
    ),
    _check(
        "generic conclusion",
        Severity.CANDIDATE,
        r"\b(the future looks bright|only time will tell"
        r"|exciting (times|new chapter)|journey toward"
        r"|step in the right direction|continues to thrive"
        r"|despite these challenges)\b",
    ),
    _check(
        "authority trope",
        Severity.CANDIDATE,
        r"\b(the real question is|at its core|what really matters"
        r"|the heart of the matter|the deeper issue"
        r"|here'?s the honest truth|the real tension)\b",
    ),
    _check(
        "dismissive difficulty",
        Severity.CANDIDATE,
        r"\b(obviously|you simply|it'?s that (simple|easy)"
        r"|all you (need|have) to do|quick and easy|trivially)\b",
    ),
    _check(
        "nominalization",
        Severity.CANDIDATE,
        r"\b(make a determination|perform an evaluation"
        r"|provide an explanation|conduct an analysis)\b",
    ),
    _check(
        "weak-verb adverb",
        Severity.CANDIDATE,
        r"\b(significantly|dramatically|drastically|greatly|vastly"
        r"|substantially) (improv|reduc|increas|enhanc|boost|decreas)\w*",
    ),
    _check(
        "meaningless link text",
        Severity.CANDIDATE,
        r"\[(click here|here|read more|this link|link)\]\(",
    ),
)

# Anchored checks that only make sense against a single source line.
LINE_CHECKS: tuple[Check, ...] = (
    _check(
        "subjectless fragment",
        Severity.CANDIDATE,
        r"^\s*No \w+[^.!?]*\b(needed|required)\b",
    ),
    _check(
        "inline-header list item",
        Severity.CANDIDATE,
        # allows a short decoration (an emoji, a symbol) before the label
        r"^\s*[-*+]\s+(?:[^\w\s*]{1,3}\s*)?\*\*[^*]+:\*\*",
    ),
)

# Common words that are legitimate alone but suspicious in clusters.
# Reported once per file when several occur close together.
COMMON_VOCAB = re.compile(
    r"\b(robust\w*|comprehensive\w*|crucial\w*|seamless\w*|enhanc\w+"
    r"|facilitat\w+|leverag\w+|pivotal|intricate|vibrant|enduring"
    r"|foster\w+|showcas\w+|underscor\w+|additionally)\b",
    re.IGNORECASE,
)

FENCE = re.compile(r"^\s*(`{3,}|~{3,})")
BLOCKQUOTE = re.compile(r"^\s*>")
INLINE_CODE = re.compile(r"(`+).*?\1")
LINK_DEST = re.compile(r"(\]\()([^)]*)(\))")
BARE_URL = re.compile(r"https?://\S+")
DIVIDER = re.compile(r"^\s*(={3,}|\*{3,}|-{4,}|_{4,})\s*$")
HEADING = re.compile(r"^#{1,6}\s+(.*)")
LIST_ITEM = re.compile(r"^\s*(?:[-*+]|\d+[.)])\s+")
TABLE_ROW = re.compile(r"^\s*\|")
BOLD_SPAN = re.compile(r"\*\*[^*]+\*\*")
WORD = re.compile(r"[A-Za-z][\w'-]*")
TRIPLE = re.compile(r"\b\w+, \w+, and \w+\b")
EMPHASIS = re.compile(r"\b(CRITICAL|IMPORTANT|MUST|NEVER|ALWAYS|MANDATORY)\b")
PASSIVE = re.compile(r"\b(?:is|are|was|were|been|being|be)\s+\w+(?:ed|en|wn)\b")
SENTENCE_SPLIT = re.compile(r"[.!?]+\s")

# Density thresholds for the file-level findings. Constants, not
# config: single consumer, tuned against the eval set, developer-owned.
DASH_CRUTCH_MIN = 3
DASH_CRUTCH_WORDS_PER = 200
BOLD_OVERUSE_MIN = 8
BOLD_OVERUSE_WORDS_PER = 80
TRIPLE_CADENCE_MIN = 4
RHYTHM_MIN_SENTENCES = 8
RHYTHM_MAX_VARIATION = 0.25
PASSIVE_NOTE_RATIO = 0.4
COMMON_VOCAB_MIN = 4
COMMON_VOCAB_WORDS_PER = 150
MAX_EXAMPLES_PER_CATEGORY = 5


def is_emoji(ch: str) -> bool:
    cp = ord(ch)
    return 0x1F300 <= cp <= 0x1FAFF or 0x2600 <= cp <= 0x27BF


def _is_title_case_heading(text: str) -> bool:
    words = WORD.findall(text)
    significant = [w for w in words if len(w) >= 4]
    return (
        len(words) >= 3
        and len(significant) >= 2
        and all(w[0].isupper() for w in significant)
    )


def _mask_spaces(m: re.Match[str]) -> str:
    return " " * len(m.group(0))


def _mask_link_dest(m: re.Match[str]) -> str:
    return m.group(1) + " " * len(m.group(2)) + m.group(3)


def _mask(line: str) -> str:
    """Blank out inline code, link destinations, and bare URLs while
    keeping every remaining character at its original column."""
    line = INLINE_CODE.sub(_mask_spaces, line)
    line = LINK_DEST.sub(_mask_link_dest, line)
    return BARE_URL.sub(_mask_spaces, line)


def _frontmatter_end(lines: list[str]) -> int:
    """Index one past the closing frontmatter delimiter, or 0."""
    if not lines or lines[0].strip() != "---":
        return 0
    for i, line in enumerate(lines[1:], start=1):
        if line.strip() in ("---", "..."):
            return i + 1
    return 0


def _scan_char_runs(prose: str, ln: int, findings: list[Finding]) -> None:
    i = 0
    while i < len(prose):
        ch = prose[i]
        if ch in TYPOGRAPHY_CHARS:
            findings.append(
                Finding(ln, Severity.CANDIDATE, TYPOGRAPHY_CHARS[ch], ch, i + 1)
            )
            i += 1
        elif is_emoji(ch):
            j = i + 1
            while j < len(prose) and (
                is_emoji(prose[j]) or prose[j] in EMOJI_CONTINUATION
            ):
                j += 1
            findings.append(
                Finding(
                    ln, Severity.CANDIDATE, "emoji", f"U+{ord(ch):04X}", i + 1
                )
            )
            i = j
        else:
            i += 1


def _scan_paragraph(
    paragraph: list[tuple[int, str]], findings: list[Finding]
) -> None:
    if not paragraph:
        return
    starts: list[int] = []
    offset = 0
    for _, text in paragraph:
        starts.append(offset)
        offset += len(text) + 1
    joined = " ".join(text for _, text in paragraph)
    for check in PHRASE_CHECKS:
        for m in check.pattern.finditer(joined):
            segment = bisect_right(starts, m.start()) - 1
            findings.append(
                Finding(
                    paragraph[segment][0],
                    check.severity,
                    check.category,
                    m.group(0),
                )
            )


def scan_lines(lines: list[str]) -> FileReport:
    """Scan one document's lines; pure function, no I/O."""
    report = FileReport()
    paragraph: list[tuple[int, str]] = []  # body prose awaiting phrase scan
    body_parts: list[str] = []  # rhythm/passive stats: body prose only
    all_parts: list[str] = []  # word count and density stats
    common_hits: list[tuple[str, int]] = []
    dash_count = 0
    bold_count = 0
    emphasis_count = 0
    fence: tuple[str, int] | None = None
    prev_blank = True
    fm_end = _frontmatter_end(lines)

    def flush() -> None:
        _scan_paragraph(paragraph, report.findings)
        paragraph.clear()

    for ln, line in enumerate(lines, start=1):
        for col, ch in enumerate(line, start=1):
            if ch in INVISIBLE_CHARS:
                report.findings.append(
                    Finding(
                        ln,
                        Severity.TELL,
                        INVISIBLE_CHARS[ch],
                        f"U+{ord(ch):04X}",
                        col,
                    )
                )

        if ln <= fm_end:
            continue

        if fence_match := FENCE.match(line):
            marker = fence_match.group(1)
            if fence is None:
                fence = (marker[0], len(marker))
                flush()
                prev_blank = False
                continue
            if marker[0] == fence[0] and len(marker) >= fence[1]:
                fence = None
                prev_blank = False
                continue
        if fence is not None:
            continue

        is_blank = not line.strip()
        if is_blank or BLOCKQUOTE.match(line):
            flush()
            prev_blank = is_blank
            continue

        prose = _mask(line)
        _scan_char_runs(prose, ln, report.findings)

        if DIVIDER.match(prose):
            if prev_blank:
                report.findings.append(
                    Finding(
                        ln,
                        Severity.CANDIDATE,
                        "decorative divider",
                        prose.strip(),
                    )
                )
            flush()
            prev_blank = False
            continue

        for check in LINE_CHECKS:
            if m := check.pattern.search(prose):
                report.findings.append(
                    Finding(ln, check.severity, check.category, m.group(0))
                )

        all_parts.append(prose)
        dash_count += sum(prose.count(d) for d in DASHES)
        bold_count += len(BOLD_SPAN.findall(prose))
        emphasis_count += len(EMPHASIS.findall(prose))
        common_hits.extend(
            (m.group(0).lower(), ln) for m in COMMON_VOCAB.finditer(prose)
        )

        heading = HEADING.match(prose)
        is_standalone = bool(
            heading or LIST_ITEM.match(prose) or TABLE_ROW.match(prose)
        )
        if heading and _is_title_case_heading(heading.group(1)):
            report.findings.append(
                Finding(
                    ln,
                    Severity.CANDIDATE,
                    "title-case heading",
                    heading.group(1).strip(),
                )
            )

        if is_standalone:
            flush()
            _scan_paragraph([(ln, prose)], report.findings)
        else:
            paragraph.append((ln, prose))
            body_parts.append(prose)
        prev_blank = False

    flush()
    if fence is not None:
        report.notes.append("unclosed code fence")

    report.words = len(WORD.findall(" ".join(all_parts)))
    _add_density_findings(
        report, " ".join(body_parts), dash_count, bold_count, common_hits
    )
    if emphasis_count:
        report.notes.append(f"{emphasis_count} emphasis words")
    return report


def _add_density_findings(
    report: FileReport,
    body_text: str,
    dash_count: int,
    bold_count: int,
    common_hits: list[tuple[str, int]],
) -> None:
    words = report.words
    if not words:
        return

    if (
        dash_count >= DASH_CRUTCH_MIN
        and dash_count * DASH_CRUTCH_WORDS_PER > words
    ):
        report.findings.append(
            Finding(
                0,
                Severity.CANDIDATE,
                "em-dash crutch",
                f"{dash_count} dashes in {words} words",
            )
        )
    elif dash_count:
        report.notes.append(f"{dash_count} em/en dashes (below crutch threshold)")

    if (
        bold_count >= BOLD_OVERUSE_MIN
        and bold_count * BOLD_OVERUSE_WORDS_PER > words
    ):
        report.findings.append(
            Finding(
                0,
                Severity.CANDIDATE,
                "boldface overuse",
                f"{bold_count} bold spans in {words} words",
            )
        )

    if (
        len(common_hits) >= COMMON_VOCAB_MIN
        and len(common_hits) * COMMON_VOCAB_WORDS_PER > words
    ):
        examples = ", ".join(
            f"{word}({line})" for word, line in common_hits[:5]
        )
        report.findings.append(
            Finding(
                0,
                Severity.CANDIDATE,
                "common AI-adjacent vocabulary cluster",
                f"{len(common_hits)} hits in {words} words: {examples}",
            )
        )

    triples = len(TRIPLE.findall(body_text))
    if triples >= TRIPLE_CADENCE_MIN:
        report.findings.append(
            Finding(
                0,
                Severity.CANDIDATE,
                "rule-of-three cadence",
                f"{triples} 'x, y, and z' triples",
            )
        )

    sentences = [s for s in SENTENCE_SPLIT.split(body_text) if s.strip()]
    lengths = [n for s in sentences if (n := len(WORD.findall(s)))]
    if len(lengths) >= RHYTHM_MIN_SENTENCES:
        mean = statistics.mean(lengths)
        if mean and statistics.pstdev(lengths) / mean < RHYTHM_MAX_VARIATION:
            report.findings.append(
                Finding(
                    0,
                    Severity.CANDIDATE,
                    "uniform sentence rhythm",
                    f"{len(lengths)} sentences, mean {mean:.0f} words, "
                    "low variation",
                )
            )
        passive_sentences = sum(
            1 for s in sentences if PASSIVE.search(s)
        )
        passive_ratio = passive_sentences / len(sentences)
        if passive_ratio > PASSIVE_NOTE_RATIO:
            report.notes.append(
                f"passive-voice approximation ~{passive_ratio:.0%} of sentences"
            )


def _print_report(path: str, report: FileReport) -> tuple[int, int]:
    tells = 0
    candidates = 0
    shown: dict[str, int] = {}
    overflow: dict[str, tuple[Severity, list[int]]] = {}

    for f in sorted(report.findings, key=lambda f: (f.line, f.col)):
        if f.severity is Severity.TELL:
            tells += 1
        else:
            candidates += 1
        shown[f.category] = shown.get(f.category, 0) + 1
        if shown[f.category] > MAX_EXAMPLES_PER_CATEGORY:
            overflow.setdefault(f.category, (f.severity, []))[1].append(f.line)
            continue
        location = f"{path}:{f.line}" if f.line else path
        if f.col:
            location = f"{location}:{f.col}"
        print(f"{location}: {f.severity} {f.category}: {f.excerpt!r}")

    for category, (severity, lines) in overflow.items():
        listed = ", ".join(str(n) for n in lines[:10])
        suffix = ", ..." if len(lines) > 10 else ""
        print(
            f"{path}: {severity} {category}: "
            f"{len(lines)} more at lines {listed}{suffix}"
        )

    summary = f"{path}: {tells} tells, {candidates} candidates ({report.words} words)"
    if report.notes:
        summary += "; notes: " + ", ".join(report.notes)
    print(summary)
    return tells, candidates


def main(argv: list[str]) -> int:
    # Windows consoles default to cp1252, which cannot encode characters
    # this scan reports (curly quotes survive, emoji do not).
    if isinstance(sys.stdout, io.TextIOWrapper):
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")

    if len(argv) < 2:
        print(__doc__, file=sys.stderr)
        return 2

    any_candidates = False
    for path in argv[1:]:
        if path == "-":
            lines = sys.stdin.read().splitlines()
            path = "<stdin>"
        else:
            try:
                with open(path, encoding="utf-8", errors="replace") as f:
                    lines = f.read().splitlines()
            except OSError as exc:
                print(f"{path}: cannot read: {exc}", file=sys.stderr)
                return 2
        _tells, candidates = _print_report(path, scan_lines(lines))
        any_candidates = any_candidates or bool(candidates)

    if any_candidates:
        print(
            "candidates need a context call before editing; "
            "see SKILL.md 'Precedence and fidelity'"
        )
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
