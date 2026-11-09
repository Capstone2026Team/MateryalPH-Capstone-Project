# Buyer Vendor ratings and public badges — 6 November 2026

## Outcome and scope

Published Tier 2 Vendor performance ratings use a star followed by the existing published value. Updated surfaces: map labels/list/selected preview, storefront header and Store rating VPS row, product/search summaries, favorites, Project Vendor comparison and quotation summaries. Accessibility text and chip tooltips still identify Vendor performance explicitly. New Vendor, Directory attribution, product ratings, scoring precision/gates, ranking, radius, permissions and procurement actions retain their existing behavior.

The shared Flutter components provide scalable medal graphics for Fast Responder, Highly Rated, High-Quality Materials, Most Ordered, On-Time and Trusted Supplier. Selection shows compact named awards; Store Profile retains the server's eligibility description and any category/province scope. An empty badge list adds no placeholder awards. Graphics have no external assets or new dependencies. Fixed an adjacent Project card distance-label overflow exposed at 320 px and doubled text size.

## Files and transport

- Shared presentation: `lib/core/vendor_score_display.dart`, `lib/design_system/components/{vendor_performance,discovery_controls}.dart`.
- Buyer consumers: map discovery models/repository/panels/labels/legend/favorites, storefront, product/search, Project Vendor selection and quotation widgets.
- `SupplierDiscoveryService` forwards the public awards already returned by `PublicVendorProjection`.
- `ProjectEstimateService` reads current public awards in a batch for comparisons and on individual preview reads; awards are not persisted in commercial estimate snapshots.
- OpenAPI adds optional `PublicBadge[]` fields to `VerifiedVendorSummary` and `ProjectCandidate`. TypeScript and Dart clients/serializers regenerated. Existing endpoints and authorization remain. No migrations, provider settings, secrets, manual badge assignment or new audit/notification behavior.
- Discovery's persistent offline copies omit awards; live results retain them through Favorite updates. Refresh restores the current server list.

## Automated evidence

- OpenAPI validation: passed, with eight existing specification recommendations.
- Geography contract: passed, 18 operations; asserts both additions use `PublicBadge` and Directory has no awards.
- Projects contract: passed, 35 operations. Trust/analytics contract: passed, 43 operations.
- TypeScript/Dart generation: passed; Dart build runner completed successfully (the deprecated `--delete-conflicting-outputs` argument was ignored by the installed runner).
- Changed PHP files: Pint passed. API PHPStan: passed, no errors.
- Final presentation checks: **10 passed**. Cover star-first order and accessible VPS provenance, no fabricated scores, long map names retaining the score, all six badge graphics on actual discovery/Project cards at 320/390/768 px and 1×/2× text, selected Vendor preview capture, and a native map-label bitmap capture. The additional bitmap check ran after the 131-test regression run below; the nine earlier presentation cases were included in that regression run.
- Final `flutter analyze --no-pub`: passed, no issues (209.7 seconds).
- Related Flutter regression run: **131 passed**, zero failures across `vendor_performance_presentation_test`, `directory_rating_transport_test`, `buyer_store_browse_test`, `map_discovery_test`, `supplier_browsing_test`, `supplier_marker_golden_test`, `discovery_cache_test`, `discovery_freshness_test`, `favorite_suppliers_actions_test`, `vendor_selection_test`, `vendor_sort_direction_test`, `item_procurement_test` and `project_transport_test` (115 seconds). Existing marker goldens were verified without updates. This is a focused regression run; the full application suite was not run.
- Source secret scan: passed, no leaks in 28 changed source/document files. Scoped `git diff --check`: passed. Unrelated working-tree changes were retained.

The two new database-backed API cases could not reach assertions: `postgres-test` cannot resolve from this Windows shell, and Docker is unavailable on PATH. The test safety guard refused the unverified connection; no application database was changed. Cases cover discovery excluding revoked/suppressed awards/private case details, and Project award revocation without changing the saved estimate. They remain unverified until run against the isolated Compose database.

## Visual and manual verification

Reviewed `apps/buyer-mobile/test/goldens/vendor-awards-selection.png` with actual Inter, Lucide and Material icon fonts. The capture uses synthetic test fixtures and confirms the compact star rating, named medals, scoped Most Ordered award and existing storefront/message actions. Also reviewed `vendor-vps-map-label.png`: its generated map bitmap displays a legible star and score after a shortened long Vendor name. These captures do not prove native Maps SDK or live provider behavior.

On a configured Android/iOS build, check one published Vendor, one New Vendor, a Directory Supplier and a Vendor with no awards. Verify map selection, Store Profile, product/search, favorites and Project Vendor cards; confirm TalkBack/VoiceOver announces Vendor performance and badge descriptions. Revoke or suppress an award and refresh; it must disappear. Native device/provider acceptance and an APK build were not performed.

Run the blocked API checks in the existing isolated test environment:

```powershell
docker compose -f compose.test.yaml run --rm api-test php artisan test --filter="test_discovery_exposes_only_active_unsuppressed_public_vendor_badges|test_candidate_badges_are_current_public_awards_without_rewriting_the_estimate"
```

Suggested commit: `feat(buyer): unify vendor star ratings and public badge graphics`.
