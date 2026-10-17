import 'dart:async';
import 'package:dio/dio.dart';
import 'navigation_counts_controller.dart';
import 'dart:typed_data';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;
import '../../core/api_guard.dart';
import '../../core/private_realtime.dart';
import '../map_discovery/discovery_repository.dart' show newIdempotencyKey;
import 'notification_inbox_controller.dart';

class NotificationsRepository
    implements
        NotificationInboxTransport,
        NavigationCountsTransport,
        NotificationDeviceRegistry {
  NotificationsRepository(
    api.MateryalphApiClient client,
    Future<void> Function() onExpired,
  ) : _api = client.getNotificationsApi(),
      _reports = client.getReportingApi(),
      _onExpired = onExpired,
      _client = client {
    _mutations = InterceptorsWrapper(
      onRequest: (options, handler) {
        options.extra['navigationEpoch'] = inbox.accessVersion;
        handler.next(options);
      },
      onResponse: (response, handler) {
        final request = response.requestOptions;
        if (request.extra['navigationEpoch'] == inbox.accessVersion &&
            request.path.contains('/buyers/') &&
            !const [
              'GET',
              'HEAD',
              'OPTIONS',
            ].contains(request.method.toUpperCase()) &&
            !RegExp(r'/(auth|typing)$').hasMatch(request.path) &&
            (response.statusCode ?? 500) < 300) {
          navigation.invalidate();
        }
        handler.next(response);
      },
    );
    client.dio.interceptors.add(_mutations);
  }
  final api.MateryalphApiClient _client;
  late final Interceptor _mutations;
  late final navigation = NavigationCountsController(this);
  final _noticeListeners = <void Function()>{};
  final _countListeners = <void Function()>{};
  void Function()? _stopRealtime;
  int _socketGeneration = 0;
  bool _watching = false;

  void dispose() {
    _client.dio.interceptors.remove(_mutations);
    inbox.dispose();
    navigation.dispose();
  }

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
  Future<BuyerNavigationCounts> counts() => _guard.call(() async {
    final value = _guard
        .required((await _api.getNavigationUpdates(audience: 'buyers')).data)
        .data;
    return BuyerNavigationCounts(
      messages: value.sections['/messages'] ?? 0,
      orders: value.sections['/orders'] ?? 0,
      disputes: value.sections['/disputes'] ?? 0,
      cartQuantity: value.cartQuantity ?? '0',
      cartVersion: value.cartVersion ?? 0,
    );
  });

  @override
  Future<void Function()> watch(void Function() refresh) =>
      _subscribe(refresh, counts: false);
  @override
  Future<void Function()> watchCounts(void Function() refresh) =>
      _subscribe(refresh, counts: true);

  Future<void Function()> _subscribe(
    void Function() refresh, {
    required bool counts,
  }) async {
    final listeners = counts ? _countListeners : _noticeListeners;
    listeners.add(refresh);
    void notify(Set<void Function()> callbacks) {
      for (final callback in callbacks.toList()) {
        callback();
      }
    }

    if (!_watching) {
      _watching = true;
      final generation = ++_socketGeneration;
      unawaited(
        watchPrivateRealtime(
          null,
          () {
            notify(_noticeListeners);
            notify(_countListeners);
          },
          events: const {'notifications.changed', 'navigation.changed'},
          onEvent: (event) {
            if (event == 'notifications.changed') notify(_noticeListeners);
            notify(_countListeners);
          },
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
        ).then((stop) {
          if (generation != _socketGeneration) {
            stop();
          } else {
            _stopRealtime = stop;
          }
        }),
      );
    }
    return () {
      listeners.remove(refresh);
      if (_noticeListeners.isEmpty && _countListeners.isEmpty) {
        _socketGeneration++;
        _watching = false;
        _stopRealtime?.call();
        _stopRealtime = null;
      }
    };
  }

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
  @override
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
  @override
  Future<void> revoke(String id) => _guard.call(() async {
    await _api.revokeNotificationDevice(audience: 'buyers', deviceId: id);
  });
  Future<api.ListDocumentExports200Response> reports({
    int page = 1,
    String? type,
    String? resourceId,
    String? format,
  }) => _guard.call(
    () async => _guard.required(
      (await _reports.listDocumentExports(
        audience: 'buyers',
        page: page,
        type: type,
        resourceId: resourceId,
        format: format,
      )).data,
    ),
  );
  Future<api.DocumentExport> requestReport(
    String id,
    api.DocumentExportInputTypeEnum type,
    api.DocumentExportInputFormatEnum format,
    String purpose,
    String key,
  ) => _guard.call(() async {
    return _guard
        .required(
          (await _reports.requestDocumentExport(
            audience: 'buyers',
            idempotencyKey: key,
            documentExportInput: api.DocumentExportInput(
              (b) => b
                ..resourceId = id
                ..type = type
                ..format = format
                ..purpose = purpose,
            ),
          )).data,
        )
        .data;
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

abstract interface class NotificationDeviceRegistry {
  Future<String> register(String token, bool ios);
  Future<void> revoke(String id);
}
