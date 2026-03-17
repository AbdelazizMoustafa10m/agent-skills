---
name: commit-message
description: Draft conventional commit messages from staged changes. Use when the user asks to commit, write a commit message, or prepare changes for a PR.
---

# Commit Message Skill

Generate a conventional commit message from the current staged diff.

## Steps

1. Run `git diff --cached --stat` to see what files changed.
2. Run `git diff --cached` to read the actual changes.
3. Draft a commit message following Conventional Commits:
   - `feat:` for new features
   - `fix:` for bug fixes
   - `refactor:` for code restructuring
   - `docs:` for documentation
   - `test:` for test changes
   - `chore:` for maintenance
4. Keep the subject line under 72 characters.
5. Add a body with bullet points if there are multiple logical changes.
6. Present the message and ask for confirmation before committing.
