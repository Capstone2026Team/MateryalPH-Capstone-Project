import 'dart:typed_data';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;
import '../../core/api_guard.dart';
import '../../core/private_realtime.dart';
import '../map_discovery/discovery_repository.dart' show newIdempotencyKey;
import 'notification_inbox_controller.dart';

class NotificationsRepository implements NotificationInboxTransport {
  NotificationsRepository(
    api.MateryalphApiClient client,
    Future<void> Function() onExpired,
  ) : _api = client.getNotificationsApi(),
      _reports = client.getReportingApi(),
      _onExpired = onExpired;
  final api.NotificationsApi _api;
  final api.ReportingApi _reports;
  final Future<void> Function() _onExpired;
  Future<void> Function()? _sessionExpiry;
  ApiGuard get _guard {
    final version = inbox.accessVersion;
    return ApiGuard(() async {
      // A late 401 from the previous session must not end a newly signed-in account.
      if (version != inbox.accessVersion) return;
      await (_sessionExpiry?.call() ?? _onExpired());
    });
  }

  late final inbox = NotificationInboxController(this);

  /// The mounted Buyer shell also clears its configured private discovery store.
  void Function() attachSessionExpiry(Future<void> Function() callback) {
    _sessionExpiry = callback;
    return () {
      if (_sessionExpiry == callback) _sessionExpiry = null;
    };
  }

  @override
  Future<api.ListNotifications200Response> list([String? cursor]) =>
      _guard.call(
        () async => _guard.required(
          (await _api.listNotifications(
            audience: 'buyers',
            cursor: cursor,
          )).data,
        ),
      );
  @override
  Future<api.NotificationBulkReadAction> readAll(
    String throughId,
    String? category,
  ) => _guard.call(
    () async => _guard
        .required(
          (await _api.markNotificationsRead(
            audience: 'buyers',
            notificationReadFilter: api.NotificationReadFilter(
              (b) => b
                ..throughId = throughId
                ..category = category,
            ),
          )).data,
        )
        .data,
  );

  @override
  Future<void Function()> watch(void Function() refresh) =>
      watchPrivateRealtime(
        null,
        refresh,
        events: const {'notifications.changed'},
        configuration: () => _guard.call(
          () async => _guard
              .required(
                (await _api.getNotificationRealtime(audience: 'buyers')).data,
              )
              .data,
        ),
        authorize: (socketId, channelName) => _guard.call(
          () async => _guard
              .required(
                (await _api.authorizeNotificationChannel(
                  audience: 'buyers',
                  chatChannelAuth: api.ChatChannelAuth(
                    (b) => b
                      ..socketId = socketId
                      ..channelName = channelName,
                  ),
                )).data,
              )
              .data
              .auth,
        ),
      );
  Future<List<api.NotificationPreference>> preferences() => _guard.call(
    () async => _guard
        .required(
          (await _api.getNotificationPreferences(audience: 'buyers')).data,
        )
        .data
        .toList(),
  );
  Future<void> preference(
    api.NotificationPreference value,
    String channel,
    bool enabled,
  ) => _guard.call(() async {
    await _api.updateNotificationPreference(
      audience: 'buyers',
      notificationPreferenceInput: api.NotificationPreferenceInput(
        (b) => b
          ..category = value.category
          ..inApp = channel == 'inApp' ? enabled : value.inApp
          ..email = channel == 'email' ? enabled : value.email
          ..push = channel == 'push' ? enabled : value.push,
      ),
    );
  });
  @override
  Future<String> resolve(String id) => _guard.call(() async {
    final result = _guard
        .required(
          (await _api.resolveNotification(
            audience: 'buyers',
            noticeId: id,
          )).data,
        )
        .data
        .path;
    await _api.readNotification(audience: 'buyers', noticeId: id);
    return result;
  });
  Future<String> register(String token, bool ios) => _guard.call(
    () async => _guard
        .required(
          (await _api.registerNotificationDevice(
            audience: 'buyers',
            notificationDeviceInput: api.NotificationDeviceInput(
              (b) => b
                ..platform = ios
                    ? api.NotificationDeviceInputPlatformEnum.IOS
                    : api.NotificationDeviceInputPlatformEnum.ANDROID
                ..token = token,
            ),
          )).data,
        )
        .data
        .id,
  );
  Future<void> revoke(String id) => _guard.call(() async {
    await _api.revokeNotificationDevice(audience: 'buyers', deviceId: id);
  });
  Future<api.ListDocumentExports200Response> reports([int page = 1]) =>
      _guard.call(
        () async => _guard.required(
          (await _reports.listDocumentExports(
            audience: 'buyers',
            page: page,
          )).data,
        ),
      );
  Future<void> requestReport(
    String id,
    api.DocumentExportInputTypeEnum type,
    api.DocumentExportInputFormatEnum format,
    String purpose,
    String key,
  ) => _guard.call(() async {
    await _reports.requestDocumentExport(
      audience: 'buyers',
      idempotencyKey: key,
      documentExportInput: api.DocumentExportInput(
        (b) => b
          ..resourceId = id
          ..type = type
          ..format = format
          ..purpose = purpose,
      ),
    );
  });
  Future<Uint8List> download(String id) => _guard.call(
    () async => _guard.required(
      (await _reports.downloadDocumentExport(
        audience: 'buyers',
        exportId: id,
      )).data,
    ),
  );
  String newKey() => newIdempotencyKey();
}
