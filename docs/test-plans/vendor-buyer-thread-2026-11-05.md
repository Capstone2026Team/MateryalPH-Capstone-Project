# One Vendor thread per Buyer

Implemented and verified locally on 5 November 2026. This follows the owner's explicit choice of **one combined timeline**, rather than a Buyer entry with separate conversation views. No push, merge or deployment was performed.

## Superseded interaction

The reply-subject selector and pinned selected subject below were rejected by the owner. The current implementation uses a normal store chat with message attachments; see [the corrected flow](single-store-chat-work-package-attachments-2026-11-05.md). Earlier results below describe the prior implementation only.

## Prior result

- The Vendor Inbox groups by the opaque Buyer profile and current store **before pagination**. A Buyer with many Work Packages or orders has one row, one latest activity preview and an aggregate authorized unread count. Two different Buyer accounts are never merged just because their names match.
- That row opens a combined chronological timeline of authorized general inquiries, Work Package inquiries, quotation versions and fulfillment/order messages. Small labels identify the original subject of each message group.
- **Reply about** selects the subject for the next message, attachment or quotation. The combined timeline stays visible. The chosen Work Package stays pinned above messages, and unsent drafts survive changing reply subjects. A newer sibling message updates the same Buyer row without changing the current reply subject or losing the draft.
- Messages, published quotations, order snapshots, sender attribution, private files, handler assignments and read receipts keep their original records and IDs. Selecting a subject cannot change or detach an order. Closed fulfillment contexts remain read-only; the existing authorized general inquiry remains selectable, including when it has no messages yet.
- Owner/Manager oversight and current staff assignment restrictions are enforced by the server. A staff member sees only their own authorized contexts. After a transfer, a changed authorized-context epoch clears previously retained client pages. Downloads and receipts use each message's original context, not whichever reply subject is selected.
- The rule-based bot now shares its rolling 24-hour welcome cap across the Buyer/store pair. A manual reply in any authorized context ends that pair's active button sequence. The shared state has a database row lock, so concurrent messages in different contexts cannot each send a welcome. Human-response-needed flags remain specific to the underlying inquiry/order. Saving a welcome with **zero quick-reply buttons** is also supported.
- Buyer app entry points remain context-specific. Its generated models and operations were regenerated and checked for compatibility.

## Files, schema and contract

The main implementation is in:

- `services/api/app/Domain/Messaging/VendorBuyerThread.php`, `ConversationService.php`, `ConversationHeaders.php`, `QuotationService.php`, `AutomatedResponseService.php`.
- `services/api/app/Http/Controllers/Api/ConversationController.php`, `services/api/routes/messaging.php`, and `AutomatedResponseSettingsRequest.php`.
- `apps/vendor-web/src/pages/MessagingPage.tsx`, `ConversationThread.tsx`, and `src/lib/messaging-api.ts`.
- Shared `packages/web-ui/src/buyer-thread-reply-context.tsx`, `messaging-patterns.tsx` and its stylesheet.
- OpenAPI, generated TypeScript/Dart clients, messaging contract checks, affected tests, workflow decisions and UI planner.

Additive migration `2026_11_05_123000_share_buyer_thread_automation_state.php` adds one automation-state row per Buyer/store pair, restricted foreign keys and an existing-message backfill that preserves the welcome cap and manual takeover. It ran successfully from an empty isolated database and on the existing local development schema. The local queue/scheduler workers were restarted. No remote migration or new secret/key setup is required.

New authorized GET operations:

| Path under `/api/v1` | Behavior |
| --- | --- |
| `/vendor/conversations/{conversationId}/buyer-thread` | Combined read projection, 50 messages by UUID cursor and 10 quotation versions per page; only the selected context and contexts referenced by that response are attached, at most 61 |
| `/vendor/conversations/{conversationId}/buyer-thread/contexts` | Up to 25 authorized reply subjects per page |

The existing Vendor inbox operation now groups before pagination. Optional response fields include `buyer_thread_id`, `conversation_count`, message/quotation `conversation_id`, `thread_contexts` and `thread_authority`. The epoch is cache invalidation metadata, never an authorization credential. All sending, quotation, private-download and receipt mutations retain their existing server authorization and context-specific routes. No message or commercial history was moved or deleted.

## Executed verification

| Check | Actual result |
| --- | --- |
| Full isolated API/schema gate | **833 passed, 16,935 assertions**, one unrelated reporting warning; Pint **871 files passed**, PHPStan **no errors** |
| Complete messaging and bot suites | **57 passed, 1,416 assertions** |
| Final combined-thread scope/backfill checks after the empty-general-inquiry adjustment | **3 passed, 70 assertions** |
| Final Vendor complete suite | **84 files, 783 tests passed** |
| Admin complete suite | **42 files, 282 tests passed** |
| Final attachment/context component regression suite | **19 passed**, including original-context download and transfer revocation |
| Vendor/Admin lint, typecheck and production builds | Passed; existing Vendor unused `inStore` warning and Vite bundle-size advisories remain |
| OpenAPI validation | Passed with eight unused-model recommendations |
| Messaging contract | **48 authorized operations passed** |
| Generated TypeScript build and Dart serializers | Passed |
| Buyer messaging transport, pinned Work Package and quick-reply compatibility | **4 passed** |
| Flutter analysis | **No issues found** |
| Browser combined-thread journey | **3 passed**, Chromium widths 320, 390 and 1440; reply routing, persistent combined history, selected Buyer row and read-only order behavior checked |
| Existing package attachment/settings browser journey | **3 passed** at the same widths |
| Scoped Gitleaks scans and staged scan | No leaks detected; staged scan had zero staged bytes |
| Diff whitespace and Compose configuration | Passed |

The final API scope adjustment was covered by a subsequent targeted run and final formatting/static analysis; the full suite was not rerun solely for that small read-filter adjustment. Browser screenshots were visually inspected after reducing context-label spacing. Initial browser failures were fixture-only: a too-short fake CSRF token and querying the intentionally hidden mobile inbox without `includeHidden`. They passed after correcting the fixture and locator.

The API warning is the previously observed `TabularDocumentRendererTest` stream-inspection `gzuncompress()` warning. Portal tests emit the existing jsdom navigation advisory. No test failure remains in the executed checks for this slice. The previously reported missing Buyer golden-baseline files were not generated; a full Buyer golden suite was not rerun for this Vendor presentation change.

Ignored logs: `services/api/storage/logs/buyer-thread-*.log`. Browser evidence: `apps/vendor-web/test-results/buyer-thread-*/combined-buyer-thread.png` at each checked width. The reviewed desktop reference is preserved in `docs/design/evidence/vendor-buyer-thread/combined-timeline.png`. These are fixture browser tests, not proof of a live authenticated two-account or physical-device session.

## Reproduce

From the repository root:

```powershell
& ./scripts/run-tests-isolated.ps1 -SkipBuild -SkipComposer
```

From `apps/vendor-web`:

```powershell
npm.cmd run lint
npm.cmd run typecheck
npm.cmd run test -- --run
npm.cmd run build
npm.cmd run test:e2e -- e2e/buyer-thread.spec.ts e2e/project-quotation.spec.ts --project=chromium-320 --project=chromium-390 --project=chromium-1440
```

Manual acceptance remains an authenticated Buyer/Vendor session with real local account data and a physical Buyer app. Check one Buyer with historical packages and orders, a reply to the intended package, a published quotation, a file from another context, shared bot takeover and a staff transfer. No live provider or production acceptance is claimed.

Suggested commit: `feat(messaging): combine vendor conversations into one buyer timeline`.
