# Vendor-to-Buyer message notifications — 2026-10-14

## Confirmed cause

The local runtime had 30 non-system Vendor conversation messages and zero
`MESSAGES` notification rows. The phone was registered and a Firebase delivery
was already recorded as `SENT`. The prior Firebase setup repair did not connect
message insertion to the notification system.

`ConversationService::append()` saved the message and published only
`CONVERSATION_CHANGED`. That event refreshed conversations and navigation
counts; it did not create a notification inbox entry or a Firebase delivery.
`NotificationPolicy` also lacked conversation targets, and Buyer could not open
a message conversation from a notification.

## Resulting behavior

Each newly committed non-system Vendor message creates one notification for
that conversation's Buyer in the same transaction. Text messages and clean
attachments share this behavior across sales and fulfillment threads.
Duplicate sends with the same client message identifier do not create extra
notifications. Buyer-sent messages and system history entries do not notify the
Buyer about their own activity. Old messages are preserved without backfilling
historical alerts.

Following the owner's notification-preview request, the title identifies the
actual public sender and store: `Juan Cruz · Sample Hardware`. The body previews
the message, for example `Your cement is ready for pickup.` Private profile
contact fields and attachment names are excluded. Public names fit the title
column, and message previews are collapsed to one line and capped at 320 display
characters. Attachment-only and product-only messages use `Sent an attachment`
or `Sent a product: [public product name]`. Full chat text stays immutable.
Other mobile notifications display their actual event title and a bounded
summary. Realtime broadcasts still carry no notification or message contents.

The existing post-commit notification outbox broadcasts a private invalidation
and queues delivery to the registered phone. REST feed, resolution, read and
queued delivery retain current recipient/account/conversation authorization.
Selecting View resolves `/messages/{conversationId}` on the server and opens
the existing Buyer conversation screen.

`MESSAGES` is an optional category, enabled by default for in-app and push;
email defaults to disabled. Existing mandatory categories retain their rules.
Reading a conversation marks only its corresponding message notices through
the captured message cutoff as read. Later messages remain unread, and queued
delivery skips already-read notices.

## Files and contract

- API: `ConversationService.php`, `NotificationPolicy.php`,
  `NotificationService.php`, `NotificationDelivery.php`, and
  `NotificationController.php`.
- Buyer: `notification_arrivals.dart`, `buyer_home_screen.dart`, and
  `notification_arrivals_test.dart`.
- API tests: `MessageNotificationsTest.php`.
- Contract: `packages/api-contract/openapi.yaml`, notification contract checks,
  and regenerated TypeScript/Dart APIs, preference model documentation and
  related generated test scaffolds. Generation refreshed 22 files; no wire
  fields or endpoint paths were added.

No migration or additional credentials are required. The local `horizon` queue
worker was restarted after checks passed to load the new notification policy.
Development commercial data and message history were not rewritten.

## Checks run

| Check | Result |
| --- | --- |
| New message notification API suite | 11 passed, 87 assertions |
| Related messaging/notification/push API suites | 64 passed, 1,145 assertions |
| Buyer messaging and notification regressions | 34 passed |
| `flutter analyze` | No issues |
| Laravel PHPStan, 512 MB | No errors |
| Pint on five changed API files and the new test | Passed |
| OpenAPI validation | Passed; eight existing unused-model recommendations |
| Messaging and notification contract checks | Passed |
| TypeScript and Dart client regeneration | Completed |
| Android ARM64 debug APK | Built successfully |
| Changed-source and generated-file secret scan | No leaks found |
| Docker Compose configuration | Passed |

The API tests used the isolated test database with provider/scanner fakes. They
cover sales and fulfillment delivery, idempotency, rejected sends, recipient
privacy, attachment privacy, transaction rollback, channel defaults, private
broadcasting, queued push, read cutoffs and authorization revocation. The broader
API run included `PhaseNineMessagingTest`, `PhaseFifteenNotificationsTest`,
`NotificationInboxTest`, `NotificationRealtimeTest`, and
`PhaseFifteenPushAdapterTest`.

This pass did not repeat the full Flutter suite. Its prior run had 368 passes,
37 failures and one skip, including unrelated interaction and golden failures;
that full-suite gate remains unresolved. Rebuilt phone UI receipt and iOS are
not claimed verified by the automated checks.

## Manual acceptance

Stop the running Flutter process completely, then from `apps/buyer-mobile` run:

```powershell
flutter run -d 110013341G000422 --dart-define-from-file=config/development.json
```

With Buyer signed in, send a new text message from the authorized Vendor. Check
the device push banner, notification bell and inbox entry. Tap the banner and verify
that it opens the correct conversation. Reading the conversation should clear
its corresponding unread notices; another Buyer must not see the notice.
Repeat with a clean photo and an authorized fulfillment thread. Push while the
app is backgrounded also requires the phone's notification permission.

## Native foreground push correction

After the message event repair, read-only diagnostics found one active Buyer
device, three Firebase deliveries recorded as `SENT`, no pending notification
outbox events, and Android `POST_NOTIFICATIONS` permission granted. These
provider acceptances do not prove that a banner appeared on the phone.

The remaining display gap was `BuyerPush`'s foreground Firebase callback: it
only refreshed REST data. Firebase suppresses automatic foreground banners on
both mobile platforms by default. See [Firebase foreground message behavior](https://firebase.google.com/docs/cloud-messaging/flutter/receive-messages#foreground_and_notification_messages).

The app now uses `flutter_local_notifications` to display foreground Firebase
messages immediately, without waiting for an online inbox reload. Android
creates the high-importance `materyalph_updates` channel with sound/vibration
and a monochrome notification icon. Both the manifest default and Laravel's
Android push payload select this channel. iOS local presentation requests a
banner and sound; Firebase's automatic foreground presentation stays disabled
to prevent duplicate alerts. APNs remote payloads request default sound.

Only the opaque notice ID enters device tap payloads. Foreground copy now mirrors
the server-supplied Firebase notification title and body, matching background
pushes; provider-supplied routes are ignored. The notification drawer shows the
actual sender/preview or event summary, with phone lock-screen visibility
settings respected.
Warm and cold taps enter the existing server-authorized notice resolution and
conversation route. Duplicate foreground deliveries display once per notice
within the session. Session disposal stops tap callbacks and clears delivered
device notifications; native display/clear operations are ordered across
sessions so delayed work cannot clear a new account's notification.

Additional changed files: `buyer_device_notifications.dart`, `buyer_push.dart`,
their tests, `pubspec.yaml`/`pubspec.lock`, Android app Gradle/manifest/icon,
iOS `AppDelegate.swift`, `FcmPushGateway.php` and its adapter tests. No migration,
API request/response changes, generated API changes or new credentials are
required for this correction. Flutter also regenerated native plugin registration
for macOS and Windows. The local queue worker was restarted with the new
platform presentation payload; its Firebase readiness and queue checks passed.

| Latest focused check | Result |
| --- | --- |
| Buyer push, device presentation, inbox and messaging suites | 42 passed |
| Isolated message notification and FCM adapter API suites | 15 passed, 97 assertions |
| Laravel PHPStan, 512 MB | No errors |
| `flutter analyze` | No issues |
| Android ARM64 debug APK | Built successfully; Gradle task 266.2 seconds |
| Pint on the changed adapter and its tests | Passed |
| Docker Compose configuration | Passed |
| Changed-source/native-registration secret scan | No leaks found across 17 files |
| Changed-source whitespace review | No nonblank trailing whitespace |

Full-suite failures recorded above remain outside the focused fix. Phone banner
appearance and iOS signing/APNs are manual acceptance gates.

This correction adds a native plugin: hot reload and hot restart cannot install
it. Use the full stop/run instructions above, allow notifications, leave Buyer
on Explore/Profile rather than the open conversation, and send a new Vendor
message. Check the device banner and sound, tap it to open that conversation,
then repeat with Buyer backgrounded. Notification preferences and reading the
conversation still control queued delivery; already-read messages are skipped.

## Sender and event previews — owner request

The phone screenshot confirmed native notification delivery but showed the
generic copy hard-coded in both the FCM adapter and local presenter. The message
notice body also only said to open the conversation.

`ConversationService` now snapshots public sender/store identity and a bounded
message preview in the same transaction as the original chat. The typed
`PushNotification` display payload carries the authorized notice title/body
through `NotificationDelivery`, both gateway adapters and FCM. Unicode is sent
as UTF-8, and long/multiline content is bounded without changing chat history.
Foreground device banners display that same copy with expanded Android body
text. The in-app notification inbox uses the authorized title and body for every
category. The later snackbar removal below replaces duplicate arrival alerts.

Queued delivery still rechecks recipient, account, conversation, preferences,
device/session and unread-message state. No routes, private file references,
profile contact fields or backend credentials are added to the push data.
Sender renames do not rewrite earlier message/notice attribution. Existing
notifications are not backfilled or rewritten; test with a new message.

This pass changes `PushNotification.php`, `PushGateway.php`,
`NotificationDelivery.php`, `ConversationService.php`, both push gateway
adapters, the three Buyer notification helpers and their tests, API preview
tests, Buyer Workflow, OpenAPI notification descriptions and generated clients.
No migration, new endpoint, new wire field or new key is required.

| Preview correction check | Result |
| --- | --- |
| Six related API suites in the isolated database | 68 passed, 1,182 assertions |
| Eight Buyer notification/messaging suites | 42 passed |
| `flutter analyze` | No issues |
| Laravel PHPStan, 512 MB | No errors |
| Pint on the eight changed PHP files | Passed |
| OpenAPI validation | Passed; eight existing unused-model recommendations |
| Messaging and notification contract checks | Passed |
| TypeScript/Dart regeneration | Completed; nine generated files changed |
| Android ARM64 debug APK | Built successfully; Gradle task 252.9 seconds |
| Docker Compose configuration | Passed |
| Source/documentation/generated-client secret scan | No leaks across 29 files, approximately 1.93 MB |
| Source/generated whitespace review | No nonblank trailing whitespace |

The local `horizon` worker was reloaded after the checks. Its credentials,
project, notification schema and Redis readiness checks passed; safe aggregate
diagnostics reported one active Buyer device, nine accepted push deliveries and
no pending notification outbox events. Aggregate `SENT` counts are not a claim
that every preview was visually reviewed on the phone.

After reloading the local worker, restart Buyer and send a new Vendor message.
Check the public sender/store title and actual body preview in the foreground
banner, background drawer and in-app notification entry. Send an order update
and verify its actual event title/summary. Expand a longer Android notification,
tap each record to verify protected routing, and verify that reading or disabling
the optional message channel still suppresses queued message pushes.

Device display and iOS remain manual acceptance gates; existing full Flutter
suite failures reported above were not reclassified as passing by these checks.

## Remove duplicate in-app snackbar — owner request

The owner requested removal of the bottom `New message … / View` snackbar
because device push notifications now provide the arrival banner. Removed the
Buyer shell's arrival listener and snackbar callback, and deleted the unused
`notification_arrivals.dart` helper and its dedicated tests. Device push
presentation/taps, REST/realtime inbox and unread badges retain their behavior.
Registration errors and unrelated action feedback still use their existing UI.
No API contract, migration, backend or credential change is required.

Restart Buyer, send a new Vendor message while on Explore, and verify the device
push banner and inbox/badge update without a bottom message snackbar.
The focused push/device-presentation/inbox regression run passed all 26 tests;
no device UI test was run for this presentation removal.

Suggested commit: `fix(buyer): remove duplicate notification snackbar`.
