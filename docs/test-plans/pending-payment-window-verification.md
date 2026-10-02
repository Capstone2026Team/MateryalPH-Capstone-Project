# Pending Payment window verification — 2026-10-02

## Outcome

Verified and completed the existing 24-hour Pending Payment implementation. `orders.payment_expires_at` remains authoritative. Checkout attempts last at most 45 minutes and are capped at that deadline. Existing orders retain their persisted deadlines. Failed/expired attempts permit retry of the same order and principal; processing fees remain channel-specific server quotes. Row locks, settlement state checks, idempotency, and late-capture compensation remain intact.

The canonical terminal state remains `EXPIRED` with `PAYMENT_WINDOW_EXPIRED`, displayed as cancelled because payment expired. Client countdown callbacks reload server state; they never cancel an order locally. Existing Vendor-approved balance payments remain available with the distinct label **Pay remaining balance**.

## Work completed

- Verified the previous acceptance, expiry, attempt-window, notification, reminder command, configuration, and scheduler changes.
- Removed remaining `orderAppBar` imports/wrapper in Buyer Orders, Order Details, and NRPC disclosure; use the shared `buyerAppBar`.
- Verified 409 `PAYMENT_ATTEMPT_IN_PROGRESS` resumes `details.payment_id` without creating or launching another checkout. Added widget regression coverage.
- Added `OrderSummary.payment_retryable` to the API contract/read model and regenerated TypeScript and Dart clients. Buyer list cards now show **Re-process payment** for failed/expired attempts and refresh server state at their displayed deadline.
- Payment-status retry controls now fetch the order and require server payability. Pending Payment controls also require the appropriate order state. Retained approved balance-payment behavior.
- Payment options resolve server expiry before returning payability. Order detail reloads after expiry reconciliation even when reconciliation confirmed a payment instead of expiring the order.
- Reminder batches exclude already-sent reminders so earlier orders cannot starve later batches. Added batching/idempotency coverage.
- Verified the shared countdown renders hours and exact Asia/Manila time. Updated stale tests, workflow/planner wording, and the visually reviewed Pending Payment golden.
- Published NRPC Terms v2 through a new migration and updated the foundation seeder. Historical v1 content and acceptances remain unchanged. A regression test verifies migration idempotency and historical content.

## Files and migrations

Principal changes are in `apps/buyer-mobile/lib/features/orders/{orders_screen,order_details_screen,order_payment_screen,nrpc_disclosure_screen,order_models,orders_repository}.dart`, their order/payment tests and fixtures, `test/phase8_capture_test.dart`, and `docs/design/evidence/phase-8/390-details-awaiting_payment.png`.

Backend follow-up changes are in `OrderQueries`, `OrderPaymentReminders`, `OrderAcceptance`, `PaymentAttemptService`, `PhaseEightOrdersTest`, `PhaseElevenPendingPaymentWindowTest`, and `SystemFoundationSeeder`. Contract changes are in `packages/api-contract/openapi.yaml`, `scripts/check-orders-contract.mjs`, and generated clients.

Development migrations confirmed applied:

- `2026_10_06_000000_create_order_payment_reminders` (existing implementation, batch 25).
- `2026_10_06_010000_publish_pending_payment_nrpc_terms` (new, batch 26), with `resources/agreements/NRPC_TERMS/2.md`.

The new terms migration preserves published history on rollback; correcting terms requires another version.

## Executed checks

Backend commands ran in `api-test` using `compose.test.yaml`, project `materyalph_phase1_test`, and `services/api/.env.testing`. Development commands ran separately in the `api` service of `compose.yaml`. On this machine Docker required its full executable path and access outside the filesystem sandbox.

| Command | Result |
| --- | --- |
| `flutter pub get` | Passed; no dependency upgrades requested |
| `flutter analyze` | Passed, no issues |
| `flutter test --reporter expanded` | Final run: 248 passed, 1 existing opt-in Phase 7 capture skipped |
| `flutter test test/phase8_capture_test.dart --plain-name 'order details AWAITING_PAYMENT' --update-goldens` | Passed after visual review |
| `php artisan test --compact --no-ansi` | 150 passed, 1,819 assertions; this invocation omitted the nested API directory |
| `php artisan test --compact --no-ansi tests/Feature/Api` | 337 passed, 5,797 assertions in the earlier API-only run |
| `php artisan test --compact --no-ansi tests/Unit tests/Feature/ExampleTest.php tests/Feature/SchemaFoundationTest.php tests/Feature/OnboardingFoundationSchemaTest.php tests/Feature/Api` | 486 passed, 1 failed, 7,594 assertions; sole failure expected NRPC Terms v1 instead of v2 |
| `php artisan test --compact --no-ansi tests/Feature/Api/PhaseEightOrdersTest.php tests/Feature/Api/PhaseElevenPaymentsTest.php tests/Feature/Api/PhaseElevenPendingPaymentWindowTest.php` | After correcting that assertion: 41 passed, 1,029 assertions; the complete suite was not repeated after this test-only correction |
| `vendor/bin/pint --test` | Final run passed, 518 files |
| `vendor/bin/phpstan analyse --memory-limit=512M --no-progress` | Passed, no errors |
| Vendor `npm.cmd run test -- --run src/pages/OrderPages.test.tsx --maxWorkers=1` | 9 passed; this resolved a worker-start timeout in a repeated concurrent run |
| Vendor `npm.cmd run lint`, `npm.cmd run typecheck`, `npm.cmd run build` | Passed; build retains its large-chunk warning |
| Contract `npm.cmd run validate` | Passed, 3 existing unused-model recommendations |
| Contract `npm.cmd run test:orders-contract`, `npm.cmd run test:payments-contract` | Passed; payments checks cover 31 operations |
| Contract `npm.cmd run generate` | Passed; generated clients synchronized |
| Generated Dart `dart run build_runner build --delete-conflicting-outputs`, `dart analyze` | Passed, no analysis issues |
| Generated TypeScript `npm.cmd run build` | Passed |
| Development `php artisan migrate --force`, `php artisan migrate:status` | Both migrations above applied; no pending migrations at verification |
| Development `php artisan schedule:list` | Expiry every minute; reminders every five minutes, both without overlapping |
| Test `php artisan materyalph:orders-payment-reminders` | Passed, `0 reminder(s) sent`; reminder delivery behavior covered by fixtures |
| Both Compose configurations, `config --quiet` | Passed |
| `gitleaks dir --redact --no-banner --no-color <changed source paths>` | Passed for changed Buyer order code/tests, backend order/payment code/tests, migration, seeder, and terms content |

No API-contract `lint` script exists; OpenAPI validation and the order/payment contract scripts are its relevant checks. No Git commands or commits were performed.

## Runtime and limits

The development API, PostgreSQL, Redis, scheduler, and queue worker were running at verification. Starting the existing API through Compose also ran its configured `api-setup` dependency, which invokes migrations and the foundation seeder; no database reset or commercial-record cleanup was performed. Subsequent scheduler/worker startup used `--no-deps`.

The configured default `ORDER_PAYMENT_WINDOW_HOURS=24` is documented in `.env.example`; no new secret is required. Provider TEST credentials, webhook reachability, and deployment scheduling remain the existing environment responsibilities.

The stale-wording search in Buyer, Vendor, docs, and PRODUCT.md found only intentional checkout-session/platform-fee references. Outside those directories, NRPC Terms v1 retains its old deadline as immutable historical content; current terms use v2.

No connected-device payment journey or live Xendit checkout was exercised. Widget tests verify resume/navigation; isolated provider fixtures verify settlement, retry, expiry, reminders, and compensation. The temporary automatic-approval usage-limit block was resolved when work resumed.

Suggested commit: `fix(payments): complete 24-hour pending payment window`
