import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'buyer_device_notifications.dart';
import 'notifications_repository.dart';

abstract interface class BuyerPushMessaging {
  Future<void> initialize();
  Future<AuthorizationStatus> permission({bool request = false});
  Future<String?> token();
  Future<void> deleteToken();
  Future<RemoteMessage?> initialMessage();
  Stream<String> get tokens;
  Stream<RemoteMessage> get opened;
  Stream<RemoteMessage> get messages;
}

class FirebaseBuyerPushMessaging implements BuyerPushMessaging {
  @override
  Future<void> initialize() async {
    if (Firebase.apps.isEmpty) {
      // The supplied native configuration selects the correct platform app ID.
      // Service-account credentials remain in Laravel.
      await Firebase.initializeApp();
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      // The local presenter displays foreground pushes on both mobile platforms.
      // Keep Firebase's automatic foreground presentation off to avoid duplicates.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
            alert: false,
            badge: false,
            sound: false,
          );
    }
  }

  @override
  Future<AuthorizationStatus> permission({bool request = false}) async =>
      (request
              ? await FirebaseMessaging.instance.requestPermission()
              : await FirebaseMessaging.instance.getNotificationSettings())
          .authorizationStatus;

  @override
  Future<String?> token() async {
    if (defaultTargetPlatform == TargetPlatform.iOS &&
        await FirebaseMessaging.instance.getAPNSToken() == null) {
      throw const BuyerPushException(
        'This phone is still connecting to notifications. Retry in a moment.',
      );
    }
    return FirebaseMessaging.instance.getToken();
  }

  @override
  Future<void> deleteToken() => FirebaseMessaging.instance.deleteToken();
  @override
  Future<RemoteMessage?> initialMessage() =>
      FirebaseMessaging.instance.getInitialMessage();
  @override
  Stream<String> get tokens => FirebaseMessaging.instance.onTokenRefresh;
  @override
  Stream<RemoteMessage> get opened => FirebaseMessaging.onMessageOpenedApp;
  @override
  Stream<RemoteMessage> get messages => FirebaseMessaging.onMessage;
}

class BuyerPushException implements Exception {
  const BuyerPushException(this.message);
  final String message;
}

/// Session-owned Firebase registration. The REST inbox remains authoritative.
class BuyerPush {
  BuyerPush(
    this.registry,
    this.open, {
    required this.refresh,
    BuyerPushMessaging? messaging,
    BuyerDeviceNotifications? notifications,
    FlutterSecureStorage? storage,
    bool? available,
    bool? ios,
  }) : _messaging = messaging ?? FirebaseBuyerPushMessaging(),
       _notifications = notifications ?? LocalBuyerDeviceNotifications(),
       _storage = storage ?? const FlutterSecureStorage(),
       _available = available ?? (enabled && supported),
       _ios = ios ?? defaultTargetPlatform == TargetPlatform.iOS;

  final NotificationDeviceRegistry registry;
  final void Function(String id) open;
  final Future<void> Function() refresh;
  final BuyerPushMessaging _messaging;
  final BuyerDeviceNotifications _notifications;
  final FlutterSecureStorage _storage;
  final bool _available, _ios;
  StreamSubscription<String>? _tokens;
  StreamSubscription<RemoteMessage>? _opens, _messages;
  Future<void>? _starting;
  Future<void>? _closing;
  Future<void> _registration = Future.value();
  final _displayed = <String>{};
  bool _disposed = false, _initialized = false, _authorized = false;

  static const enabled = bool.fromEnvironment(
    'FIREBASE_PUSH_ENABLED',
    defaultValue: true,
  );
  static bool get supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);
  static const _deviceKey = 'notification_device_id';
  static const _permissionKey = 'notification_permission_requested';

  /// Called after sign-in and on resume. Existing permission/token registrations
  /// are restored; the OS asks once when permission has not been decided.
  Future<void> start() {
    if (!_available || _disposed) return Future.value();
    return _starting ??= _start().whenComplete(() => _starting = null);
  }

  Future<void> _initialize() async {
    if (_initialized || _disposed) return;
    try {
      await _messaging.initialize();
    } catch (_) {
      throw const BuyerPushException(
        'Device notifications could not start. Check this app’s Firebase configuration and rebuild it.',
      );
    }
    if (_disposed) return;
    String? initialNotice;
    try {
      initialNotice = await _notifications.initialize(_openId);
    } catch (_) {
      throw const BuyerPushException(
        'Device notification display could not start. Rebuild the app, then retry in Notification settings.',
      );
    }
    if (_disposed) return;
    _initialized = true;
    _opens = _messaging.opened.listen(_open);
    _messages = _messaging.messages.listen(_received);
    _tokens = _messaging.tokens.listen((token) {
      if (_authorized && !_disposed) {
        // Retry failed registration on resume or through settings.
        unawaited(_register(token).catchError((Object _) {}));
      }
    });
    final initial = await _messaging.initialMessage();
    if (!_disposed && initial != null) _open(initial);
    if (initialNotice != null &&
        initialNotice != initial?.data['notification_id']) {
      _openId(initialNotice);
    }
  }

  Future<void> _start() async {
    await _initialize();
    if (_disposed) return;
    var permission = await _messaging.permission();
    if (_disposed) return;
    // Android reports denied before the first prompt as well as after denial.
    // Remember the first request so resume never repeatedly asks for permission.
    final requested = await _storage.read(key: _permissionKey);
    if (_disposed) return;
    if (permission == AuthorizationStatus.notDetermined ||
        (permission == AuthorizationStatus.denied && requested != 'true')) {
      permission = await _messaging.permission(request: true);
      if (_disposed) return;
      await _storage.write(key: _permissionKey, value: 'true');
    }
    await _syncToken(permission);
  }

  Future<void> enable() async {
    if (!_available) {
      throw const BuyerPushException(
        'Device notifications are not configured for this app.',
      );
    }
    await start();
    if (_disposed) return;
    if (!_authorized) {
      final permission = await _messaging.permission(request: true);
      await _syncToken(permission);
      if (!_disposed && !_authorized) {
        throw const BuyerPushException(
          'Allow notifications for MateryalPH in your phone’s Settings, then retry. Your in-app inbox remains available.',
        );
      }
    }
  }

  Future<void> _syncToken(AuthorizationStatus permission) async {
    if (_disposed) return;
    _authorized =
        permission == AuthorizationStatus.authorized ||
        permission == AuthorizationStatus.provisional;
    if (!_authorized) return;
    final token = await _messaging.token();
    if (_disposed) return;
    if (token == null) {
      throw const BuyerPushException(
        'This phone is still connecting to notifications. Retry in a moment.',
      );
    }
    await _register(token);
  }

  Future<void> _register(String token) {
    // Serialize rotation so an older response cannot replace the newest device.
    final operation = _registration.then((_) async {
      if (_disposed || !_authorized) return;
      final previous = await _storage.read(key: _deviceKey);
      if (_disposed || !_authorized) return;
      // Register first: a failed request must not revoke the working token.
      final id = await registry.register(token, _ios);
      if (_disposed) return;
      await _storage.write(key: _deviceKey, value: id);
      if (!_disposed && previous != null && previous != id) {
        await registry.revoke(previous);
      }
    });
    _registration = operation.catchError((Object _) {});
    return operation;
  }

  void _received(RemoteMessage message) {
    if (_disposed) return;
    // Display immediately; inbox refresh/offline recovery cannot delay the alert.
    unawaited(refresh().catchError((Object _) {}));
    final id = buyerNotificationId(message.data['notification_id']);
    if (!_authorized || id == null || !_displayed.add(id)) return;
    if (_displayed.length > 128) _displayed.remove(_displayed.first);
    unawaited(
      _notifications
          .show(
            id,
            title: message.notification?.title ?? 'MateryalPH',
            body:
                message.notification?.body ??
                'Open MateryalPH to view this update.',
          )
          .catchError((Object _) {
            if (!_disposed) _displayed.remove(id);
          }),
    );
  }

  void _open(RemoteMessage message) => _openId(message.data['notification_id']);

  void _openId(Object? value) {
    final id = buyerNotificationId(value);
    if (!_disposed && id != null) open(id);
  }

  Future<void> revoke() async {
    if (!_available) return;
    dispose();
    await _closing;
    await _registration;
    final id = await _storage.read(key: _deviceKey);
    if (id != null) await registry.revoke(id);
    if (_initialized) await _messaging.deleteToken();
    await _storage.delete(key: _deviceKey);
  }

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _authorized = false;
    unawaited(_tokens?.cancel());
    unawaited(_opens?.cancel());
    unawaited(_messages?.cancel());
    _displayed.clear();
    if (_available) {
      _closing = _notifications.close().catchError((Object _) {});
      unawaited(_closing);
    }
  }
}
