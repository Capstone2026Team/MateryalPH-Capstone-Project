# Phase 13 — Transaction disputes, appeals, Dispute-Conclusion Refunds and Vendor invoices

Implemented on 3–4 October 2026 against the isolated test stack. No deployment, commit, live key or credential change was performed. Refund evidence is Xendit **TEST** or deterministic **SIMULATED** (`FakePaymentGateway`); uploaded invoice copies in TEST mode are labelled **DEMO** samples. Nothing here proves live refund processing or a BIR-compliant invoice.

## Owner decisions (2026-10-04)

| Decision | Applied as |
| --- | --- |
| Order state | `DISPUTED` only while the order awaits receipt (`DELIVERED`/`PICKED_UP`); automatic receipt confirmation pauses. A pre-handover case leaves fulfillment running; a completed order stays `COMPLETED`. At case end `DISPUTED → COMPLETED` (commission earned then; an awarded refund opens the fee-credit proposal). A Full Refund decided before handover cancels the order. |
| Refund timing | Immediately enforceable decisions execute at once; otherwise the remedy executes when the five-business-day appeal window lapses unappealed. An appeal decision is final and executes immediately. |
| Appeals | One per case, on `NEW_EVIDENCE` or `MATERIAL_PROCESS_ERROR`; the reviewer must not be the original decider (`CONFLICT_OF_INTEREST`). |
| Sanctions | Warning and confirmed metric events take effect at execution; Temporary Restriction, Suspension and Permanent Ban are recorded and referred to User Management Staff (applied in Phase 16). |

## Delivered behavior

- **Filing** creates a Case ID (`CASE-yymmdd-XXXXXX`) and a dispute state only — never a refund. The form takes issue type, affected lines, requested remedy, partial amount, description and evidence; the original payment method is shown masked and read-only. Any refund-destination field is rejected (`REFUND_DESTINATION_NOT_ACCEPTED`).
- **Timers (Asia/Manila, shown as countdown plus exact date/time):** 48 h response, 72 h mutual resolution, 24 h clarification, appeal within 5 business days (Mon–Fri). Expired windows are handled by `materyalph:disputes-sweep` (every minute); a late action returns `409`.
- **Timeline:** one append-only `dispute_events` stream per case (actor, role, timestamp, statement, evidence). Evidence is private, content-validated, malware-scanned fail-closed and opened only through authenticated, signed five-minute URLs that re-authorize on every read.
- **Decisions** are immutable and versioned (`ADMIN_DECISION`, `APPEAL_DECISION`, `MUTUAL_AGREEMENT`); each needs a remedy, a reason, a conflict-of-interest confirmation, the current `lock_version`, and an evidence-limitation note when a clarification went unanswered.
- **Outcomes:** Dismissed, Replacement, Full Refund, Partial Refund, Inconclusive, plus Warning, metric event, Restriction, Suspension, Ban.
- **Dispute-Conclusion Refund:** only a concluded money decision creates exactly one idempotent `DISPUTE_CONCLUSION` refund per decision version and source payment, linked to the Case ID, allocated with the FIN-07 line/discount/VAT allocations and capped by what is still refundable. It is separate from `CANCELLATION`, tracks `REFUND_PENDING` until verified, opens a fee-credit proposal and a `DISPUTE_REFUND_AFTER_ASSESSMENT` tax review, never amends a filed return, and always returns to the original payment method. Cash payments become a Vendor reimbursement. **The case is not resolved until every remedy completes.**
- **Staff dispute flag (Owner only):** enabled by default for Store Staff and Customer Service. Disabling revokes navigation, direct routes, API, Reverb channel joins, evidence files, exports and queued notifications (re-authorized at delivery), reassigns open cases to the Owner (Manager fallback), cancels queued staff exports (`STAFF_DISPUTE_ACCESS_DISABLED`) and keeps every original submission and author. Re-enabling restores only current scope. Fulfillment Staff gain no case management — only a limited view and fulfillment evidence on assigned orders. Voluntary refund offers stay Owner-only; Admin-decision execution is unchanged.
- **Invoices (FIN-09):** Owner, Store Manager and Store Staff upload the official Vendor invoice copy; Customer Service sees status only; no protected finance (commission, withholding, earnings) is exposed. Issuer must match the registered business (`INVOICE_ISSUER_MISMATCH`); numbers are unique per issuer (`INVOICE_NUMBER_DUPLICATE`). A total that differs from the accepted order is flagged `INVOICE_RECONCILIATION_REQUIRED` and never changes the Buyer's total. Buyer copy/correction requests carry a three-business-day service target that is not an extension of the legal issuance duty. MateryalPH purchase-order and payment documents are always labelled *Not a tax invoice*.

## Client surfaces

- **Buyer app:** `lib/features/disputes/` — case list (Orders → Disputes), filing form, case workspace (deadlines, complaint, decisions, Dispute-Conclusion Refunds, timeline with signed evidence, server-allowed actions: respond, propose/answer, clarification, appeal, replacement confirmation, evidence/message, escalate), and Order Invoices (copies, requests, billing details, platform documents). Order Details gains a *Disputes and invoices* section. Shared widgets in `lib/design_system/components/dispute_components.dart`.
- **Vendor web:** `/disputes` (groups, search, exports), `/disputes/new`, `/disputes/:caseId`, `/invoices`; order page case panel and invoice upload panel. Navigation and pages follow the flag; denied roles see an explanation.
- **Admin web:** `/disputes` queue and case review (assign, escalate, clarification, decision and appeal forms with conflict check, remedy confirmation) and the read-only `/invoices` Invoice Request Log.
- **Shared web:** `packages/web-ui/src/dispute-patterns.tsx`.

## Automated coverage

| Area | Tests |
| --- | --- |
| API feature | `tests/Feature/Api/PhaseThirteenDisputesTest.php` (7 tests, 382 assertions) — filing and destination rejection, timers and sweep, mutual agreement, clarification and decision, enforceable vs appeal-window execution, appeal conflict and finality, refund creation/idempotency/failure/retry and remedy completion, flag revocation during an open case and export job, transfer to Owner/Manager, retained history, re-enable scope, invoice upload scope, issuer/duplicate/reconciliation and absence of protected finance. |
| API unit | `tests/Unit/PhaseThirteenRulesTest.php` (5) — business-day arithmetic, state transitions, issue/remedy catalogs. |
| Contract | `npm run test:disputes-contract` (58 operations, transports, signed links, idempotency, enums, no refund destination) plus all eleven earlier contract checks. |
| Vendor web | `src/pages/DisputePages.test.tsx` (6) — role denial, Owner-only refund, rejection needs evidence, Fulfillment limited view, Customer Service invoice status only, upload validation and single keyed request. |
| Admin web | `src/pages/DisputePages.test.tsx` (6) — queue, decision validation and single submission, evidence limitation, appeal reviewer conflict, server error, invoice log has no create action. |
| Buyer app | `test/disputes_test.dart` (12) — filing without destination and one key, offline retry key reuse, ineligibility, Manila deadlines and signed evidence, expired link reload, server-allowed actions and proposal confirmation, remedy tracking and appeal evidence, conflict reload, Order Details entry, invoice requests and mismatch notice, forbidden state. Golden `docs/design/evidence/phase-8/390-order-hub.png` regenerated for the new Disputes action. |

## Manual checks still required

1. Xendit TEST refund for a dispute award through the sandbox webhook (no live key).
2. Reverb channel join/revocation with two browsers while the Owner toggles the staff flag.
3. Screen-reader pass of the decision form and the Buyer case workspace.
