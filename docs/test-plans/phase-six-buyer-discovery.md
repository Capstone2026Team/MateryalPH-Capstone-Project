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
| Directory search cells cover the whole radius (centre plus six-cell ring at every allowed radius), results ranked by prominence per cell | Adapter `test_directory_search_cells_cover_the_whole_radius_not_only_its_centre` and the Places request test |
| First entry is a separate full-screen location page; leaving it shows a prompt that reopens it; a current location shows its street address in the header | Flutter `denied GPS keeps manual address and pin paths complete`, `current location from the location page shows its street address`, `leaving the location page shows a prompt that reopens it` |
| Drop Pin has no latitude or longitude fields and no coordinates in the confirmation | Flutter `denied GPS keeps manual address and pin paths complete` |
| Selecting a supplier isolates its pin until the preview closes; the list keeps every result | Flutter `selecting a supplier isolates its pin until the selection closes` and the isolation unit test |
| Basemap switches between Map and Satellite; the legend stays reachable | Flutter `the layers control switches between Map and Satellite` |
| Tier 2 sheet has Favorite bookmark, View Store and Message; Tier 1 sheet has Overview and About only, with no Favorite, review tab, message or VPS | Flutter Tier 1 and Tier 2 selection tests |

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
