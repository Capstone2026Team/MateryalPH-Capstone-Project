# Admin geographic analytics layout — 7 November 2026

The geographic analytics workspace reuses the shared compact header, KPI cards,
dashboard panels and CalculationHelp popup. White metrics are grouped under
Commerce, Community & activity and Order performance, with one Gross sales accent.
Card columns respond to their content width. The portrait map remains beside the
header and metrics on desktop and retains the existing mobile reading order.
The comparison table uses an opt-in compact density with a maximum height of
440px or 65vh, sticky headers and area names, and keyboard scrolling.

Calculation icons explain all headline metrics, the selected map metric, area
comparison, trend charts and demand. Metric definitions and reporting dates come
from the authorized API response. Demand help uses the existing returned definition.
No client-side financial calculation or privacy threshold was added.

## Scope

- `apps/admin-web/src/pages/GeoAnalyticsPage.tsx`
- `apps/admin-web/src/pages/GeoDemandSection.test.tsx`
- `packages/web-ui/src/analytics-layout.css`
- `packages/web-ui/src/geo-analytics-patterns.tsx`
- `packages/web-ui/src/geo-analytics.css`
- `apps/vendor-web/e2e/admin-geographic-overview.spec.ts`
- `docs/design/MateryalPH_UI_UX_Implementation_Planner.md`
- This validation record.

No migrations, OpenAPI, generated clients, authorization, exports, timers,
automatic-refresh behavior or financial formulas changed. The shared table's
default density retains its existing layout. No new setup or secret key is needed.

## Validation

From `apps/admin-web`:

- `npm.cmd run lint` — passed.
- `npm.cmd run typecheck` — passed.
- `npm.cmd run build` — passed; bundle-size advisory remains.
- `npm.cmd run test -- --run` — 310 passed, 1 failed: the Vite filesystem-access
  test exceeded its default five-second timeout. An isolated default-timeout run
  also timed out.
- `npm.cmd run test -- --run --maxWorkers=2 --testTimeout=30000` — 310 passed,
  1 failed: an asynchronous Review Moderation empty-state lookup in
  `TrustPages.test.tsx`; the Vite test passed in this run.
- `npm.cmd run test -- --run src/pages/GeoDemandSection.test.tsx src/pages/GeoAnalyticsFilters.test.tsx src/components/GeoAnalyticsPatterns.test.tsx src/pages/GeoExportButton.test.tsx src/pages/TrustPages.test.tsx vite.config.test.ts --maxWorkers=2 --testTimeout=30000`
  — 47 passed across six files, including both previously failing tests and the
  new demand calculation-popup interaction. No unrelated test was changed.

From `apps/vendor-web`:

- `npm.cmd run lint` — passed with one unrelated unused-variable warning for
  `inStore` in `e2e/admin-finance-layout.spec.ts`.
- `npm.cmd run typecheck` — passed.
- `npm.cmd run build` — passed; bundle-size advisory remains.
- `npm.cmd run test -- --run src/components/AnalyticsSummary.test.tsx src/components/AnalyticalCharts.test.tsx src/pages/VendorDashboardInsights.test.tsx`
  — 59 passed across three files.
- `npm.cmd run test:e2e -- e2e/admin-geographic-overview.spec.ts` — eight passed
  at 320, 375, 390, 768, 1024, 1280, 1440 and 1920 CSS pixels. Uses synthetic
  authorized aggregates and pinned reference boundaries. Checks cover page
  overflow, responsive map/KPI placement, calculation explanation content and
  viewport bounds, Escape/focus restoration, bounded table height, retained
  rows/sorting, map suppression, keyboard drill-down and preserved URL filters.

Repository checks:

- `git diff --check` — passed; Git emitted line-ending warnings for existing
  workspace changes. The touched tracked files also passed a scoped check.
- `gitleaks git --staged --redact --no-banner` — passed with an empty staged
  diff (zero bytes scanned).
- `Get-Content -LiteralPath $files | gitleaks stdin --redact --no-banner` —
  passed for the eight scoped source, test and documentation files.
- `docker compose config --quiet` — unavailable because `docker` is not on
  this shell's PATH. Run that exact command from the repository root in a shell
  with Docker available.

## Limits and manual acceptance

Both broader-suite failures passed in the focused rerun; a completely green
full Admin suite was not obtained, and unchanged HEAD was not tested. Treat full
suite stability separately from the passing geographic checks. Backend and
Flutter suites were not run for this presentation-only change.

Browser checks use fixtures; they do not establish live-provider, real-export,
screen-reader, device or production acceptance. Review the page with actual
authorized data, including large money values, missing aggregation, failure/retry,
suppressed metrics, selected areas and demand categories/materials. Verify PDF/CSV
export through its existing permission and reauthentication flow.

Suggested commit: `feat(admin): compact geographic analytics and add calculation help`
