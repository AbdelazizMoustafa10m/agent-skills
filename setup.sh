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

  # Get list of skills (subdirectories with SKILL.md)
  skills=()
  for skill_dir in "$scope_dir"/*/; do
    [ -f "$skill_dir/SKILL.md" ] && skills+=("$(basename "$skill_dir")")
  done

  if [ ${#skills[@]} -eq 0 ]; then
    warn "$name — no skills found in $scope/"
    continue
  fi

  for agent_dir_name in "${AGENT_DIRS[@]}"; do
    agent_dir="$project_path/$agent_dir_name"

    # Only process agent dirs that exist in the project
    [ ! -d "$agent_dir" ] && continue

    # Create skills/ subdirectory if it doesn't exist
    skills_dir="$agent_dir/skills"
    mkdir -p "$skills_dir"

    for skill_name in "${skills[@]}"; do
      repo_skill="$scope_dir/$skill_name"
      target_link="$skills_dir/$skill_name"

      # Already a correct symlink?
      if [ -L "$target_link" ]; then
        current="$(readlink "$target_link")"
        if [ "$current" = "$repo_skill" ]; then
          skip_count=$((skip_count + 1))
          continue
        fi
        # Wrong symlink — remove and re-link
        rm "$target_link"
      fi

      # Backup existing dir/file
      if [ -e "$target_link" ]; then
        backup="${target_link}.bak.$(date +%Y%m%d%H%M%S)"
        mv "$target_link" "$backup"
        info "  $agent_dir_name/skills/$skill_name — backed up existing"
      fi

      ln -s "$repo_skill" "$target_link"
      link_count=$((link_count + 1))
    done

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
