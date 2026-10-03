# Phase 12 — Fulfillment, receipt, cancellation and Cancellation Refunds

Implemented on 2–3 October 2026 against the isolated test stack. No deployment, commit, live key or credential change was performed. Provider evidence is Xendit **TEST** or deterministic **SIMULATED** (`FakePaymentGateway`); nothing here proves live refund processing.

## Owner decisions (2026-10-02)

| Decision | Applied as |
| --- | --- |
| Buyer cancellation | Withdraw before Vendor confirmation; cancel before payment while unpaid; at `CONFIRMED` final immediately with a full refund (Payment Processing Fee included, no NRPC retained); at `PROCESSING` a reasoned request the Vendor must finalize within 24 hours (retain only the accepted NRPC, with preparation evidence) or it is finalized with a full refund (`VENDOR_RESPONSE_TIMEOUT_FULL_REFUND`). The Buyer may withdraw the request. Milestones are frozen while it is open. |
| Receipt window | 48 hours from `DELIVERED`/`PICKED_UP`; reminders at 24 h and 2 h; an open problem report or dispute pauses it; the remaining time resumes on resolution. |
| Fulfillment thread on close | Read-only; Buyer, Owner and Store Manager keep history; the Fulfillment Staff assignment ends and staff lose access immediately. |
| Vendor cancellation | Owner, Store Manager and Store Staff. NRPC forfeited, every Buyer-paid amount refunded, reservations released, one NFR event. |

Stated defaults: Fulfillment Staff assignment is optional (Owner/Manager may record milestones and the thread opens without staff); Self-Pickup no-show and live GPS are out of scope.

## Delivered behavior

- **Milestones.** `CONFIRMED → PROCESSING → READY_FOR_PICKUP → PICKED_UP` or `… → OUT_FOR_DELIVERY → DELIVERED`, then `COMPLETED`, all through `OrderTransitionService`. Each milestone has a per-fulfillment `dedupe_key`; a duplicate returns `MILESTONE_ALREADY_RECORDED` without a second event, and an out-of-order milestone returns `ORDER_STATE_CONFLICT`. `lock_version` guards concurrent edits (`STALE_VERSION`). An open Buyer cancellation request blocks milestones (`CANCELLATION_PENDING`).
- **Proof.** Delivery needs a photo, receiver name, receiver kind and optional signature; pickup needs handover confirmation and receiver. Proof files are content-validated, malware-scanned fail-closed, stored privately under the order and streamed only through order-scoped authorized routes. Receiver names are encrypted at rest. Missing proof returns `PROOF_REQUIRED`.
- **Accepted arrangement.** Dispatch and trips read the accepted vehicle/count/trip/fee and address snapshot. A vehicle outside the accepted arrangement returns `VEHICLE_NOT_IN_ACCEPTED_ARRANGEMENT`; a repeated trip returns `TRIP_ALREADY_RECORDED`. Staff report vehicle issues but cannot change commercial terms.
- **Receipt.** Buyer confirmation or the scheduled sweep (`materyalph:fulfillment-sweep`, every 5 minutes) completes the order once, earns FIN-03 commission once, closes the thread and emits `ORDER_COMPLETED`. Late flags notify both parties without cancelling.
- **Fulfillment thread.** Created or reused inside the first valid `READY_FOR_PICKUP`/`OUT_FOR_DELIVERY` milestone transaction — one per order, never before. Participants are the Buyer, the current active assignee and permitted Owner/Manager; no sales-thread exposure; public identity and role only. Reassignment and closure revoke access immediately (`CONVERSATION_READ_ONLY` on send/upload) while history stays.
- **Cancellation finalization.** One transaction locks the order, records one decision (unique per order), closes open payment attempts, releases reservations and physical obligations, creates exactly one `CANCELLATION` refund per source payment from the original line/discount/VAT allocations capped by successful plus in-flight refunds, records an NFR event for Vendor cancellation, opens `ADJUSTMENT_REQUIRED` for posted CWT without touching FIN-04A, and moves the five state families. The provider refund request is queued post-commit.
- **Refunds.** `REFUND_PENDING` until a verified webhook (provider ID, amount, currency, reference, state, replay uniqueness, then authoritative `GET /refunds/{id}`) or reconciliation sets `REFUNDED` or `REFUND_FAILED`. A rejected or uncertain request stays pending or fails with a finance review item and an Owner notice. Only the Owner retries (`attempt_number + 1`, per-attempt idempotency key), always to the original method. A paid commission statement credit becomes `PLATFORM_FEE` + `FEE_CREDIT` tied to the original fee capture. Refunds never open a dispute.
- **Cash reimbursements.** `VENDOR_REIMBURSEMENT_PENDING` → `REIMBURSEMENT_CONFIRMED` by Buyer acknowledgment after the Vendor records evidence, or by an Admin decision with a reason; never a provider state.

## Client surfaces

- **Buyer app:** Order Details milestone tracker with proof attached to the Delivered/Picked up step (photo read through the API), receipt countdown or paused state, **Confirm receipt** (asks first) and **Report a problem** (category, description, one photo), resolve; cancellation section that always shows the server explanation, remedies when disabled, a cancel sheet with the server refund plan and reason chips, and withdraw-request; **Refunds and reimbursements** where *Refund initiated — not yet received* and *Refund processed* differ in label, icon and color; **Fulfillment Messages** entry and read-only chat banner.
- **Vendor web:** fulfillment workspace with milestone stepper and proof form on the step that requires it, accepted arrangement and next trip, assignment, vehicle issues, problem response, receipt status, cancellation dialog with server preview, finalize-request with NRPC evidence, refunds with Owner retry, reimbursement recording, read-only thread banner.
- **Admin web:** `/order-operations` — refunds (failed first, retry), cash reimbursements (decide with reason), open cancellation requests, summary counts.
- **Shared:** `packages/web-ui/src/fulfillment-patterns.tsx` and `apps/buyer-mobile/lib/design_system/components/fulfillment_components.dart`.

## Automated coverage

| Area | Tests |
| --- | --- |
| API feature | `tests/Feature/Api/PhaseTwelveFulfillmentTest.php` — pickup milestones, duplicates/reordering, single completion earning; dispatch snapshot and staff commercial lock; auto-confirm, pause and dispute; Buyer cancellation table and unavailability text; PROCESSING request with NRPC retention and timeout; Vendor mixed-NRPC cancellation with tax review and reimbursement; provider timeout/rejection/retry; forged and mismatched refund events; thread scope and revocation; Admin operations and paid fee credit. |
| API unit | `tests/Unit/PhaseTwelveRulesTest.php` — milestone lifecycle on the shared state machine, refund-family transitions and retry from failure, provider refund status mapping and per-attempt idempotency, owner-approved timers and reason codes. Refund allocation arithmetic is covered by the feature tests. |
| Contract | `npm run test:fulfillment-contract` (26 operations, transports, idempotency headers, FIN-07 enums, no GPS fields) plus all earlier contract checks. |
| Vendor web | `OrderFulfillmentPanels.test.tsx` (6). |
| Admin web | `OrderOperationsPage.test.tsx` (2). |
| Buyer app | `test/order_fulfillment_test.dart` (5): proof on step, countdown, confirm-after-ask, read-only thread entry; problem report validation and one photo; paid cancellation plan, reason validation and initiation-only notice; initiated vs processed styling and reimbursement acknowledgment; generated-client mapping. |

## Results (3 October 2026)

| Gate | Result |
| --- | --- |
| `vendor/bin/pint --test` | PASS, 541 files |
| `vendor/bin/phpstan analyse` | No errors |
| `php artisan test` (explicit paths, see limitations) | 508 passed (8369 assertions), 405.9 s |
| `npm run validate` + 11 contract checks | All passed |
| vendor-web lint / typecheck / test / build | Pass / pass / 234 passed / pass |
| admin-web lint / typecheck / test / build | Pass / pass / 39 passed (one intermittent failure under concurrent load; four consecutive clean reruns) / pass |
| buyer-mobile `flutter analyze` / `flutter test` | No issues / 259 passed, 1 skipped |
| `docker compose config --quiet` | Pass |
| gitleaks (staged, unstaged diff, untracked files) | No leaks |
| `git diff --check` | One pre-existing trailing space in `apps/buyer-mobile/pubspec.yaml` (not part of this phase) |

## Manual setup

No new keys. Refunds use the existing `XENDIT_SECRET_KEY` (TEST) and `XENDIT_WEBHOOK_VERIFICATION_TOKEN`; enable refund events for the same TEST webhook URL `https://<api-host>/api/v1/webhooks/xendit`. Migration `2026_10_07_000000_create_phase_twelve_fulfillment_cancellation.php`.

## Known limitations

- Self-Pickup no-show handling and live GPS are out of scope.
- The formal dispute flow is Phase 13; Phase 12 shows remedies in text and pauses auto-confirmation for an existing dispute state.
- PHPUnit directory discovery on the Windows bind mount finds only part of `tests/Feature`; the suite is run with explicit paths.
- The Buyer app sends one problem photo per report (the API accepts up to three).
