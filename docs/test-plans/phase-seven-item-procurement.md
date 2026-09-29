# Phase 7 — Item-Based Discovery, Ranking, Favorites, Cart and Checkout Preview

Surfaces: API (`services/api`, `packages/api-contract`) and Buyer (`apps/buyer-mobile`). Vendor and Admin unchanged (typecheck re-run because the shared contract moved).

## Decisions

| Decision | Source |
| --- | --- |
| Not Yet Comparable listing → SRS Price neutral 50; sole mapped offer → 100 | Project owner, 2026-09-29 (System Workflow, Ranking Algorithm) |
| One result card per listing (best variant under the active sort, "+N options") | Project owner, 2026-09-29 (Buyer Workflow, Search Results) |
| COD / In-Store shown as not offered | Default: no Vendor enablement setting exists until Phase 11 (deny by default) |
| Online payment eligible only with a `CONNECTED_TEST` Xendit account | Default |
| Intended destination and alternate drop-off are saved Buyer locations | Default |
| Best Price needs two distinct Vendors in the same comparable group and radius | Implementation interpretation — **pending owner confirmation** |
| Route family `/buyers/explore/summary` (Technical Design names `/buyer/explore/summary`) | Default: follows the implemented `/buyers` prefix |

## Acceptance checks → tests

| Check | Test |
| --- | --- |
| Fake Asia/Manila clock: open at opening minute, closed at exact closing minute, next opening | `PhaseSevenItemProcurementTest::test_store_hours_use_a_manila_clock…` |
| Phone time zone: 16:30 UTC is the next Manila date | same test; Flutter `Public Store Operation` group |
| All-Closed valid; dated override wins; removal restores the week; unique per date | `test_all_closed_is_valid_dated_overrides_win…` |
| Saved vs draft: Store Setup `form_state` never reaches the public profile; legacy/absent hours → UNAVAILABLE | `test_public_profile_shows_saved_hours_never_drafts…` |
| Hours never change discovery membership | same (all-Closed store still on the map) |
| Explore: distinct Vendors/listings, variants, duplicate materials across stores, stale stock, radius change, one snapshot, Vendor listings label, analytics disabled | `test_explore_counts_distinct_vendors_and_listings…`; Flutter `Explore dashboard` group (no false zero, stale response discarded, stale label) |
| SRS maths, weights, explainable components, deterministic ties | `Tests\Unit\SearchRelevanceScoreTest`; `test_best_deal_srs_is_explainable…`; `test_sorting_defaults_ties…` |
| Best Price: same comparable group and unit, pack normalization, requires available stock | `test_best_deal_srs_is_explainable_best_price_normalizes_packs…` |
| Favorites First explicit; Best Deal unchanged by Favorites | `test_sorting_defaults_ties_favorites_first…`; Flutter search test |
| Preferences total 100, reject all-zero, versioned, reset, private per Buyer, DB check | `test_item_based_preferences_total_100…`; Flutter `Ranking preferences` group |
| Cart creates no hold; idempotent add; price/quantity validation | `test_cart_placement_is_idempotent…`; Flutter Add to Cart retry test |
| Cross-Vendor preview: stale price, Vendor status, stale stock inline; cart intact; no orders/holds | `test_cross_vendor_preview_marks_stale_price…`; Flutter cart test |
| Heavy restriction without/with alternate, intended site retained, route basis to drop-off, advisory vs confirmed, coverage/route blockers, manual review | `test_heavy_access_requires_an_alternate…`; Flutter checkout tests |
| FIN-02 included VAT; no commission or CWT in Buyer totals | `test_preview_amounts_follow_fin02…`; unit FIN-02 test; `test:procurement-contract` |
| Layout: 320 px at 2× text, landscape, 390 px | Flutter `Layouts` group; captures in `docs/design/evidence/phase-7/` |

## Commands

```bash
docker exec materyalph_phase1_test-api-test-1 php artisan test
docker exec materyalph_phase1_test-api-test-1 vendor/bin/phpstan analyse --memory-limit=1G
docker exec materyalph_phase1_test-api-test-1 vendor/bin/pint --test
cd packages/api-contract && npm run validate && node scripts/check-procurement-contract.mjs <route-export.json>
cd apps/buyer-mobile && flutter analyze && flutter test
```

Known baseline: `buyer_app_test.dart` and `ui_capture_test.dart` fail 12 tests identically on `HEAD` (b503556) before this phase.

## Enhancement — 2026-09-29

The owner confirmed the enhancement remains inside the existing Phase 7 boundary. Checkout remains a preview; no replacement search/ranking engine, order submission, payment architecture or tax architecture was introduced.

### Implemented behavior

- Explore search opens a dedicated screen. Suggestions call the existing authorized listing search with a 350 ms debounce and stale-response rejection. Actual submitted searches are deduplicated, capped at ten, clearable, and retained for the signed-in controller lifetime. They are not persisted across sessions or devices.
- Catalog titles follow category/store context. Existing category IDs filter the backend query. A failed category or radius change cannot display the previous scope's products as current matches. Location, radius and filter empty states have appropriate recovery actions.
- Catalog uses the existing Map radius controller for 5, 10, 20, 30, 40 and 50 km. Explicit distance, price and rating sorting toggles direction. Reverse ordering occurs on the server before grouping/pagination and is part of the cursor fingerprint. Unrated products remain last in either rating direction.
- Profile opens the existing ranking-preferences API-backed page. Sliders and plus/minus adjust by 1%; largest-remainder allocation redistributes other factors proportionally with deterministic ties. A drag uses its starting weights to avoid cumulative rounding drift. Configured platform defaults, versioned save/reset, Favorites First separation, and the SRS calculation are preserved. Only a successful preference change refreshes applicable relevance results.
- Catalog, details, Map and Profile Favorite Suppliers share successful favorite changes. Duplicate rapid mutations are guarded. Favorites do not consume ranking weight.
- Add to Cart and Buy open a safe-area-aware finalization sheet with stored specifications, variant/SKU, public availability, quantity, volume-aware price, total and supported fulfillment modes. The existing price-version/idempotency/stock checks remain authoritative. Failed attempts keep an inline error; unconfirmed network retries reuse their key. Changing the payload starts a new attempt.
- Buy continues into the existing checkout preview. Cart selection reuses the server's active versus saved-for-later partition; other variants remain separate. Select All, individual selection, quantity and delete use existing versioned cart operations. Bulk selection is serialized and stops on failure, retaining the returned cart state.
- Product descriptions expand, the image gallery is preserved, specifications include active variant attributes, and the same-store shortcut uses the existing store filter. Small thumbnails request bounded decoding. Cart and checkout show the selected variant and authoritative returned amounts; no Buyer commission or invented Admin Fee was added.

### Explicit boundaries

- Materials Analytics is still disabled, now in a distinct panel. Notifications, chat, related-product recommendations, full review lists/distributions/media, Project/Work Package checkout integration, special-request submission, E-Invoice forms, order submission and Proceed to Payment are not implemented in this checkout's Phase 7 APIs. They were not fabricated or replaced with success placeholders.
- Listing media has no variant-image association in the public contract; changing variants preserves the listing gallery. Product rating summaries and existing compliance/best-price badges remain data-driven.
- Exact stock quantities are private. Finalization enforces positive quantity and the cart API rejects unavailable quantities without disclosing inventory counts. Fractional quantities retain the existing exact-quantity editor in Cart.
- UI/fixture tests and isolated API tests do not prove a live-device/provider purchase journey. No credentials, migrations or manual environment changes are required by this enhancement.

### Contract and affected files

`ListingSearchSort` adds `DISTANCE_DESC`, `PRICE_DESC`, `RATING_ASC`; existing values/defaults are unchanged. TypeScript and Dart clients/serializers were regenerated. No database migration. Backend changes are limited to `MarketplaceSearchService` sort keys and corresponding tests.

Buyer changes are in `lib/features/item_procurement/`, the shared discovery favorite controller/Profile favorite screen, and the Profile/Home navigation callbacks. Coverage is in `item_procurement_test.dart`, `phase7_enhancements_test.dart`, `phase7_capture_test.dart`, `phase7_enhancement_capture_test.dart`, `MarketplaceSortDirectionTest.php` and `PhaseSevenItemProcurementTest.php`. Visual evidence lives in `docs/design/evidence/phase-7/` and `phase-7-enhancement/`.

### Verification

- Focused isolated API suite: **12 passed, 383 assertions** (including reverse pagination and selected/saved cart membership).
- Full isolated API suite: **345 passed, 5,363 assertions**.
- SRS and direction unit tests: **5 passed, 52 assertions**.
- PHPStan for the changed search service and targeted Pint: passed.
- OpenAPI validation: passed with the existing three unused-schema recommendations. Procurement contract check: **13 operations passed**. Both portal typechecks passed.
- Flutter analysis: no issues. Flutter web build passed.
- Focused Buyer verification: **67 passed**; includes Profile navigation, shared discovery tests, responsive checks and nine Phase 7 goldens. The eight additional enhancement captures also passed their capture test and were visually reviewed.
- Full Buyer suite before the last focused regression additions: **142 passed, 1 skipped, 12 failed**. The failures are the already documented welcome/onboarding expectations in `buyer_app_test.dart` and missing non-Phase-7 golden files in `ui_capture_test.dart`; no Phase 7 tests failed in that run.
- Source secret scans passed. Git commands were not used.

Reproduce focused checks:

```powershell
cd apps/buyer-mobile
flutter analyze
flutter test --no-pub test/item_procurement_test.dart test/map_discovery_test.dart test/phase7_enhancements_test.dart test/phase7_capture_test.dart
flutter build web --no-pub
```

From the repository root, use the isolated stack for database tests:

```powershell
docker compose --env-file services/api/.env.testing -f compose.test.yaml -p materyalph_phase1_test exec -T api-test php artisan test --compact --no-ansi --filter=PhaseSevenItemProcurementTest
```

## Buyer UI refresh to the Figma references — 2026-09-29

Presentation-only change in `apps/buyer-mobile`; no API, contract, migration or rule changed.

- Shared components in `design_system/components/procurement_components.dart`: `PillSearchField`, `SortTabBar`, `FilterPill`/`FilterPillRow`, `RoundIconButton`, `SegmentedTabs`, `SpecificationRow`, solid `ListingBadge`, compact `QuantityStepper`, and `StateMessage` artwork. `BuyerTheme.successStrong` (status.success mixed with text.strong) keeps white/green badge text at 4.5:1.
- Search: back arrow, pill field, divided suggestion rows, "Clear" for session history, illustrated "Search not found" / location states.
- Catalog: title for category/store/browse context, pill search, underline sort tabs (Best Deal ▾ opens Best Deal / Favorites First and Ranking preferences; Distance, Rating, Price toggle direction), scrolling filter pills (Radius sheet, Favorite Suppliers, Site Delivery, Self-Pickup, In Stock only, PS/ICC verified, removable category/store), and a responsive grid (2 columns on phones, 1 at 2× text, up to 6 wide). Cards: photo with Best Price badge and Favorite toggle, price per unit, stock, rating/sold, store with VPS and distance, fulfillment, PS/ICC badge, stock-confirmed time and "Why this ranking" (bottom sheet).
- Product Details: full-width gallery with round Back / Store Profile / Cart controls and page dots; Overview / Related / Reviews segmented tabs; option and fulfillment pills; compact quantity; store row with Favorite toggle; label/value specification. Bottom bar: Add to Cart (tonal) and Buy (filled).
- Finalization sheet: product summary, "Selected specification" table with Total amount, option/quantity/delivery controls.
- Cart: round back, Vendor groups kept (one order request per Vendor), reference-style lines (checkbox = selected vs saved for later, photo, price, compact stepper, remove), footer with Select all, Delete (confirmation; removes selected lines one versioned request at a time) and Total + Checkout.
- Checkout preview now starts its request after the first frame, so cart listeners on underlying pages are not notified mid-build.

Not shown because no data or feature exists (not fabricated): Top Sales sort, discount percentage / strikethrough prices, delivery ETA such as "Tomorrow", brand logos, share, related-product recommendations and written review lists.

Verification: `flutter analyze` no issues; focused suites (`item_procurement_test`, `phase7_enhancements_test`, `buyer_store_browse_test`, `map_discovery_test`) 61 passed, including the new cart Delete test and every layout width; full Buyer suite 146 passed, 1 skipped, 12 failed — the same documented `buyer_app_test.dart` / `ui_capture_test.dart` baseline. Phase 7 and enhancement goldens regenerated and reviewed.

## Explore and Checkout redesign — 2026-09-29

Owner decisions (2026-09-29):

- **Explore** keeps only the header (title, Notifications, Cart), search, Materials Analytics and All categories as its main content. The Buyer workflow's MAT-01 requirements stay as one slim strip: active location and radius (tap opens the Map), Nearby Verified Vendors and Available Products (Vendor listings) from one snapshot, "Updated …" time, and a DEMO chip on TEST data (announced as "DEMO — Simulated Marketplace Data"). The Ranking preferences and Favorite Suppliers shortcuts moved off Explore; they remain on the catalog (sliders icon, Favorite Suppliers pill) and Profile. Notifications opens the existing "not available yet" page.
- **Checkout** follows the reference: delivery-address card (intended destination / Project site plus the labelled vehicle drop-off; the heavy-vehicle form opens from it and is shown automatically while incomplete), one card per store with items, a Delivery Mode switch (a mode the store does not offer stays visible and disabled), Total N items, payment methods and Payment Details. No Admin fee (no pricing rule defines one). "Submit order requests" stays disabled until order submission ships.
- **E-Invoice request and Order confirmation** are built now as labelled design previews reachable from Checkout ("Request E-Invoice", "Preview confirmation"). They save and send nothing, show no invented transaction ID, date, payment method or response time, and their submit/track buttons are disabled. The workflow places the real invoice request on Order Details after an order exists; the real confirmation ships with order submission.
- Project Procurement on Checkout opens the existing "not available yet" page.

Tests: `item_procurement_test.dart` covers the slim strip (no false zero while loading, one snapshot, stale retry, disabled analytics semantics, DEMO label), Delivery Mode switching, the disabled unoffered mode and both previews. Full Buyer suite: 149 passed, 1 skipped, 12 failed (the documented `buyer_app_test.dart` / `ui_capture_test.dart` baseline). New captures: `390-einvoice-preview.png`, `390-order-placed-preview.png`.
