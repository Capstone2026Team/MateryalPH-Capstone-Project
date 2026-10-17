import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Displays the server's event preview. Taps never trust provider-supplied routes.
abstract interface class BuyerDeviceNotifications {
  Future<String?> initialize(void Function(String id) onOpen);
  Future<void> show(String id, {required String title, required String body});
  Future<void> close();
}

String? buyerNotificationId(Object? value) =>
    value is String &&
        RegExp(
          r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
          caseSensitive: false,
        ).hasMatch(value)
    ? value.toLowerCase()
    : null;

class LocalBuyerDeviceNotifications implements BuyerDeviceNotifications {
  LocalBuyerDeviceNotifications({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _closed = false, _ready = false;
  Future<void>? _closing;

  // Native notifications belong to the application. Finish an old session's
  // display/clear before a new session can display, including delayed callbacks.
  static Future<void> _pending = Future.value();
  static bool _launchConsumed = false;
  static const channel = AndroidNotificationChannel(
    'materyalph_updates',
    'Messages and updates',
    description: 'MateryalPH messages and account updates',
    importance: Importance.high,
  );

  static Future<T> _serialize<T>(Future<T> Function() operation) {
    final future = _pending.then((_) => operation());
    _pending = future.then<void>((_) {}).catchError((Object _) {});
    return future;
  }

  @override
  Future<String?> initialize(void Function(String id) onOpen) =>
      _serialize(() async {
        if (_closed) return null;
        final initialized = await _plugin.initialize(
          settings: const InitializationSettings(
            android: AndroidInitializationSettings('ic_notification'),
            iOS: DarwinInitializationSettings(
              // Firebase owns the one permission prompt after authentication.
              requestAlertPermission: false,
              requestBadgePermission: false,
              requestSoundPermission: false,
            ),
          ),
          onDidReceiveNotificationResponse: (response) {
            final id = buyerNotificationId(response.payload);
            if (!_closed && id != null) onOpen(id);
          },
        );
        if (initialized != true) {
          throw StateError('Device notification display could not start.');
        }
        _ready = true;
        await _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.createNotificationChannel(channel);
        if (_closed || _launchConsumed) return null;
        final launch = await _plugin.getNotificationAppLaunchDetails();
        _launchConsumed = true;
        return !_closed && (launch?.didNotificationLaunchApp ?? false)
            ? buyerNotificationId(launch?.notificationResponse?.payload)
            : null;
      });

  @override
  Future<void> show(String id, {required String title, required String body}) =>
      _serialize(() async {
        final notice = buyerNotificationId(id);
        if (_closed || !_ready || notice == null) return;
        await _plugin.show(
          id: int.parse(notice.substring(28), radix: 16) & 0x7fffffff,
          title: title,
          body: body,
          payload: notice,
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: 'ic_notification',
              importance: Importance.high,
              priority: Priority.high,
              visibility: NotificationVisibility.private,
              tag: notice,
              styleInformation: BigTextStyleInformation(body),
            ),
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentBanner: true,
              presentList: true,
              presentSound: true,
              presentBadge: false,
            ),
          ),
        );
      });

  @override
  Future<void> close() {
    _closed = true;
    return _closing ??= _serialize(() async {
      if (_ready) await _plugin.cancelAll();
    });
  }
}
