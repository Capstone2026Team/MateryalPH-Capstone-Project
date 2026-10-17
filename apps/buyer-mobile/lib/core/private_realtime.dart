import 'dart:async';
import 'dart:convert';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;
import 'package:web_socket_channel/web_socket_channel.dart';
import '../features/messaging/chat_socket.dart';

Future<void Function()> watchPrivateRealtime(
  String? channel,
  void Function() refresh, {
  void Function(bool, int)? onTyping,
  void Function(bool)? onLive,
  void Function(String)? onEvent,
  required Future<api.ChatRealtime?> Function() configuration,
  required Future<String> Function(String socketId, String channelName)
  authorize,
  Set<String> events = const {'conversation.changed', 'inbox.changed'},
}) async {
  var stopped = false;
  var live = false;
  void setLive(bool value) {
    if (live == value || stopped) return;
    live = value;
    onLive?.call(value);
  }

  var retrySeconds = 1;
  Timer? retry;
  Timer? handshake;
  Timer? heartbeat;
  Timer? authority;
  WebSocketChannel? socket;
  StreamSubscription<dynamic>? subscription;
  late Future<void> Function() connect;

  void disconnect() {
    handshake?.cancel();
    heartbeat?.cancel();
    authority?.cancel();
    final previous = subscription;
    subscription = null;
    if (previous != null) unawaited(previous.cancel());
    final previousSocket = socket;
    socket = null;
    if (previousSocket != null) unawaited(previousSocket.sink.close());
  }

  void reconnect() {
    if (stopped || retry?.isActive == true) return;
    setLive(false);
    disconnect();
    retry = Timer(Duration(seconds: retrySeconds), () => unawaited(connect()));
    retrySeconds = (retrySeconds * 2).clamp(1, 30);
  }

  connect = () async {
    if (stopped) return;
    WebSocketChannel? connected;
    try {
      final config = await configuration();
      if (stopped) return;
      final target = channel ?? config?.inboxChannel;
      if (config == null ||
          !config.enabled ||
          config.key == null ||
          config.host == null ||
          target == null) {
        // REST remains available; retry configuration without a tight request loop.
        retrySeconds = 30;
        reconnect();
        return;
      }
      final current = connectChatSocket(
        Uri(
          scheme: config.scheme == 'https' ? 'wss' : 'ws',
          host: config.host,
          port: config.port,
          path: '/app/${config.key}',
          queryParameters: {
            'protocol': '7',
            'client': 'materyalph',
            'version': '1.0',
          },
        ),
      );
      connected = current;
      socket = current;
      var lastReceived = DateTime.now();
      void reconnectCurrent() {
        if (!stopped && socket == current) reconnect();
      }

      // Bound a silent connection/auth handshake; reconnects always refetch the account epoch.
      handshake = Timer(const Duration(seconds: 15), reconnectCurrent);
      heartbeat = Timer.periodic(const Duration(seconds: 25), (_) {
        if (stopped || socket != current) return;
        if (DateTime.now().difference(lastReceived).inSeconds > 60) {
          reconnectCurrent();
        } else {
          current.sink.add(
            jsonEncode({'event': 'pusher:ping', 'data': <String, Object>{}}),
          );
        }
      });
      subscription = current.stream.listen(
        (event) async {
          if (stopped || socket != current) return;
          lastReceived = DateTime.now();
          try {
            final message = jsonDecode(event as String) as Map<String, dynamic>;
            if (message['event'] == 'pusher:connection_established') {
              final data =
                  jsonDecode(message['data'] as String) as Map<String, dynamic>;
              final signed = await authorize(
                data['socket_id'] as String,
                'private-$target',
              );
              if (!stopped && socket == current) {
                current.sink.add(
                  jsonEncode({
                    'event': 'pusher:subscribe',
                    'data': {'channel': 'private-$target', 'auth': signed},
                  }),
                );
              }
            } else if (message['event'] == 'pusher:ping') {
              current.sink.add(
                jsonEncode({
                  'event': 'pusher:pong',
                  'data': <String, Object>{},
                }),
              );
            } else if (message['channel'] == 'private-$target' &&
                message['event'] == 'pusher_internal:subscription_succeeded') {
              handshake?.cancel();
              retrySeconds = 1;
              setLive(true);
              refresh(); // Catch changes between the first REST fetch and subscription/reconnection.
              authority?.cancel();
              var checking = false;
              authority = Timer.periodic(const Duration(seconds: 30), (
                _,
              ) async {
                if (checking || stopped || socket != current) return;
                checking = true;
                try {
                  final next = await configuration();
                  if (!stopped &&
                      socket == current &&
                      (next == null ||
                          !next.enabled ||
                          (channel == null && next.inboxChannel != target) ||
                          next.key != config.key ||
                          next.host != config.host ||
                          next.port != config.port ||
                          next.scheme != config.scheme)) {
                    reconnectCurrent();
                  }
                } catch (_) {
                  reconnectCurrent();
                } finally {
                  checking = false;
                }
              });
            } else if (message['channel'] == 'private-$target' &&
                message['event'] == 'conversation.typing') {
              final data = message['data'] is String
                  ? jsonDecode(message['data'] as String)
                  : message['data'];
              if (data is Map && data['typing'] is bool && data['at'] is int) {
                onTyping?.call(data['typing'] as bool, data['at'] as int);
              }
            } else if (message['channel'] == 'private-$target' &&
                events.contains(message['event'])) {
              if (onEvent != null) {
                onEvent(message['event'] as String);
              } else {
                refresh();
              }
            } else if (message['event'] == 'pusher:error') {
              refresh();
              reconnectCurrent();
            }
          } catch (_) {
            reconnectCurrent();
          }
        },
        onError: (Object _) => reconnectCurrent(),
        onDone: reconnectCurrent,
      );
      await current.ready;
    } catch (_) {
      if (!stopped && (connected == null || socket == connected)) reconnect();
    }
  };
  // Return the disposer immediately, including while configuration is loading.
  unawaited(connect());
  return () {
    stopped = true;
    retry?.cancel();
    disconnect();
  };
}
