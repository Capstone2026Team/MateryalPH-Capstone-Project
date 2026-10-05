//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';

import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';

import 'dart:typed_data';
import 'package:materyalph_api_client/src/api_util.dart';
import 'package:materyalph_api_client/src/model/admin_materials_analytics_detail_envelope.dart';
import 'package:materyalph_api_client/src/model/admin_materials_analytics_list_envelope.dart';
import 'package:materyalph_api_client/src/model/analytics_correction_envelope.dart';
import 'package:materyalph_api_client/src/model/analytics_correction_request.dart';
import 'package:materyalph_api_client/src/model/analytics_run_list_envelope.dart';
import 'package:materyalph_api_client/src/model/analytics_source_list_envelope.dart';
import 'package:materyalph_api_client/src/model/date.dart';

class AdminMaterialsAnalyticsApi {

  final Dio _dio;

  final Serializers _serializers;

  const AdminMaterialsAnalyticsApi(this._dio, this._serializers);

  /// correctAdminMaterialPriceRun
  /// materials_analytics.inspect_sources. Append a reviewed replacement revision excluding proven-invalid observations; originals are retained.
  ///
  /// Parameters:
  /// * [runId]
  /// * [idempotencyKey]
  /// * [analyticsCorrectionRequest]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [AnalyticsCorrectionEnvelope] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<AnalyticsCorrectionEnvelope>> correctAdminMaterialPriceRun({
    required String runId,
    required String idempotencyKey,
    required AnalyticsCorrectionRequest analyticsCorrectionRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/admin/materials-analytics/runs/{runId}/corrections'.replaceAll('{' r'runId' '}', encodeQueryParameter(_serializers, runId, const FullType(String)).toString());
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
      const _type = FullType(AnalyticsCorrectionRequest);
      _bodyData = _serializers.serialize(analyticsCorrectionRequest, specifiedType: _type);

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

    AnalyticsCorrectionEnvelope? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(AnalyticsCorrectionEnvelope),
      ) as AnalyticsCorrectionEnvelope;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<AnalyticsCorrectionEnvelope>(
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

  /// exportAdminMaterialsAnalytics
  /// analytics.view_aggregates and analytics.export. Aggregate CSV.
  ///
  /// Parameters:
  /// * [presetDays]
  /// * [startDate]
  /// * [endDate]
  /// * [psgcCode]
  /// * [psgcVersionId]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [Uint8List] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<Uint8List>> exportAdminMaterialsAnalytics({
    int? presetDays,
    Date? startDate,
    Date? endDate,
    String? psgcCode,
    String? psgcVersionId,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/admin/materials-analytics/export';
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
      if (presetDays != null) r'preset_days': encodeQueryParameter(_serializers, presetDays, const FullType(int)),
      if (startDate != null) r'start_date': encodeQueryParameter(_serializers, startDate, const FullType(Date)),
      if (endDate != null) r'end_date': encodeQueryParameter(_serializers, endDate, const FullType(Date)),
      if (psgcCode != null) r'psgc_code': encodeQueryParameter(_serializers, psgcCode, const FullType(String)),
      if (psgcVersionId != null) r'psgc_version_id': encodeQueryParameter(_serializers, psgcVersionId, const FullType(String)),
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
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

  /// getAdminMaterialPriceDetails
  /// analytics.view_aggregates. Graph/table with counts and exact means.
  ///
  /// Parameters:
  /// * [groupId]
  /// * [presetDays]
  /// * [startDate]
  /// * [endDate]
  /// * [psgcCode]
  /// * [psgcVersionId]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [AdminMaterialsAnalyticsDetailEnvelope] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<AdminMaterialsAnalyticsDetailEnvelope>> getAdminMaterialPriceDetails({
    required String groupId,
    int? presetDays,
    Date? startDate,
    Date? endDate,
    String? psgcCode,
    String? psgcVersionId,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/admin/materials-analytics/{groupId}'.replaceAll('{' r'groupId' '}', encodeQueryParameter(_serializers, groupId, const FullType(String)).toString());
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
      if (presetDays != null) r'preset_days': encodeQueryParameter(_serializers, presetDays, const FullType(int)),
      if (startDate != null) r'start_date': encodeQueryParameter(_serializers, startDate, const FullType(Date)),
      if (endDate != null) r'end_date': encodeQueryParameter(_serializers, endDate, const FullType(Date)),
      if (psgcCode != null) r'psgc_code': encodeQueryParameter(_serializers, psgcCode, const FullType(String)),
      if (psgcVersionId != null) r'psgc_version_id': encodeQueryParameter(_serializers, psgcVersionId, const FullType(String)),
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    AdminMaterialsAnalyticsDetailEnvelope? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(AdminMaterialsAnalyticsDetailEnvelope),
      ) as AdminMaterialsAnalyticsDetailEnvelope;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<AdminMaterialsAnalyticsDetailEnvelope>(
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

  /// listAdminMaterialPriceRuns
  /// analytics.view_aggregates. Snapshot health: state, revision, actual capture time and delay.
  ///
  /// Parameters:
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [AnalyticsRunListEnvelope] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<AnalyticsRunListEnvelope>> listAdminMaterialPriceRuns({
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/admin/materials-analytics/runs';
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

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    AnalyticsRunListEnvelope? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(AnalyticsRunListEnvelope),
      ) as AnalyticsRunListEnvelope;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<AnalyticsRunListEnvelope>(
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

  /// listAdminMaterialPriceSources
  /// materials_analytics.inspect_sources. Public listing identity, price/version, capture time and recorded geography for one published date; audited with your reason.
  ///
  /// Parameters:
  /// * [groupId]
  /// * [snapshotDate]
  /// * [reason]
  /// * [psgcCode]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [AnalyticsSourceListEnvelope] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<AnalyticsSourceListEnvelope>> listAdminMaterialPriceSources({
    required String groupId,
    required Date snapshotDate,
    required String reason,
    String? psgcCode,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/admin/materials-analytics/{groupId}/sources'.replaceAll('{' r'groupId' '}', encodeQueryParameter(_serializers, groupId, const FullType(String)).toString());
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
      r'snapshot_date': encodeQueryParameter(_serializers, snapshotDate, const FullType(Date)),
      r'reason': encodeQueryParameter(_serializers, reason, const FullType(String)),
      if (psgcCode != null) r'psgc_code': encodeQueryParameter(_serializers, psgcCode, const FullType(String)),
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    AnalyticsSourceListEnvelope? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(AnalyticsSourceListEnvelope),
      ) as AnalyticsSourceListEnvelope;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<AnalyticsSourceListEnvelope>(
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

  /// listAdminMaterialsAnalytics
  /// analytics.view_aggregates. PSGC-scoped (or Philippines-wide) aggregates; payment/order filters do not apply to listed-price history.
  ///
  /// Parameters:
  /// * [presetDays]
  /// * [startDate]
  /// * [endDate]
  /// * [categoryId]
  /// * [q]
  /// * [cursor]
  /// * [perPage]
  /// * [psgcCode]
  /// * [psgcVersionId]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [AdminMaterialsAnalyticsListEnvelope] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<AdminMaterialsAnalyticsListEnvelope>> listAdminMaterialsAnalytics({
    int? presetDays,
    Date? startDate,
    Date? endDate,
    String? categoryId,
    String? q,
    String? cursor,
    int? perPage,
    String? psgcCode,
    String? psgcVersionId,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/admin/materials-analytics';
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
      if (presetDays != null) r'preset_days': encodeQueryParameter(_serializers, presetDays, const FullType(int)),
      if (startDate != null) r'start_date': encodeQueryParameter(_serializers, startDate, const FullType(Date)),
      if (endDate != null) r'end_date': encodeQueryParameter(_serializers, endDate, const FullType(Date)),
      if (categoryId != null) r'category_id': encodeQueryParameter(_serializers, categoryId, const FullType(String)),
      if (q != null) r'q': encodeQueryParameter(_serializers, q, const FullType(String)),
      if (cursor != null) r'cursor': encodeQueryParameter(_serializers, cursor, const FullType(String)),
      if (perPage != null) r'per_page': encodeQueryParameter(_serializers, perPage, const FullType(int)),
      if (psgcCode != null) r'psgc_code': encodeQueryParameter(_serializers, psgcCode, const FullType(String)),
      if (psgcVersionId != null) r'psgc_version_id': encodeQueryParameter(_serializers, psgcVersionId, const FullType(String)),
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    AdminMaterialsAnalyticsListEnvelope? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(AdminMaterialsAnalyticsListEnvelope),
      ) as AdminMaterialsAnalyticsListEnvelope;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<AdminMaterialsAnalyticsListEnvelope>(
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
