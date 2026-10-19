# Messaging quotation threads — 2026-10-18

Vendor Messages now places compact published quotation entries between messages at their original publication time, matching the Buyer thread pattern. Each entry opens the full immutable terms. Buyer change requests show the exact recorded text, request time and active Vendor response deadline in Asia/Manila. Authorized sales users can revise through the existing quotation editor; Customer Service retains draft-only authority. Quotation history and accepted-order navigation remain available through the quotation details.

Buyer mobile no longer repeats an Open Order Details button above the thread for each accepted quotation. The appropriate accepted order remains accessible inside that quotation's details.

Loaded Vendor quotation pages survive polling and realtime refresh, including an open historical quotation. Refresh preserves composer drafts and does not force readers of older messages to the bottom. Messages and quotations share dated timeline groups. A counter-offer displays the Vendor response timer rather than continuing the ended Buyer timer.

## Files and contract

- `services/api/app/Domain/Messaging/QuotationService.php`: batch-project existing counter-offer records onto the authorized, paginated quotation versions. No message-text parsing or client-calculated deadline.
- `packages/api-contract/openapi.yaml`: optional `requested_changes`, `change_requested_at`, and `vendor_response_due_at` on `ChatQuotationVersion`. Fields are absent for versions with no counter-offer; historical versions retain their recorded request after revision.
- Generated TypeScript model/documentation and Dart model, serializer, model-test scaffold and documentation for `ChatQuotationVersion` were regenerated. Six generated source/documentation files changed; no manual serializer edits.
- `packages/web-ui/src/conversation-timeline.ts`, `messaging-patterns.tsx`, and `index.ts`: shared chronological entries, compact quotation card, recorded request presentation, state labels and correct active deadline.
- `apps/vendor-web/src/pages/ConversationThread.tsx`: inline quotation entries, detail dialog, authorized revision actions and retained paginated history.
- `apps/buyer-mobile/lib/features/messaging/messaging_screen.dart`: remove the repeated top-of-thread accepted-order actions.
- Regression coverage: `services/api/tests/Feature/Api/PhaseNineMessagingTest.php`, `packages/api-contract/scripts/check-messaging-contract.mjs`, `apps/vendor-web/src/lib/messaging-patterns.test.tsx`, `apps/vendor-web/src/pages/FulfillmentConversationDialog.test.tsx`, `apps/buyer-mobile/test/messaging_test.dart`, and `apps/buyer-mobile/test/messaging_layout_test.dart`.

No migration, development-data modification, dependency upgrade, credential setup or deployment is required. Existing quotation mutations, immutable content hashes, state transitions, locks, inventory holds, audit records and notification/broadcast invalidations remain unchanged. Conversation authorization still runs before reading the request data. The API tests cover outsider and Fulfillment-role denial, retry idempotency and preservation of the request after revision. Controls use the server's current drafting capability and version actions; the server continues to authorize every mutation.

## Validation

| Check | Result |
| --- | --- |
| Isolated API guard and negative isolation checks | Passed |
| `php artisan test --compact --filter=PhaseNineMessagingTest` in isolated `api-test` | 40 passed, 1,039 assertions |
| `vendor/bin/pint --test` in isolated `api-test` | Passed, 769 files, after formatting the changed service |
| `vendor/bin/phpstan analyse --memory-limit=512M` in isolated `api-test` | Passed, 530 files, no errors |
| Vendor `npm.cmd run lint`, `npm.cmd run typecheck`, `npm.cmd run build` | Passed |
| Vendor `npm.cmd run test -- --run src/lib/messaging-patterns.test.tsx src/pages/FulfillmentConversationDialog.test.tsx --maxWorkers=1` | 43 passed, 2 files |
| Admin `npm.cmd run lint`, `npm.cmd run typecheck`, `npm.cmd run build` | Passed |
| Contract `npm.cmd run validate` | Passed, 8 existing unused-model recommendations |
| Contract `npm.cmd run test:messaging-contract` | Passed, 40 authorized operations |
| `npm.cmd run generate`, generated TypeScript `npm.cmd run build`, generated Dart `dart run build_runner build --delete-conflicting-outputs` | Passed; Dart reports the obsolete delete flag ignored |
| Buyer `flutter analyze` | Passed, no issues |
| Buyer `flutter test --no-pub test/messaging_test.dart test/messaging_layout_test.dart test/messaging_realtime_test.dart test/messaging_api_test.dart --name '^(?!capture inbox and conversation reference layouts)'` | 42 passed |
| Regular and isolated Docker Compose `config --quiet` | Passed |
| Scoped filesystem Gitleaks scan of changed source/generated files | Passed, no leaks |
| Source comparison against the pre-edit snapshot | Reviewed; no introduced trailing whitespace or invalid encoding |

Docker checks used `C:\Users\RJ\AppData\Local\Programs\DockerDesktop\resources\bin\docker.exe` with `compose --env-file services/api/.env.testing -f compose.test.yaml -p materyalph_phase1_test exec -T api-test`. Flutter/Dart checks used the installed SDK under `C:\Users\RJ\Documents\flutter\bin` with access to its user caches. The sandbox initially denied the caches; the successful checks ran with that access. No credentials were printed or copied into the report.

## Existing screenshot gate and unverified acceptance

The initial focused Flutter run included the golden test `capture inbox and conversation reference layouts`. It failed against the stored inbox, conversation and empty-inbox images. A separate baseline-only run used copies of the original screen and test captured before editing and reproduced all three differences: inbox 5.52%, conversation 36.66%, and empty inbox 6.82%. The temporary baseline copies were removed and no golden images were updated. The final behavior run explicitly excludes that one already failing screenshot test.

Both web builds retain the existing large-chunk advisory. Full-repository test suites, live two-account Reverb behavior, browser visual acceptance and physical-phone acceptance were not performed. No APK was built or installed.

## Manual acceptance

1. Reload Vendor and restart the Buyer app with the updated code. Open the same Item-Based sales conversation in both accounts.
2. Publish a quotation. Confirm its compact entry appears in the Vendor thread at the publication time and opens the materials, specifications, payment breakdown and change notes.
3. In Buyer, request changes with multiple lines of text. Confirm Vendor receives the request through the existing live refresh or polling, displays the exact text and Vendor deadline, and offers Revise quotation to an authorized sales user.
4. Revise and republish. Confirm the new version appears, the previous version retains its recorded request, and the active response timer returns to the Buyer deadline.
5. Accept a quotation and open its details in Buyer. Confirm one appropriate Open Order Details action is present there and no repeated accepted-order actions are stacked above the message timeline. Repeat with another accepted quotation in the same permanent conversation.
6. Load earlier quotations, keep a historical version open, and receive a new message. Confirm the historical detail and unsent draft remain available. Repeat in a Project inquiry and confirm Fulfillment conversations remain separately scoped.

Suggested commit: `fix(messaging): show quotations and buyer change requests in threads`.
