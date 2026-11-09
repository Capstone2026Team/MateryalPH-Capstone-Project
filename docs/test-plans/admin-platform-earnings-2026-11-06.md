# Admin dashboard paid commission chart — 6 November 2026

## Outcome and calculation

Overview replaces Marketplace value with Platform earnings in the same full-width position. The card reuses the Vendor Sales trend's shared bar chart, headline and compact legend, calculation information popup, exact-value tooltips and direct View as table. Existing dashboard account cards, monitoring panels, navigation, global dates and automatic updates are retained.

For the requested commissions-paid view, the headline is explicitly **Net collected commissions**:

`verified commission payments allocated to monthly Vendor bills − confirmed platform commission refunds to Vendors`

The generated Finance client reads the existing `/api/v1/admin/finance/kpis` endpoint. Headline totals use `collected`, `refunded_commissions` and `net_collected`; bars use each bucket's `collected_centavos` and `refunded_centavos`. No rate is applied to GMV in the browser. The authoritative collection query already requires a PAID payment with purpose PLATFORM_FEE_PAYMENT, the recorded TEST environment, a bill allocation and no late capture. Refunds require target PLATFORM_FEE and state REFUNDED. Partial statement payments contribute only allocated amounts. Unpaid bills, pending/failed payments, unallocated overpayments, Buyer sales, Buyer fees and withholding are excluded.

Payments use collection dates; refunds use successful refund dates in Asia/Manila. The server returns daily, zero-filled buckets for ranges up to 92 days and monthly buckets for longer ranges. Refund bars show deduction magnitudes with negative labels. The table reports signed net collections for every bucket, including negative refund-only dates. Zero refunds display as zero without a negative-zero amount.

The help text distinguishes collected commission cash from accrued commission revenue and Finance's Net platform earnings. Collected cash includes any applicable fee VAT and is before platform processing costs; this request changes neither their accounting nor revenue recognition. A collection does not earn the commission again. Bills retain the applicable saved commercial rate, initially 2%, on completed materials after discounts and excluding materials VAT. The card has one visible TEST disclosure.

## Files changed

- `apps/admin-web/src/pages/AdminDashboardPage.tsx`
- `apps/admin-web/src/pages/AdminPlatformEarnings.tsx` — new independent finance panel and shared chart composition
- `apps/admin-web/src/pages/AdminPlatformEarnings.test.tsx` — new component coverage
- `apps/admin-web/src/lib/finance-api.ts`
- `apps/admin-web/src/lib/finance-api.test.ts` — new transport isolation coverage
- `packages/web-ui/src/web-api-session.ts`
- `apps/vendor-web/e2e/dashboard-layout.spec.ts` — Admin fixture/scenarios
- `docs/design/MateryalPH_UI_UX_Implementation_Planner.md`
- This report.

No migration, OpenAPI request/response change, generated-client edit, financial-domain change, new grant, audit event, notification or provider mutation. No deployment, push or merge. No new configuration, credentials or manual setup is required.

## Authorization and state handling

The Finance endpoint continues to enforce `finance.view` server-side. Its optional dashboard consumer enables a local 403 response so missing finance access clears the finance card without clearing permitted operational data. Existing clients retain their default forbidden-access behavior. The shared opt-in does not suppress 401 handling or bypass session refresh, cookies, CSRF or server authorization.

The card handles initial loading, failure/retry and denied access without substituting zero. It refreshes every 30 seconds while mounted, visible and online, avoids overlapping reads, backs off after failures and stops polling after finance denial. Resource keys isolate date ranges, so stale responses cannot overwrite the selected dates. Permission revocation removes visible financial amounts.

## Validation

| Command and working directory | Result |
| --- | --- |
| Admin: `npm.cmd run lint` | Passed |
| Admin: `npm.cmd run typecheck` | Passed |
| Admin: `npm.cmd run test -- --run --maxWorkers=4` | Final run: 44 files, 291 tests passed in 59.25 seconds |
| Admin: `npm.cmd run build` | Passed |
| Vendor: `npm.cmd run lint` | Passed; existing unused `inStore` fixture warning in `e2e/admin-finance-layout.spec.ts` |
| Vendor: `npm.cmd run typecheck` | Passed |
| Vendor: `npm.cmd run build` | Passed |
| Vendor: `npm.cmd run test -- --run --maxWorkers=2 src/lib/web-api-session-loading.test.ts src/lib/web-api-session-recovery.test.ts` | 2 files, 36 tests passed |
| Vendor: `npx.cmd playwright test e2e/dashboard-layout.spec.ts --grep "Admin dashboard\|Admin platform earnings" --project=chromium-320 --project=chromium-768 --project=chromium-1440 --project=chromium-1920` | 20 checks passed in 38.2 seconds |
| Vendor: `npx.cmd playwright test e2e/dashboard-layout.spec.ts --grep "Admin platform earnings shows paid" --project=chromium-320 --project=chromium-1440` | Final follow-up after zero-refund formatting: 2 checks passed in 4.7 seconds |
| Contract: `npm.cmd run validate` | Passed with 8 existing unused-model recommendations |
| Repository: scoped `git diff --check` | Passed |
| Repository: `gitleaks dir .tmp/admin-platform-earnings-review --redact --no-banner` | Changed-source snapshots scanned; no leaks |
| Repository: `docker compose config --quiet` | Blocked: Docker is not available on PATH |

The initial component run found ambiguous text locators matching both the headline and hidden table header. The tests now use the headline's semantic term; the final full suite passes. Type checking also caught a fixture date type and the optional boolean's strict typing; both were corrected before final validation. Existing Vite transform and large-chunk advisories remain.

Tests cover verified-cash totals distinct from earned revenue and marketplace amounts, exact refunds, refund-only negative totals, zero/missing amounts, daily/monthly labels, loading/retry, stale date responses, local finance denial, normal 401/default 403 behavior, dashboard/date integration and automatic finance refresh. Browser records are fixtures, not live-provider verification. Backend and Flutter suites were not rerun because their code did not change.

The final 320px and 1440px chart and table screenshots under `.tmp/admin-platform-earnings/` were visually inspected. Initial broader overview checks also covered 768px and 1920px without horizontal page overflow.

To finish the unavailable environment check, run `docker compose config --quiet` from the repository root on a machine with Docker installed.

Suggested conventional commit: `feat(admin): show paid commission trend on dashboard`

## Follow-up: Marketplace value replaces Overview Order activity

At the owner's request, Overview now renders the existing `GmvTrendPanel` in the former Order activity position. Marketplace value sits beside Vendor health on desktop and stacks below Platform earnings on mobile. Platform earnings remains full-width above both. Order activity remains available in Transactions & Finance. Existing gross/net calculations, suppressed gaps, forecast, table, dates, refresh and aggregate-analytics permissions are unchanged.

Files changed in this follow-up: `apps/admin-web/src/pages/AdminDashboardPage.tsx`, the Admin scenarios in `apps/vendor-web/e2e/dashboard-layout.spec.ts`, the UI/UX planner and this report. No API contract, generated client, migration, authorization, financial rule, configuration or credential change. No deployment.

Validation for this follow-up:

- Admin `npm.cmd run lint`, `npm.cmd run typecheck`, and `npm.cmd run build`: passed; existing large-chunk advisory remains.
- Admin `npm.cmd run test -- --run --maxWorkers=2 src/pages/AdminDashboardInsights.test.tsx src/pages/AdminPlatformEarnings.test.tsx`: 2 files, 18 tests passed.
- Vendor `npx.cmd playwright test e2e/dashboard-layout.spec.ts --grep "Admin dashboard uses current counts|Admin platform earnings finance denial" --project=chromium-320 --project=chromium-768 --project=chromium-1440`: 6 checks passed in 17.6 seconds. Verifies Marketplace value in Overview, its position beneath Platform earnings and beside Vendor health, Order activity retained in Transactions & Finance, equal card heights, section navigation, automatic counts, local finance denial and no page overflow.
- Scoped `git diff --check`: passed. Changed-file snapshot secret scan: passed, no leaks.
- Updated 320px and 1440px overview screenshots in `.tmp/dashboard-card-layout/` were visually inspected. Browser data is mocked; live-data acceptance and backend/Flutter suites were not repeated for this component substitution. No new setup is required.

Suggested conventional commit for the follow-up: `style(admin): replace overview order activity with marketplace value`
