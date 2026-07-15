#!/usr/bin/env bash
# Dispatch an implementation task to OpenAI Codex headlessly and return its report.
#
# Thin, robust wrapper around `codex exec`. Workspace-write sandbox (Codex edits
# files under --cd but can't escape it; network off unless --allow-network),
# prompt fed via stdin (no argv quoting traps), final message captured cleanly,
# and the Codex session id printed last so the caller can resume the session
# for fix rounds or the next step of a plan.
#
# Prints to stdout:
#   <Codex's final report>
#   __CODEX_SESSION__:<session-id>   (last line; empty if it could not be parsed)
#
# Usage:
#   codex_implement.sh --prompt-file P [--context-file C] [--cd DIR]
#                      [--effort low|medium|high|xhigh|max] [--model M]
#                      [--resume-id ID] [--allow-network] [--output-schema FILE]
#   (--prompt "text" and --context "text" also accepted)
set -euo pipefail

# MODEL and EFFORT are the canonical defaults; SKILL.md / references only describe
# them. xhigh is the workhorse setting — deep enough for real features without
# max-tier latency on every dispatch.
PROMPT="" PROMPT_FILE="" CONTEXT="" CONTEXT_FILE=""
CD="$(pwd)" EFFORT="xhigh" MODEL="gpt-5.6-sol" RESUME_ID="" OUTPUT_SCHEMA=""
ALLOW_NETWORK=false

while [ $# -gt 0 ]; do
  case "$1" in
    --prompt)        PROMPT="$2"; shift 2;;
    --prompt-file)   PROMPT_FILE="$2"; shift 2;;
    --context)       CONTEXT="$2"; shift 2;;
    --context-file)  CONTEXT_FILE="$2"; shift 2;;
    --cd)            CD="$2"; shift 2;;
    --effort)        EFFORT="$2"; shift 2;;
    --model)         MODEL="$2"; shift 2;;
    --resume-id)     RESUME_ID="$2"; shift 2;;
    --allow-network) ALLOW_NETWORK=true; shift;;
    --output-schema) OUTPUT_SCHEMA="$2"; shift 2;;
    *) echo "Unknown arg: $1" >&2; exit 2;;
  esac
done

case "$EFFORT" in
  low|medium|high|xhigh|max) ;;
  *) echo "Invalid effort: $EFFORT (expected low, medium, high, xhigh, or max)" >&2; exit 2;;
esac

[ -n "$PROMPT_FILE" ] && PROMPT="$(cat "$PROMPT_FILE")"
[ -n "$PROMPT" ] || { echo "Provide --prompt or --prompt-file." >&2; exit 2; }
[ -n "$CONTEXT_FILE" ] && CONTEXT="$(cat "$CONTEXT_FILE")"

PAYLOAD="$PROMPT"
[ -n "$CONTEXT" ] && PAYLOAD="$PROMPT

--- CONTEXT (plan / spec / supporting material) ---
$CONTEXT"

# Build argument list. `resume` inherits the original session's sandbox mode but
# rejects -s/-C and derives the *workspace root from the process cwd* — so we cd
# into $CD for every call (harmless on fresh calls, essential on resume, or the
# resumed session treats the caller's cwd as the project and rejects writes).
OUT_FILE="$(mktemp)"
cd "$CD"
if [ -n "$RESUME_ID" ]; then
  args=(exec resume "$RESUME_ID" --json --skip-git-repo-check)
else
  args=(exec --json -s workspace-write --skip-git-repo-check -C "$CD")
fi
args+=(-c "model_reasoning_effort=$EFFORT" -o "$OUT_FILE")
# Network stays off by default; opt in only for tickets that need installs.
$ALLOW_NETWORK && args+=(-c "sandbox_workspace_write.network_access=true")
[ -n "$MODEL" ] && args+=(-m "$MODEL")
[ -n "$OUTPUT_SCHEMA" ] && args+=(--output-schema "$OUTPUT_SCHEMA")
args+=(-)   # read prompt from stdin

STDOUT="$(printf '%s' "$PAYLOAD" | codex "${args[@]}")" || {
  code=$?; echo "codex exec failed (exit $code)" >&2
  [ -n "$OUT_FILE" ] && rm -f "$OUT_FILE"; exit $code; }

# Session id from the thread.started event (jq if available, else grep).
SESSION=""
if command -v jq >/dev/null 2>&1; then
  SESSION="$(printf '%s\n' "$STDOUT" | jq -r 'select(.type=="thread.started") | (.thread_id // .thread.id) // empty' 2>/dev/null | head -n1)"
else
  SESSION="$(printf '%s\n' "$STDOUT" | grep -o '"thread_id":"[^"]*"' | head -n1 | sed 's/.*:"//;s/"//')"
fi

# Final message: prefer the clean -o capture; fall back to the json agent_message.
MESSAGE=""
if [ -n "$OUT_FILE" ] && [ -s "$OUT_FILE" ]; then
  MESSAGE="$(cat "$OUT_FILE")"
elif command -v jq >/dev/null 2>&1; then
  MESSAGE="$(printf '%s\n' "$STDOUT" | jq -r 'select(.type=="item.completed") | select(.item.type=="agent_message") | .item.text' 2>/dev/null | tail -n1)"
fi
[ -n "$MESSAGE" ] || MESSAGE="$STDOUT"

printf '%s\n' "$MESSAGE"
printf '__CODEX_SESSION__:%s\n' "$SESSION"
[ -n "$OUT_FILE" ] && rm -f "$OUT_FILE"
