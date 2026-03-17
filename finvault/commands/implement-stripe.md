---
description: Orchestrate Stripe integration tasks with 3-phase flow (backend → frontend → CLI verification)
argument-hint: <task-number e.g. T-087>
---

# Stripe Integration Orchestrator

You are the **Orchestrator** for implementing Stripe task `$ARGUMENTS` in Finvault. This command handles the unique 3-phase flow that Stripe integration requires: backend foundation, billing UI, and live CLI verification against real Stripe test-mode APIs.

> **Why a dedicated command?** Stripe integrations cross the backend/frontend boundary and require procedural verification (running `stripe listen`, triggering events, checking DB state) that generic orchestrators cannot handle. Per Stripe's own research: *"a mostly correct integration is a failure; payments require 100% accuracy."*

## Workflow Overview

```
┌─────────────────────────────────────────────────────────────────┐
│  0. PRE-FLIGHT (Orchestrator)                                    │
│     - Read task spec + PROGRESS.md                               │
│     - Verify dependencies                                        │
│     - Verify Stripe CLI is installed and authenticated           │
│     - Verify Stripe env vars are configured                      │
├─────────────────────────────────────────────────────────────────┤
│  1. BACKEND FOUNDATION (spawn backend-engineer)                  │
│     - Schema, migration, env, Stripe client                     │
│     - SubscriptionService, API routes, webhook route             │
│     - GDPR integration, client fetch, hooks                     │
│     → Checkpoint: typecheck + lint                               │
├─────────────────────────────────────────────────────────────────┤
│  2. UNIT TESTS (spawn testing-engineer)                          │
│     - Service tests, route tests, webhook tests                  │
│     → Checkpoint: all tests pass                                 │
├─────────────────────────────────────────────────────────────────┤
│  3. BILLING UI (spawn frontend-engineer)                         │
│     - Billing page, components, settings nav                     │
│     → Checkpoint: typecheck + lint + build                       │
├─────────────────────────────────────────────────────────────────┤
│  4. COMPONENT TESTS (spawn testing-engineer)                     │
│     - Billing UI component tests                                 │
│     → Checkpoint: all tests pass                                 │
├─────────────────────────────────────────────────────────────────┤
│  5. STRIPE CLI VERIFICATION (Orchestrator — NOT a subagent)      │
│     - stripe listen + stripe trigger                             │
│     - Verify webhook delivery + DB state                         │
│     - Verify checkout/portal URLs                                │
│     - Verify subscription status API                             │
│     → Gate: all verification checks pass                         │
├─────────────────────────────────────────────────────────────────┤
│  6. FINAL BUILD GATE (Orchestrator)                              │
│     - npm run typecheck && lint && test && build                  │
│     - Update PROGRESS.md                                         │
└─────────────────────────────────────────────────────────────────┘
```

---

## Step 0: Pre-Flight Checks

### 0.1 Read Task Specification

```
Read: /docs/tasks/$ARGUMENTS-*.md
```

Extract the full spec. You will inject relevant sections into each subagent prompt.

### 0.2 Check Progress Status

```
Read: /docs/tasks/PROGRESS.md
```

- Already completed? → **STOP and report**
- Dependencies incomplete? → **STOP and report blockers**

### 0.3 Verify Stripe CLI

Run:

```bash
stripe --version
```

If not installed → **STOP**: Tell the user to run `brew install stripe/stripe-cli/stripe`.

### 0.4 Verify Stripe Environment

Check that `.env.local` (or equivalent) has these variables configured:

- `STRIPE_SECRET_KEY`
- `STRIPE_WEBHOOK_SECRET`
- `STRIPE_PRICE_ID_MONTHLY`
- `STRIPE_PRICE_ID_ANNUAL`

Verify price IDs exist in Stripe:

```bash
stripe prices retrieve $STRIPE_PRICE_ID_MONTHLY 2>/dev/null && echo "✓ Monthly price exists"
stripe prices retrieve $STRIPE_PRICE_ID_ANNUAL 2>/dev/null && echo "✓ Annual price exists"
```

If env vars are missing or prices don't exist → **STOP**: Tell the user to configure Stripe test-mode products and env vars first.

### 0.5 Verify Stripe CLI Authentication

```bash
stripe customers list --limit 1 2>/dev/null && echo "✓ Stripe CLI authenticated"
```

If not authenticated → Tell the user to run `stripe login`.

---

## Step 1: Spawn Backend Engineer

**Use the Agent tool to spawn the `backend-engineer` subagent:**

Inject the following into the prompt:
- The full task spec (from Step 0.1)
- Explicit instruction to implement ONLY backend/server-side code
- The exact file list from the task's File Structure section

The backend-engineer must implement:

1. Prisma schema update (`Subscription` model + `SubscriptionStatus` enum)
2. Apply migration via Supabase MCP (`mcp__plugin_supabase_supabase__apply_migration`)
3. Run `npx prisma generate`
4. Extend `lib/env.server.ts` with Stripe env vars
5. Create `lib/stripe/server.ts` (server-only Stripe client)
6. Create `types/subscription.ts` (shared types + Zod schemas)
7. Create `lib/services/subscription-service.ts`
8. Create `app/api/webhooks/stripe/route.ts`
9. Create `app/api/stripe/checkout/route.ts`
10. Create `app/api/stripe/portal/route.ts`
11. Create `app/api/stripe/subscription/route.ts`
12. Create `lib/api/subscription.ts` (client fetch functions)
13. Create `hooks/use-subscription.ts` (TanStack Query hooks)
14. Update `lib/services/account-deletion-service.ts` (GDPR integration)

**Key instructions for the backend-engineer:**

- Accept `plan: "monthly" | "annual"` from the client — map to price IDs server-side
- Use `invoice.paid` (not `invoice.payment_succeeded`) as the canonical success event
- Handle all required webhook events including `customer.subscription.paused`, `customer.subscription.resumed`, `customer.subscription.trial_will_end`
- Set `client_reference_id: userId` and `metadata: { userId }` on checkout sessions
- Identify users via metadata, never by email alone
- Use `payment_method_collection: "if_required"` and `missing_payment_method: "pause"` for trial
- Keep Stripe IDs server-only — never expose to client

After implementation, the backend-engineer must run:

```bash
npm run typecheck
npm run lint
```

**Wait for backend-engineer to complete. Capture the implementation summary and file list.**

**If typecheck or lint fails:** Spawn a fix cycle (re-spawn backend-engineer with error details).

---

## Step 2: Spawn Testing Engineer (Unit Tests)

**Use the Agent tool to spawn the `testing-engineer` subagent:**

Inject:
- The task spec's Testing Requirements → Unit Tests section
- The implementation summary from Step 1
- The list of files created/modified

The testing-engineer must write:

- `__tests__/services/subscription-service.test.ts`
- `__tests__/api/stripe/checkout.test.ts`
- `__tests__/api/stripe/portal.test.ts`
- `__tests__/api/webhooks/stripe.test.ts`
- Update `__tests__/services/account-deletion-service.test.ts`

After writing tests, run:

```bash
npm run test
npm run typecheck
npm run lint
```

**Wait for testing-engineer to complete. Capture the test summary.**

**If tests fail:** Determine if it's a test issue or implementation issue. Spawn the appropriate subagent to fix.

---

## Step 3: Spawn Frontend Engineer (Billing UI)

**Use the Agent tool to spawn the `frontend-engineer` subagent:**

Inject:
- The task spec's Billing UI and File Structure sections
- The implementation summary from Step 1 (so the frontend-engineer knows what hooks/types exist)
- Explicit instruction to use the hooks and types created in Step 1

The frontend-engineer must implement:

1. Add `settingsBilling` to `lib/navigation.ts`
2. Add Billing to `components/settings/settings-nav.tsx`
3. Create `app/(dashboard)/settings/billing/page.tsx` (server-rendered)
4. Create `components/subscription/billing-status-card.tsx`
5. Create `components/subscription/manage-subscription.tsx`

**Key instructions for the frontend-engineer:**

- Billing page must be server-rendered; pass only scalar props to client leaves
- Use `useSubscription` hook from `hooks/use-subscription.ts` (created in Step 1)
- Use shadcn/ui + Tailwind CSS, dark-mode-first
- Financial data must use `font-mono tabular-nums`
- Handle all UI states: loading, error, empty, trial, active, paused, canceled, past_due
- No generic `SubscriptionGate` component

After implementation, run:

```bash
npm run typecheck
npm run lint
npm run build
```

**Wait for frontend-engineer to complete. Capture the implementation summary.**

---

## Step 4: Spawn Testing Engineer (Component Tests)

**Use the Agent tool to spawn the `testing-engineer` subagent:**

Inject:
- The frontend implementation summary from Step 3
- Instruction to write component tests for billing UI

The testing-engineer writes tests for:
- `billing-status-card.tsx` (all subscription states)
- `manage-subscription.tsx` (portal redirect, checkout trigger)
- `billing/page.tsx` (server render, prop passing)

After writing tests, run:

```bash
npm run test
npm run typecheck
```

**Wait for completion.**

---

## Step 5: Stripe CLI Verification

> **CRITICAL: This step must be executed by the Orchestrator directly, NOT delegated to a subagent.** It requires running live processes and verifying real Stripe API interactions.

### 5.1 Start Services

Start the dev server:

```bash
npm run dev &
DEV_PID=$!
sleep 5
```

Start the Stripe webhook listener:

```bash
stripe listen --forward-to localhost:3000/api/webhooks/stripe &
LISTEN_PID=$!
sleep 3
```

Note: `stripe listen` outputs a webhook signing secret (`whsec_...`). If it differs from `.env.local`, update `STRIPE_WEBHOOK_SECRET` and restart the dev server.

### 5.2 Trigger and Verify Webhook Events

For each event, trigger it and verify the handler responds with `200`:

```bash
stripe trigger checkout.session.completed
stripe trigger customer.subscription.created
stripe trigger customer.subscription.updated
stripe trigger customer.subscription.deleted
stripe trigger invoice.paid
stripe trigger invoice.payment_failed
```

For events not supported by `stripe trigger` (paused, resumed, trial_will_end), create them via the Stripe API:

```bash
# Create a customer and subscription to test pause behavior
CUSTOMER=$(stripe customers create --name "Test User" -q | grep -o 'cus_[a-zA-Z0-9]*')
stripe subscriptions create \
  --customer=$CUSTOMER \
  -d "items[0][price]=$STRIPE_PRICE_ID_MONTHLY" \
  -d "trial_period_days=1" \
  -d "trial_settings[end_behavior][missing_payment_method]=pause"
```

### 5.3 Verify Database State

After webhook processing, verify that:

1. A `Subscription` record exists in the database
2. The `status` field matches the expected `SubscriptionStatus`
3. `stripeCustomerId` and `stripeSubscriptionId` are populated

You can check via:

```bash
npx prisma studio
# or a direct query via the app's subscription status endpoint
```

### 5.4 Verify API Routes

```bash
# These require authentication — test via curl with a valid session cookie or via the app
# At minimum, verify the routes don't crash:

# Check webhook endpoint accepts POST
curl -s -o /dev/null -w "%{http_code}" -X POST http://localhost:3000/api/webhooks/stripe
# Should return 400 (missing signature), NOT 404 or 500

# Check subscription status endpoint exists
curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/api/stripe/subscription
# Should return 401 (no auth), NOT 404 or 500
```

### 5.5 Cleanup

```bash
kill $DEV_PID 2>/dev/null
kill $LISTEN_PID 2>/dev/null
```

### 5.6 Verification Checklist

All of the following must be true before proceeding:

- [ ] `stripe listen` successfully forwarded events to the webhook endpoint
- [ ] `checkout.session.completed` trigger returned `200`
- [ ] `customer.subscription.updated` trigger returned `200`
- [ ] `customer.subscription.deleted` trigger returned `200`
- [ ] `invoice.paid` trigger returned `200`
- [ ] `invoice.payment_failed` trigger returned `200`
- [ ] Webhook endpoint returns `400` for requests without `stripe-signature`
- [ ] Subscription status endpoint returns `401` without auth
- [ ] Database records were created/updated after webhook processing

**If any check fails:** Identify the issue, spawn `backend-engineer` with the error details, fix, and re-run verification.

---

## Step 6: Final Build Gate

Run the complete verification suite:

```bash
npm run typecheck    # Must pass with 0 errors
npm run lint         # Must pass with 0 warnings
npm run test         # All tests must pass
npm run build        # Production build must succeed
```

**If any check fails:**

1. Identify the specific failure
2. Spawn the appropriate subagent (`backend-engineer` for server issues, `frontend-engineer` for UI issues, `testing-engineer` for test issues)
3. Re-run the failing check
4. Repeat until all pass

---

## Step 7: Update PROGRESS.md

After ALL verification passes, update `/docs/tasks/PROGRESS.md`:

```markdown
### $ARGUMENTS: Stripe Subscription Integration

- **Status:** ✅ Completed
- **Date:** <YYYY-MM-DD>
- **Effort:** <actual>

**What was built:**

- Stripe subscription backend (schema, service, 4 API routes, webhook handler)
- Billing settings UI (page + 2 components)
- GDPR integration (subscription cancellation on account deletion)
- TanStack Query hooks for subscription state

**Stripe CLI verification:**

- Webhook delivery: ✅
- Event handling (checkout, subscription, invoice): ✅
- Database sync: ✅
- API routes (checkout URL, portal URL, subscription status): ✅

**Files created/modified:**

- [list from subagent summaries]

**Verification:**

- `npm run build` ✅
- `npm run lint` ✅
- `npm run typecheck` ✅
- `npm run test` ✅
- `stripe trigger` events ✅
```

---

## Output Format

```markdown
# Task $ARGUMENTS: Stripe Integration Complete

## Execution Summary

| Phase | Status | Details |
|-------|--------|---------|
| Pre-flight | ✅ | Stripe CLI v1.x, env vars configured, prices verified |
| Backend | ✅ | X files created, Y modified |
| Unit Tests | ✅ | X tests, all passing |
| Billing UI | ✅ | X components, server-rendered page |
| Component Tests | ✅ | X tests, all passing |
| CLI Verification | ✅ | All webhook events handled, DB state correct |
| Build Gate | ✅ | typecheck + lint + test + build |

## Backend Implementation
[Summary from backend-engineer]

## Frontend Implementation
[Summary from frontend-engineer]

## Testing
[Summary from testing-engineer]

## Stripe CLI Verification Results
- checkout.session.completed: ✅ 200
- customer.subscription.updated: ✅ 200
- customer.subscription.deleted: ✅ 200
- invoice.paid: ✅ 200
- invoice.payment_failed: ✅ 200
- Webhook signature rejection: ✅ 400
- DB state after webhooks: ✅ verified

## Files Changed
- Created: [list]
- Modified: [list]

## PROGRESS.md Updated
- Status: ✅ Completed
- Date: YYYY-MM-DD
```

---

## Error Recovery

### If Stripe CLI Not Installed
```
BLOCKED: Stripe CLI is required for integration verification.
Run: brew install stripe/stripe-cli/stripe && stripe login
```

### If Stripe Env Vars Missing
```
BLOCKED: Stripe environment variables not configured.
Required in .env.local:
- STRIPE_SECRET_KEY (from Stripe Dashboard → Developers → API keys)
- STRIPE_WEBHOOK_SECRET (from stripe listen output or Dashboard)
- STRIPE_PRICE_ID_MONTHLY (create in Dashboard → Products)
- STRIPE_PRICE_ID_ANNUAL (create in Dashboard → Products)
```

### If Dependencies Not Met
```
BLOCKED: Task $ARGUMENTS requires completion of:
- T-XXX: [status]
Please complete blocking tasks first.
```

### If Webhook Verification Fails
1. Check the dev server is running and the webhook route exists
2. Check `stripe listen` output for forwarding errors
3. Check the webhook handler logs for processing errors
4. Spawn `backend-engineer` with the specific error to fix
5. Re-run `stripe trigger` for the failing event

### If Build Gate Fails After Verification Passed
1. Identify which check failed (typecheck, lint, test, build)
2. The failure is likely a type error or lint warning introduced during fixes
3. Spawn the appropriate subagent to fix
4. Re-run only the failing check, then full gate

---

## Subagent Reference

| Subagent | Phase | Responsibility |
|----------|-------|---------------|
| `backend-engineer` | 1 | Schema, migration, env, Stripe client, service, routes, webhooks, GDPR, hooks |
| `testing-engineer` | 2, 4 | Unit tests (Phase 2), component tests (Phase 4) |
| `frontend-engineer` | 3 | Billing page, components, settings nav |
| Orchestrator (you) | 0, 5, 6, 7 | Pre-flight, CLI verification, build gate, progress update |
