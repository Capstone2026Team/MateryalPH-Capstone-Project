# Vendor address and map

The Google map container is now persistent and has explicit height. React no longer removes its loading text from the Google-owned DOM. The loader uses an API callback, a 15-second timeout, authorization failure feedback and retry. Vite reads only VITE_GOOGLE_MAPS_BROWSER_KEY; backend Google requests use GOOGLE_MAPS_SERVER_API_KEY.

PSGC Cloud v2 is accessed only by the Laravel PsgcProvider adapter, with six-hour server caching and bounded, paginated application responses. No PSA file import is required. API documentation: https://psgc.cloud/api-docs/v2 . Provider parent display names are not trusted: live inspection returned Sarangani for Quezon City. Codes determine province/region grouping; barangays come from the selected city endpoint. Missing or ambiguous reverse-geocoding matches require explicit selection.

Address changes invalidate the previous location. Map clicks and marker dragging reverse-geocode and prefill matching PSGC selections plus detailed address. Resolve returns an encrypted, organization-bound, 30-minute token. Draft persistence rejects raw client coordinates, modified address/token pairs and cross-organization tokens. Geocoding runs outside database transactions. Existing stored addresses are retained when address is omitted. The explicit Manual Address Entry path requires current PSGC selections and complete structured fields, but no Google request or resolution token; it stores source MANUAL with null latitude, longitude and geography. Map-mode edits still require a fresh bound resolution token. Manual submission never fabricates a verified geospatial location. Critical changes retain the existing address version and review/audit flow.

## Required local setup

Apply the additive migration in the normal API environment:

    php artisan migrate

Restart Vite after changing its browser environment; rebuild deployed frontend bundles. Enable Maps JavaScript API for the browser key and Geocoding API for the backend key with appropriate restrictions. No new credentials are required for PSGC Cloud.

## Validation commands

    cd services/api
    php vendor/bin/pint --test
    php vendor/bin/phpstan analyse --memory-limit=512M --no-progress
    php vendor/bin/phpunit tests/Unit/VendorAddressResolverTest.php

In the isolated test container:

    docker exec materyalph_phase1_test-api-test-1 php artisan test --no-ansi

Generated Dart serializer completion (the local sandbox denied Dart analytics-directory access):

    cd packages/api-contract/generated/dart
    dart run build_runner build --delete-conflicting-outputs
    dart analyze

Provider fakes and map constructor stubs do not prove live Google billing, restrictions or geocoder connectivity. PSGC Cloud v2 was queried live; its reference data quality/version is controlled by that provider.


## Phase 3C completion — September 24, 2026

V2 now places structured fields beside the map at desktop widths, stacking fields above the map below 1024 px. Latitude and longitude have read-only fields. Failed geocoding offers retry and an explicit switch to manual entry, retaining structured selections. Manual fields validate a 2–200-character street and a four-digit postal code. PSGC suggestions and ancestry validation remain server-owned; a total PSGC reference-provider outage still requires retry (or cached reference data), rather than accepting fabricated codes.

Address lookup POSTs are explicitly declared read-only in the shared web transport. They may overlap so the newest pin can resolve while an older response is pending. Sequence guards reject stale pin and forward-resolution replies; all write endpoints retain duplicate-request protection, CSRF and authorization.

The Phase 3C browser fixtures use synthetic map/provider responses and do not establish live Google connectivity. See `docs/test-plans/phase-3c-acceptance.md` at the repository root for the current acceptance evidence.
