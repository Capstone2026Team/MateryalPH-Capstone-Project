# Vendor dashboard calculation help and secondary cards

Owner request, 2026-11-04: refine the Traffic & Volume and Disputes & Quality cards and add **How this is calculated** where useful.

The follow-up requests make these triggers icon-only and place them at the top right of every applicable metric and chart card. Original metric icons remain alongside the info controls. Calculation footer rows are removed. Each control retains its metric-specific accessible name, 44 px target, keyboard support and existing explanation dialog. Stock status also explains its available-to-sell formula and current-date scope.

The secondary tabs use white grouped surfaces, responsive card grids, compact card headings and quieter section labels. Issue types and current open-case statuses have separate cards so their different reporting scopes are visible. The current-status empty state uses a clear message instead of placeholder bars. Cancellation shares a compact row with current case status. Count charts use distinct whole-number axis ticks, including the single-case 0–1 range.

Calculation help reuses the shared, keyboard-accessible floating explanation. It covers the main Gross sales, Earnings, Average order value and Orders confirmed metrics; operational Fulfillment rate; Demand funnel; Order mix; Requests and confirmations per day; all four quality metrics; Cases filed per day; Issue types; Open cases by status; and Cancellation. Daily traffic and case charts also offer data tables. Explanations distinguish first-confirmation, request, filing, validation and expected-fulfillment dates; selected-period totals versus current workload; independent funnel stages; per-order versus per-report counts; and unavailable rates when the denominator is zero.

The existing backend projection was reviewed for every definition. No calculation, API contract, generated client, migration, status, payment/refund rule, permission or data-access change is part of this design update. Explanations render only with their authorized data sections. No audit mutation, notification, environment key or manual setup is required.

Files for this update:

- `apps/vendor-web/src/pages/VendorDashboardInsights.tsx` and its component tests.
- `apps/vendor-web/src/components/AnalyticalCharts.test.tsx` and `e2e/dashboard-layout.spec.ts`.
- Shared `packages/web-ui/src/analytics-layout.tsx`, `analytics-layout.css`, `calculation-help.tsx`, `calculation-help.css`, `chart-patterns.tsx`, `geo-analytics-patterns.tsx`, `dashboard-patterns.tsx` and `portal-card.css`.
- This report. Existing unrelated working changes are preserved.

Validation commands:

```powershell
cd apps/vendor-web
npm.cmd run lint
npm.cmd run typecheck
npm.cmd run test -- --run --maxWorkers=2
npm.cmd run build
npm.cmd run test:e2e -- e2e/dashboard-layout.spec.ts --grep "Vendor secondary dashboard|Vendor closed cases|Vendor calculation explanations|Vendor dashboard switches" --project chromium-320 --project chromium-768 --project chromium-1440

cd ../admin-web
npm.cmd run lint
npm.cmd run typecheck
npm.cmd run test -- --run --maxWorkers=2
npm.cmd run build
```

Final validation passed: **65 Vendor component tests**, **11 Admin dashboard tests**, **12 Vendor browser checks** and **3 Admin browser checks**. Browser checks cover 320, 768 and 1440 px, restored metric icons, icon-only controls in the top-right headings, 44 px targets, calculation popups without card resizing, keyboard/focus recovery, viewport bounds, real zero values, empty current statuses, equal card heights and horizontal overflow. Vendor screenshots are in `.tmp/dashboard-secondary-cards/`. Desktop and phone screenshots were visually inspected.

Vendor and Admin lint, typechecks and production builds passed. The existing unused `inStore` variable warning in `e2e/admin-finance-layout.spec.ts` and production bundle-size advisories remain. Whitespace checks and a redacted Gitleaks scan of the task's source and report passed.

Before the final icon/heading adjustments, the full suites passed with two workers: **752 Vendor tests in 81 files** and **261 Admin tests in 40 files**. Initial runs with default concurrency reported timing/assertion failures in order, navigation, finance, verification and Vite tests; the same source passed in the subsequent two-worker runs. Final shared-card changes were checked with the focused component and browser suites above.

Browser evidence uses intercepted synthetic dashboard payloads, not the user's live financial or case records. Backend, Flutter and provider behavior are unchanged and are not revalidated by these UI checks. Docker CLI is unavailable in this environment, so Compose validation cannot run. No deployment or database mutation was performed.

Suggested commit: `feat(dashboard): clarify metric calculations and refine quality cards`
