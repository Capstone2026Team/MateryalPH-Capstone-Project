# materyalph_api_client.api.VendorMaterialsAnalyticsApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**exportVendorMaterialsAnalytics**](VendorMaterialsAnalyticsApi.md#exportvendormaterialsanalytics) | **GET** /vendor/materials-analytics/export |
[**getVendorMaterialPriceDetails**](VendorMaterialsAnalyticsApi.md#getvendormaterialpricedetails) | **GET** /vendor/materials-analytics/{groupId} |
[**listVendorMaterialsAnalytics**](VendorMaterialsAnalyticsApi.md#listvendormaterialsanalytics) | **GET** /vendor/materials-analytics |


# **exportVendorMaterialsAnalytics**
> Uint8List exportVendorMaterialsAnalytics(presetDays, startDate, endDate, radiusKm)



materials_analytics.view_competitors. Aggregate-only CSV with the same suppression; re-authorized on every request.

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

final api = MateryalphApiClient().getVendorMaterialsAnalyticsApi();
final int presetDays = 56; // int |
final Date startDate = 2013-10-20; // Date |
final Date endDate = 2013-10-20; // Date |
final int radiusKm = 56; // int | Around your own verified store point (default 50 km). Any origin or competitor field is refused.

try {
    final response = api.exportVendorMaterialsAnalytics(presetDays, startDate, endDate, radiusKm);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorMaterialsAnalyticsApi->exportVendorMaterialsAnalytics: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **presetDays** | **int**|  | [optional]
 **startDate** | **Date**|  | [optional]
 **endDate** | **Date**|  | [optional]
 **radiusKm** | **int**| Around your own verified store point (default 50 km). Any origin or competitor field is refused. | [optional]

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/csv, application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVendorMaterialPriceDetails**
> VendorMaterialsAnalyticsDetailEnvelope getVendorMaterialPriceDetails(groupId, presetDays, startDate, endDate, radiusKm)



materials_analytics.view_competitors. The aggregate graph/table for one comparable variant; there is no competitor-offers child.

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

final api = MateryalphApiClient().getVendorMaterialsAnalyticsApi();
final String groupId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final int presetDays = 56; // int |
final Date startDate = 2013-10-20; // Date |
final Date endDate = 2013-10-20; // Date |
final int radiusKm = 56; // int | Around your own verified store point (default 50 km). Any origin or competitor field is refused.

try {
    final response = api.getVendorMaterialPriceDetails(groupId, presetDays, startDate, endDate, radiusKm);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorMaterialsAnalyticsApi->getVendorMaterialPriceDetails: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **groupId** | **String**|  |
 **presetDays** | **int**|  | [optional]
 **startDate** | **Date**|  | [optional]
 **endDate** | **Date**|  | [optional]
 **radiusKm** | **int**| Around your own verified store point (default 50 km). Any origin or competitor field is refused. | [optional]

### Return type

[**VendorMaterialsAnalyticsDetailEnvelope**](VendorMaterialsAnalyticsDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listVendorMaterialsAnalytics**
> VendorMaterialsAnalyticsListEnvelope listVendorMaterialsAnalytics(presetDays, startDate, endDate, categoryId, q, cursor, perPage, radiusKm)



materials_analytics.view_competitors (Owner, Store Manager only). Competitor aggregates excluding your organization, suppressed below three competitors at every point and endpoint, and your own price separately. No offers, identities or protected finance.

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

final api = MateryalphApiClient().getVendorMaterialsAnalyticsApi();
final int presetDays = 56; // int |
final Date startDate = 2013-10-20; // Date |
final Date endDate = 2013-10-20; // Date |
final String categoryId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String q = q_example; // String |
final String cursor = cursor_example; // String |
final int perPage = 56; // int |
final int radiusKm = 56; // int | Around your own verified store point (default 50 km). Any origin or competitor field is refused.

try {
    final response = api.listVendorMaterialsAnalytics(presetDays, startDate, endDate, categoryId, q, cursor, perPage, radiusKm);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorMaterialsAnalyticsApi->listVendorMaterialsAnalytics: $e\n');
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
 **radiusKm** | **int**| Around your own verified store point (default 50 km). Any origin or competitor field is refused. | [optional]

### Return type

[**VendorMaterialsAnalyticsListEnvelope**](VendorMaterialsAnalyticsListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

