# Portal standardization evidence

Review date: 2026-10-09 (Asia/Manila).

The Admin and Vendor portals now use the same page headers, typography, controls, search inputs, tables, pagination and dialog foundation. The date picker uses the supplied screenshots as its composition reference. Compact screens use a scrolling preset row and stacked months; modal actions stay visible while the calendar and fields scroll. Calendar targets measure at least 44 by 44 pixels. Existing analytics window limits are preserved.

Screenshots in this directory use synthetic API responses and identities. They contain no development sessions, credentials, private documents or precise Buyer coordinates.

## Implementation

- Shared components: `packages/web-ui/src/{button,field,filter-controls,page-patterns,dashboard-patterns,portal-shell,form-dialog,confirm-dialog,date-filter,range-calendar,calendar-dates,notification-inbox,notification-inbox-state,notifications-workspace,vendor-team-activity,index}` and `portal-patterns.css`.
- Vendor pages: Dashboard, Orders, Disputes, Invoices, Finance, Materials/Reviews, Catalog/import, Inventory/history and Store Profile; the corresponding API adapters use generated calendar serialization. Current vehicle configuration continues to use its existing shared editor.
- Admin pages: Dashboard/Geo/Materials, verification, audit, privacy, enforcement/Buyer Management, finance, refund/reimbursement/cancellation, disputes, invoices, product compliance, reviews, notifications/report histories, integrations/jobs and budget actions. Shared OperationsKit supplies tables and pagination throughout nested operation panels.
- Backend: `app/Support/PortalDateRange.php` and the affected controllers/domain queries apply inclusive Manila boundaries before pagination. Omitted boundaries mean All dates on meaningful histories; existing bounded analytics and current-state/statutory views retain their documented scope.
- Contract: optional calendar `from`/`to` parameters on 33 dated GET operations and notification bulk-read scope, with regenerated TypeScript/Dart clients and documentation. Verification retains its existing `submitted_from`/`submitted_to` names.
- Token outputs were regenerated from the existing token source. A comparison confirmed the prior drift was whitespace only; no brand/token values changed.

Search, state filters, sorting, route navigation, permissions, cookie/CSRF transport, optimistic concurrency, idempotency and private export reauthorization remain in place. Transaction CSV follows the selected dates. Dispute CSV retains its explicitly labeled full-status-group scope.

No migration files were added and no development migrations, environment changes, development-data mutations, new dependencies, Git commands, commits or deployments were performed. No new setup or secret keys are required.

## Completed validation

| Check | Result |
| --- | --- |
| Vendor `npm.cmd run lint`, `typecheck`, `build` | Passed |
| Vendor `npm.cmd run test -- --run` | 340 tests passed, 40 files |
| Admin `npm.cmd run lint`, `typecheck`, `build` | Passed |
| Admin full component/transport suite under `America/Los_Angeles` | 85 tests passed, 20 files |
| Vendor calendar/transport checks in Manila and Los Angeles | 11 tests passed in each timezone |
| Shared picker component regressions in the Vendor suite | 11 passed, including malformed-date recovery and preset month/highlight synchronization |
| Date picker/notification browser checks | 32 passed across 320, 375, 390, 768, 1024, 1280, 1440 and 1920 px; browser timezone Los Angeles |
| Broader portal browser regression | 48 passed across 375, 768 and 1440 px |
| Affected API regression in isolated Compose | 72 tests passed, 1,806 assertions |
| Dashboard/Admin operations/inbox API batch | 24 tests passed, 749 assertions |
| Focused date-boundary/scope API tests | 3 passed, 95 assertions |
| Full API Pint and PHPStan | Passed |
| OpenAPI validation and portal date contract | Passed; 33 dated GETs plus bulk-read checked |
| Existing domain route/authorization contracts | Passed, including 34 Admin operations |
| Generated TypeScript builds and Dart serializer generation | Passed |
| Buyer Dart analysis | No issues found |
| Design token generation check and Compose configuration | Passed |
| Gitleaks source scans | No leaks in both portal sources, shared UI, API app/tests, contract scripts and OpenAPI |

The browser regression covers dashboard section navigation and polling, restricted Admin visibility, order detail/actions/Escape/focus/reduced motion, catalog grid/table/empty/import/wizard/compliance, inventory cards/ledger/conflict retention/auto-accept confirmation, per-vehicle validation, messaging, sidebar/drawer behavior and Store Profile sections. Date tests additionally verify draft-only changes, inclusive notification scope, server bulk-read payloads, custom/open-ended dates, All dates reset, preserved search/status scope, pagination reset and calendar month/highlight synchronization when choosing a preset from a historical range.

Browser commands (from `apps/vendor-web`, using the locally running preview servers):

```powershell
npm.cmd exec playwright test -- e2e/portal-standardization.spec.ts --reporter=list --output=test-results/date-standardization
npm.cmd exec playwright test -- e2e/dashboard-layout.spec.ts e2e/orders-layout.spec.ts e2e/phase-4-catalog.spec.ts e2e/phase-5-inventory.spec.ts e2e/messaging.spec.ts e2e/portal-navigation.spec.ts e2e/store-profile.spec.ts --project=chromium-1440 --project=chromium-768 --project=chromium-375 --reporter=list --output=test-results/portal-regression
```

API commands (from the repository root, using the isolated test stack):

```powershell
docker compose --env-file services/api/.env.testing -f compose.test.yaml -p materyalph_phase1_test exec -T api-test php artisan test --compact --no-ansi tests/Feature/Api/PhaseElevenFinanceFlowsTest.php tests/Feature/Api/PhaseFiveInventoryDeliveryTest.php tests/Feature/Api/PhaseFourCatalogComplianceTest.php tests/Feature/Api/VendorTeamTrackingTest.php tests/Feature/Api/PhaseThirteenDisputesTest.php tests/Feature/Api/PhaseFourteenReviewsScoresTest.php tests/Feature/Api/PhaseFifteenExportsTest.php tests/Feature/Api/PhaseFifteenNotificationsTest.php
docker compose --env-file services/api/.env.testing -f compose.test.yaml -p materyalph_phase1_test exec -T api-test php artisan test --compact --no-ansi tests/Feature/Api/DashboardInsightsTest.php tests/Feature/Api/PhaseSixteenAdminOperationsTest.php tests/Feature/Api/NotificationInboxTest.php
docker compose --env-file services/api/.env.testing -f compose.test.yaml -p materyalph_phase1_test exec -T api-test php artisan test --compact --no-ansi tests/Feature/Api/PhaseEightOrdersTest.php tests/Feature/Api/DashboardInsightsTest.php tests/Feature/Api/NotificationInboxTest.php --filter 'date_filter|custom_dates'
```

The executed Windows command uses `C:\Users\RJ\AppData\Local\Programs\DockerDesktop\resources\bin\docker.exe` for `docker`. Generated-client analysis used `C:\Users\RJ\Documents\flutter\bin\cache\dart-sdk\bin\dart.exe analyze` in `packages/api-contract/generated/dart` (exit 1, one warning) and `apps/buyer-mobile` (exit 0). TypeScript used `npm.cmd run build` in `packages/api-contract/generated/typescript`; Dart serializer generation used `dart run build_runner build --delete-conflicting-outputs` in the generated Dart package (exit 0; the obsolete flag was ignored by build_runner).

The Flutter wrapper stalled on SDK cache permissions, so analysis used the installed Dart executable directly. To repeat the normal Flutter CLI gate once local cache access is available, run `flutter analyze` from `apps/buyer-mobile`.

## Visual evidence

The date tests capture picker and filtered-page screenshots for both portals at all eight widths, plus the date-scoped notification view. Catalog and inventory regression captures use `catalog-*` and `inventory-*` names. Representative files:

- [Vendor desktop picker](vendor-date-picker-1440.png)
- [Admin compact picker](admin-date-picker-320.png)
- [Vendor filtered page](vendor-filtered-page-1440.png)
- [Admin filtered page](admin-filtered-page-375.png)
- [Vendor mobile product controls](catalog-375-products-list.png)
- [Inventory conflict dialog](inventory-375-inventory-conflict.png)

These captures were visually inspected alongside desktop/tablet layouts. They demonstrate the shared visual foundation and representative workflows; they do not establish a live-data review of every populated route.

## Remaining verification limits

- The isolated `PhaseEightOrdersTest::test_unchanged_manual_confirmation_reserves_stock_and_assesses_estimated_money` still fails because its expected ESTIMATED fee-assessment fixture is absent. This same unrelated failure was recorded before this redesign; the new order-submission-date test passes. The full backend suite is therefore not claimed as passing.
- Generated Dart analysis exits 1 with one unrelated `unused_element_parameter` warning in `geo_demand_cell_value.dart:40:14`. Buyer application analysis passes.
- Production builds retain the existing large-JavaScript-chunk warning. Bundle splitting was outside the UI/date scope.
- Browser checks use Chromium and synthetic fixtures. Live authenticated datasets, private files, provider behavior, other browser engines and development-schema readiness were not verified. No claim of a full WCAG audit is made.
- Git-based staged scanning and `git diff --check` were not run because the standing instruction prohibits Git commands; source scans and direct source review were used instead.

See [the coverage and behavior inventory](../../../test-plans/portal-design-standardization.md).

Suggested conventional commit: `feat(portals): unify dashboard design and Manila date filters`.
