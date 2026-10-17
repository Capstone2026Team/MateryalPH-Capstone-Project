import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/features/notifications/buyer_device_notifications.dart';
import 'package:materyalph/features/notifications/buyer_push.dart';
import 'package:materyalph/features/notifications/notifications_repository.dart';

class _Messaging implements BuyerPushMessaging {
  final tokenEvents = StreamController<String>.broadcast(sync: true);
  final openEvents = StreamController<RemoteMessage>.broadcast(sync: true);
  final messageEvents = StreamController<RemoteMessage>.broadcast(sync: true);
  AuthorizationStatus status = AuthorizationStatus.authorized;
  AuthorizationStatus? granted;
  String? currentToken = 'synthetic-token-1';
  RemoteMessage? initial;
  Completer<void>? initializing;
  int initializations = 0, prompts = 0, deletions = 0;

  @override
  Future<void> initialize() async {
    initializations++;
    await initializing?.future;
  }

  @override
  Future<AuthorizationStatus> permission({bool request = false}) async {
    if (request) {
      prompts++;
      status = granted ?? status;
    }
    return status;
  }

  @override
  Future<String?> token() async => currentToken;
  @override
  Future<void> deleteToken() async => deletions++;
  @override
  Future<RemoteMessage?> initialMessage() async => initial;
  @override
  Stream<String> get tokens => tokenEvents.stream;
  @override
  Stream<RemoteMessage> get opened => openEvents.stream;
  @override
  Stream<RemoteMessage> get messages => messageEvents.stream;

  Future<void> close() async {
    await tokenEvents.close();
    await openEvents.close();
    await messageEvents.close();
  }
}

class _Registry implements NotificationDeviceRegistry {
  final events = <String>[];
  bool fail = false;
  Completer<String>? response;

  @override
  Future<String> register(String token, bool ios) async {
    events.add('register:$token');
    if (fail) throw StateError('Synthetic offline failure');
    return response?.future ?? 'device:$token';
  }

  @override
  Future<void> revoke(String id) async => events.add('revoke:$id');
}

class _Notifications implements BuyerDeviceNotifications {
  final shown = <String>[];
  final copies = <(String, String)>[];
  String? initial;
  void Function(String)? open;
  Completer<void>? initializing;
  int initializations = 0, closes = 0;
  bool fail = false;

  @override
  Future<String?> initialize(void Function(String) onOpen) async {
    initializations++;
    open = onOpen;
    await initializing?.future;
    if (fail) throw StateError('Synthetic display failure');
    return initial;
  }

  @override
  Future<void> show(
    String id, {
    required String title,
    required String body,
  }) async {
    shown.add(id);
    copies.add((title, body));
  }

  @override
  Future<void> close() async => closes++;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const storage = FlutterSecureStorage();
  const notice = '019a0000-0000-7000-8000-000000000001';
  late _Messaging messaging;
  late _Registry registry;
  late _Notifications notifications;
  late BuyerPush push;
  late List<String> opens;
  late int refreshes;

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    messaging = _Messaging();
    registry = _Registry();
    notifications = _Notifications();
    opens = [];
    refreshes = 0;
    push = BuyerPush(
      registry,
      opens.add,
      messaging: messaging,
      notifications: notifications,
      available: true,
      ios: false,
      refresh: () async => refreshes++,
    );
  });
  tearDown(() async {
    push.dispose();
    await messaging.close();
  });

  test(
    'sign-in and resume register the current token without revoking it',
    () async {
      await push.start();
      await push.start();
      expect(messaging.initializations, 1);
      expect(notifications.initializations, 1);
      expect(messaging.prompts, 0);
      expect(registry.events, [
        'register:synthetic-token-1',
        'register:synthetic-token-1',
      ]);
      expect(
        await storage.read(key: 'notification_device_id'),
        'device:synthetic-token-1',
      );
    },
  );

  test(
    'Android undecided denial requests permission once at sign-in',
    () async {
      messaging.status = AuthorizationStatus.denied;
      messaging.granted = AuthorizationStatus.authorized;
      await push.start();
      await push.start();
      expect(messaging.prompts, 1);
      expect(registry.events.length, 2);
    },
  );

  test(
    'denial leaves the inbox usable and settings explains OS permission',
    () async {
      messaging.status = AuthorizationStatus.denied;
      await push.start();
      await push.start();
      expect(messaging.prompts, 1);
      expect(registry.events, isEmpty);
      await expectLater(
        push.enable(),
        throwsA(
          isA<BuyerPushException>().having(
            (e) => e.message,
            'message',
            contains('phone’s Settings'),
          ),
        ),
      );
      messaging.messageEvents.add(const RemoteMessage());
      expect(refreshes, 1);
      expect(notifications.shown, isEmpty);
      expect(registry.events, isEmpty);
    },
  );

  test('provisional permission also registers an existing token', () async {
    messaging.status = AuthorizationStatus.provisional;
    await push.start();
    expect(registry.events, ['register:synthetic-token-1']);
  });

  test(
    'missing token is retryable and cannot claim registration succeeded',
    () async {
      messaging.currentToken = null;
      await expectLater(push.enable(), throwsA(isA<BuyerPushException>()));
      expect(registry.events, isEmpty);
      expect(await storage.read(key: 'notification_device_id'), isNull);
      messaging.currentToken = 'synthetic-token-1';
      await push.enable();
      expect(registry.events, ['register:synthetic-token-1']);
    },
  );

  test(
    'failed rotation preserves the previous registration until retry succeeds',
    () async {
      await storage.write(
        key: 'notification_device_id',
        value: 'previous-device',
      );
      registry.fail = true;
      await expectLater(push.start(), throwsStateError);
      expect(
        await storage.read(key: 'notification_device_id'),
        'previous-device',
      );
      expect(registry.events, ['register:synthetic-token-1']);
      registry.fail = false;
      await push.start();
      expect(registry.events.last, 'revoke:previous-device');
      expect(
        await storage.read(key: 'notification_device_id'),
        'device:synthetic-token-1',
      );
    },
  );

  test(
    'token rotations are serialized and keep the newest registered device',
    () async {
      await push.start();
      final response = registry.response = Completer<String>();
      messaging.tokenEvents.add('synthetic-token-2');
      messaging.tokenEvents.add('synthetic-token-3');
      await Future<void>.delayed(Duration.zero);
      expect(registry.events.last, 'register:synthetic-token-2');
      registry.response = null;
      response.complete('device:synthetic-token-2');
      await Future<void>.delayed(Duration.zero);
      expect(registry.events, [
        'register:synthetic-token-1',
        'register:synthetic-token-2',
        'revoke:device:synthetic-token-1',
        'register:synthetic-token-3',
        'revoke:device:synthetic-token-2',
      ]);
      expect(
        await storage.read(key: 'notification_device_id'),
        'device:synthetic-token-3',
      );
    },
  );

  test(
    'disposal during initialization cannot register a previous session',
    () async {
      final initializing = messaging.initializing = Completer<void>();
      final starting = push.start();
      push.dispose();
      initializing.complete();
      await starting;
      expect(registry.events, isEmpty);
    },
  );

  test(
    'a registration response after disposal cannot overwrite device storage',
    () async {
      final response = registry.response = Completer<String>();
      final starting = push.start();
      await Future<void>.delayed(Duration.zero);
      push.dispose();
      response.complete('old-session-device');
      await starting;
      expect(await storage.read(key: 'notification_device_id'), isNull);
    },
  );

  test(
    'foreground events invalidate REST; taps only pass opaque IDs to authorized routing',
    () async {
      messaging.initial = const RemoteMessage(
        data: {'notification_id': notice},
      );
      await push.start();
      expect(opens, [notice]);
      messaging.messageEvents.add(
        const RemoteMessage(
          data: {'notification_id': notice, 'path': '/private/unsafe'},
        ),
      );
      expect(refreshes, 1);
      expect(opens, [notice]);
      messaging.openEvents.add(
        const RemoteMessage(data: {'notification_id': '/unsafe'}),
      );
      messaging.openEvents.add(
        RemoteMessage(data: {'notification_id': '-' * 36}),
      );
      messaging.openEvents.add(
        const RemoteMessage(data: {'notification_id': notice}),
      );
      expect(opens, [notice, notice]);
      push.dispose();
      messaging.openEvents.add(
        const RemoteMessage(data: {'notification_id': notice}),
      );
      messaging.messageEvents.add(const RemoteMessage());
      expect(opens, [notice, notice]);
      expect(refreshes, 1);
    },
  );

  test(
    'foreground push displays once and rejects malformed notice IDs',
    () async {
      await push.start();
      const message = RemoteMessage(
        data: {'notification_id': notice, 'path': '/private/unsafe'},
        notification: RemoteNotification(
          title: 'Juan Cruz · Sample Hardware',
          body: 'Your cement is ready for pickup.',
        ),
      );
      messaging.messageEvents.add(message);
      messaging.messageEvents.add(message);
      messaging.messageEvents.add(
        const RemoteMessage(data: {'notification_id': '/private/unsafe'}),
      );
      messaging.messageEvents.add(const RemoteMessage());
      expect(notifications.shown, [notice]);
      expect(notifications.copies, [
        ('Juan Cruz · Sample Hardware', 'Your cement is ready for pickup.'),
      ]);
      expect(refreshes, 4);
      expect(opens, isEmpty);
      notifications.open!(notice);
      notifications.open!('/unsafe');
      expect(opens, [notice]);
      push.dispose();
      notifications.open!(notice);
      messaging.messageEvents.add(message);
      expect(opens, [notice]);
      expect(notifications.shown, [notice]);
      expect(notifications.closes, 1);
    },
  );

  test('local notification taps also open after a cold start', () async {
    notifications.initial = notice;
    await push.start();
    await push.start();
    expect(opens, [notice]);
  });

  test('an offline inbox refresh does not prevent the device alert', () async {
    push.dispose();
    notifications = _Notifications();
    push = BuyerPush(
      registry,
      opens.add,
      messaging: messaging,
      notifications: notifications,
      available: true,
      ios: false,
      refresh: () async => throw StateError('Synthetic offline failure'),
    );
    await push.start();
    messaging.messageEvents.add(
      const RemoteMessage(data: {'notification_id': notice}),
    );
    await Future<void>.delayed(Duration.zero);
    expect(notifications.shown, [notice]);
  });

  test(
    'display startup failure is retryable and cannot register a device',
    () async {
      notifications.fail = true;
      await expectLater(
        push.start(),
        throwsA(
          isA<BuyerPushException>().having(
            (e) => e.message,
            'message',
            contains('display could not start'),
          ),
        ),
      );
      expect(registry.events, isEmpty);
      notifications.fail = false;
      await push.start();
      expect(registry.events, ['register:synthetic-token-1']);
    },
  );

  test(
    'disposal during display setup ignores late initial taps and registration',
    () async {
      notifications.initial = notice;
      final initializing = notifications.initializing = Completer<void>();
      final starting = push.start();
      await Future<void>.delayed(Duration.zero);
      push.dispose();
      initializing.complete();
      await starting;
      notifications.open!(notice);
      expect(opens, isEmpty);
      expect(registry.events, isEmpty);
      expect(notifications.closes, 1);
    },
  );

  test(
    'logout revokes the registered device and stops subsequent registration',
    () async {
      await push.start();
      await push.revoke();
      expect(registry.events.last, 'revoke:device:synthetic-token-1');
      expect(messaging.deletions, 1);
      expect(notifications.closes, 1);
      expect(await storage.read(key: 'notification_device_id'), isNull);
      messaging.tokenEvents.add('synthetic-token-2');
      await push.start();
      expect(registry.events.length, 2);
    },
  );
}
