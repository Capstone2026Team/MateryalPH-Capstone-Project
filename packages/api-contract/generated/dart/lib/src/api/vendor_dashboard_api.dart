//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';

import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';

import 'package:materyalph_api_client/src/api_util.dart';
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:materyalph_api_client/src/model/vendor_dashboard_insights_envelope.dart';

class VendorDashboardApi {

  final Dio _dio;

  final Serializers _serializers;

  const VendorDashboardApi(this._dio, this._serializers);

  /// getVendorDashboardInsights
  /// Any active Vendor member. Sections follow the fixed-role grants: orders.confirm, finance.view (peso values), scores.view_store, inventory.view and portal.disputes; a section without its grant is null. Unknown parameters return 422 DASHBOARD_FILTER_UNSUPPORTED.
  ///
  /// Parameters:
  /// * [days]
  /// * [from] - Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Order first confirmation for sales and volume, submitted_at for responses, and event created_at for the demand funnel and filed cases. Omitted days and dates mean all own order history through today. Stock, scores and work queues remain current; forecasting and basket mining retain independent 90-day history.
  /// * [to] - Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Order first confirmation for sales and volume, submitted_at for responses, and event created_at for the demand funnel and filed cases. Omitted days and dates mean all own order history through today. Stock, scores and work queues remain current; forecasting and basket mining retain independent 90-day history.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [VendorDashboardInsightsEnvelope] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<VendorDashboardInsightsEnvelope>> getVendorDashboardInsights({
    int? days,
    Date? from,
    Date? to,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/vendor/dashboard/insights';
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

    VendorDashboardInsightsEnvelope? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(VendorDashboardInsightsEnvelope),
      ) as VendorDashboardInsightsEnvelope;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<VendorDashboardInsightsEnvelope>(
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
