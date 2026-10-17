# materyalph_api_client.api.VendorProductAnalyticsApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getVendorProductAnalytics**](VendorProductAnalyticsApi.md#getvendorproductanalytics) | **GET** /vendor/product-analytics |
[**getVendorProductAnalyticsDetail**](VendorProductAnalyticsApi.md#getvendorproductanalyticsdetail) | **GET** /vendor/product-analytics/listings/{listingId} |
[**getVendorProductAnalyticsSummaries**](VendorProductAnalyticsApi.md#getvendorproductanalyticssummaries) | **GET** /vendor/product-analytics/summaries |


# **getVendorProductAnalytics**
> VendorProductAnalyticsEnvelope getVendorProductAnalytics(days, from, to, sort, page)



Vendor members holding catalog.manage (Owner, Store Manager, Store Staff, Inventory Staff); others receive 403 PRODUCT_ANALYTICS_DENIED. Peso values are null unless the caller holds finance.view (Owner). Unknown parameters return 422 PRODUCT_ANALYTICS_FILTER_UNSUPPORTED. The products table is paginated (20 per page); sort=value falls back to orders without finance.view.

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

final api = MateryalphApiClient().getVendorProductAnalyticsApi();
final int days = 56; // int |
final Date from = 2013-10-20; // Date | Inclusive Asia/Manila calendar date (up to 366 days in all). Views use the view day; orders use their first confirmation day; forecasts and co-ordering keep an independent 90-day history.
final Date to = 2013-10-20; // Date | Inclusive Asia/Manila calendar date (up to 366 days in all). Views use the view day; orders use their first confirmation day; forecasts and co-ordering keep an independent 90-day history.
final String sort = sort_example; // String |
final int page = 56; // int |

try {
    final response = api.getVendorProductAnalytics(days, from, to, sort, page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorProductAnalyticsApi->getVendorProductAnalytics: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **days** | **int**|  | [optional] [default to 30]
 **from** | **Date**| Inclusive Asia/Manila calendar date (up to 366 days in all). Views use the view day; orders use their first confirmation day; forecasts and co-ordering keep an independent 90-day history. | [optional]
 **to** | **Date**| Inclusive Asia/Manila calendar date (up to 366 days in all). Views use the view day; orders use their first confirmation day; forecasts and co-ordering keep an independent 90-day history. | [optional]
 **sort** | **String**|  | [optional] [default to 'views']
 **page** | **int**|  | [optional] [default to 1]

### Return type

[**VendorProductAnalyticsEnvelope**](VendorProductAnalyticsEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVendorProductAnalyticsDetail**
> VendorProductAnalyticsDetailEnvelope getVendorProductAnalyticsDetail(listingId, days, from, to)



Vendor members holding catalog.manage (Owner, Store Manager, Store Staff, Inventory Staff); others receive 403 PRODUCT_ANALYTICS_DENIED. Peso values are null unless the caller holds finance.view (Owner). Unknown parameters return 422 PRODUCT_ANALYTICS_FILTER_UNSUPPORTED. A listing outside the caller’s store returns 404 LISTING_NOT_FOUND.

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

final api = MateryalphApiClient().getVendorProductAnalyticsApi();
final String listingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final int days = 56; // int |
final Date from = 2013-10-20; // Date | Inclusive Asia/Manila calendar date (up to 366 days in all). Views use the view day; orders use their first confirmation day; forecasts and co-ordering keep an independent 90-day history.
final Date to = 2013-10-20; // Date | Inclusive Asia/Manila calendar date (up to 366 days in all). Views use the view day; orders use their first confirmation day; forecasts and co-ordering keep an independent 90-day history.

try {
    final response = api.getVendorProductAnalyticsDetail(listingId, days, from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorProductAnalyticsApi->getVendorProductAnalyticsDetail: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **listingId** | **String**|  |
 **days** | **int**|  | [optional] [default to 30]
 **from** | **Date**| Inclusive Asia/Manila calendar date (up to 366 days in all). Views use the view day; orders use their first confirmation day; forecasts and co-ordering keep an independent 90-day history. | [optional]
 **to** | **Date**| Inclusive Asia/Manila calendar date (up to 366 days in all). Views use the view day; orders use their first confirmation day; forecasts and co-ordering keep an independent 90-day history. | [optional]

### Return type

[**VendorProductAnalyticsDetailEnvelope**](VendorProductAnalyticsDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVendorProductAnalyticsSummaries**
> VendorProductAnalyticsSummariesEnvelope getVendorProductAnalyticsSummaries(listingIds, days)



Vendor members holding catalog.manage (Owner, Store Manager, Store Staff, Inventory Staff); others receive 403 PRODUCT_ANALYTICS_DENIED. Peso values are null unless the caller holds finance.view (Owner). Unknown parameters return 422 PRODUCT_ANALYTICS_FILTER_UNSUPPORTED. Up to 50 comma-separated listing IDs.

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

final api = MateryalphApiClient().getVendorProductAnalyticsApi();
final String listingIds = listingIds_example; // String | Comma-separated listing IDs (at most 50).
final int days = 56; // int |

try {
    final response = api.getVendorProductAnalyticsSummaries(listingIds, days);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorProductAnalyticsApi->getVendorProductAnalyticsSummaries: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **listingIds** | **String**| Comma-separated listing IDs (at most 50). |
 **days** | **int**|  | [optional] [default to 30]

### Return type

[**VendorProductAnalyticsSummariesEnvelope**](VendorProductAnalyticsSummariesEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

