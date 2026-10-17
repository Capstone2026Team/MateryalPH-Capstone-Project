# Vendor Product Analytics and Store Performance redesign — test plan (2026-10-10)

Scope: product views recorded from Buyer Product Details, Vendor Product Analytics (overview, per-product page, My Products summaries), the redesigned Store Performance scores tab and dashboard shortcuts. Decisions approved by the project owner on 2026-10-10 are recorded in the Vendor Workflow.

| Layer | Location | Covers |
| --- | --- | --- |
| Feature/API | `services/api/tests/Feature/Api/ProductAnalyticsTest.php` | One view per Buyer per Manila day; another store's views excluded; conversion numerator/denominator; Owner peso values; overview, detail and summaries shapes; no Buyer identity or location in responses; restock suggestion from out-of-stock viewed product; catalog.manage gate (Manager, Staff, Inventory allowed; Customer Service, Fulfillment, Buyer refused); value sort falls back to orders; foreign listing 404; strict filters and 50-ID cap. |
| Unit | `services/api/tests/Unit/ProductAnalyticsRankingTest.php` | Wilson 95% lower bound values and the ranking rationale. |
| Regression | `DashboardInsightsTest`, `PhaseSevenItemProcurementTest`, `PhaseFourteenAnalyticsTest`, `DashboardMiningTest` | Product Details still returns the same payload while recording a view; dashboard and mining unchanged. |
| Contract | `packages/api-contract/scripts/check-product-analytics-contract.mjs` (`npm run test:product-analytics-contract -- <routes.json>`) | Three read-only Vendor operations, cookie transport, documented 401/403/404/422, no identity/radius filters, nullable peso fields, no personal-data fields. |
| Component | `apps/vendor-web/src/pages/ProductAnalyticsPages.test.tsx`, `TrustPages.test.tsx`, `CatalogPages.test.tsx` | Tab visibility per grant, no peso values without finance.view, every panel has a method note, period and sort reach the request, denial before any request, retry, product page standing and edit shortcut, My Products strip and shortcuts. |
| Layout | `apps/vendor-web/e2e/product-analytics-layout.spec.ts` | 1440/768/390 px without horizontal scroll; evidence in `docs/design/evidence/product-analytics`. |

Known limits: view history starts on the migration date; there is no retention job for `listing_view_days` yet; Buyer mobile is unchanged because recording is server-side.
