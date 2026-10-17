import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/features/notifications/notifications_repository.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

void main() {
  test(
    'notifications socket receives instant invalidations and reconnects with a fresh private epoch',
    () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      final sockets = <WebSocket>[];
      final initial = Completer<void>(), reconnected = Completer<void>();
      var calls = 0, refreshed = 0;
      final channels = <String>[];
      final dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            final Object data;
            if (options.path.endsWith('/notifications/realtime')) {
              calls++;
              data = {
                'enabled': true,
                'key': 'fixture-public-key',
                'host': '127.0.0.1',
                'port': server.port,
                'scheme': 'http',
                'inbox_channel': 'notifications.epoch$calls',
              };
            } else {
              expect(options.path, '/buyers/notifications/auth');
              channels.add((options.data as Map)['channel_name'] as String);
              data = {'auth': 'fixture-signature'};
            }
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: {
                  'data': data,
                  'meta': <String, Object>{},
                  'errors': <Object>[],
                },
              ),
            );
          },
        ),
      );
      final connection = server.listen((request) async {
        final socket = await WebSocketTransformer.upgrade(request);
        sockets.add(socket);
        socket.add(
          jsonEncode({
            'event': 'pusher:connection_established',
            'data': jsonEncode({'socket_id': '12.34'}),
          }),
        );
        socket.listen((raw) {
          final event = jsonDecode(raw as String) as Map;
          if (event['event'] == 'pusher:subscribe') {
            final channel = (event['data'] as Map)['channel'] as String;
            for (final ignored in const [
              'pusher_internal:subscription_succeeded',
              'notifications.changed',
            ]) {
              socket.add(
                jsonEncode({
                  'event': ignored,
                  'channel': 'private-notifications.foreign',
                  'data': '{}',
                }),
              );
            }
            socket.add(
              jsonEncode({
                'event': 'pusher_internal:subscription_succeeded',
                'channel': channel,
                'data': '{}',
              }),
            );
            socket.add(
              jsonEncode({
                'event': 'notifications.changed',
                'channel': channel,
                'data': '{}',
              }),
            );
            // An unrelated domain event cannot refresh this subscription.
            socket.add(
              jsonEncode({
                'event': 'conversation.changed',
                'channel': channel,
                'data': '{}',
              }),
            );
          }
        });
      });
      final repository = NotificationsRepository(
        api.MateryalphApiClient(dio: dio),
        () async {},
      );
      final stop = await repository.watch(() {
        refreshed++;
        if (refreshed == 2) initial.complete();
        if (refreshed == 4) reconnected.complete();
      });
      addTearDown(() async {
        stop();
        for (final socket in sockets) {
          await socket.close();
        }
        await connection.cancel();
        await server.close(force: true);
        dio.close(force: true);
      });
      await initial.future.timeout(const Duration(seconds: 10));
      expect(refreshed, 2);
      await sockets.first.close();
      await reconnected.future.timeout(const Duration(seconds: 10));
      expect(channels, [
        'private-notifications.epoch1',
        'private-notifications.epoch2',
      ]);
    },
  );
}
