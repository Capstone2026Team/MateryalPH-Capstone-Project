# Quotation history modal and active Project inquiries

Quotation history opens above the Vendor and Buyer message threads. Closing it preserves the conversation and its unsent draft. Vendor uses the shared FormDialog, including when viewing a Project inquiry. Buyer uses the shared BuyerContentDialog with internal quotation list/detail navigation, retaining the current quotation summary layout, version details, older-page retry, decisions and accepted-order links.

Project inquiries now lists open quotation workflows only. The API filters before pagination and uses the same query for Project inquiry counts and unread badges: an authorized conversation for the current version of an undeleted, unassigned Active/Quotation Inquiry Work Package in an Active Project; quotation state Draft, Published, Viewed, Countered or Stock Revalidation Required. Published, Viewed and Countered deadlines must remain in the future, even before the expiry worker runs. Accepted, expired, rejected, withdrawn, old-version and closed-Project inquiries are excluded from this navigation list. Existing authorized conversation and commercial history is retained.

## Files and contract

- Vendor: `ConversationThread.tsx`, `ProjectInquiryDialog.tsx`, `FulfillmentConversationDialog.test.tsx`.
- Shared web UI: `packages/web-ui/src/project-inquiry-list.tsx`.
- Buyer: `messaging_screen.dart`, new `conversation_quotation_dialog.dart`, the embedded-list option in `conversation_quotations_screen.dart`, shared `buyer_overlays.dart`, `project_inquiry_list.dart`, and the affected cases in `messaging_layout_test.dart`.
- API: `ConversationService.php` and `PhaseNineMessagingTest.php`.
- Contract: `packages/api-contract/openapi.yaml`; regenerated TypeScript/Dart messaging API and ConversationView documentation/comments and generated Dart test scaffolds. Response fields and request parameters are unchanged; the Project inquiry list/count semantics are narrowed.
- Buyer and Vendor workflows record the owner's October 18 presentation/filter decision.

No migration, credentials, environment keys or development data changes are required. No new message, audit or notification mutation is introduced by opening a modal or listing inquiries. Existing role/assignment checks, protected attachments, server quotation actions and immutable history remain in place.

## Validation

| Check | Result |
| --- | --- |
| Isolated API PhaseNineMessagingTest + PhaseTenProjectsTest | 51 passed, 1,293 assertions |
| Active inquiry regression, both portals and retained history | 1 passed, 66 assertions |
| PHPStan, 512 MB | No errors |
| Pint, both touched PHP files | Passed |
| Vendor lint / typecheck / production build | Passed; build retains the large-chunk advisory |
| Vendor focused messaging/component suites | 24 passed, 2 files |
| Buyer analysis after modal integration | No issues |
| Buyer messaging, Project inquiry and repository behavior suites | 41 passed, 4 files; reference-image capture excluded |
| OpenAPI validation | Passed, 8 unused-model recommendations |
| Messaging contract | 40 authorized operations passed |
| Generated TypeScript build | Passed |
| Development and isolated Compose configuration | Passed |
| Scoped source/generated secret scan | 24 files; no source secrets found |
| Source whitespace / conflict review | No trailing whitespace or conflict markers; reviewed-file hashes checked for concurrent changes |

API tests used a separate disposable PostgreSQL test stack because another run held locks in the usual isolated database. No other run's processes or database sessions were terminated. Only this task's blocked test attempt was stopped.

The Buyer reference-image capture test reports stored inbox, conversation and empty-inbox snapshot mismatches. Reference images were left unchanged; the final behavior run excludes `capture inbox and conversation reference layouts`. No live browser, phone, provider or full-repository gate is represented as passed.

Relevant commands:

```text
php artisan test --compact --no-ansi tests/Feature/Api/PhaseNineMessagingTest.php tests/Feature/Api/PhaseTenProjectsTest.php
vendor/bin/pint --test app/Domain/Messaging/ConversationService.php tests/Feature/Api/PhaseNineMessagingTest.php
vendor/bin/phpstan analyse --memory-limit=512M --no-progress
flutter analyze --no-pub
flutter test --no-pub test/messaging_layout_test.dart test/project_inquiries_test.dart test/messaging_test.dart test/messaging_api_test.dart --name '^(?!capture inbox and conversation reference layouts)'
npm run test -- --run src/pages/FulfillmentConversationDialog.test.tsx src/lib/messaging-patterns.test.tsx --maxWorkers=1
npm run lint
npm run typecheck
npm run build
npm run validate
npm run test:messaging-contract
```

## Manual acceptance

Refresh Vendor and hot-restart Buyer. Open quotation history from an Item inquiry and a Project inquiry; verify a modal, quotation details/history actions, keyboard/back/close behavior and preservation of the underlying draft. Load older Buyer quotations and verify refresh retains an open version. Check that only current open quotation workflows appear in Project inquiries and that accepting/closing one removes it on refresh while its authorized history remains readable through existing order/Project history routes.

Suggested commit: `fix(messaging): show quotation history in modals and filter active inquiries`.

## Buyer modal return button removal

The October 18 follow-up removes the orange Back control from Quotation details inside the history modal. The shared Buyer header has an optional `showBackButton` flag, defaulting to true. Both modal entry routes pass the embedded state to details, while ordinary pushed pages retain their existing navigation. The modal's X close control, quotation actions and underlying message draft remain intact.

Files: `buyer_app_bar.dart`, `conversation_quotations_screen.dart`, `conversation_quotation_dialog.dart`, and the existing modal regression in `messaging_layout_test.dart`. No API, migration, authorization, notification or configuration changes are required.

The focused existing modal test passed (1 test), including absence of the modal Back control, closing and draft preservation. `flutter analyze --no-pub lib` passed with no issues. Formatting and a four-file scoped Gitleaks/source review passed. Full `flutter analyze --no-pub` currently reports three unrelated undefined `rebalanceRankingWeights` references in `test/projects_authoring_test.dart` at lines 298, 309 and 316. No Project authoring source/test file was edited by this follow-up. Phone acceptance remains manual; hot-restart Buyer to load the change.

Suggested commit: `fix(buyer): remove return button from quotation modal`.

## Buyer request-changes dialog layout

The Request changes dialog now separates the quotation context from the input, keeps the field label at the top, supplies a short hint and places Cancel/Send request in Material's compact action footer. The footer falls back to its native overflow layout when space is limited. The existing three-character minimum and 2,000-character maximum are unchanged.

`BuyerDialog.fullWidthActions` defaults to the existing full-width layout; only this counter-offer form opts into compact actions. `messaging_screen.dart` also uses the shared `showBuyerFormDialog` helper so controllers are disposed after the closing animation. The helper's new optional barrier flag preserves this form's existing outside-tap dismissal behavior. Cancellation with the keyboard open no longer uses a disposed controller.

Files: `buyer_overlays.dart`, `form_dialog.dart`, `messaging_screen.dart`, and the existing modal regression in `messaging_layout_test.dart`. No API, migration, authorization, notification or configuration changes are required.

Validation: `flutter analyze --no-pub lib` passed; 35 tests passed across `messaging_layout_test.dart`, `messaging_test.dart` and `chat_delivery_dialog_test.dart`, excluding the stored reference-image capture test. The modal regression checks validation, reachable Send request with a 300-pixel keyboard inset, cancellation and preservation of the underlying draft. Formatting and the four-file secret/source review passed. Physical-phone acceptance remains manual; hot-restart Buyer and reopen Counter-offer.

Suggested commit: `fix(buyer): tidy quotation request dialog layout`.
