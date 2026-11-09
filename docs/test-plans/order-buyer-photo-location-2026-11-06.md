# Order Buyer photo and fulfillment location map

The Vendor order drawer and full Order information show the Buyer's current private profile photo, with initials when missing, denied, stale or unreadable. Pickup and Delivery use one shared location panel. Pickup shows only the registered store; Delivery shows the store and saved actual vehicle endpoint with a Google driving estimate, route line and directions link. An alternate vehicle drop-off remains distinct from the intended site. Addresses and navigation remain available during map/route failures.

## Implementation

- Vendor: `OrderPages.tsx`, `OrderLocationPanel.tsx`, `orders-api.ts`.
- Shared UI: `ChatAvatar` image-error fallback; `DeliveryRouteMap` supports a single pickup pin, loading, retry and stacked address alternatives in narrow panels.
- API: `OrderLocationMap`, `OrderQueries`, `DeliveryBuyerContact`, `DeliveryWorkspace`, `VendorOrderController`, `routes/orders.php`.
- OpenAPI and regenerated TypeScript/Dart clients: optional `OrderDetail.location_map`, `OrderBuyerRef.profile_photo_path`, `OrderLocationMap`, and two read-only Vendor order operations.
- No migration, commercial snapshot, amount, status, payment or fulfillment transition change.

## API and authorization

`GET /api/v1/vendor/orders/{orderId}/buyer-photo?version={version}` returns the existing sanitized PNG using private/no-store delivery. Current membership, organization, order visibility, assigned Fulfillment Staff scope and photo version are checked again after private storage access. No public storage URL, user identifier, email or phone is added.

`GET /api/v1/vendor/orders/{orderId}/route` reuses the server Routes adapter/cache and rechecks current order access after the provider call. Read-only route preview follows order-view access; operational fulfillment permissions remain separate.

`location_map` is projected into authorized Vendor order details only, excluding order/fulfillment lists, Buyer responses and analytics. It uses saved order endpoint coordinates, never device GPS. Historical pickup addresses that differ from the current registered address retain the text/navigation fallback rather than showing an inaccurate current-store pin.

The existing delivery-contact `mobile_e164` and `avatar_path` gates are unchanged. A separate `profile_photo_path` provides the requested profile identity for authorized pickup and closed-order viewers.

## Automated validation

- Focused Vendor component/page tests: **57 passed** across `OrderPages`, `OrderLocationPanel`, and `DeliveryRouteMap`.
- Full Vendor test run: **863 passed, 1 failed** at the existing Vite dev-server test's 5-second startup timeout. That test passed separately (**1/1**) in 3.65 seconds; the full run is recorded as mixed, not fully green.
- Isolated API photo/map and existing contact regressions: **6 passed, 267 assertions**.
- Complete isolated `PhaseEightOrdersTest` and `PhaseTwelveFulfillmentTest` run: **56 passed, 2,164 assertions** (582.69 seconds).
- Responsive Chromium layout suite: **12 passed** across 390, 768 and 1440 px, both pickup/delivery and drawer/full order. SDK/route/photo responses are synthetic fixtures; this verifies layout, image loading, actual drop-off navigation and overflow, not live Google tiles or route accuracy.
- OpenAPI validation: passed, with eight unused-model recommendations.
- New photo/location contract: passed, including generated TypeScript decoding and Dart serializer presence.
- Existing fulfillment contract: **31 operations passed**.
- Generated TypeScript build: passed. Generated Dart build_runner: passed; focused Dart analysis: **No issues found**.
- Pint for affected API files: passed. PHPStan: **No errors**.
- Vendor production build: passed; existing bundle-size warning remains.
- Final Vendor typecheck: passed. Vendor lint: passed with one unrelated unused-variable warning in `e2e/admin-finance-layout.spec.ts`.
- Source diff whitespace check and staged/new-source secret checks: passed.

## Broader gates and manual acceptance

The broader orders-contract script initially stopped at `openPendingOrderQuotation`, whose existing bearer-or-cookie contract conflicts with the script's cookie-only assertion. That operation/policy was not changed for this request. A final retry also hit its 60-second local Laravel route-export timeout. To bypass local bootstrap for that broader check, run from the repository root:

```powershell
docker compose --env-file services/api/.env.testing -f compose.test.yaml -p materyalph_phase1_test exec -T api-test php artisan route:list --json --path=api/v1 > order-routes.json
node packages/api-contract/scripts/check-orders-contract.mjs order-routes.json
```

Validation covers the affected Vendor/API/shared UI/contracts and generated clients. The remaining API suites, Admin portal suites and Buyer mobile suites were not run.

Confirm with the existing Google browser/server configuration that real tiles and the driving route load for a local delivery order, including its alternate drop-off, and that pickup pins the saved store. Verify with an uploaded Buyer photo and a Buyer without a photo. No new credentials or manual database setup are required. This work introduces no live delivery GPS.

Suggested commit: `feat(orders): show buyer photos and fulfillment maps`.
