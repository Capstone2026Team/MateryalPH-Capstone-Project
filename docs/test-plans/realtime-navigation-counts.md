# Realtime navigation counts — 2026-10-12

Navigation counts now synchronize through the existing private Reverb notification channel and authorized REST read models. No schema migration, new dependency, permission, business status or environment key was introduced.

## Cause and implementation

Conversation changes previously reached conversation/inbox channels, while the Vendor sidebar's section summary only refreshed on local read actions or its timer. Notification invalidations updated the bell without refreshing the other section counts. Order state outbox events did not invalidate navigation. Admin only displayed its notification unread total, and Buyer had no global message/order/dispute count snapshot. Buyer cart shortcuts displayed distinct line counts.

`NavigationUpdates` reuses the current order, conversation, dispute and Admin operational queue scopes. `NavigationBroadcast` publishes content-free `navigation.changed` invalidations through the current `NotificationChannel`, rechecking account and role authority at delivery. Existing conversation/order/dispute outbox events now drive this channel. Cart mutations persist a `CART_CHANGED` outbox event in their transaction. Successful verification, compliance, review moderation, privacy, invoice, fulfillment assignment, enforcement and operational retry audits enqueue navigation invalidations. Terminal outbox failures invalidate the authorized integration queue, with a guard against recursive invalidation failures. Dispute sanction referrals also invalidate the authorized enforcement queue.

Web counters share `useNavigationUpdates`, `PortalResourceStore` and one reference-counted socket per portal/session. Invalidations arriving during a GET cause a subsequent authoritative reload; bursts coalesce. Successful mutations refresh counts locally. Reconnection and foreground/online recovery refresh state, heartbeats recover silent connections, and a 30-second authority probe replaces a still-connected stale channel. A 15-second REST safety poll covers missed events and socket outages. Mounted counters survive navigation/filter cache eviction. A successful read keeps an in-flight GET barrier so an older shared response cannot replace the remaining count. Session cleanup cancels subscriptions and timers; old responses cannot restore snapshots, expire a newer session, or apply its rate-limit cooldown to the new account. The existing notification-count hook now uses this same snapshot.

Buyer `NavigationCountsController` shares the notification socket and foreground lifecycle through `NotificationScope`. Its counts drive Messages, Profile Orders/Disputes and the shared cart shortcut on Map, Explore, search, Product Details and Messages. Successful server-returned cart views publish exact fixed-point quantity totals immediately; older count responses cannot overwrite a newer cart version. The server reads quantity and version in one SQL snapshot. Notification inbox pagination and existing mandatory notification preferences remain intact.

Mounted Vendor Orders/Disputes and Admin verification/compliance/dispute lists refresh their existing read models automatically, preserving query/filter state. The shared `CountBadge` implementations hide zero and display `99+`, retaining the full count in control labels. Existing expanded/collapsed sidebar behavior and navigation destinations remain in place. Team Accounts headcounts remain in the legacy API for compatibility and are no longer displayed as attention badges.

## Counting rules

| Surface | Count |
| --- | --- |
| Messages | Received messages without the current viewer's read receipt, within the existing canonical inbox/handler/assignment scope; Buyer uses the unarchived SALES inbox |
| Notifications | Authorized, enabled, unread in-app notices across all records |
| Buyer/Vendor Orders | Current visible orders excluding COMPLETED, DECLINED, EXPIRED and CANCELLED |
| Buyer/Vendor Disputes | Existing `DisputeRules::ACTIVE`; DECIDED remains active until the case concludes |
| Cart | Exact quantity sum of active selected lines; saved-for-later is excluded; unit decimal precision is preserved |
| Vendor Fulfillment | Visible confirmed, processing and handover-stage orders; Fulfillment Staff retain assignment scope |
| Vendor E-Invoices | Outstanding REQUESTED/RETURNED_FOR_CORRECTION requests; reading a notice does not fulfill a request |
| Vendor Products | Authorized unread product notices |
| Admin | Permission-scoped pending verification, compliance, dispute review/appeal, enforcement referral, review report, overdue invoice, privacy, refund/reimbursement and failed-job queues; informational dashboard totals are excluded |

## Files and contract

- API: `NavigationUpdates`, `NavigationBroadcast`, `VendorNavigationUpdates`, the existing order/dispute count queries, `OutboxProcessor`, `AuditRecorder`, `CartService`, `NotificationController` and notification routes.
- Shared web UI: `use-navigation-updates`, `use-navigation-refresh`, `notification-realtime`, portal resource synchronization, `count-badge`, sidebar styling and session transport generation guards. Vendor/Admin shells and relevant list consumers reuse them.
- Buyer: notification repository/scope, `navigation_counts_controller`, `private_realtime`, `count_badge`, `buyer_cart_button`, cart controller, home/profile and existing cart shortcut consumers. The application disposes the repository's shared resources.
- Local validation artifacts are excluded through `/.tmp/realtime-counts/` in `.gitignore`.
- Tests: `NavigationUpdatesTest`, the invoice badge expectation in `PhaseThirteenDisputesTest`, web count/socket/resource/session tests, asynchronous evidence URL cleanup verification, Buyer count tests and notification contract checks.
- `GET /api/v1/{buyers|vendor|admin}/navigation-updates` uses `NavigationUpdates`: fixed-path `sections`, plus Buyer-only `cart_quantity` and `cart_version`. The Vendor endpoint remains compatible with its existing generated operation.
- OpenAPI documents cookie/CSRF and native bearer transports plus `navigation.changed`. TypeScript and Dart clients/builders are regenerated from source. The existing `OFF` vacation enum value was quoted so the order contract's YAML ambiguity guard passes; its business meaning is unchanged.

## Validation evidence

All database tests ran in the guarded `materyalph_phase1_test-api-test-1` container; no development reset, seed or migration was performed. Raw local logs and pre-edit comparisons are under `.tmp/realtime-counts/`.

| Check | Result |
| --- | --- |
| Final count/notification/Admin API edge suites | 23 passed, 436 assertions |
| Final related API regression, 10 suites | 106 passed, 1 existing failure, 2,923 assertions |
| Exact cart snapshot, lifecycle, scope, replay and failure checks | All 6 NavigationUpdatesTest cases pass in the edge suite |
| Final focused web count/socket/inbox/session tests | 49 passed |
| Full Vendor suite | 382 passed, 4 existing failures, 45 files (386 tests) |
| Full Admin suite | 90 passed, 21 files |
| Focused Buyer count/socket/notification tests | 23 passed |
| Broader Buyer cart/profile/notification run | 48 passed, 4 existing failures |
| PHPStan | No errors |
| Pint | Affected PHP files pass |
| Vendor/Admin lint, typecheck and builds | Passed; existing large-chunk advisories remain |
| Flutter analysis | No issues found |
| OpenAPI validation and notification/messaging/order/dispute checks | Passed; unused-model recommendations remain |
| Generated TS build and Dart build_runner | Passed |
| Compose configuration | Passed |
| Scoped Gitleaks filesystem scan | No leaks in 62 affected source/test/contract/config files |
| Changed-source whitespace/conflict check | No issues |
| Live local Reverb smoke | Private subscription, signed publication and socket delivery passed |

Relevant regression commands:

```text
docker exec materyalph_phase1_test-api-test-1 php artisan test --compact --no-ansi tests/Feature/Api/NavigationUpdatesTest.php tests/Feature/Api/VendorNavigationUpdatesTest.php tests/Feature/Api/NotificationRealtimeTest.php tests/Feature/Api/NotificationInboxTest.php tests/Feature/Api/PhaseEightOrdersTest.php tests/Feature/Api/PhaseNineMessagingTest.php tests/Feature/Api/PhaseTwelveFulfillmentTest.php tests/Feature/Api/PhaseThirteenDisputesTest.php tests/Feature/Api/PhaseFifteenNotificationsTest.php tests/Feature/Api/PhaseSixteenAdminOperationsTest.php
cd apps/vendor-web && npm.cmd run test -- --run --maxWorkers=2
cd apps/admin-web && npm.cmd run test -- --run --maxWorkers=1
cd apps/buyer-mobile && flutter test --no-pub test/navigation_counts_test.dart test/notification_inbox_controller_test.dart test/notification_realtime_test.dart test/messaging_realtime_test.dart test/notifications_api_test.dart
cd packages/api-contract && npm.cmd run validate && npm.cmd run test:notifications-contract && npm.cmd run test:messaging-contract && npm.cmd run test:orders-contract && npm.cmd run test:disputes-contract
node scripts/check-local-reverb.mjs
```

On this Windows session Docker and Flutter/Dart needed access to their installed SDK/CLI locations. Flutter checks used the installed Dart executable and `flutter_tools.snapshot`; results are from executed checks. No Git commands were used. Scoped filesystem secret and changed-source whitespace checks replace the prohibited staged-Git checks.

The evidence-popup cleanup assertion now waits for React to release the final local URL, retaining its exact all-URLs-revoked condition. The API fee failure (`PhaseEightOrdersTest`, line 160), four Vendor order-document-link expectations and four Buyer cart/profile expectations reproduce with pre-edit source classes/pages. They were retained. Counter behavior tests, authorization, transaction rollback, outbox replay, concurrent invalidations, missed events, account changes and reconnections pass.

## Development and manual acceptance

The running API confirms Reverb and Redis drivers, and the private socket smoke passes. Development `migrate:status` shows all existing migrations applied, and all three count routes are registered. The existing horizon-named service currently runs `queue:work`; the Horizon command namespace is unavailable in that runtime. Its worker was signaled to finish gracefully and started again to load the updated handlers. No environment/credential files were changed. No new setup keys are required.

Automated isolated role/session tests and the live Reverb transport smoke do not establish a complete logged-in Buyer-phone/Vendor-browser/Admin-browser journey. Manual acceptance still needs those actual sessions:

1. Keep Vendor on a page outside Messages; send a Buyer inquiry and verify the unread sidebar count, then read it and verify other sessions clear their count.
2. Add/update/remove selected cart quantities, including fractional units; verify all Buyer shortcuts agree and another active device catches up. Saved-for-later stays outside the active total.
3. Confirm, complete or cancel orders, and conclude disputes; verify terminal records leave the active profile counts while applicable pending Vendor/Admin work changes.
4. Submit/review verification and compliance requests and fulfill invoice requests; verify current authorized pending counts across Admin sessions. Reading a notice leaves unfinished work counted.
5. Disconnect/reconnect the socket, background/resume Buyer, switch accounts, reload pages and send simultaneous events. Verify automatic recovery and absence of prior-account badges.
6. Check expanded/collapsed sidebars and mobile layouts with enlarged text. Badges hide at zero and controls announce full counts.

Suggested commit, when authorized: `fix(notifications): synchronize navigation counters across roles`.
