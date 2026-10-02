# Phase 9 messaging repair — 2026-10-02

This records the repair to the existing Phase 9 implementation. Owner decisions MSG-02 and MSG-03 are recorded in all four final workflows and `phase-nine-messaging.md`. General/product chats share one thread per Buyer/store; Work Package inquiries and order fulfillment threads remain separate. The owner also approved later, separate quotations after acceptance in the same general chat and the local Reverb setup.

## Root cause and evidence

Both inboxes failed while building a participant's public identity. `ConversationService::identity()` looked for `profile_photo_key` on a `user_profiles` row, but that column belongs to `users`. Laravel logged `Undefined property: stdClass::$profile_photo_key`; the API returned a server failure which both clients mapped to their generic request error. Earlier fixtures had no profile row, so the null-safe access masked the mistake. The identity and avatar-download paths now use the actual user photo storage fields.

`PhaseNineMessagingTest::test_inboxes_with_real_profiles_use_user_photo_storage_and_allow_product_free_reuse` exercises profiles, an avatar, both inboxes, and a real MOBILE Passport bearer token through the HTTP kernel in `api-test`. It asserts HTTP 200, an empty errors array and a populated inbox without printing tokens. The generated Dart transport regression verifies Authorization, the endpoint path and decoding. A product-free locked reference is returned as `{}`, not `[]`, to match the generated map type. The fix preserves real authentication expiry handling.

Local realtime had separate runtime problems: a missing Reverb secret/service, an existing application key containing `:` (incompatible with Pusher's `key:signature` framing), and native connections without an allowlisted Origin. With owner approval, the ignored local environment was configured, the public key replaced, and `reverb`, `api`, `horizon` and `scheduler` restarted. Private subscription, signed publication and socket delivery pass through `node scripts/check-local-reverb.mjs`. This infrastructure smoke check is separate from application authorization tests and a real two-account/device test.

## Workflow discrepancies and repairs

| Before | Result |
| --- | --- |
| Real participant profiles crashed the inbox; error and empty presentation could overlap | Correct photo table; distinct loading, genuine error/Retry and No messages yet; Retry performs another request |
| Store entry required selecting a product | Store Profile opens chat directly; product selection is optional in the contract and Dart client |
| Repeated product inquiries created multiple general threads | Buyer/store creation is serialized, returns the canonical thread and has a database uniqueness constraint |
| Product context was fixed at thread creation | Product Details prepares a removable local draft; attaching/sending snapshots a product independently of quotation terms |
| No product message model or picker | Paginated/searchable store-scoped eligible-product picker; text, product and combined messages; immutable card fields and unavailable state |
| Send feedback waited for REST | Immediate pending item, failed status and Retry with the same immutable client message ID |
| Vendor inbox had no private live subscription | Both inboxes receive private invalidations; thread reconnect reauthorizes and walks missed pages to the last known message |
| No typing event | Debounced authorized ephemeral event; timestamp ordering and three-second display expiry |
| Inbox rows lacked useful previews and Buyer identity | Public other-party name/avatar, product-aware preview, timestamp and unread count; read receipts update the list |
| One accepted quotation permanently closed a reusable store thread | Explicit Vendor New quotation action creates another quotation; original accepted versions/orders remain immutable and linked |
| Delivery could only be declared during initial product entry | In-thread Delivery details uses owned saved locations, preserves intended/alternate locations and guards published quotations and draft versions |

## API and data changes

All paths are relative to `/api/v1`; normal Buyer bearer and Vendor cookie/CSRF middleware remain in effect.

| Operation | Change |
| --- | --- |
| `POST /buyers/conversations` | Product optional; reuse canonical general thread; independent Work Package creation remains in its existing flow |
| `GET /{buyers|vendor}/conversations` and `/{id}` | Public Buyer identity, last-message preview, latest product reference, canonical/legacy thread links and paginated legacy references |
| `POST /{buyers|vendor}/conversations/{id}/messages` | Optional body/product; requires at least one; same `client_message_id` plus same content replays; changed content conflicts |
| `GET /{buyers|vendor}/conversations/{id}/products` | Store-scoped active eligible offers, `q`, `product_id`, page size 25 |
| `POST /{buyers|vendor}/conversations/{id}/typing` | Boolean typing event only; never persisted |
| `PUT /buyers/conversations/{id}/destination` | Owned saved location and access declaration; conversation version required; published/viewed quotation blocks changes |
| `POST /vendor/conversations/{id}/quotation/start` | Current quotation version and Idempotency-Key; general canonical thread only, after acceptance |
| Quotation history | Each version carries quotation ID and accepted-order ID; paginates across quotation cycles; stale decisions cannot act on a later quotation |
| Realtime configuration/auth | Vendor inbox channel; separate public socket address; existing viewer/authority-bound private authorization |

Migration `2026_10_06_000000_improve_store_conversations.php` adds nullable message `product_id` and `product_snapshot` with a pair check, plus conversation `canonical_conversation_id` with a restrictive self foreign key. Product IDs are existing listing-variant UUIDs; snapshots preserve listing ID, name, integer-centavo price and a safe public image. The snapshot intentionally survives physical deletion. Existing duplicate general inquiries link to the oldest canonical thread; messages, commercial records, receipts, assignments and attachments are retained. A partial unique index enforces one canonical SALES/ITEM_BASED thread per Buyer/store. Legacy history remains accessible, with new general messages directed to the canonical chat.

Migration `2026_10_06_000001_allow_store_quotation_cycles.php` replaces the one-quotation index with one nonaccepted quotation per conversation and one quotation per Project-Based inquiry. Rollback fails safely if later quotations exist; it never deletes them to recreate the older constraint.

Existing `conversation.{purpose}.{id}.{viewer}.{epoch}` channels carry `conversation.changed` and ephemeral `conversation.typing`. Viewer-bound `buyer-inbox.{epoch}` and `vendor-inbox.{epoch}` carry `inbox.changed`. Changed events contain invalidation metadata only. REST reauthorizes content; message UUID ordering and client-ID reconciliation prevent duplicate timeline entries. Missed history is paged back to the previously seen message. Forty-five-second REST synchronization is a fallback.

## Files

- API: `app/Domain/Messaging/{ConversationService,ConversationProducts,ConversationFiles,ConversationBroadcast,BuyerInboxChannel,QuotationService}.php`; `app/Http/Controllers/Api/ConversationController.php`; `routes/{messaging,channels}.php`; `config/reverb.php`; the two migrations; `tests/Feature/Api/PhaseNineMessagingTest.php`.
- Buyer: `features/messaging/{messaging_screen,messaging_repository,chat_drafts,chat_product_picker,chat_delivery_dialog,chat_socket,chat_socket_native,chat_socket_browser}.dart`; `features/item_procurement/procurement_navigation.dart`; Store Profile/Home entry points; `design_system/components/messaging_components.dart`; messaging layout/transport, native socket and delivery-dialog tests and updated messaging reference images.
- Vendor/shared UI: `apps/vendor-web/src/pages/MessagingPage.tsx`, `src/lib/{messaging-api.ts,messaging-patterns.test.tsx}`, `e2e/messaging.spec.ts`, `packages/web-ui/src/messaging-patterns.tsx`.
- Contract: `openapi.yaml`, `scripts/{improve-messaging-contract,check-messaging-contract}.mjs`, generated TypeScript/Dart clients and generated serializers.
- Runtime/docs: `compose.yaml`, API `.env.example`, ignored local API environment, `scripts/{inspect-messaging-runtime.php,check-local-reverb.mjs}`, four final workflows and Phase 9 test plans.

## Security and compatibility

Read, send, product search, file download and channel authorization retain current account/store/role/handler checks. Only currently authorized recipients get typing or invalidation events. Customer Service remains draft-only for commercial terms. Fulfillment roles cannot access sales channels. Private uploads retain content checks, fail-closed scanning, download authorization and existing rate limits. No new Admin conversation-reading permission is introduced. This repair does not claim to implement additional moderation/reporting interfaces outside the existing phase.

Product cards accept only eligible products of the conversation's Vendor. The server snapshots public catalog facts; clients cannot submit prices/names/images. Reusing a send ID with another product/text/sender conflicts. Published/accepted financial and quotation snapshots are preserved. Delivery changes increment the active draft version and publication rechecks the reference after its network route calculation.

Native sockets send the fixed `https://materyalph-buyer` application-origin label. This is an allowlist label, not a backend endpoint or credential; signed private authorization remains mandatory. Browser origins remain explicitly allowlisted. Server-only secrets are kept in the ignored environment and have never been printed.

## Commands and results

Database tests used `docker compose --env-file services/api/.env.testing -f compose.test.yaml -p materyalph_phase1_test exec -T api-test ...` from the repository root. Host PHP/Flutter commands were run outside the restricted sandbox when its filesystem/cache restrictions prevented normal execution.

| Command (within its package unless noted) | Result |
| --- | --- |
| API `php artisan test --no-ansi` in api-test | PASS: 150 tests, 1,819 assertions. This invocation discovered top-level tests only in this environment |
| API `php artisan test tests/Feature --no-ansi` | PASS: 12 tests, 74 assertions; overlaps the default run |
| API `php artisan test tests/Feature/Api --no-ansi` | PASS: 344 endpoint tests, 5,912 assertions before subsequent quotation/delivery additions |
| API `php artisan test tests/Feature/Api/PhaseNineMessagingTest.php tests/Feature/Api/PhaseTenProjectsTest.php --no-ansi` | PASS after quotation/delivery additions: 36 tests, 691 assertions |
| API `php vendor/bin/pint --test --format=json` | PASS |
| API `php vendor/bin/phpstan analyse --memory-limit=512M` | PASS, no errors |
| Buyer `flutter analyze` | PASS, no issues (final run) |
| Buyer `flutter test` | PASS: 254 passed, one skipped, including native socket, reconnect-gap and delivery tests |
| Vendor `npm run lint`, `npm run typecheck`, `npm run build` | PASS; build retains large-chunk advisory |
| Vendor `npm run test -- --run --maxWorkers=2` | PASS: 29 files, 228 tests. An earlier unbounded run hit worker/timeouts; bounded rerun passed |
| Vendor `npm run test:e2e -- e2e/messaging.spec.ts` | PASS: eight viewport projects, including subsequent quotation/order link |
| Admin `npm run lint`, `npm run typecheck`, `npm run build` | PASS |
| Admin `npm run test -- --run --maxWorkers=1` | PASS: 12 files, 37 tests. Earlier two-worker run had one preview failure; focused rerun (2 tests) and full serial rerun passed |
| Contract `node scripts/improve-messaging-contract.mjs`, `npm run generate` | PASS; TS and Dart regenerated from source |
| Generated TS `npm run build`; generated Dart `dart run build_runner build --delete-conflicting-outputs` | PASS |
| Contract `npm run validate` | PASS; three existing unused-model recommendations |
| Contract `npm run test:messaging-contract -- messaging-repair-routes.json` | PASS: 31 authenticated/authorized operations |
| Root `docker compose --profile realtime config --quiet` | PASS |
| Root `node scripts/check-local-reverb.mjs` | PASS: native-origin private subscription, signed publication and socket delivery |
| Scoped `gitleaks dir <changed-source-path> --redact --no-banner` | PASS, no leaks in initial changed-source scan and final Messaging domain, Buyer messaging, helper/contract scripts and test-plan scans |

No Git commands, commit, push, merge or deployment were performed. Git-based staged/diff checks were intentionally not run under the standing no-Git instruction. Logs named `messaging-repair-*.log` record individual command output without environment or token dumps.

## Manual two-account acceptance script

Prerequisites: apply the two migrations after local-data approval; local API, queue worker and Reverb running; updated Buyer build and Vendor frontend; Buyer A and Vendor owner B with two active eligible products and at least one saved Buyer location. Reverb public host/port must be reachable from the phone. When using USB reverse forwarding, forward both API 8080 and Reverb 8081. `REVERB_PUBLIC_HOST` may remain blank to use the API request hostname; browser hostname must be in `REVERB_ALLOWED_ORIGINS`. Never enter secrets in frontend settings.

1. **Store Profile, no product:** A opens B's store and taps Message store. Expect a usable composer immediately, no product gate or sent product. Return and reopen: same thread ID, one general inbox row. With a fresh Buyer, Messages shows No messages yet before creating a thread; interrupted requests show an actual error and Retry fetches again.
2. **Product Details draft:** A taps Message on product one. Expect the same store thread with an unsent card. Type text, leave, reopen: text/card remain locally. Remove the card and reopen: it stays removed. Send it, then tap Message on the same product again: no duplicate draft when that product is the latest attachment.
3. **Second product:** In the thread, Attach product, search for product two and select it. Only B's eligible products appear. Remove/reselect, then send product-only and text-with-product. Tap cards to Product Details (Buyer) and `/products/{listingId}` (Vendor). Change the listing price/name afterward: sent card keeps original facts. Inactivate it: card displays No longer available.
4. **Typing both ways:** With both threads open, A types; B sees typing. Stop for about three seconds: it clears. Repeat B to A, then send: indicator clears immediately. No typing entries appear in history after reopening.
5. **Foreground instant delivery:** Send A→B and B→A without touching refresh. Expect an immediate pending bubble locally, then one sent bubble; recipient appears through Reverb promptly, before the 45-second fallback. Disable a send response temporarily, retry: same client ID, one server message. Changed content under the same ID returns a conflict.
6. **Airplane/reconnect:** A enables airplane mode; B sends several messages. Restore connectivity/reopen: all missed messages appear in order once. Repeat with over 50 missed messages to exercise paging. A sends offline: failed state and Retry; restored connectivity sends once.
7. **Unread/list row:** A leaves the thread; B sends text then a product. A's row rises to the top with the latest timestamp, name/avatar, unread badge and `Sent a product: [name]`. Open the thread: unread clears. Repeat in Vendor inbox with no selected conversation.
8. **Vendor view and quotations:** B verifies product cards, pending/failed/retry, public Buyer identity and listing links. Publish/accept a quotation normally. B taps New quotation, publishes another; A accepts it. Expect two different orders in one chat, both accepted histories unchanged, and a retry of the first acceptance still returns the first order. Work Package and fulfillment threads retain their separate flow.
9. **Delivery after product-free entry:** A uses Delivery details, chooses an owned saved location and explicitly declares access. YES requires a distinct alternate drop-off and instructions. B publishes a delivery quotation using existing fleet/rate controls. A cannot change the destination while it is Published/Viewed. After withdrawal, changes invalidate the old draft version. Accepted order destinations never change.
10. **Security/legacy:** Another Buyer and a different Vendor cannot GET, send, fetch a file or authorize these channels. A transferred handler loses REST/socket/file access. Legacy duplicate inquiries remain reachable through Earlier inquiry history; new chat uses the canonical thread. Verify prior quotations/files are present. Retest scanner rejection and existing reporting/moderation flows without bypasses.

## Local readiness and limitations

At the latest read-only development check, one duplicate general-thread group contained three legacy threads to link. Both new migrations remain pending owner approval; the running development API cannot use the new fields until they are applied. The separate approved Reverb setup is complete and its socket smoke check passes. No data reset/reseed or history deletion is needed.

An Android device is connected, but no updated app was installed and no live account acceptance was performed while the development schema remains pending. Live two-account Buyer-device/real-browser acceptance, airplane mode and external storage/scanner provider behavior are not established by isolated tests, fixture browser tests or the infrastructure-only socket smoke test. Run the script above after migration and installing the updated Buyer build. The initial Admin verification-preview failure did not reproduce in its focused or complete serial rerun; no Admin source change was needed.

Suggested conventional commit: `fix(messaging): repair inboxes and reuse store conversations with product cards`.
