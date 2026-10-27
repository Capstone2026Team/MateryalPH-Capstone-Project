# AdminGeographicAnalyticsApi

All URIs are relative to */api/v1*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**getGeoAnalyticsDashboard**](AdminGeographicAnalyticsApi.md#getgeoanalyticsdashboard) | **GET** /admin/geo-analytics |  |
| [**getGeoBoundaries**](AdminGeographicAnalyticsApi.md#getgeoboundaries) | **GET** /admin/geo-analytics/boundaries |  |
| [**getGeoDemandHeatmap**](AdminGeographicAnalyticsApi.md#getgeodemandheatmap) | **GET** /admin/geo-analytics/demand |  |
| [**getGeoFilterOptions**](AdminGeographicAnalyticsApi.md#getgeofilteroptions) | **GET** /admin/geo-analytics/filter-options |  |



## getGeoAnalyticsDashboard

> GeoDashboardEnvelope getGeoAnalyticsDashboard(dataset, area, from, to, granularity, procurementType, categoryId, materialId, fulfillmentMethod, paymentMethod, orderState)



analytics.view_aggregates. KPIs, trends, rates, response time, DAU/WAU/MAU and the child-area table from daily facts, after small-cell suppression. Unknown parameters return 422 ANALYTICS_FILTER_UNSUPPORTED.

### Example

```ts
import {
  Configuration,
  AdminGeographicAnalyticsApi,
} from '@materyalph/api-client-ts';
import type { GetGeoAnalyticsDashboardRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AdminGeographicAnalyticsApi(config);

  const body = {
    // 'TEST' | 'DEMO' (optional)
    dataset: dataset_example,
    // string | Active-version PSGC code of a region, province, independent city or city/municipality; omit for the Philippines. No radius applies. (optional)
    area: area_example,
    // Date (optional)
    from: 2013-10-20,
    // Date (optional)
    to: 2013-10-20,
    // 'DAY' | 'WEEK' | 'MONTH' (optional)
    granularity: granularity_example,
    // 'ITEM_BASED' | 'PROJECT_BASED' (optional)
    procurementType: procurementType_example,
    // string (optional)
    categoryId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string (optional)
    materialId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // 'DELIVERY' | 'PICKUP' (optional)
    fulfillmentMethod: fulfillmentMethod_example,
    // 'ONLINE' | 'CASH_ON_DELIVERY' | 'IN_STORE' (optional)
    paymentMethod: paymentMethod_example,
    // 'CONFIRMED' | 'PROCESSING' | 'READY_FOR_PICKUP' | 'OUT_FOR_DELIVERY' | 'DELIVERED' | 'PICKED_UP' | 'COMPLETED' | 'DISPUTED' | 'CANCELLATION_REQUESTED' | 'CANCELLED' (optional)
    orderState: orderState_example,
  } satisfies GetGeoAnalyticsDashboardRequest;

  try {
    const data = await api.getGeoAnalyticsDashboard(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **dataset** | `TEST`, `DEMO` |  | [Optional] [Defaults to `undefined`] [Enum: TEST, DEMO] |
| **area** | `string` | Active-version PSGC code of a region, province, independent city or city/municipality; omit for the Philippines. No radius applies. | [Optional] [Defaults to `undefined`] |
| **from** | `Date` |  | [Optional] [Defaults to `undefined`] |
| **to** | `Date` |  | [Optional] [Defaults to `undefined`] |
| **granularity** | `DAY`, `WEEK`, `MONTH` |  | [Optional] [Defaults to `undefined`] [Enum: DAY, WEEK, MONTH] |
| **procurementType** | `ITEM_BASED`, `PROJECT_BASED` |  | [Optional] [Defaults to `undefined`] [Enum: ITEM_BASED, PROJECT_BASED] |
| **categoryId** | `string` |  | [Optional] [Defaults to `undefined`] |
| **materialId** | `string` |  | [Optional] [Defaults to `undefined`] |
| **fulfillmentMethod** | `DELIVERY`, `PICKUP` |  | [Optional] [Defaults to `undefined`] [Enum: DELIVERY, PICKUP] |
| **paymentMethod** | `ONLINE`, `CASH_ON_DELIVERY`, `IN_STORE` |  | [Optional] [Defaults to `undefined`] [Enum: ONLINE, CASH_ON_DELIVERY, IN_STORE] |
| **orderState** | `CONFIRMED`, `PROCESSING`, `READY_FOR_PICKUP`, `OUT_FOR_DELIVERY`, `DELIVERED`, `PICKED_UP`, `COMPLETED`, `DISPUTED`, `CANCELLATION_REQUESTED`, `CANCELLED` |  | [Optional] [Defaults to `undefined`] [Enum: CONFIRMED, PROCESSING, READY_FOR_PICKUP, OUT_FOR_DELIVERY, DELIVERED, PICKED_UP, COMPLETED, DISPUTED, CANCELLATION_REQUESTED, CANCELLED] |

### Return type

[**GeoDashboardEnvelope**](GeoDashboardEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized result. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **409** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **503** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getGeoBoundaries

> GeoBoundaryEnvelope getGeoBoundaries(area)



analytics.view_aggregates. Simplified PSGC boundaries of the selection\&#39;s children for the map.

### Example

```ts
import {
  Configuration,
  AdminGeographicAnalyticsApi,
} from '@materyalph/api-client-ts';
import type { GetGeoBoundariesRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AdminGeographicAnalyticsApi(config);

  const body = {
    // string (optional)
    area: area_example,
  } satisfies GetGeoBoundariesRequest;

  try {
    const data = await api.getGeoBoundaries(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **area** | `string` |  | [Optional] [Defaults to `undefined`] |

### Return type

[**GeoBoundaryEnvelope**](GeoBoundaryEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized result. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **409** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **503** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getGeoDemandHeatmap

> GeoDemandEnvelope getGeoDemandHeatmap(dataset, area, from, to, granularity, procurementType, categoryId, materialId, fulfillmentMethod, paymentMethod, orderState, measure, page)



analytics.view_aggregates. Category or material demand by child area with eight taxonomy columns per page, including active categories or materials with zero matching demand and inactive entries with matching historical demand. Columns have stable taxonomy ordering and column_pagination describes all pages. Category/material filters constrain individual demand lines. Quantity needs one material (422 QUANTITY_NEEDS_MATERIAL).

### Example

```ts
import {
  Configuration,
  AdminGeographicAnalyticsApi,
} from '@materyalph/api-client-ts';
import type { GetGeoDemandHeatmapRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AdminGeographicAnalyticsApi(config);

  const body = {
    // 'TEST' | 'DEMO' (optional)
    dataset: dataset_example,
    // string | Active-version PSGC code of a region, province, independent city or city/municipality; omit for the Philippines. No radius applies. (optional)
    area: area_example,
    // Date (optional)
    from: 2013-10-20,
    // Date (optional)
    to: 2013-10-20,
    // 'DAY' | 'WEEK' | 'MONTH' (optional)
    granularity: granularity_example,
    // 'ITEM_BASED' | 'PROJECT_BASED' (optional)
    procurementType: procurementType_example,
    // string (optional)
    categoryId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string (optional)
    materialId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // 'DELIVERY' | 'PICKUP' (optional)
    fulfillmentMethod: fulfillmentMethod_example,
    // 'ONLINE' | 'CASH_ON_DELIVERY' | 'IN_STORE' (optional)
    paymentMethod: paymentMethod_example,
    // 'CONFIRMED' | 'PROCESSING' | 'READY_FOR_PICKUP' | 'OUT_FOR_DELIVERY' | 'DELIVERED' | 'PICKED_UP' | 'COMPLETED' | 'DISPUTED' | 'CANCELLATION_REQUESTED' | 'CANCELLED' (optional)
    orderState: orderState_example,
    // 'ORDER_COUNT' | 'QUANTITY' | 'VALUE' (optional)
    measure: measure_example,
    // number | Page of category or material columns, eight per page. (optional)
    page: 56,
  } satisfies GetGeoDemandHeatmapRequest;

  try {
    const data = await api.getGeoDemandHeatmap(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **dataset** | `TEST`, `DEMO` |  | [Optional] [Defaults to `undefined`] [Enum: TEST, DEMO] |
| **area** | `string` | Active-version PSGC code of a region, province, independent city or city/municipality; omit for the Philippines. No radius applies. | [Optional] [Defaults to `undefined`] |
| **from** | `Date` |  | [Optional] [Defaults to `undefined`] |
| **to** | `Date` |  | [Optional] [Defaults to `undefined`] |
| **granularity** | `DAY`, `WEEK`, `MONTH` |  | [Optional] [Defaults to `undefined`] [Enum: DAY, WEEK, MONTH] |
| **procurementType** | `ITEM_BASED`, `PROJECT_BASED` |  | [Optional] [Defaults to `undefined`] [Enum: ITEM_BASED, PROJECT_BASED] |
| **categoryId** | `string` |  | [Optional] [Defaults to `undefined`] |
| **materialId** | `string` |  | [Optional] [Defaults to `undefined`] |
| **fulfillmentMethod** | `DELIVERY`, `PICKUP` |  | [Optional] [Defaults to `undefined`] [Enum: DELIVERY, PICKUP] |
| **paymentMethod** | `ONLINE`, `CASH_ON_DELIVERY`, `IN_STORE` |  | [Optional] [Defaults to `undefined`] [Enum: ONLINE, CASH_ON_DELIVERY, IN_STORE] |
| **orderState** | `CONFIRMED`, `PROCESSING`, `READY_FOR_PICKUP`, `OUT_FOR_DELIVERY`, `DELIVERED`, `PICKED_UP`, `COMPLETED`, `DISPUTED`, `CANCELLATION_REQUESTED`, `CANCELLED` |  | [Optional] [Defaults to `undefined`] [Enum: CONFIRMED, PROCESSING, READY_FOR_PICKUP, OUT_FOR_DELIVERY, DELIVERED, PICKED_UP, COMPLETED, DISPUTED, CANCELLATION_REQUESTED, CANCELLED] |
| **measure** | `ORDER_COUNT`, `QUANTITY`, `VALUE` |  | [Optional] [Defaults to `undefined`] [Enum: ORDER_COUNT, QUANTITY, VALUE] |
| **page** | `number` | Page of category or material columns, eight per page. | [Optional] [Defaults to `1`] |

### Return type

[**GeoDemandEnvelope**](GeoDemandEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized result. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **409** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **503** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getGeoFilterOptions

> GeoFilterOptionsEnvelope getGeoFilterOptions(categoryId, page)



Requires analytics.view_aggregates and the geo_analytics feature flag. Paginated active material categories from the taxonomy, ordered by sort order, name and ID. With category_id, returns active canonical materials in that category ordered by name and ID. Choices are independent of demand, dataset, dates and geography, including choices with no orders.

### Example

```ts
import {
  Configuration,
  AdminGeographicAnalyticsApi,
} from '@materyalph/api-client-ts';
import type { GetGeoFilterOptionsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AdminGeographicAnalyticsApi(config);

  const body = {
    // string (optional)
    categoryId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // number (optional)
    page: 56,
  } satisfies GetGeoFilterOptionsRequest;

  try {
    const data = await api.getGeoFilterOptions(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **categoryId** | `string` |  | [Optional] [Defaults to `undefined`] |
| **page** | `number` |  | [Optional] [Defaults to `1`] |

### Return type

[**GeoFilterOptionsEnvelope**](GeoFilterOptionsEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Taxonomy choices, up to 100 per page. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **503** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

