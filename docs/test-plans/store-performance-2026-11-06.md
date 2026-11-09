# Store Performance refinement — 6 November 2026

## Scope

- VPS beside a compact Badges/Badge metrics column, followed by operational KPIs and aligned VCS/MQS/OHS cards.
- A star VPS gauge with scale marks and VCS/OHS icons/bars; five operational component rows remain inside OHS.
- Vector badge medal emblems, a server-status earned count, and circular CRR/FRR graphics with explicit numeric values and neutral missing states.
- Shared circular score presentation, calculation help and neutral unpublished states.
- Separate server-classified store health, score history and compact badge presentation.
- Mobile stacking, desktop alignment, keyboard calculation controls and independent supplemental-data retry.
- Score history retains its interactive chart with no table. Badge requirements and CRR/FRR stay visible; no content dropdown or accordion controls.

## Files

- `apps/vendor-web/src/pages/TrustPages.tsx` and its component tests.
- `apps/vendor-web/e2e/store-performance-layout.spec.ts`.
- `apps/vendor-web/e2e/reviews-layout.spec.ts`: align the date-control selector with its existing Last 30 days default while checking the shared ring.
- Shared `performance-achievements.tsx`, `rating-ring`, `store-performance-overview`, `store-performance` styles, score eligibility helper and exports in `packages/web-ui/src`.
- `score-overview.tsx` shares the gauge and VCS/OHS bar presentation with VPS; existing dashboard gauges retain their needle treatment.
- `review-overview.tsx` and `review-workspace.css` reuse the extracted ring without changing review aggregation.
- The Store Performance decision in the UI/UX implementation planner.

## Data and authorization

No migrations, API contract changes, generated-client changes or backend changes. Uses the existing `/vendor/performance` response and `/vendor/dashboard/insights?days=30`. Store Performance retains `scores.view_store`; operational KPIs require the server-authorized `orders.confirm` section. No financial values, Buyer identities or coordinates are rendered.

Published values are never inferred from visible reviews. VCS retains the combined Delivery/Processing Speed criterion. OHS counts eligible orders, publishes only after its ten-order minimum and retains the weekly cadence. All-cause cancellation, dispute rate, fulfillment rate, order-decision response time and badge metrics remain distinct, with calculation help.

## Automated checks

- Vendor: `npm.cmd run lint`, `npm.cmd run typecheck`, `npm.cmd run test -- --run --maxWorkers=2`, `npm.cmd run build`.
- Admin shared-component regression: the same four commands from `apps/admin-web`.
- Focused final refinement: `npm.cmd run test -- --run src/pages/TrustPages.test.tsx src/pages/ProductAnalyticsPages.test.tsx src/pages/VendorDashboardInsights.test.tsx`.
- Responsive browser checks: `npm.cmd exec -- playwright test e2e/store-performance-layout.spec.ts` from `apps/vendor-web`.
- Contract validation: `npm.cmd run validate` from `packages/api-contract`.
- `git diff --check`, `gitleaks git --staged --redact --no-banner` and direct redacted scans of the task's source/test files.

The browser fixture uses synthetic data and checks 320, 375, 390, 768, 1024, 1280, 1440 and 1920 px. At desktop widths VCS/MQS/OHS share a top edge, width and height; Badges and Badge metrics sit beside VPS. VCS/OHS bars inside VPS show only published values. OHS must show all five operational components, eligible orders and penalties; unpublished MQS and OHS must show their respective 5-rating and 10-order gates. Calculation help opens from the keyboard, closes with Escape and restores focus. Score history must contain no table. Page content must contain no `details`, `summary` or `select` elements. Global shell account/navigation controls are unchanged.

## Results and remaining acceptance

The latest requested arrangement passed Vendor lint, typecheck and build, **47 focused Vendor tests** across Store Performance, Product Analytics and Dashboard insights, and Admin typecheck with **19 trust tests**. All **8 responsive Store Performance browser scenarios passed**, covering published/unpublished values, component bars inside VPS, badge emblems and earned count, circular CRR/FRR graphics, Badges/Badge metrics beside VPS, restored VCS/MQS/OHS alignment, the OHS event list, no history table, no content dropdowns and page/card overflow. Desktop and mobile screenshots were visually inspected. Component tests explicitly retain earned, unearned and suppressed badge statuses, count only earned records, and distinguish a real 0.00% response rate from missing data. The medal and rate graphics are decorative; all values, status labels, windows and sample counts remain text.

The preceding layout passed the complete Vendor suite (**832 tests in 90 files**) and complete Admin suite (**282 tests in 42 files**), plus both builds. Those full suites were not repeated for this final layout-only arrangement; the affected page, shared score bar/gauge, permission and chart cases were rerun in the focused checks above. Vendor lint retains an unrelated unused-variable warning in `e2e/admin-finance-layout.spec.ts`; builds retain large-chunk recommendations.

Task diff checks and direct redacted source/test/documentation secret scans passed. The staged secret scan had no staged content. API contracts were unchanged; the earlier contract validation passed with eight unused-model recommendations. No financial, authorization or scoring behavior changed.

`docker compose config --quiet` could not run because Docker is not available on PATH. Run that exact command once Docker is available. No backend/Flutter tests were run because their code and contracts were unchanged. No live API, deployment or user acceptance is implied by the mocked browser checks. No credentials or setup keys are required for this UI change; nothing was deployed.

Suggested commit: `feat(vendor): refine performance visuals`
