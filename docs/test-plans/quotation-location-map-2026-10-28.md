# Quotation Buyer location map picker — 28 October 2026

## Delivered

Prepare quotation now offers **Current location** and **Alternate Buyer Location** instead of inline address search. Current location selects the address the Buyer already shared. The alternate choice opens a separate dialog with search, map click/drag pin selection, the resolved address, **Use this location**, and **Cancel**. Only confirmation applies the new destination; cancelled or stale lookups cannot replace the quotation's address.

The same dialog handles a heavy-vehicle alternative drop-off. Reopening an existing proposed address restores its saved pin through conversation-scoped lookup. Selecting a different endpoint clears the old access confirmations and refreshes the existing delivery fee recommendation. Existing role, Work Package, coverage, 50-km, capacity, publication and Buyer-approval rules remain enforced.

## Files and contract

- `packages/web-ui/src/quotation-destination-fields.tsx`: compact selection buttons and shared picker integration.
- `packages/web-ui/src/quotation-location-dialog.tsx`: search/pin review, confirmation, cancellation and stale-response protection.
- `packages/web-ui/src/location-pin-map.tsx`: reusable map implementation extracted from the Vendor business address selector.
- `apps/vendor-web/src/components/VendorAddressMapSelector.tsx`: retains business address behavior through the shared map.
- Vendor quotation editor, messaging API adapter, component tests and `e2e/quotation-delivery.spec.ts`.
- API `QuotationDestination`, `ConversationController` and messaging feature tests.
- OpenAPI, regenerated TypeScript/Dart clients, messaging contract checks, and `scripts/check-quotation-location.dart`.
- UI/UX planner addendum.

No migration or new endpoint. The existing quotation location operation accepts exactly one of address `query`, map `latitude` + `longitude`, or a previously proposed `address_id`. Resolved responses include coordinates for the editable Vendor-proposed pin. This never requests the Buyer's device GPS or lists their address book; saved points must belong to this same authorized conversation.

## Verification

- Messaging API suite: **50 passed / 1,296 assertions**, including forward search, pin resolution, saved-pin lookup, unauthorized/cross-conversation access, mixed/invalid inputs, provider failures and quotation acceptance.
- Vendor full suite: **687 passed**. Focused map, location dialog, business address and quotation editor checks: **24 passed**.
- Admin full suite: **236 passed**.
- Vendor/Admin lint, typecheck and production builds passed. Existing unused-variable and bundle-size warnings remain.
- Chromium quotation flow passed at **320, 390 and 1440 px**. Scenarios cover search, cancellation without changing the quotation, map pin confirmation, access reconfirmation, calculated/manual fees and totals. Desktop and phone popup screenshots were visually reviewed; no popup horizontal overflow was detected. The browser tests use a clearly labelled TEST map and mocked API responses.
- OpenAPI validation and **42-operation** messaging contract passed. Generated TypeScript build and Dart serializer rebuild passed. Dart location codec passed for all three lookup modes and resolved coordinates.
- Pint and PHPStan passed. Diff whitespace and staged/diff/new-file Gitleaks scans passed (the staged scan had no staged changes).

The initial checks caught an unsupported validation-rule string and a map-wrapper environment initialization issue. Both were corrected; the complete API and Vendor suites above passed afterward.

## Commands and manual acceptance

```text
# services/api, inside the existing isolated test Compose project
php artisan test --compact tests/Feature/Api/PhaseNineMessagingTest.php
php vendor/bin/pint --test
php vendor/bin/phpstan analyse --memory-limit=512M

# apps/vendor-web
npm.cmd run lint
npm.cmd run typecheck
npm.cmd run test -- --run
npm.cmd run build
npm.cmd run test:e2e -- e2e/quotation-delivery.spec.ts --project=chromium-320 --project=chromium-390 --project=chromium-1440 --reporter=line

# packages/api-contract
npm.cmd run validate
npm.cmd run test:messaging-contract
dart run scripts/check-quotation-location.dart
```

Uses the existing public, referrer-restricted `VITE_GOOGLE_MAPS_BROWSER_KEY` and backend `GOOGLE_MAPS_SERVER_API_KEY`. No credentials were added or changed. Actual Google map/geocoding and physical-device acceptance remain manual. Buyer UI was not changed; generated Dart request/response behavior was checked through serializer generation and the codec test. No deployment, push, merge or development-database migration was performed.

Suggested commit: `fix(quotations): add buyer location map picker`.
