#!/usr/bin/env bash
# Agent Skills Sync — Setup Script
# Creates symlinks from each project's agent directories to this unified skills repo.
#
# One canonical copy of each skill, shared across all coding agents
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
err()  { printf "${RED}[ERR]${RESET}   %s\n" "$1"; }

# Agent directories that support the open skills standard
AGENT_DIRS=(".claude" ".codex" ".copilot" ".opencode" ".agent" ".factory" ".agents" ".gemini" ".github")

# Global agent home directories (user-level skills)
GLOBAL_AGENT_HOMES=("$HOME/.claude" "$HOME/.codex" "$HOME/.gemini")

# Project definitions: name|path|scope
PROJECTS=(
  "finvault|$HOME/prj/prod/finvault|finvault"
  "harvx|$HOME/prj/prod/harvx|harvx"
  "raven|$HOME/prj/prod/raven|raven"
)

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║   Agent Skills Sync — Setup              ║"
echo "╚══════════════════════════════════════════╝"
echo ""
info "Skills repo: $REPO_DIR"
echo ""

link_count=0
skip_count=0

# Helper: link skills from a scope dir into a target skills/ directory
# Usage: link_skills <scope_dir> <skills_dir> <label>
link_skills() {
  local scope_dir="$1"
  local skills_dir="$2"
  local label="$3"

  mkdir -p "$skills_dir"

  local skills=()
  for skill_dir in "$scope_dir"/*/; do
    [ -f "$skill_dir/SKILL.md" ] && skills+=("$(basename "$skill_dir")")
  done

  if [ ${#skills[@]} -eq 0 ]; then
    return
  fi

  for skill_name in "${skills[@]}"; do
    local repo_skill="$scope_dir/$skill_name"
    local target_link="$skills_dir/$skill_name"

    # Already a correct symlink?
    if [ -L "$target_link" ]; then
      local current
      current="$(readlink "$target_link")"
      if [ "$current" = "$repo_skill" ]; then
        skip_count=$((skip_count + 1))
        continue
      fi
      rm "$target_link"
    fi

    # Backup existing dir/file
    if [ -e "$target_link" ]; then
      local backup="${target_link}.bak.$(date +%Y%m%d%H%M%S)"
      mv "$target_link" "$backup"
      info "  $label/$skill_name — backed up existing"
    fi

    ln -s "$repo_skill" "$target_link"
    link_count=$((link_count + 1))
  done
}

# ═══════════════════════════════════════════
#  Global (user-level) skills
# ═══════════════════════════════════════════
GLOBAL_DIR="$REPO_DIR/global"

if [ -d "$GLOBAL_DIR" ] && [ -n "$(find "$GLOBAL_DIR" -maxdepth 2 -name SKILL.md 2>/dev/null)" ]; then
  echo -e "${CYAN}── global ${DIM}(user-level skills → ~/.claude, ~/.codex, ~/.gemini)${RESET}"

  for agent_home in "${GLOBAL_AGENT_HOMES[@]}"; do
    [ ! -d "$agent_home" ] && continue
    agent_name="$(basename "$agent_home")"
    skills_dir="$agent_home/skills"
    link_skills "$GLOBAL_DIR" "$skills_dir" "$agent_name/skills"
    linked=$(find "$skills_dir" -maxdepth 1 -type l 2>/dev/null | wc -l | tr -d ' ')
    echo -e "  ${GREEN}✓${RESET} ~/$agent_name/skills/ — $linked skills linked"
  done

  echo ""
fi

# ═══════════════════════════════════════════
#  Project-level skills
# ═══════════════════════════════════════════
for project_def in "${PROJECTS[@]}"; do
  IFS='|' read -r name project_path scope <<< "$project_def"

  if [ ! -d "$project_path" ]; then
    warn "$name — project dir not found ($project_path), skipping"
    continue
  fi

  echo -e "${CYAN}── $name ${DIM}($project_path)${RESET}"

  scope_dir="$REPO_DIR/$scope"
  if [ ! -d "$scope_dir" ]; then
    warn "$name — no skills scope dir ($scope), skipping"
    continue
  fi

  # Check there are skills
  if [ -z "$(find "$scope_dir" -maxdepth 2 -name SKILL.md 2>/dev/null)" ]; then
    warn "$name — no skills found in $scope/"
    continue
  fi

  for agent_dir_name in "${AGENT_DIRS[@]}"; do
    agent_dir="$project_path/$agent_dir_name"

    # Only process agent dirs that exist in the project
    [ ! -d "$agent_dir" ] && continue

    skills_dir="$agent_dir/skills"
    link_skills "$scope_dir" "$skills_dir" "$agent_dir_name/skills"

    # Count linked skills for this agent dir
    linked=$(find "$skills_dir" -maxdepth 1 -type l 2>/dev/null | wc -l | tr -d ' ')
    echo -e "  ${GREEN}✓${RESET} $agent_dir_name/skills/ — $linked skills linked"
  done

  echo ""
done

echo "Done! Created $link_count new links ($skip_count already up-to-date)."
echo ""
echo "Workflow:"
echo "  1. Edit skills in ~/prj/agent-skills/ — all agents see the change instantly"
echo "  2. Run 'agent-sync push' to sync across machines"
echo "  3. Run 'agent-sync pull' + './setup.sh' on the other machine"
echo ""
