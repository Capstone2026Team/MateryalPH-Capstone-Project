# Vendor inbox and fulfillment separation

Implemented locally on 9 November 2026.

## Result

The Vendor Owner/Store Manager inbox contains one Buyer row labelled **All inquiries & orders**. Sales and Work Package inquiries supply its preview and normal chat timeline. Order-specific fulfillment messages, read receipts and closure notices stay inside **Fulfillment conversations**, with a separate unread badge. Opening or closing that popup preserves the normal reply draft. Completing, cancelling, declining or expiring an order makes only its fulfillment thread read-only.

Order-only Buyer/store pairs receive a permanent SALES chat when their fulfillment thread is created or reused. The additive migration supplies missing parent chats for existing fulfillment history. It preserves messages, quotations, order snapshots, receipts and the existing chat when present; rollback retains the new chats because they may contain subsequent messages. Creation is audited and publishes the existing post-commit conversation invalidation.

Assigned Fulfillment Staff retain only their currently assigned order threads, listed separately per order. Their inbox never presents an order thread as All inquiries & orders, and selecting one order does not highlight every order for that Buyer. Sales roles, Owner/Manager supervision, private-file authorization and order closure restrictions remain authoritative on the server.

## Changed areas

- API: `ConversationService.php`, `ConversationHeaders.php`, `FulfillmentThreadService.php` and `PhaseNineMessagingTest.php`.
- Migration: `services/api/database/migrations/2026_11_09_000000_backfill_order_store_chats.php`.
- Vendor: `MessagingPage.tsx`, `ConversationThread.tsx`, `FulfillmentConversationDialog.test.tsx` and shared `packages/web-ui/src/messaging-patterns.tsx`.
- Contract: descriptions of the existing inbox and combined Buyer-thread endpoints, messaging contract assertions, and regenerated TS/Dart messaging clients and documentation. No request/response fields or routes were added.
- Documentation: System, Buyer and Vendor workflows, UI/UX planner and this verification record.

Unrelated README and concurrent invoice changes were preserved. No push, merge or deployment occurred.

## Executed verification

| Check | Result |
| --- | --- |
| Focused Vendor fulfillment popup and shared messaging components | 49/49 passed |
| API PhaseNineMessagingTest | Passed, including all four closure states, legacy-link routing, repeatable backfill and assigned-order separation |
| API MessageNotificationsTest | Passed |
| API PhaseTwelveFulfillmentTest | Passed |
| Expanded API run including orders and Buyer My Orders | 114 passed, 19 failed after the shared test database began reporting missing tables/columns; not a clean acceptance run |
| Full Vendor suite, initial run | 934 passed, 2 failed: Vite server timeout and Catalog mixer setup lookup |
| Full Vendor suite with two workers | 934 passed, 2 failed: Vite timeout and a concurrently edited invoice correction test |
| Separate unchanged Catalog and Vite test files, one worker | 24/24 passed |
| Vendor lint, typecheck and production build | Passed; existing large-chunk advisory remains |
| Full and focused PHP Pint and PHPStan | Passed in the final checks |
| OpenAPI validation | Passed, 8 unused-model recommendations |
| Messaging contract | Passed, 50 authorized operations |
| Fulfillment contract | Passed, 34 operations |
| TS/Dart client regeneration | Completed |
| Compose configuration and task source whitespace checks | Passed; a later global check encountered generated-client whitespace during concurrent client regeneration |
| Staged and task-scoped Gitleaks scans | No leaks found; staged scan covered zero staged bytes |

The local API reported `development`. Only the new migration was applied there, successfully. A subsequent read-only aggregate found **0 fulfillment threads missing a permanent sales parent**. No credential/key setup is required.

Automatic approval review could not complete the request to start a separate test stack because its usage limit was reached. That stack was not started. A clean broader API rerun, authenticated two-account realtime/browser acceptance, Admin and Flutter suites remain unperformed for this change. The shared API run's missing-schema errors do not establish a messaging regression.

## Reproduction and remaining checks

From `apps/vendor-web`:

```powershell
npm.cmd run lint
npm.cmd run typecheck
npm.cmd run test -- --run src/pages/FulfillmentConversationDialog.test.tsx src/lib/messaging-patterns.test.tsx --maxWorkers=2
npm.cmd run test -- --run --maxWorkers=2
npm.cmd run build
```

From the repository root, after ensuring no other process is running tests against the shared isolated test database:

```powershell
docker compose --env-file services/api/.env.testing -f compose.test.yaml exec -T api-test php artisan test tests/Feature/Api/PhaseNineMessagingTest.php tests/Feature/Api/MessageNotificationsTest.php tests/Feature/Api/PhaseTwelveFulfillmentTest.php tests/Feature/Api/PhaseEightOrdersTest.php tests/Feature/Api/BuyerMyOrdersTest.php
```

In another environment, apply the additive migration using its normal release process before checking legacy order-only Buyers. No production migration or deployment was performed here.

Manual acceptance:

1. Reload Vendor Messages as Owner/Store Manager. Confirm one All inquiries & orders row per Buyer and no fulfillment closure text in its preview or normal timeline.
2. Open that Buyer and enter an unsent reply. Open Fulfillment conversations, inspect an active and a closed order, then close the popup. Confirm the original reply and selected Buyer remain available.
3. Complete/cancel/decline/expire an order through the normal authorized flow. Its fulfillment thread must become read-only; both Buyer and Vendor can still reply to the normal chat.
4. Reopen an old saved Vendor URL containing a fulfillment conversation ID. Confirm the normal Buyer chat opens, its fulfillment list loads and ordinary replies target the sales chat.
5. As Fulfillment Staff, check two assigned orders for the same Buyer. Both appear independently, only the selected order is highlighted, and the sales chat is unavailable.

Suggested commit: `fix(messaging): keep fulfillment threads inside buyer conversations`.
