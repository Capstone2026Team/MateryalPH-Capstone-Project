import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;
import '../../core/api_guard.dart';
import '../../core/private_realtime.dart';

abstract interface class MessagingRepository {
  Future<void> updateDestination(
    String id,
    int version,
    String location,
    String restriction, {
    String? alternate,
    String? instructions,
  });
  Future<api.ConversationPage> inbox({int page = 1, bool archived = false});
  Future<api.ConversationPage> projectInquiries(String id, {int page = 1});
  Future<void> archive(String id);
  Future<void> restore(String id);
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

  /// Free site inspection for ready-mixed concrete; returns the store
  /// conversation it was posted in. [key] also identifies the request on retry.
  Future<String> requestSiteInspection({
    required String listingId,
    required String locationId,
    required DateTime preferredDate,
    required String key,
    String? variantId,
    String? notes,
  });
  Future<void> cancelSiteInspection(
    String id,
    String inspectionId,
    int version,
  );
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
    String? paymentMethod,
  });
  Future<void> upload(String id, Uint8List bytes, String name, String key);
  Future<Uint8List> attachment(String id, String attachmentId);
  Future<Uint8List> avatar(String id, int userId);

  /// [onLive] reports whether the realtime subscription is currently
  /// established, so the screen can poll quickly while it is not.
  Future<void Function()> watch(
    String channel,
    void Function() refresh, {
    void Function(bool, int)? onTyping,
    void Function(bool)? onLive,
  });
  Future<void Function()> watchInbox(
    void Function() refresh, {
    void Function(bool)? onLive,
  });
}

/// A chat upload answers only after the fail-closed malware scan, and a photo of up to 10 MB
/// can take a while to send or fetch on mobile data. The generated client's three-second
/// receive timeout reported these as offline even though the upload had been saved.
final class _ChatAttachmentTimeouts extends Interceptor {
  static final _attachments = RegExp(
    r'/conversations/[^/]+/attachments(/[^/]+)?$',
  );

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final match = _attachments.firstMatch(options.path);
    if (match != null) {
      if (options.method == 'POST' && match.group(1) == null) {
        options.sendTimeout = const Duration(seconds: 60);
        options.receiveTimeout = const Duration(seconds: 60);
      } else if (options.method == 'GET') {
        options.receiveTimeout = const Duration(seconds: 45);
      }
    }
    handler.next(options);
  }
}

final class ApiMessagingRepository implements MessagingRepository {
  ApiMessagingRepository({
    required api.MateryalphApiClient client,
    required Future<void> Function() onSessionExpired,
  }) : _client = client,
       _guard = ApiGuard(onSessionExpired) {
    if (!_client.dio.interceptors.any(
      (item) => item is _ChatAttachmentTimeouts,
    )) {
      _client.dio.interceptors.add(_ChatAttachmentTimeouts());
    }
  }
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
  Future<api.ConversationPage> inbox({int page = 1, bool archived = false}) =>
      _guard(
        () async => _guard.required(
          (await _api.listConversations(
            messagingPortal: 'buyers',
            page: page,
            archived: archived ? true : null,
          )).data?.data,
        ),
      );
  @override
  Future<api.ConversationPage> projectInquiries(String id, {int page = 1}) =>
      _guard(
        () async => _guard.required(
          (await _api.listChatProjectInquiries(
            messagingPortal: 'buyers',
            conversationId: id,
            page: page,
          )).data?.data,
        ),
      );

  @override
  Future<void> archive(String id) => _guard(() async {
    await _api.archiveChatConversation(
      messagingPortal: 'buyers',
      conversationId: id,
    );
  });
  @override
  Future<void> restore(String id) => _guard(() async {
    await _api.restoreChatConversation(
      messagingPortal: 'buyers',
      conversationId: id,
    );
  });
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
  Future<String> requestSiteInspection({
    required String listingId,
    required String locationId,
    required DateTime preferredDate,
    required String key,
    String? variantId,
    String? notes,
  }) => _guard(
    () async => _guard
        .required(
          (await _api.requestSiteInspection(
            messagingPortal: 'buyers',
            idempotencyKey: key,
            siteInspectionCreate: api.SiteInspectionCreate(
              (b) => b
                ..listingId = listingId
                ..listingVariantId = variantId
                ..locationId = locationId
                ..preferredDate = api.Date(
                  preferredDate.year,
                  preferredDate.month,
                  preferredDate.day,
                )
                ..notes = notes,
            ),
          )).data?.data,
        )
        .conversationId,
  );

  @override
  Future<void> cancelSiteInspection(
    String id,
    String inspectionId,
    int version,
  ) => _guard(() async {
    await _api.cancelSiteInspection(
      messagingPortal: 'buyers',
      conversationId: id,
      inspectionId: inspectionId,
      siteInspectionVersion: api.SiteInspectionVersion(
        (b) => b..lockVersion = version,
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
    String? paymentMethod,
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
          ..budgetOverrideReason = budgetOverrideReason
          ..paymentMethod = paymentMethod == null
              ? null
              : api.ChatDecisionPaymentMethodEnum.valueOf(paymentMethod),
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
    void Function(bool)? onLive,
  }) => _watch(channel, refresh, onTyping: onTyping, onLive: onLive);

  @override
  Future<void Function()> watchInbox(
    void Function() refresh, {
    void Function(bool)? onLive,
  }) => _watch(null, refresh, onLive: onLive);

  Future<void Function()> _watch(
    String? channel,
    void Function() refresh, {
    void Function(bool, int)? onTyping,
    void Function(bool)? onLive,
  }) => watchPrivateRealtime(
    channel,
    refresh,
    onTyping: onTyping,
    onLive: onLive,
    configuration: () async =>
        (await _api.getChatRealtime(messagingPortal: 'buyers')).data?.data,
    authorize: (socketId, channelName) async =>
        (await _api.authorizeChatChannel(
          messagingPortal: 'buyers',
          chatChannelAuth: api.ChatChannelAuth(
            (b) => b
              ..socketId = socketId
              ..channelName = channelName,
          ),
        )).data!.auth,
  );
}
