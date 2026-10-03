import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/features/messaging/messaging_repository.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

void main() {
  test(
    'inbox socket subscribes, handles events and reconnects with fresh configuration',
    () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      final sockets = <WebSocket>[];
      final refreshed = Completer<void>();
      final reconnected = Completer<void>();
      final pong = Completer<void>();
      var configCalls = 0;
      var refreshCalls = 0;
      final requestedChannels = <String>[];
      final dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path.endsWith('/messaging/realtime')) {
              configCalls++;
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'data': {
                      'enabled': true,
                      'key': 'fixture-public-key',
                      'host': '127.0.0.1',
                      'port': server.port,
                      'scheme': 'http',
                      'inbox_channel': 'buyer-inbox.epoch$configCalls',
                    },
                    'meta': <String, Object>{},
                    'errors': <Object>[],
                  },
                ),
              );
            } else {
              final data = options.data as Map<String, dynamic>;
              requestedChannels.add(data['channel_name'] as String);
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {'auth': 'fixture-signature'},
                ),
              );
            }
          },
        ),
      );
      final connections = server.listen((request) async {
        final socket = await WebSocketTransformer.upgrade(request);
        sockets.add(socket);
        socket.add(
          jsonEncode({
            'event': 'pusher:connection_established',
            'data': jsonEncode({'socket_id': '12.34'}),
          }),
        );
        socket.listen((raw) {
          final event = jsonDecode(raw as String) as Map<String, dynamic>;
          if (event['event'] == 'pusher:subscribe') {
            socket.add(
              jsonEncode({
                'event': 'pusher_internal:subscription_succeeded',
                'data': '{}',
              }),
            );
            socket.add(jsonEncode({'event': 'inbox.changed', 'data': '{}'}));
            socket.add(jsonEncode({'event': 'pusher:ping', 'data': '{}'}));
          } else if (event['event'] == 'pusher:pong' && !pong.isCompleted) {
            pong.complete();
          }
        });
      });
      final repository = ApiMessagingRepository(
        client: api.MateryalphApiClient(dio: dio),
        onSessionExpired: () async {},
      );
      final stop = await repository.watchInbox(() {
        refreshCalls++;
        if (refreshCalls == 2) refreshed.complete();
        if (refreshCalls == 4) reconnected.complete();
      });
      addTearDown(() async {
        stop();
        for (final socket in sockets) {
          await socket.close();
        }
        await connections.cancel();
        await server.close(force: true);
        dio.close(force: true);
      });
      await refreshed.future.timeout(const Duration(seconds: 10));
      await pong.future.timeout(const Duration(seconds: 10));
      expect(configCalls, 1);
      await sockets.first.close();
      await reconnected.future.timeout(const Duration(seconds: 10));
      expect(configCalls, 2);
      expect(requestedChannels, [
        'private-buyer-inbox.epoch1',
        'private-buyer-inbox.epoch2',
      ]);
    },
  );

  test(
    'disposing while realtime configuration loads prevents a socket connection',
    () async {
      final requested = Completer<void>();
      final release = Completer<void>();
      final dio = Dio();
      var authCalls = 0;
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            if (options.path.endsWith('/messaging/realtime')) {
              requested.complete();
              await release.future;
              handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'data': {
                      'enabled': true,
                      'key': 'fixture-public-key',
                      'host': '127.0.0.1',
                      'port': 1,
                      'scheme': 'http',
                      'inbox_channel': 'buyer-inbox.fixture',
                    },
                  },
                ),
              );
            } else {
              authCalls++;
            }
          },
        ),
      );
      final repository = ApiMessagingRepository(
        client: api.MateryalphApiClient(dio: dio),
        onSessionExpired: () async {},
      );
      final stop = await repository.watchInbox(
        () => fail('Disposed subscription refreshed'),
      );
      await requested.future;
      stop();
      release.complete();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(authCalls, 0);
      dio.close(force: true);
    },
  );
}
