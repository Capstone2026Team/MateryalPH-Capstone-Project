# Buyer procurement updates - 2026-11-09

Implemented the requested purchase-count, attachment-menu, cart/checkout product-link and Best Deal search changes.

## Result

- Product cards, Product Details and product-review headings show distinct Buyers with completed purchases. One Buyer counts once across repeated orders and all variants of the same listing. Completed quantities remain available for the existing TOP_SELLING sort.
- The Buyer chat plus menu offers file and product attachments. Its Delivery details action is removed; existing delivery references and authorized quotation flows remain available.
- Cart uses a shared compact product link with saved variant/quantity, price, availability and line total. Inline fulfillment and quantity/option controls are removed. Selection, removal, stale-price resolution, store grouping and totals remain.
- Cart and checkout product links open Product Details with the saved selections. Save changes updates the existing cart line rather than adding another. Checkout refreshes its preview after returning.
- Best Deal prioritizes exact product names, names containing all search tokens, full catalog/alias matches, then fuzzy alternatives by similarity. The existing five-component SRS ranks offers within the same match level. Explicit distance, price, rating, Favorites First and Top Selling ordering retain their behavior. Match ordering applies before candidate limits, listing deduplication and signed cursor pagination; old ordering cursors are invalidated.

## Files and contract

Mobile changes are in `apps/buyer-mobile/lib/features/item_procurement/`: `cart_product_link.dart`, `cart_screen.dart`, `cart_controller.dart`, `checkout_preview_screen.dart`, `procurement_navigation.dart`, `product_details_screen.dart`, `product_finalization_sheet.dart`, `search_results_screen.dart`, `procurement_models.dart` and `procurement_repository.dart`. The attachment action is removed from `features/messaging/messaging_screen.dart`.

Backend changes are in `ListingPublicFacts.php`, `ListingDetailService.php`, `MarketplaceSearchService.php`, `CartService.php` and `BuyerCartController.php`. Relevant Buyer/System workflow and UI planner text is updated. Existing unrelated working-tree changes are retained.

OpenAPI adds optional nonnegative integer `unique_buyers` to `ListingSearchResult` and `ListingDetails`, retains quantity-based `units_sold`, documents text-first Best Deal ordering, and extends `CartItemUpdate` with `listing_variant_id`, `expected_price_version_id` and `fulfillment_method`. TypeScript and Dart clients and Dart serializers were regenerated. No migration or new configuration/key is required.

## Authorization and data

Cart edits retain authenticated Buyer ownership, cart version checks, same-listing variant validation, current displayed-price checks, quantity/stock rules, Work Package tags and Vendor-wide fulfillment validation. Product changes and fulfillment changes share one transaction. Duplicate existing options return `CART_VARIANT_ALREADY_EXISTS` rather than silently merging lines. Failed fulfillment validation rolls back the product edit. Nothing reserves inventory, submits an order, changes commercial history or reveals Buyer identities/exact stock.

## Validation

| Check | Result |
| --- | --- |
| `flutter analyze --no-pub` | Passed: No issues found. |
| `flutter test --no-pub test/item_procurement_test.dart test/phase7_enhancements_test.dart test/cart_api_test.dart test/checkout_options_contract_test.dart test/messaging_layout_test.dart test/messaging_test.dart test/messaging_api_test.dart test/explore_freshness_test.dart test/ranking_preferences_contract_test.dart --reporter expanded` | Passed: 99 tests. Includes saved-line editing, refreshed checkout links, distinct-Buyer labels, attachment menu, transport/serialization, ranking preferences and responsive layouts from 320 px at 2x text through 1920 px. |
| Isolated API: `php artisan test tests/Feature/Api/PhaseSevenItemProcurementTest.php tests/Feature/Api/CheckoutOptionsTest.php tests/Unit/SearchRelevanceScoreTest.php --compact --no-ansi` | Passed: 29 tests, 825 assertions. |
| API `php vendor/bin/phpstan analyse --memory-limit=512M --no-progress` | Passed: No errors. |
| `php vendor/bin/pint --test` with the six changed PHP files | Passed. |
| Contract `npm.cmd run validate` | Passed with eight unused-model recommendations. |
| `node packages/api-contract/scripts/check-procurement-contract.mjs <isolated-route-export.json>` | Passed: 15 Buyer operations match Laravel routes and guards. |
| `npm.cmd run generate` and Dart `build_runner build` | Passed. |
| Application and isolated-test `docker compose config --quiet` | Passed. |
| `git diff --check`, staged Gitleaks, and Gitleaks over the affected diff | Passed: no whitespace errors or detected secrets. |
| Rendered visual inspection | Passed: inspected 390 px Cart and Checkout screenshots in `apps/buyer-mobile/build/buyer-procurement-review/`. Temporary capture test removed. |

The API command used the existing `materyalph_phase1_test` Compose project and its guarded test database. Host PHP attempts could not resolve the Docker-only `postgres-test` hostname and made zero assertions. A later host route export timed out; the contract check passed using a read-only export from the isolated API container. Dart/Flutter commands used the direct SDK executable with approved SDK-cache access. These environment attempts are separate from the passing isolated checks above.

Validation is focused on the affected domains. A physical-device smoke test and full repository suite were not run. No deployment or mobile installation was performed.

Suggested commit: `fix(buyer): refine purchase counts cart editing and search relevance`
