# Buyer Favorite Directory Suppliers and supplier preview layout — 2026-10-25

Owner request: separate **Favorite Suppliers only** from **Show Verified Vendors**, let both Tier 1 Directory Suppliers and Tier 2 Verified Vendors be saved as Favorites, and clean up the selected-supplier preview for both tiers without changing the visual language.

## Behavior

- **Saving.** `PUT /buyers/favorite-suppliers/{id}` accepts an active Verified Vendor id or a currently listed Directory Supplier result id. A Directory Favorite is stored in `favorite_directory_suppliers` as `(buyer_profile_id, google_place_id)` only — Google Place IDs may be kept indefinitely; name, address and rating are never copied. An expired Directory result returns `404 DIRECTORY_SUPPLIER_NOT_FOUND`; the old `422 FAVORITE_REQUIRES_VERIFIED_VENDOR` no longer occurs.
- **Survives the cache.** After the bounded Directory cache is pruned, a re-cached place (new result id) is still `is_favorite: true`. Profile › Favorite Suppliers lists an uncached Directory Favorite as `Saved Directory Supplier` with `currently_discoverable: false` and a removable id.
- **Removing.** `DELETE` accepts a Verified Vendor id, a Directory result id (even expired) or the id returned by the favorites list.
- **Filter.** `favorites_only` limits both tiers to saved suppliers and no longer hides Directory Suppliers; only `supplier_type` and `category_id` set Directory status `FILTERED_OUT`. The Directory minimum Google rating still applies under Favorites.
- **Still informational.** A Directory Favorite has no storefront, message, quotation, order, MateryalPH review or VPS and never enters SRS, FMS or Project candidates. The Favorites tab rating sort uses VPS only; Directory Favorites follow by distance.
- **Filter sheet.** Favorite Suppliers only is its own first section (bookmark icon, "Your saved Verified Vendors and Directory Suppliers"), above the Verified and Directory sections.
- **Preview layout.** Shared structure for both tiers: header (image, name, Favorite, Close) → full-width tier/score badges (long `New Vendor — Building Track Record` no longer truncates) → aligned status lines (open status dot, route) → one filled primary action plus secondary icon action → labelled flat cards (`Categories`, `Store details` with Fulfillment/Address; or `Opening hours` table with today emphasized, `Contact`) → footnotes and Google attribution. The Directory Google rating moved into the header badges.
- **Map.** Favorite gold ring and star now also render on Directory pins; legend text updated.

## Files

- Migration `services/api/database/migrations/2026_10_30_000000_create_favorite_directory_suppliers.php`.
- API: `FavoriteSupplierService`, `SupplierDiscoveryService`, `DirectorySupplierService`; OpenAPI `FavoriteSupplier.tier`, endpoint and `favorites_only` descriptions; regenerated TS/Dart clients.
- Buyer: `discovery_models.dart`, `discovery_repository.dart`, `discovery_controller.dart`, `supplier_browsing.dart`, `supplier_panels.dart`, `supplier_map.dart`, `map_home_screen.dart`, `buyer_places_screens.dart`, `design_system/components/discovery_controls.dart`.
- Docs: Buyer workflow Favorites sections, UI/UX planner §marker table, filter bar, §9.6.

## Verification

- `php artisan test tests/Feature/Api/PhaseSixBuyerDiscoveryTest.php` — 22 passed (new `test_directory_suppliers_are_saved_as_favorites_by_place_id_and_survive_cache_expiry`).
- `PhaseSevenItemProcurementTest.php` + `WorkPackageSourcingTest.php` — 25 passed.
- Pint and PHPStan on the changed API files — clean. `npm run validate`, `npm run test:geography-contract` — passed.
- `flutter analyze` — no issues. Focused Flutter files (map discovery, filters, rating transport, supplier photo, cache, freshness, marker golden, item procurement) — 85 passed.
- Tier 1/Tier 2 previews were rendered at 390 px and visually reviewed (temporary capture test, removed).

Hot reload is not enough after pulling: run the new migration (`php artisan migrate`) on the dev database before saving a Directory Favorite.
