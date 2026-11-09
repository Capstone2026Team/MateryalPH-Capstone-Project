# Product Analytics column layout — 6 November 2026

The overview now places At a glance beside Material quality (MQS) on desktop. The summary uses compact 2-by-2 metrics while MQS is present. Below, Product views and orders sits above Suggestions in the left column. The right column contains Top-rated products, Top selling products, Top performing products and Category share in a 2-by-2 grid. Ranking values sit below each product name to keep names readable at narrower card widths. Both column groups align at the top and bottom; longer Suggestions scroll inside its body with a fixed header and keyboard access. The product comparison and demand patterns retain the full content width below.

At smaller available content widths, the top cards and analytics columns stack. Suggestions remains directly below the chart, followed by the ranking cards. Published and empty states retain every authorized panel; no score or product ranking is fabricated.

## Changed files

- `apps/vendor-web/src/pages/ProductAnalyticsPages.tsx`: rearranged the existing summary, quality, chart, Suggestions and ranking components.
- `packages/web-ui/src/analytics-layout.css`: responsive overview/column grids and scoped ranking-row presentation.
- `apps/vendor-web/src/pages/ProductAnalyticsPages.test.tsx`: adjusted the independent MQS retry assertion to the moved Top-rated products panel.
- `apps/vendor-web/e2e/product-analytics-layout.spec.ts`: verifies the requested card positions, matching edges, responsive stacking, sort keyboard behavior and scrollable Suggestions; resets the scroller before screenshot capture.
- `docs/design/MateryalPH_UI_UX_Implementation_Planner.md`: records the final requested arrangement.
- This validation record.

No migration, API contract, generated-client, calculation, permission, loading/retry or product-detail behavior changed. `catalog.manage`, `scores.view_store`, `reviews.view` and Owner-only sales values retain their existing gates. No credentials, manual setup, audit writes or notifications are required. No deployment was performed.

## Validation

| Command/check | Result |
| --- | --- |
| Vendor `npm.cmd run test -- --run src/pages/ProductAnalyticsPages.test.tsx` | 17 tests passed, 1 file. |
| Vendor `npm.cmd run lint` | Final run passed with the existing unrelated unused `inStore` warning in the Admin finance browser test. |
| Vendor `npm.cmd run typecheck` | Final run passed. An earlier run reported the unrelated unused `ShieldCheck` import in `FinancePages.tsx:5`; it was resolved outside this change, without editing that file here. |
| Vendor `npm.cmd run build` | Passed; bundle-size warning. |
| Vendor `npm.cmd exec playwright test e2e/product-analytics-layout.spec.ts -- --grep "Product Analytics has its own navigation" --output=../../.tmp/product-analytics-columns-results` | 8 passed at 320, 375, 390, 768, 1024, 1280, 1440 and 1920 px. |
| Scoped `git diff --check` | Passed. |
| Changed source, CSS and documentation piped to Gitleaks | Passed, no leaks in approximately 222 KB. |

Browser checks cover At a glance/MQS side-by-side alignment and equal heights, chart-before-Suggestions order, the four ranking cards to the right on wide screens, the two ranking rows, aligned lower edges, keyboard scrolling, responsive fallback, empty data, shared card appearance, product links, period/sort behavior and legacy redirects. Desktop and tablet screenshots were visually inspected. Browser data is mocked sample data; live backend/provider behavior was not retested for this layout-only change.

An initial browser run passed six widths but hit missing Playwright trace files during context cleanup at 768 and 1024 px. The final run used a separate output directory and all eight passed. These were artifact-cleanup failures, with no layout assertion failure reported.

Screenshots: `.tmp/analytics-review/products/1440-product-analytics-overview.png`, `1920-product-analytics-overview.png` and the corresponding narrower-width/empty captures.

Suggested commit: `style(vendor): organize product analytics into aligned columns`
