//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';

import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';

import 'package:materyalph_api_client/src/api_util.dart';
import 'package:materyalph_api_client/src/model/admin_dashboard_insights_envelope.dart';
import 'package:materyalph_api_client/src/model/date.dart';

class AdminDashboardApi {

  final Dio _dio;

  final Serializers _serializers;

  const AdminDashboardApi(this._dio, this._serializers);

  /// getAdminDashboardInsights
  /// Any active Admin. marketplace needs analytics.view_aggregates and the geo_analytics flag; vendor_health needs scores.view. Unknown parameters return 422 DASHBOARD_FILTER_UNSUPPORTED; no point or radius filter exists.
  ///
  /// Parameters:
  /// * [days]
  /// * [dataset]
  /// * [area] - Active-version PSGC code; omit for the Philippines.
  /// * [from] - Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Existing geographic date basis (confirmed_on and reporting cutoff). Custom ranges remain bounded to 366 inclusive dates; omitted dates retain the legacy 30-day period.
  /// * [to] - Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Existing geographic date basis (confirmed_on and reporting cutoff). Custom ranges remain bounded to 366 inclusive dates; omitted dates retain the legacy 30-day period.
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [AdminDashboardInsightsEnvelope] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<AdminDashboardInsightsEnvelope>> getAdminDashboardInsights({
    int? days = 30,
    String? dataset,
    String? area,
    Date? from,
    Date? to,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/admin/dashboard/insights';
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
      if (dataset != null) r'dataset': encodeQueryParameter(_serializers, dataset, const FullType(String)),
      if (area != null) r'area': encodeQueryParameter(_serializers, area, const FullType(String)),
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

    AdminDashboardInsightsEnvelope? _responseData;

    try {
      final rawResponse = _response.data;
      _responseData = rawResponse == null ? null : _serializers.deserialize(
        rawResponse,
        specifiedType: const FullType(AdminDashboardInsightsEnvelope),
      ) as AdminDashboardInsightsEnvelope;

    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<AdminDashboardInsightsEnvelope>(
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
