# Buyer notifications repair — 2026-10-14

The later [Vendor message notification correction](vendor-message-notifications-2026-10-14.md)
connects incoming chat messages to this notification infrastructure. The setup
repair below alone did not create notifications when a Vendor sent a message.

## Confirmed causes

Read-only local diagnostics confirmed that the API's Firebase service-account
credentials were structurally valid and matched its configured project. The
Android app, sender and project identifiers matched the supplied native config.
The notification schema, Redis queue, worker and scheduler were available.
There were 35 persisted and currently authorized Buyer notifications (one
unread), zero active Buyer devices, no push
delivery rows and no pending notification outbox jobs.

The development Flutter config explicitly disabled Firebase push. Startup did
not request permission or register an existing token; only the settings button
registered a device. Android did not apply the Google services plugin, so the
supplied `google-services.json` was not processed for native Firebase startup.
The connected phone had notification permission denied and neither local API
nor realtime port forwarded over USB. Foreground FCM messages refreshed data
without any visible in-app alert.

## Repair

- Enabled push in the existing ignored development config. Native mobile builds
  default to enabled, with an explicit `FIREBASE_PUSH_ENABLED=false` opt-out.
- Process Android's ignored `android/app/google-services.json` when present.
  Copy the ignored iOS `ios/Runner/GoogleService-Info.plist` into the app bundle
  when present, add remote-notification background mode and push entitlements.
  Initialization reads native configuration instead of reusing one platform's
  Dart app ID on another platform.
- After authenticated sign-in/session restore and on resume, register the
  current FCM token if permission is authorized or provisional. Prompt once
  for undecided permission, including Android's initial `denied` result. An
  explicit settings retry explains persistent OS denial. Unsupported platforms
  use the normal inbox without invoking Firebase Messaging.
- Serialize token rotation, register before revoking an older device, retain
  the working registration when a request fails, and reject late storage writes
  or callbacks after disposal/logout. Registration still uses the existing
  authenticated, encrypted, session-bound API endpoint.
- The inbox shows the actual title and event/message preview, as refined in the
  later Vendor-message corrections. Reverb and polling update the inbox and
  unread badges. Firebase displays the device banner and refreshes REST state;
  the duplicate arrival snackbar was removed at the owner's request. Notification
  targets are still resolved and authorized by the server using the opaque notice
  ID, and provider-supplied paths are never trusted for navigation.
- Restored USB forwarding for ports 8080 and 8081 on the connected phone.
- Disabled Windows Gradle command echo even when `DEBUG` is set, so encoded
  client build configuration is not printed with build arguments.

No migrations, commercial rules, API responses or generated clients changed.
Server credentials and existing notification preferences were preserved.

## Files changed

- Flutter: `lib/features/notifications/buyer_push.dart`,
  `notification_arrivals.dart`, `notification_settings_screen.dart`,
  `notifications_repository.dart`, and `lib/screens/buyer_home_screen.dart`.
- Android: `android/settings.gradle.kts`, `android/app/build.gradle.kts`,
  `android/app/src/main/AndroidManifest.xml`, and `android/gradlew.bat`.
- iOS: `ios/Runner/Info.plist`, `ios/Runner/Runner.entitlements`, and
  `ios/Runner.xcodeproj/project.pbxproj`.
- Tests: `test/buyer_push_test.dart` and `test/notification_arrivals_test.dart`.
  These Flutter/native/test paths are relative to `apps/buyer-mobile`.
- Diagnostics/documentation: `scripts/inspect-notification-runtime.php`,
  `README.md`, and this test plan. The existing ignored
  `apps/buyer-mobile/config/development.json` now enables push.

## Local use

From `apps/buyer-mobile`, rebuild rather than hot-reload native Gradle changes:

```powershell
flutter run --dart-define-from-file=config/development.json
```

On the phone, allow MateryalPH notifications. If Android previously refused the
permission, enable it in the phone's application Settings, return to MateryalPH,
and use Notification settings → Enable device notifications. The inbox remains
available without OS notification permission.

For a single USB-connected Android phone using the development localhost API:

```powershell
adb reverse tcp:8080 tcp:8080
adb reverse tcp:8081 tcp:8081
```

Read-only server diagnostics return readiness booleans and aggregate counts;
they never output credentials, tokens, notification contents or identities:

```powershell
docker compose exec -T api php /workspace/scripts/inspect-notification-runtime.php
```

## Automated validation

- `flutter analyze`: no issues.
- Focused Buyer push, arrivals, inbox, realtime and notification API tests:
  30 passed, including token rotation, permission denial, failed registration,
  disposal races, opaque-ID routing, historical-alert suppression and a
  transaction committing an older notification ID after a newer one.
- Isolated API `PhaseFifteenPushAdapterTest`, `PhaseFifteenNotificationsTest`,
  `NotificationInboxTest`, `NotificationRealtimeTest`: 23 passed, 324 assertions.
- `php -l scripts/inspect-notification-runtime.php`: passed.
- `docker compose config --quiet`: passed.
- Android ARM64 debug APK build: passed with existing Gradle/AGP/Kotlin
  deprecation warnings. Generated Firebase app, sender and project resources
  match the supplied native config. The APK was not installed or launched on
  the phone as part of automated validation.
- OpenAPI validation and notification contract checks: passed (eight existing
  unused-model recommendations from OpenAPI validation).
- Changed-source secret scan: passed; no leaks found.
- Full `flutter test`: 368 passed, one skipped, 37 failed. Twenty-seven failure
  messages were image/golden mismatches. Other failures cover old profile/inbox
  labels, checkout interactions, location, order fulfillment, Projects and review
  expectations. The notification-specific regression suite remains green.
  This full-suite gate is not claimed clean, and unrelated behavior and golden
  references were not changed to satisfy it.

The live Firebase provider, rebuilt phone behavior and iOS APNs/signing are not
established by mocked tests. Windows cannot build or sign iOS; use Xcode with
the existing environment-specific APNs setup to verify iOS receipt and tapping.
From `apps/buyer-mobile` on macOS, the native build command is
`flutter build ios --debug --dart-define-from-file=config/development.json`.
No notifications were fabricated or sent to real users during diagnosis.

Firebase documents both the [Android Google services plugin requirement](https://firebase.google.com/docs/android/setup)
and [foreground FCM display behavior](https://firebase.google.com/docs/cloud-messaging/flutter/receive-messages).
