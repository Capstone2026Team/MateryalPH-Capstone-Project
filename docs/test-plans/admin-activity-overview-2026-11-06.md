# Admin activity in Overview — 6 November 2026

## Outcome

Overview now includes Active Buyers and Vendor users as a full-width panel below Marketplace value and Vendor health. Compact Buyer and Vendor period summaries replace the wide summary table. They sit side by side on larger screens and stack on mobile, with separate daily, 7-day and 30-day counts. The panel retains the daily comparison chart, expandable rolling 30-day chart and View as table. Calculation help explains qualifying human actions, overlapping windows and privacy suppression. Chart axes use whole-person ticks, including low activity periods.

The dashboard now has three tabs: Overview, Disputes & Appeals, and Audit Logs & Tracking. User Activity and Transactions & Finance and their separate dashboard contents were removed as requested. Platform earnings and the existing Overview cards retain their positions. Standalone Platform Finance, Marketplace Analytics, Vendor verification, score monitoring and other routes remain unchanged; authorized work remains reachable through Priority actions and existing navigation.

## Changed files

- `apps/admin-web/src/pages/AdminDashboardPage.tsx`
- `apps/admin-web/src/pages/AdminDashboardInsights.tsx`
- `apps/admin-web/src/pages/AdminDashboardInsights.test.tsx`
- `apps/vendor-web/e2e/dashboard-layout.spec.ts` — Admin scenarios
- `docs/design/MateryalPH_UI_UX_Implementation_Planner.md`
- This report.

No migrations, API request/response changes, generated-client edits, financial formulas, authorization grants, providers, audit events or notifications changed. Existing dashboard date filters, 30-second automatic updates, role-scoped aggregates, suppression and separate finance authorization are preserved. A recorded zero stays zero; a suppressed value is never shown as zero. No configuration, credentials or manual setup is required. No deployment, push or merge was performed.

## Validation

| Working directory and command | Result |
| --- | --- |
| Admin: `npm.cmd run lint` | Passed |
| Admin: `npm.cmd run typecheck` | Passed |
| Admin: `npm.cmd run build` | Passed; existing large-chunk advisory remains |
| Admin: `npm.cmd run test -- --run --maxWorkers=2` | Final full run: 44 files, 293 tests passed in 83.95 seconds |
| Vendor: `npx.cmd playwright test e2e/dashboard-layout.spec.ts --grep "Admin dashboard\|Admin platform earnings" --project=chromium-320 --project=chromium-768 --project=chromium-1440 --project=chromium-1920` | 20 checks passed in 34.4 seconds |
| Vendor: `npx.cmd playwright test e2e/dashboard-layout.spec.ts --grep "Admin dashboard uses current counts" --project=chromium-320 --project=chromium-1440` | Final screenshot follow-up: 2 checks passed in 4.7 seconds |
| Repository: scoped `git diff --check` | Passed |
| Repository: `gitleaks dir .tmp/admin-activity-overview-review --redact --no-banner` | Changed-file snapshots scanned; no leaks |

The initial four-worker full run passed 292 tests and timed out the existing Vite filesystem-access test at five seconds. That test passed alone, then the final two-worker full suite passed all 293 tests. Its implementation and timeout were not changed. Existing Vite transform advisories remain.

Component coverage verifies separate Buyer/Vendor counts, suppressed values versus recorded zeros, suppressed chart gaps, the daily table, rolling chart, help and whole-person axes. Browser coverage verifies the three-tab navigation, activity in Overview, full-width placement, period counts, chart/help/table interaction, automatic summary updates, preserved dispute/audit sections, restricted analytics, local finance denial, equal neighboring card heights and no horizontal page overflow.

Final 320px and 1440px activity screenshots under `.tmp/admin-activity-overview/` were visually inspected. Broader Overview screenshots are under `.tmp/dashboard-card-layout/`. Browser data is mocked; live-data/provider acceptance was not performed. Backend, Flutter and API-contract suites were not rerun for this client presentation change. The previously unavailable Docker environment gate was not retried; when Docker is installed, run `docker compose config --quiet` from the repository root.

Suggested conventional commit: `style(admin): consolidate activity into dashboard overview`
