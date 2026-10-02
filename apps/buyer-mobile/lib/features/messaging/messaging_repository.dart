import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../core/api_guard.dart';
import 'chat_socket.dart';

abstract interface class MessagingRepository {
  Future<void> updateDestination(
    String id,
    int version,
    String location,
    String restriction, {
    String? alternate,
    String? instructions,
  });
  Future<api.ConversationPage> inbox({int page = 1});
  Future<api.ConversationDetail> conversation(
    String id, {
    String? before,
    int page = 1,
    int legacyPage = 1,
  });
  Future<String> create(
    String vendorId,
    String? variantId,
    String key, {
    String? locationId,
    String? heavyVehicleRestriction,
    String? alternateDropOffLocationId,
    String? accessInstructions,
  });
  Future<void> send(String id, String body, String key, {String? productId});
  Future<api.ChatProductPage> products(
    String id, {
    String? query,
    String? productId,
    int page = 1,
  });
  Future<void> typing(String id, bool typing);
  Future<void> read(String id, String through);
  Future<String?> decide(
    String id,
    String action,
    api.ChatQuotationVersion version,
    String key, {
    String? reason,
    bool nrpcAcknowledged = false,
    String? termsId,
    String? budgetOverrideReason,
  });
  Future<void> upload(String id, Uint8List bytes, String name, String key);
  Future<Uint8List> attachment(String id, String attachmentId);
  Future<Uint8List> avatar(String id, int userId);
  Future<void Function()> watch(
    String channel,
    void Function() refresh, {
    void Function(bool, int)? onTyping,
  });
  Future<void Function()> watchInbox(void Function() refresh);
}

final class ApiMessagingRepository implements MessagingRepository {
  ApiMessagingRepository({
    required api.MateryalphApiClient client,
    required Future<void> Function() onSessionExpired,
  }) : _client = client,
       _guard = ApiGuard(onSessionExpired);
  final api.MateryalphApiClient _client;
  final ApiGuard _guard;
  api.MessagingApi get _api => _client.getMessagingApi();

  @override
  Future<void> updateDestination(
    String id,
    int version,
    String location,
    String restriction, {
    String? alternate,
    String? instructions,
  }) => _guard(() async {
    await _api.updateChatDestination(
      messagingPortal: 'buyers',
      conversationId: id,
      chatDestinationUpdate: api.ChatDestinationUpdate(
        (b) => b
          ..lockVersion = version
          ..locationId = location
          ..heavyVehicleRestriction =
              api.ChatDestinationUpdateHeavyVehicleRestrictionEnum.valueOf(
                restriction,
              )
          ..alternateDropOffLocationId = alternate
          ..accessInstructions = instructions,
      ),
    );
  });

  @override
  Future<api.ConversationPage> inbox({int page = 1}) => _guard(
    () async => _guard.required(
      (await _api.listConversations(
        messagingPortal: 'buyers',
        page: page,
      )).data?.data,
    ),
  );
  @override
  Future<api.ConversationDetail> conversation(
    String id, {
    String? before,
    int page = 1,
    int legacyPage = 1,
  }) => _guard(
    () async => _guard.required(
      (await _api.getConversation(
        messagingPortal: 'buyers',
        conversationId: id,
        before: before,
        page: page,
        legacyPage: legacyPage,
      )).data?.data,
    ),
  );
  @override
  Future<String> create(
    String vendorId,
    String? variantId,
    String key, {
    String? locationId,
    String? heavyVehicleRestriction,
    String? alternateDropOffLocationId,
    String? accessInstructions,
  }) => _guard(
    () async => _guard
        .required(
          (await _api.createConversation(
            messagingPortal: 'buyers',
            idempotencyKey: key,
            chatCreate: api.ChatCreate(
              (b) => b
                ..vendorId = vendorId
                ..listingVariantId = variantId
                ..locationId = locationId
                ..heavyVehicleRestriction = heavyVehicleRestriction
                ..alternateDropOffLocationId = alternateDropOffLocationId
                ..accessInstructions = accessInstructions,
            ),
          )).data?.data,
        )
        .id,
  );
  @override
  Future<void> send(String id, String body, String key, {String? productId}) =>
      _guard(() async {
        await _api.sendChatMessage(
          messagingPortal: 'buyers',
          conversationId: id,
          chatSend: api.ChatSend(
            (b) => b
              ..body = body.isEmpty ? null : body
              ..productId = productId
              ..clientMessageId = key,
          ),
        );
      });
  @override
  Future<api.ChatProductPage> products(
    String id, {
    String? query,
    String? productId,
    int page = 1,
  }) => _guard(
    () async => _guard.required(
      (await _api.listChatProducts(
        messagingPortal: 'buyers',
        conversationId: id,
        q: query,
        productId: productId,
        page: page,
      )).data?.data,
    ),
  );
  @override
  Future<void> typing(String id, bool typing) async {
    await _api.sendChatTyping(
      messagingPortal: 'buyers',
      conversationId: id,
      chatTyping: api.ChatTyping((b) => b..typing = typing),
    );
  }

  @override
  Future<void> read(String id, String through) => _guard(() async {
    await _api.readChatMessages(
      messagingPortal: 'buyers',
      conversationId: id,
      chatRead: api.ChatRead((b) => b..throughMessageId = through),
    );
  });
  @override
  Future<String?> decide(
    String id,
    String action,
    api.ChatQuotationVersion version,
    String key, {
    String? reason,
    bool nrpcAcknowledged = false,
    String? termsId,
    String? budgetOverrideReason,
  }) => _guard(
    () async => (await _api.decideChatQuotation(
      messagingPortal: 'buyers',
      conversationId: id,
      action: action,
      idempotencyKey: key,
      chatDecision: api.ChatDecision(
        (b) => b
          ..versionId = version.id
          ..contentHash = version.contentHash
          ..reason = reason
          ..nrpcAcknowledged = nrpcAcknowledged
          ..nrpcTermsVersionId = termsId
          ..budgetOverrideReason = budgetOverrideReason,
      ),
    )).data?.data.orderId,
  );
  @override
  Future<void> upload(String id, Uint8List bytes, String name, String key) =>
      _guard(() async {
        await _api.uploadChatAttachment(
          messagingPortal: 'buyers',
          conversationId: id,
          file: MultipartFile.fromBytes(bytes, filename: name),
          clientMessageId: key,
        );
      });
  @override
  Future<Uint8List> attachment(String id, String attachmentId) => _guard(
    () async => _guard.required(
      (await _api.downloadChatAttachment(
        messagingPortal: 'buyers',
        conversationId: id,
        attachmentId: attachmentId,
      )).data,
    ),
  );
  @override
  Future<Uint8List> avatar(String id, int userId) => _guard(
    () async => _guard.required(
      (await _api.getChatAvatar(
        messagingPortal: 'buyers',
        conversationId: id,
        userId: userId,
      )).data,
    ),
  );
  @override
  Future<void Function()> watch(
    String channel,
    void Function() refresh, {
    void Function(bool, int)? onTyping,
  }) => _watch(channel, refresh, onTyping: onTyping);

  @override
  Future<void Function()> watchInbox(void Function() refresh) =>
      _watch(null, refresh);

  Future<void Function()> _watch(
    String? channel,
    void Function() refresh, {
    void Function(bool, int)? onTyping,
  }) async {
    var stopped = false;
    var retrySeconds = 1;
    Timer? retry;
    Timer? handshake;
    WebSocketChannel? socket;
    StreamSubscription<dynamic>? subscription;
    late Future<void> Function() connect;

    void disconnect() {
      handshake?.cancel();
      final previous = subscription;
      subscription = null;
      if (previous != null) unawaited(previous.cancel());
      final previousSocket = socket;
      socket = null;
      if (previousSocket != null) unawaited(previousSocket.sink.close());
    }

    void reconnect() {
      if (stopped || retry?.isActive == true) return;
      disconnect();
      retry = Timer(
        Duration(seconds: retrySeconds),
        () => unawaited(connect()),
      );
      retrySeconds = (retrySeconds * 2).clamp(1, 30);
    }

    connect = () async {
      if (stopped) return;
      try {
        final config = (await _api.getChatRealtime(
          messagingPortal: 'buyers',
        )).data?.data;
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
        socket = current;
        // Bound a silent connection/auth handshake; reconnects always refetch the account epoch.
        handshake = Timer(const Duration(seconds: 15), reconnect);
        subscription = current.stream.listen(
          (event) async {
            if (stopped || socket != current) return;
            try {
              final message =
                  jsonDecode(event as String) as Map<String, dynamic>;
              if (message['event'] == 'pusher:connection_established') {
                final data =
                    jsonDecode(message['data'] as String)
                        as Map<String, dynamic>;
                final signed = await _api.authorizeChatChannel(
                  messagingPortal: 'buyers',
                  chatChannelAuth: api.ChatChannelAuth(
                    (b) => b
                      ..socketId = (data['socket_id'] as String)
                      ..channelName = 'private-$target',
                  ),
                );
                if (!stopped && socket == current) {
                  current.sink.add(
                    jsonEncode({
                      'event': 'pusher:subscribe',
                      'data': {
                        'channel': 'private-$target',
                        'auth': signed.data!.auth,
                      },
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
              } else if (message['event'] ==
                  'pusher_internal:subscription_succeeded') {
                handshake?.cancel();
                retrySeconds = 1;
                refresh(); // Catch changes between the first REST fetch and subscription/reconnection.
              } else if (message['event'] == 'conversation.typing') {
                final data = message['data'] is String
                    ? jsonDecode(message['data'] as String)
                    : message['data'];
                if (data is Map &&
                    data['typing'] is bool &&
                    data['at'] is int) {
                  onTyping?.call(data['typing'] as bool, data['at'] as int);
                }
              } else if (message['event'] == 'conversation.changed' ||
                  message['event'] == 'inbox.changed') {
                refresh();
              } else if (message['event'] == 'pusher:error') {
                refresh();
                reconnect();
              }
            } catch (_) {
              reconnect();
            }
          },
          onError: (Object _) => reconnect(),
          onDone: reconnect,
        );
        await current.ready;
      } catch (_) {
        reconnect();
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
}
