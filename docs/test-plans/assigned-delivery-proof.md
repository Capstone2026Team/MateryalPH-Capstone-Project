# Assigned delivery proof workflow — 2026-10-13

Site Delivery assignment is part of the Out for Delivery phase. The Owner or Store Manager clicks **Out for Delivery**, chooses active Fulfillment Staff and an available accepted vehicle, and clicks **Done**. The existing versioned, idempotent assignment request saves assignment and dispatch in one transaction. With multiple staff accounts, an explicit selection is required. Reassignment stays inside that phase and preserves accepted arrangements, fees and history. An older order already Out for Delivery without staff can gain its assignment inside the same phase without recording dispatch again.

Only the current active assigned Fulfillment Staff may record **Delivered**. Their existing workspace retains photo upload/capture, required receiver name, optional signature, notes and additional photos. Vendor oversight displays assignment information and submitted proof instead of delivery proof controls. Self-Pickup handover and optional staff assignment remain supported.

## Changed files and contract

- Vendor: `OrderFulfillmentPanels.tsx`, `OrderPages.tsx`, `FulfillmentPages.tsx` and their component tests. The shared `packages/web-ui/src/fulfillment-patterns.tsx` supports phase content and audience-specific proof instructions, with existing defaults retained.
- Backend: `FulfillmentService.php`, `FulfillmentView.php`, `OrderQueries.php` and `PhaseTwelveFulfillmentTest.php`.
- Buyer: `test/fulfillment_badges_test.dart` adds assignment-to-proof synchronization coverage; existing production refresh logic is retained.
- Contract: `openapi.yaml`, `add-fulfillment-contract.mjs` and `check-fulfillment-contract.mjs`. Standard generation updates five VendorFulfillment API comment/documentation/test-scaffold files across TypeScript and Dart; models and serializers are unchanged.
- System, Vendor and Buyer workflows and the UI/UX planner reflect staff-only Delivered and assignment within Out for Delivery.

No migration, new endpoint, request/response field, dependency, key or manual schema change is required.

## Authorization and synchronization

Owner/Manager Delivered requests return `403 PERMISSION_DENIED` before proof storage. After scanning, the service refreshes membership and rechecks current order assignment under the existing transaction locks. Reassignment during scanning rejects the former staff member and discards staged private files. Evidence validation, fail-closed scanning, receiver-name encryption, private file access, idempotency, accepted vehicle allocation and Buyer receipt confirmation remain in force.

Existing private navigation/notification invalidations trigger authorized REST reloads across the assigned staff list/details, Vendor Order Details and Buyer orders. Polling, reconnect and session cleanup remain. Read generations and order-version guards prevent older background or overlapping mutation responses from undoing saved assignments or delivery proof. Direct staff order links route to their assigned Fulfillment workspace; Owner/Manager links retain Order Details.

## Verification

- Related isolated API suites: **22 passed, 893 assertions**, including pickup, atomic assignment/dispatch, vehicle capacity, staff-only proof, replay cleanup, notification/view synchronization and reassignment during scanning.
- New API regressions separately: **2 passed, 92 assertions**.
- Full PHPStan: **no errors**. Changed-file Pint: **4 files passed**. Docker Compose configuration: **passed**.
- Vendor lint, typecheck and production build: **passed**. Build retains the existing large-chunk advisory.
- Focused Vendor workflow checks: **25 passed** (15 fulfillment-panel, 7 staff-workspace and 3 order integration/routing tests; 39 unrelated order tests skipped in the order-focused run). After adding the version guard for shared pending REST reads, the affected synchronization/routing selection passed **6 tests**, with 43 unrelated tests skipped.
- Related Vendor component run: **55 passed, 6 failed** across three files. All six original OrderPages failures reproduced against its pre-change implementation: four obsolete Order documents link assertions, a Customer Service confirmation fixture and an NRPC validation assertion. Temporary baseline files were removed.
- OpenAPI validation: **passed**, with eight existing unused-model recommendations. Fulfillment contract: **30 operations passed**. Generated TypeScript build and focused generated Dart VendorFulfillment API analysis: **passed**.
- Buyer three-file run: **17 passed, 3 failed**. Failures are in unchanged `order_fulfillment_test.dart`: the receipt-confirmation review fake returns null, and Send report/Cancel order are outside the test viewport. The new assignment-to-Delivered/proof refresh regression passed.
- Full Buyer `flutter analyze`: **no issues found**.
- Final clean Buyer synchronization run: **15 passed** (8 fulfillment-badge and 7 navigation-count tests, run with concurrency 1). An earlier retry exhausted compiler memory before tests started; the clean retry passed after the concurrent builds finished.
- Scoped secret scan: **no leaks**. Authored code/test whitespace and conflict-marker review: **passed**. No Git commands were used.

These isolated tests do not establish the development database migration state or live Reverb/browser/device delivery. No development DB, environment or credential changes were performed.

## Manual acceptance

1. With at least two active Fulfillment Staff accounts, click Out for Delivery. Verify no separate delivery-assignment section, explicit staff choice, accepted available vehicle selection, and Done saving dispatch once.
2. Keep the selected staff portal open. The delivery should appear automatically with its assigned vehicle and instructions. A different staff account must not access it.
3. In the staff portal, reject completion without the photo or receiver name; then capture/upload a photo, enter the receiver name and optionally add a signature. Submit Delivered.
4. Keep Vendor and Buyer Order Details open. Verify Delivered and private proof refresh automatically, and receipt confirmation remains a separate Buyer action. The Vendor must have no manual Delivered proof action, including a forged API request.
5. Verify reassignment before Delivered, reconnect/foreground recovery, account switching, accepted extra trips and an ordinary Self-Pickup handover.

Suggested commit: `fix(fulfillment): require assigned staff for delivery completion`.
