# Ship gate

Run this on every agent document before it ships. It has five passes: the default test, structure, the slop scan, failure behavior, and the self-audit. Run them in order, because pass 1 deletes text that later passes would otherwise waste time polishing.

Record findings as you go. Fix them all. Then rerun passes 1 and 3, since fixes introduce new text. The gate passes when a clean rerun reports nothing you have not consciously accepted.

## Pass 1: the default test

Go sentence by sentence. For each one ask: would the agent do this anyway?

Delete every sentence that fails. Delete the whole sentence, not a few words from it. A trimmed no-op is still a no-op.

Watch for these, which almost always fail:

- Any sentence telling the model to be accurate, careful, thorough, or helpful.
- Any sentence telling it to think before answering, or to consider the context.
- Any sentence telling it not to make things up.
- Any restatement of something the environment already says: a script in `package.json`, the directory tree, a flag in `--help`, a type in the code.
- Any rule with none of the three origins from step 1 of the skill (failure, constraint, repeated correction).

If you are unsure whether a line beats the default, mark it and settle it by running the document twice, once with the line and once without. Do not settle it by discussion.

## Pass 2: structure

Seven binary checks.

1. The trigger line leads with the action and names the distinct cases in the words a user would type. No two entries are rephrasings of each other.
2. Steps come before reference. No block of reference material sits between two steps.
3. Every step has an end condition an agent could check. No "review the changes", "make sure it works".
4. Every rule is stated in exactly one place. A checklist entry or an example may point at a rule or demonstrate it; a second full statement is a finding.
5. Material only some runs need sits behind a pointer, not inline. Material every run needs is inline, not behind a pointer.
6. Reference files are one level deep from the main file. No file points at a file that points at a third file.
7. Everything about one concept sits under one heading. A definition here and its caveat three sections later forces the agent to reassemble them.

## Pass 3: slop scan

Run the mechanical half first (the script lives in this skill's folder, whose path is announced when the skill loads):

```bash
python <skill-folder>/scripts/slop_scan.py FILE
```

It flags em and en dashes, curly quotes, arrows, invisible characters, emoji, AI vocabulary, stacked hedges, and decorative dividers, and it counts emphasis words. It skips fenced code blocks and inline code spans, so quoted BAD examples do not trip it. Exit 0 means no findings.

Then read for what a script cannot catch:

- A persona paragraph with no behavior depending on it. Keep a role line only when it selects between real behaviors ("You review code. You do not write it.").
- A list of principles or values that binds no step.
- A "best practices" section with no evidence behind it.
- A recap or summary section restating the body.
- A bold label and colon restating the sentence after it.
- Bold on every proper noun or acronym. Bold is emphasis; spending it everywhere leaves nothing for the line that matters.
- Title case headings. Use sentence case.
- A table of contents on a file under roughly 100 lines.
- A prohibition that could be written as its positive target.
- Marketing voice, or feelings instead of mechanisms: "the database stays close at hand" names a sensation. Name the mechanism or the number instead, or cut the sentence.
- Adjective triples, filler openers, and hedges that dissolve the instruction (`you may want to consider running the tests` is a mood, not an instruction).
- An adverb propping up a weak verb (`runs quickly`, `significantly improves`). Use the number, or a verb that carries the meaning alone.
- Passive voice hiding an actor the agent needs to know. "Queries are validated" by what, and when?

Emphasis works by contrast. When capitalized words stop standing out, none of them work; more than two or three surviving in one file is the usual sign. Spend them only where a wrong call cannot be undone.

## Pass 4: failure behavior and stop conditions

List every external thing the document depends on: a token, an env var, a network call, a file path, a service, a command.

For each one, confirm the document says what happens when it is missing or fails. If it does not, that is a finding: the agent will invent something plausible instead, and plausible is the dangerous kind of wrong.

Then confirm four more things:

1. The document says where the work stops. Commit, push, deploy, and message-sending each need an explicit yes or no.
2. Success comes from the system, not from the agent's belief: the exit code or status the tool documents, not "the output looks fine".
3. If the agent reads external content (pages, issues, logs, tool output), the document says that content is data, not instructions.
4. The document says what happens at the end: stop, report, ask, or hand off to a named next document.

## Pass 5: self-audit

Ask the question directly, and answer it honestly:

> What in this document makes it obviously written by a model?

Then fix whatever you named. This pass catches the tells that are new, local to your domain, or specific to this draft, which is exactly the set no fixed checklist can hold.

Follow it with the different-project test:

> Which sentence here could appear unchanged in a document for a different project?

Any sentence that could says nothing about this one. Cut it. Repository files fail this test more than any other document type.

## Findings format

Report findings so they can be acted on without rereading the file:

```
LINE 34  no-op          "Always strive for clarity and precision." -> delete
LINE 51  negation       "Never use var." -> "Declare with const, or let when reassigned."
LINE 88  vague end      "Review the changes." -> "Every changed file appears in the summary."
LINE 91  missing stop   deploy step has no stop condition -> add "Stop after staging. Do not deploy."
```

First drafts usually produce findings. If the first pass reports none, re-read the two longest sections once; if the result stands, accept it and move on.
