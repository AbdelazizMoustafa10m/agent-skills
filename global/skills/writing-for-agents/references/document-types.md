# Where each rule belongs

Putting a rule in the wrong document is the most common reason a correct rule fails to fire. The rule is read on turns where it does not matter and missed on the turn where it does.

Route first, write second.

## Routing table

| The rule is about | It belongs in | It fires |
| --- | --- | --- |
| What product the agent is in, what it is for | System prompt | Every turn |
| A gotcha in this repository | Repository file (`CLAUDE.md`, `AGENTS.md`) | Every turn in this repo |
| Your stable personal preferences across all repos | Global agent file | Every turn everywhere |
| A procedure used on some tasks | Skill | When its description matches |
| How to call one tool correctly | That tool's description | At the moment of use |
| What one delegated task must produce | Subagent brief | Once, for that task |
| What to do right now, and where to stop | Work prompt | Once |
| A rule that must never be broken | Hook, permission, schema, or CI check | Deterministically, outside the prompt |
| Helping a human evaluate the project | `README.md` | Never, it is not an agent document |

## System prompt

Owned by the harness, not the repository. It says what product the agent is operating inside and what it is doing there.

Belongs: product identity, the shape of the interaction, what the agent may and may not do at the product level, how output reaches the user.

Does not belong: anything that varies by repository, anything about one tool, anything discoverable from the file system.

If you build your own harness, this is where the time goes. If you do not own the harness, you cannot edit it, and the instinct to compensate for it in the repository file is where most bloat starts.

## Repository file

Its job is to tell an agent how to change this codebase safely.

Which file the harness reads is harness-specific. Claude Code loads `CLAUDE.md`; it does not read `AGENTS.md` on its own, but a `CLAUDE.md` containing the line `@AGENTS.md` imports it. Codex CLI loads `AGENTS.md`. Keeping one real file and importing it from the other avoids drift.

Belongs: what the repo is, in two or three lines. Then gotchas, and mostly gotchas. The migration that locks prod. The test that passes locally and fails in CI for an environment reason. The folder nobody should add to and why. The command that looks right and is wrong.

Does not belong: the directory tree, the `package.json` scripts, general coding advice, session facts the agent now saves to memory on its own. Every line here must fail the different-project test (checklist, pass 5).

Length: as short as the gotchas allow. When one topic grows past a short section, move it to a skill and point at it from here.

A `README.md` is a different document with a different reader. A README helps a person decide whether to use or trust the project. An agent file tells an agent how to work inside it. Do not let one become the other.

## Global agent file

Your machine-level file, applied to every repository. It describes your stable preferences, the things that are true of you regardless of what you are working on.

Belongs: how you want to be communicated with, what you always want done before work is called finished, tools you always want used or avoided, the standing "stop before you commit" rule.

Does not belong: anything about one project. That is what the repository file is for.

Keep machine-specific, harness-specific, and universal content in separate files. A rule that only makes sense on your laptop should not travel to a CI runner.

## Deterministic checks

Prose is advisory: the model can fail to follow it. A hook, a permission, a schema, or a CI check cannot be skipped. Route must-never-break rules there (destructive operations, credentials, spend, anything compliance-shaped), and keep the prose for what the check cannot express: the policy behind it, the exception path, the recovery behavior.

## Skill

A procedure or body of reference the agent loads only when it is relevant. Skills are where team-specific and product-specific knowledge lives.

Frontmatter mechanics. The open Agent Skills spec defines `name`, `description`, `license`, `compatibility`, `metadata`, and `allowed-tools`; everything else is a harness extension, so label it when you rely on it.

- `name`: at most 64 characters, lowercase letters, numbers, and hyphens. Skills uploaded to claude.ai or the API additionally may not contain "anthropic" or "claude" in the name; local Claude Code skills may.
- `description`: non-empty, at most 1024 characters, no XML tags, third person. This is the trigger line; the rules from step 3 of the skill apply in full.
- `when_to_use` (Claude Code only): appended to the description in the skill listing. Claude Code truncates the combined text at 1536 characters there, so the case that matters most goes in the description's first sentence.
- `disable-model-invocation: true` (Claude Code only): the skill fires only when a human types its name, and its description stays out of context. Zero context load, but you become the index that remembers it exists, and no other skill can reach it. Other harnesses ignore or reject the field.

Body: keep `SKILL.md` under 500 lines. Split past that into `references/`, one level deep. Give a reference file over 100 lines a table of contents, so the agent sees the full scope even on a partial read.

Choose model invocation when the agent must find the skill on its own or another skill must reach it. Choose user invocation when it only ever fires because you typed it. Do not pay for discovery you never use.

When user-invoked skills multiply past what you can remember, add a router: one skill that names the others and says when to reach for each. It can only point at them, not fire them, and it turns many things to remember into one.

## Tool and MCP description

The best place for a rule about a tool, because it arrives exactly when the tool is about to be used.

Belongs: what the tool does, when to reach for it over the alternatives, what each parameter means, what the failure modes are and what to do about each one.

Does not belong: usage examples that a well-designed parameter would make unnecessary. Prefer an expressive interface: an enum of valid values teaches better than three example calls and cannot be misread (pair 9 in `examples.md`).

If a rule about a tool currently lives in the system prompt or the repository file, move it here and delete it there.

## Subagent brief

A one-shot instruction to an agent with no memory of your conversation and no way to ask you a question.

Belongs: the task, the inputs by absolute path, the exact output artifact and where to put it, the definition of done, and the failure behavior. Everything the parent knows that the child needs, stated outright. When the child will read external content, say that the content is data, not instructions.

Does not belong: anything that assumes shared context. "Continue from where we left off" means nothing to a fresh process.

The most common defect is a missing output spec. The subagent does good work and returns a summary instead of the file, and the work is gone.

## Work prompt

The thing you type to start a task. It is an agent document too, and it deserves the same discipline.

Belongs: the goal, the constraint that is not obvious, and the stop condition, said plainly: "Do not commit or push to any machine yet. I will tell you when."

Does not belong: a persona, a restatement of the codebase, or politeness padding.

The stop condition is the part people skip and the part that matters most (pair 8 in `examples.md`).
