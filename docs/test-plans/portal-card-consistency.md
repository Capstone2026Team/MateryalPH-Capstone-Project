# Shared Admin and Vendor card design — 3 November 2026

## Result and scope

Expanded the earlier financial-card work to both portals' metric and content cards. `KpiCard`, `MetricCard`, `StatCard`, `SummaryTiles`, score tiles and dashboard summary metrics now share one metric stylesheet. Content, chart, form, record, profile, verification, order, quotation, support and team surfaces use the shared `mp-card` foundation. Existing workspace changes were preserved.

- Shared 12px surface radius and semantic borders; white content surfaces and pale brand metric surfaces, with the existing orange featured variant.
- Content padding is 16px on mobile and 20px from 640px; metric padding is 12px on mobile and 16px above it. Edge-to-edge tables and compact information bars retain their appropriate layout.
- Metric labels, values and 32px decorative icon containers use the same typography and spacing. Dashboard-specific overrides no longer change standard KPI styling.
- Financial calculations, signed breakdowns, supplied totals, disclosure states and comparison periods are preserved. The common trend renderer continues to show signed up/down/flat changes only when actual comparison data exists.
- Filterable statistics retain their button semantics, selected state, disabled behavior, keyboard focus and dismissible help. Status accents remain semantic.
- Both Vite configurations explicitly allow the shared UI source, tokens and generated client, with strict filesystem serving. Both have regression coverage for shared CSS/modules/images and for rejecting an unrelated workspace document. Test servers use isolated dependency caches.

## Files

| Area | Changes |
| --- | --- |
| New shared foundation | `packages/web-ui/src/portal-card.css` |
| Shared metric/card consumers | `analytics-layout.tsx`, `analytics-layout.css`, `kpi-card.css`, `metric-trend.css`, `chart-patterns.tsx`, `dashboard-patterns.tsx`, `page-patterns.tsx`, `catalog-patterns.tsx`, `analytics-patterns.tsx`, `profile-details.tsx`, `profile-details.css`, `onboarding-fields.tsx`, and package `index.ts` |
| Other shared consumers | Account, filters, finance, fulfillment, disputes, maps/tables, notifications, messaging, quotations, review details, support, stock ledger, verification, onboarding, delivery vehicles and team components under `packages/web-ui/src` |
| Admin consumers | `OperationsKit.tsx` plus audit, disputes, enforcement, finance/tax, geographic analytics, invoices, notifications, verification, platform settings, compliance, trust and directory pages |
| Vendor consumers | Site inspection, store sections and work-package components plus catalog, disputes, finance, fulfillment, invoices, orders/payment, store/onboarding, support, trust and review pages |
| Development configuration | Both `vite.config.ts` files; Admin `vite.config.test.ts`; new Vendor `vite.config.test.ts`; Vendor `src/test/setup.ts` guards its DOM shim in Node tests |
| Checks | New `src/components/PortalCards.test.tsx` and `e2e/fixtures/card-design.ts`; dashboard, Earnings, Admin Finance, product analytics and order layout specs call the shared computed-style assertions |

The card classes are consumed in 64 TSX source files: 32 shared, 15 Admin and 17 Vendor. These changes primarily replace repeated surface/padding classes; no workflow, route, event handler or financial calculation was rewritten for the migration.

## Contract, authorization and setup

No migrations, API behavior/schema changes, generated-client edits, new permissions or audit/notification events. Owner-only financial access, Admin role scopes and geographic suppression remain in place. No credentials or manual setup are required. Nothing was pushed, merged or deployed.

## Checks performed

Commands below run in the named app directory unless stated otherwise.

| Command/check | Result |
| --- | --- |
| Vendor `npm.cmd run lint`, `npm.cmd run typecheck`, `npm.cmd run build` | Passed; one existing unused `inStore` fixture warning and the existing large-bundle warning |
| Admin `npm.cmd run lint`, `npm.cmd run typecheck`, `npm.cmd run build` | Passed; existing large-bundle warning |
| Vendor `npm.cmd run test -- --run --maxWorkers=4` | 80 files, 725 tests passed |
| Admin `npm.cmd run test -- --run --maxWorkers=3` | 40 files, 261 tests passed |
| Five card/layout specs, 320px and 1440px | 23 passed initially; one screenshot-capture protocol failure; that case passed in an isolated rerun |
| Same five specs, 1920/1280/1024/768/390/375px | 72 passed |
| Store Profile, verification/checklist panels and Admin order logs, 320/1440px | 10 passed |
| Chromium against `localhost:5173/dashboard` and `localhost:5174/dashboard`, synthetic API fixtures | Both rendered four metric cards and shared content cards; no Vite overlay, failed script/style requests or runtime errors |
| API contract `npm.cmd run validate` | Passed; eight existing unused-model recommendations |
| Root `gitleaks dir .tmp/portal-card-consistency/security --redact --no-banner` | Changed/new frontend sources scanned; no leaks |
| Root `gitleaks git --staged --redact --no-banner` | Passed; staging area empty |
| Root `git diff --check` | Passed |

The five main browser specs are `dashboard-layout.spec.ts`, `earnings-layout.spec.ts`, `admin-finance-layout.spec.ts`, `product-analytics-layout.spec.ts` and `orders-layout.spec.ts`. Across runs, all **106 distinct browser cases passed**. They verify common computed radius, borders, padding, metric typography, responsive layouts, equal chart-card rows, filters, navigation, calculation disclosures, permissions and real supplied trend values. The extra ten cases cover both portals' verification surfaces, Vendor Store Profile sections and Admin record cards.

Initial validation caught the Node test setup's unconditional `Element` access; the guarded shim fixes it and the final full Vendor suite passes. The screenshot failure occurred after the card assertions and passed when rerun alone; no application fix was needed for it.

Desktop Vendor/Admin summaries and the Vendor dashboard were visually inspected. Evidence is in `.tmp/summary-trends/`, `.tmp/dashboard-card-layout/`, `.tmp/portal-card-consistency/` and `.tmp/analytics-review/`; these are ignored local artifacts.

## Verification limits

Browser API responses were synthetic, including for the dev-server checks. This verifies rendering and interactions, not live authenticated data or provider settlement. Every route and role combination was not manually inspected. PHP and Flutter suites were not run for this frontend-only presentation change. Docker is unavailable in this environment; the repository-wide configuration check remains `docker compose config --quiet` on a machine with Docker installed. No backend or Compose files changed.

Suggested commit: `feat(web-ui): unify vendor and admin portal cards`

## Follow-up: missing Vendor summary indicators

The supplied Vendor screenshot exposed a state the earlier positive-percentage fixtures did not exercise: the API deliberately returns `change_percent: null` when the previous period is zero (`VendorDashboardInsights::delta`). Vendor passed that value into the summary without the unavailable-comparison message already used by Admin, so the shared renderer returned nothing.

`apps/vendor-web/src/pages/VendorDashboardInsights.tsx` now supplies the existing shared fallback for Gross sales and Orders confirmed. The badge remains visible as **No comparison**, with a specific zero-baseline explanation. Available signed percentage changes retain their existing green/red/flat indicators. `ProductAnalyticsPages.tsx` applies the same correction to Vendor product sales/views/orders summaries. Restricted roles do not receive financial values or a store-wide comparison inferred from missing permissions. Current queue and response-time snapshots remain snapshots.

Regression coverage added in `VendorDashboardInsights.test.tsx`, `ProductAnalyticsPages.test.tsx` and `e2e/dashboard-layout.spec.ts` includes the screenshot's ₱34,870.20 and eight confirmed orders with zero previous activity, no activity in either period, missing percentages, product summaries with/without financial access, and the existing measured percentage path.

Follow-up checks (these are separate from the preceding full-suite run):

- Vendor `npm.cmd run test -- --run src/pages/VendorDashboardInsights.test.tsx src/pages/ProductAnalyticsPages.test.tsx src/components/AnalyticsSummary.test.tsx --maxWorkers=3`: **3 files, 33 tests passed**.
- Vendor `npx.cmd playwright test e2e/dashboard-layout.spec.ts --grep "Vendor (dashboard summary|summary retains)" --output=../../.tmp/vendor-summary-indicators/results`: **16 passed**, eight widths from 320–1920px, covering both measured percentages and the missing-comparison state.
- Vendor lint, TypeScript and production build passed; existing fixture and bundle-size warnings remain.
- A Chromium check against `localhost:5173/dashboard?from=2026-10-02&to=2026-11-03`, using synthetic API responses matching the displayed figures, rendered both missing-comparison badges with no module failures, Vite overlay or runtime errors. Desktop and mobile screenshots were inspected; artifacts are under `.tmp/vendor-summary-indicators/`.
- `git diff --check` and Gitleaks on the changed Vendor sources/tests passed.

No migrations, API/generated-client changes, financial formulas, permissions or setup changes. Live authenticated API data was not inspected. Suggested follow-up commit: `fix(vendor-web): retain summary indicators without a comparison`.
