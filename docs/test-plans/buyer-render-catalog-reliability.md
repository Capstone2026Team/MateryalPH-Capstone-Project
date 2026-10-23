# Buyer Render catalog reliability and query performance

Date: 2026-10-22

## Outcome

Render access logs at 05:34 Asia/Manila showed five `POST /api/v1/buyers/listings/search` requests ending as HTTP 499 after 2.85–3.07 seconds. The Buyer client inherited the generated client's three-second response budget. Its timeout message had been corrected previously, but the shared failure kind still selected the offline heading and artwork.

The Buyer application now uses a shared hosted API policy: 30 seconds to connect/send and 60 seconds to receive, preserving larger configured limits. Authentication, Item-Based procurement, Project procurement and the standalone public-store client install that policy. Explicit provider/photo limits remain scoped to those operations. Multipart scanning retains its 90-second send allowance and up to 270-second response allowance.

`DiscoveryFailureKind.timeout` separates slow responses from disconnected transport. Existing screen components therefore choose their error state instead of offline artwork. `isTransportFailure` covers both offline and timeout outcomes so payment, checkout, order actions, disputes, cart additions, message-upload reconciliation and directory-photo backoff preserve their existing safe retry behavior. There is no automatic replay of a mutation.

The API batches current delivery eligibility for the Vendor summaries returned by catalog, map and Project discovery. Catalog cards reuse that public projection instead of querying eligibility again for every listing. A fixture with six listings from three Vendors used nine dedicated eligibility queries before the change and one afterward. Eligibility is evaluated on every request; no stock, price, permission or delivery cache was added.

## Contract and security

- No migration, API request/response schema, generated client, role, commercial state, ranking formula or threshold changed.
- Buyer bearer authentication, session expiry, server authorization and private-file controls remain in place.
- Exact inventory, private staff contacts and provider credentials remain absent from the public projection.
- No new environment key or credential is required.
- The API source changes must be deployed before their query reduction affects Render. The rebuilt APK includes the Buyer timeout fixes and targets `https://materyalph-staging-api.onrender.com/api/v1`.
- The current API service uses Render Free. Its documented idle shutdown and wake-up delay remain a hosting constraint: https://render.com/docs/free#spinning-down-on-idle.

## Verification

- Focused Flutter selection: **35 passed**. Includes a real local HTTP server delaying responses beyond three seconds, Buyer bearer headers, timeout classification, safe payment retries, upload budgets, profile operations and supplier thumbnails.
- Catalog component regression verifies that a timeout offers Retry without the offline heading or artwork. Dispute retry coverage includes offline and timeout outcomes.
- `flutter analyze --no-pub`: **no issues**.
- `flutter build apk --debug --no-pub --dart-define-from-file=config/development.json --dart-define=APP_ENV=staging --dart-define=API_BASE_URL=https://materyalph-staging-api.onrender.com/api/v1`: **passed**.
- APK inspection verified the Render URL, shared transport policy and timeout-safe retry code are embedded.
- Focused isolated API performance regression: **1 passed, 45 assertions**. Before optimization, the same test failed at nine eligibility queries rather than one.
- Pint on the three affected PHP files: **passed**. Full PHPStan with `--memory-limit=512M`: **no errors**.
- OpenAPI validation: **passed**, with eight unused-schema recommendations. Procurement contract: **15 operations passed** using an isolated `route:list --json` export. Geography contract: **18 operations passed**.
- Dart formatting, `git diff --check`, Compose configuration and redacted secret scans: **passed**.

The wider mobile selection passed 94 tests and identified five existing failures. An isolated copy of unchanged HEAD reproduced all five:

1. Invoice copy request interaction.
2. Buy finalization/checkout interaction.
3. Per-store delivery-mode/invoice preview interaction.
4. Manual-review/blocked-route delivery display interaction.
5. Add-to-Cart retry interaction.

The first wide API run lost its isolated PostgreSQL connection during server recovery. After PostgreSQL recovered and the isolation guard passed again, the complete affected API selection finished with **54 passed, 9 failed, 1,521 assertions**. The nine failures are in `PhaseTenProjectsTest`; running that class against unchanged HEAD versions of both affected API classes reproduced exactly the same nine failures (**7 passed, 9 failed, 295 assertions**). Working source files were not replaced during the baseline comparison. Several failures are requests missing the currently required `payment_method`. This wider suite is not reported as green.

The complete API selection was:

```text
php artisan test --compact --no-ansi --filter='PhaseSevenItemProcurementTest|PhaseSixBuyerDiscoveryTest|VendorDeliveryEligibilityTest|ReadyMixedConcreteTest|PhaseTenProjectsTest'
```

It ran only in the guarded `materyalph_phase1_test` Compose project, using `api-test`, `postgres-test` and `redis-test`. The performance regression, current delivery revocation/restoration, catalog/discovery and concrete cases passed. No development or Render database was changed.

## Changed files

Buyer transport and client entry points:

- `apps/buyer-mobile/lib/core/buyer_transport.dart`
- `apps/buyer-mobile/lib/core/file_upload_transport.dart`
- `apps/buyer-mobile/lib/auth/auth_repository.dart`
- `apps/buyer-mobile/lib/features/item_procurement/procurement_repository.dart`
- `apps/buyer-mobile/lib/features/projects/projects_repository.dart`
- `apps/buyer-mobile/lib/screens/buyer_store_browse_screen.dart`

Timeout classification and existing retry callers:

- `apps/buyer-mobile/lib/core/api_guard.dart`
- `apps/buyer-mobile/lib/features/map_discovery/discovery_models.dart`
- `apps/buyer-mobile/lib/features/map_discovery/directory_photo_loader.dart`
- `apps/buyer-mobile/lib/features/item_procurement/checkout_preview_screen.dart`
- `apps/buyer-mobile/lib/features/item_procurement/product_details_screen.dart`
- `apps/buyer-mobile/lib/features/orders/nrpc_disclosure_screen.dart`
- `apps/buyer-mobile/lib/features/orders/orders_screen.dart`
- `apps/buyer-mobile/lib/features/orders/order_details_screen.dart`
- `apps/buyer-mobile/lib/features/orders/order_payment_screen.dart`
- `apps/buyer-mobile/lib/features/disputes/dispute_screens.dart`
- `apps/buyer-mobile/lib/features/messaging/messaging_screen.dart`

API optimization and regression:

- `services/api/app/Domain/Geography/PublicVendorProjection.php`
- `services/api/app/Domain/Procurement/MarketplaceSearchService.php`
- `services/api/tests/Feature/Api/PhaseSevenItemProcurementTest.php`

Buyer regression tests:

- `apps/buyer-mobile/test/api_guard_test.dart`
- `apps/buyer-mobile/test/buyer_transport_test.dart`
- `apps/buyer-mobile/test/project_transport_test.dart`
- `apps/buyer-mobile/test/item_procurement_test.dart`
- `apps/buyer-mobile/test/payments_test.dart`
- `apps/buyer-mobile/test/disputes_test.dart`

## Manual acceptance

Install the rebuilt `apps/buyer-mobile/build/app/outputs/flutter-apk/app-debug.apk`, reopen Product Catalog and Find Vendors, and verify normal search, sorting and pagination against Render. Check a genuinely disconnected device separately from a slow server response. Phone and live-provider acceptance remain manual. No backend deployment or paid provisioning was performed as part of this change.

Suggested commit: `fix(buyer): unify hosted request timeouts and batch catalog eligibility`
