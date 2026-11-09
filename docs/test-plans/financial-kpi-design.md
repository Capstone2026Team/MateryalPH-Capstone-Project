# Financial KPI design adoption — 3 November 2026

## Result

Applied the approved summary-card design across Vendor and Admin financial KPI cards: consistent label/value spacing, larger tabular amounts, 32px icon containers, pale brand surfaces, orange featured cards and matching up/down/flat percentage pills. Financial calculation tables remain on white panels with their signed deductions and exact supplied totals. Cards wrap and stack on narrow screens.

One shared `MetricTrend` now renders both summary and individual-card comparisons, including screen-reader direction labels, finite-value checks, rounded-zero handling and explicit unavailable states. No percentage is inserted for a snapshot without a comparison. Vendor Earnings now connects all four summary totals to the existing server comparison fields, including the period label; All dates offers Choose dates to compare, and zero baselines retain No comparison. The original financial calculation cards use the same indicators.

Coverage includes Vendor dashboard sales, product sales-value KPIs, Earnings and product/delivery reconciliation, commission monitoring, statement amounts and the shared gross-remittance threshold panel; Admin financial overview/calculation cards, billing/tax summary tiles, dashboard GMV and geographic GMV cards. Nonfinancial KPI cards retain their existing surfaces while reusing the common trend renderer when they already have a delta. Suppressed geographic cells retain their disclosure text and light surface.

All financial formulas, event-date bases, immutable records, refund semantics, taxpayer thresholds, Owner-only finance access, disclosure rules, payment controls, exports, APIs, filters, notices and navigation are preserved. Existing workspace edits were retained.

## Files changed for this request

| Area | Files |
| --- | --- |
| Shared trend renderer (new) | `packages/web-ui/src/metric-trend.tsx`, `metric-trend.css` |
| Shared financial appearance | `packages/web-ui/src/kpi-card.css` (new), `chart-patterns.tsx`, `analytics-layout.tsx`, `analytics-layout.css`, `page-patterns.tsx`, `finance-patterns.tsx` |
| Vendor consumers | `apps/vendor-web/src/pages/FinancePages.tsx`, `VendorDashboardInsights.tsx`, `ProductAnalyticsPages.tsx` |
| Admin consumers | `apps/admin-web/src/pages/FinanceOperationsPanels.tsx`, `AdminDashboardInsights.tsx`, `GeoAnalyticsPage.tsx` |
| Component checks | `apps/vendor-web/src/components/FinancialKpiCard.test.tsx` (new), `apps/vendor-web/src/pages/FinancePages.test.tsx` |
| Browser checks | `apps/vendor-web/e2e/earnings-layout.spec.ts`, `admin-finance-layout.spec.ts` |
| Report (new) | `docs/test-plans/financial-kpi-design.md` |

No migrations, OpenAPI request/response/schema changes, generated-client edits, new grants or audit/notification events. No credentials or manual setup are needed. Nothing was pushed or deployed.

## Validation

| Command / check | Exact result |
| --- | --- |
| Vendor `npm.cmd run lint`, `npm.cmd run typecheck`, `npm.cmd run build` | Passed |
| Admin `npm.cmd run lint`, `npm.cmd run typecheck`, `npm.cmd run build` | Passed |
| Vendor `npm.cmd run test -- --run --maxWorkers=4` | 78 files, 723 tests passed |
| Admin `npm.cmd run test -- --run --maxWorkers=3` | 40 files, 261 tests passed |
| Vendor focused shared-summary/financial-card/Finance checks | 3 files, 60 tests passed before the full suite |
| Browser `npm.cmd run test:e2e -- e2e/earnings-layout.spec.ts e2e/admin-finance-layout.spec.ts e2e/dashboard-layout.spec.ts e2e/product-analytics-layout.spec.ts --workers=2` | 87 passed; one 1024px Product Analytics case completed its assertions but failed during trace cleanup with ENOENT after a concurrent Playwright run reused the output directory |
| Isolated rerun: `npm.cmd run test:e2e -- e2e/product-analytics-layout.spec.ts --project=chromium-1024 --workers=1 --output=../../.tmp/financial-kpi-validation/product-rerun` | 1 passed; separate artifacts directory |
| Browser `npm.cmd run test:e2e -- e2e/admin-geographic-overview.spec.ts --project=chromium-320 --project=chromium-1440 --workers=1` | 2 passed |
| API contract `npm.cmd run validate` | Passed; eight existing unused-model recommendations |
| `gitleaks dir .tmp/financial-kpi-validation/security --redact --no-banner` | Actual working diff and changed/new sources passed; no leaks |
| `gitleaks git --staged --redact --no-banner` | Passed; staging area empty |
| `git diff --check` | Passed |

All 90 distinct browser cases passed across the primary run and isolated rerun. They cover eight configured widths from 320 to 1920px, all four Earnings indicators, the All dates and unavailable-baseline states, calculation disclosures and signed amounts, Admin snapshot totals without fake percentages, billing tiles, role restrictions, dates, automatic updates, product pages and map/KPI layout. Desktop and mobile Earnings screenshots and desktop Admin Finance calculation screenshots were visually inspected. Evidence remains under `.tmp/analytics-review/earnings/` (`1440-earnings-trends.png`, `320-earnings-trends.png`) and `.tmp/analytics-review/admin-finance/` (`1440-platform-finance-breakdowns.png`), plus existing dashboard evidence paths.

Initial focused checks caught a nonexistent average-order-value percentage field and test locators tied to the old card markup. The card retains its existing previous-value hint; the locators now follow the definition-list semantics. The final full suites pass.

Browser data is mocked. Live provider/data acceptance, PHP and Flutter suites were not performed for this frontend-only request. Docker is unavailable in this shell; run `docker compose config --quiet` in a Docker-enabled shell. Existing nonblocking warnings remain: the unused `inStore` browser fixture variable, Vite large chunks, Vitest esbuild/oxc precedence, jsdom navigation output and a Git LF/CRLF notice for a pre-existing edited browser file.

Suggested commit: `style(finance): unify vendor and financial KPI cards`.

## Admin development-server repair — 3 November 2026

The reported `/analytics` overlay was reproduced on `http://localhost:5174`: `chart-patterns.tsx` returned 500 for its `./kpi-card.css` import, and a direct stylesheet request returned 403. The file existed and was readable. Admin's strict Vite serving allow list covered only the shared assets folder, excluding the rest of the shared UI source directory. A server restart alone did not resolve it.

Changed `apps/admin-web/vite.config.ts` to allow `packages/web-ui/src` rather than only its assets subdirectory. The allow list stays bounded; a direct request for repository `PRODUCT.md` still returns 403. The importing module and both KPI/trend stylesheets now return 200.

Extended `apps/admin-web/vite.config.test.ts` to check shared styles, importing-module transformation, the login image and rejection of unrelated repository files. The test now has its own `.tmp/admin-vite-config-test` dependency cache. Previously its temporary Vite server shared the running app's default cache; during verification that replaced the React dependency metadata and caused a 504/blank startup. The isolated cache prevents that collision. The local Admin dev server was restarted on port 5174 after the repair.

Validation: the focused Vite regression test passed (1 file, 1 test); Admin lint and TypeScript checks passed; `git diff --check` and changed-source secret scanning passed. A fresh Chromium visit to the actual development URL rendered the `Philippine geographic analytics` heading with zero Vite overlays, failed module requests or JavaScript runtime errors. Evidence is in `.tmp/runtime-recovery/`. Full suites and production builds were not repeated for this development-server configuration/test fix.

No migration, API, generated-client, business-rule or authorization-grant change; no credentials or new setup required. An already-open browser tab may need Ctrl+Shift+R. Suggested fix commit: `fix(admin): allow shared UI source in dev server`.
