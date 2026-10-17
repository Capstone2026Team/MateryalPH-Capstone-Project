# Checkout Project links and invoice details — 2026-10-15

Checkout now selects an owned Active Project and open Work Package through the existing paginated Project API. Each submitted Vendor order remains Item-Based and links to the selected Work Package version. Linking contributes pending confirmations and, after acceptance, spend to the existing FIN-11 budget calculation. It neither selects the Project Vendor nor marks missing lines fulfilled. Delivery remains the checkout selection.

The shared invoice form follows the supplied Personal/Business, basic information, address, disclaimer and consent design. Checkout retains a billing draft and saves it atomically with every submitted child order. Order Details uses the same form for billing edits and actual copy/correction requests. Requests retain the existing confirmed-sale gate and three-business-day service target. No default billing profile is created.

## Files and API

- Buyer: `lib/features/item_procurement/checkout_project_screen.dart`, `checkout_preview_screen.dart`, `checkout_previews.dart`, `procurement_navigation.dart`; `lib/design_system/components/invoice_request_form.dart`; `lib/core/invoice_billing_input.dart`; `lib/features/disputes/dispute_screens.dart`; `lib/features/orders/orders_repository.dart`; `lib/screens/buyer_home_screen.dart`.
- API: `OrderSubmissionService`, `BuyerOrderController`, `ProjectBudget`, `AutoAcceptService`, `OrderConfirmationService`, `OrderQueries`.
- Contract: `packages/api-contract/openapi.yaml`, generated TypeScript/Dart models and serializers, `scripts/check-orders-contract.mjs`.
- Tests: `CheckoutOptionsTest.php`, `checkout_options_contract_test.dart`, updated Orders fake signature.

`POST /api/v1/buyers/checkouts` adds optional `work_package_id`, `work_package_lock_version`, `budget_override_reason` and `invoice_details` (`billing_name`, `billing_address`, optional `tin`). Changed options participate in the idempotency request hash. Existing clients may omit every new field. No migration or new configuration key is required.

Ownership and Active Project/open Work Package checks run on the server with version checks and Project-before-package locks. Invalid billing, stale links and missing budget overrides roll back the whole submission. Auto-accept and unchanged manual confirmation recheck the budget; an over-budget confirmation requires Buyer approval through the existing override form. TIN storage remains encrypted and Buyer responses masked. Item-Based Vendors do not receive the linked Work Package contents.

## Verification

- Final isolated `CheckoutOptionsTest.php`: **4 passed, 123 assertions**. Covers multiple Vendors, billing privacy, replay/body conflict, foreign/stale/closed links, invalid/empty billing, budget rollback, auto-accept, final approval and Vendor Project privacy.
- Existing related API regressions: **49 passed** across `PhaseEightOrdersTest.php`, `PhaseTenProjectsTest.php` and `PhaseThirteenDisputesTest.php`. The initial combined run had 52 passes and one new-test failure caused by an incorrect approval URL in the test; the corrected four-test checkout suite passed afterward.
- Buyer non-UI tests: **5 passed** across `checkout_options_contract_test.dart`, `order_detail_contract_test.dart`, `messaging_api_test.dart`.
- `flutter analyze --no-pub`: **no issues found**.
- PHPStan: **no errors**. Pint: **7 changed PHP files passed**.
- OpenAPI validation passed with eight unused-model recommendations. Orders, Projects (25 operations) and disputes/invoices (58 operations) contract checks passed.
- Vendor and Admin TypeScript typechecks passed.
- Scoped Gitleaks scan of 28 changed source/generated files: **no leaks**; whitespace check: **no findings**. Compose configuration validated without displaying environment values.

API tests used an independent `materyalph_checkout_options_test` Compose project because another run was resetting the shared isolated database. The development database was not modified. An initial Buyer compilation hit a transient temporary-disk-space error; the rerun passed. No browser/device or UI/E2E test was performed.

## Manual acceptance

1. Checkout → Project Procurement: choose Project and Work Package; return, change or remove the link. Check empty/loading/retry and multiple pages.
2. Request E-Invoice: enter Personal or Business billing, optional TIN, address and consent; return and reopen to confirm the draft. Remove it if no longer needed.
3. Submit multiple ready Vendors. Verify each resulting Item-Based order shows the Project context to the Buyer and the saved masked billing details in Order Details. Verify pending confirmations/spend in Project budgets.
4. Exceed the budget: enter a written override at checkout, then verify final approval rechecks the deficit. Existing prices, delivery and payment behavior continue normally.
5. Once the sale is confirmed, request an invoice copy or correction from Order Details using the shared form. Verify request status and authorized Vendor visibility. Check keyboard scrolling and larger text on the connected phone.

Suggested commit: `fix(buyer): connect checkout project links and invoice details`.

## Follow-up: Project Procurement tap

The checkout tap previously returned silently when its optional Projects dependency was absent. Checkout now falls back to the Projects service exposed by its Orders repository, sharing the existing authenticated API client and session guard. A missing service displays an inline error and Retry action. This also covers checkout routes retained by an older navigation instance.

Changed `checkout_preview_screen.dart`, `orders_repository.dart`, `projects_repository.dart`, the Orders test fake and `checkout_options_contract_test.dart`. The two non-UI checkout tests passed, including Project bearer authentication and genuine 401/session-expiry handling; all five Dart files passed formatting and the scoped secret scan found no leaks. No API contract, migration or credential changes. Device interaction remains manual; perform a full Flutter hot restart and reopen Checkout when loading these changes.

Suggested follow-up commit: `fix(buyer): restore checkout project selection`.

Final follow-up static check: `flutter analyze --no-pub` passed with no issues (103.2 seconds).
