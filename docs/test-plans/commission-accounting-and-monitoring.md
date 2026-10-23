# Platform Finance and Vendor commission monitoring

Implemented 2026-10-19 under the owner-approved FIN-03 update. Renamed Platform Finance on 2026-10-24 (Admin workflow owner decision of that date).

## 2026-10-24 Platform Finance overview

- API: `PlatformMoneyFlow` reads confirmed orders, verified Buyer payments, recorded cash, confirmed refunds and cash reimbursements live; `FinanceOperationsService::kpis` returns them in `commerce`, adds `payment_methods`, the `gmv_centavos`/`buyer_payments_centavos`/`buyer_refunds_centavos` trend fields and the `open_work_items`, `overdue_statements`, `confirmed_orders`, `online_payments`, `cash_records` and `pending_buyer_refunds` counts. GMV no longer reads the rebuilt `analytics_order_facts` snapshot.
- Feature tests (`PhaseElevenFinanceFlowsTest`, `PhaseTwelveFulfillmentTest`, `PhaseSixteenAdminOperationsTest`): NRPC assurance plus online balance count GMV once; Admin Buyer payments equal the Vendor Earnings online collections plus Buyer fees and physical collections for the same records; payment methods add up to the received total; a confirmed cancellation refund is cancelled value, never refunded value too; a failed refund is in progress, never returned; Buyer payments never become platform-held funds; marketplace and platform keys never overlap.
- Contract: `check-admin-finance-contract.mjs`. Component tests: `FinancePages.test.tsx`. Layout evidence: `apps/vendor-web/e2e/admin-finance-layout.spec.ts` at all eight viewports, screenshots in `docs/design/evidence/admin-finance/`.

## Result

Admin Finance is organized as Overview, Commission Management, Payments and Refunds, and Reconciliation. Commission Management shows the current/scheduled percentage, protected editing, effective Manila date, calculation preview and paginated policy history. Overview uses four compact cards with expandable calculations, actionable finance tasks and one chart with its data table. Supporting tax/evidence records and existing review commands remain accessible.

Vendor navigation calls the existing Transactions module Finance. `/finance/commissions` provides Owner-only commission monitoring: current/scheduled policies and acceptance, estimated fees, earned fees and approved credits, unbilled amounts, draft bills, issued unpaid/overdue bills, verified allocations and confirmed fee refunds. The paginated order table shows the saved percentage and materials basis. Links use the existing statement payment and Store Verification consent flows.

The initial rate remains 2.00%. Publishing creates an immutable fee-policy version and hash-verified terms, with an audit event and Owner notices. New transactions require the current Owner's acceptance and any current authority approval. Published quotations and accepted orders retain their original policy; subsequent earning, credits and refunds use that saved rate. Mixed-rate monthly bills identify rates on their source lines and have no misleading statement-wide policy ID. Statutory tax rules, Buyer totals, billing deadlines and provider TEST isolation are preserved.

## Main implementation files

- API: `CommissionPolicyService`, `VendorCommissionService`, `FinancialSnapshotService`, `FeeAssessmentService`, `CommissionService`, `StatementService`, `FinanceOperationsService`, `VendorFinanceService`, `AccountAgreements`, `AgreementContent`, `AdminFinanceController`, `VendorFinanceController`, and `routes/payments.php`.
- Admin: `CommissionPolicyPanel.tsx`, `FinancePages.tsx`, `FinanceOperationsPanels.tsx`, `lib/finance-api.ts` and focused component tests.
- Vendor: `FinancePages.tsx`, `PhaseThreeVendorPages.tsx`, `App.tsx`, `lib/finance-api.ts`, affected commission disclosures and component tests.
- Shared UI: `CommissionRateSummary`, optional expandable `KpiCard` calculations, and the versioned agreement panel without a fixed-rate badge.
- Contract: `openapi.yaml`, regenerated TypeScript/Dart clients, `check-admin-finance-contract.mjs` and `check-commission-policy.dart`.
- Authority: the System, Admin and Vendor workflows and UI/UX implementation planner record this owner decision.

## API contract and authorization

- `GET /api/v1/admin/finance/commission-policies`: `finance.view`; current/next policies, `can_manage`, latest concurrency version and paginated history.
- `POST /api/v1/admin/finance/commission-policies`: `finance.view` plus `platform_settings.manage`, recent authentication, CSRF, UUID Idempotency-Key, expected latest version and a reason. Integer basis points support 0.00–100.00% in 0.01% steps. Effective time is now or future; backdating and insertion before a scheduled policy are refused. Identical retries replay one result; changed payloads conflict.
- `GET /api/v1/vendor/finance/commissions`: current active Vendor Owner only. All order, statement and cash queries are scoped to the Owner's organization. No staff access, raw provider payload, credentials or private tax evidence is added.
- `FeeAssessment.commission_basis_points` is a validated range rather than a fixed 200. Nullable policy references use OpenAPI 3.1 null unions. Statement source lines include their original rate. Existing credit preparation/approval still requires different named users.

## Migration and local readiness

`2026_10_21_000000_version_commercial_commission_rates.php` adds policy-to-agreement links, reasons, immutable database-backed published terms, bounded percentage constraints, a policy lookup index and history protection. It supports an empty schema and the existing schema. Rollback refuses to discard newly published policy/consent history.

The migration passed isolated schema creation and was applied narrowly to the normal development API as batch 57. Its migration status is Ran. All three new routes are registered, Compose configuration validates, and a read-only development query confirmed the existing rate is still 200 basis points (2.00%). No commercial rate was published against development during verification. No additional credentials or environment keys are needed.

## Verification

- Isolation guard: static/live guards and negative guard cases passed. All API runs used the dedicated `materyalph_phase1_test` project sequentially.
- Related isolated API regression: **82 passed, 1,843 assertions**, covering Finance Flows, Payments, Vendor Earnings Trend, Admin Operations, Financial Calculator and Finance Rules.
- Final focused commission regression: **4 passed, 88 assertions**. Covers permissions, recent authentication, idempotent replay/changed-body conflict, stale versions, immutable records, invalid/scheduled rates, readable new terms, consent rejection without a new assessment, original rates and credits, mixed-rate billing and store-scoped monitoring.
- Full PHPStan: no errors. Pint check of changed PHP files: passed.
- Admin lint, typecheck and production build: passed. Full component suite: **24 files, 132 passed**. Final Finance component rerun: **12 passed**.
- Vendor lint, typecheck and production build: passed. Focused Finance suite: **32 passed**. Full component suite: **575 passed, 6 failed across 63 files**. The six failures are confined to `OrderPages.test.tsx` and reproduce with the prior order fee wording restored: missing Order Documents links, the customer-service confirmation expectation, the old NRPC checkbox expectation, and the two direct-order Message/navigation cases. Baseline reproduction: **36 passed, the same 6 failed**. Final source wording was restored after this diagnostic check.
- OpenAPI validation: passed, with the eight existing unused-model recommendations. TypeScript/Dart source generation and generated TypeScript build: passed.
- Admin Finance, Payments and Earnings JavaScript contract checks: passed. Commission Policy Dart serialization contract: passed.
- Dart serializer generation: passed. Analysis of the nine new models/envelopes and two affected API files: **11 files, no issues**. Full generated-library analysis reports only the existing `unused_element_parameter` warnings in unchanged `directory_review_ratings_value.dart` and `geo_demand_cell_value.dart`; generator logs confirm those sources were unchanged.
- Changed production source/contract secret scan: no leaks. Code whitespace checked separately from the planner's existing intentional Markdown hard breaks.

Both Vite builds retain the existing large-chunk warning. Browser/device and live-provider journeys were not run. Buyer runtime source was not changed; generated Dart compatibility was checked instead of rerunning the Buyer application suite.

## Manual acceptance

1. In Admin Finance → Commission Management, review the current 2.00% rate, then test an authorized current or future rate with a reason and the protected identity check. Verify the history and concurrency conflict behavior.
2. As the Vendor Owner, open Finance → Commission Monitoring. Review current/scheduled percentages and the original percentage on earlier orders. Accept effective revised terms through Store Verification before new transactions use the new rate.
3. Complete orders at different rates, draft the monthly bill, and verify its source lines and original-rate return credits. Use TEST statements/payments only.

Suggested commit: `feat(finance): add versioned commission rates and vendor monitoring`.
