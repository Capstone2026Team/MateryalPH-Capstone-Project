# Quotation product details and payment layout

Buyer Flutter and Vendor web quotation history now use the same content order and labels: Materials, Payment breakdown, then Fulfillment & payment. Each quoted material shows its saved brand, variant and technical specifications with wrapping detail chips. Quantity formatting removes trailing zeroes, and peso amounts use grouping and two decimal places. A quotation whose technical details were never recorded shows a short explanation.

Payment rows separate materials, actual Vendor discounts, included materials VAT, delivery and the total before processing fee. Discount assessments retain their materials/delivery scope; delivery discounts show their saved gross basis, deduction and net charge. Zero discounts are omitted. VAT is explicitly identified as included, and a positive NRPC is identified as already included in the total. The processing fee remains Pending until payment-channel selection. Fulfillment method, date and payment method have separate labeled rows. Mobile amounts align beside labels when space allows and stack when text scaling or a long amount requires more room. The repeated Viewed status is removed.

## Files and contract

- `packages/web-ui/src/quotation-details.tsx`: reusable material and payment sections.
- `packages/web-ui/src/messaging-patterns.tsx`: shared quotation card integration.
- `apps/buyer-mobile/lib/design_system/components/quotation_details.dart`: Flutter design-system material/payment sections, using existing specification chips and peso formatting.
- `apps/buyer-mobile/lib/design_system/components/messaging_components.dart`: Buyer quotation card integration; retains its existing delivery-plan details, deadline, change summary and authorized actions.
- `packages/api-contract/openapi.yaml`: optional `ChatQuotationLine.brand`, `variant_label`, `specifications` and `ChatQuotationMoney.materials_gross_centavos`. These fields already exist in server snapshots; this declares them so the clients retain them. Existing required properties and endpoints are unchanged.
- `packages/api-contract/generated/{typescript,dart}`: generator-owned models, documentation and scaffolds refreshed with the repository generator; Dart builders rebuilt for the two changed models. No generated serializer was edited manually.
- `packages/api-contract/scripts/check-messaging-contract.mjs`, `scripts/check-quotation-details.dart` and `package.json`: optional-field contract and codec regression checks.
- `apps/vendor-web/src/lib/messaging-patterns.test.tsx`, `apps/buyer-mobile/test/quotation_details_test.dart`: snapshot rendering, historical compatibility, scoped discounts, VAT/NRPC inclusion and narrow/large-text checks.
- `services/api/tests/Feature/Api/PhaseNineMessagingTest.php`: both portals retain published technical details and the content hash after current catalog details change.

No migration or production API implementation changed. Authorization, action availability, idempotency, immutable quotation records, calculation rules, audit events and notifications retain their existing behavior. The UI reads saved integer amounts and product details; it does not rebuild historical terms from current listings or calculate a new payable total. No credentials, key names or server setup are required.

## Validation

Commands below use the installed SDKs on PATH unless a package configuration is explicitly shown.

| Location | Command | Final result |
| --- | --- | --- |
| `packages/api-contract` | `npm run generate` | Passed; TS and Dart regenerated |
| `packages/api-contract/generated/dart` | `dart run build_runner build --build-filter=lib/src/model/chat_quotation_line.g.dart --build-filter=lib/src/model/chat_quotation_money.g.dart` | Passed; 4 outputs written |
| `packages/api-contract/generated/typescript` | `npm run build` | Passed |
| `packages/api-contract` | `npm run validate` | Passed; 8 unused-model recommendations |
| `packages/api-contract` | `npm run test:messaging-contract` | Passed; 40 authorized operations |
| `packages/api-contract` | `dart --packages=generated/dart/.dart_tool/package_config.json run scripts/check-quotation-details.dart` | Passed; saved details, historical omissions, empty PHP map/array forms and integer amounts |
| `packages/api-contract` | `dart --packages=generated/dart/.dart_tool/package_config.json run scripts/check-quotation-discount.dart` | Passed |
| `apps/vendor-web` | `npm run lint` | Passed |
| `apps/vendor-web` | `npm run typecheck` | Passed |
| `apps/vendor-web` | `npm run test -- --run src/lib/messaging-patterns.test.tsx src/lib/quotation-draft.test.ts src/pages/FulfillmentConversationDialog.test.tsx --maxWorkers=1` | 46 tests passed, 3 files |
| `apps/vendor-web` | `npm run build` | Passed; large-chunk advisory remains |
| `apps/buyer-mobile` | `flutter analyze --no-pub lib test/quotation_details_test.dart` | No issues found |
| `apps/buyer-mobile` | `flutter test --no-pub test/quotation_details_test.dart test/messaging_test.dart test/messaging_layout_test.dart test/chat_delivery_dialog_test.dart --name '^(?!capture inbox and conversation reference layouts)'` | 39 tests passed |
| Disposable isolated API container | `php artisan test --compact --no-ansi --filter='test_both_portals_keep_published_product_details_after_the_listing_changes\|test_versions_are_immutable_soft_holds_do_not_reserve_and_stale_acceptance_is_recoverable'` | 2 tests passed, 52 assertions |
| `services/api` | `php vendor/bin/pint --test tests/Feature/Api/PhaseNineMessagingTest.php` | Passed |
| `services/api` | `php -l tests/Feature/Api/PhaseNineMessagingTest.php` | No syntax errors |
| Root | `docker compose --env-file services/api/.env.testing -f compose.test.yaml -p materyalph_quotation_ui_test config --quiet` | Passed |
| Root | `gitleaks dir .quotation-details-review --redact --no-banner --no-color` | Passed; no leaks in 17 scoped source/contract/model files |
| Root | Source review and trailing-whitespace check of those 17 files | Passed |

The API tests ran on the separate `materyalph_quotation_ui_test` network/database using the existing isolated-test dependencies and Passport keys. The test environment guard remained enabled. Its disposable PostgreSQL/cache services were stopped afterward; development services/data were not changed.

An initial Flutter run included the untagged stored reference-image capture, which failed comparisons for inbox, conversation and empty-inbox images. Those baselines were not refreshed; the final focused run explicitly excludes that capture. Initial new assertions were corrected to account for repeated values in separate payment/change-summary rows, and a new API test was corrected to use the existing conversation endpoint. All final commands listed as passed completed successfully.

Full-repository suites, browser/device E2E and live provider checks were not run. No Git commands, pushes, deployments or development database migrations were performed.

## Manual acceptance

1. Refresh Vendor and hot restart Buyer; open the same quotation from Quotation history on both.
2. Check the saved brand, variant and technical specifications beneath each material. A later catalog edit must not alter an already published version.
3. Review Self-Pickup and Site Delivery quotations, a materials discount, a delivery discount, and an NRPC example. VAT and NRPC must remain included in the recorded total; no processing fee is invented.
4. Check older versions, long specification values and mobile text scaling. Older versions without saved details retain their historical terms and the missing-details explanation.

Suggested commit: `fix(messaging): align quotation details and payment breakdowns`.
