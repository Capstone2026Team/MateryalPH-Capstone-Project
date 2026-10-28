# Message quotation delivery and pricing — 28 October 2026

## Delivered behavior

- Item-Based Prepare quotation offers the Buyer's shared inquiry destination or a searched, Buyer-confirmed address. Search resolves through the existing server-side geocoder and returns a conversation-scoped address ID and formatted address, without device GPS or address-book access.
- Record the Buyer's known heavy-vehicle restriction answer and access/unloading instructions. A restriction requires a separate alternative drop-off, used for road routing and delivery pricing. Intended and alternative endpoints must remain within the existing 50-km procurement boundary and configured delivery coverage.
- Incomplete delivery details autosave without running publication validation or inventing a zero fee. Site Delivery previews use the existing delivery planner, vehicle eligibility, measurements, capacities, rates, mobilization, integer-centavo rounding and per-load-group trips.
- Automatically apply the recommendation and recalculate when vehicles/trips change. Manual fees are explicit and require a Buyer-visible explanation before publication; the API freezes both formula and proposed amounts. Ordinary order confirmation retains exact formula validation.
- Keep the after-discount quotation order total visible in the dialog footer. Processing fees remain pending the Buyer's channel selection. The Buyer reviews the endpoints, access instructions, arrangement, original formula fee when overridden, final amount and explanation before accepting.
- Preserve Work Package destinations, immutable published versions, role permissions, Buyer payment selection, reservations and existing audit/outbox publication events. Store Staff prepare delivery terms for an Owner or Store Manager to confirm and publish.

## Changed domains and contract

Vendor editor/API adapter/draft normalization, shared destination/delivery fields and quotation breakdown, Buyer quotation breakdown, messaging controller/routes/services, delivery snapshot preparation, OpenAPI and generated TypeScript/Dart clients, workflow/planner addenda, API/component/browser/Buyer tests.

No migration is required: proposed locations use the existing `addresses` table with conversation ownership; draft selections and immutable quotation/order snapshots use their existing JSON fields. Buyer saved locations and the inquiry's original reference are not overwritten.

New authenticated, CSRF-protected Vendor operations:

- `POST /api/v1/vendor/conversations/{conversationId}/quotation/location`
- `POST /api/v1/vendor/conversations/{conversationId}/quotation/delivery-plan`

Drafts gain an optional `destination` selection. Delivery terms support explicit `fee_override`; published delivery snapshots include `formula_charge_centavos` and `fee_overridden`. Published quotation content now declares the already-frozen destination in the generated-client contract.

## Validation evidence

- Isolated messaging and delivery recommendation regressions: **66 passed, 1,368 assertions**. The final two new quotation tests were rerun after the radius/alternative-endpoint additions: **2 passed, 61 assertions**.
- Isolated `PhaseEightOrdersTest.php`: **28 passed, 858 assertions**, including ordinary order fee/discount behavior.
- Vendor full suite: **682 passed**. Final quotation editor/draft checks: **22 passed**. Vendor lint, typecheck and production build passed; lint retains an unrelated unused-variable warning in `e2e/admin-finance-layout.spec.ts` and build retains bundle-size warnings.
- Admin full suite: **236 passed**; lint, typecheck and production build passed, with existing bundle-size warnings.
- Buyer analysis: **no issues**. Focused quotation/messaging/fulfillment tests: **18 passed**; final disclosure-only rerun: **6 passed**. The final stable full Buyer suite passed **633 tests with 1 skipped**.
- Chromium quotation flow: all three scenarios passed at **320, 390 and 1440 px**. Reviewed desktop destination and narrow-phone manual-fee screenshots; total remains visible and no horizontal page overflow was detected. Screenshots are in ignored `apps/vendor-web/test-results/quotation-delivery-*/`.
- OpenAPI validation passed with eight unused-model recommendations; messaging contract passed **42 authorized operations**, and orders contract passed. Both clients and Dart serializers regenerated through their generators.
- Full Pint check and PHPStan passed. Compose configuration and diff whitespace checks passed. Gitleaks staged scan (no staged changes), tracked diff scan and new source-file scan found no leaks.

The first full Vendor run had three failures in media/legal tests while unrelated shared session work was changing concurrently. All three subsequently passed in a 50-test rerun and the final 682-test run; this quotation change did not edit those unrelated files.

An earlier full Buyer run overlapped the final disclosure edit and failed its new formula-fee assertion. That test passed in isolation, and the full suite was rerun with edits stopped: **633 passed, 1 skipped**, with no remaining failure. The HTML browser reporter stalled after its three successful scenarios; the line-reporter rerun exited cleanly with **3 passed**, and its local test/preview processes were cleaned up.

## Reproduction

Use `npm.cmd` on Windows. API tests run only in the repository's isolated `materyalph_phase1_test` Compose project, using `compose.test.yaml` and the ignored test environment.

```text
php artisan test --compact --filter=PhaseNineMessagingTest
php artisan test --compact tests/Feature/Api/PhaseEightOrdersTest.php
php artisan test --compact --filter=DeliveryRecommendationTest
php vendor/bin/pint --test
php vendor/bin/phpstan analyse --memory-limit=512M

# apps/vendor-web
npm.cmd run lint
npm.cmd run typecheck
npm.cmd run test -- --run
npm.cmd run build
npm.cmd run test:e2e -- e2e/quotation-delivery.spec.ts --project=chromium-320 --project=chromium-390 --project=chromium-1440

# packages/api-contract
npm.cmd run validate
npm.cmd run test:messaging-contract
npm.cmd run test:orders-contract

# apps/buyer-mobile
flutter analyze
flutter test
```

## Remaining acceptance and setup

Live two-account acceptance, physical-device use and actual Google geocoding/routing were not exercised. Provider calls in automated tests use fakes or mocked HTTP responses. The existing `GOOGLE_MAPS_SERVER_API_KEY` must enable the deployed geocoding/routing services; no new credential names or schema setup were introduced. No deployment, push, merge or development-database migration was performed. The complete API test suite was not run; API verification is scoped to messaging, order and delivery regressions above.

Suggested commit: `fix(quotations): complete delivery destination and pricing flow`.
