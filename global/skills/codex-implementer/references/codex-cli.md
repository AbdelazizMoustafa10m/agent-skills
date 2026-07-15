# `codex exec` reference (headless implementation runs)

Load this only when the wrapper script misbehaves or you need a flag it doesn't
expose. The wrapper (`scripts/codex_implement.sh` / `.ps1`) already handles the
common path. Verified against `codex-cli` 0.144.4 on July 14, 2026.

## Invocation

```
codex exec [OPTIONS] [PROMPT]
codex exec [OPTIONS] resume [SESSION_ID|--last] [PROMPT]
```

- Prompt is the positional `[PROMPT]`, or read from **stdin** when omitted or when
  the prompt is the literal `-`.
- If stdin is piped *and* a positional prompt is given, stdin is appended to the
  prompt as a `<stdin>` block. (The wrapper sidesteps this by sending everything
  through stdin with a `-` prompt, so quoting can never break.)

## Flags that matter for a writing worker

| Flag | Meaning |
|------|---------|
| `-s, --sandbox <read-only\|workspace-write\|danger-full-access>` | Permission for model-run commands. Use **`workspace-write`** — Codex can edit files and run commands under the working root, but can't escape it. Don't reach for `danger-full-access`; if a task seems to need it, the scope is wrong. |
| `-c sandbox_workspace_write.network_access=true` | Network inside the sandbox is **off by default**. Add this (wrapper: `--allow-network` / `-AllowNetwork`) only for tickets that genuinely need installs. Opening one flag is safer than loosening the sandbox. |
| `--skip-git-repo-check` | Allow running outside a git repo. Harmless inside a repo, so always pass it. |
| `-C, --cd <DIR>` | Directory Codex treats as its working root — both its read scope and its **write scope**. Point it at the project root, not `/`. |
| `--add-dir <DIR>` | Extra writable directory alongside the workspace. |
| `-m, --model <MODEL>` | Select the model. The wrapper defaults to `gpt-5.6-sol`; pass this flag to override it. |
| `-c, --config <key=value>` | Override config. Used by the wrapper as `-c model_reasoning_effort=<low\|medium\|high\|xhigh\|max>`. Value parses as TOML. |
| `-o, --output-last-message <FILE>` | Write just the final answer to a file (clean capture). Supported by both `exec` and `exec resume` in this version. |
| `--json` | Emit a JSONL event stream on stdout (used to read the session id). |
| `--output-schema <FILE>` | Force the final message to match a JSON Schema. Used with the bundled `references/report.schema.json` to get a structured `{status, summary, changes[], commands_run[], open_items[]}` report the caller can cross-check against the diff. |
| `--ephemeral` | Don't persist session files. (Omit — you want `resume` to work for fix rounds.) |
| `-i, --image <FILE>` | Attach image(s) to the prompt (e.g. a mockup to implement). |

There is **no `-a/--ask-for-approval` on `codex exec`** in this version — exec is
non-interactive by design; the sandbox is the only guardrail. That's exactly why
the sandbox choice matters: nothing will ask you before a command runs. Older web
docs showing `--full-auto` / `-a never` are stale for this version; don't add them.

## AGENTS.md

Codex reads the repo's `AGENTS.md` (not `CLAUDE.md`) and applies it to the run.
If the repo keeps its conventions in `CLAUDE.md` only, either symlink
`AGENTS.md → CLAUDE.md` or restate the conventions that matter in the ticket.
Conventions Codex never sees are conventions it won't follow.

## JSONL event shapes (stdout under `--json`)

One JSON object per line. The ones the wrapper reads:

```json
{"type":"thread.started","thread_id":"<uuid>"}
{"type":"turn.started"}
{"type":"item.completed","item":{"type":"agent_message","text":"<the report>"}}
{"type":"turn.completed","usage":{"input_tokens":1234,"output_tokens":567}}
```

Field names have drifted across versions; the wrapper checks `thread_id` /
`thread.id` for the session and `item.text` / `item.content` for the message, and
falls back to the `-o` file. If you parse manually, be similarly defensive.

## Success is three signals, not one

A dispatch "worked" only when all three hold — any one alone lies:

1. **Exit code 0** — the process didn't die (but exit 0 with no edits happens).
2. **A coherent final report** — the `-o` capture / schema output parses and
   claims specific changes (but Codex can misreport what it did).
3. **The diff agrees** — `git status` / `git diff` shows real changes matching
   the report's `changes[]` and the ticket's scope.

Cross-check 2 against 3 every time. Files touched outside the declared scope are
a finding, not a footnote.

## Resume (fix rounds and multi-step plans)

```
codex exec resume <SESSION_ID> --json --skip-git-repo-check -o result.txt -
```

Resuming reopens the prior session so Codex remembers what it built and why —
use it to send a fix list after your review, or the next step of a plan. Prefer
resuming **by id** (captured from the first call's `__CODEX_SESSION__:` line)
over `--last` — `--last` grabs the most recent session globally, which is wrong
if other Codex sessions are running.

Two resume quirks, both verified on 0.144.4:

- `resume` does **not** accept `-s/--sandbox` or `-C/--cd` (passing them errors
  with `unexpected argument`). The sandbox **mode** carries over, so a session
  opened workspace-write stays writable.
- But the **workspace root does not carry over** — the resumed process derives
  the project boundary from its *current working directory*. Resume from the
  wrong cwd and Codex rejects edits with `patch rejected: writing outside of
  the project`, even though the sandbox is writable. The wrapper guards this by
  `cd`-ing into `--cd` before every invocation — so keep passing the same
  `--cd` on resume calls.

`resume` does accept `-o`, so the wrapper captures the final message cleanly
there too.

Keep single runs bounded: prefer tickets of roughly ≤ 25 minutes of work and
chain them via resume, rather than one giant run — very long sessions are where
resumes go stale and diffs stop being reviewable.

## Git hygiene

- Snapshot `git status` **before** dispatching; otherwise you can't attribute
  the diff. Prefer a clean tree or a dedicated branch for sizable tickets.
- Tell Codex **not to commit** in every ticket. workspace-write can technically
  write to `.git`, so the rule lives in the ticket; the orchestrator owns
  commits, branches, and pushes.
- Don't run two dispatches against the same tree concurrently — colliding diffs
  can't be attributed or reviewed. Sequential tickets, or separate worktrees.

## Troubleshooting

- **"Not inside a trusted directory" / git errors** → add `--skip-git-repo-check`
  (the wrapper always does).
- **Auth failures** → `codex login` (this machine uses CLI auth in
  `~/.codex/auth.json`; no API key env var is required). A one-off key override is
  `CODEX_API_KEY=… codex exec …`.
- **`npm install` / `pip install` fails inside the run** → network is off by
  default in workspace-write. Re-dispatch with `--allow-network`, or run the
  install yourself and resume the session.
- **Codex reports edits but the tree is clean** → it probably ran against the
  wrong root; check the `--cd` you passed. This is why signal 3 (the diff) is
  checked every time.
- **Long runs** → implementation at `xhigh` takes minutes to tens of minutes;
  that's expected. macOS has no `timeout(1)` by default — bound a run from the
  caller, or install coreutils for `gtimeout`.
- **Garbled multi-line prompt** → never inline a ticket into the shell; always use
  `--prompt-file`/`--context-file` (or the `.ps1` equivalents) so it travels via stdin.
- **macOS/Linux** → the wrapper is `scripts/codex_implement.sh`; ensure it's
  executable (`chmod +x`).
- **Windows** → Codex runs natively in PowerShell; `powershell_utf8 = true` is set
  in config, so UTF-8 output is handled.

## Sources

- OpenAI Codex Manual — [Models](https://learn.chatgpt.com/docs/models.md)
  (`gpt-5.6-sol` recommendations and reasoning-effort guidance).
- OpenAI Developers — Codex CLI command-line options, non-interactive mode, and
  sandbox configuration (`sandbox_workspace_write.network_access`).
- `codex exec --help` (codex-cli 0.144.4, the installed version on July 14, 2026).
