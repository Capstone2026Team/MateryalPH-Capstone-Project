//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';

import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';

import 'dart:typed_data';
import 'package:materyalph_api_client/src/api_util.dart';
import 'package:materyalph_api_client/src/model/chat_channel_auth.dart';
import 'package:materyalph_api_client/src/model/chat_channel_signature.dart';
import 'package:materyalph_api_client/src/model/chat_create.dart';
import 'package:materyalph_api_client/src/model/chat_decision.dart';
import 'package:materyalph_api_client/src/model/chat_decision_result_response.dart';
import 'package:materyalph_api_client/src/model/chat_destination_update.dart';
import 'package:materyalph_api_client/src/model/chat_draft_save.dart';
import 'package:materyalph_api_client/src/model/chat_empty_response.dart';
import 'package:materyalph_api_client/src/model/chat_handlers_response.dart';
import 'package:materyalph_api_client/src/model/chat_id_response.dart';
import 'package:materyalph_api_client/src/model/chat_product_page_response.dart';
import 'package:materyalph_api_client/src/model/chat_publish.dart';
import 'package:materyalph_api_client/src/model/chat_quotation_page_response.dart';
import 'package:materyalph_api_client/src/model/chat_quotation_preview_request.dart';
import 'package:materyalph_api_client/src/model/chat_read.dart';
import 'package:materyalph_api_client/src/model/chat_realtime_response.dart';
import 'package:materyalph_api_client/src/model/chat_send.dart';
import 'package:materyalph_api_client/src/model/chat_transfer.dart';
import 'package:materyalph_api_client/src/model/chat_typing.dart';
import 'package:materyalph_api_client/src/model/conversation_detail_response.dart';
import 'package:materyalph_api_client/src/model/conversation_page_response.dart';
import 'package:materyalph_api_client/src/model/delivery_plan_envelope.dart';
import 'package:materyalph_api_client/src/model/fulfillment_conversation_page_response.dart';
import 'package:materyalph_api_client/src/model/quotation_location_envelope.dart';
import 'package:materyalph_api_client/src/model/quotation_location_search.dart';
import 'package:materyalph_api_client/src/model/site_inspection_create.dart';
import 'package:materyalph_api_client/src/model/site_inspection_created_response.dart';
import 'package:materyalph_api_client/src/model/site_inspection_decision.dart';
import 'package:materyalph_api_client/src/model/site_inspection_list_response.dart';
import 'package:materyalph_api_client/src/model/site_inspection_version.dart';

class MessagingApi {

  final Dio _dio;

  final Serializers _serializers;

  const MessagingApi(this._dio, this._serializers);

  /// archiveChatConversation
  /// Hides the Buyer and Store sales group, including its item and project inquiries, from this Buyer&#39;s inbox. It is idempotent, personal and reversible; messages, quotations and orders are never changed or deleted. Fulfillment threads stay with their order (409 CONVERSATION_NOT_ARCHIVABLE). New activity in any inquiry returns the group to the inbox.
  ///
  /// Parameters:
  /// * [messagingPortal]
  /// * [conversationId]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [ChatEmptyResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<ChatEmptyResponse>> archiveChatConversation({
    required String messagingPortal,
    required String conversationId,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/{messagingPortal}/conversations/{conversationId}/archive'.replaceAll('{' r'messagingPortal' '}', encodeQueryParameter(_serializers, messagingPortal, const FullType(String)).toString()).replaceAll('{' r'conversationId' '}', encodeQueryParameter(_serializers, conversationId, const FullType(String)).toString());
    final _options = Options(
      method: r'PUT',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'http',
            'scheme': 'bearer',
            'name': 'passportBearer',
          },
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    ChatEmptyResponse? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(ChatEmptyResponse),
      ) as ChatEmptyResponse;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<ChatEmptyResponse>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// authorizeChatChannel
  /// Pusher protocol signature for an authorized per-viewer Reverb channel. Purpose, membership and assignment epoch must match. Broadcasts carry only invalidations; message/file data always requires a fresh authorized REST request. No client events are accepted.
  ///
  /// Parameters:
  /// * [messagingPortal]
  /// * [chatChannelAuth]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [ChatChannelSignature] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<ChatChannelSignature>> authorizeChatChannel({
    required String messagingPortal,
    required ChatChannelAuth chatChannelAuth,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/{messagingPortal}/messaging/auth'.replaceAll('{' r'messagingPortal' '}', encodeQueryParameter(_serializers, messagingPortal, const FullType(String)).toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'accessCookie',
            'keyName': 'mp_access',
            'where': '',
          },{
            'type': 'http',
            'scheme': 'bearer',
            'name': 'passportBearer',
          },{
            'type': 'apiKey',
            'name': 'webCsrf',
            'keyName': 'X-CSRF-Token',
            'where': 'header',
          },
        ],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      const _type = FullType(ChatChannelAuth);
      _bodyData = _serializers.serialize(chatChannelAuth, specifiedType: _type);

    } catch(error, stackTrace) {
      throw DioException(
         requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    ChatChannelSignature? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(ChatChannelSignature),
      ) as ChatChannelSignature;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<ChatChannelSignature>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// cancelSiteInspection
  /// The Buyer cancels a REQUESTED or SCHEDULED inspection. A stale lock_version returns SITE_INSPECTION_VERSION_CONFLICT; a closed request returns SITE_INSPECTION_CLOSED.
  ///
  /// Parameters:
  /// * [messagingPortal]
  /// * [conversationId]
  /// * [inspectionId]
  /// * [siteInspectionVersion]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [SiteInspectionListResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<SiteInspectionListResponse>> cancelSiteInspection({
    required String messagingPortal,
    required String conversationId,
    required String inspectionId,
    required SiteInspectionVersion siteInspectionVersion,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/{messagingPortal}/conversations/{conversationId}/site-inspections/{inspectionId}/cancel'.replaceAll('{' r'messagingPortal' '}', encodeQueryParameter(_serializers, messagingPortal, const FullType(String)).toString()).replaceAll('{' r'conversationId' '}', encodeQueryParameter(_serializers, conversationId, const FullType(String)).toString()).replaceAll('{' r'inspectionId' '}', encodeQueryParameter(_serializers, inspectionId, const FullType(String)).toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'http',
            'scheme': 'bearer',
            'name': 'passportBearer',
          },
        ],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      const _type = FullType(SiteInspectionVersion);
      _bodyData = _serializers.serialize(siteInspectionVersion, specifiedType: _type);

    } catch(error, stackTrace) {
      throw DioException(
         requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    SiteInspectionListResponse? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(SiteInspectionListResponse),
      ) as SiteInspectionListResponse;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<SiteInspectionListResponse>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// createConversation
  /// Buyer-only Item-Based inquiry. Project inquiry entry remains gated until Phase 10; both contexts use the same quotation engine. Fulfillment thread creation has no public endpoint and Phase 12 entry remains disabled.
  ///
  /// Parameters:
  /// * [messagingPortal]
  /// * [idempotencyKey]
  /// * [chatCreate]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [ChatIdResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<ChatIdResponse>> createConversation({
    required String messagingPortal,
    required String idempotencyKey,
    required ChatCreate chatCreate,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/{messagingPortal}/conversations'.replaceAll('{' r'messagingPortal' '}', encodeQueryParameter(_serializers, messagingPortal, const FullType(String)).toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        r'Idempotency-Key': idempotencyKey,
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'http',
            'scheme': 'bearer',
            'name': 'passportBearer',
          },
        ],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      const _type = FullType(ChatCreate);
      _bodyData = _serializers.serialize(chatCreate, specifiedType: _type);

    } catch(error, stackTrace) {
      throw DioException(
         requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    ChatIdResponse? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(ChatIdResponse),
      ) as ChatIdResponse;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<ChatIdResponse>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// decideChatQuotation
  /// Current purpose, participant, account and fixed-role authority are checked server-side. Vendor uses HttpOnly cookies and CSRF; Buyer uses native bearer transport.
  ///
  /// Parameters:
  /// * [messagingPortal]
  /// * [conversationId]
  /// * [action]
  /// * [idempotencyKey]
  /// * [chatDecision]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [ChatDecisionResultResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<ChatDecisionResultResponse>> decideChatQuotation({
    required String messagingPortal,
    required String conversationId,
    required String action,
    required String idempotencyKey,
    required ChatDecision chatDecision,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/{messagingPortal}/conversations/{conversationId}/quotation/{action}'.replaceAll('{' r'messagingPortal' '}', encodeQueryParameter(_serializers, messagingPortal, const FullType(String)).toString()).replaceAll('{' r'conversationId' '}', encodeQueryParameter(_serializers, conversationId, const FullType(String)).toString()).replaceAll('{' r'action' '}', encodeQueryParameter(_serializers, action, const FullType(String)).toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        r'Idempotency-Key': idempotencyKey,
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'accessCookie',
            'keyName': 'mp_access',
            'where': '',
          },{
            'type': 'http',
            'scheme': 'bearer',
            'name': 'passportBearer',
          },{
            'type': 'apiKey',
            'name': 'webCsrf',
            'keyName': 'X-CSRF-Token',
            'where': 'header',
          },
        ],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      const _type = FullType(ChatDecision);
      _bodyData = _serializers.serialize(chatDecision, specifiedType: _type);

    } catch(error, stackTrace) {
      throw DioException(
         requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    ChatDecisionResultResponse? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(ChatDecisionResultResponse),
      ) as ChatDecisionResultResponse;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<ChatDecisionResultResponse>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// decideSiteInspection
  /// Store sales roles (Owner, Store Manager, Store Staff, Customer Service) schedule or reschedule (future scheduled_for), decline (reason) or complete a SCHEDULED inspection with the measured volume in m³. Each change posts a system message and notifies the Buyer. Fulfillment Staff are not sales participants and receive 404. Completing never creates a quotation; the store sends one through the existing quotation flow.
  ///
  /// Parameters:
  /// * [messagingPortal]
  /// * [conversationId]
  /// * [inspectionId]
  /// * [action]
  /// * [siteInspectionDecision]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [SiteInspectionListResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<SiteInspectionListResponse>> decideSiteInspection({
    required String messagingPortal,
    required String conversationId,
    required String inspectionId,
    required String action,
    required SiteInspectionDecision siteInspectionDecision,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/{messagingPortal}/conversations/{conversationId}/site-inspections/{inspectionId}/{action}'.replaceAll('{' r'messagingPortal' '}', encodeQueryParameter(_serializers, messagingPortal, const FullType(String)).toString()).replaceAll('{' r'conversationId' '}', encodeQueryParameter(_serializers, conversationId, const FullType(String)).toString()).replaceAll('{' r'inspectionId' '}', encodeQueryParameter(_serializers, inspectionId, const FullType(String)).toString()).replaceAll('{' r'action' '}', encodeQueryParameter(_serializers, action, const FullType(String)).toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'accessCookie',
            'keyName': 'mp_access',
            'where': '',
          },{
            'type': 'apiKey',
            'name': 'webCsrf',
            'keyName': 'X-CSRF-Token',
            'where': 'header',
          },
        ],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      const _type = FullType(SiteInspectionDecision);
      _bodyData = _serializers.serialize(siteInspectionDecision, specifiedType: _type);

    } catch(error, stackTrace) {
      throw DioException(
         requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    SiteInspectionListResponse? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(SiteInspectionListResponse),
      ) as SiteInspectionListResponse;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<SiteInspectionListResponse>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// downloadChatAttachment
  /// Current purpose, participant, account and fixed-role authority are checked server-side. Vendor uses HttpOnly cookies and CSRF; Buyer uses native bearer transport.
  ///
  /// Parameters:
  /// * [messagingPortal]
  /// * [conversationId]
  /// * [attachmentId]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Uint8List] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Uint8List>> downloadChatAttachment({
    required String messagingPortal,
    required String conversationId,
    required String attachmentId,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/{messagingPortal}/conversations/{conversationId}/attachments/{attachmentId}'.replaceAll('{' r'messagingPortal' '}', encodeQueryParameter(_serializers, messagingPortal, const FullType(String)).toString()).replaceAll('{' r'conversationId' '}', encodeQueryParameter(_serializers, conversationId, const FullType(String)).toString()).replaceAll('{' r'attachmentId' '}', encodeQueryParameter(_serializers, attachmentId, const FullType(String)).toString());
    final _options = Options(
      method: r'GET',
      responseType: ResponseType.bytes,
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'accessCookie',
            'keyName': 'mp_access',
            'where': '',
          },{
            'type': 'http',
            'scheme': 'bearer',
            'name': 'passportBearer',
          },{
            'type': 'apiKey',
            'name': 'webCsrf',
            'keyName': 'X-CSRF-Token',
            'where': 'header',
          },
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    Uint8List? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : rawResponse as Uint8List;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<Uint8List>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// getChatAvatar
  /// Current purpose, participant, account and fixed-role authority are checked server-side. Vendor uses HttpOnly cookies and CSRF; Buyer uses native bearer transport.
  ///
  /// Parameters:
  /// * [messagingPortal]
  /// * [conversationId]
  /// * [userId]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Uint8List] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Uint8List>> getChatAvatar({
    required String messagingPortal,
    required String conversationId,
    required int userId,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/{messagingPortal}/conversations/{conversationId}/avatars/{userId}'.replaceAll('{' r'messagingPortal' '}', encodeQueryParameter(_serializers, messagingPortal, const FullType(String)).toString()).replaceAll('{' r'conversationId' '}', encodeQueryParameter(_serializers, conversationId, const FullType(String)).toString()).replaceAll('{' r'userId' '}', encodeQueryParameter(_serializers, userId, const FullType(int)).toString());
    final _options = Options(
      method: r'GET',
      responseType: ResponseType.bytes,
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'accessCookie',
            'keyName': 'mp_access',
            'where': '',
          },{
            'type': 'http',
            'scheme': 'bearer',
            'name': 'passportBearer',
          },{
            'type': 'apiKey',
            'name': 'webCsrf',
            'keyName': 'X-CSRF-Token',
            'where': 'header',
          },
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    Uint8List? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : rawResponse as Uint8List;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<Uint8List>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// getChatRealtime
  /// Current purpose, participant, account and fixed-role authority are checked server-side. Vendor uses HttpOnly cookies and CSRF; Buyer uses native bearer transport.
  ///
  /// Parameters:
  /// * [messagingPortal]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [ChatRealtimeResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<ChatRealtimeResponse>> getChatRealtime({
    required String messagingPortal,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/{messagingPortal}/messaging/realtime'.replaceAll('{' r'messagingPortal' '}', encodeQueryParameter(_serializers, messagingPortal, const FullType(String)).toString());
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'accessCookie',
            'keyName': 'mp_access',
            'where': '',
          },{
            'type': 'http',
            'scheme': 'bearer',
            'name': 'passportBearer',
          },{
            'type': 'apiKey',
            'name': 'webCsrf',
            'keyName': 'X-CSRF-Token',
            'where': 'header',
          },
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    ChatRealtimeResponse? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(ChatRealtimeResponse),
      ) as ChatRealtimeResponse;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<ChatRealtimeResponse>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// getConversation
  /// Current purpose, participant, account and fixed-role authority are checked server-side. Vendor uses HttpOnly cookies and CSRF; Buyer uses native bearer transport.
  ///
  /// Parameters:
  /// * [messagingPortal]
  /// * [conversationId]
  /// * [page]
  /// * [before]
  /// * [legacyPage] - Page of preserved legacy inquiry references, 25 per page.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [ConversationDetailResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<ConversationDetailResponse>> getConversation({
    required String messagingPortal,
    required String conversationId,
    int? page,
    String? before,
    int? legacyPage,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/{messagingPortal}/conversations/{conversationId}'.replaceAll('{' r'messagingPortal' '}', encodeQueryParameter(_serializers, messagingPortal, const FullType(String)).toString()).replaceAll('{' r'conversationId' '}', encodeQueryParameter(_serializers, conversationId, const FullType(String)).toString());
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'accessCookie',
            'keyName': 'mp_access',
            'where': '',
          },{
            'type': 'http',
            'scheme': 'bearer',
            'name': 'passportBearer',
          },{
            'type': 'apiKey',
            'name': 'webCsrf',
            'keyName': 'X-CSRF-Token',
            'where': 'header',
          },
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _queryParameters = <String, dynamic>{
      if (page != null) r'page': encodeQueryParameter(_serializers, page, const FullType(int)),
      if (before != null) r'before': encodeQueryParameter(_serializers, before, const FullType(String)),
      if (legacyPage != null) r'legacy_page': encodeQueryParameter(_serializers, legacyPage, const FullType(int)),
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    ConversationDetailResponse? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(ConversationDetailResponse),
      ) as ConversationDetailResponse;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<ConversationDetailResponse>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// listChatHandlers
  /// Current purpose, participant, account and fixed-role authority are checked server-side. Vendor uses HttpOnly cookies and CSRF; Buyer uses native bearer transport.
  ///
  /// Parameters:
  /// * [messagingPortal]
  /// * [conversationId]
  /// * [page]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [ChatHandlersResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<ChatHandlersResponse>> listChatHandlers({
    required String messagingPortal,
    required String conversationId,
    int? page,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/{messagingPortal}/conversations/{conversationId}/handlers'.replaceAll('{' r'messagingPortal' '}', encodeQueryParameter(_serializers, messagingPortal, const FullType(String)).toString()).replaceAll('{' r'conversationId' '}', encodeQueryParameter(_serializers, conversationId, const FullType(String)).toString());
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'accessCookie',
            'keyName': 'mp_access',
            'where': '',
          },{
            'type': 'apiKey',
            'name': 'webCsrf',
            'keyName': 'X-CSRF-Token',
            'where': 'header',
          },
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _queryParameters = <String, dynamic>{
      if (page != null) r'page': encodeQueryParameter(_serializers, page, const FullType(int)),
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    ChatHandlersResponse? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(ChatHandlersResponse),
      ) as ChatHandlersResponse;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<ChatHandlersResponse>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// listChatProducts
  /// Search active eligible products of this conversation store. product_id filters one listing variant for a local unsent draft.
  ///
  /// Parameters:
  /// * [messagingPortal]
  /// * [conversationId]
  /// * [q]
  /// * [productId]
  /// * [page]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [ChatProductPageResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<ChatProductPageResponse>> listChatProducts({
    required String messagingPortal,
    required String conversationId,
    String? q,
    String? productId,
    int? page,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/{messagingPortal}/conversations/{conversationId}/products'.replaceAll('{' r'messagingPortal' '}', encodeQueryParameter(_serializers, messagingPortal, const FullType(String)).toString()).replaceAll('{' r'conversationId' '}', encodeQueryParameter(_serializers, conversationId, const FullType(String)).toString());
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'accessCookie',
            'keyName': 'mp_access',
            'where': '',
          },{
            'type': 'http',
            'scheme': 'bearer',
            'name': 'passportBearer',
          },{
            'type': 'apiKey',
            'name': 'webCsrf',
            'keyName': 'X-CSRF-Token',
            'where': 'header',
          },
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _queryParameters = <String, dynamic>{
      if (q != null) r'q': encodeQueryParameter(_serializers, q, const FullType(String)),
      if (productId != null) r'product_id': encodeQueryParameter(_serializers, productId, const FullType(String)),
      if (page != null) r'page': encodeQueryParameter(_serializers, page, const FullType(int)),
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    ChatProductPageResponse? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(ChatProductPageResponse),
      ) as ChatProductPageResponse;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<ChatProductPageResponse>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// listChatProjectInquiries
  /// Lists open Project-Based quotation inquiries for this authorized sales conversation&#39;s Buyer and Store. Includes only currently authorized assignments for the current version of an undeleted, unassigned Active or Quotation Inquiry Work Package in an Active Project. Quotations must be Draft, Published, Viewed, Countered or Stock Revalidation Required; Published, Viewed and Countered deadlines must still be in the future. Filters before pagination, newest activity first. Closed and older inquiries retain directly authorized conversation and quotation history. Never creates an inquiry. Fulfillment threads cannot use this endpoint.
  ///
  /// Parameters:
  /// * [messagingPortal]
  /// * [conversationId]
  /// * [page]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [ConversationPageResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<ConversationPageResponse>> listChatProjectInquiries({
    required String messagingPortal,
    required String conversationId,
    int? page = 1,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/{messagingPortal}/conversations/{conversationId}/project-inquiries'.replaceAll('{' r'messagingPortal' '}', encodeQueryParameter(_serializers, messagingPortal, const FullType(String)).toString()).replaceAll('{' r'conversationId' '}', encodeQueryParameter(_serializers, conversationId, const FullType(String)).toString());
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'accessCookie',
            'keyName': 'mp_access',
            'where': '',
          },{
            'type': 'http',
            'scheme': 'bearer',
            'name': 'passportBearer',
          },
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _queryParameters = <String, dynamic>{
      if (page != null) r'page': encodeQueryParameter(_serializers, page, const FullType(int)),
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    ConversationPageResponse? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(ConversationPageResponse),
      ) as ConversationPageResponse;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<ConversationPageResponse>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// listConversations
  /// One sales inbox entry per Buyer and Store. The authorized Item-Based conversation is the main thread; when unavailable to the viewer, use their oldest authorized project inquiry. Preview, activity ordering and unread count include all currently authorized sales inquiries in that group. Detail messages and read receipts remain conversation-specific. Assigned Fulfillment Staff retain their separate order threads. Current purpose, participant, account and fixed-role authority are checked server-side. Vendor uses HttpOnly cookies and CSRF; Buyer uses native bearer transport.
  ///
  /// Parameters:
  /// * [messagingPortal]
  /// * [page]
  /// * [archived] - Buyer only. Archive and restore apply to the entire Buyer and Store sales group. New activity in any inquiry restores the group. true lists archived groups; omitted or false lists the active inbox. Order fulfillment threads are never listed for a Buyer; they open from Order Details.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [ConversationPageResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<ConversationPageResponse>> listConversations({
    required String messagingPortal,
    int? page,
    bool? archived,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/{messagingPortal}/conversations'.replaceAll('{' r'messagingPortal' '}', encodeQueryParameter(_serializers, messagingPortal, const FullType(String)).toString());
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'accessCookie',
            'keyName': 'mp_access',
            'where': '',
          },{
            'type': 'http',
            'scheme': 'bearer',
            'name': 'passportBearer',
          },{
            'type': 'apiKey',
            'name': 'webCsrf',
            'keyName': 'X-CSRF-Token',
            'where': 'header',
          },
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _queryParameters = <String, dynamic>{
      if (page != null) r'page': encodeQueryParameter(_serializers, page, const FullType(int)),
      if (archived != null) r'archived': encodeQueryParameter(_serializers, archived, const FullType(bool)),
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    ConversationPageResponse? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(ConversationPageResponse),
      ) as ConversationPageResponse;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<ConversationPageResponse>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// listVendorFulfillmentConversations
  /// Owner and Store Manager only. Lists existing fulfillment threads for the authorized sales inquiry&#39;s buyer and vendor, across procurement types. Writable threads first, then read-only history, newest activity and ID first within each group. Never creates a thread.
  ///
  /// Parameters:
  /// * [conversationId]
  /// * [page]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [FulfillmentConversationPageResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<FulfillmentConversationPageResponse>> listVendorFulfillmentConversations({
    required String conversationId,
    int? page = 1,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/vendor/conversations/{conversationId}/fulfillment-conversations'.replaceAll('{' r'conversationId' '}', encodeQueryParameter(_serializers, conversationId, const FullType(String)).toString());
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'accessCookie',
            'keyName': 'mp_access',
            'where': '',
          },
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _queryParameters = <String, dynamic>{
      if (page != null) r'page': encodeQueryParameter(_serializers, page, const FullType(int)),
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    FulfillmentConversationPageResponse? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(FulfillmentConversationPageResponse),
      ) as FulfillmentConversationPageResponse;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<FulfillmentConversationPageResponse>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// openVendorOrderConversation
  /// Opens the authorized order&#39;s quotation conversation or permanent Item-Based store chat, creating the latter if absent. Existing handler access is preserved. Assigned Fulfillment Staff can only open their existing order fulfillment thread. Does not send a message or change commercial terms.
  ///
  /// Parameters:
  /// * [orderId]
  /// * [idempotencyKey]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [ChatIdResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<ChatIdResponse>> openVendorOrderConversation({
    required String orderId,
    required String idempotencyKey,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/vendor/orders/{orderId}/conversation'.replaceAll('{' r'orderId' '}', encodeQueryParameter(_serializers, orderId, const FullType(String)).toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        r'Idempotency-Key': idempotencyKey,
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'accessCookie',
            'keyName': 'mp_access',
            'where': '',
          },{
            'type': 'apiKey',
            'name': 'webCsrf',
            'keyName': 'X-CSRF-Token',
            'where': 'header',
          },
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    ChatIdResponse? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(ChatIdResponse),
      ) as ChatIdResponse;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<ChatIdResponse>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// previewChatQuotationDelivery
  /// Authorized sales staff only. Uses conversation-scoped locations; never exposes device GPS or the Buyer address book. Advisory calculations do not publish or reserve inventory.
  ///
  /// Parameters:
  /// * [conversationId]
  /// * [chatQuotationPreviewRequest]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [DeliveryPlanEnvelope] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<DeliveryPlanEnvelope>> previewChatQuotationDelivery({
    required String conversationId,
    required ChatQuotationPreviewRequest chatQuotationPreviewRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/vendor/conversations/{conversationId}/quotation/delivery-plan'.replaceAll('{' r'conversationId' '}', encodeQueryParameter(_serializers, conversationId, const FullType(String)).toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'accessCookie',
            'keyName': 'mp_access',
            'where': '',
          },{
            'type': 'apiKey',
            'name': 'webCsrf',
            'keyName': 'X-CSRF-Token',
            'where': 'header',
          },
        ],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      const _type = FullType(ChatQuotationPreviewRequest);
      _bodyData = _serializers.serialize(chatQuotationPreviewRequest, specifiedType: _type);

    } catch(error, stackTrace) {
      throw DioException(
         requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    DeliveryPlanEnvelope? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(DeliveryPlanEnvelope),
      ) as DeliveryPlanEnvelope;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<DeliveryPlanEnvelope>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// publishChatQuotation
  /// Current purpose, participant, account and fixed-role authority are checked server-side. Vendor uses HttpOnly cookies and CSRF; Buyer uses native bearer transport.
  ///
  /// Parameters:
  /// * [messagingPortal]
  /// * [conversationId]
  /// * [idempotencyKey]
  /// * [chatPublish]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [ChatQuotationPageResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<ChatQuotationPageResponse>> publishChatQuotation({
    required String messagingPortal,
    required String conversationId,
    required String idempotencyKey,
    required ChatPublish chatPublish,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/{messagingPortal}/conversations/{conversationId}/quotation/publish'.replaceAll('{' r'messagingPortal' '}', encodeQueryParameter(_serializers, messagingPortal, const FullType(String)).toString()).replaceAll('{' r'conversationId' '}', encodeQueryParameter(_serializers, conversationId, const FullType(String)).toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        r'Idempotency-Key': idempotencyKey,
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'accessCookie',
            'keyName': 'mp_access',
            'where': '',
          },{
            'type': 'apiKey',
            'name': 'webCsrf',
            'keyName': 'X-CSRF-Token',
            'where': 'header',
          },
        ],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      const _type = FullType(ChatPublish);
      _bodyData = _serializers.serialize(chatPublish, specifiedType: _type);

    } catch(error, stackTrace) {
      throw DioException(
         requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    ChatQuotationPageResponse? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(ChatQuotationPageResponse),
      ) as ChatQuotationPageResponse;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<ChatQuotationPageResponse>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// readChatMessages
  /// Current purpose, participant, account and fixed-role authority are checked server-side. Vendor uses HttpOnly cookies and CSRF; Buyer uses native bearer transport. Reading received messages also marks that Buyer&#39;s corresponding MESSAGES notifications through the same message cutoff as read; later arrivals remain unread and queued delivery skips already-read message notices.
  ///
  /// Parameters:
  /// * [messagingPortal]
  /// * [conversationId]
  /// * [chatRead]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [ChatEmptyResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<ChatEmptyResponse>> readChatMessages({
    required String messagingPortal,
    required String conversationId,
    required ChatRead chatRead,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/{messagingPortal}/conversations/{conversationId}/read'.replaceAll('{' r'messagingPortal' '}', encodeQueryParameter(_serializers, messagingPortal, const FullType(String)).toString()).replaceAll('{' r'conversationId' '}', encodeQueryParameter(_serializers, conversationId, const FullType(String)).toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'accessCookie',
            'keyName': 'mp_access',
            'where': '',
          },{
            'type': 'http',
            'scheme': 'bearer',
            'name': 'passportBearer',
          },{
            'type': 'apiKey',
            'name': 'webCsrf',
            'keyName': 'X-CSRF-Token',
            'where': 'header',
          },
        ],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      const _type = FullType(ChatRead);
      _bodyData = _serializers.serialize(chatRead, specifiedType: _type);

    } catch(error, stackTrace) {
      throw DioException(
         requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    ChatEmptyResponse? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(ChatEmptyResponse),
      ) as ChatEmptyResponse;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<ChatEmptyResponse>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// requestSiteInspection
  /// Free Site Inspection / Estimate for ready-mixed concrete (owner decision 2026-10-16). Instead of stating a volume, the Buyer asks the store to inspect a saved location. The request is posted in the Buyer&#39;s Item-Based store conversation, whose delivery destination becomes the inspected site, so the store&#39;s later quotation for the measured volume uses it. Creates no order, hold, reservation or charge. One open request per conversation (SITE_INSPECTION_ALREADY_OPEN); a non-ready-mixed or unavailable listing returns SITE_INSPECTION_UNAVAILABLE. The preferred date is today to 60 days ahead in Asia/Manila. Notes are stored encrypted and shown only to the Buyer and the store&#39;s sales roles.
  ///
  /// Parameters:
  /// * [messagingPortal]
  /// * [idempotencyKey] - Also the inspection identifier; a retry returns the same request.
  /// * [siteInspectionCreate]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [SiteInspectionCreatedResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<SiteInspectionCreatedResponse>> requestSiteInspection({
    required String messagingPortal,
    required String idempotencyKey,
    required SiteInspectionCreate siteInspectionCreate,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/{messagingPortal}/site-inspections'.replaceAll('{' r'messagingPortal' '}', encodeQueryParameter(_serializers, messagingPortal, const FullType(String)).toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        r'Idempotency-Key': idempotencyKey,
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'http',
            'scheme': 'bearer',
            'name': 'passportBearer',
          },
        ],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      const _type = FullType(SiteInspectionCreate);
      _bodyData = _serializers.serialize(siteInspectionCreate, specifiedType: _type);

    } catch(error, stackTrace) {
      throw DioException(
         requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    SiteInspectionCreatedResponse? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(SiteInspectionCreatedResponse),
      ) as SiteInspectionCreatedResponse;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<SiteInspectionCreatedResponse>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// restoreChatConversation
  /// Returns the archived Buyer and Store sales group to the Buyer&#39;s inbox. Idempotent. Accepts any authorized sales inquiry in the group.
  ///
  /// Parameters:
  /// * [messagingPortal]
  /// * [conversationId]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [ChatEmptyResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<ChatEmptyResponse>> restoreChatConversation({
    required String messagingPortal,
    required String conversationId,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/{messagingPortal}/conversations/{conversationId}/archive'.replaceAll('{' r'messagingPortal' '}', encodeQueryParameter(_serializers, messagingPortal, const FullType(String)).toString()).replaceAll('{' r'conversationId' '}', encodeQueryParameter(_serializers, conversationId, const FullType(String)).toString());
    final _options = Options(
      method: r'DELETE',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'http',
            'scheme': 'bearer',
            'name': 'passportBearer',
          },
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    ChatEmptyResponse? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(ChatEmptyResponse),
      ) as ChatEmptyResponse;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<ChatEmptyResponse>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// saveChatQuotationDraft
  /// Current purpose, participant, account and fixed-role authority are checked server-side. Vendor uses HttpOnly cookies and CSRF; Buyer uses native bearer transport.
  ///
  /// Parameters:
  /// * [messagingPortal]
  /// * [conversationId]
  /// * [chatDraftSave]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [ChatQuotationPageResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<ChatQuotationPageResponse>> saveChatQuotationDraft({
    required String messagingPortal,
    required String conversationId,
    required ChatDraftSave chatDraftSave,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/{messagingPortal}/conversations/{conversationId}/quotation/draft'.replaceAll('{' r'messagingPortal' '}', encodeQueryParameter(_serializers, messagingPortal, const FullType(String)).toString()).replaceAll('{' r'conversationId' '}', encodeQueryParameter(_serializers, conversationId, const FullType(String)).toString());
    final _options = Options(
      method: r'PUT',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'accessCookie',
            'keyName': 'mp_access',
            'where': '',
          },{
            'type': 'apiKey',
            'name': 'webCsrf',
            'keyName': 'X-CSRF-Token',
            'where': 'header',
          },
        ],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      const _type = FullType(ChatDraftSave);
      _bodyData = _serializers.serialize(chatDraftSave, specifiedType: _type);

    } catch(error, stackTrace) {
      throw DioException(
         requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    ChatQuotationPageResponse? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(ChatQuotationPageResponse),
      ) as ChatQuotationPageResponse;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<ChatQuotationPageResponse>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// searchChatQuotationLocation
  /// Authorized sales staff only. Uses conversation-scoped locations; never exposes device GPS or the Buyer address book. Advisory calculations do not publish or reserve inventory.
  ///
  /// Parameters:
  /// * [conversationId]
  /// * [quotationLocationSearch]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [QuotationLocationEnvelope] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<QuotationLocationEnvelope>> searchChatQuotationLocation({
    required String conversationId,
    required QuotationLocationSearch quotationLocationSearch,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/vendor/conversations/{conversationId}/quotation/location'.replaceAll('{' r'conversationId' '}', encodeQueryParameter(_serializers, conversationId, const FullType(String)).toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'accessCookie',
            'keyName': 'mp_access',
            'where': '',
          },{
            'type': 'apiKey',
            'name': 'webCsrf',
            'keyName': 'X-CSRF-Token',
            'where': 'header',
          },
        ],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      const _type = FullType(QuotationLocationSearch);
      _bodyData = _serializers.serialize(quotationLocationSearch, specifiedType: _type);

    } catch(error, stackTrace) {
      throw DioException(
         requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    QuotationLocationEnvelope? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(QuotationLocationEnvelope),
      ) as QuotationLocationEnvelope;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<QuotationLocationEnvelope>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// sendChatMessage
  /// Current purpose, participant, account and fixed-role authority are checked server-side. Vendor uses HttpOnly cookies and CSRF; Buyer uses native bearer transport. A new non-system Vendor message atomically records one MESSAGES notification for the conversation&#39;s Buyer and queues private realtime/push delivery. Replaying client_message_id does not duplicate the message or notification. Notice copy includes the public sender and store identity and a bounded message preview; private contacts and attachment details are excluded.
  ///
  /// Parameters:
  /// * [messagingPortal]
  /// * [conversationId]
  /// * [chatSend]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [ChatIdResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<ChatIdResponse>> sendChatMessage({
    required String messagingPortal,
    required String conversationId,
    required ChatSend chatSend,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/{messagingPortal}/conversations/{conversationId}/messages'.replaceAll('{' r'messagingPortal' '}', encodeQueryParameter(_serializers, messagingPortal, const FullType(String)).toString()).replaceAll('{' r'conversationId' '}', encodeQueryParameter(_serializers, conversationId, const FullType(String)).toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'accessCookie',
            'keyName': 'mp_access',
            'where': '',
          },{
            'type': 'http',
            'scheme': 'bearer',
            'name': 'passportBearer',
          },{
            'type': 'apiKey',
            'name': 'webCsrf',
            'keyName': 'X-CSRF-Token',
            'where': 'header',
          },
        ],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      const _type = FullType(ChatSend);
      _bodyData = _serializers.serialize(chatSend, specifiedType: _type);

    } catch(error, stackTrace) {
      throw DioException(
         requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    ChatIdResponse? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(ChatIdResponse),
      ) as ChatIdResponse;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<ChatIdResponse>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// sendChatTyping
  /// Ephemeral authorized conversation.typing event on existing viewer channels, with typing boolean and server millisecond timestamp at. Never persisted; receivers ignore older events and clear after three seconds. No account request-rate limit applies.
  ///
  /// Parameters:
  /// * [messagingPortal]
  /// * [conversationId]
  /// * [chatTyping]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [ChatEmptyResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<ChatEmptyResponse>> sendChatTyping({
    required String messagingPortal,
    required String conversationId,
    required ChatTyping chatTyping,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/{messagingPortal}/conversations/{conversationId}/typing'.replaceAll('{' r'messagingPortal' '}', encodeQueryParameter(_serializers, messagingPortal, const FullType(String)).toString()).replaceAll('{' r'conversationId' '}', encodeQueryParameter(_serializers, conversationId, const FullType(String)).toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'accessCookie',
            'keyName': 'mp_access',
            'where': '',
          },{
            'type': 'http',
            'scheme': 'bearer',
            'name': 'passportBearer',
          },{
            'type': 'apiKey',
            'name': 'webCsrf',
            'keyName': 'X-CSRF-Token',
            'where': 'header',
          },
        ],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      const _type = FullType(ChatTyping);
      _bodyData = _serializers.serialize(chatTyping, specifiedType: _type);

    } catch(error, stackTrace) {
      throw DioException(
         requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    ChatEmptyResponse? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(ChatEmptyResponse),
      ) as ChatEmptyResponse;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<ChatEmptyResponse>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// startNextChatQuotation
  /// Start a separate quotation after acceptance in the canonical general store chat. Prior accepted quotations and orders stay immutable. Work Package and fulfillment threads cannot start a later quotation. Requires the latest quotation lock_version and Idempotency-Key.
  ///
  /// Parameters:
  /// * [messagingPortal]
  /// * [conversationId]
  /// * [idempotencyKey]
  /// * [chatPublish]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [ChatQuotationPageResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<ChatQuotationPageResponse>> startNextChatQuotation({
    required String messagingPortal,
    required String conversationId,
    required String idempotencyKey,
    required ChatPublish chatPublish,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/{messagingPortal}/conversations/{conversationId}/quotation/start'.replaceAll('{' r'messagingPortal' '}', encodeQueryParameter(_serializers, messagingPortal, const FullType(String)).toString()).replaceAll('{' r'conversationId' '}', encodeQueryParameter(_serializers, conversationId, const FullType(String)).toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        r'Idempotency-Key': idempotencyKey,
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'accessCookie',
            'keyName': 'mp_access',
            'where': '',
          },{
            'type': 'apiKey',
            'name': 'webCsrf',
            'keyName': 'X-CSRF-Token',
            'where': 'header',
          },
        ],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      const _type = FullType(ChatPublish);
      _bodyData = _serializers.serialize(chatPublish, specifiedType: _type);

    } catch(error, stackTrace) {
      throw DioException(
         requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    ChatQuotationPageResponse? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(ChatQuotationPageResponse),
      ) as ChatQuotationPageResponse;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<ChatQuotationPageResponse>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// transferChatHandler
  /// Current purpose, participant, account and fixed-role authority are checked server-side. Vendor uses HttpOnly cookies and CSRF; Buyer uses native bearer transport.
  ///
  /// Parameters:
  /// * [messagingPortal]
  /// * [conversationId]
  /// * [chatTransfer]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [ChatEmptyResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<ChatEmptyResponse>> transferChatHandler({
    required String messagingPortal,
    required String conversationId,
    required ChatTransfer chatTransfer,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/{messagingPortal}/conversations/{conversationId}/transfer'.replaceAll('{' r'messagingPortal' '}', encodeQueryParameter(_serializers, messagingPortal, const FullType(String)).toString()).replaceAll('{' r'conversationId' '}', encodeQueryParameter(_serializers, conversationId, const FullType(String)).toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'accessCookie',
            'keyName': 'mp_access',
            'where': '',
          },{
            'type': 'apiKey',
            'name': 'webCsrf',
            'keyName': 'X-CSRF-Token',
            'where': 'header',
          },
        ],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      const _type = FullType(ChatTransfer);
      _bodyData = _serializers.serialize(chatTransfer, specifiedType: _type);

    } catch(error, stackTrace) {
      throw DioException(
         requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    ChatEmptyResponse? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(ChatEmptyResponse),
      ) as ChatEmptyResponse;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<ChatEmptyResponse>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// updateChatDestination
  /// Buyer-owned saved destination and heavy access for a general store chat. Requires the current conversation lock_version; rejects changes while a quotation is published/viewed. Accepted snapshots stay immutable. An active draft must be reviewed against its incremented quotation lock_version.
  ///
  /// Parameters:
  /// * [messagingPortal]
  /// * [conversationId]
  /// * [chatDestinationUpdate]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [ChatEmptyResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<ChatEmptyResponse>> updateChatDestination({
    required String messagingPortal,
    required String conversationId,
    required ChatDestinationUpdate chatDestinationUpdate,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/{messagingPortal}/conversations/{conversationId}/destination'.replaceAll('{' r'messagingPortal' '}', encodeQueryParameter(_serializers, messagingPortal, const FullType(String)).toString()).replaceAll('{' r'conversationId' '}', encodeQueryParameter(_serializers, conversationId, const FullType(String)).toString());
    final _options = Options(
      method: r'PUT',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'accessCookie',
            'keyName': 'mp_access',
            'where': '',
          },{
            'type': 'http',
            'scheme': 'bearer',
            'name': 'passportBearer',
          },{
            'type': 'apiKey',
            'name': 'webCsrf',
            'keyName': 'X-CSRF-Token',
            'where': 'header',
          },
        ],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      const _type = FullType(ChatDestinationUpdate);
      _bodyData = _serializers.serialize(chatDestinationUpdate, specifiedType: _type);

    } catch(error, stackTrace) {
      throw DioException(
         requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    ChatEmptyResponse? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(ChatEmptyResponse),
      ) as ChatEmptyResponse;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<ChatEmptyResponse>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

  /// uploadChatAttachment
  /// Current purpose, participant, account and fixed-role authority are checked server-side. Vendor uses HttpOnly cookies and CSRF; Buyer uses native bearer transport. A newly committed Vendor attachment message records one MESSAGES notification for the authorized Buyer without exposing attachment contents or names.
  ///
  /// Parameters:
  /// * [messagingPortal]
  /// * [conversationId]
  /// * [file]
  /// * [clientMessageId]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [ChatEmptyResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<ChatEmptyResponse>> uploadChatAttachment({
    required String messagingPortal,
    required String conversationId,
    required MultipartFile file,
    required String clientMessageId,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/{messagingPortal}/conversations/{conversationId}/attachments'.replaceAll('{' r'messagingPortal' '}', encodeQueryParameter(_serializers, messagingPortal, const FullType(String)).toString()).replaceAll('{' r'conversationId' '}', encodeQueryParameter(_serializers, conversationId, const FullType(String)).toString());
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{
        ...?headers,
      },
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'accessCookie',
            'keyName': 'mp_access',
            'where': '',
          },{
            'type': 'http',
            'scheme': 'bearer',
            'name': 'passportBearer',
          },{
            'type': 'apiKey',
            'name': 'webCsrf',
            'keyName': 'X-CSRF-Token',
            'where': 'header',
          },
        ],
        ...?extra,
      },
      contentType: 'multipart/form-data',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      _bodyData = FormData.fromMap(<String, dynamic>{
        r'file': file,
        r'client_message_id': encodeFormParameter(_serializers, clientMessageId, const FullType(String)),
      });

    } catch(error, stackTrace) {
      throw DioException(
         requestOptions: _options.compose(
          _dio.options,
          _path,
        ),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    ChatEmptyResponse? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(ChatEmptyResponse),
      ) as ChatEmptyResponse;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<ChatEmptyResponse>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }

}
