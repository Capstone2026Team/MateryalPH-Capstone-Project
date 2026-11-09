# Dashboard reference rebuild — 3 November 2026

This replaces the earlier dashboard simplification's composition. The supplied reference controls the visual hierarchy: one grouped summary with a featured value, two columns of compact graph cards, a narrower operations column, and a record list below the graphs.

## Result

- Vendor Overview: gross sales (or an authorized operational measure), three summary tiles, sales area chart, order columns, category donut, published-score gauge and bars, stock distribution, priority actions and incoming requests. The order pipeline moves to Traffic & Volume. The removed Store workspace card stays removed.
- Admin Overview: grouped GMV/order/Vendor/review totals, value and order trends, category bars, Vendor health distribution, work queues and a small permission-scoped audit activity preview. Category counts use bars because one order can contain several categories; their sum is not represented as an order total.
- Product analytics: grouped summary, four equal graph/ranking cards, top-three ranking summaries, simple suggestions in a side column and the full product table below. Table headers stay intact and wide tables scroll within their own frame. The full data, additional rankings and association analysis remain reachable.
- Finance: compact summary strips and graph-led chart cards. Vendor sales/collections and estimated remittance are side by side; product records follow. The duplicate Earnings top-seller ranking is removed. Admin platform earnings and marketplace payments remain separate. Original calculation tables, signed deductions, commission, VAT and withholding definitions remain available through explicit controls.
- Shared analytics: compact plotting height, consistent card spacing, published-score gauge with proportional bars, grey empty graphs, short legends, and chart-attached data/calculation controls. Score, materials, geographic and other analytical consumers retain their exact values and disclosure rules. Advanced analysis remains available without dictating the overview's layout.
- Mobile: section tabs scroll horizontally, summary tiles stay grouped, graph cards stack, and operations follow the main content. Equal-height graph cards include mixed empty/populated rows.

The chart details control uses native disclosure semantics, supports Escape with focus returned to its trigger, and dismisses on an outside pointer action. Exact-value tables and keyboard chart readings are retained. No decorative sample observations are inserted into empty data.

## Implementation

New shared composition and styles: `packages/web-ui/src/analytics-layout.tsx` and `analytics-layout.css`. Existing shared chart, card, score, insight, price-trend and empty-frame components provide the reusable rendering.

Portal composition changes are in Vendor `VendorDashboardInsights.tsx`, `PhaseThreeVendorPages.tsx`, `ProductAnalyticsPages.tsx`, `TrustPages.tsx`, `FinancePages.tsx`; Admin `AdminDashboardPage.tsx`, `AdminDashboardInsights.tsx`, `FinanceOperationsPanels.tsx`, `GeoAnalyticsPage.tsx`, `TrustPages.tsx`. Corresponding component, navigation and browser assertions were updated for the new visible structure and chart controls.

No migration, API contract or generated-client change is required. No financial formula, role, authorization grant, score eligibility rule, small-cell suppression or provider boundary changes. The Admin audit preview reads the existing paginated endpoint only when `canViewAudit` is true. No credential or manual setup is required. Nothing was pushed or deployed.

## Validation

| Check | Result |
| --- | --- |
| Vendor full suite | 76 files, 700 tests passed |
| Admin full suite | 39 files, 237 tests passed |
| Vendor/Admin lint and TypeScript | Passed |
| Vendor/Admin production builds | Passed |
| Dashboard browser suite | 40 passed in 40.2 seconds, eight viewport projects |
| Other analytical surfaces | 10 browser checks passed at 320 and 1440 px |
| Dedicated final screenshot capture | 4 additional browser checks passed |
| Combined additional browser run | 14 passed in 19.8 seconds |
| Final product table-header follow-up | 2 passed in 3.8 seconds at 320 and 1440 px |
| OpenAPI validation | Passed with eight existing unused-model recommendations |
| Actual diff/new source secret scanning and whitespace | Passed |

Dashboard checks cover the four-card composition, equal dimensions, date filters, automatic updates, role restrictions, grey empty data, keyboard graph values, mobile chart tables and closing details with Escape. Additional checks cover Store Performance, product analytics/detail, My Products, Vendor Earnings, Admin Finance, geographic overview and materials analytics. The final screenshots were visually inspected against the supplied reference, including narrow mobile layouts. Data is deterministic and mocked for these browser checks; live data/provider and deployment acceptance were not performed.

Final dashboard screenshots: `.tmp/reference-review/{1440,320}-{vendor,admin}-dashboard.png`. Other captures: `.tmp/analytics-review/` and `.tmp/dashboard-card-layout/`. Existing committed screenshots were retained. The temporary screenshot-only spec is removed after capture; committed browser coverage remains in the existing portal specs.

Existing warnings: unused `inStore` in the Admin Finance browser fixture, Vite large chunks, Vitest's esbuild/oxc configuration warning, and non-fatal jsdom navigation output. Docker Compose validation remains blocked because Docker is unavailable in this shell; run `docker compose config --quiet` in a Docker-enabled environment. PHP and Flutter suites were not run for this frontend-only change.

Suggested commit: `style(portals): rebuild analytics around compact chart cards`

## Theme-colour follow-up — 3 November 2026

Primary graph marks now use the system's `action-primary` orange instead of blue, with slate comparison series. Additional categories use the existing theme's success, deepened amber, pressed orange and charcoal tokens. Stock and Vendor-health charts use explicit success/warning/error roles so their meanings do not depend on categorical slot order. Summary surfaces use the same orange and pale brand tint; the score gauge uses an orange arc and charcoal needle. Grey empty and suppressed states remain intact.

Changed for this follow-up: shared `geo-analytics.css`, `geo-analytics-patterns.tsx`, `analytics-layout.css`, `score-overview.tsx`; Vendor and Admin `VendorDashboardInsights.tsx` / `AdminDashboardInsights.tsx`; this report. No layout, filter, API, migration, financial calculation, authorization or generated-client change. No setup or credentials required, and no deployment performed.

Validation rerun for this colour correction:

- Vendor and Admin lint, TypeScript checks and production builds passed. Existing unused-fixture and large-chunk warnings remain.
- Focused Vendor component checks: 2 files, 20 tests passed. Admin dashboard checks: 1 file, 8 tests passed.
- Final dashboard browser checks: 10 passed in 9.1 seconds at 320 and 1440 px, covering both portals, empty graphs, date filters, equal card heights and restricted access. Updated screenshots in `.tmp/dashboard-card-layout/` were visually inspected at desktop and mobile sizes.
- Orange/white contrast is 5.18:1, slate/white 7.58:1, success/white 3.30:1, deepened chart amber/white 3.23:1 and error/white 4.83:1. Labels, distinct line styles and accessible data tables remain available; this is not a new colour-vision simulation audit.
- Actual tracked diff plus new shared source secret scans passed; `git diff --check` passed. Backend and Flutter checks were not rerun for this presentation-only follow-up. Browser data is mocked; live-data acceptance was not performed.

Suggested follow-up commit: `style(analytics): align portal charts with the orange theme`

## Welcome-header follow-up — 3 November 2026

Restored the shared personalized `Welcome back, [full name]` page header on the active Vendor Owner dashboard and Admin dashboard. Vendor retains the store name, Active badge and original supporting sentence; Admin retains Platform overview, Admin workspace and the aggregation note. Removed the automatic `Hi, [first name]` heading from the shared analytics summary, including other consumers of that summary. Explicit finance summary titles and date context remain. The shared summary no longer subscribes to account identity.

Files changed for this follow-up: Vendor `PhaseThreeVendorPages.tsx` and `VendorNavigation.test.tsx`, Admin `AdminDashboardPage.tsx`, shared `analytics-layout.tsx`, browser `dashboard-layout.spec.ts`, and this report. Existing staff-specific dashboards, role boundaries, metrics, graph colours and date filters retain their behavior. No migration, API contract, authorization or generated-client change; no setup or deployment required.

Both portals' lint, TypeScript checks and builds passed. Vendor navigation/identity checks passed (2 files, 95 tests); after removing the extra summary greeting, Vendor dashboard checks passed (9 tests) and Admin dashboard checks passed (8 tests). The final welcome-header browser run passed 4 checks in 8.5 seconds across both portals at 320 and 1440 px, asserting the signed-in name, supporting copy and absence of `Hi,` headings. Updated dashboard screenshots were inspected. Existing lint, build and test-runner warnings remain as documented above. Browser data is mocked; backend/Flutter suites and live-data acceptance were not run for this presentation change.

Suggested follow-up commit: `fix(dashboard): restore welcome headers and remove duplicate greetings`
