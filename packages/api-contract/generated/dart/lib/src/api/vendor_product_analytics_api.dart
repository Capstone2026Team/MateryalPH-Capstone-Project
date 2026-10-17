//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';

import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';

import 'package:materyalph_api_client/src/api_util.dart';
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:materyalph_api_client/src/model/vendor_product_analytics_detail_envelope.dart';
import 'package:materyalph_api_client/src/model/vendor_product_analytics_envelope.dart';
import 'package:materyalph_api_client/src/model/vendor_product_analytics_summaries_envelope.dart';

class VendorProductAnalyticsApi {

  final Dio _dio;

  final Serializers _serializers;

  const VendorProductAnalyticsApi(this._dio, this._serializers);

  /// getVendorProductAnalytics
  /// Vendor members holding catalog.manage (Owner, Store Manager, Store Staff, Inventory Staff); others receive 403 PRODUCT_ANALYTICS_DENIED. Peso values are null unless the caller holds finance.view (Owner). Unknown parameters return 422 PRODUCT_ANALYTICS_FILTER_UNSUPPORTED. The products table is paginated (20 per page); sort&#x3D;value falls back to orders without finance.view.
  ///
  /// Parameters:
  /// * [days]
  /// * [from] - Inclusive Asia/Manila calendar date (up to 366 days in all). Views use the view day; orders use their first confirmation day; forecasts and co-ordering keep an independent 90-day history.
  /// * [to] - Inclusive Asia/Manila calendar date (up to 366 days in all). Views use the view day; orders use their first confirmation day; forecasts and co-ordering keep an independent 90-day history.
  /// * [sort]
  /// * [page]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [VendorProductAnalyticsEnvelope] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<VendorProductAnalyticsEnvelope>> getVendorProductAnalytics({
    int? days = 30,
    Date? from,
    Date? to,
    String? sort = 'views',
    int? page = 1,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/vendor/product-analytics';
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
      if (days != null) r'days': encodeQueryParameter(_serializers, days, const FullType(int)),
      if (from != null) r'from': encodeQueryParameter(_serializers, from, const FullType(Date)),
      if (to != null) r'to': encodeQueryParameter(_serializers, to, const FullType(Date)),
      if (sort != null) r'sort': encodeQueryParameter(_serializers, sort, const FullType(String)),
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

    VendorProductAnalyticsEnvelope? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(VendorProductAnalyticsEnvelope),
      ) as VendorProductAnalyticsEnvelope;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<VendorProductAnalyticsEnvelope>(
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

  /// getVendorProductAnalyticsDetail
  /// Vendor members holding catalog.manage (Owner, Store Manager, Store Staff, Inventory Staff); others receive 403 PRODUCT_ANALYTICS_DENIED. Peso values are null unless the caller holds finance.view (Owner). Unknown parameters return 422 PRODUCT_ANALYTICS_FILTER_UNSUPPORTED. A listing outside the caller’s store returns 404 LISTING_NOT_FOUND.
  ///
  /// Parameters:
  /// * [listingId]
  /// * [days]
  /// * [from] - Inclusive Asia/Manila calendar date (up to 366 days in all). Views use the view day; orders use their first confirmation day; forecasts and co-ordering keep an independent 90-day history.
  /// * [to] - Inclusive Asia/Manila calendar date (up to 366 days in all). Views use the view day; orders use their first confirmation day; forecasts and co-ordering keep an independent 90-day history.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [VendorProductAnalyticsDetailEnvelope] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<VendorProductAnalyticsDetailEnvelope>> getVendorProductAnalyticsDetail({
    required String listingId,
    int? days = 30,
    Date? from,
    Date? to,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/vendor/product-analytics/listings/{listingId}'.replaceAll('{' r'listingId' '}', encodeQueryParameter(_serializers, listingId, const FullType(String)).toString());
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
      if (days != null) r'days': encodeQueryParameter(_serializers, days, const FullType(int)),
      if (from != null) r'from': encodeQueryParameter(_serializers, from, const FullType(Date)),
      if (to != null) r'to': encodeQueryParameter(_serializers, to, const FullType(Date)),
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    VendorProductAnalyticsDetailEnvelope? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(VendorProductAnalyticsDetailEnvelope),
      ) as VendorProductAnalyticsDetailEnvelope;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<VendorProductAnalyticsDetailEnvelope>(
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

  /// getVendorProductAnalyticsSummaries
  /// Vendor members holding catalog.manage (Owner, Store Manager, Store Staff, Inventory Staff); others receive 403 PRODUCT_ANALYTICS_DENIED. Peso values are null unless the caller holds finance.view (Owner). Unknown parameters return 422 PRODUCT_ANALYTICS_FILTER_UNSUPPORTED. Up to 50 comma-separated listing IDs.
  ///
  /// Parameters:
  /// * [listingIds] - Comma-separated listing IDs (at most 50).
  /// * [days]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [VendorProductAnalyticsSummariesEnvelope] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<VendorProductAnalyticsSummariesEnvelope>> getVendorProductAnalyticsSummaries({
    required String listingIds,
    int? days = 30,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/vendor/product-analytics/summaries';
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
      r'listing_ids': encodeQueryParameter(_serializers, listingIds, const FullType(String)),
      if (days != null) r'days': encodeQueryParameter(_serializers, days, const FullType(int)),
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    VendorProductAnalyticsSummariesEnvelope? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(VendorProductAnalyticsSummariesEnvelope),
      ) as VendorProductAnalyticsSummariesEnvelope;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<VendorProductAnalyticsSummariesEnvelope>(
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
