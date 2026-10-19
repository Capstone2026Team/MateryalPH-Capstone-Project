# Vendor address and map

The Google map container is now persistent and has explicit height. React no longer removes its loading text from the Google-owned DOM. The loader uses an API callback, a 15-second timeout, authorization failure feedback and retry. Vite reads only VITE_GOOGLE_MAPS_BROWSER_KEY; backend Google requests use GOOGLE_MAPS_SERVER_API_KEY.

PSGC Cloud v2 is accessed only by the Laravel PsgcProvider adapter, with six-hour server caching and bounded, paginated application responses. No PSA file import is required. API documentation: https://psgc.cloud/api-docs/v2 . Provider parent display names are not trusted: live inspection returned Sarangani for Quezon City. Codes determine province/region grouping; barangays come from the matched city endpoint. Missing, ambiguous or unavailable reference matches remain unresolved and do not block address entry. Names stay editable; the Vendor never selects PSGC codes.

The address step offers Use Google Maps and Enter address manually. Map clicks and marker dragging fill editable address details. Pin selection returns an encrypted, organization-bound pin token; completed address names plus that token return a 30-minute resolution token. Missing fields can be typed before resolution. Draft persistence rejects raw client coordinates, modified address/token pairs and cross-organization tokens. Geocoding and optional reference matching run outside database transactions. Existing stored addresses are retained when address is omitted. Manual entry requires street, barangay, city/municipality, province/Metro Manila and a four-digit postal code, with optional unit/building; it requires no Google request or token and stores null latitude, longitude and geography. Best-effort reference matching never fabricates codes. All supplied legacy codes still undergo hierarchy validation. Critical changes retain the existing address version and review/audit flow.

## Required local setup

The October 19, 2026 address-entry update requires no new migration; existing geographic reference columns are nullable.

Restart Vite after changing its browser environment; rebuild deployed frontend bundles. Enable Maps JavaScript API for the browser key and Geocoding API for the backend key with appropriate restrictions. No new credentials are required for PSGC Cloud.

## Validation commands

    cd services/api
    php vendor/bin/pint --test
    php vendor/bin/phpstan analyse --memory-limit=512M --no-progress
    php vendor/bin/phpunit tests/Unit/VendorAddressResolverTest.php

In the isolated test container:

    docker exec materyalph_phase1_test-api-test-1 php artisan test --no-ansi

Generated Dart serializer completion:

    cd packages/api-contract/generated/dart
    dart run build_runner build --delete-conflicting-outputs
    dart analyze

Provider fakes and map constructor stubs do not prove live Google billing, restrictions or geocoder connectivity. PSGC Cloud reference data quality/version is controlled by that provider.


## Address-entry behavior — October 19, 2026

Google mode places address details below the map; manual mode shows only address details. Raw latitude and longitude are hidden. Failed geocoding offers retry and an explicit switch to manual entry, retaining typed details. Manual fields validate a 2–200-character street and a four-digit postal code. Geographic matching remains server-owned and optional when the directory is unavailable. Resolved coordinates remain bound to the reviewed address, while manual addresses have no asserted map location.

Address lookup POSTs are explicitly declared read-only in the shared web transport. They may overlap so the newest pin can resolve while an older response is pending. Sequence guards reject stale pin and forward-resolution replies; all write endpoints retain duplicate-request protection, CSRF and authorization.

The Phase 3C browser fixtures use synthetic map/provider responses and do not establish live Google connectivity. See `docs/test-plans/phase-3c-acceptance.md` at the repository root for the current acceptance evidence.
