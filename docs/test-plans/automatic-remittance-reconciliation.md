# Automatic recorded remittance reconciliation

Owner request: 8 November 2026. Accountant staff use the existing `ADMIN_FINANCE` role, as explicitly confirmed by the owner.

## Delivered behavior

New posted TEST platform-withholding assessments publish `REMITTANCE_RECONCILIATION_REQUESTED` in the source transaction. The existing outbox worker checks them after commit. `materyalph:remittances-reconcile` recovers up to 200 missed pending records every minute, without overlap. The existing Admin Run reconciliation command also checks these recorded remittances and returns their reconciled/exception counts.

The checker compares the linked successful non-late merchant payment, one collection allocation, original assessment arithmetic and exact balanced DEMO ledger entries for collection, provider charge, CWT and remittance. Duplicate or inconsistent ledger entries, a mismatching reported deduction, a full refund or unresolved tax adjustment cannot be approved away. Failed checks create one exception work item and an audit event. Voided assessments are historical and have no approval action.

An assessment is reconciled at most once. A new append-only decision records automatic versus backup processing, original source version, verified source/ledger references, reason, actor/role, timestamp, correlation and TEST/SIMULATED origin. Only `reconciliation_state` and its update timestamp change on the assessment. Original money, tax profile/rate, ledger entries and FIN-04A accumulators remain unchanged. The deduction evidence remains `SIMULATED_WITHHELD`; this confirms the recorded TEST flow, not a real settlement, BIR filing or BIR payment.

## Authorization and API

Backup approval requires all of:

- An active Admin account and current membership in `ADMIN_SUPERADMIN` or `ADMIN_FINANCE`.
- `finance.view` and the new `finance.approve_remittance_reconciliation` permission.
- Recent authentication, normal protected web cookie/CSRF transport and a reason of 10–2,000 characters.
- The current assessment `source_version`, an `Idempotency-Key`, and freshly passing source/ledger checks under the assessment lock.

`POST /api/v1/admin/finance/remittances/{assessmentId}/approve-reconciliation` accepts `source_version` and `reason`. Identical retries return the original decision. A reused key with another body, stale source or already completed assessment conflicts. Other roles cannot approve even if given a copied permission. Revoked membership/permission and expired recent authentication are rejected.

The existing remittance list adds the source version, caller-specific approval availability, method, approving role and reconciliation time. The Admin ledger displays these and a shared compact approval dialog. A retry keeps the same key and source version. Errors leave the dialog open; success reloads the selected queue. The register source link opens reconciled records for the selected month. The All filter remains removed. Separate tax-package review, independent reviewer rules and export/submission statuses are unchanged.

OpenAPI and both generated clients were updated; Dart serializers were regenerated. No new environment key or provider configuration is needed.

## Files and migration

- `services/api/database/migrations/2026_11_08_010000_add_remittance_reconciliation_decisions.php`: append-only decision table, constraints, and narrowly scoped permission grants. Works on the existing schema and after empty-database migrations; rollback retains financial history.
- `services/api/app/Domain/Finance/RemittanceReconciliationService.php`: source/ledger checks, automatic recovery, restricted backup approval, idempotency and audit.
- Existing assessment/outbox/console services: post-commit handler and scheduled recovery.
- Existing Admin Finance service, operations controller/routes and list projection: run command, approval endpoint and decision metadata.
- `apps/admin-web/src/pages/FinanceOperationsPanels.tsx`, Finance page/API wrapper and withholding-register link: method display, restricted approval dialog and relevant result/context links.
- `packages/api-contract/openapi.yaml`, generated TypeScript/Dart clients and serializers, contract scripts, workflow/planner documentation and focused regression tests.

## Executed verification

- New reconciliation feature coverage, including both authorized roles, queue recovery, amount/history preservation, duplicate ledger rejection, mismatch/full-review safeguards, retries, stale backup versus automatic completion, expired identity verification, copied permission denial, revoked access and append-only decisions.
- Isolated backend regression command: `php artisan test --filter='RemittanceReconciliationTest|PhaseElevenFinanceFlowsTest|PhaseElevenWithholdingThresholdTest|PhaseElevenPaymentsTest|PhaseFifteenExportsTest|PhaseSixteenAdminOperationsTest|PhaseElevenFinanceRulesTest'`: **86 passed, 1,292 assertions**.
- Full Admin command: `npm.cmd run test -- --run --maxWorkers=2 --testTimeout=30000`: **51 files, 383 tests passed**. Focused Finance/register UI coverage passed **36 tests**, including backup failure/retry with a stable key and denied-action presentation.
- Admin lint, typecheck and production build passed. The existing large-chunk build advisory remains.
- Full PHPStan passed with no errors. Focused Pint passed on **11 changed PHP files**.
- OpenAPI validation passed with eight existing unused-model recommendations. TypeScript/Dart generation, generated TypeScript build, Dart serializer generation, `test:admin-finance-contract` and `check-withholding-register.dart` passed, including approval transport and exact source/method/actor serialization.
- The running development server serves the updated approval dialog, automatic explanation and regenerated approval method.
- Compose configuration validation, full whitespace review and redacted task-source/staged secret scans passed. No staged content was present.
- Full backend, Vendor and Buyer suites were not run. Browser visual acceptance was unavailable: Computer Use reported no native pipe or browser access host. API, component, source-delivery and local-data checks do not replace authenticated visual or live-provider/BIR acceptance.

## Local application and data result

The additive migration was applied only to the verified local development database with DEMO mode and disabled live commerce. No other pending migration was applied. Before/after captures are in ignored `.tmp/withholding-month/automatic-live-before.json` and `automatic-live-after.json`.

All **4 posted assessments / 508 centavos** changed from Pending to Reconciled automatically; **0 exceptions** were found. Four immutable AUTOMATIC decisions were recorded. The financial-history digest covering original assessment money, DEMO ledger entries and withholding accumulators matched before and after. The two voided assessments remain historical; their original 892 centavos are excluded from the active withholding register.

A final read-only projection check, using an existing active authorized Admin through the same domain access checks, returned all four October rows with `AUTOMATIC` / `SYSTEM` decisions and timestamps. Completed rows expose no backup approval action. The register defaults to October 2026 and returns the same four assessments / 508 centavos. This was a local service projection check, not an authenticated browser session.

The local worker container was restarted to load the new outbox handler. This service uses `queue:work`; its container name is `horizon`, but the local installation does not expose `horizon:terminate`. The one-minute recovery schedule was verified as `* * * * *`. No deployment, push, merge, real money movement or BIR submission was performed.

Suggested commit: `feat(finance): automate remittance reconciliation with restricted backup approval`.
