import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for NotificationsApi
void main() {
  final instance = MateryalphApiClient().getNotificationsApi();

  group(NotificationsApi, () {
    // Pusher protocol signature only for the caller's current private-notifications channel. Foreign, stale and other domain channels are denied; current account, audience and membership are rechecked. Web requires HttpOnly cookies and CSRF; native Buyer uses bearer transport. Events carry only content-free notifications.changed invalidations and never authorize REST data access.
    //
    //Future<NotificationChannelAuthResponse> authorizeNotificationChannel(String audience, ChatChannelAuth chatChannelAuth) async
    test('test authorizeNotificationChannel', () async {
      // TODO
    });

    // get Notification Preferences
    //
    //
    //
    //Future<GetNotificationPreferences200Response> getNotificationPreferences(String audience) async
    test('test getNotificationPreferences', () async {
      // TODO
    });

    // Current Buyer, Vendor or Admin notification invalidation channel and public Reverb connection settings. The opaque channel rotates with account or membership authority. No notice contents or backend credentials are returned. Clients re-fetch on reconnect and poll while unavailable.
    //
    //Future<ChatRealtimeResponse> getNotificationRealtime(String audience) async
    test('test getNotificationRealtime', () async {
      // TODO
    });

    // Current caller's authorized unread in-app notice count across all types. Archived, foreign, revoked and disabled optional notices are excluded. Web uses HttpOnly cookies; mobile Buyer uses bearer transport.
    //
    //Future<GetNotificationUnreadCount200Response> getNotificationUnreadCount(String audience) async
    test('test getNotificationUnreadCount', () async {
      // TODO
    });

    // Active orders and unread updates for Vendor navigation
    //
    // Orders counts currently visible nonterminal orders, excluding COMPLETED, DECLINED, EXPIRED and CANCELLED, independently of notification history. Team Accounts counts manageable active non-Owner memberships whose user accounts are active; deleted memberships and unaccepted invitations are excluded, and delegated Managers count only non-manager staff. Other sections count unread in-app notifications by their authorized destination and unread messages in the current user's inbox. Store Profile has no indicator. Rechecks current membership, role, delegation, assignment and preferences. Only fixed sidebar paths and counts are returned; visiting a section does not mark updates read.
    //
    //Future<GetVendorNavigationUpdates200Response> getVendorNavigationUpdates() async
    test('test getVendorNavigationUpdates', () async {
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
    // Cursor feed filtered by current membership, role, assignment and preferences, newest first. Read notices are retained and available in the Archived view; no notification is deleted by reading it. Clients can assemble cursor pages for immediate local status and notification-category filters. Authoritative records precede delivery.
    //
    //Future<ListNotifications200Response> listNotifications(String audience, { String cursor }) async
    test('test listNotifications', () async {
      // TODO
    });

    // Mark the current filtered notification view read and archived
    //
    // Atomically marks the caller's authorized unread notices at or before through_id as read, optionally matching a notification category or legacy exact display title. The captured upper bound leaves later arrivals unread. Rechecks current account, membership, role, resource access and in-app preferences. Notices and required security history are retained and remain accessible in Archived. Naturally idempotent; retries do not change existing read timestamps. Audits the changed count and queues a private content-free inbox invalidation after commit.
    //
    //Future<MarkNotificationsRead200Response> markNotificationsRead(String audience, NotificationReadFilter notificationReadFilter) async
    test('test markNotificationsRead', () async {
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
