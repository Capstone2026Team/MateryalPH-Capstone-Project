# materyalph_api_client.api.AdminDashboardApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getAdminDashboardInsights**](AdminDashboardApi.md#getadmindashboardinsights) | **GET** /admin/dashboard/insights |


# **getAdminDashboardInsights**
> AdminDashboardInsightsEnvelope getAdminDashboardInsights(days, dataset, area, from, to)



Any active Admin. marketplace needs analytics.view_aggregates and the geo_analytics flag; vendor_health needs scores.view. Unknown parameters return 422 DASHBOARD_FILTER_UNSUPPORTED; no point or radius filter exists.

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

final api = MateryalphApiClient().getAdminDashboardApi();
final int days = 56; // int |
final String dataset = dataset_example; // String |
final String area = area_example; // String | Active-version PSGC code; omit for the Philippines.
final Date from = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Existing geographic date basis (confirmed_on and reporting cutoff). Custom ranges remain bounded to 366 inclusive dates; omitted dates retain the legacy 30-day period.
final Date to = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Existing geographic date basis (confirmed_on and reporting cutoff). Custom ranges remain bounded to 366 inclusive dates; omitted dates retain the legacy 30-day period.

try {
    final response = api.getAdminDashboardInsights(days, dataset, area, from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminDashboardApi->getAdminDashboardInsights: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **days** | **int**|  | [optional] [default to 30]
 **dataset** | **String**|  | [optional]
 **area** | **String**| Active-version PSGC code; omit for the Philippines. | [optional]
 **from** | **Date**| Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Existing geographic date basis (confirmed_on and reporting cutoff). Custom ranges remain bounded to 366 inclusive dates; omitted dates retain the legacy 30-day period. | [optional]
 **to** | **Date**| Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Existing geographic date basis (confirmed_on and reporting cutoff). Custom ranges remain bounded to 366 inclusive dates; omitted dates retain the legacy 30-day period. | [optional]

### Return type

[**AdminDashboardInsightsEnvelope**](AdminDashboardInsightsEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

