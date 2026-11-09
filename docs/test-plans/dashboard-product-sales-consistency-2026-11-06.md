# Dashboard product sales consistency — 6 November 2026

Presentation follow-up: the Owner subsequently requested matching row heights and removal of the inline category reconciliation table. That update is recorded under Presentation follow-up below; the shared calculations remain unchanged.

## Outcome

Vendor Dashboard Sales by category and Top products now use the same surviving sales and latest frozen material amounts as Finance and Product Analytics. The old dashboard read raw order-line totals and included cancelled or fully refunded sales. Product Analytics also had its own refund-state filter and raw-line query. These separate queries could disagree after cancellations, completed refunds or an approved discounted revision.

For the screenshot period, **7 October–5 November 2026**, a read-only query against the existing local demo records verified:

| Measure | Amount |
| --- | ---: |
| Product sales value, category total and the single top product | PHP 29,406.50 |
| Plus delivery | PHP 930.75 |
| Completed partial refunds on the surviving sales | PHP 0.00 |
| Net sales | **PHP 30,337.25** |

The old product/category value was PHP 31,690.50. The corrected product has four surviving orders rather than six. Product sales excludes delivery, so it is shown with a short reconciliation to Net sales. The zero-refund row is omitted. No demo records were changed to make these numbers agree.

This completes the product-card follow-up to [the financial reporting correction](financial-reporting-consistency-2026-11-06.md). The earlier Platform commission charges, Creditable withholding tax and Expected online payout naming remains in place.

## Shared calculation and presentation

- `SalesReporting::sales()` supplies surviving confirmed sales and the latest immutable financial snapshot. `productLines()` supplies its material lines after Vendor discounts, VAT included. All three reports use first-confirmation dates in Asia/Manila.
- Cancelled sales and sales fully refunded through confirmed financial records contribute zero. Partial refunds remain an explicit order-level deduction: **product sales + delivery − completed partial refunds = Net sales**. No unsupported refund allocation to individual products was introduced.
- Category shares include all categories. More than six categories become the top five plus Other categories; its order count is the distinct union of the grouped categories' orders.
- Category amounts use exact pesos. The category card includes the reconciliation, and both cards size to their content. A single product no longer sits inside a forced chart-height blank area.
- The Product analytics link preserves the dashboard reporting dates. Product Analytics overview and detail show Product sales value and visibly explain that delivery is excluded and partial refunds are separate.

## Files, contract and authorization

Backend: `SalesReporting.php`, `VendorFinanceService.php`, `Analytics/Dashboard/VendorDashboardInsights.php`, `Analytics/Products/VendorProductAnalytics.php`, and focused API tests for the three reports.

Client/shared UI: Vendor `VendorDashboardInsights.tsx`, `ProductAnalyticsPages.tsx`, their tests, dashboard fixtures/browser tests, shared `dashboard-patterns.tsx` and `analytics-layout.css`. System/Vendor workflows and the UI/UX planner record the correction.

OpenAPI adds the required nullable `VendorDashboardOrders.products.sales_breakdown`, with four nonnegative integer-centavo fields: `product_sales_centavos`, `delivery_centavos`, `refunds_centavos`, and `net_sales_centavos`. It is null for roles without sales access. The TypeScript/Dart clients and Dart serializers were regenerated through the normal tooling; contract checks cover the new object, null access and reconciliation. Product Analytics schema descriptions now state the common snapshot/refund scope.

Existing Owner-only financial access and Product Analytics route permissions are preserved. No migration, new secret, manual configuration, tax/commission rule change, historical financial edit or provider call is required. No deployment, push or merge was performed. Existing unrelated workspace edits were retained.

## Validation performed

| Check | Exact result |
| --- | --- |
| API: ProductAnalyticsTest, VendorEarningsTrendTest, DashboardInsightsTest | **21 tests, 1,331 assertions passed** |
| Additional seven-category aggregation regression | **1 test, 106 assertions passed** |
| Unit: PhaseTenProjectCalculationsTest, PhaseElevenFinanceRulesTest, DashboardSalesAmountsTest | **41 tests, 151 assertions passed** |
| Vendor Finance, Product Analytics and Dashboard components | **79 tests passed** |
| Final Dashboard component rerun after copy/layout review | **24 tests passed** |
| Final Product Analytics component rerun after visible explanations | **13 tests passed** |
| Chromium browser: single-product reconciliation, populated cards and empty cards, each at 320, 390 and 1440 px | **9 tests passed** |
| Buyer order detail contract, checkout options contract and project budget bar | **13 tests passed** |
| Vendor lint, typecheck and production build | **Passed**; existing unused `inStore` browser-fixture warning and bundle-size warning remain |
| Admin typecheck and production build | **Passed**; bundle-size warning remains |
| Full Pint | **879 files passed** |
| PHPStan | **588 files, no errors** |
| OpenAPI validation; generated TypeScript build; Dashboard, Product Analytics and Earnings contract checks | **Passed**; eight existing unused-model recommendations |
| Dart serializer generation; analysis of the new breakdown and dashboard product models | **22 outputs generated; no analysis issues** |
| Compose configuration; diff whitespace; staged and affected-source secret scans | **Passed; no leaks found**; staged scan had no staged changes |

Regression cases cover cancelled and fully refunded sales, a newer approved discounted snapshot, the first-confirmation date boundary, completed partial refunds deducted once, restricted-role null financial values, and inclusion of small categories. Browser assertions cover exact amounts, date-preserving navigation, no horizontal overflow, compact heights, and empty states. Final phone/category and desktop/top-product captures were also visually inspected.

Local review screenshots: `.tmp/analytics-review/product-sales-consistency/`. Validation logs: `.tmp/product-sales-consistency-logs/`, preserving their original source-directory structure. These are local ignored artifacts.

Reproduction commands, from the indicated directories:

```powershell
# Repository root; isolated test database only
$taskDocker = "$env:LOCALAPPDATA\Programs\DockerDesktop\resources\bin\docker.exe"
& $taskDocker compose --env-file services/api/.env.testing -f compose.test.yaml -p materyalph_phase1_test exec -T api-test php vendor/bin/phpunit tests/Feature/Api/ProductAnalyticsTest.php tests/Feature/Api/VendorEarningsTrendTest.php tests/Feature/Api/DashboardInsightsTest.php
& $taskDocker compose --env-file services/api/.env.testing -f compose.test.yaml -p materyalph_phase1_test exec -T api-test php vendor/bin/phpunit tests/Unit/PhaseTenProjectCalculationsTest.php tests/Unit/PhaseElevenFinanceRulesTest.php tests/Unit/DashboardSalesAmountsTest.php

# apps/vendor-web
npm.cmd run test -- --run src/pages/FinancePages.test.tsx src/pages/ProductAnalyticsPages.test.tsx src/pages/VendorDashboardInsights.test.tsx
npm.cmd run lint
npm.cmd run typecheck
npm.cmd run build
npm.cmd run test:e2e -- e2e/dashboard-layout.spec.ts --grep 'Vendor product cards keep|Vendor product insights are compact' --project=chromium-320 --project=chromium-390 --project=chromium-1024 --project=chromium-1440

# apps/buyer-mobile
flutter.bat test --no-pub test/order_detail_contract_test.dart test/checkout_options_contract_test.dart test/project_budget_bar_test.dart

# packages/api-contract
npm.cmd run validate
npm.cmd run test:dashboard-contract
npm.cmd run test:product-analytics-contract
npm.cmd run test:earnings-contract
```

The final nine browser checks include the category regression's later UI copy. The 21-test API run preceded the separate new seven-category test, which then passed independently. Counts above are separate runs and should not be added as unique tests without accounting for reruns.

Full monorepo/backend/mobile suites, live provider settlement, tax filing and a live-server browser session were not run. Browser layout checks use fixtures; the screenshot-period totals were additionally verified against the existing demo records using a read-only query.

## Presentation follow-up

Sales by category and Top products now use the normal shared panel sizing, filling the same grid-row height as Order activity and Store performance. The inline Product sales value / Plus delivery / Net sales table was removed from Sales by category. The category/product amounts, calculation help, date-preserving Product Analytics link and financial rules remain intact; help points to Finance for the amount breakdown.

Changed files for this follow-up: Vendor dashboard page, its component/browser tests, Vendor workflow, UI/UX planner and this report. No backend, API contract, migration, authorization, new setup or secret changes were required. No deployment was performed.

Validation: **24 Dashboard component tests passed**, **12 browser checks passed** at 320, 390, 1024 and 1440 px, including populated and empty states and equal-height assertions for neighboring cards. Vendor lint, typecheck, production build and diff whitespace check passed. The existing unused `inStore` fixture warning and bundle-size warning remain. Browser screenshots were visually reviewed. Logs are `.tmp/dashboard-card-size-*.log`; screenshots are `.tmp/analytics-review/dashboard-card-size/`. Full backend/mobile suites were not rerun for this presentation-only follow-up.

Suggested follow-up commit: `fix(vendor): match dashboard card heights and simplify category card`.

## Top alignment and scrolling follow-up

The Owner clarified that full-height cards must keep their content at the top and must not expand as more sales arrive. Both cards now opt into a shared `DashboardPanel.scrollBody` presentation, with top alignment, size containment and internal vertical scrolling. The header remains outside the scroll area. The named body region is keyboard-focusable with a visible focus indicator; PageDown and End reach later categories. Top products also caps rendering at five products, even if an oversized response is supplied. Normal shared panels retain their existing defaults.

Changed files: shared `dashboard-patterns.tsx` and `analytics-layout.css`, Vendor dashboard page and its component/browser tests, Vendor workflow, UI/UX planner and this report. Financial amounts, reporting scope, filters, permissions and API responses are unchanged. No migration, manual setup, new secret or deployment is required.

Final validation: **24 component tests passed** and **12 browser checks passed** at 320, 390, 1024 and 1440 px. The growth case replaces a single category/product with six long category names and eight products: card heights stay within one pixel of their original sizes, only five products render, category overflow scrolls by keyboard, and no horizontal page overflow appears. Single-item lists begin within 24 px of the body top, and desktop cards still match neighboring heights. Populated and empty states pass. Screenshots of single-item and overflowing lists were visually inspected.

Vendor lint, production build, final typecheck, diff whitespace check and affected-source secret scan passed. The initial typecheck reported optional-property errors in the separately edited `TrustPages.tsx`; this task did not modify that file, and the final typecheck passed after its external update. Existing fixture/bundle warnings remain. No full backend/mobile suite was rerun for this UI change.

Local logs: `.tmp/dashboard-top-scroll-*.log`. Screenshots: `.tmp/analytics-review/dashboard-top-scroll/`. Suggested commit: `fix(vendor): top-align dashboard lists and contain overflow`.

## Suggested commit

`fix(analytics): reconcile dashboard product sales with finance`
