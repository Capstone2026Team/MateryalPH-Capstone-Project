# Admin analytics freshness — 2026-10-21

The Admin Dashboard and geographic Marketplace Analytics shared an overnight projection while the Vendor dashboard read current confirmed orders. Reloading the Admin response could not add orders processed after the last aggregation.

`analytics:aggregate-marketplace` now runs every minute under the existing overlap/single-server protections and publishes all geographic fact families in one transaction. It replaces the separate ten-minute presence schedule. The presence recovery command remains available. Daily date buckets, amounts, privacy suppression, permissions and API schemas are unchanged. Materials listed-price history still captures once per day at 00:10 Asia/Manila.

The Admin Dashboard polls insights every 30 seconds. Geographic metrics, material demand, Materials Analytics list/detail and snapshot health reuse the shared portal resource and automatic refresh primitives: visible/online polling, deduplicated requests, scoped filter keys, pending data retention, unauthorized-data removal and 120-second failure retry.

Verification:

- `PhaseSixteenGeoAnalyticsTest`: recurring command updates both Admin endpoints with later orders and cancellations; gross matches the Vendor dashboard; no duplicate facts; privacy suppression remains effective; every-minute aggregation and daily price capture schedules remain distinct.
- The existing boundary-only geography fixture removes its recognizable place names so the test actually exercises boundary fallback and unresolved geography.
- `use-analytics-resource.test.tsx`: automatic replacement without pending flicker, slow-request deduplication, filter race isolation, hidden/offline resume, revoked data and failure backoff.
- Run the Admin suite, lint, typecheck and build; API Pint/PHPStan plus geographic/dashboard/materials regression suites; OpenAPI validation and existing dashboard/admin-operations/trust contract checks.

Manual acceptance: keep the same date range in Vendor and Admin, confirm a child order, then allow the next scheduler minute and visible-page refresh. Check gross/order totals, then cancellation/refund net amounts and selected geographic filters. Materials history must retain its actual capture time. A running scheduler is required; Free staging sleep pauses it. This change does not deploy staging or run browser/device/provider acceptance.

Completed checks:

- Admin `npm.cmd run test -- --run`: 26 files, 155 tests passed. Lint, typecheck and production build passed; the build retains its bundle-size warning.
- Isolated API `php artisan test --compact --no-ansi --filter='PhaseSixteenGeoAnalyticsTest|DashboardInsightsTest|PhaseFourteenAnalyticsTest'`: 17 tests, 620 assertions passed.
- Pint on changed PHP files and full PHPStan analysis passed.
- OpenAPI validation passed with eight unused-model recommendations. Dashboard, Admin operations and trust contract scripts passed (2, 34 and 39 operations respectively); no API schema/client generation or migrations were needed.
- Compose validation, staged/diff/source secret checks and `git diff --check` passed. Nothing was staged; the staged secret check scanned zero commits, so separate diff/source scans covered the changes.
- The running local scheduler published October 21 facts without a manual rebuild. Derived and source totals both show 8 confirmed orders and 3,487,020 centavos gross (PHP 34,870.20); derived net is 3,298,275 centavos (PHP 32,982.75). This is local runtime evidence, not deployed-staging or browser acceptance.

Suggested commit: `fix(admin): keep dashboard and marketplace analytics current`.
