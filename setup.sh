#!/usr/bin/env bash
# Agent Assets Sync — Setup Script
# Creates symlinks for skills, agents, and commands from this unified repo
# into each project's agent directories and user-level agent homes.
#
# One canonical copy of each asset, shared across all coding agents
# (Claude Code, Codex CLI, Gemini CLI, Copilot, OpenCode, etc.)
#
# Usage:
#   cd ~/prj/agent-skills && ./setup.sh

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
DIM='\033[2m'
RESET='\033[0m'

log()  { printf "${GREEN}[OK]${RESET}    %s\n" "$1"; }
warn() { printf "${YELLOW}[SKIP]${RESET}  %s\n" "$1"; }
info() { printf "${CYAN}[INFO]${RESET}  %s\n" "$1"; }

# Agent directories within projects that support the open standards
AGENT_DIRS=(".claude" ".codex" ".copilot" ".opencode" ".agent" ".factory" ".agents" ".gemini" ".github")

# Global agent home directories (user-level)
GLOBAL_AGENT_HOMES=("$HOME/.claude" "$HOME/.codex" "$HOME/.gemini")

# Project definitions: name|path|scope
PROJECTS=(
  "finvault|$HOME/prj/prod/finvault|finvault"
  "harvx|$HOME/prj/prod/harvx|harvx"
  "raven|$HOME/prj/prod/raven|raven"
  "planora|$HOME/prj/planora|global"
)

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║   Agent Assets Sync — Setup              ║"
echo "╚══════════════════════════════════════════╝"
echo ""
info "Repo: $REPO_DIR"
echo ""

link_count=0
skip_count=0

# ─────────────────────────────────────────────────
# Helper: link a single item (file or directory)
# Usage: link_one <source> <target>
# ─────────────────────────────────────────────────
link_one() {
  local source="$1"
  local target="$2"

  if [ -L "$target" ]; then
    local current
    current="$(readlink "$target")"
    if [ "$current" = "$source" ]; then
      skip_count=$((skip_count + 1))
      return
    fi
    rm "$target"
  fi

  if [ -e "$target" ]; then
    local backup="${target}.bak.$(date +%Y%m%d%H%M%S)"
    mv "$target" "$backup"
  fi

  mkdir -p "$(dirname "$target")"
  ln -s "$source" "$target"
  link_count=$((link_count + 1))
}

# ─────────────────────────────────────────────────
# Link skills: each skill is a directory with SKILL.md
# Usage: link_skills <scope_dir>/skills  <target_skills_dir>
# ─────────────────────────────────────────────────
link_skills() {
  local source_dir="$1"
  local target_dir="$2"
  [ ! -d "$source_dir" ] && return

  mkdir -p "$target_dir"
  for skill in "$source_dir"/*/; do
    [ -f "$skill/SKILL.md" ] || continue
    link_one "$skill" "$target_dir/$(basename "$skill")"
  done
}

# ─────────────────────────────────────────────────
# Link agents/commands: each is a .md file
# Usage: link_md_files <scope_dir>/agents  <target_agents_dir>
# ─────────────────────────────────────────────────
link_md_files() {
  local source_dir="$1"
  local target_dir="$2"
  [ ! -d "$source_dir" ] && return

  local has_files=false
  for f in "$source_dir"/*.md; do
    [ -f "$f" ] && has_files=true && break
  done
  [ "$has_files" = true ] || return 0

  mkdir -p "$target_dir"
  for f in "$source_dir"/*.md; do
    [ -f "$f" ] || continue
    link_one "$f" "$target_dir/$(basename "$f")"
  done
}

# ─────────────────────────────────────────────────
# Count symlinks in a directory
# ─────────────────────────────────────────────────
count_links() {
  find "$1" -maxdepth 1 -type l 2>/dev/null | wc -l | tr -d ' '
}

# ═══════════════════════════════════════════
#  Global (user-level) assets
# ═══════════════════════════════════════════
GLOBAL_DIR="$REPO_DIR/global"

has_global=false
for type in skills commands; do
  if [ -d "$GLOBAL_DIR/$type" ] && [ -n "$(ls -A "$GLOBAL_DIR/$type" 2>/dev/null)" ]; then
    has_global=true
    break
  fi
done

if $has_global; then
  echo -e "${CYAN}── global ${DIM}(user-level → ~/.claude, ~/.codex, ~/.gemini)${RESET}"

  for agent_home in "${GLOBAL_AGENT_HOMES[@]}"; do
    [ ! -d "$agent_home" ] && continue
    agent_name="$(basename "$agent_home")"

    link_skills    "$GLOBAL_DIR/skills"   "$agent_home/skills"
    link_md_files  "$GLOBAL_DIR/commands" "$agent_home/commands"

    summary=""
    for type in skills commands; do
      [ -d "$agent_home/$type" ] || continue
      n=$(count_links "$agent_home/$type")
      if [ "$n" -gt 0 ]; then
        summary="${summary:+$summary, }$n $type"
      fi
    done
    if [ -n "$summary" ]; then
      echo -e "  ${GREEN}✓${RESET} ~/$agent_name/ — $summary"
    fi
  done
  echo ""
fi

# ═══════════════════════════════════════════
#  Project-level assets
# ═══════════════════════════════════════════
for project_def in "${PROJECTS[@]}"; do
  IFS='|' read -r name project_path scope <<< "$project_def"

  if [ ! -d "$project_path" ]; then
    warn "$name — project dir not found ($project_path), skipping"
    continue
  fi

  scope_dir="$REPO_DIR/$scope"
  if [ ! -d "$scope_dir" ]; then
    warn "$name — no scope dir ($scope), skipping"
    continue
  fi

  echo -e "${CYAN}── $name ${DIM}($project_path)${RESET}"

  for agent_dir_name in "${AGENT_DIRS[@]}"; do
    agent_dir="$project_path/$agent_dir_name"
    [ ! -d "$agent_dir" ] && continue

    link_skills    "$scope_dir/skills"   "$agent_dir/skills"
    link_md_files  "$scope_dir/commands" "$agent_dir/commands"

    summary=""
    for type in skills commands; do
      [ -d "$agent_dir/$type" ] || continue
      n=$(count_links "$agent_dir/$type")
      if [ "$n" -gt 0 ]; then
        summary="${summary:+$summary, }$n $type"
      fi
    done
    if [ -n "$summary" ]; then
      echo -e "  ${GREEN}✓${RESET} $agent_dir_name/ — $summary"
    fi
  done

  echo ""
done

echo "Done! Created $link_count new links ($skip_count already up-to-date)."
echo ""
echo "Workflow:"
echo "  1. Edit assets in ~/prj/agent-skills/ — all agents see changes instantly"
echo "  2. Run 'agent-sync push' to sync across machines"
echo "  3. Run 'agent-sync pull' on the other machine"
echo ""
