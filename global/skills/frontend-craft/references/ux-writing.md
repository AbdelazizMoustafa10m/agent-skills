# UX Writing

Copy is interface. The fastest way a polished-looking UI loses trust is generic, vague, or
robotic words. Microcopy is design work, not filler — write it with the same care as the
layout.

## Principles

- **Specific beats generic.** "Save changes" beats "Submit". "Delete 3 invoices" beats
  "Confirm". The user should know exactly what will happen before they act.
- **Lead with the verb and the user's goal.** Button labels name the *action and its
  object*, not the mechanism. "Create report", "Invite teammate", "Export CSV".
- **Match the product's voice** established in the direction brief. A laboratory-precise
  tool and a sunlit local-market brand do not write error messages the same way.
- **Sentence case** for almost everything (buttons, labels, headings) reads as more
  modern and human than Title Case; reserve all-caps for short eyebrows/labels with added
  letter-spacing.
- **No filler.** Cut "Welcome to your dashboard!" and "Please note that…". Every word
  should change what the reader knows or does.

## Buttons and actions

- Primary button = the one action you want most; make it the only high-emphasis button in
  view. Secondary/tertiary actions step down in weight.
- Never two competing primary buttons side by side — it stalls the decision.
- Destructive actions: name the consequence ("Delete account"), use a distinct danger
  treatment, and confirm only when the action is hard to undo (don't confirmation-spam
  reversible actions).
- Disabled buttons should explain *why* (tooltip or inline hint) — a dead button with no
  reason is a dead end.

## Error messages

A good error says what happened, why, and how to fix it — in the user's terms, without
blame:

- ❌ "Error: invalid input." ✅ "That email is already in use. Try signing in instead."
- ❌ "Something went wrong." ✅ "We couldn't save your changes — check your connection and
  try again." (Offer the retry.)
- Put the message *next to the field* it concerns, associated programmatically (see
  accessibility-gates.md), and keep the user's entered data.
- Never expose raw stack traces, codes, or internal jargon to end users.

## Empty states

The first thing a new user often sees — design it, don't leave a blank panel:

- Say what *would* be here, why it's empty, and the single next action to fill it.
- "No invoices yet. Create your first invoice to start tracking payments." + a primary
  action.
- Distinguish "empty because new" (onboard, encourage) from "empty because filtered/0
  results" (explain the filter, offer to clear it) from "empty because error" (explain,
  offer retry). They are three different states.

## Loading and progress

- Skeletons that mirror the final layout beat a centered spinner — they signal *what* is
  coming and prevent layout shift.
- For waits over ~1s, show progress or reassurance; for known long jobs, show steps.
- Optimistic UI for low-stakes actions (the like registers instantly, syncs after); never
  for payments or destructive operations.

## Labels, placeholders, helper text

- A label is permanent; a placeholder disappears on focus and must **never** be the only
  label (it fails accessibility and memory). Use placeholders for *format examples*
  ("name@company.com"), not for the field name.
- Helper text below the field for constraints ("8+ characters"); show it *before* the user
  errs, not only after.
- Keep labels short and parallel in structure across a form.

## Numbers, dates, and units in copy

- Format for the locale and be consistent (`Intl` APIs). Spell out ambiguous dates.
- State units explicitly; never make the user guess whether a figure is dollars or
  thousands of dollars.
