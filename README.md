# Agent Skills — Unified Cross-Agent Skills Repo

One canonical copy of each skill, shared across all coding agents (Claude Code, Codex CLI, Gemini CLI, Copilot, OpenCode, etc.) and synced across machines.

## How it works

Skills follow the [open agent skills standard](https://agentskills.io) — a folder with a `SKILL.md` file. This repo stores one copy per skill and `setup.sh` creates symlinks into every agent's `skills/` directory.

```
agent-skills/
├── finvault/              # Finvault-specific skills (16)
├── harvx/                 # Harvx-specific skills (5)
├── raven/                 # Raven-specific skills (5)
├── skills.toml            # Project → skills mapping config
└── setup.sh               # Creates symlinks
```

Edit a skill once in this repo → every agent sees the change instantly.

## Setup on a new machine

```bash
git clone git@github.com:AbdelazizMoustafa10m/agent-skills.git ~/prj/agent-skills
cd ~/prj/agent-skills && ./setup.sh
```

## Adding a new skill

```bash
# 1. Create the skill in the right project scope
mkdir -p ~/prj/agent-skills/finvault/my-new-skill
# 2. Write SKILL.md with frontmatter (name, description) + instructions
# 3. Re-run setup to link it into all agent dirs
cd ~/prj/agent-skills && ./setup.sh
# 4. Sync across machines
agent-sync push
```

## Adding a new project

1. Create a directory: `mkdir ~/prj/agent-skills/my-project`
2. Add skills inside it
3. Add the project to `PROJECTS` in `setup.sh`
4. Run `./setup.sh`
