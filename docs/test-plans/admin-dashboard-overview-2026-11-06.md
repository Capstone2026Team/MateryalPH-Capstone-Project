# Admin dashboard overview — 6 November 2026

The Admin dashboard no longer has a Compliance & Moderation tab. Overview leads with Active Buyers, Active Tier 2 Vendors, Monthly active Buyers and Monthly active Vendor users. It uses the same shared compact AnalyticsSummary, main chart grid and operations rail as the Vendor dashboard. Active Buyers is the featured orange card.

The main column contains the account/activity summary, a full-width Marketplace value chart, paired Order activity and Vendor health cards, and paired Category demand and Queue load cards. Priority actions and Recent activity occupy the desktop rail and stack below the main content on smaller screens. Existing User Activity, Disputes & Appeals, Transactions & Finance and Audit Logs & Tracking sections remain available.

Account counts retain their current-summary definitions. Monthly activity retains its disclosure-controlled meaningful-action definition and existing date basis. Suppressed cells remain Suppressed; unauthorized or unavailable figures remain unavailable rather than becoming zero. Compliance queues stay reachable from permission-scoped Priority actions and existing navigation. Audit visibility, queue destinations, date filters, chart calculations and automatic updates are preserved. The page no longer requests a previous-period dataset solely for the removed financial headline comparisons.

## Files changed

- `apps/admin-web/src/pages/AdminDashboardPage.tsx`
- `apps/admin-web/src/pages/AdminDashboardInsights.tsx`
- `apps/admin-web/src/pages/AdminDashboardInsights.test.tsx`
- `apps/vendor-web/e2e/dashboard-layout.spec.ts` — Admin scenarios only
- `docs/design/MateryalPH_UI_UX_Implementation_Planner.md`
- This report.

No migrations, API request/response changes, generated-client edits, authorization grants, domain rules, audit/notification events or provider changes. No credentials or manual setup are required. No deployment, push or merge was performed. Existing workspace edits were preserved using pre-edit file snapshots for review.

## Validation

| Command and working directory | Result |
| --- | --- |
| Admin: `npm.cmd run lint` | Passed |
| Admin: `npm.cmd run typecheck` | Passed |
| Admin: `npm.cmd run test -- --run` | 42 files, 281 tests passed |
| Admin: `npm.cmd run build` | Passed; large-chunk advisory remains |
| Vendor: `npx.cmd playwright test e2e/dashboard-layout.spec.ts --grep "Admin dashboard" --project=chromium-320 --project=chromium-768 --project=chromium-1440 --project=chromium-1920` | Final run: 12 passed in 11.3 seconds |
| Repository: `git diff --check` | Passed; existing CRLF normalization warnings |
| Repository: `gitleaks dir .tmp/admin-overview-review --redact --no-banner` | Changed source/test/planner snapshots scanned; no leaks found |
| Repository: `docker compose config --quiet` | Blocked: Docker is unavailable on PATH and at its standard Windows installation location |

Browser coverage checks the requested four card values, featured card, full-width chart, desktop rail alignment, removed tab, preserved compliance link, section navigation, 30/90-day requests, automatic summary updates, restricted counts and audit access, equal neighboring card heights and absence of horizontal page overflow. Initial browser runs exposed test locator/fixture and card-padding assertions; those assertions were corrected before the final passing run. Product code did not require a follow-up correction.

Rendered overview screenshots at 320, 768 and 1440 pixels were visually inspected. Evidence is under `.tmp/dashboard-card-layout/` (`320-admin-overview.png`, `768-admin-overview.png`, `1440-admin-overview.png`, `1920-admin-overview.png`). Browser records are fixtures; live-data acceptance was not performed. Backend, Flutter and API-contract suites were not rerun because their code and contracts did not change. Vite's existing test-transform configuration advisory remains.

Run `docker compose config --quiet` from the repository root on a machine with Docker installed to complete that environment gate.

Suggested conventional commit: `style(admin): align dashboard overview with vendor layout`
