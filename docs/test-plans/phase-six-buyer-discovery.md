# Phase 6 test plan: Buyer onboarding, locations, maps and supplier directory

**Surfaces:** API (`services/api`, `packages/api-contract`) and Buyer (`apps/buyer-mobile`). Vendor and Admin were not changed.

## Owner decisions recorded (2026-09-28)

- **PSGC master:** one versioned importer with two sources, the PSA CSV and a psgc.cloud snapshot. Every import lands as DRAFT, and an operator activates it explicitly. See `docs/architecture/psgc-import.md`.
- **Map filters:** tier toggles, Favorites only, Supplier Type and Material Category. There is no Open Now, rating or review-count filter.
- **Industry classification:** a controlled list plus Other with a description. Recorded in the Buyer workflow.

## Acceptance coverage

| Requirement | Evidence |
| --- | --- |
| Renamed store is consistent across map, list, preview, Store Profile and Favorites | API `test_a_renamed_store_stays_consistent_across_map_list_preview_store_profile_and_favorites` |
| Private fields are excluded (legal and registered names, store email, ID values, TIN keys, Buyer origin coordinates) | API `test_public_discovery_payloads_exclude_private_vendor_fields_and_buyer_coordinates`; contract check on public schemas |
| An active store with no eligible offerings is excluded, even when its stored DISCOVERABLE flag is stale | API `test_active_stores_without_eligible_offerings_are_excluded_even_with_a_stale_discoverable_flag` |
| Stale eligibility and cache are revalidated; expired directory cache is never served | API `test_stale_eligibility_is_revalidated_immediately_and_expired_directory_cache_is_never_served`; Flutter stale search and route rejection tests |
| Schedule-only changes leave membership, order, counts and expansion unchanged | API `test_schedule_only_changes_leave_discovery_membership_order_and_expansion_unchanged` |
| Radius edges: `ST_DWithin` on geography in metres, exact boundary included at four bearings, 5 cm and 1 m outside excluded, no route call used for membership | API `test_radius_membership_uses_geodesic_st_dwithin_with_an_inclusive_boundary_and_rejects_unsupported_radii` |
| Unsupported radius is rejected on the backend (`RADIUS_UNSUPPORTED`) | Same API test, plus the saved radius preference |
| Expansion is offered and never applied; 50 km is the maximum | API expansion test; Flutter controller and Map Home dialog tests |
| GPS denied: manual address and pin remain complete alternatives | Flutter `denied GPS keeps manual address and pin paths complete`; API pin resolution with the provider down plus a manual description |
| Unresolved PSGC is saved as UNRESOLVED; the resolver uses the active version only; import, activation and immutability | API saved-location and PSGC tests |
| Provider timeout: Tier 2 still returned; Tier 1 served as CACHED or UNAVAILABLE; details and route return 503 with the straight-line distance | API timeout and route tests; adapter tests (`tests/Unit/GeographyProviderAdapterTest.php`) |
| Cache expiry: expired cells are re-queried, expired records are never served, and the prune command runs | API stale and cache test |
| Tier 1 restrictions: no VPS, favorite, storefront, message or order; Google rating is attributed; actions are only Call, Open in Maps, Website and Share | API Tier 1 test; contract check; Flutter Tier 1 widget test |
| MAT-01: a Vendor scope rejects a competitor or arbitrary origin; Admin uses a PSGC scope with no 50 km ceiling | API `test_mat01_scope_resolution_rejects_competitor_origins_for_vendors_and_validates_admin_psgc` |
| Ownership, optimistic versions, primary rule, idempotent save and address versioning | API location versions test |
| Minimum field masks, daily budgets, closed-business filtering, https-only links | Adapter tests |
| Route requested once per selection; origin and request versions guard stale routes; store address change invalidates the cached route | API route test; Flutter controller route test |
| Same data and order on map and list, non-color marker semantics, Reduce Motion, 320 px, landscape and 2x text | `test/map_discovery_test.dart`; evidence in `docs/design/evidence/phase-6/` |
| Radius-aware 10 km grid squares with overlapping search circles, shared inner-cell keys, bounded concurrency and exact-radius membership; upstream results are not a census | Adapter `test_directory_search_cells_cover_the_whole_radius_not_only_its_centre` and the Places request test |
| First entry is a separate full-screen location page; leaving it shows a prompt that reopens it; a current location shows its street address in the header | Flutter `denied GPS keeps manual address and pin paths complete`, `current location from the location page shows its street address`, `leaving the location page shows a prompt that reopens it` |
| Drop Pin has no latitude or longitude fields and no coordinates in the confirmation | Flutter `denied GPS keeps manual address and pin paths complete` |
| Selecting a supplier isolates its pin until the preview closes; the list keeps every result | Flutter `selecting a supplier isolates its pin until the selection closes` and the isolation unit test |
| Basemap switches between Map and Satellite; the legend stays reachable | Flutter `the layers control switches between Map and Satellite` |
| Tier 2 sheet has Favorite bookmark, View Storefront and the existing Message action; Tier 1 has Overview, Google Reviews and About with no marketplace Favorite, message or VPS | Flutter Tier 1 and Tier 2 selection tests |

## Commands

```bash
docker exec materyalph_phase1_test-api-test-1 php artisan test
cd packages/api-contract && npm run validate && npm run test:geography-contract -- <route-export.json>
cd apps/buyer-mobile && flutter analyze && flutter test
```

## Known pre-existing failures (unchanged, verified against HEAD in a detached worktree)

- Buyer: 12 tests in `buyer_app_test.dart` (onboarding reflow, Welcome, registration) and `ui_capture_test.dart` goldens. They fail identically at HEAD.
- Admin: `PortalShell.test.tsx` collapsed-tooltip test.

## Not covered by automated tests

- Real Google Maps SDK rendering, marker bitmaps and camera motion on a device. They need the native client keys. This includes Drop Pin drag handling, which relies on the SDK receiving gestures first.
- A live Places or Routes response. Adapters are tested only against faked HTTP.


## Buyer map enhancement (2026-09-29)

- A confirmed location is saved with the existing resolution token / Buyer location API and becomes the marketplace primary location. Selecting an existing saved location reuses it and makes it primary; identical coordinates do not add another saved row. Map tab visits preserve the shared controller; fresh app entry restores the primary (or another valid saved location). GPS is optional and requires explicit action.
- Search uses a debounced Google Places autocomplete request through `POST /api/v1/buyers/locations/autocomplete`. `PLACE` mode on the existing resolve endpoint uses the same session token to resolve the Place ID. Suggestions, search selection, map pan/tap and reverse geocoding share one selected preview. Stale responses cannot replace newer selections; save uses one idempotency key through retries.
- Google Place Details now include optional open status/closing time, up to four photos, up to five attributed Google review excerpts, provider attributions and returned boolean service/accessibility/payment attributes. No rating distribution or unsupported service is inferred. Details and media resource names are not written to the provider cache; responses use `Cache-Control: no-store`. Photos have a neutral unavailable state, attribution and source links. Existing search-result caching is unchanged and remains subject to the project's Google agreement.
- Grid generation covers every intersecting square for 5/10/20/30/40/50 km. The default cap is 121 cells; a lower configured cap enlarges cells instead of omitting the outer area. Cells are queried in batches of 16; successful batches survive a later failure. Existing Place ID deduplication, sanitation, claimed-Vendor suppression, exact PostGIS radius membership and daily provider budget remain authoritative.
- The Buyer progressively fetches the existing paginated supplier results so outer suppliers beyond the first 100 can appear on both map and list. Longer receive timeouts apply only to provider-backed discovery/details/location resolution. Counts remain server result counts; no count is hard-coded.

### Runtime setup and live checks

No new key, migration or location-storage table is required. Existing `GOOGLE_MAPS_SERVER_API_KEY`, enabled Places API (New), native Maps keys and `MAPS_CLIENT_CONFIGURED` are reused. For a deployment explicitly setting the older `GOOGLE_PLACES_MAX_SEARCH_CELLS=7`, raise the non-secret cell cap to `121` to use the denser large-radius grid; the configured daily call budget is unchanged. This task does not edit ignored environment files. Expanded grids and optional Places details can increase billable calls; the provider budget still fails closed.

Live-device acceptance remains necessary: search and drag a pin; verify the camera and address agree; choose/relaunch and verify restoration; select each radius through 50 km; inspect outer-area suppliers; open a real Google business with photos/reviews and inspect attribution; verify missing-photo and quota responses; select a Tier 2 Vendor and inspect route/card camera padding. Synthetic captures in `docs/design/evidence/phase-6/` prove layout only. The existing Tier 2 Message callback still goes through the app's existing Messages availability flow; this change does not implement a new messaging domain.

Provider references: [Autocomplete](https://developers.google.com/maps/documentation/places/web-service/place-autocomplete), [Nearby Search limits](https://developers.google.com/maps/documentation/places/web-service/nearby-search), [Places policies and attribution](https://developers.google.com/maps/documentation/places/web-service/policies), [Place Photos](https://developers.google.com/maps/documentation/places/web-service/place-photos).

### Validation from this enhancement run

- Isolated API: `php artisan test --compact --no-ansi --filter='GeographyProviderAdapterTest|PhaseSixBuyerDiscoveryTest|PhaseSevenItemProcurementTest'` — **40 passed, 1,609 assertions**.
- Buyer: `flutter analyze` — **no issues**. Full `flutter test --reporter expanded` — **122 passed, 12 failed**. All map/location/procurement and Phase 6 captures passed. The 12 failures are in the existing onboarding/authentication tests (`buyer_app_test.dart`, 10) and missing account-screen goldens (`ui_capture_test.dart`, 2), consistent with the pre-existing failure list above; this run did not modify those flows.
- Phase 6 synthetic visual captures — **13 passed**, including the new location details and Google Reviews states. Visually reviewed the map summary, Tier 2 preview, location details, and Tier 1 reviews captures.
- PHPStan — **no errors**. OpenAPI validation — **valid**, with three existing unused-model recommendations. Geography contract — **17 operations match Laravel routes and guards**. Generated TypeScript/Dart clients and Dart serializers rebuilt.
- Gitleaks directory scan of changed source/contract/test files — **no leaks**. No migrations or ignored environment files changed. No deployment or live Google requests were performed.


## Supplier photos and location controls follow-up (2026-09-29)

- Removed the separate **Enter address** chip and its manual-address sheet from Select Location. Google **Search location**, saved locations, current location and map pin selection continue to share the existing location flow.
- Tier 1 list rows request a single 160 px Google business photo through `GET /api/v1/buyers/discovery/directory-suppliers/{supplierId}/photo`. The endpoint reuses Buyer-only bearer authorization, the existing Places rate limit and daily provider budget, and the existing unexpired/unclaimed supplier visibility check. No full reviews/details request is made for a thumbnail. Responses are `no-store`; photo resource names, URLs and images are not persisted. Google, author and provider attribution and available source links stay beside the image.
- Tier 2 rows and previews use the existing public store `logo_url`, fitting the full logo without cropping. No Google photo lookup is made for a Verified Vendor. Both tiers retain neutral fallbacks for absent or failed images.
- Thumbnail rows debounce fast scrolling, do not prefetch an offscreen scroll cache, cancel queued work when removed, retain one request across rebuilds and evict transient Google images on disposal. The shared loader limits concurrency to two and starts to 15 per minute, leaving capacity in the existing 20/minute Places limit for user actions. Provider/offline/rate-limit failures suspend further thumbnail requests for a minute rather than retrying automatically. Large lists can therefore show fallback icons while later visible photos wait for capacity.
- Both native maps share the existing Philippine service rectangle (4–21.5 latitude, 116–127 longitude) and zoom range 7–21. The existing radius fitting, selected route, recenter and layers remain intact. This prevents the world-scale view in the report and constrains the camera to the service area. **It does not erase foreign geography from Google's basemap**: adjacent coastline may remain visible near an edge. The bounds are service bounds, not a country-border mask. See [Google's camera bounds behavior](https://developers.google.com/maps/documentation/android-sdk/views#restricting_the_users_panning_to_a_given_area).

### Follow-up validation

- Focused Flutter map/location/photo regressions: **44 passed**. Full Buyer suite: **128 passed, 12 failed**, with the same existing auth/onboarding failures (10) and missing account capture goldens (2) documented above.
- Isolated geography/provider/procurement API regressions: **43 passed, 1,643 assertions**. Thumbnail coverage includes lazy minimal-field requests, one small photo, attribution, no photo/media failure, authorization, expired/claimed supplier rejection, no detail-cache writes and provider failure.
- OpenAPI validation: valid with three existing unused-model recommendations. Geography contract: **18 operations** match routes and Buyer guards. TypeScript/Dart clients and Dart serializers regenerated. No schema migration, new key or environment change.
- Live device acceptance: relaunch the Buyer app against the updated API; verify Search location is the only address-entry action; expand the list and inspect a real Google business photo and attribution; inspect a Verified Vendor with a saved store logo; scroll a long list/offline and confirm neutral fallbacks; zoom/pan both maps to the limits and verify 50 km radius fitting and selected routes. Automated captures use a synthetic map and do not prove Google SDK rendering or live image delivery.

- Final static/visual checks: `flutter analyze` reported no issues; scoped Pint passed; PHPStan reported no errors; all **13 Phase 6 captures passed** after the final header adjustment. The location and Tier 2 captures were visually reviewed. Scoped Gitleaks found no leaks and the changed-file whitespace check passed.
