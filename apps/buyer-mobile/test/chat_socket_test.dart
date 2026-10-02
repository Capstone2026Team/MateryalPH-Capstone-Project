import 'dart:async';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/features/messaging/chat_socket.dart';

void main() {
  test(
    'native chat socket supplies the allowlisted application origin',
    () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      final origin = Completer<String?>();
      server.listen((request) async {
        origin.complete(request.headers.value('origin'));
        final socket = await WebSocketTransformer.upgrade(request);
        socket.listen(socket.add);
      });
      final client = connectChatSocket(
        Uri.parse('ws://127.0.0.1:${server.port}'),
      );
      try {
        await client.ready;
        expect(await origin.future, 'https://materyalph-buyer');
        client.sink.add('test-event');
        expect(await client.stream.first, 'test-event');
      } finally {
        await client.sink.close();
        await server.close(force: true);
      }
    },
  );
}
