# Delivery staff workspace — 2026-10-13

Owners and Store Managers confirm the delivery staff and accepted vehicle in Order Details. Confirm assignment and dispatch commits the assignment, Out for Delivery milestone and accepted trip together. Fulfillment Staff use `/fulfillment` to search/filter/sort their current assignments, acknowledge them, view delivery information and directions, message the Buyer, report issues and submit delivery proof. Buyer and Vendor Order Details show the public assignment, vehicle, milestones, issues and private proof through authoritative automatic refresh.

When dispatch is the next action, Order Details shows the required staff and accepted-vehicle selectors directly inside the Out for Delivery phase. For an unassigned order with multiple active Fulfillment Staff accounts, the staff selection starts empty and Done stays disabled until a staff member and an available accepted vehicle are selected. Done uses the existing versioned, idempotent assignment-and-dispatch request. Reassignment remains available inside the same phase after dispatch.

Delivery information also shows the order Buyer's name, protected profile photo/initials, current copyable phone, intended delivery address, distinct alternate drop-off, assigned vehicle, schedule and access instructions. Phone/photo fields are exposed only to Owner/Manager and current active assigned staff on an accepted, open Site Delivery order. The order-scoped `GET /api/v1/vendor/orders/{orderId}/fulfillment/buyer-photo?version=...` reauthorizes after private storage access and returns sanitized PNG with private/no-store headers. Other roles and closed/pickup orders receive null contact fields. Missing phone uses the existing Buyer message action; clipboard failure retains selectable text. Desktop information/navigation sections sit side by side; mobile stacks wrapping content and touch-sized actions. Map addresses remain accessible when the route or browser map is unavailable.

## Changed surfaces

- API: `DeliveryAssignments`, `DeliveryWorkspace`, `FulfillmentService`, `FulfillmentView`, `OrderEvidenceFiles`, `OrderQueries`, `OrderNotifier`, `FulfillmentThreadService`, `AccountAccess`, `VendorFulfillmentController` and fulfillment routes.
- Vendor: `FulfillmentPages`, `OrderFulfillmentPanels`, `OrderPages`, `PhaseThreeVendorPages`, `orders-api` and application routes. The earlier `/preview/fulfillment` URL reaches the implemented workspace.
- Shared web UI: `DeliveryRouteMap`, exports, and camera capture in the existing `FileSelectionField` with gallery selection, previews, removal and replacement.
- Buyer: fulfillment models, repository mapping, Order Details fulfillment sections and proof presentation. The intact map module was recovered from the unintended `projects/map_discovery` location to its original `features/map_discovery` path; its source was not rewritten.
- Contract: OpenAPI, generated TypeScript/Dart clients and serializers, multipart array normalization and fulfillment contract checks.
- Workflow decisions: System, Vendor, Buyer and UI/UX planner record the requested role/navigation and delivery-assignment rules. Local task logs are ignored.

## Migration and authorization

`2026_10_13_140000_extend_delivery_assignments.php` adds accepted vehicle references, allocated vehicle count and acknowledgement time to the existing assignment table. It also permits the attributed acknowledgement event and backfills recorded dispatch vehicles for existing assignments. It preserves commercial snapshots, fees, proofs and history. Empty-schema tests and a down/up backfill test passed in the isolated test database. The additive migration was separately applied to the development `api` container and verified as **Ran, batch 39**.

Assignment mutations lock the organization and order, validate the current role/account and active same-store Fulfillment membership, check accepted vehicle availability and aggregate active allocations, and use idempotency keys. The new UI sends the current order version; explicit vehicle/dispatch requests require it. Identical assignments preserve their acknowledgement and timestamp. Changed assignments record reason/attribution/history and notify affected staff and the Buyer/store. Reassignment ends at Delivered/Picked up. Commercial changes still require the approved Buyer workflow; this module never changes the accepted arrangement or fee.

The standalone Fulfillment permission is exclusive to Fulfillment Staff. Staff list/read/acknowledge/milestone/thread/file access follows the current assignment. Owners/Managers keep Order Details oversight and exception controls. Fulfillment Staff have no Products or E-Invoices permissions/navigation. Store Profile appears in the sidebar for Vendor Owners and Store Managers, with existing role-specific profile permissions. Account status is refreshed after lock waits, evidence storage and route-provider calls, with current authorization checked before returning private directions or committing milestones.

Proof requires receiver name and a validated, scanned JPG/PNG image. Optional signature, notes and up to three additional images use the configured evidence limit and authorized order-scoped storage/downloads. Completion is transactional and idempotent; Buyer receipt confirmation remains a separate step. UI and notifications use the existing messaging, outbox and private invalidation infrastructure with authoritative REST reload, reconnect/resume and polling fallback. Only public staff display information is exposed to Buyers.

## API contract

New authorized operations:

| Method | Path | Scope |
| --- | --- | --- |
| GET | `/api/v1/vendor/fulfillment` | Current Fulfillment Staff assignments, paginated, with search/status/sort |
| GET | `/api/v1/vendor/orders/{orderId}/fulfillment/vehicles` | Owner/Manager, accepted vehicles and allocation availability |
| GET | `/api/v1/vendor/orders/{orderId}/fulfillment/route` | Owner/Manager or current assignee, with authorization checked after the provider call |
| POST | `/api/v1/vendor/orders/{orderId}/fulfillment/acknowledge` | Current Fulfillment Staff assignee, idempotent |

The existing assignment request adds `vehicle_index`, `lock_version` and `dispatch`. Assignment responses add the accepted vehicle, acknowledgement/end timestamps and authorized history. Proof responses add notes, responsible display name and extra photo paths. The existing milestone form accepts `additional_photos`; generated multipart clients send `additional_photos[]`. Existing statuses, payment/cancellation/dispute rules and receipt deadlines remain unchanged.

## Initial delivery workspace verification

Passed checks recorded in this task:

| Check | Result |
| --- | --- |
| Fulfillment feature suite, isolated PostgreSQL | 15 tests, 751 assertions passed, including account revocation during the route-provider call |
| Related order, concurrency, messaging, dispute and team suites | 17 tests, 532 assertions passed |
| Role permission unit test | 1 test, 15 assertions passed |
| Final focused assignment/proof/backfill replay | 3 tests, 124 assertions passed |
| Vendor workspace, assignment, messaging and route component tests | 26 passed |
| Buyer delivery JSON contract, 320/390 px layout and synchronization tests | 12 passed |
| Browser staff workspace, proof submission and all-role sidebar checks | 18 passed at 320, 390 and 1920 px, using API fixtures |
| Admin full component suite | 91 passed |
| PHP Pint / PHPStan | Passed / no errors |
| Vendor/Admin lint, typecheck and production builds | Passed; existing bundle-size warnings remain |
| Flutter analysis | No issues |
| OpenAPI validation / fulfillment contract | Passed / 30 operations checked |
| Generated TypeScript build and Dart serializers | Passed; Windows mapped-file locking was handled by generating serializers in an isolated temporary copy and publishing matching generated output atomically |
| Compose configuration | Passed |
| Focused secret scan / source whitespace | No leaks / passed |

The full Vendor run had **437 passed, 6 failed** in existing OrderPages document/date/NRPC expectations. The broader Buyer order run had **24 passed, 4 failed**: a missing review fake after receipt confirmation, older problem/cancellation-dialog expectations and an older money-breakdown label. These failures are retained and reported; this task did not rewrite those working flows to satisfy older tests. No Git commands, deployment, push, merge, credential rotation or destructive development database operation was performed.

## Delivery contact and responsive layout follow-up — 2026-10-13

This follow-up changes `DeliveryBuyerContact`, Vendor order read models/controller/routes, `FulfillmentPages`, `orders-api`, shared `CopyableText` and `DeliveryRouteMap`, OpenAPI, generated TS/Dart clients, contract checks and the fulfillment API tests. Existing phone/profile-photo columns and the immutable order destination are reused; no migration or new provider credential is required. Read-only contact/photo requests do not create commercial transitions or notification events. Existing acknowledgement, Buyer messaging, proof submission, audit/outbox and receipt behavior are retained.

- Isolated API contact/security plus assignment/proof regressions: **5 passed, 274 assertions**. Coverage includes Owner/Manager/current staff, unrelated role/store/assignee denial, reassignment/deactivation/closure revocation, private/no-store PNG, profile version, missing data, Self-Pickup exclusion and reauthorization after storage reads.
- Vendor lint, typecheck and production build: passed. The existing bundle-size warning remains. Admin typecheck passed for shared UI/client compatibility.
- PHPStan: no errors. Focused Pint check: 5 files passed. Compose configuration: passed.
- Scoped secret scan: no leaks in the 18 changed source/document files and 11 regenerated client artifacts. Added-line whitespace/conflict checks passed. The development API route export includes the new protected Buyer-photo endpoint.
- OpenAPI validation: passed with 8 existing unused-model recommendations. Fulfillment contract: **31 operations**, with generated TypeScript missing/null/populated contact round trips. Generated TS build and Dart serializer generation passed; the handwritten Dart contact round-trip check passed for all three cases.
- Changed Dart API/model/serializer analysis: no issues. Full generated Dart `lib` analysis reports one unchanged `unused_element_parameter` warning in `geo_demand_cell_value.dart:40`; this follow-up does not alter that model.
- UI/component/E2E tests and browser/device acceptance were not run for this follow-up. Manually verify the two sections at narrow phone/tablet/desktop widths, long names/addresses, photo/initials fallback, phone copy/failure feedback, alternate drop-off, route/map failure and the existing acknowledgement/messages/proof flow.

Suggested follow-up commit: `feat(fulfillment): add protected buyer contact and responsive delivery overview`.

## Manual provider/device acceptance

The browser tests use API fixtures; backend providers and scanners use fakes. Live Reverb across two accounts, actual Google route rendering/provider behavior, phone camera/gallery permissions, real private storage/scanning and live payment-provider behavior remain manual acceptance items. Route geometry decoding, map-provider failure/address fallback, authorization and server state rules were exercised. There is no live GPS tracking.

Existing configuration names are `VITE_GOOGLE_MAPS_BROWSER_KEY` (referrer-restricted browser key) and `GOOGLE_MAPS_SERVER_API_KEY` (server only). No new credential was introduced or requested. Continue using the existing Reverb/outbox/private-storage configuration.

For a live acceptance pass, use an Owner/Manager, one assigned Fulfillment Staff account and the order's Buyer in separate sessions. Confirm assignment/dispatch, verify notifications and assignment changes, inspect the route/confirmed endpoint, exchange an image message, test receiver/photo validation and camera/gallery replacement, submit delivery proof, inspect Buyer/Owner updates, and separately confirm receipt. Reassignment/deactivation must revoke former-staff order/thread/file access, and the accepted fee must remain identical throughout.

Suggested commit: `feat(fulfillment): add assigned delivery workspace`.
