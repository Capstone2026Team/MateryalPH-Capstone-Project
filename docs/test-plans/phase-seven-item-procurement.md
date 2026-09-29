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
