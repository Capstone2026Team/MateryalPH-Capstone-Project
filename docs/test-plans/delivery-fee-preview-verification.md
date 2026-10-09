# Delivery fee preview verification — 2026-10-07

## Outcome

Selecting Site Delivery in the Buyer product finalization sheet now requests an automatic server-side estimate before adding the product to the cart. The sheet reuses checkout's destination/access editor and delivery explanation, shows materials plus estimated delivery, recalculates after variant, quantity or saved destination changes, discards obsolete responses, and offers retry after failure. Checkout waits while its product delivery estimate is being calculated.

Project-Based direct-selection orders now expose the delivery estimate already retained in their immutable system-estimate snapshot. Buyer and Vendor payment summaries include that estimate in an explicitly labeled estimated total. Confirmed delivery amounts remain authoritative. Existing snapshots are not rewritten.

Calculation reuses `DeliveryPreviewService` and `DeliveryRecommendationService`: Vendor rates, road-route endpoint distance, eligible vehicles, capacities and trips. Vendor confirmation and Buyer acceptance before payment remain required. Unknown physical measurements, unavailable routes or unsuitable vehicles do not become invented distances or zero fees.

## Files and contract

- API: `CartService.php`, `DeliveryPreviewService.php`, `OrderQueries.php`, `BuyerCartController.php`, and `routes/buyer.php`.
- Buyer: `product_finalization_sheet.dart`, `product_details_screen.dart`, `procurement_repository.dart`, `procurement_navigation.dart`, `checkout_preview_screen.dart`, new shared `delivery_widgets.dart`, and design-system `procurement_components.dart` / `order_components.dart`.
- Web: shared `packages/web-ui/src/order-patterns.tsx`.
- Contract: `packages/api-contract/openapi.yaml`, procurement contract assertions, regenerated TypeScript/Dart clients and Dart serializers.
- Regression coverage: `PhaseSevenItemProcurementTest.php`, `PhaseTenProjectsTest.php`, `cart_api_test.dart`; existing product-sheet fixtures updated for required dependencies.
- No migration, development data change, deployment or commit.

New operation: `POST /api/v1/buyers/cart/delivery-preview` (`previewBuyerProductDelivery`). Input is listing variant ID and quantity. Output reuses `DeliveryPreview`, including its advisory, blocked, action-required and manual-review states. The Buyer cannot supply a fee or vehicle rate.

The endpoint requires the existing mobile Passport and Buyer-account guards. Destination resolution uses only the authenticated Buyer's cart and owned locations. It validates public listing eligibility, fulfillment capability, quantity precision and availability without exposing exact inventory. It does not add cart lines, reserve inventory, confirm delivery, change payment amounts or publish a commercial event. Route calls occur outside database locks.

## Checks completed

| Check | Result |
| --- | --- |
| Focused PHP Pint, 7 changed PHP files | Passed |
| `php vendor/bin/phpstan analyse --memory-limit=512M --no-progress` | Passed, no errors |
| `npm.cmd run validate` in api-contract | Passed; 3 unused-model recommendations |
| Procurement contract | Passed, 15 operations and guards |
| Orders contract | Passed |
| Projects contract | Passed, 23 operations and guards |
| TypeScript/Dart generation and Dart build_runner | Passed |
| `flutter analyze --no-pub` | Passed, no issues |
| `flutter test --no-pub test/cart_api_test.dart` | Passed, 5 tests |
| Vendor lint, typecheck, build | Passed; bundle-size warning |
| Admin lint, typecheck, build | Passed; bundle-size warning |
| Changed source whitespace/conflict-marker check | Passed, 22 files |
| Gitleaks stdin scan of changed source | Passed, no leaks |
| Gitleaks stdin scan of regenerated client files | Passed, no leaks |

Flutter checks used the installed Dart executable and Flutter tool snapshot directly, with approved SDK-cache access, because the shell wrappers stalled. UI/E2E tests were not run. No Git commands were used; source review and the explicit-file scan do not represent a Git diff or staged-history scan.

## Pending verification

The initial run could not access Docker through the sandbox. The follow-up obtained approved access to the existing Docker Desktop CLI and ran tests in the already running isolated containers. The earlier native attempt was stopped and is not counted as passed. Test database safeguards were preserved.

- Delivery unit tests: **12 passed, 69 assertions**.
- Explicit Item-Based, Orders and Project-Based API files: **45 passed, 1 failed, 1,247 assertions**. All 13 Item-Based and 14 Project-Based cases passed, including the new delivery regressions. One pickup-order test fails at `PhaseEightOrdersTest.php:135` because its expected commission `fee_assessments` row is absent. This is a separate commission-assessment gate; the whole order suite is not claimed as passed.
- Follow-up checkout explanation: Flutter analysis passed; diagnostic PHP syntax/Pint and secret scan passed. No UI test was run.

Once Docker Desktop is available, run from the repository root:

```powershell
docker compose --env-file services/api/.env.testing -f compose.test.yaml -p materyalph_phase1_test up -d --build --wait postgres-test redis-test api-test
docker compose --env-file services/api/.env.testing -f compose.test.yaml -p materyalph_phase1_test exec -T api-test php artisan test --compact --no-ansi "--filter=PhaseSevenItemProcurementTest|PhaseEightOrdersTest|PhaseTenProjectsTest|DeliveryRecommendationTest"
docker compose config --quiet
```

New API cases cover pre-cart calculation, fee changes across trips, quantity validation, alternate endpoints, missing measurements, route failure, Buyer isolation, role denial, no commercial or cart-line mutations, and immutable Project-Based estimates in both order summaries.

Live Google Routes behavior and device/browser acceptance remain unverified. No new key names or manual schema setup are introduced. A numeric estimate still requires a saved destination, the access declaration, usable Vendor vehicle rates/capacities, sufficient product measurements and a working route provider. Accepted orders are not repriced.

Suggested commit: `fix(procurement): show automatic delivery estimates before checkout`

## Follow-up: checkout still shows Pending

A read-only runtime check of the user-supplied SKU `213212-1` found product transport dimensions of **231 × 323 × 123123 cm**, equivalent to **2.31 × 3.23 × 1231.23 m**, at **20 kg**. The eligible flatbed's cargo space is **14.60 × 2.50 × 1.50 m**. The stored route is available; the recommendation service rejects vehicle fit with `DIMENSIONS_INSUFFICIENT`. No numeric delivery estimate is valid for the stored load.

The Buyer checkout payment block now repeats the actual delivery issue, uses “Estimate unavailable,” and labels the known materials amount “Materials total before delivery” instead of showing an unexplained Pending total. Successful estimates remain clearly labeled as estimates.

`scripts/inspect-delivery-runtime.php` provides a read-only transaction-based diagnostic for a supplied SKU. It uses existing cached routes without making provider calls or changing cart/product data, and omits identity, addresses, coordinates, instructions, exact stock and credentials from its output.

The user authorized correcting the development listing, but actual dimensions have not yet been supplied. No measurement has been guessed or changed. No API contract or migration change is needed for this follow-up.
