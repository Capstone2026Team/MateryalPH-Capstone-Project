//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';

import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';

import 'package:materyalph_api_client/src/api_util.dart';
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:materyalph_api_client/src/model/geo_boundary_envelope.dart';
import 'package:materyalph_api_client/src/model/geo_dashboard_envelope.dart';
import 'package:materyalph_api_client/src/model/geo_demand_envelope.dart';

class AdminGeographicAnalyticsApi {

  final Dio _dio;

  final Serializers _serializers;

  const AdminGeographicAnalyticsApi(this._dio, this._serializers);

  /// getGeoAnalyticsDashboard
  /// analytics.view_aggregates. KPIs, trends, rates, response time, DAU/WAU/MAU and the child-area table from daily facts, after small-cell suppression. Unknown parameters return 422 ANALYTICS_FILTER_UNSUPPORTED.
  ///
  /// Parameters:
  /// * [dataset]
  /// * [area] - Active-version PSGC code of a region, province, independent city or city/municipality; omit for the Philippines. No radius applies.
  /// * [from]
  /// * [to]
  /// * [granularity]
  /// * [procurementType]
  /// * [categoryId]
  /// * [materialId]
  /// * [fulfillmentMethod]
  /// * [paymentMethod]
  /// * [orderState]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [GeoDashboardEnvelope] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<GeoDashboardEnvelope>> getGeoAnalyticsDashboard({
    String? dataset,
    String? area,
    Date? from,
    Date? to,
    String? granularity,
    String? procurementType,
    String? categoryId,
    String? materialId,
    String? fulfillmentMethod,
    String? paymentMethod,
    String? orderState,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/admin/geo-analytics';
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
      if (dataset != null) r'dataset': encodeQueryParameter(_serializers, dataset, const FullType(String)),
      if (area != null) r'area': encodeQueryParameter(_serializers, area, const FullType(String)),
      if (from != null) r'from': encodeQueryParameter(_serializers, from, const FullType(Date)),
      if (to != null) r'to': encodeQueryParameter(_serializers, to, const FullType(Date)),
      if (granularity != null) r'granularity': encodeQueryParameter(_serializers, granularity, const FullType(String)),
      if (procurementType != null) r'procurement_type': encodeQueryParameter(_serializers, procurementType, const FullType(String)),
      if (categoryId != null) r'category_id': encodeQueryParameter(_serializers, categoryId, const FullType(String)),
      if (materialId != null) r'material_id': encodeQueryParameter(_serializers, materialId, const FullType(String)),
      if (fulfillmentMethod != null) r'fulfillment_method': encodeQueryParameter(_serializers, fulfillmentMethod, const FullType(String)),
      if (paymentMethod != null) r'payment_method': encodeQueryParameter(_serializers, paymentMethod, const FullType(String)),
      if (orderState != null) r'order_state': encodeQueryParameter(_serializers, orderState, const FullType(String)),
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    GeoDashboardEnvelope? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(GeoDashboardEnvelope),
      ) as GeoDashboardEnvelope;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<GeoDashboardEnvelope>(
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

  /// getGeoBoundaries
  /// analytics.view_aggregates. Simplified PSGC boundaries of the selection&#39;s children for the map.
  ///
  /// Parameters:
  /// * [area]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [GeoBoundaryEnvelope] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<GeoBoundaryEnvelope>> getGeoBoundaries({
    String? area,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/admin/geo-analytics/boundaries';
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
      if (area != null) r'area': encodeQueryParameter(_serializers, area, const FullType(String)),
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    GeoBoundaryEnvelope? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(GeoBoundaryEnvelope),
      ) as GeoBoundaryEnvelope;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<GeoBoundaryEnvelope>(
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

  /// getGeoDemandHeatmap
  /// analytics.view_aggregates. Category or material demand by child area; quantity needs one material (422 QUANTITY_NEEDS_MATERIAL).
  ///
  /// Parameters:
  /// * [dataset]
  /// * [area] - Active-version PSGC code of a region, province, independent city or city/municipality; omit for the Philippines. No radius applies.
  /// * [from]
  /// * [to]
  /// * [granularity]
  /// * [procurementType]
  /// * [categoryId]
  /// * [materialId]
  /// * [fulfillmentMethod]
  /// * [paymentMethod]
  /// * [orderState]
  /// * [measure]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [GeoDemandEnvelope] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<GeoDemandEnvelope>> getGeoDemandHeatmap({
    String? dataset,
    String? area,
    Date? from,
    Date? to,
    String? granularity,
    String? procurementType,
    String? categoryId,
    String? materialId,
    String? fulfillmentMethod,
    String? paymentMethod,
    String? orderState,
    String? measure,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/admin/geo-analytics/demand';
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
      if (dataset != null) r'dataset': encodeQueryParameter(_serializers, dataset, const FullType(String)),
      if (area != null) r'area': encodeQueryParameter(_serializers, area, const FullType(String)),
      if (from != null) r'from': encodeQueryParameter(_serializers, from, const FullType(Date)),
      if (to != null) r'to': encodeQueryParameter(_serializers, to, const FullType(Date)),
      if (granularity != null) r'granularity': encodeQueryParameter(_serializers, granularity, const FullType(String)),
      if (procurementType != null) r'procurement_type': encodeQueryParameter(_serializers, procurementType, const FullType(String)),
      if (categoryId != null) r'category_id': encodeQueryParameter(_serializers, categoryId, const FullType(String)),
      if (materialId != null) r'material_id': encodeQueryParameter(_serializers, materialId, const FullType(String)),
      if (fulfillmentMethod != null) r'fulfillment_method': encodeQueryParameter(_serializers, fulfillmentMethod, const FullType(String)),
      if (paymentMethod != null) r'payment_method': encodeQueryParameter(_serializers, paymentMethod, const FullType(String)),
      if (orderState != null) r'order_state': encodeQueryParameter(_serializers, orderState, const FullType(String)),
      if (measure != null) r'measure': encodeQueryParameter(_serializers, measure, const FullType(String)),
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    GeoDemandEnvelope? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(GeoDemandEnvelope),
      ) as GeoDemandEnvelope;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<GeoDemandEnvelope>(
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
