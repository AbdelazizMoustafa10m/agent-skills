# `codex exec` reference (headless mode)

Load this only when the wrapper script misbehaves or you need a flag it doesn't
expose. The wrapper (`scripts/codex_consult.sh` / `.ps1`) already handles the
common path. Verified against `codex-cli` 0.144.4 on July 14, 2026.

## Invocation

```
codex exec [OPTIONS] [PROMPT]
codex exec [OPTIONS] resume [SESSION_ID|--last] [PROMPT]
codex exec [OPTIONS] review        # built-in code review against the current repo
```

- Prompt is the positional `[PROMPT]`, or read from **stdin** when omitted or when
  the prompt is the literal `-`.
- If stdin is piped *and* a positional prompt is given, stdin is appended to the
  prompt as a `<stdin>` block. (The wrapper sidesteps this by sending everything
  through stdin with a `-` prompt, so quoting can never break.)

## Flags that matter for a read-only advisor

| Flag | Meaning |
|------|---------|
| `-s, --sandbox <read-only\|workspace-write\|danger-full-access>` | Permission for model-run commands. Use **`read-only`** — a reviewer never writes. |
| `--skip-git-repo-check` | Allow running outside a git repo. Needed in your home dir and other non-repo paths; harmless inside a repo, so always pass it. |
| `-C, --cd <DIR>` | Directory Codex treats as its working root (what it can read). |
| `--add-dir <DIR>` | Extra readable directory alongside the workspace. |
| `-m, --model <MODEL>` | Select the model. The wrapper defaults to `gpt-5.6-sol`; pass this flag to override it. |
| `-c, --config <key=value>` | Override config. Used by the wrapper as `-c model_reasoning_effort=<low\|medium\|high\|xhigh\|max>`. Value parses as TOML. |
| `-o, --output-last-message <FILE>` | Write just the final answer to a file (clean capture). Supported by both `exec` and `exec resume` in this version. |
| `--json` | Emit a JSONL event stream on stdout (used to read the session id). |
| `--output-schema <FILE>` | Force the final message to match a JSON Schema. Mode 2 uses this with the bundled `references/verdict.schema.json` to get a structured `{verdict, summary, issues[]}` object (more reliable than scraping a text line). The wrapper exposes it as `--output-schema` / `-OutputSchema`. |
| `--ephemeral` | Don't persist session files. (Omit when you want `resume` to work.) |
| `-i, --image <FILE>` | Attach image(s) to the prompt. |

There is **no `-a/--ask-for-approval` on `codex exec`** in this version — exec is
non-interactive by design, and `read-only` can't do anything needing approval.
Older web docs showing `-a never` are stale; don't add it.

## JSONL event shapes (stdout under `--json`)

One JSON object per line. The ones the wrapper reads:

```json
{"type":"thread.started","thread_id":"<uuid>"}
{"type":"turn.started"}
{"type":"item.completed","item":{"type":"agent_message","text":"<the answer>"}}
{"type":"turn.completed","usage":{"input_tokens":1234,"output_tokens":567}}
```

Field names have drifted across versions; the wrapper checks `thread_id` /
`thread.id` for the session and `item.text` / `item.content` for the message, and
falls back to the `-o` file. If you parse manually, be similarly defensive.

## Resume (iterative review)

```
codex exec resume <SESSION_ID> --json --skip-git-repo-check -o result.txt -
codex exec resume --last       --json --skip-git-repo-check -o result.txt -
```

Resuming reopens the prior session so Codex remembers what it already flagged and
can verify your fixes. Prefer resuming **by id** (captured from the first call's
`__CODEX_SESSION__:` line) over `--last` — `--last` grabs the most recent session
globally, which is wrong if other Codex sessions are running. Note `resume` does
**not** accept `-s/--sandbox` or `-C/--cd` (it inherits the original session's
sandbox and working dir); passing them errors with `unexpected argument`. It does
accept `-o`, so the wrapper captures the final message cleanly there too.

## Capturing output by hand

- Final answer only → `-o result.txt` (then read the file).
- Full event stream → `--json` on stdout (progress events go to **stderr** in
  non-JSON mode; the final message goes to stdout).
- Pipe context in → `git diff | codex exec -s read-only --skip-git-repo-check "review this diff"`.

## Troubleshooting

- **"Not inside a trusted directory" / git errors** → add `--skip-git-repo-check`
  (the wrapper always does).
- **Auth failures** → `codex login` (this machine uses CLI auth in
  `~/.codex/auth.json`; no API key env var is required). A one-off key override is
  `CODEX_API_KEY=… codex exec …`.
- **Very slow responses are expected** → the wrapper defaults to
  `gpt-5.6-sol` with `max` reasoning because a second opinion is worth the wait.
  For a faster, shallower answer pass `--effort medium`, `high`, or `xhigh`.
- **Garbled multi-line prompt** → never inline a diff into the shell; always use
  `--prompt-file`/`--context-file` (or the `.ps1` equivalents) so it travels via stdin.
- **macOS/Linux** → the wrapper is `scripts/codex_consult.sh`; ensure it's
  executable (`chmod +x`). macOS has no `timeout(1)` by default — bound a run from
  the caller, or install coreutils for `gtimeout`.
- **Windows** → Codex runs natively in PowerShell; `powershell_utf8 = true` is set
  in config, so UTF-8 output is handled.

## Sources

- OpenAI Codex Manual — [Models](https://learn.chatgpt.com/docs/models.md)
  (`gpt-5.6-sol` recommendations and Max reasoning guidance).
- OpenAI Developers — Codex CLI command-line options & non-interactive mode.
- `codex exec --help` (codex-cli 0.144.4, the installed version on July 14, 2026).
