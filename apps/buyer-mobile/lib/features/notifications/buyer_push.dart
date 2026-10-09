import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'notifications_repository.dart';

/// Public, environment-specific app configuration only. Service credentials stay in Laravel.
class BuyerPush {
  BuyerPush(this.repository, this.open);
  final NotificationsRepository repository;
  final void Function(String id) open;
  StreamSubscription<String>? _tokens;
  StreamSubscription<RemoteMessage>? _opens;
  StreamSubscription<RemoteMessage>? _messages;
  bool _disposed = false;
  final _storage = const FlutterSecureStorage();
  static const enabled = bool.fromEnvironment('FIREBASE_PUSH_ENABLED');

  Future<void> start() async {
    if (!enabled || kIsWeb || _disposed) return;
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: String.fromEnvironment('FIREBASE_API_KEY'),
          appId: String.fromEnvironment('FIREBASE_APP_ID'),
          messagingSenderId: String.fromEnvironment(
            'FIREBASE_MESSAGING_SENDER_ID',
          ),
          projectId: String.fromEnvironment('FIREBASE_PROJECT_ID'),
          iosBundleId: String.fromEnvironment('FIREBASE_IOS_BUNDLE_ID'),
        ),
      );
    }
    if (_disposed) return;
    _opens ??= FirebaseMessaging.onMessageOpenedApp.listen(_open);
    _messages ??= FirebaseMessaging.onMessage.listen((_) {
      unawaited(repository.inbox.refresh());
    });
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (_disposed) return;
    if (initial != null) _open(initial);
    _tokens ??= FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      unawaited(_register(token).catchError((Object _) {}));
    });
  }

  Future<void> enable() async {
    await start();
    if (_disposed) return;
    if (!enabled) {
      throw StateError('Push is not configured for this environment.');
    }
    final permission = await FirebaseMessaging.instance.requestPermission();
    if (_disposed) return;
    if (permission.authorizationStatus != AuthorizationStatus.authorized &&
        permission.authorizationStatus != AuthorizationStatus.provisional) {
      throw StateError(
        'Notification permission was not granted. You can still use your inbox.',
      );
    }
    final token = await FirebaseMessaging.instance.getToken();
    if (_disposed) return;
    if (token == null) {
      throw StateError('Push registration is temporarily unavailable.');
    }
    await _register(token);
  }

  Future<void> _register(String token) async {
    if (_disposed) return;
    final previous = await _storage.read(key: 'notification_device_id');
    if (_disposed) return;
    if (previous != null) await repository.revoke(previous);
    final id = await repository.register(
      token,
      defaultTargetPlatform == TargetPlatform.iOS,
    );
    await _storage.write(key: 'notification_device_id', value: id);
  }

  void _open(RemoteMessage message) {
    if (_disposed) return;
    final id = message.data['notification_id'];
    if (id is String &&
        RegExp(r'^[0-9a-f-]{36}$', caseSensitive: false).hasMatch(id)) {
      open(id);
    }
  }

  Future<void> revoke() async {
    if (!enabled) return;
    final id = await _storage.read(key: 'notification_device_id');
    if (id != null) await repository.revoke(id);
    if (enabled && Firebase.apps.isNotEmpty) {
      await FirebaseMessaging.instance.deleteToken();
    }
    await _storage.delete(key: 'notification_device_id');
  }

  void dispose() {
    _disposed = true;
    unawaited(_tokens?.cancel());
    unawaited(_opens?.cancel());
    unawaited(_messages?.cancel());
  }
}
