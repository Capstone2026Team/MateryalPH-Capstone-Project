# Financial reporting consistency — 6 November 2026

## Outcome and observed discrepancy

For 7 October–5 November 2026, the Vendor Dashboard showed PHP 30,337.25 while Finance showed PHP 30,051.75. A PHP 285.50 order was accepted on 6 October and first confirmed on 7 October. Dashboard used confirmation dates; Finance used acceptance dates. Read-only queries against the local TEST database now return **3,033,725 centavos on both projections** for those exact dates. No development records were changed to achieve this result.

## Reporting rule

- One `SalesReporting` query supplies first-confirmation dates, completed online principal refunds and confirmed cash reimbursements to Vendor Dashboard, Vendor Finance, Admin marketplace payments and geographic facts.
- Net sales excludes Buyer processing fees, removes cancelled sales and completed refunds once, and never falls below zero per order. Pending/failed refunds and late-capture compensation do not reduce sales.
- Finance product values plus delivery less the explicit completed-partial-refund component reconcile to Net sales. Zero-value cancelled/fully refunded sales have no product rows.
- Gross sales, Net sales, money collected, expected online payout, platform earnings and annual withholding-threshold records remain separate measures. Matching scope and dates must yield matching sales totals.
- Platform commission charges means the completed-order charge after approved credits. Before-credit and estimated charges are identified separately. Monthly commission is not deducted again from expected online payout.
- Creditable withholding tax is written in full without a simulated prefix. TEST context remains visible. The annual tax threshold and posted tax records retain their taxpayer-year scope.

## Files and contract

Primary changes: `services/api/app/Domain/Finance/SalesReporting.php`, `VendorFinanceService.php`, `PlatformMoneyFlow.php`, `FinanceOperationsService.php`, plain-language credit errors in `CommissionService.php`, Vendor dashboard service, geographic fact builder/definitions, and `DocumentSnapshot.php` for newly generated export labels. Portal changes cover Vendor Finance/Dashboard, Admin Finance/Dashboard/Marketplace Analytics, shared threshold presentation and product-total layout. The System, Vendor and Admin workflows and UI/UX planner record the approved reporting change.

`VendorEarnings.breakdown.sales.refunds_centavos` is a new required integer-centavo reconciliation component. Existing transport keys, including `commercial_sales_centavos`, `earned_commission_centavos` and `simulated_cwt_centavos`, remain compatible; descriptions document their display names and sales scope. TypeScript/Dart clients and Dart serializers were regenerated. No migration is required.

## Authorization and financial integrity

Owner-only Vendor finance and exports, Admin finance permissions, geographic small-cell suppression, private downloads, revocation checks and existing audits remain in force. No VAT/withholding rate, commission policy, saved order amount, provider configuration, credential or historical assessment was changed. No deployment, push, external message or development-database mutation was performed. No manual setup or new secret key is required.

## Automated validation

Passed:

- Isolated API: DashboardInsightsTest + VendorEarningsTrendTest + PhaseElevenFinanceFlowsTest — **31 tests, 1,582 assertions**. New coverage compares Finance, Dashboard and Admin sales across a Manila date boundary and pending/failed/successful partial refunds, with product and trend reconciliation.
- Isolated geographic analytics regression — **10 tests** (part of an earlier 18-test run with the existing Earnings tests, 1,149 assertions combined).
- Finance PDF projection and download revocation — **1 test, 22 assertions**, including all four updated financial labels in the captured export.
- Vendor components: Finance, Dashboard and shared portal patterns — **75 tests**, plus **22 Dashboard tests** rerun after the final help-text review.
- Admin components: Finance, tax records, Dashboard and geographic analytics — **42 tests**.
- Desktop/mobile browser checks at 1440 and 390 px — **10 tests**, covering Finance overview, legacy Earnings URLs, tables, calculation help, channel layout and Admin Finance. Captured screenshots were visually inspected for readable full labels and responsive layout.
- Vendor/Admin lint, typecheck and production builds. Vendor lint retains the existing unused `inStore` variable warning in the browser fixture; builds retain bundle-size warnings. The Vendor test environment logs jsdom's unsupported full-page navigation message without failing tests.
- Full Pint — **879 files**; PHPStan — **588 files, no errors**.
- OpenAPI validation, generated TypeScript build, Earnings/Admin Finance/Dashboard contract checks, Dart serializer generation and analysis of the changed Dart finance models.
- Compose configuration, diff whitespace check, staged secret scan (no staged changes) and a redacted scan of the affected source diff — no leaks found.

Full monorepo/backend/mobile suites and live provider settlement or tax filing were not run. Browser tests use TEST fixtures; the exact PHP 30,337.25 reconciliation was additionally verified with read-only queries against the user's local demo records.

## Suggested commit

`fix(finance): align sales totals and simplify financial labels`
