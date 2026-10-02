# Phase 9 — Messaging and Order from Chat

Implemented across the API, Vendor portal, Buyer app, shared web UI and generated API clients. No deployment or commit was made. The development database has not been migrated by this phase; isolated test migrations and schema verification passed.

## Delivered behavior

- Separate `SALES` and order-linked `FULFILLMENT` conversations. Current account, organization, fixed role and assignment are checked on every REST request, channel authorization and private-file request. Owner/Manager oversight remains scoped to their organization. Transferring a handler does not transfer commercial authority.
- Customer Service can prepare and revise drafts, but cannot publish, withdraw published terms or set/change NRPC. Existing Phase 8 authority for permitted unchanged order confirmations is preserved. Fulfillment Staff cannot access sales conversations or their attachments.
- Public store identity, verified status and actual handler name/avatar/role; immutable sender attribution, transfer history, system messages, read receipts and paginated history. Private login email and personal phone are excluded from identity responses.
- Reverb subscriptions use purpose, conversation, viewer and current authority epoch. Post-commit outbox broadcasts contain invalidations only; clients fetch content through authenticated REST. Old subscriptions receive no new invalidations after reassignment or role/account changes. REST synchronization remains available when Reverb is unavailable.
- Private JPG/PNG/PDF sales attachments, image-only fulfillment attachments, content validation and fail-closed malware scanning. Downloads reauthorize current access, require CLEAN file state and use private/no-store responses. Retry of the same attachment identifier is idempotent; different content conflicts.
- One shared Item-Based/Project-Based quotation engine: draft, publish, immutable revision, view, withdraw, accept, reject, counter-offer, reminder and expiry. Each revision preserves source versions, actor, hash, full before/after history and readable changes; it supersedes the previous version and resets the Buyer deadline. Default 24 hours, configurable from 1 to 72 hours, exact Asia/Manila time plus countdown. Counter-offers retain the existing 24-hour Vendor response window.
- Publication creates soft holds only. Rejection, withdrawal, counter-offer, expiry and supersession release them. Acceptance locks inventory deterministically and revalidates every line atomically. A shortage returns `STOCK_REVALIDATION_REQUIRED` without an accepted order, charge or partial reservation; a stale version returns a recoverable 409.
- FIN-02 source price/tax versions, discount allocation, NRPC acknowledgement, delivery vehicle/rate calculations and fee-policy version survive into the accepted order. Unknown payable tax classification fails before publication. Quotation and financial snapshot prices are marked `PRIVATE_TRANSACTION`; MAT/competitor queries continue to use eligible public ordinary price sources only.
- Buyer messaging opens from Product Details and the Messages destination; accepted quotations link to Order Details. Vendor messaging includes drafts, product lines, publication and handler transfers. Shared quotation cards keep superseded terms readable without stale actions.

## Changes

| Area | Main files |
| --- | --- |
| Migration | `services/api/database/migrations/2026_10_03_000000_complete_phase_nine_messaging.php` |
| API domain | `services/api/app/Domain/Messaging/` — access/channel policy, conversations, private files, outbox broadcast, fulfillment threads, quotation terms, versions and acceptance |
| API integration | `ConversationController.php`, `routes/messaging.php`, `routes/channels.php`, `routes/console.php`, `config/broadcasting.php`, `config/reverb.php`, `AppServiceProvider.php`, `OutboxProcessor.php` |
| Shared commerce | `ConfirmedDeliverySnapshot.php`, `FinancialSnapshotService.php`, inventory soft-hold projections, `EligibleOfferQuery.php` |
| Dependencies | API Composer manifest/lock add Reverb; Buyer pubspec/lock add file selection and WebSocket transport |
| Contract | `packages/api-contract/openapi.yaml`, messaging authoring/check scripts, generated TypeScript/Dart clients and serializers; CI messaging contract gate |
| Vendor | `MessagingPage.tsx`, `messaging-api.ts`, app routing/navigation; shared `packages/web-ui/src/messaging-patterns.tsx` |
| Buyer | `lib/features/messaging/`, `lib/design_system/components/messaging_components.dart`, home/procurement navigation and Product Details action |
| Tests/docs | `PhaseNineMessagingTest.php`, Vendor component and eight-width browser checks, Buyer `messaging_test.dart`; generated ERD/data dictionary |

The additive migration extends the existing conversation/quotation tables, adds current fulfillment assignments and enforces one thread per order. Published versions, quotation lines, changes/events and message attribution have database immutability protection. No previously applied migration was edited.

## API contract

Contract version `1.0.0-phase.9` adds 25 documented authorized operations under `/api/v1/{buyers|vendor}/conversations` and `/messaging`. The surface covers inbox/detail, sending, receipts, attachment upload/download, avatar retrieval, handlers/transfer, draft/publication/decisions, runtime public Reverb configuration and channel authorization. Lists are paginated. Retry-sensitive creation/publication/decisions require `Idempotency-Key`; message/attachment identifiers provide their idempotency boundary. Drafts and handler transfers use `lock_version`; acceptance uses version ID and content hash. Empty quotation state is nullable in the generated clients. No fulfillment creation route is exposed.

## Acceptance evidence

| Check | Result |
| --- | --- |
| Complete isolated API regression suite | **388 passed, 6,318 assertions** |
| Final focused Phase 9 suite, including added cross-order file checks | **14 passed, 254 assertions** |
| PHPStan | **No errors**, 308 source files |
| Pint | **447 files passed**; subsequent test-only additions also passed formatting |
| Schema documentation check | Matches migrated isolated database |
| Vendor unit/component suite | **216 passed**; final messaging component rerun **4 passed** |
| Admin unit/component suite | **30 passed**; hover-only sidebar test fixture aligned with existing behavior |
| Buyer full suite | **189 passed, 1 intentionally skipped** opt-in Phase 7 capture; zero failures |
| Flutter analysis | **No issues** |
| Portal lint/typecheck/build | Passed; existing large-chunk build advisory remains |
| Browser messaging checks | **8 passed (7.3 seconds)** at widths 320, 375, 390, 768, 1024, 1280, 1440 and 1920; fixture API, not a live provider journey |
| OpenAPI and generated clients | Validation passed with three existing unused-model recommendations; TS build and Dart serializer generation passed |
| Route contract | All 25 messaging operations and existing order contract passed |
| Secret scan | Gitleaks directory scans: 14 source/generated targets, zero findings; no Git commands used |
| Compose | Development and isolated test configuration validation passed |

The API acceptance suite includes sales/fulfillment channel separation, wrong viewer/purpose, cross-Vendor and cross-order access, no early fulfillment thread, fixed-role Customer Service restrictions, assignment/role/account revocation, retained messages/history, private-contact exclusion, attachment retry/scanner failure, immutable revisions and stale acceptance, fake-clock reminder/expiry boundaries, competing quotations for the last stock, Project-Based single-Vendor selection, unknown tax rejection, NRPC and confirmed delivery snapshots. Stock tests exercise competing accepted quotations and all-or-none reservations; they are not a concurrent load benchmark.

## Local runtime setup and remaining live checks

1. Apply the additive migration in the development API when ready: `php artisan migrate`. The isolated test database does not migrate development.
2. Configure the existing ignored environment with `BROADCAST_CONNECTION=reverb`, `REVERB_APP_ID`, `REVERB_APP_KEY`, `REVERB_APP_SECRET`, `REVERB_HOST`, `REVERB_PORT`, `REVERB_SCHEME` and explicit `REVERB_ALLOWED_ORIGINS`. The public endpoint must be reachable by the Vendor browser and Buyer device. No secret values were added to this report or client configuration.
3. Run `php artisan reverb:start`, the configured queue worker/Horizon, and the scheduler (`php artisan schedule:work` locally). `materyalph:quotations-sweep` handles reminders/expiry; `materyalph:outbox-dispatch` retries committed events. Retain configured private storage and fail-closed malware scanning.
4. Exercise two signed-in clients against the live local API: send/read/upload, transfer a handler while their socket is open, publish/revise/counter/accept, verify Order Details, and confirm the superseded session cannot fetch messages or files. Real socket delivery, device file selection and live provider/storage/scanner integrations remain manual acceptance checks; automated tests use provider/scanner fakes and browser fixtures.

Phase 12 milestone entry is intentionally disabled. Its future integration must call `FulfillmentThreadService::ensureForMilestone` within the milestone/outbox boundary only at `READY_FOR_PICKUP` or `OUT_FOR_DELIVERY`, and use the existing assignment service. Phase 10 owns public Work Package inquiry creation; the shared engine already accepts Project-Based conversations and enforces single-Vendor selection in tests. Phase 11 still owns payment-channel selection and provider payment initiation.

Suggested conventional commit: `feat(messaging): add secure conversations and versioned order-from-chat quotations`.

## Vendor messaging reference-layout update — 2026-09-30

The Vendor Messages page now uses a persistent desktop inbox beside the selected conversation, compact incoming/outgoing message bubbles, initials, Manila timestamps, read indicators and a bottom composer. Mobile switches between inbox and conversation. Quotation history opens from the toolbar; the existing draft editor, handler transfer, private attachments and accepted-order link remain available.

Changed files: `apps/vendor-web/src/pages/MessagingPage.tsx`, `apps/vendor-web/e2e/messaging.spec.ts`, `packages/web-ui/src/messaging-patterns.tsx`, `packages/web-ui/src/messaging-patterns.css`, `packages/web-ui/src/index.ts`, and this report. No migrations, API contract changes, new credentials or manual setup are required. Existing server authorization and attachment scan restrictions remain in force.

The inbox filters the current API page by inquiry type, handler and reference without requests on each keystroke. The API does not expose inbox Buyer identity, last-message previews or CCS; the UI uses existing inquiry/handler fields and does not manufacture the reference image's scores, order counts, stock values or product suggestions.

Validation for this UI update:

- Vendor `npm.cmd run lint`, `npm.cmd run typecheck`, and `npm.cmd run build`: passed. The existing large-bundle advisory remains.
- Vendor `npm.cmd run test -- --run --maxWorkers=2`: **216 tests passed across 27 files**. Focused messaging presentation run: **4 passed**.
- Vendor `npm.cmd run test:e2e -- e2e/messaging.spec.ts`: **8 passed**, at 320, 375, 390, 768, 1024, 1280, 1440 and 1920 pixels. Checks cover desktop inbox filtering/selection, mobile navigation, quotation history and stale-action suppression, opening the draft editor, horizontal overflow, and preservation of text and the message idempotency identifier across a failed send and retry.
- Admin `npm.cmd run typecheck`: passed for the shared component exports.
- Browser screenshots visually inspected at desktop, tablet and narrow mobile widths. Screenshots are emitted as `apps/vendor-web/test-results/messaging-quotation-histor-e4d3a-eadable-across-screen-sizes-chromium-{width}/messaging.png`.
- Gitleaks directory scans of shared UI, Vendor pages and Vendor E2E sources: **zero findings**. Whitespace/conflict-marker review passed for the five changed source/test files. No Git commands were run.

Browser tests use fixture responses; live cross-client Reverb, storage and scanner acceptance remains as documented above. Backend and Flutter suites were not rerun for this UI-only change.

Suggested conventional commit: `feat(vendor): redesign messaging workspace with split inbox`.


### Owner decision — 2026-10-02: Store messaging and product cards (MSG-02)

This decision supersedes the product-required/locked-product entry wording in Phase 9. A Buyer may message an active Tier 2 Vendor directly from Store Profile without a product. General and product inquiries reuse one SALES / ITEM_BASED conversation per Buyer and Vendor store. The owner confirmed that Work Package quotation conversations and order-specific FULFILLMENT threads remain separate with their existing authority and commercial records.

Product Details opens that store conversation and prepares an unsent, removable product draft; opening it never sends a message. Do not attach again when the same product is the latest attached product. Preserve unsent Buyer text/product drafts locally in secure storage, and only restore after current conversation authorization succeeds. The composer offers a searchable, paginated picker restricted to that store's currently eligible active products. Text, product-only and text-with-product messages are supported. Product references use the existing listing variant UUID (`product_id`); snapshot listing ID, name, integer-centavo price and safe public image URL at send time. Preserve the snapshot after catalog changes and display No longer available when the offer is unavailable. Product cards do not modify quotations, inventory, or accepted terms.

Client-generated message IDs bind immutable sender, text and product content. Optimistic messages show Sending, failure and Retry; retry reuses the same identifier. Inbox rows show the public other-party identity/avatar, latest message preview (Sent a product: [name] for product messages), Manila timestamp and unread count, ordered by activity. Opening the thread marks received messages read. Loading, No messages yet and real failures with functional Retry are separate states.

Use existing Reverb viewer-authorized channels and account inbox invalidations. Reconnect reauthorizes and fetches missed history; REST polling is a recovery fallback. Typing is an ephemeral, debounced event with a server timestamp, no database/outbox persistence, and approximately three-second expiry. Read/send/file/channel checks continue to revalidate account, store, role and handler authority; preserve scanner, rate-limit, commercial-history and privacy safeguards. No Admin receives general conversation access through this change.

Legacy duplicate general inquiries are linked to the oldest canonical thread without moving or deleting immutable commercial history. They remain reachable from Earlier inquiry history; new general chat goes to the canonical thread. Existing quotation actions retain their purpose-specific authorization. The unique partial index excludes Work Package and fulfillment threads.


Implementation and current validation: see [2026-10-02 messaging repair](phase-nine-messaging-repair-2026-10-02.md). Earlier phase totals above are historical evidence, not the acceptance results for this change.


### Owner decision — 2026-10-02: Later quotations in a permanent store chat (MSG-03)

The owner approved later, separate quotations in the same general store conversation after an earlier quotation is accepted. Vendor sales staff use New quotation; Customer Service retains draft-only authority. Each quotation keeps its own immutable published versions and accepted order. An idempotent start action requires the current quotation version, and the new draft advances the version counter so a stale editor cannot overwrite it. Earlier accepted quotations remain Accepted with their original order links; they are never relabeled Superseded by a later purchase. Work Package inquiries keep their one-quotation commercial boundary; fulfillment threads cannot create quotations.

A Buyer may add or update the saved delivery location and heavy-vehicle access declaration from Delivery details inside the general thread, without a product or a blocking chat-entry dialog. Only the Buyer's owned, nonarchived locations are permitted; the intended site and alternate drop-off remain separate. Changes require the current conversation version and are rejected while the current quotation is Published or Viewed. An existing draft's version advances, and publication rechecks the delivery reference after route calculation. Existing accepted quotation and order snapshots remain unchanged. This follows from the permanent product-free store chat: delivery must not be fixed to its first entry.

Local runtime verification uses Reverb's private channels. Native Buyer sockets send the explicit application-origin label `https://materyalph-buyer` (not a network endpoint); it grants no channel permission. Browser origins remain explicitly allowlisted. Application keys must not contain a colon because Pusher signatures use `key:signature`. No secret values belong in documentation or client bundles.
