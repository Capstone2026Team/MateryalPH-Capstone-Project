# Automatic delivery recommendation and Buyer approval — 2026-10-15

The system now recommends the lowest formula-fee eligible vehicle plan for each separately carried load group, breaking ties by fewer trips, fewer vehicles and vehicle ID. The existing capacity, dimensions, material compatibility, coverage, actual road route and access checks still apply. Delivery previews return the recommended plan and its fee rather than an unexplained range of alternatives. Vendor order confirmation loads and selects that plan automatically and recalculates after quantity changes, discarding obsolete responses.

Changing the vehicle, vehicle count, trips or gross fee requires a Vendor explanation of 10–2000 characters. Validation compares both the current recommendation and the recommendation frozen at submission, including route/rate changes. The immutable delivery snapshot keeps the original recommendation, confirmed plan and explanation. Buyer Order Details and published quotation review disclose the explanation before acceptance. The existing versioned Buyer approval and payment gates remain in place. An estimate is advisory; it never dispatches a vehicle or guarantees exact packing.

Project estimates include the delivery calculation version in their freshness fingerprint. Vendor Selection offers Refresh estimate when a listing or vehicle change makes an otherwise active estimate stale. Historical estimates and accepted orders are not rewritten.

## Live development data check

The read-only `scripts/inspect-delivery-runtime.php 213212-1` diagnostic confirmed the user's updated listing: 16.667 kg and 1200 × 1.50 × 1.50 cm (12 m length). It passes the currently configured flatbed's 2000 kg payload and 14.60 × 2.50 × 1.50 m cargo checks. The active cart contains one piece. Its current cached road route was 5084 m and yielded one trip at 60,420 centavos: ₱350 base + 5.084 km × ₱50/km = **₱604.20**. No product, cart, stock or order data was changed by the diagnostic. This is a route-based estimate, not a confirmed order charge.

## Files and API contract

- Domain/API: `DeliveryRecommendationService`, `DeliveryPreviewService`, `ConfirmedDeliverySnapshot`, `OrderDeliveryPlanner`, `OrderConfirmationService`, `OrderQueries`, `ProjectEstimateService`, `QuotationTerms`, `VendorOrderController`.
- Vendor/shared web UI: `OrderPages.tsx`, `delivery-arrangement-fields.tsx`, `quotation-delivery-arrangement.tsx`.
- Buyer: shared procurement/messaging components, delivery preview, order model/repository/details, quotation acceptance review and Project Vendor Selection.
- Tests: `DeliveryRecommendationTest.php`, `PhaseFiveInventoryDeliveryTest.php`, `PhaseEightOrdersTest.php`, and `check-orders-contract.mjs`.
- Source contract: `packages/api-contract/openapi.yaml`; regenerated TypeScript/Dart clients and Dart serializers.
- Workflows: System, Buyer, Vendor and UI/UX planner record the user's requested rule.

No migration, new credentials, environment variables, deployment, Git command or development database mutation is required.

Existing endpoints gain optional contract fields: `DeliveryEstimateOption.vehicle_id`, `DeliveryPlanVehicle.recommended`, `OrderDeliveryEstimate.options`, `DeliveryConfirmation.change_reason` and `OrderConfirmedDelivery.{system_recommendation,recommendation_changed,change_reason}`. Historical responses remain readable. A missing/invalid explanation for a changed plan returns `422 DELIVERY_CHANGE_REASON_REQUIRED`. No fee, recommendation flag or vehicle supplied by a client is trusted without server validation.

Only the Owner/Store Manager confirms a commercial delivery arrangement. Existing current authorization checks, deterministic stock reservation, idempotency, immutable snapshots, commercial-version approval, audit references and post-commit notifications are reused. Route-provider calls remain outside database locks. No private staff contacts, exact inventory or coordinates are added to responses.

## Validation

| Check | Result |
| --- | --- |
| Isolated delivery unit/API regressions across fleet, cart, orders, messaging and Projects | **42 passed, 842 assertions** |
| Buyer cart and messaging API tests | **6 passed** |
| Full API PHPStan, 512 MB | Passed, no errors |
| Pint on 12 affected PHP source/test files | Passed |
| OpenAPI validation | Passed, 8 unused-model recommendations |
| Orders, procurement, messaging and Projects contract checks | Passed |
| TypeScript/Dart generation and Dart serializer generation | Passed |
| Generated TypeScript client build | Passed |
| Full Flutter analysis | Passed, no issues |
| Vendor lint, typecheck and production build | Passed; bundle-size warning |
| Admin lint, typecheck and production build | Passed; bundle-size warning |
| Docker Compose configuration | Passed |
| Explicit source whitespace/conflict review | Passed, 30 files; intentional Markdown hard breaks retained |
| Gitleaks source scan | Passed, 2.63 MB, no leaks |
| Gitleaks generated-client source scan | Passed, 22.68 MB, no leaks |

The API regression command was run through the dedicated Compose test project, without using the development database:

```powershell
& 'C:\Users\RJ\AppData\Local\Programs\DockerDesktop\resources\bin\docker.exe' compose --env-file services/api/.env.testing -f compose.test.yaml -p materyalph_phase1_test exec -T api-test php -d memory_limit=512M artisan test --compact --no-ansi tests/Unit/DeliveryRecommendationTest.php tests/Feature/Api/PhaseFiveInventoryDeliveryTest.php tests/Feature/Api/PhaseSevenItemProcurementTest.php tests/Feature/Api/PhaseEightOrdersTest.php tests/Feature/Api/PhaseNineMessagingTest.php tests/Feature/Api/PhaseTenProjectsTest.php --filter=delivery
```

Buyer API checks used `flutter test --no-pub test/cart_api_test.dart test/messaging_api_test.dart` through the installed Flutter SDK executable. Full PHPStan used `php vendor/bin/phpstan analyse --memory-limit=512M --no-progress`. The standard npm `lint`, `typecheck`, `build`, contract validation and listed contract-check scripts were run from their package directories.

Device/browser visual acceptance and live provider calls were not performed. The full application test suites, Git diff and staged-history checks were not run; the checks above are the completed scope. Reopen checkout to obtain a new estimate; use Refresh estimate for an existing Project system estimate after a listing change. No new key names or manual database setup are needed.

Suggested commit: `fix(delivery): recommend vehicles and require approval for changes`
