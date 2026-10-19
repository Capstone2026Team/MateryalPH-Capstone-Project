# Buyer payment choice before quotation acceptance

The Vendor chooses the quotation's fulfillment method. The Buyer explicitly chooses payment in the Review and accept quotation dialog, before the final Accept action is enabled. No method is preselected.

| Quoted fulfillment | Buyer choices |
| --- | --- |
| Site Delivery | Cash on Delivery (COD), Online payment |
| Self-Pickup | In-Store Payment, Online payment |

The existing Vendor settings and online-account readiness determine availability. An unavailable method is disabled with an explanation. The API rechecks availability and fulfillment when accepting; a stale or forged choice cannot reserve inventory or create an order. Direct physical payment without NRPC uses the existing CONFIRMED flow and physical obligation; physical payment with NRPC still requires the accepted NRPC online first. Online payment uses the existing AWAITING_PAYMENT flow. No payment success or provider event is fabricated.

The selected method is saved in the order, its accepted commercial snapshot and the quotation acceptance event. Both Buyer and Vendor history display that recorded selection. A new quotation's published terms have no Vendor-selected payment method, and an already published version is never rewritten. Older accepted orders retain their recorded method. Direct physical payment without NRPC displays Processing fee: Not applicable; online payments and physical payments requiring NRPC retain payment-channel fee selection.

## Changes

- API domain: `QuotationTerms.php` ignores legacy Vendor payment hints; `QuotationAcceptance.php` requires and revalidates the Buyer choice before stock/order writes; `QuotationService.php` returns current available choices plus the accepted order's method, records the choice in the acceptance event, and uses the order's actual payment state for Project package status.
- Transport: `ConversationController.php` validates the method enum and prohibits payment selection on non-acceptance actions. Missing selection is validated in the authorized acceptance use case; unauthorized callers do not gain acceptance access.
- Vendor: `ConversationThread.tsx` removes the fixed Online default and explains the Buyer choice; `quotation-draft.ts` strips old payment preferences before saving. Shared quotation cards in `packages/web-ui` display Pending Buyer choice or the accepted method.
- Buyer: the shared `QuotationPaymentChoices` component provides the fulfillment-specific options. `messaging_screen.dart` gates final acceptance and passes the explicit choice through `MessagingRepository`; shared quotation details show the recorded method after acceptance.
- Contract: `ChatDecision.payment_method` is required for accept and prohibited for other actions. `ChatQuotationVersion` adds optional `available_payment_methods` and `selected_payment_method`. Legacy `ChatDraftContent.payment_method` and `ChatQuotationContent.payment_method` are optional/deprecated. TS and Dart clients were regenerated; the complete Dart builders were regenerated with build_runner.
- Tests: extended API messaging coverage, Vendor draft/card tests, Buyer payment-choice interactions and saved method display, plus a Dart codec contract check.
- Workflows: recorded the owner's 2026-10-18 decision in the System, Buyer and Vendor workflow documents, superseding the older Vendor-selected quotation payment wording.

No database migration, credentials or new role/permission is required. Authorization, commercial hashes, tax and inventory revalidation, budget checks, immutable history, idempotency, NRPC Terms, existing order notifications and payment verification remain enforced. The changed method is part of the idempotency request hash; replaying the same key with a different method is rejected.

## Verification

| Location | Command/check | Final result |
| --- | --- | --- |
| `packages/api-contract` | `npm run generate` | Passed |
| `packages/api-contract/generated/dart` | `dart run build_runner build` | Passed; full builder layer restored, 2,284 outputs written |
| `packages/api-contract/generated/typescript` | `npm run build` | Passed |
| `packages/api-contract` | `npm run validate` | Passed; 8 unused-model recommendations |
| `packages/api-contract` | `npm run test:messaging-contract` | Passed; 40 authorized operations |
| `packages/api-contract` | `dart --packages=generated/dart/.dart_tool/package_config.json run scripts/check-quotation-payment.dart` | Passed; explicit choices, acceptance serialization, new Vendor drafts, historical snapshots |
| `packages/api-contract` | `dart --packages=generated/dart/.dart_tool/package_config.json run scripts/check-quotation-details.dart` | Passed |
| `apps/vendor-web` | `npm run lint` | Passed |
| `apps/vendor-web` | `npm run typecheck` | Passed |
| `apps/vendor-web` | `npm run test -- --run src/lib/messaging-patterns.test.tsx src/lib/quotation-draft.test.ts src/pages/FulfillmentConversationDialog.test.tsx --maxWorkers=1` | 48 tests passed, 3 files |
| `apps/vendor-web` | `npm run build` | Passed; existing large-chunk advisory |
| `apps/buyer-mobile` | `flutter analyze --no-pub lib test/quotation_details_test.dart test/messaging_layout_test.dart` | No issues found |
| `apps/buyer-mobile` | `flutter test --no-pub test/quotation_details_test.dart test/messaging_test.dart test/messaging_layout_test.dart test/chat_delivery_dialog_test.dart --name '^(?!capture inbox and conversation reference layouts)'` | 43 tests passed |
| Isolated API container | `php artisan test --compact --no-ansi --filter='PhaseNineMessagingTest\|PhaseElevenPaymentsTest'` | 39 tests passed, 1,011 assertions |
| Isolated API container | `php vendor/bin/phpstan analyse --memory-limit=512M --no-progress app/Domain/Messaging/QuotationTerms.php app/Domain/Messaging/QuotationAcceptance.php app/Domain/Messaging/QuotationService.php app/Http/Controllers/Api/ConversationController.php` | No errors |
| `services/api` | `php vendor/bin/pint --test app/Domain/Messaging/QuotationTerms.php app/Domain/Messaging/QuotationAcceptance.php app/Domain/Messaging/QuotationService.php app/Http/Controllers/Api/ConversationController.php tests/Feature/Api/PhaseNineMessagingTest.php` | Passed |
| Root | Isolated Compose `config --quiet` | Passed |
| Root | `gitleaks dir .quotation-payment-review --redact --no-banner --no-color` | Passed; no leaks across 37 scoped source, workflow, contract and model files |
| Root | Source review and trailing-whitespace scan | Passed for all 20 implementation/test files |

API verification used the separate disposable `materyalph_quotation_ui_test` database/network with the existing test guard enabled. Its PostgreSQL/cache services were stopped after verification. Development services and data were not migrated or changed.

An initial focused Dart builder run left the other generated builder files absent; a full build_runner run restored them before the final checks. Three new Flutter interaction tests needed a settled scroll frame before tapping off-screen buttons; the corrected explicit-choice tests passed. The final regression run excludes the existing stored reference-image capture. No baselines were refreshed, no device/browser E2E or live provider payment was performed, and the full repository suites were not run. No Git commands or deployments were used.

## Manual acceptance

Refresh Vendor and hot restart Buyer so the updated contract and required acceptance input are used together. Publish a Self-Pickup quotation; verify no method is chosen, select In-Store Payment or Online payment, and accept. Repeat with Site Delivery and COD/Online. Verify unavailable Vendor methods are disabled, a missing choice keeps Accept disabled, and both displays and Order Details show the accepted selection. Check an NRPC physical-payment quotation still requests its online assurance payment. Older accepted quotations must retain their original order/method.

Suggested commit: `feat(messaging): let buyers choose payment before quotation acceptance`.
