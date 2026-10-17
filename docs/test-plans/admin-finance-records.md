# Admin recorded finance and commission reporting — 2026-10-15

## Outcome and financial rules

Admin Transactions and Finance defaults to Platform Earnings. The simulated-figures badge and Tax Adjustments controls are removed. Threshold and overlap reviews use the existing work queue. The page retains shared cards, tables, status badges, date filters, charts, authorization and protected exports.

Both portals use `CommissionService::movements`: original completed-material commission earnings and negative approved credits, dated by `earned_at` and `approved_at`. These are integer centavos. Verified commission collections use original payment allocations; successful fee refunds use `completed_at`. Pending/failed refunds do not count as refunded cash. Approval reverses revenue once; payment collection and refund settlement do not earn/reverse revenue again. Net platform earnings are posted fee revenue excluding fee VAT, after credits, less actual recorded platform commission-payment processing expense.

Approved credits append to the original bill and reduce its unpaid debt. A credit exceeding the remaining debt becomes a separate refund payable against original platform-fee captures. Gross paid allocations remain recorded. Outstanding debt is floored at zero; settled, draft and voided statements are excluded from overdue results. Due dates remain the existing Manila billing policy. Generated `overdue=true` query values are accepted. Both portals read the same statement balances.

Monthly charts and the table use recorded events, bounded to the most recent 120 recorded months in the selected range. Earnings, credits, cash and refunds use event dates. Current debt filters use statement issue dates; unbilled pending fees use earning dates. Negative net earnings or credit-only periods remain valid. Payment rows separately show captured total, confirmed refunds, net collected and pending/failed refund indicators. Original provider environment and evidence origin remain visible.

Tax adjustment records, backend APIs, two-person review rules, immutable ledger postings and reporting dependencies are preserved. No live-provider, withholding responsibility, credential or BIR-filing configuration changes were made. No additional configuration keys are required.

## Files and contract

- Admin: `src/pages/FinancePages.tsx`, `FinanceOperationsPanels.tsx`, `FinancePages.test.tsx`, `PhaseSixteenPages.test.tsx`, and `src/lib/finance-api.ts`.
- Shared API: `CommissionService`, `StatementService`, `FinanceOperationsService`, `AdminFinanceService`, `VendorFinanceService`, `RefundService`, `PaymentSettlement`, and `AdminFinanceController`.
- Migration: `2026_10_19_000000_synchronize_commission_statement_credits.php`. Adds linked, unique compensating statement lines, permits nonnegative debt after credits on paid bills, synchronizes historical unallocated/misapplied credits, and corrects historical fee VAT rounding with balanced postings. It can queue required refunds through existing post-commit outbox processing. Rollback preserves financial corrections and schema support for those records.
- Contract: `openapi.yaml`, `package.json`, `scripts/check-admin-finance-contract.mjs`, regenerated TypeScript/Dart clients and Dart serializers. Adds monthly commission data, documents payment refund fields, statement date/debt behavior and signed Vendor commission earnings.
- Workflow: `docs/workflows/MateryalPH_Final_Admin_Workflow.md` records the owner decision.
- API tests: `PhaseElevenFinanceFlowsTest.php` covers installment settlement, duplicate events/approval, partial/full credit debt reductions, original-source refunds, dated cross-portal totals, zero revenue after reversal, and repeatable historical credit repairs. `PhaseElevenFinanceRulesTest.php` covers exact VAT reversal rounding.

Authorization remains `finance.view` for reads; `finance.review_tax` for credit preparation; `finance.approve_statements` for issue/credit approval. The preparer cannot approve their own credit. Vendor finance remains Owner-scoped. No private credentials, taxpayer identity, Buyer payment destination or provider payload is added to analytics.

## Verification

- Admin lint, typecheck and production build passed. All Admin component tests passed: **23 files, 117 tests**.
- Vendor lint, typecheck and production build passed. Focused Vendor Finance tests passed: **21 tests**.
- Pure finance rules passed: **29 tests, 93 assertions**.
- Focused Pint and full PHPStan passed.
- OpenAPI validation passed with eight existing unused-model recommendations. TypeScript/Dart source regeneration and generated TypeScript build passed.
- Dart serializer generation completed (12 generated outputs); focused analysis of the new commission model and updated KPI model/serializers passed with no issues.
- Admin Finance, payment, earnings-trend and portal-date contract checks passed.
- Gitleaks scan of the changed production sources/contract passed, with no leaks. Targeted whitespace checks passed.
- Both web builds retain the existing large-chunk warning. No browser/device or live-provider journey was run.
- The initial native database attempt stopped at the isolated database guard (**6 failures, 0 assertions**), because `postgres-test` could not resolve. During the Vendor Earnings breakdown follow-up on 2026-10-15, Docker was reached outside the sandbox and the isolated stack's static/live guards passed. `VendorEarningsTrendTest` passed **5 tests, 262 assertions**; `PhaseElevenFinanceFlowsTest` and `PhaseSixteenAdminOperationsTest` passed **22 tests, 732 assertions**. This exercises the new migration from an empty test schema and the historical credit repair cases. The development migration remains **unapplied**, and the development database has not been modified.

## Database gate and development setup

To repeat the checks, start only the isolated test stack and run the relevant suites from the repository root. This environment may require access outside the sandbox to reach the Docker CLI:

```powershell
./scripts/run-tests-isolated.ps1 -GuardOnly -KeepRunning -SkipComposer
docker compose --env-file services/api/.env.testing -f compose.test.yaml -p materyalph_phase1_test exec -T api-test php artisan test --compact --no-ansi tests/Feature/Api/PhaseElevenFinanceFlowsTest.php tests/Feature/Api/PhaseElevenPaymentsTest.php tests/Feature/Api/VendorEarningsTrendTest.php tests/Feature/Api/PhaseSixteenAdminOperationsTest.php
docker compose config --quiet
```

After the isolated feature checks pass, inspect the actual development migration status. Apply the new migration narrowly, without sweeping unrelated pending migrations:

```powershell
docker compose exec -T api php artisan migrate:status
docker compose exec -T api php artisan migrate --path=database/migrations/2026_10_19_000000_synchronize_commission_statement_credits.php
```

The new constraint/correction fields must be installed before using commission credit approval against the development database. Historical debt synchronization requires this migration; code changes alone do not repair existing statement records.

Suggested commit: `fix(finance): synchronize commission credits and recorded admin earnings`.
