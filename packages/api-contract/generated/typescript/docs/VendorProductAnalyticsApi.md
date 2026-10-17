# VendorProductAnalyticsApi

All URIs are relative to */api/v1*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**getVendorProductAnalytics**](VendorProductAnalyticsApi.md#getvendorproductanalytics) | **GET** /vendor/product-analytics |  |
| [**getVendorProductAnalyticsDetail**](VendorProductAnalyticsApi.md#getvendorproductanalyticsdetail) | **GET** /vendor/product-analytics/listings/{listingId} |  |
| [**getVendorProductAnalyticsSummaries**](VendorProductAnalyticsApi.md#getvendorproductanalyticssummaries) | **GET** /vendor/product-analytics/summaries |  |



## getVendorProductAnalytics

> VendorProductAnalyticsEnvelope getVendorProductAnalytics(days, from, to, sort, page)



Vendor members holding catalog.manage (Owner, Store Manager, Store Staff, Inventory Staff); others receive 403 PRODUCT_ANALYTICS_DENIED. Peso values are null unless the caller holds finance.view (Owner). Unknown parameters return 422 PRODUCT_ANALYTICS_FILTER_UNSUPPORTED. The products table is paginated (20 per page); sort&#x3D;value falls back to orders without finance.view.

### Example

```ts
import {
  Configuration,
  VendorProductAnalyticsApi,
} from '@materyalph/api-client-ts';
import type { GetVendorProductAnalyticsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorProductAnalyticsApi(config);

  const body = {
    // 7 | 30 | 90 (optional)
    days: 56,
    // Date | Inclusive Asia/Manila calendar date (up to 366 days in all). Views use the view day; orders use their first confirmation day; forecasts and co-ordering keep an independent 90-day history. (optional)
    from: 2013-10-20,
    // Date | Inclusive Asia/Manila calendar date (up to 366 days in all). Views use the view day; orders use their first confirmation day; forecasts and co-ordering keep an independent 90-day history. (optional)
    to: 2013-10-20,
    // 'views' | 'orders' | 'conversion' | 'value' (optional)
    sort: sort_example,
    // number (optional)
    page: 56,
  } satisfies GetVendorProductAnalyticsRequest;

  try {
    const data = await api.getVendorProductAnalytics(body);
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
| **days** | `7`, `30`, `90` |  | [Optional] [Defaults to `30`] [Enum: 7, 30, 90] |
| **from** | `Date` | Inclusive Asia/Manila calendar date (up to 366 days in all). Views use the view day; orders use their first confirmation day; forecasts and co-ordering keep an independent 90-day history. | [Optional] [Defaults to `undefined`] |
| **to** | `Date` | Inclusive Asia/Manila calendar date (up to 366 days in all). Views use the view day; orders use their first confirmation day; forecasts and co-ordering keep an independent 90-day history. | [Optional] [Defaults to `undefined`] |
| **sort** | `views`, `orders`, `conversion`, `value` |  | [Optional] [Defaults to `&#39;views&#39;`] [Enum: views, orders, conversion, value] |
| **page** | `number` |  | [Optional] [Defaults to `1`] |

### Return type

[**VendorProductAnalyticsEnvelope**](VendorProductAnalyticsEnvelope.md)

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
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getVendorProductAnalyticsDetail

> VendorProductAnalyticsDetailEnvelope getVendorProductAnalyticsDetail(listingId, days, from, to)



Vendor members holding catalog.manage (Owner, Store Manager, Store Staff, Inventory Staff); others receive 403 PRODUCT_ANALYTICS_DENIED. Peso values are null unless the caller holds finance.view (Owner). Unknown parameters return 422 PRODUCT_ANALYTICS_FILTER_UNSUPPORTED. A listing outside the caller’s store returns 404 LISTING_NOT_FOUND.

### Example

```ts
import {
  Configuration,
  VendorProductAnalyticsApi,
} from '@materyalph/api-client-ts';
import type { GetVendorProductAnalyticsDetailRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorProductAnalyticsApi(config);

  const body = {
    // string
    listingId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // 7 | 30 | 90 (optional)
    days: 56,
    // Date | Inclusive Asia/Manila calendar date (up to 366 days in all). Views use the view day; orders use their first confirmation day; forecasts and co-ordering keep an independent 90-day history. (optional)
    from: 2013-10-20,
    // Date | Inclusive Asia/Manila calendar date (up to 366 days in all). Views use the view day; orders use their first confirmation day; forecasts and co-ordering keep an independent 90-day history. (optional)
    to: 2013-10-20,
  } satisfies GetVendorProductAnalyticsDetailRequest;

  try {
    const data = await api.getVendorProductAnalyticsDetail(body);
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
| **listingId** | `string` |  | [Defaults to `undefined`] |
| **days** | `7`, `30`, `90` |  | [Optional] [Defaults to `30`] [Enum: 7, 30, 90] |
| **from** | `Date` | Inclusive Asia/Manila calendar date (up to 366 days in all). Views use the view day; orders use their first confirmation day; forecasts and co-ordering keep an independent 90-day history. | [Optional] [Defaults to `undefined`] |
| **to** | `Date` | Inclusive Asia/Manila calendar date (up to 366 days in all). Views use the view day; orders use their first confirmation day; forecasts and co-ordering keep an independent 90-day history. | [Optional] [Defaults to `undefined`] |

### Return type

[**VendorProductAnalyticsDetailEnvelope**](VendorProductAnalyticsDetailEnvelope.md)

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
| **404** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getVendorProductAnalyticsSummaries

> VendorProductAnalyticsSummariesEnvelope getVendorProductAnalyticsSummaries(listingIds, days)



Vendor members holding catalog.manage (Owner, Store Manager, Store Staff, Inventory Staff); others receive 403 PRODUCT_ANALYTICS_DENIED. Peso values are null unless the caller holds finance.view (Owner). Unknown parameters return 422 PRODUCT_ANALYTICS_FILTER_UNSUPPORTED. Up to 50 comma-separated listing IDs.

### Example

```ts
import {
  Configuration,
  VendorProductAnalyticsApi,
} from '@materyalph/api-client-ts';
import type { GetVendorProductAnalyticsSummariesRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorProductAnalyticsApi(config);

  const body = {
    // string | Comma-separated listing IDs (at most 50).
    listingIds: listingIds_example,
    // 7 | 30 | 90 (optional)
    days: 56,
  } satisfies GetVendorProductAnalyticsSummariesRequest;

  try {
    const data = await api.getVendorProductAnalyticsSummaries(body);
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
| **listingIds** | `string` | Comma-separated listing IDs (at most 50). | [Defaults to `undefined`] |
| **days** | `7`, `30`, `90` |  | [Optional] [Defaults to `30`] [Enum: 7, 30, 90] |

### Return type

[**VendorProductAnalyticsSummariesEnvelope**](VendorProductAnalyticsSummariesEnvelope.md)

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
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

