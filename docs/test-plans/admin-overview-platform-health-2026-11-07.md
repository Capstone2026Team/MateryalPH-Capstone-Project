# Admin overview and case presentation

Scope: Admin Dashboard Overview, its Disputes & Appeals section, and the Admin case queue. Existing API endpoints, generated clients, permissions and database schema remain unchanged.

## Acceptance

- Marketplace value, category demand and order activity use shared calculation-help controls; no three-dot menu remains on Overview. GMV forecast, suppression gaps, keyboard chart navigation and the direct daily table remain available.
- Platform health lists every monitored integration from `/admin/integrations` with its exact reported state and optional environment. The status graph is a current snapshot, never claimed uptime. Simulated and unconfigured services remain separate from healthy services. Check the timestamp and details link, loading, empty, error/retry, refresh and local 403 behavior.
- Participant bars show active Buyer accounts and activated Tier 2 Vendor stores separately, with unavailable role scopes clearly identified. This snapshot does not change with activity dates. Meaningful daily and rolling activity still follows the selected dates.
- Average confirmed order value uses visible gross sales divided by visible confirmed child orders, rounded to the nearest centavo for display. Suppress if either source is suppressed; zero orders yields unavailable, while zero sales with orders yields zero. Fulfillment/cancellation retain their existing server denominators and do not imply complementary cohorts.
- Dashboard case queues include only the role-scoped Disputes and appeals group. Admin case lists use the shared responsive table/cards with parties, issue/remedy, status/handler, deadline, refund and Review case actions. Status selection and pagination still query the server. Empty/error/retry and existing decision/conflict tests remain applicable.
- Verify desktop and mobile layouts, no page overflow, calculation popover placement, Escape dismissal/focus restoration, and section isolation.
- Marketplace at a glance sits directly below Marketplace value. On desktop, the two left cards have the same width as Platform health and their combined height, including the gap, matches the right card. Narrow screens stack Marketplace value, Marketplace at a glance, then Platform health.

## Research used to select metrics

[Sharetribe marketplace metrics](https://www.sharetribe.com/academy/measure-your-success-key-marketplace-metrics/) supports monitoring marketplace activity, transaction value and repeat usage. [Shopify's analytics overview](https://help.shopify.com/en/manual/reports-and-analytics/shopify-reports/overview-dashboard/using-the-overview-dashboard) includes sales, orders and average order value. The implementation uses MateryalPH's existing definitions and cohorts. Repeat purchase and conversion are not shown because the current dashboard contract has no qualifying inputs.

Browser checks use synthetic API responses and verify presentation and permissions handling, not live provider availability.

## Implementation and validation

Changed Admin files: `AdminDashboardPage.tsx`, `AdminDashboardInsights.tsx` and its tests, new `AdminPlatformHealth.tsx` and its tests, `DisputePages.tsx` and its tests, and `lib/operations-api.ts`. Shared changes: the opt-in `AnalyticsPanelColumns` export and its styles in `packages/web-ui/src/{analytics-layout.tsx,analytics-layout.css,index.ts}`. Updated `apps/vendor-web/e2e/dashboard-layout.spec.ts` and the UI/UX implementation planner. Existing unrelated workspace edits were retained.

No database migration, API response/request change, generated-client change, new permission, credential or manual setup is required. Monitoring still requires `integrations.view`, analytics retain aggregate access and suppression, and case decisions retain their server authorization and conflict checks. The dashboard's monitoring request handles 403 locally without changing normal expired-session behavior.

- Admin `npm.cmd run lint`, `npm.cmd run typecheck` and `npm.cmd run build`: passed.
- Admin `npm.cmd run test -- --run --maxWorkers=2`: 46 files, 309 tests passed. The initial default-worker run had one five-second Vite server-test timeout; that test passed alone and in this complete rerun.
- Vendor lint, typecheck and build: passed. Lint retains an unrelated unused `inStore` warning in `e2e/admin-finance-layout.spec.ts`; both portal builds retain bundle-size warnings.
- Vendor `npm.cmd run test -- --run src/pages/VendorDashboardInsights.test.tsx`: 24 tests passed.
- Admin dashboard and case-queue browser checks: 32 passed across 320, 375, 390, 768, 1024, 1280, 1440 and 1920 px. Two additional 320/1440 screenshot checks passed for the final stacked marketplace layout. Used a separate local Admin preview and an ignored Playwright configuration without managed web-server teardown, after the normal runner stalled during teardown despite passing its six selected checks.
- Task-scoped and workspace `git diff --check`: passed. Gitleaks scanned the changed source/documents (including new files): no leaks. The staged scan also passed with no staged content.
- `docker compose config --quiet`: unavailable because Docker is not installed/on PATH in this shell. Run that exact command in a Docker-enabled environment if validating deployment configuration. No backend, database, live-provider or Buyer-device behavior was changed or retested.

Suggested commit: `feat(admin): clarify marketplace overview and platform health`
