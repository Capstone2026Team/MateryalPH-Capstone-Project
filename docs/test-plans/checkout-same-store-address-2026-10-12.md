# Checkout same-store-address message — 2026-10-12

## Outcome

When a delivery route is unavailable or not found, the existing blocked message now identifies a destination that matches the Vendor's saved store pin or formatted address. Address comparison ignores case and repeated/leading/trailing whitespace and never matches two blank addresses. There is no new distance threshold.

Buyer message:

> Your intended destination matches the Vendor's store address. Delivery is blocked because a route to this location could not be confirmed. Choose another delivery location or select Self-Pickup if available.

When a heavy-vehicle restriction requires an alternate endpoint, the message names the **alternative vehicle drop-off** and compares that endpoint with the store. A matching intended site does not produce this explanation when the alternate drop-off is elsewhere.

The shared API service supplies the same message to checkout and product delivery preview. Existing Buyer components already display the server's issue message, so no new client rendering logic is required. Route issue codes, eligibility, fulfillment choices, fees, destination ownership and all order-submission safeguards remain unchanged. A matching address with an available route follows the normal review path. No route distance, zero fee, reservation, order, audit event or notification is invented by this informational preview.

## Files and contract

- `services/api/app/Domain/Procurement/DeliveryPreviewService.php`: reads the public formatted store address and supplies the more specific route-failure message.
- `services/api/tests/Feature/Api/PhaseSevenItemProcurementTest.php`: regression coverage for exact pins, formatted addresses, unrelated addresses, both route-failure codes, product preview consistency, normal eligibility after route recovery and alternate endpoint selection.
- `packages/api-contract/openapi.yaml` and `scripts/check-procurement-contract.mjs`: document and validate this message behavior; request/response fields and stable error codes are unchanged.
- Canonical regeneration changes documentation in TypeScript `src/models/DeliveryPreview.ts`, TypeScript `docs/DeliveryPreview.md`, and Dart `lib/src/model/delivery_preview.dart`. No generated file was edited by hand.
- This verification note. No migration or development commercial data change is needed.

## Verification

- New focused API regressions: **2 passed, 80 assertions**.
- Full Phase 7 procurement suite: **15 passed, 501 assertions**.
- Related Phase 8 delivery-order regressions: **2 passed, 75 assertions**.
- Pint: **passed**, two changed PHP files.
- PHPStan: **passed**, no errors.
- OpenAPI validation: **passed**, eight unused-model recommendations.
- Procurement route/contract check: **passed**, 15 operations and guards.
- Canonical TypeScript/Dart client regeneration: **passed**; only the three documented generated files changed.
- Generated TypeScript client build: **passed**.
- Full generated Dart client analysis: **one existing warning**, `unused_element_parameter` for `specifiedType` at `lib/src/model/geo_demand_cell_value.dart:40`. That model's bytes are unchanged from the pre-edit baseline; no analyzer errors were reported. The command exits 1 because of the warning.
- Changed-source Gitleaks scan: **passed**, no leaks found.
- Changed-file whitespace and baseline diff review: **passed**, without Git commands.

A read-only local diagnostic printed only boolean comparisons and made no external requests. The currently saved screenshot store/destination do not match by exact pin or normalized formatted address, so this change does not relabel that existing route failure as a matching-address problem. No live check using private checkout coordinates, UI/device test, deployment or commit was performed.

## Manual acceptance

Reload checkout after an unavailable/no-route response for a destination that matches the Vendor's store address. Confirm the blocked panel explains the match and offers changing the location or Self-Pickup only when available. An alternate endpoint should be named correctly. An unrelated destination must retain its original route explanation.

Suggested conventional commit: `fix(checkout): explain route blockers at vendor store addresses`.
