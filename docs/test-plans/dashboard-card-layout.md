# Dashboard cards and analytical graphs

Latest visual composition and verification: [Dashboard reference rebuild](dashboard-reference-rebuild.md). The earlier validation history below is retained for context.

Scope: Vendor and Admin main dashboards, shared analytical charts, and their existing finance, product, geographic and team-reporting consumers.

- Compact KPI cards and dashboard panels; sales/order charts share a desktop row, with a separate action column and responsive stacking.
- Follow-up: Open orders by state, Stock status and Incoming order requests share a full-width row of three equal cards on desktop and stack in that order on mobile. The row adapts to two or one cards when a role cannot view stock or store-wide orders; unauthorized slots are omitted.
- Shared panel, KPI, metric and summary cards stretch to their row's height. Chart panels reserve header space; empty time-series graphs reserve the same plot height as populated graphs. Long descriptions and legends can wrap without clipping.
- Area graphs for monetary trends, columns for daily counts, line overlays for comparisons, donuts for selected shares, and existing scatter/heatmap representations for segments and demand.
- Empty graphs keep a neutral grey frame and the original reason, with no invented observations or numeric axes. Recorded zero values remain keyboard-readable; missing and suppressed points remain gaps, including area fills.
- Date filters, section navigation, automatic updates, accessible data tables, permissions, financial definitions, API calls and provider boundaries are retained. No migration or API contract/client-generation change is required. No credentials or manual setup are needed for this UI change.

## Dashboard and analytics simplification

The latest review follows the supplied card, revenue, distribution and score examples while retaining MateryalPH's semantic design tokens and navigation.

- Vendor Overview has four headline measures, sales and order trends, actionable work and the three-card operations row. Zero-count priority actions no longer crowd the main view.
- Admin Overview has four headline measures, one marketplace-value chart and the role-scoped work queues. Removed the duplicate platform snapshot, additional account-count row, review-priority card and queue-load graphs from the main sections. Account detail remains in User Activity.
- Removed KPI sparklines that repeated the full charts. Forecasts and unusual-day markers are opt-in on the chart; forecast summaries, calculation notes and exact-value tables remain available through compact disclosures.
- Shared score presentation uses one semicircular VPS gauge and labelled /5 bars for the remaining scores. Only published, valid API values are rendered. Unpublished scores retain grey tracks, eligibility reasons and sample progress. No client-side score is inferred or calculated.
- Vendor Performance keeps its published scores prominent; operational bands and history are supporting details. Store Performance shows compact badge statuses, with eligibility and response metrics in one expandable section.
- Product analytics prioritizes views/orders, best sellers, category share, useful suggestions and the product list. Additional rankings, category views, association rules and segments sit under Product demand patterns. Empty overview suggestion panels are omitted.
- Admin rolling activity, regional segments, category associations and Vendor clusters are supporting details. Financial headline calculations remain visible; secondary Vendor deductions and Admin billing records are expandable. Geographic, materials and team-reporting graphs use the same shared chart and empty-state treatments.

## Current validation

Final local results on 3 November 2026:

| Check | Result |
| --- | --- |
| Vendor lint, typecheck, production build | Passed; existing lint/build warnings below |
| Admin lint, typecheck, production build | Passed; existing build warnings below |
| Vendor full component/unit suite | 76 files, 699 tests passed |
| Admin full component/unit suite | 39 files, 237 tests passed |
| Final Store Performance/product follow-up | 2 files, 14 tests passed |
| Dashboard browser checks | 40 passed in 38.7 seconds across eight widths |
| Other analytics browser checks | 10 passed in 13.1 seconds at 320 and 1440 px |
| OpenAPI validation | Passed with eight existing unused-model recommendations |
| Whitespace and actual-change/new-source secret scans | Passed |
| Docker Compose configuration | Blocked: Docker is not installed/available in this shell |

Browser checks cover date filters, automatic refresh, hidden role-scoped values, section isolation, equal-size sibling cards, mixed empty/populated cards, grey empty graphs, collapsed analysis, badge details, financial calculation tables and horizontal overflow. The additional surfaces are Store Performance, product analytics/detail, My Products, Vendor Earnings, Admin Platform Finance, geographic overview and materials analytics. Desktop and mobile screenshots were visually reviewed. Evidence is under `.tmp/dashboard-card-layout/` and `.tmp/analytics-review/`; existing committed screenshots were not overwritten.

The browser assertions were updated to check the surviving KPI when its duplicate review card was removed and to open supporting analysis before checking its graph. The results above combine the full suites, the focused follow-up after final Store Performance/product adjustments, and the final browser runs. Checks use local mocked data; live backend/provider and deployment acceptance were not performed. No migration, API schema, generated-client, authentication, authorization, financial-rule or setup change is required.

## Files

- Dashboard composition: `apps/vendor-web/src/pages/{VendorDashboardInsights,PhaseThreeVendorPages}.tsx`, `apps/admin-web/src/pages/{AdminDashboardPage,AdminDashboardInsights}.tsx`.
- Shared cards/charts: `packages/web-ui/src/{dashboard-patterns,page-patterns,chart-patterns,chart-empty-frame,geo-analytics-patterns,analytics-patterns,insight-patterns,score-overview,vendor-team-performance}.tsx`, `chart-layout.ts`, `geo-analytics.css`, `index.ts`.
- Analytical consumers: Vendor `FinancePages.tsx`, `ProductAnalyticsPages.tsx`, `TrustPages.tsx`; Admin `FinanceOperationsPanels.tsx`, `GeoAnalyticsPage.tsx`.
- Tests: Vendor `components/AnalyticalCharts.test.tsx`, `pages/{VendorDashboardInsights,ProductAnalyticsPages,TrustPages,FinancePages}.test.tsx`, Admin `pages/AdminDashboardInsights.test.tsx`, Vendor `e2e/{dashboard-layout,product-analytics-layout,earnings-layout,admin-finance-layout}.spec.ts`.

## Earlier validation

Results on 3 November 2026: Vendor lint/typecheck/build passed, 76 test files and 695 tests passed; Admin lint/typecheck/build passed, 39 test files and 237 tests passed. The final browser run passed all 40 tests in 33.2 seconds across eight viewport projects. Equal-height assertions include a grey empty sales graph beside a populated order graph. OpenAPI validation, whitespace checks and the staged/actual-change secret scans passed, with the existing warnings listed below.

Incoming-request placement follow-up: changed only Vendor `VendorDashboardInsights.tsx`, its existing dashboard browser spec and this report. Vendor lint, typecheck and build passed; all 9 focused dashboard tests and 15 browser checks passed (21.1 seconds) at 320, 390, 1280, 1440 and 1920 px. Browser assertions check the shared parent, equal desktop widths/heights, mobile order, empty incoming requests and horizontal overflow. The 1440 px operations-row screenshot was visually inspected. The changed-source secret scan and whitespace check passed. No API, migration, authorization or setup change was introduced. Suggested follow-up commit: `style(vendor): align incoming requests with operation cards`.

Store workspace removal follow-up: removed the active Owner dashboard's Store workspace footer in `PhaseThreeVendorPages.tsx` and updated the existing dashboard browser assertions. Sidebar navigation, Store Profile, limited onboarding, Marketplace readiness and generic workspace slot support are retained. Vendor lint/typecheck/build passed; both focused test files passed (102 tests), and both browser checks passed at 320 and 1440 px (4.9 seconds), asserting the card is absent. Changed-source secret scanning and whitespace checks passed. No migration, API, authorization or setup change is needed. Suggested follow-up commit: `style(vendor): remove dashboard store workspace card`.

Portal commands, run from each respective app directory:

```powershell
npm.cmd run lint
npm.cmd run typecheck
npm.cmd run test -- --run --maxWorkers=4
npm.cmd run build
```

Additional checks:

```powershell
npm.cmd --prefix packages/api-contract run validate
git diff --check
gitleaks git --staged --redact --no-banner
```

The actual unstaged diff and the new shared chart/test files were also piped into `gitleaks stdin --redact --no-banner`; the staged scan alone contains no changes.

Browser tests use deterministic mocked API responses, including restricted access, empty series and a mixed row containing one empty graph and one populated graph. They verify date controls, automatic refresh, section switching, exact values, overflow and equal sibling-card heights at 320, 375, 390, 768, 1024, 1280, 1440 and 1920 px. These are local UI checks; no live-provider or deployment acceptance is implied.

The normal Playwright web-server teardown hung in this Windows environment after assertions completed. The clean browser run starts the two preview servers separately and uses an ignored local config that imports the normal configuration with `webServer` disabled:

```powershell
# Start from each app directory in separate terminals.
node node_modules/vite/bin/vite.js preview --host 127.0.0.1 --port 4173
node node_modules/vite/bin/vite.js preview --host 127.0.0.1 --port 4174

# From apps/vendor-web, with the local review config present:
npm.cmd run test:e2e -- e2e/dashboard-layout.spec.ts --config ../../.tmp/dashboard-card-layout/playwright.review.config.mts
```

Screenshots are saved under `.tmp/dashboard-card-layout/`; previous committed design evidence is retained.

Blocked gate: `docker compose config --quiet` could not run because Docker is unavailable in this shell and the usual Docker Desktop executable path is absent. Run that exact command in a Docker-enabled environment. PHP and Flutter suites are outside this frontend-only change and were not run.

Existing warnings: Vendor lint reports unused `inStore` in `e2e/admin-finance-layout.spec.ts`; Vite reports large chunks; Vitest reports the existing esbuild/oxc configuration warning and a non-fatal jsdom navigation message; OpenAPI validation reports eight unused-model recommendations.

Suggested commit: `style(portals): simplify dashboards and analytics`
