# materyalph_api_client.api.AdminMaterialsAnalyticsApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**correctAdminMaterialPriceRun**](AdminMaterialsAnalyticsApi.md#correctadminmaterialpricerun) | **POST** /admin/materials-analytics/runs/{runId}/corrections |
[**exportAdminMaterialsAnalytics**](AdminMaterialsAnalyticsApi.md#exportadminmaterialsanalytics) | **GET** /admin/materials-analytics/export |
[**getAdminMaterialPriceDetails**](AdminMaterialsAnalyticsApi.md#getadminmaterialpricedetails) | **GET** /admin/materials-analytics/{groupId} |
[**listAdminMaterialPriceRuns**](AdminMaterialsAnalyticsApi.md#listadminmaterialpriceruns) | **GET** /admin/materials-analytics/runs |
[**listAdminMaterialPriceSources**](AdminMaterialsAnalyticsApi.md#listadminmaterialpricesources) | **GET** /admin/materials-analytics/{groupId}/sources |
[**listAdminMaterialsAnalytics**](AdminMaterialsAnalyticsApi.md#listadminmaterialsanalytics) | **GET** /admin/materials-analytics |


# **correctAdminMaterialPriceRun**
> AnalyticsCorrectionEnvelope correctAdminMaterialPriceRun(runId, idempotencyKey, analyticsCorrectionRequest)



materials_analytics.inspect_sources. Append a reviewed replacement revision excluding proven-invalid observations; originals are retained.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAdminMaterialsAnalyticsApi();
final String runId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final AnalyticsCorrectionRequest analyticsCorrectionRequest = ; // AnalyticsCorrectionRequest |

try {
    final response = api.correctAdminMaterialPriceRun(runId, idempotencyKey, analyticsCorrectionRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminMaterialsAnalyticsApi->correctAdminMaterialPriceRun: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **runId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **analyticsCorrectionRequest** | [**AnalyticsCorrectionRequest**](AnalyticsCorrectionRequest.md)|  |

### Return type

[**AnalyticsCorrectionEnvelope**](AnalyticsCorrectionEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **exportAdminMaterialsAnalytics**
> Uint8List exportAdminMaterialsAnalytics(presetDays, startDate, endDate, psgcCode, psgcVersionId)



analytics.view_aggregates and analytics.export. Aggregate CSV.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAdminMaterialsAnalyticsApi();
final int presetDays = 56; // int |
final Date startDate = 2013-10-20; // Date |
final Date endDate = 2013-10-20; // Date |
final String psgcCode = psgcCode_example; // String |
final String psgcVersionId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.exportAdminMaterialsAnalytics(presetDays, startDate, endDate, psgcCode, psgcVersionId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminMaterialsAnalyticsApi->exportAdminMaterialsAnalytics: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **presetDays** | **int**|  | [optional]
 **startDate** | **Date**|  | [optional]
 **endDate** | **Date**|  | [optional]
 **psgcCode** | **String**|  | [optional]
 **psgcVersionId** | **String**|  | [optional]

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/csv, application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAdminMaterialPriceDetails**
> AdminMaterialsAnalyticsDetailEnvelope getAdminMaterialPriceDetails(groupId, presetDays, startDate, endDate, psgcCode, psgcVersionId)



analytics.view_aggregates. Graph/table with counts and exact means.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAdminMaterialsAnalyticsApi();
final String groupId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final int presetDays = 56; // int |
final Date startDate = 2013-10-20; // Date |
final Date endDate = 2013-10-20; // Date |
final String psgcCode = psgcCode_example; // String |
final String psgcVersionId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getAdminMaterialPriceDetails(groupId, presetDays, startDate, endDate, psgcCode, psgcVersionId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminMaterialsAnalyticsApi->getAdminMaterialPriceDetails: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **groupId** | **String**|  |
 **presetDays** | **int**|  | [optional]
 **startDate** | **Date**|  | [optional]
 **endDate** | **Date**|  | [optional]
 **psgcCode** | **String**|  | [optional]
 **psgcVersionId** | **String**|  | [optional]

### Return type

[**AdminMaterialsAnalyticsDetailEnvelope**](AdminMaterialsAnalyticsDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAdminMaterialPriceRuns**
> AnalyticsRunListEnvelope listAdminMaterialPriceRuns()



analytics.view_aggregates. Snapshot health: state, revision, actual capture time and delay.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAdminMaterialsAnalyticsApi();

try {
    final response = api.listAdminMaterialPriceRuns();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminMaterialsAnalyticsApi->listAdminMaterialPriceRuns: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AnalyticsRunListEnvelope**](AnalyticsRunListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAdminMaterialPriceSources**
> AnalyticsSourceListEnvelope listAdminMaterialPriceSources(groupId, snapshotDate, reason, psgcCode)



materials_analytics.inspect_sources. Public listing identity, price/version, capture time and recorded geography for one published date; audited with your reason.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAdminMaterialsAnalyticsApi();
final String groupId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final Date snapshotDate = 2013-10-20; // Date |
final String reason = reason_example; // String |
final String psgcCode = psgcCode_example; // String |

try {
    final response = api.listAdminMaterialPriceSources(groupId, snapshotDate, reason, psgcCode);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminMaterialsAnalyticsApi->listAdminMaterialPriceSources: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **groupId** | **String**|  |
 **snapshotDate** | **Date**|  |
 **reason** | **String**|  |
 **psgcCode** | **String**|  | [optional]

### Return type

[**AnalyticsSourceListEnvelope**](AnalyticsSourceListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAdminMaterialsAnalytics**
> AdminMaterialsAnalyticsListEnvelope listAdminMaterialsAnalytics(presetDays, startDate, endDate, categoryId, q, cursor, perPage, psgcCode, psgcVersionId)



analytics.view_aggregates. PSGC-scoped (or Philippines-wide) aggregates; payment/order filters do not apply to listed-price history.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAdminMaterialsAnalyticsApi();
final int presetDays = 56; // int |
final Date startDate = 2013-10-20; // Date |
final Date endDate = 2013-10-20; // Date |
final String categoryId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String q = q_example; // String |
final String cursor = cursor_example; // String |
final int perPage = 56; // int |
final String psgcCode = psgcCode_example; // String |
final String psgcVersionId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.listAdminMaterialsAnalytics(presetDays, startDate, endDate, categoryId, q, cursor, perPage, psgcCode, psgcVersionId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminMaterialsAnalyticsApi->listAdminMaterialsAnalytics: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **presetDays** | **int**|  | [optional]
 **startDate** | **Date**|  | [optional]
 **endDate** | **Date**|  | [optional]
 **categoryId** | **String**|  | [optional]
 **q** | **String**|  | [optional]
 **cursor** | **String**|  | [optional]
 **perPage** | **int**|  | [optional]
 **psgcCode** | **String**|  | [optional]
 **psgcVersionId** | **String**|  | [optional]

### Return type

[**AdminMaterialsAnalyticsListEnvelope**](AdminMaterialsAnalyticsListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

