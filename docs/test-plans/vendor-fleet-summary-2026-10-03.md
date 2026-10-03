# Vendor fleet summary — 2026-10-03

## Result and definitions

Added a responsive Fleet overview above the existing vehicle list using shared `MetricCard` components:

- Total vehicles: summed configured vehicle units in saved, nonremoved configurations.
- Active vehicles: units in enabled, nonremoved configurations.
- Available vehicles: units in enabled configurations manually marked available.
- In use: summed confirmed vehicle assignments on this Vendor's DELIVERY orders whose order state is currently OUT_FOR_DELIVERY, as requested by the user. Also shows the number of contributing orders.

Configurations represent pools, not individually identified physical vehicles. In use counts each confirmed snapshot entry; repeated assignments can count more than once. It does not count trips, infer GPS activity, or subtract assignments from manually configured availability. Historical assignments remain counted if their fleet configuration is subsequently disabled or removed.

Refresh fleet retrieves current saved data. Refresh is disabled during unsaved edits. Successful saves refresh the summary from the API response. Missing summary data shows an unavailable state rather than fabricated zeroes.

## Files and contract

- `services/api/app/Domain/Vendors/VendorFleetService.php`: Vendor-scoped aggregate queries returned as `meta.summary` on organization fleet GET/PUT responses.
- `services/api/tests/Feature/Api/PhaseFiveInventoryDeliveryTest.php`: unit-versus-configuration totals, zero fleet, availability/disabled/removal behavior, order-state filtering, foreign Vendor isolation, immutable delivery assignments and staff summary exclusion.
- `packages/api-contract/openapi.yaml`: additive `FleetSummary` schema and optional `FleetVehicleListMeta.summary`.
- `packages/api-contract/scripts/check-inventory-contract.mjs`: summary schema assertions.
- `packages/api-contract/generated/typescript` and `generated/dart`: regenerated source, exports, documentation and serializers; TypeScript compiled client rebuilt and Dart build_runner completed.
- `apps/vendor-web/src/pages/FleetPages.tsx`: summary cards and refresh control.
- `apps/vendor-web/src/pages/FleetPages.test.tsx`: summary rendering, saved-versus-draft counts, refresh protection, missing summary and role visibility.
- `apps/vendor-web/e2e/phase-5-inventory.spec.ts`: raw API summary fixtures and responsive rendered-count assertions through the generated client.

No migrations, new key names, setup steps, audit mutations or notifications are required. Existing Owner/Store Manager authorization gates protect the organization summary; ASSIGNED_ONLY Fulfillment access receives no organization summary. Both orders and delivery snapshots are scoped to the authenticated Vendor. No private Buyer or staff data is returned by the summary.

## Verification

- Isolated `php artisan test tests/Feature/Api/PhaseFiveInventoryDeliveryTest.php --compact`: **12 passed, 304 assertions**.
- Isolated `php artisan test tests/Feature/Api/PhaseThreeVendorOnboardingTest.php tests/Feature/Api/PhaseTwelveFulfillmentTest.php --compact`: **94 passed, 1,625 assertions**.
- `php vendor/bin/pint --test app/Domain/Vendors/VendorFleetService.php tests/Feature/Api/PhaseFiveInventoryDeliveryTest.php`: passed.
- `php vendor/bin/phpstan analyse --memory-limit=512M`: no errors, 377 files.
- Contract `npm.cmd run validate`: valid; three existing unused-model recommendations.
- Contract `npm.cmd run test:inventory-contract`: passed, 17 routes and guards.
- Generated TypeScript `npm.cmd run build`: passed.
- Generated Dart `dart run build_runner build --delete-conflicting-outputs`: completed; the installed build_runner ignored the obsolete flag. `dart analyze`: no issues.
- Vendor lint, typecheck and production build: passed; existing bundle-size warning remains.
- Vendor `npm.cmd run test -- --run --no-file-parallelism`: **30 files, 237 passed**.
- Vendor `npm.cmd run test:e2e -- e2e/phase-5-inventory.spec.ts -g "vehicles open"`: **8 passed**, widths 320, 375, 390, 768, 1024, 1280, 1440 and 1920; overflow checks and generated-client decoding included. Desktop and mobile screenshots reviewed.
- Admin consumer typecheck: passed.
- Redacted directory secret scans passed for affected Vendor page/E2E, API domain/test and generated-client directories. Direct changed-source whitespace/conflict-marker check passed. No Git commands used.

An initial browser run caught stale compiled TypeScript client output; rebuilding the generated client and portal resolved it, and all eight browser checks passed on the corrected build. The default filtered Artisan invocation discovered no tests; explicit test-file invocations above ran and passed. Sandbox access initially blocked Docker/Dart caches; approved access allowed isolated API and Dart checks to finish.

## Scope of evidence

API tests used the isolated test database; browser tests used fixture API responses. No development data was created or modified, no development migrations were applied, and live user-order counts were not inspected. No deployment was performed.

Suggested conventional commit: `feat(vendor): add fleet summary and delivery usage counts`
