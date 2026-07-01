---
name: codex-counsel
description: >-
  Consult OpenAI's Codex CLI (a different model family, GPT) for an independent
  second opinion. Use when the user asks to "ask Codex" / "ask another model" /
  "get counsel" / "what would Codex say", or wants a sanity check, a devil's
  advocate, or an adversarial review — and when a task benefits from cross-model
  scrutiny: reviewing a plan before building it, reviewing a code change or git
  diff, pressure-testing an architecture or design decision, choosing between two
  approaches, or breaking a debugging dead-end. Trigger proactively before
  high-stakes work (risky refactors, security-sensitive changes, irreversible
  migrations) where an independent check would catch a confident mistake.
---

# Codex Counsel

Treat OpenAI's Codex as **counsel** — a second mind trained by different people on
different data, so its blind spots don't line up with yours. That's the whole
point: when you (Claude) wrote the plan or the code, asking yourself to check it
is grading your own homework, and a confident mistake stays confident. A different
model family is the cheapest way to find the error you can't see.

Two things follow from that, and they matter more than any flag below:

1. **Don't relay — synthesize.** Codex is a colleague, not an oracle. After it
   answers, say plainly where you agree, where you disagree, and *why*. If Codex
   is wrong, push back and explain. Rubber-stamping ("Codex says LGTM") wastes the
   whole exercise. The user wants two minds in tension, not an echo.
2. **The useful asymmetry.** Cross-model review helps most when the stronger
   reasoner (you) weighs a fresh critic's findings — not when you defer to them.
   So Codex *surfaces* candidate issues; *you* adjudicate which are real.

## Preflight (once per session, fast)

Codex must be installed and authenticated. A cheap check:

```
codex --version
```

If that fails, tell the user to install it (`npm install -g @openai/codex`) and
authenticate (`codex login`), then stop — there's nothing to consult. Everything
else (flags, sandbox, git-repo quirks) is handled by the wrapper script; you do
not need to remember the CLI surface.

## The wrapper

All Codex calls go through the bundled script, which builds a safe, read-only,
non-interactive invocation and returns just Codex's answer. Codex **only reads**
your code — `read-only` sandbox, never writes — so it's safe to point at anything.

**macOS / Linux (bash — this machine's default):**

```
scripts/codex_consult.sh --prompt-file <path> [--context-file <path>] [--cd <dir>]
    [--effort low|medium|high|xhigh] [--model <name>] [--resume-id <id>]
    [--output-schema <path>]
```

The script must be executable (`chmod +x scripts/codex_consult.sh`); if it isn't,
invoke it as `bash scripts/codex_consult.sh …`.

**Windows / PowerShell (portability):** `scripts/codex_consult.ps1` takes the same
ideas as flags (`-PromptFile`, `-ContextFile`, `-Cd`, `-Effort`, `-Model`,
`-ResumeId`, `-OutputSchema`). Use whichever shell the environment gives you.

What it does for you: read-only sandbox, `--skip-git-repo-check` (so it works in
your home dir and other non-repo paths), prompt passed via a temp file (no
shell-quoting traps), final answer captured cleanly, and — on a fresh call — the
Codex **session id** printed on the last line as `__CODEX_SESSION__:<id>` so you
can resume the same session later. Pass that id back via `--resume-id` to let Codex
remember its earlier findings and check whether your fixes actually landed.

**Always write the prompt to a file** and pass `--prompt-file`. Inlining multi-line
prompts with diffs in them through the shell is where things break. Put the diff,
plan, or code in a context file and pass `--context-file`; it reaches Codex as a
`<stdin>` block appended to your instruction.

### Effort and model

The wrapper defaults to `xhigh` reasoning — the deepest setting. A second opinion
is worth waiting for, so default to thoroughness over speed; expect consults to
take appreciably longer (tens of seconds to a few minutes) than an ordinary reply.
That's the trade you're making on purpose. Dial it down only when you want a fast
answer and the stakes are genuinely low:

- `--effort medium` — quick sanity checks, "am I missing something obvious?"
- `--effort high` — a solid review with a faster turnaround.
- `--effort xhigh` — default; the deepest scrutiny for plans, diffs, and hard calls.

When you do drop the effort for speed, it's worth telling the user — they asked for
a second opinion, and a shallower one is a different thing than the default.

Leave `--model` unset to use the user's configured Codex model (a different family
from you, which is exactly what you want). Only override if the user asks.

## Mode 1 — Consult (one-shot)

The default. Use it for a single independent opinion: review this plan, sanity-check
this decision, pressure-test this design, get unstuck on this bug.

1. Gather the artifact (plan text, `git diff`, the function, the question) into a
   context file. Give Codex enough to judge — the goal, the constraints, what
   "good" looks like — not just raw code with no framing.
2. Write a focused prompt: state what you want Codex to do and what to return.
   Asking for a *critique* beats asking "is this good?" — invite it to find the
   strongest objection, the missed edge case, the assumption that only holds on the
   happy path.
3. Run the wrapper, read Codex's answer.
4. **Report back as a synthesis, not a forward.** Lead with your own judgment:
   which of Codex's points you think are real and worth acting on, which you'd
   push back on and why, and what (if anything) changes as a result. Surface
   genuine disagreement — it's the most valuable output.

Example prompt to Codex (in the prompt file):

```
You are a skeptical senior reviewer giving an independent second opinion. The
implementation plan is in the appended <stdin> block. Find the most important
problems: correctness risks, missing edge cases, hidden assumptions, security or
concurrency issues, and anything that would fail in production but passes a happy-
path read. Be specific and cite the part of the plan you mean. If it's sound, say
so briefly and name the one thing you'd still watch.
```

## Mode 2 — Debate (iterative)

For high-stakes plans and diffs (not small changes — those are Mode 1), one shot
finds problems but doesn't verify the fixes. Loop until Codex is satisfied or
you've capped the rounds. The key move:
**you make real revisions between rounds** — actually improve the artifact, don't
just paraphrase Codex back at it — and you **resume the same Codex session** so it
remembers what it already flagged and judges whether you genuinely addressed it.

Stop signal: pass `--output-schema` pointing at this skill's
`references/verdict.schema.json` (absolute path) so Codex returns a structured
`{verdict, summary, issues[]}` object instead of prose. Read `verdict` (`APPROVED`
or `REVISE`) — parsing a JSON field is more reliable than scraping a text line, and
each issue's `status` (`open`/`resolved`) is what makes the resume step verifiable.

The loop:

1. **Round 1.** Run the wrapper on the plan/diff with the critique prompt above and
   `--output-schema <abs-path>/references/verdict.schema.json`. Capture the JSON
   answer **and the session id** from the `__CODEX_SESSION__:` line.
2. If `verdict` is `APPROVED` → done. Report the converged result.
3. If `verdict` is `REVISE` → **revise the artifact for real**, addressing each
   `issue` you judge valid (and noting any you're deliberately rejecting, with
   reasoning).
4. **Re-review via resume:** run the wrapper with `--resume-id <id>` (keep passing
   `--output-schema`) and a short prompt like *"I revised the plan to address your
   feedback (updated version in `<stdin>`). Mark each prior issue `resolved` or
   `open`, then return your verdict."* Resuming is what lets Codex check fixes
   instead of starting fresh.
5. Repeat from step 2. **Cap at 3 rounds by default, 5 maximum.** If it hasn't
   converged by then, stop and tell the user where the disagreement stands — a
   stubborn loop usually means a real judgment call only they can make.

## Honesty about disagreement

Rubber-stamping (principle 1) has a mirror image — quietly *dismissing* Codex to
look decisive — and false consensus of either kind is the failure mode here.
Resist both. If you and Codex disagree and you can't resolve it from the evidence,
say so explicitly and lay out both cases for the user. An unresolved, well-stated
disagreement is a *good* outcome: it's exactly the signal they reached for a
second opinion to get.

## More detail

`references/codex-cli.md` has the full `codex exec` flag reference, the JSON event
shapes, resume mechanics, and troubleshooting (auth, sandbox, git-repo errors,
shell quoting). Read it only if the wrapper misbehaves or you need a flag the
wrapper doesn't expose.
