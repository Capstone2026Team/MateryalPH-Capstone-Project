# Work Package inquiries, automated responses and order recovery

Verified locally on 5 November 2026. No deployment, push or merge was performed. Existing unrelated workspace changes were preserved.

## Delivered flow

- Work Package sales inquiries appear directly in the paginated inbox. Standalone Project Inquiries navigation, dialogs and Buyer screens were removed. Historical compatibility endpoints remain available; old messages and quotations were retained.
- The thread pins a compact Work Package attachment above its scrolling messages. Opening it shows the locked Buyer original and Vendor proposal. Fulfillment messages also expose the order's immutable Work Package reference without changing its linkage.
- Buyer quotation cards lead with the total and fulfillment summary, then show materials, terms, charges and acceptance controls. Replacement quotations explain which pending request will be replaced.
- The Vendor Inbox gear opens a responsive Automated Response Settings dialog. Owner and Store Manager can save a welcome message and up to three labelled buttons with exact saved responses. Automation is disabled by default.
- A new Buyer message can send one welcome per thread per rolling 24 hours. Opening a thread, typing, Vendor/system messages and retried message submissions do not trigger welcomes. Buttons select immutable saved answers once per option; no text interpretation, AI, ML, NLP or external AI API is involved.
- Automated messages are visibly labelled, excluded from human performance metrics and leave the thread marked Needs a reply. A manual Vendor message ends the sequence. Disabling automation prevents additional button responses. Normal messaging remains available.
- A permitted Vendor can prepare a replacement quotation from a pending order's fulfillment thread or linked inquiry. The pending order remains in place until Buyer acceptance. Only an unconfirmed, unaccepted order without payment records can be replaced. Acceptance atomically cancels the old request and creates the new accepted order while preserving original snapshots and history.
- Cancellation, decline and expiry expose the same Work Package for sourcing again. A durable outbox handler releases the single-supplier selection and invalidates stale estimates; an immediate server projection makes the package reusable before that worker runs. Grouped arrangements reopen only the failed supplier's uncovered quantities. The Buyer must choose and submit before another supplier receives an order.

## Implementation and contract

API rules live in `AutomatedResponseService`, `PendingOrderQuotationService`, `QuotationAcceptance`, `WorkPackageOrderRecovery`, and the existing conversation, transition and project services. Reopening runs after commit through the outbox to avoid reversing order/inventory/package lock order. Settings changes and reopening are audited without recording private message bodies in audit payloads.

New additive migrations:

1. `2026_11_05_120000_add_conversation_automated_responses.php`: versioned store settings, thread state, immutable message automation payloads and unique button selections.
2. `2026_11_05_121000_reopen_work_packages_after_closed_orders.php`: forward-only repair of historical single-supplier package selections after closed orders.
3. `2026_11_05_122000_link_pending_order_quotations.php`: restricted, unique quotation-to-pending-order replacement links.

The migrations ran successfully against an empty isolated database, the isolated schema checks, and the existing local **development** database. Local queue and scheduler containers were restarted to load the new outbox handler. They have not been applied to a remote environment. No new secret, provider account or API key is required.

New `/api/v1` operations documented in OpenAPI and regenerated into TypeScript and Dart clients:

| Method | Path | Authorization / concurrency |
| --- | --- | --- |
| GET | `/vendor/messaging/automated-response` | Current organization's Owner or Store Manager |
| PUT | `/vendor/messaging/automated-response` | Same scope; `lock_version` and `Idempotency-Key` |
| POST | `/buyers/conversations/{conversationId}/automated-response` | Current Buyer participant; welcome ID, option index, stable client message ID |
| POST | `/vendor/orders/{orderId}/quotation-inquiry` | Authorized order organization and quotation sales role; current conversation access; order `lock_version` and `Idempotency-Key` |

Conversation responses include automation/settings capabilities, human-response-needed state and pending-order replacement metadata. Automated message responses expose button labels and availability; configured answer bodies remain private until the Buyer selects that button. Published quotation versions expose the replacement order reference. Every existing authorization check for private attachments, handler assignment and closed fulfillment remains in force.

Shared web components: `automated-response-settings-dialog.tsx`, `work-package-attachment.tsx`, and `messaging-patterns.tsx`. Buyer navigation callbacks await order/message navigation before refreshing the Work Package, preventing stale order state from being cleared locally. Per-thread Vendor composer drafts survive switching between inquiry and fulfillment views.

## Executed checks

| Check | Actual result |
| --- | --- |
| Isolated API full gate (`scripts/run-tests-isolated.ps1 -SkipBuild -SkipComposer`) | Pint **869 files passed**, PHPStan **no errors**, API **829 passed / 16,819 assertions**, plus one unrelated reporting warning |
| Focused API automation/messaging/projects/sourcing suite | **78 passed / 2,012 assertions** |
| Final grouped-supplier cancellation regression, added after the full run | **1 passed / 36 assertions**; replacement selection covers only the failed five units, preserves the peer order and sends no automatic order |
| Final changed PHP test formatting | **1 file passed** |
| Vendor complete component suite | **84 files / 781 tests passed** |
| Admin complete component suite | **42 files / 282 tests passed** |
| Vendor and Admin TypeScript checks and production builds | Passed; existing Vite bundle-size advisory remains |
| Vendor lint | Passed with an existing unused `inStore` warning in `e2e/admin-finance-layout.spec.ts:31` |
| Admin lint | Passed |
| Buyer affected messaging, quotation and navigation tests | **58 passed** |
| Final Buyer quotation and conversation screenshot render | **2 passed**, images visually inspected |
| Final Flutter analysis | **No issues found** |
| Buyer full suite | **604 passed, 1 skipped, 50 failed**; all 50 failures report missing golden baseline files |
| OpenAPI validation | Passed with eight existing unused-model recommendations |
| Generated TypeScript build and Dart build_runner | Passed |
| Messaging and project contract checks | **46 messaging operations / 35 project operations passed** |
| Browser fixture checks | **3 passed**, Chromium widths 320, 390 and 1440; pinned attachment comparison and automation settings checked, screenshots inspected |
| Compose configuration and `git diff --check` | Passed |
| Scoped Gitleaks scans and staged scan | No leaks detected; staged scan contains no staged commits/files |

The reporting warning was reproduced independently in `TabularDocumentRendererTest`: its PDF stream inspection calls `gzuncompress()` on an uncompressed stream at line 26. It is outside this feature and does not fail the suite.

The full Buyer failures are absent reference images in the phase 6/7/8/14 capture, projects, ranking and general UI capture tests. Unrelated golden baselines were not created or silently accepted. The full Buyer gate therefore remains incomplete even though the changed-flow tests and analysis pass.

Logs are in ignored `services/api/storage/logs/inquiry-*.log`. Reviewed Buyer references are in `docs/design/evidence/buyer-messaging/conversation.png` and `quotation-detail.png`. Browser fixture screenshots are under `apps/vendor-web/test-results/inquiry-final/`; these demonstrate fixture layout and interactions, not an authenticated live integration session.

## Reproduction and remaining manual acceptance

Run portal commands from their respective app directories using `npm.cmd` on Windows:

```powershell
npm.cmd run lint
npm.cmd run typecheck
npm.cmd run test -- --run
npm.cmd run build
```

Run the isolated API gate from the repository root:

```powershell
& ./scripts/run-tests-isolated.ps1 -SkipBuild -SkipComposer
```

Run the affected Buyer suite from `apps/buyer-mobile`:

```powershell
flutter analyze
flutter test --no-pub test/messaging_api_test.dart test/messaging_layout_test.dart test/messaging_test.dart test/project_inquiries_test.dart test/quotation_details_test.dart test/quotation_specification_test.dart
```

For browser checks, build both portals, then run from `apps/vendor-web`:

```powershell
npm.cmd run test:e2e -- e2e/project-quotation.spec.ts --project=chromium-320 --project=chromium-390 --project=chromium-1440
```

The repository Playwright web-server teardown hung on the initial run after its three tests passed. A second run against the existing preview with web-server management disabled exited successfully with all three passing. The temporary configuration was removed; repository configuration was not changed.

Physical-device/installed-app acceptance and an authenticated two-account browser journey remain manual. Verify an enabled welcome and button response, manual takeover, acceptance of a pending replacement, and Buyer/Vendor cancellation followed by choosing another supplier. No payment/refund provider or production acceptance is claimed. The Flutter app must be rebuilt/restarted on a device to show its changes.

Suggested commit: `feat(messaging): unify work package inquiries and automated responses`.


## Owner correction: one ordinary store chat

Work Packages are message attachments in the existing Buyer/Store chat. No reply-subject picker or separate Project Inquiries category is used. Message buttons on quotation options and arrangements attach the package to that chat. See [the correction and verification](single-store-chat-work-package-attachments-2026-11-05.md).
