# materyalph_api_client.api.AdminGeographicAnalyticsApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getGeoAnalyticsDashboard**](AdminGeographicAnalyticsApi.md#getgeoanalyticsdashboard) | **GET** /admin/geo-analytics |
[**getGeoBoundaries**](AdminGeographicAnalyticsApi.md#getgeoboundaries) | **GET** /admin/geo-analytics/boundaries |
[**getGeoDemandHeatmap**](AdminGeographicAnalyticsApi.md#getgeodemandheatmap) | **GET** /admin/geo-analytics/demand |
[**getGeoFilterOptions**](AdminGeographicAnalyticsApi.md#getgeofilteroptions) | **GET** /admin/geo-analytics/filter-options |


# **getGeoAnalyticsDashboard**
> GeoDashboardEnvelope getGeoAnalyticsDashboard(dataset, area, from, to, granularity, procurementType, categoryId, materialId, fulfillmentMethod, paymentMethod, orderState)



analytics.view_aggregates. KPIs, trends, rates, response time, DAU/WAU/MAU and the child-area table from daily facts, after small-cell suppression. Unknown parameters return 422 ANALYTICS_FILTER_UNSUPPORTED.

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

final api = MateryalphApiClient().getAdminGeographicAnalyticsApi();
final String dataset = dataset_example; // String |
final String area = area_example; // String | Active-version PSGC code of a region, province, independent city or city/municipality; omit for the Philippines. No radius applies.
final Date from = 2013-10-20; // Date |
final Date to = 2013-10-20; // Date |
final String granularity = granularity_example; // String |
final String procurementType = procurementType_example; // String |
final String categoryId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String materialId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String fulfillmentMethod = fulfillmentMethod_example; // String |
final String paymentMethod = paymentMethod_example; // String |
final String orderState = orderState_example; // String |

try {
    final response = api.getGeoAnalyticsDashboard(dataset, area, from, to, granularity, procurementType, categoryId, materialId, fulfillmentMethod, paymentMethod, orderState);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminGeographicAnalyticsApi->getGeoAnalyticsDashboard: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dataset** | **String**|  | [optional]
 **area** | **String**| Active-version PSGC code of a region, province, independent city or city/municipality; omit for the Philippines. No radius applies. | [optional]
 **from** | **Date**|  | [optional]
 **to** | **Date**|  | [optional]
 **granularity** | **String**|  | [optional]
 **procurementType** | **String**|  | [optional]
 **categoryId** | **String**|  | [optional]
 **materialId** | **String**|  | [optional]
 **fulfillmentMethod** | **String**|  | [optional]
 **paymentMethod** | **String**|  | [optional]
 **orderState** | **String**|  | [optional]

### Return type

[**GeoDashboardEnvelope**](GeoDashboardEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getGeoBoundaries**
> GeoBoundaryEnvelope getGeoBoundaries(area)



analytics.view_aggregates. Simplified PSGC boundaries of the selection's children for the map.

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

final api = MateryalphApiClient().getAdminGeographicAnalyticsApi();
final String area = area_example; // String |

try {
    final response = api.getGeoBoundaries(area);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminGeographicAnalyticsApi->getGeoBoundaries: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **area** | **String**|  | [optional]

### Return type

[**GeoBoundaryEnvelope**](GeoBoundaryEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getGeoDemandHeatmap**
> GeoDemandEnvelope getGeoDemandHeatmap(dataset, area, from, to, granularity, procurementType, categoryId, materialId, fulfillmentMethod, paymentMethod, orderState, measure, page)



analytics.view_aggregates. Category or material demand by child area with eight taxonomy columns per page, including active categories or materials with zero matching demand and inactive entries with matching historical demand. Columns have stable taxonomy ordering and column_pagination describes all pages. Category/material filters constrain individual demand lines. Quantity needs one material (422 QUANTITY_NEEDS_MATERIAL).

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

final api = MateryalphApiClient().getAdminGeographicAnalyticsApi();
final String dataset = dataset_example; // String |
final String area = area_example; // String | Active-version PSGC code of a region, province, independent city or city/municipality; omit for the Philippines. No radius applies.
final Date from = 2013-10-20; // Date |
final Date to = 2013-10-20; // Date |
final String granularity = granularity_example; // String |
final String procurementType = procurementType_example; // String |
final String categoryId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String materialId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String fulfillmentMethod = fulfillmentMethod_example; // String |
final String paymentMethod = paymentMethod_example; // String |
final String orderState = orderState_example; // String |
final String measure = measure_example; // String |
final int page = 56; // int | Page of category or material columns, eight per page.

try {
    final response = api.getGeoDemandHeatmap(dataset, area, from, to, granularity, procurementType, categoryId, materialId, fulfillmentMethod, paymentMethod, orderState, measure, page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminGeographicAnalyticsApi->getGeoDemandHeatmap: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dataset** | **String**|  | [optional]
 **area** | **String**| Active-version PSGC code of a region, province, independent city or city/municipality; omit for the Philippines. No radius applies. | [optional]
 **from** | **Date**|  | [optional]
 **to** | **Date**|  | [optional]
 **granularity** | **String**|  | [optional]
 **procurementType** | **String**|  | [optional]
 **categoryId** | **String**|  | [optional]
 **materialId** | **String**|  | [optional]
 **fulfillmentMethod** | **String**|  | [optional]
 **paymentMethod** | **String**|  | [optional]
 **orderState** | **String**|  | [optional]
 **measure** | **String**|  | [optional]
 **page** | **int**| Page of category or material columns, eight per page. | [optional] [default to 1]

### Return type

[**GeoDemandEnvelope**](GeoDemandEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getGeoFilterOptions**
> GeoFilterOptionsEnvelope getGeoFilterOptions(categoryId, page)



Requires analytics.view_aggregates and the geo_analytics feature flag. Paginated active material categories from the taxonomy, ordered by sort order, name and ID. With category_id, returns active canonical materials in that category ordered by name and ID. Choices are independent of demand, dataset, dates and geography, including choices with no orders.

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

final api = MateryalphApiClient().getAdminGeographicAnalyticsApi();
final String categoryId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final int page = 56; // int |

try {
    final response = api.getGeoFilterOptions(categoryId, page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminGeographicAnalyticsApi->getGeoFilterOptions: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **categoryId** | **String**|  | [optional]
 **page** | **int**|  | [optional] [default to 1]

### Return type

[**GeoFilterOptionsEnvelope**](GeoFilterOptionsEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

