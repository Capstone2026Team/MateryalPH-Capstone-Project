# Unified inquiry inbox — 2026-10-15

One inbox entry per Buyer/Store opens the Item-Based conversation. Project inquiries inside the thread lists authorized Work Package conversations. Vendor uses a dialog over the mounted main thread; Buyer uses nested navigation. Returning preserves the item draft. Work Package references, quotations, attachments, messages and read receipts remain in their original conversations. Direct project links and notifications continue to open that project's context.

## Files and contract

- API: `ConversationService.php`, `ConversationBroadcast.php`, `ConversationController.php`, `routes/messaging.php`.
- New data migration: `2026_10_15_000000_add_main_store_threads_for_project_inquiries.php`. Adds empty Item-Based main threads only for project-only pairs with an active Owner, with Buyer/Owner participants and handler assignment. Retains prior activity timestamps and a fully archived Buyer's archive state. Running it again adds nothing. Rollback retains the conversations because they may acquire immutable commercial history. No existing migration was edited.
- OpenAPI: `GET /{buyers|vendor}/conversations/{conversationId}/project-inquiries`, paginated at 25. `ConversationView` adds optional `main_conversation_id`, `project_inquiry_count`, `project_unread_count`, and `inquiry_label`. Inbox preview/activity/unread counts aggregate authorized sales conversations before pagination. Detail and read endpoints stay conversation-specific. Archive/restore applies to the personal sales group. TS/Dart clients and Dart serializers were regenerated.
- Vendor: `MessagingPage.tsx`, `ConversationThread.tsx`, new `ProjectInquiryDialog.tsx`, `messaging-api.ts`; shared `project-inquiry-list.tsx`, `messaging-patterns.tsx`, and `index.ts`. Updated component regressions and the existing E2E label assertions.
- Buyer: messaging repository/screen, new `project_inquiries_screen.dart`, new design-system `project_inquiry_list.dart`; repository, fake-repository and project-navigation tests.
- Buyer/Vendor workflow addenda record this requested navigation change.

## Authorization and side effects

Every project list, aggregate count/preview and main-thread reference is restricted to current Buyer ownership or Vendor organization/role/handler participation. Staff without main-thread access use their oldest authorized project as the inbox entry. Transfers/revocations cannot expose sibling projects. Fulfillment access and order-specific history stay separate. No commercial records are merged or moved, and no messages are sent by opening the picker. Project creation remains in the existing Work Package flow.

Project activity refreshes the main badge through the existing post-commit outbox and current-authority Reverb channels. A viewer must have access to both conversations to receive the additional main-thread invalidation. Socket payloads contain no message content. Buyer does not mark a covered main thread read while navigating a project. Existing attachments, scanner checks, immutable snapshots, provider boundaries and notifications remain intact. No credentials or configuration keys are added.

## Validation

| Check | Result |
| --- | --- |
| Isolated API `PhaseNineMessagingTest.php` + `PhaseTenProjectsTest.php` | 48 passed, 1,173 assertions |
| PHPStan | No errors |
| Pint, seven touched PHP files | Passed |
| Vendor focused messaging component suites | 22 passed |
| Buyer repository, quotation, realtime and project-picker suites | 8 passed |
| Existing Buyer messaging interaction regressions, visual capture excluded | 22 passed |
| Flutter analysis | No issues |
| Vendor lint/typecheck/build | Passed |
| Admin lint/typecheck/build | Passed |
| Generated TypeScript build | Passed |
| OpenAPI validation | Passed, eight existing unused-model recommendations |
| Messaging contract / Project contract | 37 / 25 authorized operations passed |
| Development and isolated Compose configuration | Passed |
| Scoped Gitleaks directory scan | 29 changed source/generated files, zero findings |
| Whitespace/conflict review | 26 source/test/workflow files passed; no Git commands used |

Portal builds retain large-chunk advisories. The focused checks above do not establish live browser/device, network, provider or scanner behavior. No browser/device E2E test was run; existing golden reference captures were not refreshed.

The full Vendor run completed with **504 passed / 6 failed** (56 files). All six failures are in `OrderPages.test.tsx`: two document-link/date assertions, Customer Service confirmation, NRPC reason validation, and two fulfillment popup/document-link assertions. Its Order documents link assertions encounter the existing Export PDF control; no order page or order test was changed by this work. The full Admin run completed with **116 passed / 1 failed** (23 files): `ProductCompliancePages.test.tsx` expects exactly one photo fetch but observes two. Its focused rerun also failed (four passed / one failed; three fetches). No Admin page or test was edited. These broader gates remain unresolved; the full suites are not represented as passed.

After explicit user approval, the single development migration completed successfully (**5.90 ms**, migration batch **44**, status **Ran**). Read-only checks before and after show **zero** Buyer/Store pairs lacking a main Item-Based conversation. Existing histories therefore needed no backfill records. Only the reviewed migration was run:

```powershell
& 'C:\Users\RJ\AppData\Local\Programs\DockerDesktop\resources\bin\docker.exe' compose exec -T api php artisan migrate --path=database/migrations/2026_10_15_000000_add_main_store_threads_for_project_inquiries.php --force
```

Reload the Vendor portal and hot-restart/rebuild the Buyer app to load the changed clients. No manual key setup is required.

## Manual acceptance

1. Open Messages on both Buyer and Vendor accounts with item and project history for the same Store. Confirm one row and that it opens Item inquiry.
2. Open Project inquiries, choose a Work Package, send/read a message, inspect its locked original and quotation history, and return. Confirm the item draft survives and only the read project's unread count changes.
3. Verify project activity updates the root badge/preview, including reconnect recovery; archive/restore the entire Buyer group and verify a new project message restores it.
4. Verify an assigned staff account cannot discover another handler's project/main conversation, and fulfillment history retains its separate access.
5. For old project-only pairs in another environment, apply the narrow migration with development-data approval, then confirm an empty main item thread and unchanged project history. An organization without an active Owner retains the authorized project fallback until it has an active Owner/main conversation.

Suggested commit: `feat(messaging): group item and project inquiries in one inbox thread`.
