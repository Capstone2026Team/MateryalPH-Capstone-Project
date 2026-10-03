# Buyer messaging reference layout and automatic updates

Updated 2026-10-01 following the Buyer request to remove the refresh icon, reuse the existing empty-state component, and follow the original reference more closely.

## Delivered

- Compact Messages heading and one search/cart/notification row. Reuses `PillSearchField` with its trailing search icon, `RoundIconButton`, the existing Lucide icons, Inter typography and semantic colors. Cart opens the existing cart route. Notifications retain the existing unavailable-screen behavior, without a fabricated unread dot.
- Compact two-line conversation rows with real store logos or neutral fallbacks, actual unread counts and dividers. The timestamp is the conversation update date, not an invented last-message time. Search filters the current API page by store/handler without a request for each keystroke.
- Empty and no-result inbox states reuse `StateMessage` and `assets/states/inbox.png`. No bespoke icon-circle empty state remains.
- No refresh icon in the inbox or conversation. Private Reverb invalidations update the inbox (including a first conversation), unread counts and open conversations. Reconnect uses fresh configuration and reauthorizes; successful subscription fetches changes missed while disconnected. Incoming invalidations during a fetch queue a subsequent fetch. App background pauses subscriptions; resume resynchronizes. The existing 45-second REST fallback and pull-to-refresh recovery remain available.
- Existing quotation acceptance/counter-offer/history, immutable sender attribution, authorized files and scan restrictions remain unchanged. Failed sends retain the text and retry identifier.

## Changed files

Buyer source: `lib/features/messaging/messaging_screen.dart`, `messaging_repository.dart`, `lib/design_system/components/messaging_components.dart`, `procurement_components.dart`, `lib/screens/buyer_home_screen.dart`, and `lib/features/item_procurement/procurement_navigation.dart` under `apps/buyer-mobile`.

API source: `BuyerInboxChannel.php`, `ConversationBroadcast.php`, `ConversationService.php` under `services/api/app/Domain/Messaging`, plus `services/api/app/Http/Controllers/Api/ConversationController.php` and `services/api/routes/channels.php`.

Contract: `packages/api-contract/openapi.yaml`, `scripts/add-messaging-contract.mjs`, `scripts/check-messaging-contract.mjs`, regenerated TypeScript/Dart client models and Dart serializers. `ChatRealtime.inbox_channel` is an optional nullable opaque channel name; Vendor responses contain null. Existing channel authorization also accepts the authenticated Buyer's current inbox channel.

Tests: `apps/buyer-mobile/test/messaging_layout_test.dart`, `messaging_realtime_test.dart`, and `services/api/tests/Feature/Api/PhaseNineMessagingTest.php`.

Evidence: `docs/design/evidence/buyer-messaging/{inbox,conversation,empty-inbox}.png` and this report. Screenshots use synthetic fixtures, not live stores.

No migrations, credentials or environment files changed. No Git commands, deployment or production actions were performed.

## Security

The Buyer inbox channel is bound to the current account and account version through an opaque HMAC. Another Buyer or any Vendor cannot join it. Suspended accounts receive no inbox broadcasts; changed account versions cannot authorize the old channel. Inbox socket events contain only an empty invalidation payload. Conversation content and files always require fresh authorized REST access. Conversation creation emits the invalidation through the existing transactional outbox after commit.

## Validation

- Focused API messaging: **16 passed, 280 assertions**.
- Complete isolated API regression: **390 passed, 6,353 assertions**.
- PHPStan: no errors across 309 source files. Pint: 448 files passed.
- Focused Flutter messaging: **16 passed**, including real loopback WebSocket subscription, heartbeat/reconnection, disposal during configuration, incoming inbox/thread events, refresh races, background/resume, retry identity, shared empty state, responsive layouts, quotation actions and golden comparisons.
- Final full Flutter regression: **202 passed, 1 intentionally skipped**, zero failures. The skip is the existing opt-in Phase 7 capture.
- Flutter analysis: no issues.
- OpenAPI validation passed with three existing unused-model recommendations. Messaging route/schema contract passed for all 25 authorized operations. Generated TypeScript build and Dart serializer generation passed.
- Gitleaks scans of Buyer source/tests, messaging API domain/controllers/tests and generated clients: zero findings. Source formatting and whitespace/conflict-marker review passed.
- All three previews were visually inspected. Portrait widths 320/390/768 and landscape shell navigation at 844x390 with doubled text are covered.

## Live runtime limitation

Read-only inspection of the current local API found `BROADCAST_CONNECTION=reverb`, configured app credentials and Redis queues. The queue worker and scheduler containers are running. However, its configured Reverb endpoint is `localhost:8081`, unreachable from the API container, and no host Reverb process was found. The server port default is also 8080 rather than the configured client port 8081. A physical phone's localhost does not point to the development computer.

Immediate live-device delivery therefore still needs a running Reverb service, consistent port 8081, and a host reachable from both the API container and phone (or an explicitly configured forwarding arrangement). Existing `REVERB_HOST`, `REVERB_PORT`, `REVERB_SCHEME`, `REVERB_SERVER_PORT` and explicit `REVERB_ALLOWED_ORIGINS` must match that local topology. Keep existing credentials private and unchanged. Workers must load the new broadcasting code. No environment edits were made because the saved workspace instruction prohibits modifying env/secrets without authorization.

The UI and real-time code are implemented and tested, but a live authenticated Buyer/Vendor device journey is not claimed. Local loopback WebSocket tests do not establish device network reachability. No fabricated presence, message previews, stock or conversation deletion was added.

Suggested conventional commit: `feat(buyer): align messaging layout and add private inbox updates`.
