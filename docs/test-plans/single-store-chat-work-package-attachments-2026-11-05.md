# One store chat with Work Package message attachments

Owner correction implemented locally on 5 November 2026. This replaces the rejected reply-subject selector. The Vendor header's **Fulfillment conversations** button, unread badge and existing order-list/message popup are retained.

## Result

- One Buyer/Store inbox row and one ordinary composer. No Choose reply subject modal or separate Project Inquiries category.
- Buyer Message actions on Work Package quotation options and arrangements open the existing store chat and post a compact package attachment, like a product card. Opening messages never detaches or changes an order.
- The package card opens the locked original and can open its authorized quotation editor directly. Quotation decisions and private file downloads retain their original source IDs.
- The normal chat remains writable after a linked order closes or is cancelled. Dedicated fulfillment views retain their existing order-specific read-only rules and staff permissions.
- Fulfillment conversations opens from the main Vendor chat header. Closing its popup preserves the chat draft and scroll position. Order Details also retains its fulfillment-message entry point.
- Buyer inbox grouping, ordinary sends, typing, uploads, archive/restore and live refresh use the normal chat automatically. Existing messages and immutable commercial history are not moved or deleted.
- The static bot retains the shared 24-hour Buyer/Store cap and manual takeover. Consumed quick-reply buttons from historical package messages are disabled correctly in the combined Buyer view.

## Implementation and contract

The principal files are:

- API: `WorkPackageChatAttachment.php`, `ConversationService.php`, `VendorBuyerThread.php`, `ConversationController.php`, `BuyerProjectController.php`, and `routes/messaging.php`.
- Vendor: `MessagingPage.tsx`, `ConversationThread.tsx`, shared `messaging-patterns.tsx`; the reply-subject component/export was removed.
- Buyer: `projects_repository.dart`, `project_arrangement_screen.dart`, `messaging_repository.dart`, `messaging_screen.dart`, and shared `messaging_components.dart`.
- OpenAPI, regenerated TypeScript/Dart clients, contract checks, regression tests, owner decisions in workflows and the UI planner.

Additive migration `2026_11_05_124000_attach_work_packages_to_chat_messages.php` adds nullable inquiry/order source foreign keys and an immutable JSON snapshot to messages. Restrictive foreign keys and checks require exactly one source for an attachment snapshot. The migration ran from the empty isolated test schema and on the existing local development database. Local queue/scheduler workers were restarted. No remote migration, deployment or new secret/key setup was performed.

| API under `/api/v1` | Behavior |
| --- | --- |
| `POST /buyers/conversations/{conversationId}/work-package-attachment` | Share an authorized package inquiry in the normal store chat; Idempotency-Key required |
| `POST /buyers/orders/{orderId}/work-package-message` | Open the authorized order's normal store chat and attach its package; Idempotency-Key required; preserves the order |
| `GET /buyers/conversations/{conversationId}?store_thread=true` | Read the authorized sales history in the store chat; raw reads remain compatible when the option is absent |

`ChatMessage` supports kind `WORK_PACKAGE` and optional `work_package_attachment`. Its fields include the locked reference, source inquiry/order IDs, order lock version and server-assessed quotation capability. Inquiry creation retains its existing `id` and additionally returns `store_conversation_id` for navigation. The old context-list endpoint remains deprecated for compatibility; the UI does not use it as a picker.

Every share operation authenticates the Buyer and authorizes the original package inquiry or order. Another Buyer's source is rejected. Vendors cannot submit Buyer share mutations. Staff assignment and role scopes still govern history, quotation editing, fulfillment and private files. Commercial corrections retain immutable quotation/order records; the earlier pending-only quotation replacement and cancelled-package reopening rules remain in force.

## Verification

| Check | Executed result |
| --- | --- |
| Full isolated API gate | 835 passed, 17,023 assertions; one reporting warning described below |
| Empty/current schema and isolation guards | Passed; additive local migration passed |
| Full Pint | 873 files passed |
| PHPStan | No errors |
| Final API regression after the bot-option projection correction | 3 passed, 93 assertions; full Pint and PHPStan repeated successfully |
| Restored fulfillment and unified-chat component suite | 19 passed |
| Browser chat/attachment/quotation/settings/fulfillment journeys | 6 passed at Chromium widths 320, 390 and 1440 |
| Buyer focused messaging, attachments and quotations | 55 passed; subsequent final transport file 2 passed, including the added package/order sharing test |
| Flutter analysis | No issues found |
| Vendor lint/typecheck/build | Passed; existing unused `inStore` lint warning and bundle-size advisory |
| Admin lint/typecheck/build | Passed; existing bundle-size advisory |
| OpenAPI validation | Passed with eight unused-model recommendations |
| Messaging contract | 50 authorized operations passed |
| Generated TypeScript build and Dart serializers | Passed |
| Scoped redacted secret scans and staged scan | No leaks found; no staged bytes |
| Diff whitespace and Compose configuration | Passed |

The full Vendor run passed 781 tests and hit a timeout in the Store Email test, followed by a dependent fixture failure. Re-running that complete navigation file passed all 96 tests. An earlier full run hit a Vite/attachment timeout during concurrent checks; its focused recheck passed all 20 tests. The full Admin run passed 281 tests and timed out in its Vite configuration test; the focused recheck passed. These are reported separately from a clean single complete portal run. No unrelated production code or test timeout was changed.

The full API warning is the existing `TabularDocumentRendererTest` stream-inspection `gzuncompress()` warning. The final aggregate bot-option query is covered by the additional focused API regression run after the complete gate. Full Buyer goldens were not regenerated or rerun for this correction.

Browser checks use synthetic fixtures, not live account or physical-device acceptance. The final desktop screenshot is `docs/design/evidence/vendor-buyer-thread/combined-timeline.png`; it includes the restored Fulfillment conversations button. The UI and attachment layouts were visually inspected at desktop and mobile widths. Manual two-account Buyer/Vendor acceptance remains outstanding.

Ignored logs are under `services/api/storage/logs/single-chat-*.log`. Suggested commit: `fix(messaging): attach work packages to the store chat and retain fulfillment access`.
