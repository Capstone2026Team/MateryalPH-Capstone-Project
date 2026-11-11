# Vendor stock confirmation — 2026-11-11

## Outcome and affected files

- Dashboard Stock status now shows Active and Not active counts, calculated by the API over the same nonremoved inventory variants used by the stock chart. Not active includes drafts, inactive, temporarily hidden, pending and rejected listings. Available stock remains a separate measure.
- Product Analytics & reviews includes listing-filtered, paginated inventory with variant selection, private quantities, confirmation dates, reorder level, ordinary price, existing authorized editing/history/auto-accept actions and Confirm stock. Changing the chart period keeps the inventory workspace mounted.
- Inventory dialogs reuse the same editor and confirmation flow. Successful changes reload the full ledger, including other variants and summary counts.
- Saving catalog stock counts, correcting listing details or adding a missing clean product photo now invokes the existing hidden-listing restoration check. A valid confirmation restores an eligible listing immediately. A hidden listing with fresh stock explains its remaining requirements instead of claiming its stock is unconfirmed.

Primary files: `apps/vendor-web/src/pages/{VendorDashboardInsights,ProductAnalyticsPages,ProductInventorySection,InventoryPages,InventoryDetails,CatalogShared,TrustPages}.tsx`, `apps/vendor-web/src/lib/inventory-api.ts`, `packages/web-ui/src/inventory-stock-details.tsx`, and the inventory/catalog/dashboard domain services in `services/api/app/Domain/`.

No migrations or data repair were added. The local read-only diagnostic found no currently fresh-confirmed hidden listings; it did not reproduce the screenshot's exact live record. No existing application data was changed by the diagnostic.

## Contract and security

`packages/api-contract/openapi.yaml` adds `VendorDashboardStock.active`, `VendorDashboardStock.inactive` and `InventoryRow.listing_visibility_blockers`. TypeScript and Dart clients, including Dart builders, were regenerated. Contract checks cover both languages.

Existing inventory view/manage, price and auto-accept grants remain authoritative. Product analytics requests private stock only with `inventory.view`; confirmation requires the API's existing inventory-manage authorization. Existing CSRF, tenant scoping, optimistic row versions, all-or-nothing confirmation, deterministic locks, audit attribution and immutable history remain in use. No new endpoints, permissions, environment variables, credentials or manual setup are required.

The Day 7/12 reminders, Day 15 hiding deadline, freshness of every active variant, store activation, listing readiness and PS/ICC verification still gate restoration. Stale hidden listings return the actionable confirmation requirement without running unnecessary full readiness checks.

## Validation

- Isolated API command: `php artisan test --compact tests/Feature/Api/PhaseFiveInventoryDeliveryTest.php tests/Feature/Api/DashboardInsightsTest.php tests/Feature/Api/InventoryConcurrencyTest.php tests/Feature/Api/ProductAnalyticsTest.php tests/Feature/Api/ProductQuantityPolicyTest.php tests/Unit/InventoryRulesTest.php` — **41 passed, 1,300 assertions**. The final stale-stock query optimization was followed by another PhaseFiveInventoryDeliveryTest run: **16 passed, 362 assertions**. Database-isolation positive/negative guards passed before execution.
- Vendor `npm.cmd run test -- --run` — **105 files, 1,021 tests passed**. After the final chart-loading correction, ProductAnalyticsPages.test.tsx passed **25 tests** and VendorDashboardInsights.test.tsx passed **24 tests**. The earlier affected-file run passed **59 tests** across inventory, analytics and dashboard.
- Vendor lint, typecheck and production build passed. Admin typecheck and production build passed. Existing large-bundle warnings and the non-failing jsdom navigation diagnostic remain.
- Full API Pint and PHPStan passed. A final Pint check and PHPStan rerun followed the last inventory-service adjustment.
- OpenAPI validation passed with eight existing unused-model recommendations. Inventory contract checks passed for **17 operations**; dashboard contract checks passed for **2 operations**. Generated TypeScript build passed.
- Full Dart builder generation completed with **16 outputs**. `scripts/check-inventory-stock.dart` passed serialization/round-trip checks, and analysis of that script and both affected generated model sources found no issues.
- Buyer `flutter analyze --no-pub` passed with no issues (**173.2 seconds**).
- Synthetic browser stock-confirmation checks passed at **1440, 390 and 320px**. They verify the reviewed physical count, confirmation, visible restored status, exact Manila due date, retained state after chart-period changes, 44px confirmation target and no page overflow. Desktop and phone screenshots were visually reviewed under `.tmp/analytics-review/products/`.
- Existing product gallery/details/analytics/reviews browser interactions also passed at those three widths: **6 browser checks passed in total**.
- Compose configuration, staged Gitleaks (zero staged bytes), a separate redacted scan of changed source/generated files, and `git diff --check` passed.

## Acceptance limits

Browser fixtures are synthetic. Live authenticated confirmation against the screenshot's store and deployed Hostinger state remains manual; no deployment was requested or performed. Backend and Vendor assets must both be released to expose the new response fields and controls. Full API, Admin and Buyer test suites were not run for this scoped change.

Suggested commit: `fix(vendor): restore stock confirmations and show inventory status`
