# Vendor sales overview card

Owner requests, 2026-11-04: use the rounded paired-column reference, retain **Total gross sales** as the headline, rename Dashboard Net sales to **Earnings**, total Earnings and Refunds over the selected period, and prefix refund deductions with a minus sign.

The shared `TrendLineChart` overview appearance supplies the headline, compact period-total legend, rounded columns and exact-value tooltip. Daily hover/touch values do not replace the selected-period totals. Hover, touch, arrow keys, Escape and outside dismissal are supported. Deduction formatting is shared by the legend, tooltip, keyboard announcement, table and calculation breakdown. Missing values remain unavailable rather than becoming zero. Whole summary groups wrap before a currency amount breaks across lines. Other charts retain their existing appearance.

`GET /vendor/dashboard/insights` adds optional nullable `orders.series[].refunds_centavos` and `cancellation_deductions_centavos`. Refund deductions include completed online principal and confirmed physical reimbursements, capped at each order's confirmed sale value; pending/failed refunds, Buyer processing fees and late-capture compensation are excluded. Other cancellation deductions are the cancelled confirmed order value not already counted as refunded. **Gross sales minus refunds minus other cancellation deductions equals Earnings**, per order and per period. Confirmed cash reimbursements now reduce Earnings. API money remains positive integer centavos; the minus sign is presentation. Both plotted series use the order's first confirmation day in Asia/Manila, rather than the refund payout date. Earnings is before commission, other charges and business costs, not profit. The existing `net_sales_centavos` wire name remains stable. The gross-sales forecast is not rendered on this chart.

The existing `finance.view` grant remains required, so only the Owner receives the new money field; other roles receive null. No migration, new permission, audit mutation, notification or environment key is required. TypeScript and Dart clients are regenerated from OpenAPI.

Files changed for this task: `apps/vendor-web/src/pages/VendorDashboardInsights.tsx` and its tests; `src/test/dashboard-insights-fixture.ts`; `src/components/AnalyticalCharts.test.tsx`; `e2e/dashboard-layout.spec.ts` and `e2e/fixtures/dashboard-insights.ts`; shared `packages/web-ui/src/geo-analytics-patterns.tsx` and `geo-analytics.css`; API `VendorDashboardInsights.php` and `DashboardInsightsTest.php`; `packages/api-contract/openapi.yaml`, its dashboard contract checker and the generated `VendorDashboardSeriesPoint` TypeScript/Dart model, documentation and Dart scaffold. Existing unrelated working changes were preserved.

The totals correction also adds `services/api/app/Domain/Analytics/Dashboard/DashboardSalesAmounts.php` and `tests/Unit/DashboardSalesAmountsTest.php`, shared amount helpers in `order-patterns.tsx` and `chart-patterns.tsx` and their exports, and the owner decision in the Vendor workflow. The read projection does not modify immutable order/payment/refund records.

Validation commands:

```powershell
cd apps/vendor-web
npm.cmd run lint
npm.cmd run typecheck
npm.cmd run test -- --run src/components/AnalyticalCharts.test.tsx src/pages/VendorDashboardInsights.test.tsx
npm.cmd run build
npm.cmd run test:e2e -- e2e/dashboard-layout.spec.ts --grep "Vendor sales overview|Vendor dashboard switches|empty analytics|empty sales card" --project chromium-320 --project chromium-768 --project chromium-1440
```

For the totals correction, **34 focused Vendor component tests**, **11 Admin dashboard tests**, **4 calculation unit tests / 20 assertions**, and **12 mocked-browser checks** at 320, 768 and 1440 px passed. The regression fixture covers gross 3,487,020 centavos, Earnings 3,062,275, refunds 236,000 and other cancellations 188,745, followed by a zero-activity day. This verifies period totals, deduction signs, daily tooltips and the complete calculation breakdown. These values are a synthetic regression example, not a verified breakdown of the user's live records. Browser checks also cover tooltip bounds/dismissal, empty/mixed states, equal card heights and page overflow. Screenshots are in `.tmp/sales-overview/`. These are fixture checks rather than live authenticated financial-data verification.

Before the final series change, full portal suites passed with two workers: **744 Vendor tests** and **261 Admin tests**. Initial parallel full runs had a Catalog lookup failure and an Admin Vite timeout; both passed in isolation and in the subsequent full runs. Vendor/Admin lint, typechecks and production builds passed, with an existing Vendor unused-variable warning and bundle-size advisories. Final series/header changes also passed Vendor typecheck, production build, the focused components and browser checks. OpenAPI validation and both dashboard operation contract checks passed.

For the totals correction, Vendor/Admin lint and typecheck and both production builds passed (existing unused-variable and bundle-size warnings remain). API Pint and PHPStan passed. OpenAPI validation and the dashboard operation contract checks passed. The generated TypeScript package built successfully. Dart build_runner completed, and analysis of the regenerated source and builder found no issues. Whitespace and secret scanning cover the task's changes.

The native database-backed `DashboardInsightsTest` run and an outside-sandbox retry stopped at the isolation guard: **8 blocked tests, 0 assertions** in each run, because the Docker hostname `postgres-test` was unavailable and Docker CLI was not installed. Compose validation and the full API suite are consequently unverified. Restore the isolated test stack and run:

The totals-correction follow-up reproduced this blocker with the single reconciliation feature test: **1 blocked test / 0 assertions**. Its new assertions include the daily reconciliation identity and permission-gated cancellation amounts. Pure calculation tests above ran successfully without the database.

```powershell
pwsh -File scripts/run-tests-isolated.ps1 -GuardOnly -KeepRunning -SkipComposer
docker compose --env-file services/api/.env.testing -f compose.test.yaml -p materyalph_phase1_test exec -T api-test php artisan test --compact --no-ansi tests/Feature/Api/DashboardInsightsTest.php
```

Do not point these tests at the development database. No deployment or database mutation was performed.

Suggested commit: `fix(dashboard): reconcile earnings and show period deduction totals`

## Cancellation totals placement follow-up

Owner request, 2026-11-04: put cancellation deductions beside Earnings and Refunds and remove the separate row below the chart. The selected-period legend now includes **Cancellation deductions**, with a minus sign, as a third series. Daily columns, exact-value tooltips and keyboard announcements include the same deduction; the existing table and calculation breakdown retain their detail. Zero is displayed as `-₱0.00`; missing amounts remain unavailable. The header groups wrap at narrow widths.

This follow-up changes `apps/vendor-web/src/pages/VendorDashboardInsights.tsx`, its component tests, `e2e/dashboard-layout.spec.ts`, shared `packages/web-ui/src/geo-analytics.css` and this report. It reuses the shared multi-series chart with its existing palette. The three legend items share a row when at least 312 px is available and wrap as complete groups on smaller cards. There is no migration, API/generated-client change, financial formula or authorization change, new key or manual setup.

Suggested commit: `fix(dashboard): group cancellation deductions with sales totals`

For this placement follow-up, **42 Vendor component tests** and **9 fixture browser checks** passed at 320, 768 and 1440 px. They cover period totals, a nonzero cancellation day, negative deduction formatting, three adjacent legend groups where space permits, tooltips, zero-activity latest days, empty/unavailable charts and page overflow. Desktop and mobile screenshots in `.tmp/sales-overview/` were visually inspected. Vendor lint, typecheck and production build passed; the existing unused `inStore` warning and bundle-size advisory remain. Scoped whitespace and redacted secret checks passed. These checks use synthetic payloads; live financial records, backend and Flutter were not rerun for this display-only follow-up.

```powershell
cd apps/vendor-web
npm.cmd run test -- --run --maxWorkers=2 src/pages/VendorDashboardInsights.test.tsx src/components/AnalyticalCharts.test.tsx
npm.cmd run test:e2e -- e2e/dashboard-layout.spec.ts --grep "Vendor sales overview|empty analytics|an empty sales card" --project chromium-320 --project chromium-768 --project chromium-1440 --reporter=list
```

## Side-by-side header correction — 2026-11-05

Total gross sales is now the left column and Selected period totals the right column. A grid replaces the header's wrapping flex layout, and the three-series legend no longer forces a full-width row. The legend groups wrap inside the right column; headers narrower than 300 px stack the two groups to keep currency values readable. The plot spans both columns. Original metric values, deduction signs, date filters, tooltips, authorization and API behavior are preserved.

The follow-up label is **Other deduction**, consistently used in the legend, tooltip, accessible chart summary, data table and calculation breakdown. Its definition remains cancelled order value that has not already been deducted as a completed refund; it does not introduce a new fee or expense category.

The sales bars are thicker. Each day's visible bars use more of that day's allotted width and share the space that was previously reserved for zero or unavailable series. Bars remain separated and inside their own date bucket. Values, height scaling, dates, zero/missing readings and the other chart appearances are preserved.

This correction changes `packages/web-ui/src/geo-analytics.css` and `geo-analytics-patterns.tsx`, `apps/vendor-web/src/pages/VendorDashboardInsights.tsx` and its tests, the existing browser assertions in `apps/vendor-web/e2e/dashboard-layout.spec.ts`, and this report. No migration, financial formula, API contract, generated client, authorization, setup or environment key is needed.

Suggested commit: `fix(dashboard): align sales totals and widen daily bars`

Final checks for the side-by-side, label and bar-width follow-ups: **42 Vendor component tests**, **11 Admin dashboard tests**, and **16 fixture browser checks** passed. The browser matrix covers 320, 768, 1440 and 1920 px, header alignment, unbroken currency values, the Other deduction label and minus sign, wider bars staying inside their date buckets without overlap, tooltips, and empty/unavailable states in both portals. Desktop and phone screenshots in `.tmp/sales-overview/` were visually inspected. Vendor lint and both portal typechecks/builds passed; the existing Vendor `inStore` lint warning and bundle-size advisories remain. Scoped whitespace and redacted Gitleaks checks passed. Financial formulas, API payloads and grants were unchanged; live backend/provider and Flutter checks were not part of this presentation update. No deployment, migration, credential or environment setup is required.

```powershell
cd apps/vendor-web
npm.cmd run test:e2e -- e2e/dashboard-layout.spec.ts --grep "Vendor sales overview|empty analytics|an empty sales card|Admin dashboard uses current counts" --project chromium-320 --project chromium-768 --project chromium-1440 --project chromium-1920 --reporter=list
```

## Compact, wider bars — 2026-11-05

The final request requires larger bars, a compact card and the entire date range visible without scrolling. Sales trend spans both columns of the dashboard chart group, giving the daily bars more room while keeping the plot **176 px high**. The plot fits the available card width, showing all dates together with the normal peso axis. There is no horizontal scrollbar, scrolling hint, panning control or date aggregation. Tooltips, touch, keyboard arrows, Home/End and the existing daily data table retain exact daily values.

Only the Sales trend card uses the full-width appearance. Other charts keep their default sizing. Daily bars continue to share only their own date bucket; zero/missing series do not reserve empty bar slots. No amounts, date grouping, financial calculations, contracts, generated clients or permissions change. Files for this follow-up are `packages/web-ui/src/geo-analytics-patterns.tsx`, `geo-analytics.css`, shared `analytics-layout.tsx`, `analytics-layout.css`, `dashboard-patterns.tsx`, `apps/vendor-web/src/pages/VendorDashboardInsights.tsx`, `apps/vendor-web/e2e/dashboard-layout.spec.ts` and this report. No migration, provider setup or environment key is required.

The new sparse-data fixture covers 35 dates with one large sale and separate deductions, matching the visual shape reported by the user. Browser assertions check the full-width card, compact plot height, simultaneous first/last date visibility, no scrolling or hint, exact amounts, keyboard navigation and page overflow. Screenshots are `.tmp/sales-overview/*-sparse-bars.png`.

Suggested commit: `fix(dashboard): keep sales bars readable in a compact plot`

Final validation: **42 Vendor component tests**, **11 Admin dashboard tests** and **20 fixture browser checks** passed. The browser matrix covers 320, 768, 1440 and 1920 px, including a 35-day sparse series, complete date-range visibility, no horizontal scrolling/hint, compact chart height, full-width card layout, non-overlapping bars, exact tooltips, keyboard/touch interaction and empty/unavailable states. Desktop and phone screenshots were visually inspected. Vendor lint, both portal typechecks and both production builds passed, with the existing Vendor unused-variable warning and bundle-size advisories. Scoped whitespace and redacted secret checks passed. Live financial records, backend/provider behavior and Flutter were not revalidated for this presentation-only change.

```powershell
cd apps/vendor-web
npm.cmd run test:e2e -- e2e/dashboard-layout.spec.ts --grep "Vendor sales overview|sparse sales|empty analytics|an empty sales card|Admin dashboard uses current counts" --project chromium-320 --project chromium-768 --project chromium-1440 --project chromium-1920 --reporter=list
```
