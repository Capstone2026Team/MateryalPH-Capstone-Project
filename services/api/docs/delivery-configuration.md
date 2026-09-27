# Delivery configuration and advisory fulfillment foundation

The S2 editor uses shared web-ui controls, preserves unsaved vehicle entries across service changes, and supports adding multiple configurations. Self-Pickup hides and excludes delivery values from the request. The setup editor hides the availability checkbox and preserves existing availability values; saved configurations are not deleted. New delivery coverage defaults to the approved 50 km limit; existing coverage and versioned vehicle distance limits remain unchanged when omitted. The two distance inputs are absent. Coverage is informational and is never an access guarantee.

Category and type are separate. Motorcycles have no subtype. Pickup, Van and Truck show applicable types and descriptions before operational fields. Concrete mixers clear cargo dimensions and require mixer capacity; ordinary cement uses cargo logic. Fees are entered in pesos and converted to integer centavos. Vehicle images use the existing authenticated upload and download transport, private storage and fail-closed scanning; only clean VEHICLE_IMAGE files belonging to the same organization can be attached. Images are not added to public Store Profile media.

The forward migration adds category, custom type, brand and mixer capacity without guessing categories for legacy vehicles. Legacy configurations remain editable but cannot be recommended until completed with applicable capacities, classification, image and effective rates. Store Setup completion and activation share the same eligibility check.

`DeliveryRecommendationService::recommend` is an internal use case for future authorized procurement flows. It loads only the fulfilling Vendor's eligible vehicles and current effective rate versions. Inputs must come from authoritative product and routing data, with a route to the applicable drop-off. A heavy restriction requires both original location and alternative drop-off. Unknown site access fails closed; heavy vehicles additionally require access confirmation. It never treats the Buyer's answer as proof of accessibility.

Cargo inputs describe identical independently transportable units (unit dimensions, count, total actual weight). Conservative axis-aligned packing and actual payload limits determine trips; dimensional weight is used only with an explicit kg/m³ factor. Heterogeneous loads require separate assessment; this service does not claim a general three-dimensional packing solver. Mixers instead use ready-mixed concrete volume and weight. Available fleet size yields vehicle count, total vehicle-trips and trip rounds. Estimated fees use integer centavos and half-up distance multiplication per trip. All eligible alternatives are returned; no unapproved commercial ranking, automatic dispatch or final charge is inferred.

`ConfirmedDeliverySnapshot::record` is an internal acceptance hook, requiring the surrounding order transaction and an actor with `orders.confirm` for the owning Vendor. It re-evaluates selected vehicles, counts and trips, and persists the confirmed charge and arrangement with both locations and copied vehicle/rate details. The new snapshot table rejects updates and deletes at the database level. The future canonical order-acceptance service must call this hook in its transition transaction after Buyer/Vendor commercial confirmation; no ordering UI, payment flow or public recommendation endpoint is introduced in this phase.

Validation uses fake image/scanner/storage adapters and isolated PostgreSQL. Live provider uploads and future ordering integrations are separate acceptance gates. Apply the migration with `cd services/api; php artisan migrate` in the intended environment before using the new API fields.

## Validation record

- Isolated PostgreSQL migration from an empty schema passed; generated ERD/data dictionary match the migrated database.
- Full backend suite: 192 tests, 2167 assertions passed. After the final disable-only and arithmetic guard changes, targeted delivery tests: 8 tests, 43 assertions passed.
- Pint and PHPStan passed with no errors.
- Vendor: lint, typecheck, 130 tests and production build passed.
- Admin: lint, typecheck, 16 tests and production build passed.
- Chromium setup journey: all eight configured widths (320–1920 px) passed. Screenshots inspected at 320 and 1920 px. Browser API and image data were mocked.
- OpenAPI validation and the 33-operation Vendor/Admin contract check passed. TypeScript client built; Dart client and serializers regenerated, and Dart analysis passed.
- The broad Dart generated test suite has six API fixture load failures because its default relative `/api/v1` base URL is invalid for native Dio. These fixtures were not changed by this delivery feature. The full mobile application was not tested.
- Modified UI/domain source secret scans, staged secret scan (no staged files), Compose validation and `git diff --check` passed.
- Live malware scanner, private image storage and actual road-routing providers were not exercised. Buyer ordering and payment integration of the internal recommendation/snapshot hooks remains for the applicable future phases.

Suggested commit: `feat(vendor): add delivery vehicle configuration and advisory fulfillment`

## Setup preview and automatic saving update

Vehicle images preview immediately after selection and saved images use authenticated private-content reads (JPEG, PNG and WebP). Failed uploads retain the selection for retry and prevent leaving until resolved. Finish Later, dashboard links, and changed step navigation save progress automatically; the manual Save setup draft action is removed. Failed saves keep the form open. Closing or reloading a dirty tab triggers the browser unsaved-change warning.

The existing encrypted STORE_SETUP draft now accepts optional JSON `form_state` and returns it privately as `setup.form_state`. Incomplete vehicle entries restore on return without becoming operational vehicles. Complete entries still pass the existing vehicle validation and ownership checks. Pending delivery edits block setup completion. No additional migration or credentials are needed for this update.

The shared Delivery rates calculator uses integer centavos, half-up rounding per trip, sample distance from 0 to 50 km, and total vehicle trips. It is advisory and does not write a final charge. The configured-coverage paragraph is removed from the editor.

Current update validation: Vendor component/navigation tests, Admin tests, both portal lint/typecheck/build, PHP Pint/PHPStan, OpenAPI validation and 33-operation contract checks pass. Eight Chromium viewport checks pass with mocked APIs and image uploads. Database tests are blocked because Docker Desktop CLI is unavailable; run `./scripts/run-tests-isolated.ps1` once Docker is installed/running. Live scanner/storage were not exercised.
