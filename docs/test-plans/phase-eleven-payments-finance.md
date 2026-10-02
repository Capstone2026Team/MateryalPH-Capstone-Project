# Phase 11 — Payments, fees, withholding threshold and Vendor finance

Implemented on 2 October 2026 against the isolated test stack. No deployment, commit, live key, development-database change or credential change was performed. All provider evidence is Xendit **TEST** or deterministic **SIMULATED**; nothing here proves live payment processing, production KYC or statutory withholding.

## Owner decisions (2026-10-02)

| Decision | Applied as |
| --- | --- |
| Fee schedule | Versioned DEMO schedule from Xendit's published PH rates, effective 2026-10-02 +08: Cards 3.2% + ₱10.00, GCash 2.3%, Maya 1.8%, GrabPay 2.0%, ShopeePay 2.0%, each plus 12% VAT on the fee. Server gross-up so the Vendor receives the principal; snapshot per attempt; labelled DEMO. |
| Channels | Cards and the four e-wallets only. QR Ph, OTC, direct debit and bank transfer disabled with `REFUND_ROUTE_UNAVAILABLE`. One channel per provider session. |
| Physical payments | Owner-only COD / In-Store toggles, default off, one policy for Item checkout, quotations and Project packages; delivery/pickup pairing unchanged. |
| Remittance grouping | One remittance group per verified collection; FIN-04A assesses that group as one remittance. |

## Delivered behavior

- **Payment attempts.** `FULL_ORDER_PAYMENT`, `NRPC_ASSURANCE_PAYMENT` (credited once against the physical balance; its fee is not credited) and `ORDER_BALANCE_PAYMENT` (only after Owner/Manager approval; uses the lowest remaining obligation, so NRPC is never charged twice). One open attempt per order and purpose; one non-late `PAID` per order and purpose. Each attempt snapshots channel fee version, principal, fee, total, provider account, account contract version, provider API version, environment and evidence origin. Order-scoped idempotency keys are separate from Phase 3D provisioning keys.
- **Account revalidation.** Every create checks the organization-bound reconciled TEST association through the adapter (environment, association, purpose, capability). A raw provider `LIVE` returned under TEST credentials is never shown as production. No second account is provisioned and no pasted link/ID is accepted.
- **Window.** The order's Pending Payment window is 24 hours (`payments.order_window_hours`, `ORDER_PAYMENT_WINDOW_HOURS`); each checkout session lasts 45 minutes and never past the deadline; an attempt is refused with `PAYMENT_WINDOW_TOO_SHORT` when fewer than the provider minimum (10 minutes) remain. Expiry reconciles first, then expires open attempts and queues provider cancellation post-commit.
- **Webhooks.** `POST /api/v1/webhooks/xendit` checks `x-callback-token` in constant time, enforces a 64 KB limit, stores the encrypted payload once per `webhook-id`, acknowledges, and processes asynchronously. Processing rechecks provider IDs, amount, currency, reference, sub-account and the allowed transition, then retrieves the session authoritatively before `PaymentSettlement` (the only `PAID` writer) confirms. Mismatches open a finance review item and never mark anything paid. Xendit documents no HMAC signature for these callbacks, so verification is token plus authoritative retrieval.
- **Reconciliation.** Scheduled every 5 minutes for attempts older than 2 minutes; uncertain creates close only after expiry plus a 15-minute grace. A capture proven after failure/expiry becomes `CAPTURED_LATE_REFUND_PENDING` with one `TECHNICAL_COMPENSATION` refund and a review item. Return pages are safe Pending pages; neither a return URL nor a Buyer refresh can confirm a payment.
- **FIN contract.** `G = C − R − D_r − V_r − P`; `W = half-up(G × 0.005)` when subject; expected Vendor cash `C − R − P − W`; `commission_deducted_in_remittance = 0`. Commission is ESTIMATED at confirmation and EARNED (2%) on completion with balanced ledger batches; credits are proposals until Admin approval.
- **FIN-04A.** `vendor_withholding_accumulators` (unique environment + taxpayer key + taxable year) is locked `FOR UPDATE` per remittance, never across a provider call. The crossing remittance is taxed in full; the status is sticky for the year; a declaration recorded after crossing changes nothing; a new year opens `SUBJECT_PRIOR_YEAR` when the prior year crossed. `EXEMPT`/`SUBJECT_TO_WITHHOLDING` are never persisted. Status events are append-only, the crossing event is unique, and assessments snapshot before/after status and `g_effective`. An 80% advisory is sent once; every flip to subject sends a mandatory, non-disableable Owner notice.
- **Statements.** Drafted 00:05 Manila on the 1st, approved by the 3rd, due on the 15th or issue + 12 days; Owner pays positive balances with `PLATFORM_FEE_PAYMENT` to the platform TEST account (45-minute attempts, platform absorbs the fee, no auto-debit or splits). Overdue notices and finance-review escalation run daily at 00:10 Manila.
- **Physical payments.** Obligation opened at acceptance; collections recorded by Owner, Store Manager or Store Staff with evidence and `Idempotency-Key`; online balance credits; Buyer acknowledges each record once. Corrections are not yet implemented (see limitations).
- **Authorization.** Earnings, Transaction History, statements, exports, notices and finance dashboard fields are Owner-only; Store Manager operational access does not grant them. No wallet, balance or escrow. Admin finance keeps preparer ≠ reviewer. The single V4 Commission Terms acceptance is reused.

## Client surfaces

- **Vendor web:** `/finance` (Xendit TEST connection, Tax Profile summary, withholding arrangement with "Production assignment unconfirmed", Commission Terms, online channels, physical payments, refund capability, threshold panel), `/finance/transactions` with CSV export, `/finance/statements/:id` with Pay and status checks, `/finance/earnings`; order payment panel for physical records and online-balance approval.
- **Admin web:** `/finance` queue, payments, withholding accumulators, statements and channel schedule; accumulator detail with overlap resolution.
- **Shared:** `packages/web-ui/src/finance-patterns.tsx` — DemoLabel, WithholdingStatusBadge (text + icon), ThresholdPanel (year, cumulative pesos, remaining floored at zero, crossing date/time in Asia/Manila, crossing-final sentence), PaymentAttemptBadge, PaymentChannelList, FinanceSection.
- **Buyer app:** checkout payment-method selection per store; Order Details **Pay now** / **View pending payment**, payment section with verified payment, latest attempt and Vendor physical records with one-time **Confirm**; channel screen with DEMO fee and total; Pending screen that re-checks on resume, manual check and slow poll, and shows success only for `PAID`. `materyalph://payments/...` only brings the app forward.

## Validation evidence

The 24-hour Pending Payment follow-up, exact check results, migrations, and remaining runtime limits are recorded in [Pending Payment window verification](pending-payment-window-verification.md).

See the final report of 2 October 2026 for exact command results. Covered fixtures: success, pending, failed, expired, forged token, duplicate webhook, reordered events, mismatched amount/currency/reference/sub-account, provider timeout (before and after create), reconciliation, late capture compensation; FIN-06 arithmetic; FIN-04A exactly-at-limit (₱500,000.00 stays relief), ₱500,000.01 crossing, full crossing-remittance taxation, post-crossing declaration, year rollover, and two concurrent settlements against live PostgreSQL (forked processes).

## Manual setup

Key names only (values stay in ignored env files): `XENDIT_SECRET_KEY` (TEST), `XENDIT_WEBHOOK_VERIFICATION_TOKEN`, optional `XENDIT_PLATFORM_ACCOUNT_ID`, `PAYMENT_GATEWAY` (`xendit` or `fake`). Configure the Xendit TEST dashboard Payment Session webhook to `https://<api-host>/api/v1/webhooks/xendit`; return URLs need an HTTPS `APP_URL`. Apply migration `2026_10_05_000000_create_phase_eleven_payments_finance.php` to development only after explicit approval.

## Known limitations

Physical-payment corrections, special relief rates other than the standard threshold path, and automatic refund of statement fee credits (held as payable review items) are not implemented. Cancellation and dispute refunds remain Phase 12. Fee rates are DEMO published rates, not a contracted schedule.
