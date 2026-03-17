---
name: pricing-page
description: Design, rewrite, critique, or optimize Finvault's pricing page and pricing messaging. Use this skill whenever the user mentions `/pricing`, pricing copy, annual vs monthly billing, free-trial messaging, FAQ content, plan framing, subscription conversion, pricing-page SEO/AEO, competitor comparison against Plaid/Monarch/YNAB/Copilot, or checkout-handoff UX for Finvault—even if they ask more generally about monetization, trial conversion, or pricing clarity.
---

# Pricing Page (Finvault)

This skill is for **Finvault's actual product and pricing model**, not a generic multi-tier SaaS template.

Your job is to help visitors decide that Finvault is worth trying now because it is:
- **faster than bank sync** for many workflows
- **privacy-first without fear-mongering**
- **full-featured from day one**
- **simple to understand**: one product, two billing cadences

## Read this first

When working on Finvault pricing, consult only the files you need, starting with:

- `docs/prd/PRD-PrivacyFirst-Finance-App.md`
- `docs/MARKETING-POSITIONING.md`
- `docs/tasks/T-087-stripe-subscription-integration.md`
- `docs/tasks/T-088-pricing-page-ui.md`
- `docs/tasks/T-088a-pricing-subscription-awareness.md`
- `app/(marketing)/pricing/page.tsx`
- `components/pricing/*`

These establish product truth, copy guardrails, and checkout behavior.

## Default Finvault assumptions

If the user does not explicitly change strategy, assume all of the following are true:

- Product: privacy-first, AI-powered personal finance app
- Core differentiator: **upload screenshots or PDFs instead of connecting bank credentials**
- Positioning: **faster than bank sync, without sharing credentials**
- Audience: privacy-conscious professionals, developers/security-minded users, international users, post-Mint switchers
- Tone: confident, technical-but-accessible, privacy-positive, premium, understated
- Offer model: **one product, two billing cadences**
- Trial: **30 days free**
- Card requirement: **no credit card required to start**
- Monthly price: **$12.99/month**
- Annual price: **$99/year**
- Entitlements: **all features included**, no premium tiers, no upsells
- International note: **7 currencies supported**

## Product truths to preserve

Default to these truths unless the user explicitly changes them:

- Finvault does **not** ask for bank credentials
- Finvault does **not** rely on Plaid/aggregator-style bank login flows
- Finvault supports screenshot import, PDF import, CSV import, AI categorization, portfolio tracking, budgets, debt tracking, savings goals, export, and account deletion
- Privacy should be framed as **control and architecture**, not paranoia
- Annual vs monthly are **billing options for the same product**, not different plans with different features

## Before you write or redesign

If context is missing, ask only for the gaps that matter.

### Ask these first
- Is this for the public `/pricing` page, a pricing section, or pricing copy only?
- Is the goal more trial starts, more annual take-rate, clearer messaging, or lower confusion?
- Which audience are we optimizing for right now?
- What proof is available: screenshots, testimonials, metrics, logos, launch quotes?
- Which objections matter most for this iteration?

### Do **not** ask by default
- whether Finvault has multiple tiers
- whether there is a free plan
- whether enterprise pricing exists

Those are not the current product strategy.

## Core framing for Finvault

### 1) Present one product, not plan complexity
- Use **monthly** and **annual** as billing choices
- Keep feature entitlements identical
- Treat annual as **best value**, not a different product

### 2) Lead with the real differentiator
The strongest Finvault pricing frame is not `budgeting software`.
It is:

- AI-powered finance app
- faster than waiting for bank sync
- no credential sharing
- works with screenshot/PDF import from any bank workflow

### 3) Make the trial feel safe
- Surface `30 days free` prominently
- Surface `No credit card required` prominently
- Explain what happens after the trial in one sentence

### 4) Use privacy as reassurance, not fear
Prefer:
- `Your bank login stays with your bank`
- `No credential sharing`
- `Full export and account deletion`
- `Privacy by design`

Avoid:
- alarmist security rhetoric
- unsupported claims like `more secure than Plaid`
- vague promises with no concrete mechanism

### 5) Give users a factual reason to pay
The page should make the answer obvious:

- full-featured replacement for spreadsheet-heavy workflows
- privacy-respecting alternative to Monarch/Copilot/YNAB-style tools
- faster import path for users who do not want or cannot use aggregators

## Recommended pricing-page structure for Finvault

### Above the fold
- Clear headline with trial + value framing
- Short subhead connecting AI, speed, and privacy
- Annual/monthly toggle or side-by-side cadence cards
- Primary CTA: `Start 30-Day Free Trial`
- Microcopy: `No credit card required`

### Mid-page
- `Everything included` feature grid
- trust strip: no credential sharing, GDPR, cancel anytime, full export
- short objection-handling section or proof block

### Below the fold
- FAQ focused on trial, billing, privacy, import workflow, bank compatibility, and data control
- final CTA with the same promise as the hero

## Finvault-specific layout recommendation

Default to this pattern unless the user asks otherwise:

### A) Single-offer with dual billing
Best for Finvault right now.

Rules:
- Show annual and monthly clearly
- Highlight annual as `Best Value` or `Recommended`
- Keep both cards/features nearly identical except billing cadence
- Do not invent feature gates to make cards feel more different

### B) Single-offer plus trust/proof stack
Use when the page needs more persuasion than more pricing detail.

Rules:
- Keep pricing simple
- Add more trust, proof, and objection handling below
- Emphasize why Finvault is different from bank-sync competitors

## Copywriting guidance

### Messaging priorities
When possible, prioritize this order:
1. speed / convenience
2. privacy / control
3. full-featured value
4. price / savings

### Strong headline directions
- `30 days free. Then $99/year for everything.`
- `The AI finance app that's faster than bank sync.`
- `Upload screenshots or a PDF. Get insights. Share no credentials.`
- `All the finance tools you want. None of the bank-login handoff.`

### Subheadline ingredients
Blend 2-3 of these, not all of them:
- upload up to 10 screenshots at once
- import PDFs from any bank workflow
- AI extraction and categorization
- no bank login sharing
- 7 currencies supported
- all features included

### CTA rules
- Keep primary CTA consistent: `Start 30-Day Free Trial`
- Keep secondary CTA factual: `See how it works`, `Sign in`, or `Compare billing`
- Reinforce `No credit card required` near the CTA, not buried far below

### Feature bullets
Write as outcomes, not internal capabilities.

Bad: `AI-powered categorization`

Better: `Import a statement and let AI sort transactions in seconds`

Bad: `Full data export`

Better: `Export everything any time—you stay in control of your data`

## Objections to handle on the page

Finvault pricing work should usually answer these:

### `Isn't manual import tedious?`
Answer with speed and workflow:
- PDF import can be faster than waiting for sync
- screenshot batch import reduces manual effort
- the product is about convenience without credential sharing

### `Why should I pay when Monarch, Copilot, or YNAB exist?`
Answer with differentiation:
- similar premium category
- stronger privacy posture
- better fit for users who will not share bank credentials
- international and non-aggregator workflows matter

### `Will this work with my bank?`
Answer with workflow compatibility, not unsupported universals:
- PDF, screenshot, and CSV import paths
- works for users outside standard aggregator coverage

### `What happens after the free trial?`
Answer with clarity:
- no hidden charge during signup
- choose monthly or annual to continue

### `Do I get every feature?`
Answer with a strong yes:
- all features included
- no premium upsells
- future features included

## FAQ checklist

Pricing FAQ should usually cover 6-10 of these:
- How does the 30-day free trial work?
- Do I need a credit card to start?
- What happens when the trial ends?
- Can I cancel anytime?
- Can I switch between monthly and annual billing?
- Do you use Plaid or ask for bank credentials?
- Will Finvault work with my bank workflow?
- What currencies do you support?
- What happens to my data if I cancel?
- Do I get future features automatically?
- How accurate is AI categorization, and can I correct it?

Keep answers short, factual, and calm.

## SEO and AEO for Finvault

### SEO basics
- Default page title: `Pricing - Finvault`
- Meta description should mention the trial, pricing entry point, and privacy differentiator
- Keep URL clean: `/pricing`
- Support discoverability for terms like:
  - privacy-first finance app
  - no Plaid finance app
  - alternative to Monarch / Copilot / YNAB / Mint

### AEO guidance
- Use plain Q/A formatting in FAQ
- Answer trial, cancellation, billing, bank-credential, and data-control questions directly
- Suggest FAQ schema if implementation supports it

## Implementation notes for Finvault

If the request touches actual product/UI implementation, preserve current repo behavior:

- public pricing page stays public
- signed-out CTA should hand off to signup with plan intent preserved
- signed-in CTA should go to authenticated checkout
- `resumeCheckout` handling must avoid loops
- do not introduce Stripe.js or expose raw Stripe price IDs to the client

## Common mistakes

- Turning Finvault into a generic multi-tier SaaS in the copy
- Treating annual and monthly as feature-different plans
- Hiding prices or making visitors talk to sales
- Underplaying `No credit card required`
- Leading with privacy fear instead of control and convenience
- Making claims stronger than the repo docs support
- Forgetting the current checkout/auth handoff rules
- Writing feature lists that sound like internal product marketing instead of user value

## Output format

When generating pricing-page work for Finvault, return:

1. **Assumptions used**
2. **Page outline**
3. **Pricing module spec** - annual/monthly presentation, CTA, microcopy, trust cues
4. **Copy blocks** - hero, subhead, plan labels, CTA labels, support text
5. **FAQ list** - 6-10 Q/A pairs
6. **Objection-handling notes** - which objections are addressed where
7. **SEO/AEO** - title, meta description, schema suggestion
8. **Experiment ideas** - 3-5 focused tests

If implementation details are relevant, also include:

9. **Finvault integration notes** - signup handoff, checkout resume, auth-state behavior

## Quick questions for underspecified requests

If the user simply says `make the pricing page better`, ask:
- Is the goal more trials, more annual conversions, or clearer trust messaging?
- Are we changing copy only, or structure/components too?
- Which audience should the page speak to first?
- Which 2-3 objections should we prioritize?

If the user gives no further detail, proceed with Finvault defaults and say so explicitly.