# Dashboard summary design and trend indicators — 3 November 2026

## Outcome

The shared analytics summary now has a full-width date/context header, aligned metric cards, larger tabular values, restrained orange surfaces, consistent icon containers and responsive one/two/four-column layouts. The featured metric retains the primary orange treatment.

Trend percentages use green up-arrow pills, red down-arrow pills and neutral flat-change pills, with signed values and screen-reader direction labels. The supporting comparison label sits outside the pill. Missing/nonfinite percentages are omitted unless the caller supplies a visible explanation. Values that round to zero use the neutral state. Both directional pill text/background combinations exceed 5.4:1 contrast using the existing semantic tokens.

Admin Gross GMV and Confirmed orders compare the selected inclusive Manila calendar dates with the immediately preceding period of equal length. Both reads use the existing generated API client and run concurrently. The comparison is discarded if dates, environment or geographic scope do not match, or either dataset is unavailable. Suppressed/missing values and zero baselines produce no percentage. A failed comparison leaves current figures available; 401/403 still reach the existing resource/auth handling. Existing Vendor/Product/Finance percentages use the same shared visual treatment.

Active Tier 2 Vendors and pending business-document reviews remain current snapshots, explicitly labelled as current. Their API has no historical counts, so the UI does not invent growth figures. Existing filters, automatic updates, sidebar/topbar, role boundaries and financial definitions retain their behavior. Existing workspace changes were preserved.

## Files changed for this request

- `packages/web-ui/src/analytics-layout.tsx`
- `packages/web-ui/src/analytics-layout.css`
- `apps/admin-web/src/lib/dashboard-insights-api.ts`
- `apps/admin-web/src/lib/dashboard-insights-api.test.ts` (new)
- `apps/admin-web/src/pages/AdminDashboardPage.tsx`
- `apps/admin-web/src/pages/AdminDashboardInsights.tsx`
- `apps/admin-web/src/pages/AdminDashboardInsights.test.tsx`
- `apps/vendor-web/src/components/AnalyticsSummary.test.tsx` (new)
- `apps/vendor-web/e2e/dashboard-layout.spec.ts`
- This report (new).

No migration, OpenAPI behavior/schema or generated-client change. No new authorization grant, audit/notification event, provider interaction, credential or manual setup. No push or deployment.

## Validation

Commands ran from the named app/package unless otherwise stated.

| Check | Exact result |
| --- | --- |
| Admin `npm.cmd run lint`, `npm.cmd run typecheck`, `npm.cmd run build` | Passed |
| Vendor `npm.cmd run lint`, `npm.cmd run typecheck`, `npm.cmd run build` | Passed |
| Admin `npm.cmd run test -- --run --maxWorkers=2` | 40 files, 257 tests passed before the final four dataset/scope guard cases were added |
| Final Admin `npm.cmd run test -- --run --maxWorkers=2 src/lib/dashboard-insights-api.test.ts src/pages/AdminDashboardInsights.test.tsx` | 2 files, 32 tests passed, including all 21 comparison-helper cases |
| Vendor `npm.cmd run test -- --run --maxWorkers=2 src/pages/VendorDashboardInsights.test.tsx src/components/AnalyticsSummary.test.tsx` | 2 files, 23 tests passed after correcting a missing text space between the percentage and comparison label |
| Final Vendor `npm.cmd run test -- --run --maxWorkers=4` | 77 files, 714 tests passed |
| `npm.cmd run test:e2e -- e2e/dashboard-layout.spec.ts --workers=2` | 56 checks passed across eight viewport projects, 320–1920px |
| `npm.cmd run test:e2e -- e2e/admin-finance-layout.spec.ts e2e/earnings-layout.spec.ts e2e/product-analytics-layout.spec.ts --project=chromium-320 --project=chromium-1440 --workers=2` | 6 checks passed |
| Final Admin comparison browser check at 320/1440px after the availability guard | 2 checks passed |
| API contract `npm.cmd run validate` | Passed with eight unused-model recommendations |
| Repository `gitleaks git --staged --redact --no-banner` | Passed; staging area was empty |
| Actual working diff and changed/new source scan with `gitleaks dir` | Passed; no leaks |
| Repository `git diff --check` | Passed |

The initial unconstrained concurrent full-suite run was interrupted after a Vite server startup timeout and resource contention. The bounded Admin rerun passed. A bounded Vendor full run loaded the earlier missing-space implementation and reported 713 passed / 1 failed; both the affected 23-test rerun and the final 714-test full suite passed after the fix. No test failure remains from this change.

Desktop Admin/Vendor summary screenshots and full mobile dashboard captures were visually inspected. Evidence: `.tmp/summary-trends/{1440,320}-{admin,vendor}-summary.png` and `.tmp/summary-trends/320-{admin,vendor}-dashboard.png`. Mobile full-page captures avoid the fixed topbar overlap that can occur in a tall element-only screenshot. Browser fixtures are deterministic; no live data/provider or deployment acceptance was performed.

Existing warnings: unused `inStore` in the Admin Finance browser fixture, Vite large chunks, Vitest esbuild/oxc option precedence, non-fatal jsdom navigation output and a Git LF/CRLF warning for a pre-existing edited browser file. Docker is unavailable in this shell; Compose validation was not run. Run `docker compose config --quiet` in a Docker-enabled shell. PHP and Flutter suites were not run for this frontend-only change.

Suggested commit: `feat(analytics): refine summary cards and add period trend indicators`.
