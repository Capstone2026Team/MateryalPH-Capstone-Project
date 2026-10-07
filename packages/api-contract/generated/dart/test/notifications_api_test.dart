import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for NotificationsApi
void main() {
  final instance = MateryalphApiClient().getNotificationsApi();

  group(NotificationsApi, () {
    // get Notification Preferences
    //
    //
    //
    //Future<GetNotificationPreferences200Response> getNotificationPreferences(String audience) async
    test('test getNotificationPreferences', () async {
      // TODO
    });

    // list Notification Failures
    //
    //
    //
    //Future<ListNotificationFailures200Response> listNotificationFailures({ int page }) async
    test('test listNotificationFailures', () async {
      // TODO
    });

    // list Notifications
    //
    // Cursor feed filtered by current membership, role, assignment and preferences. Authoritative records precede delivery.
    //
    //Future<ListNotifications200Response> listNotifications(String audience, { String cursor }) async
    test('test listNotifications', () async {
      // TODO
    });

    // read Notification
    //
    //
    //
    //Future<RevokeNotificationDevice200Response> readNotification(String audience, String noticeId) async
    test('test readNotification', () async {
      // TODO
    });

    // register Notification Device
    //
    // Encrypted session-bound token registration. Web requires deployment approval. Token never returned.
    //
    //Future<RegisterNotificationDevice201Response> registerNotificationDevice(String audience, NotificationDeviceInput notificationDeviceInput) async
    test('test registerNotificationDevice', () async {
      // TODO
    });

    // resolve Notification
    //
    // Fresh authenticated session and resource authorization required. Returns only an allowlisted same-application path; denied links return NOTICE_ACCESS_REVOKED.
    //
    //Future<ResolveNotification200Response> resolveNotification(String audience, String noticeId) async
    test('test resolveNotification', () async {
      // TODO
    });

    // revoke Notification Device
    //
    //
    //
    //Future<RevokeNotificationDevice200Response> revokeNotificationDevice(String audience, String deviceId) async
    test('test revokeNotificationDevice', () async {
      // TODO
    });

    // update Notification Preference
    //
    // Mandatory classes cannot be disabled. Unknown categories are rejected.
    //
    //Future<GetNotificationPreferences200Response> updateNotificationPreference(String audience, NotificationPreferenceInput notificationPreferenceInput) async
    test('test updateNotificationPreference', () async {
      // TODO
    });

  });
}
