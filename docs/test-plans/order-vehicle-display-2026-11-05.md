# Fleet summary and Site Delivery vehicle display — 2026-11-05

## Delivered behavior

- Fleet overview follows the supplied reference: four separate compact white cards, right-aligned icons/help and an orange Total border/bottom accent. Existing count meanings stay intact.
- Vendor order recommendations show the photo, vehicle name/type/brand, payload, mixer volume or cargo dimensions, heavy classification, vehicle/trip counts and eligibility/manual-review status. Trip rates wrap below the details on phones. Existing selection, delivery formula, access confirmations and approval behavior remain intact.
- Buyer and Vendor Site Delivery order details show the saved recommended or confirmed vehicle profile. Recommendations explicitly await Vendor confirmation; confirmed vehicles are labeled for the order. Buyer Out for Delivery adds the existing order progress to the status.
- Photos use contained thumbnails, accessible labels, loading/failure placeholders and retry. Stable image identity prevents repeat loads on ordinary web rerenders. Historical records without a saved photo retain a neutral fallback.
- The existing wide fleet editor, listing-based mixer setup, explicit capacity/access suggestions and draft-preserving automatic refresh remain in place.

## Files and data boundary

- Vendor: `apps/vendor-web/src/pages/FleetPages.tsx`, `OrderPages.tsx`; shared `packages/web-ui/src/delivery-vehicle-card.tsx`, `index.ts` and WebP support in `web-api-session.ts`.
- Buyer: `lib/design_system/components/delivery_vehicle_card.dart`; order models, repository, details screen and the existing `EvidencePhoto` component's optional contain fit.
- API: new `Domain/Vendors/DeliveryVehicleProfile.php` and `Domain/Orders/OrderVehicleImages.php`; projections in `OrderDeliveryPlanner`, `OrderQueries`, `DeliveryPreviewService`; existing `OrderEvidenceFiles` stream integration.
- Contract: `packages/api-contract/openapi.yaml`, generated TypeScript/Dart models, docs and serializers; `scripts/check-order-vehicles-contract.mjs` and its npm script.
- Tests: API profile unit and order feature tests; Vendor shared-card tests and responsive fleet/order tests; Buyer display, contract parsing and private-photo order-screen integration tests.
- Relevant Buyer/Vendor workflows and UI/UX planner document the requested presentation.

No migration or new route is needed. The optional `vehicle_details` profile is additive on delivery estimate options, plan vehicles and confirmed order vehicles. Fields are restricted to physical/display data; private fleet counts and internal operational data are excluded. Older snapshots remain readable. Existing saved configurations already contain the image reference.

## Authorization and history

Buyer bytes use the existing Passport-authenticated Buyer order-file route; Vendor bytes use the existing authorized Vendor order-file route or authorized fleet image resolver. The controller must authorize the order before resolving a vehicle image. A file must be referenced by that order's confirmed configuration, or its submitted estimate before confirmation, belong to the same Vendor organization, have purpose `VEHICLE_IMAGE`, remain PRIVATE and be CLEAN. Allowed image types are JPG, PNG and WebP. Responses retain private/no-store and nosniff headers.

Confirmed display comes from the saved arrangement, never the current fleet. Replacing the fleet image/name does not change accepted order details or grant access to the replacement image. No new state, dispatch allocation, rate, timer, notification or audit mutation is introduced by these display reads. Existing role checks and staff assignment access remain authoritative.

## Checks and results

- API: `php artisan test tests/Feature/Api/PhaseEightOrdersTest.php tests/Feature/Api/PhaseFiveInventoryDeliveryTest.php tests/Unit/DeliveryVehicleProfileTest.php tests/Unit/DeliveryRecommendationTest.php` — **61 passed, 1,328 assertions** in the isolated Compose database. Includes another Buyer's rejection, unreferenced replacement rejection, accepted-photo preservation after fleet changes and rejection after CLEAN status is revoked.
- PHPStan — **no errors**, 587 files. Pint `--test` on the eight affected PHP files — **passed**.
- Vendor typecheck and production build — **passed**. Lint exits successfully with the existing unused `inStore` warning in `e2e/admin-finance-layout.spec.ts`; production build retains its bundle-size warning.
- Focused Vendor card/fleet/order/session tests — **88 passed across four files**.
- Buyer order/fulfillment/contract/card tests — **29 passed across four files**, including an actual private-photo request from Order Details. Flutter analyze — **no issues**.
- Responsive fleet editor, ready-mix setup and order vehicle recommendation tests — **24 passed**, Chromium at 320, 375, 390, 768, 1024, 1280, 1440 and 1920 px. A detected tablet confirmation-button overflow was corrected by allowing the action row to wrap. Two later first-viewport startup/screenshot timeouts passed on rerun; the final complete run passed.
- After the final mobile rate placement and capacity formatting refinement: **8/8** recommendation browser cases, **2/2** web card tests and **1/1** Buyer card test passed. Targeted Dart analysis of the final card and tests found no issues. The clean desktop fleet-summary screenshot run also passed.
- Admin compatibility: typecheck — **passed**; session recovery tests — **9 passed**.
- OpenAPI validation — **valid**, eight unused-model recommendations. TS/Dart generation, TS build and Dart build_runner — **passed**.
- Dedicated order vehicle contract — **passed**. Inventory contract — **17 operations matched**; fulfillment contract — **31 operations matched**.
- Compose config validation, task-scoped whitespace check and Gitleaks on affected source/test files — **passed**. Staged secret scan — **no leaks, zero staged bytes**.

The broader `node scripts/check-orders-contract.mjs ../../.tmp/vehicle-routes.json` check stops at `openPendingOrderQuotation`: that operation declares bearer OR cookie/CSRF while the checker expects only cookie/CSRF for the Vendor mutation. This task does not change that operation. The vehicle assertions run independently in `npm.cmd run test:order-vehicles-contract`; the broad Orders gate remains unresolved.

These are scoped checks, not a clean whole-repository gate. Full API/Admin/Vendor/Buyer suites and live provider/device journeys were not run. Browser tests use synthetic data/images; Buyer tests use synthetic private image bytes. The connected live-browser host was unavailable, so rendered browser-test screenshots were inspected instead.

## Evidence and setup

Synthetic screenshots are saved in `docs/design/evidence/order-vehicles-2026-11-05/` for fleet overview and desktop/mobile recommendations.

No new keys or manual database setup are required. Refresh the Vendor portal and rebuild/restart the Buyer app with the updated API to use the display. On an actual Site Delivery order, verify the saved image/details before and after Vendor confirmation and dispatch; an older record without an image must retain its fallback. No deployment was performed. Only the isolated test containers started for validation were stopped afterward.

Suggested commit: `feat(orders): show delivery vehicle photos and details`
