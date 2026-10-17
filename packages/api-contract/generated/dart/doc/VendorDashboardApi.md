# materyalph_api_client.api.VendorDashboardApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getVendorDashboardInsights**](VendorDashboardApi.md#getvendordashboardinsights) | **GET** /vendor/dashboard/insights |


# **getVendorDashboardInsights**
> VendorDashboardInsightsEnvelope getVendorDashboardInsights(days, from, to)



Any active Vendor member. Sections follow the fixed-role grants: orders.confirm, finance.view (peso values), scores.view_store, inventory.view and portal.disputes; a section without its grant is null. Unknown parameters return 422 DASHBOARD_FILTER_UNSUPPORTED.

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

final api = MateryalphApiClient().getVendorDashboardApi();
final int days = 56; // int |
final Date from = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Order first confirmation for sales and volume, submitted_at for responses, and event created_at for the demand funnel and filed cases. Omitted days and dates mean all own order history through today. Stock, scores and work queues remain current; forecasting and basket mining retain independent 90-day history.
final Date to = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Order first confirmation for sales and volume, submitted_at for responses, and event created_at for the demand funnel and filed cases. Omitted days and dates mean all own order history through today. Stock, scores and work queues remain current; forecasting and basket mining retain independent 90-day history.

try {
    final response = api.getVendorDashboardInsights(days, from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorDashboardApi->getVendorDashboardInsights: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **days** | **int**|  | [optional]
 **from** | **Date**| Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Order first confirmation for sales and volume, submitted_at for responses, and event created_at for the demand funnel and filed cases. Omitted days and dates mean all own order history through today. Stock, scores and work queues remain current; forecasting and basket mining retain independent 90-day history. | [optional]
 **to** | **Date**| Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Order first confirmation for sales and volume, submitted_at for responses, and event created_at for the demand funnel and filed cases. Omitted days and dates mean all own order history through today. Stock, scores and work queues remain current; forecasting and basket mining retain independent 90-day history. | [optional]

### Return type

[**VendorDashboardInsightsEnvelope**](VendorDashboardInsightsEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

