---
name: codex-implementer
description: >-
  Delegate hands-on implementation to OpenAI's Codex CLI (a GPT-family coding
  workhorse) while Claude stays the manager: Claude writes the task spec,
  dispatches Codex to edit files in a workspace-write sandbox, then reviews the
  diff, runs the checks, and iterates until it lands. Use when the user says
  "have Codex implement / build / write it", "delegate to Codex", "send this to
  Codex", "let Codex do the work", "use Codex as a worker", or wants Claude to
  orchestrate while another model does the heavy lifting — and for substantial,
  well-specified implementation work: executing an approved plan, a multi-file
  feature or refactor, generating a test suite, or a long batch of mechanical
  edits. Not for reviews or second opinions (that's codex-counsel), and not for
  one-liners Claude can edit faster directly.
---

# Codex Implementer

Treat OpenAI's Codex as your **implementer** — a diligent senior engineer you hand
a well-written ticket to. You (Claude) are the tech lead: you own the spec, the
review, the verification, and git. Codex owns the typing.

Why this division of labor works:

1. **Codex is a strong workhorse.** The GPT family under Codex is excellent at
   executing a precise spec — it reads the repo itself, follows conventions, and
   grinds through multi-file changes without tiring.
2. **Cross-family review comes free.** When Codex writes the code, your review is
   a *real* review: you're not grading your own homework, so a confident mistake
   doesn't sail through on shared blind spots.
3. **Your context is the scarce resource.** You hold the conversation, the plan,
   and the user's intent — things Codex can't see. Delegating the file-by-file
   grind spends Codex's patience instead of your context.

Two principles matter more than any flag below:

1. **Delegate outcomes, not keystrokes.** Codex performs to the quality of the
   ticket. Give it the goal, acceptance criteria, scope, and constraints — then
   let it decide how to type. A vague prompt gets you a vague implementation and
   an expensive round trip to fix it.
2. **Trust, but verify.** Codex *reports* what it did; git shows what actually
   happened. Review the diff like a skeptical reviewer and run the checks
   yourself. Never relay "Codex says done" to the user as "done."

## When to delegate — and when not to

Delegate when the work is **substantial and specifiable**: executing a plan the
user approved, a feature or refactor spanning several files, writing a test
suite against known behavior, or a long mechanical batch (renames, migrations,
API-shape changes). The dispatch overhead (spec + review) is fixed, so it pays
off exactly when the implementation is the bulk of the work.

Do it yourself when:

- The change is a one-liner or a couple of scoped edits — the round trip costs
  more than the work (the toll booth shouldn't cost more than the road).
- The task depends on conversation context that would be lossy to write down.
- There are no clear acceptance criteria yet — that's design, not
  implementation. Settle the design first (yourself, or with codex-counsel),
  then delegate the build.

## Preflight (once per session, fast)

Codex must be installed and authenticated. A cheap check:

```
codex --version
```

If that fails, tell the user to install it (`npm install -g @openai/codex`) and
authenticate (`codex login`), then stop. Also run `git status` — you want to
know what was dirty *before* Codex touches anything, or the diff can't be
attributed. Prefer a clean tree or a dedicated branch for anything sizable.

## The wrapper

All dispatches go through the bundled script, which builds a non-interactive
`codex exec` invocation with a **workspace-write** sandbox — Codex can edit files
under the working directory (and run commands there), but can't escape it, and
network is off unless you opt in.

**macOS / Linux (bash — this machine's default):**

```
scripts/codex_implement.sh --prompt-file <path> [--context-file <path>] [--cd <dir>]
    [--effort low|medium|high|xhigh|max] [--model <name>] [--resume-id <id>]
    [--allow-network] [--output-schema <path>]
```

The script must be executable (`chmod +x scripts/codex_implement.sh`); if it
isn't, invoke it as `bash scripts/codex_implement.sh …`.

**Windows / PowerShell (portability):** `scripts/codex_implement.ps1` takes the
same ideas as flags (`-PromptFile`, `-ContextFile`, `-Cd`, `-Effort`, `-Model`,
`-ResumeId`, `-AllowNetwork`, `-OutputSchema`).

What it does for you: workspace-write sandbox scoped to `--cd`,
`--skip-git-repo-check`, prompt passed via a temp file (no shell-quoting traps),
final report captured cleanly, and — on a fresh call — the Codex **session id**
printed on the last line as `__CODEX_SESSION__:<id>` so you can resume the same
session for fixes or the next step of a plan. `--allow-network` enables network
inside the sandbox for tasks that need installs (`npm install`, `pip install`);
leave it off otherwise — an offline worker can't leak or fetch surprises.

**Always write the ticket to a file** and pass `--prompt-file`. Inlining
multi-line prompts through the shell is where things break. Codex reads the repo
itself — pass file *paths* in the ticket, not pasted file contents; use
`--context-file` only for material that isn't on disk (the plan, the spec, API
notes from the conversation).

### Effort and model

The wrapper defaults to `gpt-5.6-sol` at `xhigh` reasoning — a workhorse setting:
deep enough to catch edge cases, without paying max-tier latency on every
dispatch. Implementation runs take **minutes, sometimes tens of minutes**; that's
the deal you're making, so dispatch and let it work. Calibrate per ticket:

- `--effort medium` — mechanical batches: renames, boilerplate, rote migrations.
- `--effort high` — routine, well-trodden feature work.
- `--effort xhigh` — default; real features, refactors, anything with edge cases.
- `--effort max` — the hardest tickets: concurrency, subtle algorithms, gnarly
  debugging-while-implementing.

Leave `--model` unset to use the default. Override only when the user asks.

## Mode 1 — Delegate a task

The default: one scoped task, dispatched once, reviewed once (plus fix rounds).

1. **Write the ticket** to a prompt file. A good ticket has: the goal,
   acceptance criteria ("done means…"), files/dirs in scope, conventions and
   constraints worth stating, what's explicitly out of scope, and the commands
   that verify the work (test/build/lint). Two standing rules to include:
   **do not commit** (you own git), and stay within the named scope.
2. **Dispatch** via the wrapper with `--output-schema
   <abs-path>/references/report.schema.json` so Codex returns a structured
   `{status, summary, changes[], commands_run[], open_items[]}` report instead
   of prose. Capture the session id from the `__CODEX_SESSION__:` line.
3. **Verify with three signals** — exit code 0, a coherent report, and a
   `git diff` that matches the spec. Any one alone lies: cross-check the
   report's `changes[]` against the actual diff, and flag files touched outside
   the declared scope.
4. **Review the diff for real** — correctness, spec compliance, repo
   conventions, unintended edits — and run the verification commands yourself.
5. **Close the loop.** Trivial nits: fix them yourself, cheaper than a round
   trip. Substantive problems: resume the session (`--resume-id <id>`) with a
   concrete fix list — Codex remembers what it built and why. Cap fix rounds at
   3; if it's still wrong, take over or re-spec, and tell the user which.
6. **Report to the user**: what you delegated, what changed (files + shape of
   the change), your review verdict, and the check results — faithfully. Tests
   failed → say so. Codex `BLOCKED` with questions → surface them.

Example ticket (in the prompt file):

```
Implement the following in this repository. Do not commit — leave changes in
the working tree. Stay within the scope below; if something outside it seems
necessary, stop and report it in open_items instead of doing it.

GOAL: Add rate limiting to the public API endpoints.
ACCEPTANCE CRITERIA:
- Requests over 100/min per API key get HTTP 429 with a Retry-After header.
- Limits configurable via RATE_LIMIT_* env vars; defaults in config/defaults.ts.
- Unit tests cover the limiter; existing tests still pass.
SCOPE: src/middleware/, src/config/, tests/middleware/.
CONVENTIONS: Follow the existing middleware pattern in src/middleware/auth.ts.
VERIFY WITH: npm test && npm run lint
```

## Mode 2 — Execute a plan

For a multi-step plan (yours or the user's), you become the foreman: break the
plan into tickets and run the Mode 1 loop per ticket.

- **Dependent steps** → one session: dispatch step 1, review it, then
  `--resume-id` for step 2 so Codex keeps the mental model it just built. The
  sandbox mode carries over on resume; keep passing the same `--cd` every time
  (the wrapper re-enters the project so the write scope stays put).
- **Independent steps** → separate fresh sessions, one at a time — same-tree
  parallel dispatches produce colliding diffs you can't attribute.
- **Chunk the work.** A ticket should be one reviewable unit (roughly ≤ 25
  minutes of Codex work). Very long single runs are where sessions degrade and
  diffs become unreviewable — more, smaller tickets beat one giant one.
- **Never dispatch step N+1 on an unreviewed step N.** An error that survives a
  checkpoint compounds into every later step. Review checkpoints are where the
  manager earns their keep.
- Between steps, briefly tell the user where the plan stands: steps landed,
  step in flight, anything reordered and why.

## More detail

`references/codex-cli.md` has the full `codex exec` flag reference for
implementation runs (sandbox modes, network config, JSON event shapes, resume
mechanics) and troubleshooting (auth, sandbox denials, network-blocked installs,
git quirks). Read it only if the wrapper misbehaves or you need a flag the
wrapper doesn't expose.
