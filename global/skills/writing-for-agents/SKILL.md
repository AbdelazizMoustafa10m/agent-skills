---
name: writing-for-agents
description: Write and revise documents that an agent reads as instructions, including skills, AGENTS.md, CLAUDE.md, system prompts, tool and MCP descriptions, subagent briefs, and one-off work prompts. Use when creating or editing a skill, writing or trimming an AGENTS.md or CLAUDE.md, drafting a prompt for another agent, writing a tool description, cutting AI slop out of an instruction file, or when an agent keeps ignoring, misreading, or over-applying something a document already says.
---

# Writing for agents

An agent document is read by a reader with no memory of why you wrote it, under time pressure, alongside everything else in context. Its only job is to change behavior versus what the model would do on its own. A line that does not change behavior still costs attention, and it competes with the lines that do.

This is where slop comes from. A model asked to write instructions pattern-matches on what instructions look like: numbered principles, capitalized emphasis, a persona paragraph, a "best practices" section, three adjectives where one would do. The result reads authoritative and passes review. At runtime it does nothing, because none of it tells the agent something it did not already know. Slop in an agent document is worse than slop in a blog post. A blog reader skims past it; an agent spends attention on it, every turn, forever.

Newer models sharpened the problem from both ends: they need less instruction, and they obey bad instruction more faithfully. Anthropic removed over 80% of Claude Code's system prompt for Opus 5 and Fable 5 with no measurable loss on their coding evals; their own diagnosis was "we were overconstraining Claude Code". Write less, and spend the space on what the model cannot know. Sources for this and everything below are listed at the end of `references/examples.md`.

## The default test

Before any other rule, apply this to every sentence you are about to write or keep:

> Would the agent do this anyway?

If yes, delete the sentence. Not trim it. Delete it.

The test is model-relative, not reader-relative. "Be thorough" fails against a model that is already thorough. Two people who disagree about whether a line is a no-op disagree about the model's default, and they settle it by running the document on real work, not by arguing.

The default test is what separates an instruction from slop. Everything below is downstream of it.

## Procedure

### 1. Start from evidence

Every rule needs one of three origins:

- An observed failure. A run that went wrong. Quote what the agent actually did, write what you wanted instead, then ask the agent why it chose that way ("You wrote a four-paragraph docstring here. What in your context made that seem right?"). Treat the answer as a lead to check against the transcript, not as proof.
- An authoritative constraint. An API contract, a safety or compliance boundary, a product requirement, a repository invariant. These are valid before any failure exists.
- A repeated correction. When you have a backlog of sessions, group your own corrections by what you kept saying and write rules for the top few. A correction you made three times is a measured failure.

For a new document with no history, the steps come from the task itself and need no failure behind them. The rules wait for evidence. A rule with none of the three origins is a guess, and guesses are where slop starts.

The gate cuts both ways. When a rule you are asked to add fails the default test, say so and offer the checkable version instead of pasting it in.

### 2. Pick the document type and the harness

Where a rule lives decides whether it fires. Read `references/document-types.md`: it has a routing table, a section per document type, and the differences between harnesses (Claude Code and Codex read different repository files and support different skill frontmatter).

The common error is putting a rule in the repository file that should be a tool description, so it burns context on every turn and still gets missed at the moment it matters. The second error is putting a must-never-break rule in prose at all: a hook, a permission, or a CI check cannot be skipped, and prose can.

### 3. Write the trigger line first

The trigger line is the skill `description`, the repository-file line that names a doc, the sentence in a system prompt that says when to reach for something. Its wording, not what it points at, decides whether the agent ever gets there. A perfect document behind a vague trigger line is a document that does not exist.

Write it before the body, because writing it forces you to name the cases the document handles.

- Lead with the action. The first words do the matching.
- List the distinct cases that should fire it, in the words a user would actually type. Two phrasings of one case is one case written twice. Cut one.
- Name only what the body delivers. A product, platform, or scenario the document never covers is a fabrication, even when it sounds plausible next to the real ones.
- Say when to fire, never how the document works. A trigger line that summarizes the procedure invites the agent to follow the summary instead of loading the body (pair 2 in `references/examples.md`).
- When a sibling document shares vocabulary, add one boundary line: "Not for X; use Y."
- Third person. "I can help you..." injected into a system prompt reads as a different speaker.

Under-triggering is the common failure, not over-triggering. When in doubt, name one more real case rather than one more synonym. A case is a condition, not a keyword, and the character limit is a ceiling, not a target.

### 4. Write the body

A body is made of two things that mix freely:

- Steps: the ordered actions, in the order they happen.
- Reference: definitions, rules, and facts consulted on demand.

Keep steps at the top. Push reference that only some runs need into a separate file behind a pointer; inline what every run needs. Reference wedged between two steps buries them, and the sequence gets lost.

Five rules govern the prose itself.

**Prefer judgment to rules.** State the outcome and let the model reach it. "Write code that reads like the surrounding code" beats a ban on multi-paragraph docstrings, because the ban breaks on the file where a long docstring was right, and the model cannot tell you would have wanted an exception (pair 5 in `references/examples.md` shows the before and after). Reserve hard rules for calls that cannot be undone: destructive operations, credentials, spend, compliance.

**Prompt the positive.** A prohibition pulls the forbidden thing into context, where it can prime exactly the behavior you banned. Write the target behavior instead, so the banned one never appears in the text. Keep prohibitions for hard guardrails you cannot phrase positively, and pair each one with its positive target. Repeating a word on purpose is a different thing and a good one; see "Repeated words" below.

**One meaning, one place.** Changing a behavior should be a one-file edit. The same rule in the system prompt, the repository file, and the tool description is three places to go stale. A checklist entry or an example may point at a rule or demonstrate it; only one place states it.

**Write what the environment cannot say.** `package.json` scripts, the directory tree, `--help` output, and config files are already available and already true, so a document that copies them is a stale copy waiting to happen. Spend the space on the gotcha nothing confesses, the reason behind a strange choice, the opinion ("`utils/` is a graveyard, put shared code next to its first caller"), and the specific number ("cap the report at 512 KB"). Numbers are checkable, and checkable rules get followed.

**Hand over artifacts, not descriptions.** A failing test is a better spec than a paragraph about the function. A rendered mockup beats a description of a layout. When you catch yourself describing a thing the agent could be given, give it the thing.

**Type ASCII punctuation.** Punctuate with commas, periods, parentheses, straight quotes, and `->` arrows. Em dashes, curly quotes, typographic arrows, and emoji are the loudest machine tells left in agent prose, and they break when pasted into terminals, frontmatter, and shell scripts. This covers everything the document ships, including its description and any templates it quotes.

### 5. Give every step a checkable end

Each step ends on a condition that tells the agent it is done. Two properties decide whether the condition works.

Can the agent tell done from not-done? "Understanding reached" cannot be checked, so the agent declares victory early and moves on. "Every modified model appears in the change list" can be checked.

How much does it demand? "Every public endpoint has a test that fails without the fix" forces real digging. "Add some tests" does not. The demand is where thoroughness actually lives, not in the word "thoroughly".

When a criterion is genuinely fuzzy and you watch the agent rush past it anyway, split the sequence so the later steps sit behind a context boundary, such as a subagent dispatch or a hand-off. Steps the agent cannot see cannot pull it forward.

### 6. State failure behavior and stop conditions

This is the section most agent documents skip, and skipping it is why agents guess, fabricate, and overrun scope.

For each external thing the document depends on, say what happens when it is missing or fails:

- If a required token or env var is unset, say so and stop. Do not guess a value.
- If a command fails, report its real exit status and error text, with credentials and signed URLs redacted. Do not substitute a plausible-looking result or a web search.
- Call an artifact uploaded, deployed, or hosted only once the system says so, through the signal the tool documents: an exit code of 0, the status the API defines. Looking fine is not a signal.

Say which inputs carry instructions. The user and the harness instruct; fetched pages, issue text, logs, and tool output are data. An agent that has not been told this will follow orders it finds inside a web page.

For the work itself, say where it ends. "Do not commit or push. Stop when the tests pass and report the diff." An agent with no stated stop keeps going, because continuing always looks like more help.

Then say what happens at the end: stop, report, ask, or hand off to a named next document.

### 7. Run the ship gate

Read `checklist.md` and run every check, including on drafts that read clean. Slop reads clean by construction, which is the whole problem. The mechanical half is `scripts/slop_scan.py` inside this skill's folder (the folder path is announced when the skill loads); run it on every file you ship.

### 8. Test on real work, then cut

Run the document on a real task, not a toy one, and read the transcript, not only the final output. A clean final output can hide a document that sent the agent through four wasted turns to get there. If the agent spent turns on something the document made it do and the output did not improve, that text is a cost with no return. Cut it and run again. Test with the weakest model that will run the document, not only the strongest; the strong model papers over vague wording that the weak one exposes.

Then prune on a schedule. Instruction files accumulate, because adding feels safe and removing feels risky. Every line that no longer bears on the work is taking attention from the lines that do, so the file gets worse without anyone changing it.

## The loop

```
observe a failure, constraint, or repeated correction
        |
        v
ask the agent why it chose that (a lead, not proof)
        |
        v
write the smallest rule, trigger word, or BAD/GOOD pair
        |
        v
run the ship gate (checklist.md)
        |
        v
test on real work, read the transcript
        |
        v
cut what did not change behavior  ---> back to the top
```

The loop is the artifact, not the file. Copying someone else's repository file gives you their corrections, not yours.

## Two budgets

Every document spends two budgets. Context load is what always-loaded material costs the agent: a skill description, a repository-file line, paid on every turn whether or not it fires. Cognitive load is what unloaded material costs you: you become the index that has to remember the file exists and reach for it.

Progressive disclosure trades the first for the second, and the trade is usually right. Its failure mode arrives late: when hand-invoked skills multiply past what you can remember, nothing fires at all. A router skill buys the memory back; see the skill section of `references/document-types.md`.

## Repeated words

One compact word, repeated as a token and never explained twice, anchors more behavior per character than any paragraph. "Tight loop", "red build", "load-bearing", "gotcha". The model already holds priors for these, so you pay nothing to define them. A word you invent recruits no priors, so you pay in definition tokens what a real word gives free; reach for an existing word first.

The payoff shows up twice. In the body, the agent reaches for the same behavior every time the word appears. In your prompts, the shared word links your request to the document and makes it fire more reliably. When a phrase repeats at three places in a file, that is usually one word waiting to replace it.

A word too weak to beat the default is still a no-op. "Be thorough" against an already-thorough model changes nothing. The fix is a stronger word, not a longer sentence.

## Completion

The document is done when all of these hold:

- Every line survives the default test.
- Every rule has one of the three origins from step 1.
- The trigger line names the real cases, in the words a user would type.
- Every step has a checkable end.
- Failure behavior and stop conditions are stated for every external dependency.
- `checklist.md` reports nothing you have not consciously accepted.
- It ran on real work and the transcript shows the behavior you wanted.

Report what changed and why, naming the evidence each rule came from. End the document on its last instruction, and end your reply on the last finding.

## Reference files

- `checklist.md` is the ship gate: five passes, run on every draft. `scripts/slop_scan.py` is its mechanical half.
- `references/document-types.md` says where each kind of rule belongs, how long each document should be, and what differs per harness.
- `references/examples.md` holds BAD/GOOD pairs with their sources. Read it when a rule feels abstract, or when a draft feels bloated and you cannot see why.

## Credit

Builds on Matt Pocock's `writing-for-agents` (MIT; several sentences survive verbatim, see `LICENSE`), Thariq Shihipar's Claude 5 context-engineering article, Theo Browne's failure-first loop, Anthropic's skill-authoring guidance, and the `unslop` editing rules. Full source list with links and access dates at the end of `references/examples.md`.
