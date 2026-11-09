# Admin and Vendor grouped card backgrounds

Owner request: apply the supplied dashboard summary's white group background to related cards throughout both portals.

## Result

`mp-card-group` in `packages/web-ui/src/portal-card.css` supplies one white semantic surface, a subtle border, the standard 12px radius, and 16px padding (12px below 640px). Existing grids retain their columns, gaps, reading order and equal-height behavior. Groups allow visible focus rings, menus and metric help to extend outside their edges.

The dashboard summary now uses this shared treatment. Other metric rows, analytical card grids, dashboard operations columns and staff workspaces reuse it. Shared summary components cover their existing consumers in orders, finance, catalog, inventory, fleet, user directories, geographic reporting and integration health.

The change adds or reuses the shared class in 50 grouped layouts across 23 source files, plus one existing browser-test helper.

## Changed files

Owner correction — 4 November 2026: restored the original white group backgrounds. The shared CSS, browser-style assertions and `DESIGN.md` match their pre-glass versions; all grouped layouts remain. Both portals' lint, typecheck and production builds passed after restoration. No component/browser suites were rerun for this exact styling revert; the earlier results below are retained as history. No API, database, authorization or setup changes. Suggested restoration commit: `style(portals): restore white card group backgrounds`.

All paths below are relative to the repository root; brace lists name individual files.

- Shared: `packages/web-ui/src/portal-card.css`, `analytics-layout.css`, and `{analytics-layout,catalog-patterns,dashboard-patterns,finance-patterns,page-patterns,section-workspace,vendor-team-performance}.tsx`.
- Admin: `apps/admin-web/src/pages/{AdminDashboardInsights,AdminDashboardPage,FinanceOperationsPanels,GeoAnalyticsPage,IntegrationHealthPages,OrderOperationsPage,UserDirectoryPages}.tsx`.
- Vendor: `apps/vendor-web/src/pages/{CatalogPages,FinancePages,FleetPages,InventoryPages,ProductAnalyticsPages,VendorDashboardInsights,VendorStaffDashboard}.tsx`.
- Browser verification: `apps/vendor-web/e2e/fixtures/card-design.ts` checks computed group backgrounds, borders, padding, card containment and grouped metrics through the existing layout specs.
- This report: `docs/test-plans/portal-card-groups.md`.

Existing workspace edits were preserved. No migrations, API contract/generated clients, permissions, authentication, financial calculations, setup or credential changes are required. No deployment was performed.

## Verification

- Both portals: `npm.cmd run lint`, `npm.cmd run typecheck`, and `npm.cmd run build` passed.
- Vendor full suite: `npm.cmd run test -- --run --maxWorkers=3` — **80 files, 730 tests passed**.
- Admin full suite: the same command — **40 files, 261 tests passed**.
- Browser layouts: dashboards, Earnings, Admin Finance, products and orders — **26 passed**, at 320px and 1440px. Checks include restricted/empty data, filter/navigation behavior, group appearance and horizontal overflow. Desktop Admin/Vendor dashboard, mobile Vendor dashboard and desktop Earnings screenshots were visually inspected.
- Final class-only follow-up: Vendor staff dashboard **6 tests passed**; Admin Finance, geographic filters and integration health **22 tests passed**. Both portals' lint, typecheck and production builds passed again. Browser checks for Admin Finance, geographic overview and integration health **8 passed** at the same two widths.
- OpenAPI: `npm.cmd --prefix packages/api-contract run validate` passed with eight existing unused-model recommendations.
- `git diff --check`, staged Gitleaks and Gitleaks scanning the actual changes passed. The staged scan contained no staged changes.

Browser APIs used synthetic responses. Live authenticated backend/provider acceptance and an exhaustive review of every route/role combination were not performed. PHP and Flutter suites were not run for this frontend presentation change. Docker is unavailable in this shell; the remaining repository configuration check is `docker compose config --quiet` in a Docker-enabled environment.

Existing non-failing warnings: Vendor's unused `inStore` browser-fixture variable, large Vite chunks, Vitest's esbuild/oxc configuration notice and a jsdom navigation notice.

Suggested commit: `style(portals): group related cards on shared surfaces`
