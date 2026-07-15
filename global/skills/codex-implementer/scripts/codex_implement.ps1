<#
.SYNOPSIS
  Dispatch an implementation task to OpenAI Codex headlessly and return its report.

.DESCRIPTION
  Thin, robust wrapper around `codex exec`. Builds a non-interactive invocation
  with a workspace-write sandbox (Codex edits files under -Cd but can't escape
  it; network off unless -AllowNetwork), feeds the prompt (and optional context)
  entirely via stdin so no shell quoting can break it, captures Codex's final
  message cleanly, and prints the Codex session id so the caller can resume the
  same session for fix rounds or the next step of a plan.

  Prints to stdout:
    <Codex's final report>
    __CODEX_SESSION__:<session-id>      (last line; id is empty if it could not be parsed)

  Exits non-zero (with Codex's stderr on the error stream) if the call fails.

.PARAMETER Prompt        Ticket text for Codex (alternative to -PromptFile).
.PARAMETER PromptFile    File containing the ticket text.
.PARAMETER Context       Extra context (plan/spec/notes) appended to the ticket.
.PARAMETER ContextFile   File containing that context.
.PARAMETER Cd            Working directory Codex works in (its write scope). Default: current dir.
.PARAMETER Effort        Reasoning effort: low|medium|high|xhigh|max. Default (canonical): xhigh.
.PARAMETER Model         Codex model. Default (canonical): gpt-5.6-sol.
.PARAMETER ResumeId      Resume an existing Codex session (fix rounds / next plan step).
.PARAMETER AllowNetwork  Enable network inside the sandbox (npm/pip installs). Off by default.
.PARAMETER OutputSchema  JSON Schema file; forces Codex's final message to match it
                         (e.g. references/report.schema.json for a structured report).
#>
[CmdletBinding()]
param(
    [string]$Prompt,
    [string]$PromptFile,
    [string]$Context,
    [string]$ContextFile,
    [string]$Cd = (Get-Location).Path,
    # Canonical defaults; SKILL.md / references only describe them.
    [ValidateSet('low','medium','high','xhigh','max')]
    [string]$Effort = 'xhigh',
    [string]$Model = 'gpt-5.6-sol',
    [string]$ResumeId,
    [switch]$AllowNetwork,
    [string]$OutputSchema
)

$ErrorActionPreference = 'Stop'

# --- Resolve prompt + context into one stdin payload (no argv quoting risk) ---
if ($PromptFile) {
    if (-not (Test-Path $PromptFile)) { Write-Error "PromptFile not found: $PromptFile"; exit 2 }
    $Prompt = Get-Content -Raw -Path $PromptFile
}
if (-not $Prompt) { Write-Error "Provide -Prompt or -PromptFile."; exit 2 }

if ($ContextFile) {
    if (-not (Test-Path $ContextFile)) { Write-Error "ContextFile not found: $ContextFile"; exit 2 }
    $Context = Get-Content -Raw -Path $ContextFile
}

$payload = $Prompt
if ($Context) {
    $payload = $Prompt + "`n`n--- CONTEXT (plan / spec / supporting material) ---`n" + $Context
}

# --- Build the codex exec argument list -------------------------------------
# `resume` inherits the original session's sandbox mode but rejects -s/-C and
# derives the *workspace root from the process cwd* — so we cd into $Cd for
# every call (harmless on fresh calls, essential on resume, or the resumed
# session treats the caller's cwd as the project and rejects writes).
Set-Location $Cd
$outFile = [System.IO.Path]::GetTempFileName()
if ($ResumeId) {
    $cliArgs = @('exec', 'resume', $ResumeId, '--json', '--skip-git-repo-check')
} else {
    $cliArgs = @('exec', '--json', '-s', 'workspace-write', '--skip-git-repo-check', '-C', $Cd)
}
$cliArgs += @('-c', "model_reasoning_effort=$Effort", '-o', $outFile)
# Network stays off by default; opt in only for tickets that need installs.
if ($AllowNetwork) { $cliArgs += @('-c', 'sandbox_workspace_write.network_access=true') }
if ($Model) { $cliArgs += @('-m', $Model) }
if ($OutputSchema) { $cliArgs += @('--output-schema', $OutputSchema) }
$cliArgs += '-'   # read the prompt from stdin

# --- Invoke ------------------------------------------------------------------
$errFile = [System.IO.Path]::GetTempFileName()
$stdout = $payload | & codex @cliArgs 2>$errFile
$exit = $LASTEXITCODE

if ($exit -ne 0) {
    Write-Error ("codex exec failed (exit $exit):`n" + (Get-Content -Raw -Path $errFile))
    if ($outFile) { Remove-Item $outFile -ErrorAction SilentlyContinue }
    Remove-Item $errFile -ErrorAction SilentlyContinue
    exit $exit
}

# --- Parse the JSONL event stream for session id and (if resuming) message ---
$session = ''
$jsonMessage = $null
foreach ($line in ($stdout -split "`r?`n")) {
    if (-not $line.Trim()) { continue }
    try { $ev = $line | ConvertFrom-Json -ErrorAction Stop } catch { continue }
    if ($ev.type -eq 'thread.started') {
        if ($ev.thread_id)     { $session = $ev.thread_id }
        elseif ($ev.thread.id) { $session = $ev.thread.id }
    }
    if ($ev.type -eq 'item.completed' -and
        ($ev.item.type -eq 'agent_message' -or $ev.item.item_type -eq 'agent_message')) {
        if ($ev.item.text)        { $jsonMessage = $ev.item.text }
        elseif ($ev.item.content) { $jsonMessage = $ev.item.content }
    }
}

# --- Resolve the final message ----------------------------------------------
$message = $null
if ($outFile -and (Test-Path $outFile)) {
    $message = (Get-Content -Raw -Path $outFile).TrimEnd()
}
if (-not $message) { $message = $jsonMessage }            # resume path, or -o empty
if (-not $message) { $message = $stdout.Trim() }          # last-ditch fallback

# --- Emit --------------------------------------------------------------------
Write-Output $message
Write-Output "__CODEX_SESSION__:$session"

if ($outFile) { Remove-Item $outFile -ErrorAction SilentlyContinue }
Remove-Item $errFile -ErrorAction SilentlyContinue
