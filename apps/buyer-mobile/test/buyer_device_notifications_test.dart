import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/features/notifications/buyer_device_notifications.dart';

class _Android extends AndroidFlutterLocalNotificationsPlugin {
  AndroidNotificationChannel? channel;

  @override
  Future<void> createNotificationChannel(
    AndroidNotificationChannel value,
  ) async {
    channel = value;
  }
}

class _Plugin implements FlutterLocalNotificationsPlugin {
  final android = _Android();
  final events = <String>[];
  final payloads = <String?>[];
  InitializationSettings? settings;
  NotificationDetails? details;
  void Function(NotificationResponse)? tap;
  String? title, body, initial;
  Completer<void>? showing;

  @override
  T? resolvePlatformSpecificImplementation<
    T extends FlutterLocalNotificationsPlatform
  >() => android as T;

  @override
  Future<bool?> initialize({
    required InitializationSettings settings,
    DidReceiveNotificationResponseCallback? onDidReceiveNotificationResponse,
    DidReceiveBackgroundNotificationResponseCallback?
    onDidReceiveBackgroundNotificationResponse,
  }) async {
    this.settings = settings;
    tap = onDidReceiveNotificationResponse;
    events.add('initialize');
    return true;
  }

  @override
  Future<NotificationAppLaunchDetails?>
  getNotificationAppLaunchDetails() async => NotificationAppLaunchDetails(
    initial != null,
    notificationResponse: NotificationResponse(
      notificationResponseType: NotificationResponseType.selectedNotification,
      payload: initial,
    ),
  );

  @override
  Future<void> show({
    required int id,
    String? title,
    String? body,
    NotificationDetails? notificationDetails,
    String? payload,
  }) async {
    events.add('show');
    this.title = title;
    this.body = body;
    details = notificationDetails;
    payloads.add(payload);
    await showing?.future;
  }

  @override
  Future<void> cancelAll() async => events.add('clear');

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  const id = '019a0000-0000-7000-8000-000000000001';

  test(
    'cold and warm taps use an opaque ID and stop after the session closes',
    () async {
      final plugin = _Plugin()..initial = id;
      final display = LocalBuyerDeviceNotifications(plugin: plugin);
      final opens = <String>[];
      expect(await display.initialize(opens.add), id);
      plugin.tap!(
        const NotificationResponse(
          notificationResponseType:
              NotificationResponseType.selectedNotification,
          payload: id,
        ),
      );
      plugin.tap!(
        const NotificationResponse(
          notificationResponseType:
              NotificationResponseType.selectedNotification,
          payload: '/unsafe',
        ),
      );
      expect(opens, [id]);
      await display.close();
      plugin.tap!(
        const NotificationResponse(
          notificationResponseType:
              NotificationResponseType.selectedNotification,
          payload: id,
        ),
      );
      expect(opens, [id]);
      expect(plugin.events.last, 'clear');
      final next = LocalBuyerDeviceNotifications(plugin: plugin);
      expect(await next.initialize(opens.add), isNull);
      await next.close();
    },
  );

  test(
    'foreground notifications have audible banner settings and safe copy',
    () async {
      final plugin = _Plugin();
      final display = LocalBuyerDeviceNotifications(plugin: plugin);
      await display.initialize((_) {});
      await display.show(
        id,
        title: 'Juan Cruz · Sample Hardware',
        body: 'Your cement is ready for pickup.',
      );
      expect(plugin.android.channel?.importance, Importance.high);
      expect(plugin.android.channel?.playSound, isTrue);
      expect(plugin.settings?.iOS?.requestAlertPermission, isFalse);
      expect(plugin.settings?.iOS?.requestSoundPermission, isFalse);
      expect(plugin.payloads, [id]);
      expect(plugin.title, 'Juan Cruz · Sample Hardware');
      expect(plugin.body, 'Your cement is ready for pickup.');
      expect(plugin.details?.android?.channelId, plugin.android.channel?.id);
      expect(plugin.details?.android?.priority, Priority.high);
      expect(
        plugin.details?.android?.visibility,
        NotificationVisibility.private,
      );
      expect(plugin.details?.iOS?.presentBanner, isTrue);
      expect(plugin.details?.iOS?.presentSound, isTrue);
      await display.show('/unsafe', title: 'Untrusted route', body: 'Ignored');
      await display.close();
      await display.show(id, title: 'Closed session', body: 'Ignored');
      expect(plugin.payloads, [id]);
    },
  );

  test(
    'old-session display finishes and clears before new-session display',
    () async {
      final plugin = _Plugin();
      final old = LocalBuyerDeviceNotifications(plugin: plugin);
      await old.initialize((_) {});
      final showing = plugin.showing = Completer<void>();
      final pending = old.show(
        id,
        title: 'Order confirmed',
        body: 'The Vendor confirmed your order.',
      );
      await Future<void>.delayed(Duration.zero);
      final clearing = old.close();
      final next = LocalBuyerDeviceNotifications(plugin: plugin);
      final initializing = next.initialize((_) {});
      expect(plugin.events, ['initialize', 'show']);
      showing.complete();
      await pending;
      await clearing;
      await initializing;
      plugin.showing = null;
      await next.show(
        id,
        title: 'Order confirmed',
        body: 'The Vendor confirmed your order.',
      );
      expect(plugin.events, [
        'initialize',
        'show',
        'clear',
        'initialize',
        'show',
      ]);
      await next.close();
    },
  );
}
