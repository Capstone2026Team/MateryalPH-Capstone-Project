# VendorMaterialsAnalyticsApi

All URIs are relative to */api/v1*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**exportVendorMaterialsAnalytics**](VendorMaterialsAnalyticsApi.md#exportvendormaterialsanalytics) | **GET** /vendor/materials-analytics/export |  |
| [**getVendorMaterialPriceDetails**](VendorMaterialsAnalyticsApi.md#getvendormaterialpricedetails) | **GET** /vendor/materials-analytics/{groupId} |  |
| [**listVendorMaterialsAnalytics**](VendorMaterialsAnalyticsApi.md#listvendormaterialsanalytics) | **GET** /vendor/materials-analytics |  |



## exportVendorMaterialsAnalytics

> Blob exportVendorMaterialsAnalytics(presetDays, startDate, endDate, radiusKm)



materials_analytics.view_competitors. Aggregate-only CSV with the same suppression; re-authorized on every request.

### Example

```ts
import {
  Configuration,
  VendorMaterialsAnalyticsApi,
} from '@materyalph/api-client-ts';
import type { ExportVendorMaterialsAnalyticsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorMaterialsAnalyticsApi(config);

  const body = {
    // 7 | 30 | 90 (optional)
    presetDays: 56,
    // Date (optional)
    startDate: 2013-10-20,
    // Date (optional)
    endDate: 2013-10-20,
    // 5 | 10 | 20 | 30 | 40 | 50 | Around your own verified store point (default 50 km). Any origin or competitor field is refused. (optional)
    radiusKm: 56,
  } satisfies ExportVendorMaterialsAnalyticsRequest;

  try {
    const data = await api.exportVendorMaterialsAnalytics(body);
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
| **presetDays** | `7`, `30`, `90` |  | [Optional] [Defaults to `undefined`] [Enum: 7, 30, 90] |
| **startDate** | `Date` |  | [Optional] [Defaults to `undefined`] |
| **endDate** | `Date` |  | [Optional] [Defaults to `undefined`] |
| **radiusKm** | `5`, `10`, `20`, `30`, `40`, `50` | Around your own verified store point (default 50 km). Any origin or competitor field is refused. | [Optional] [Defaults to `undefined`] [Enum: 5, 10, 20, 30, 40, 50] |

### Return type

**Blob**

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `text/csv`, `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Competitor aggregates CSV; formulas neutralized. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **409** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **503** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getVendorMaterialPriceDetails

> VendorMaterialsAnalyticsDetailEnvelope getVendorMaterialPriceDetails(groupId, presetDays, startDate, endDate, radiusKm)



materials_analytics.view_competitors. The aggregate graph/table for one comparable variant; there is no competitor-offers child.

### Example

```ts
import {
  Configuration,
  VendorMaterialsAnalyticsApi,
} from '@materyalph/api-client-ts';
import type { GetVendorMaterialPriceDetailsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorMaterialsAnalyticsApi(config);

  const body = {
    // string
    groupId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // 7 | 30 | 90 (optional)
    presetDays: 56,
    // Date (optional)
    startDate: 2013-10-20,
    // Date (optional)
    endDate: 2013-10-20,
    // 5 | 10 | 20 | 30 | 40 | 50 | Around your own verified store point (default 50 km). Any origin or competitor field is refused. (optional)
    radiusKm: 56,
  } satisfies GetVendorMaterialPriceDetailsRequest;

  try {
    const data = await api.getVendorMaterialPriceDetails(body);
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
| **groupId** | `string` |  | [Defaults to `undefined`] |
| **presetDays** | `7`, `30`, `90` |  | [Optional] [Defaults to `undefined`] [Enum: 7, 30, 90] |
| **startDate** | `Date` |  | [Optional] [Defaults to `undefined`] |
| **endDate** | `Date` |  | [Optional] [Defaults to `undefined`] |
| **radiusKm** | `5`, `10`, `20`, `30`, `40`, `50` | Around your own verified store point (default 50 km). Any origin or competitor field is refused. | [Optional] [Defaults to `undefined`] [Enum: 5, 10, 20, 30, 40, 50] |

### Return type

[**VendorMaterialsAnalyticsDetailEnvelope**](VendorMaterialsAnalyticsDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized result. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **404** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **409** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **503** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## listVendorMaterialsAnalytics

> VendorMaterialsAnalyticsListEnvelope listVendorMaterialsAnalytics(presetDays, startDate, endDate, categoryId, q, cursor, perPage, radiusKm)



materials_analytics.view_competitors (Owner, Store Manager only). Competitor aggregates excluding your organization, suppressed below three competitors at every point and endpoint, and your own price separately. No offers, identities or protected finance.

### Example

```ts
import {
  Configuration,
  VendorMaterialsAnalyticsApi,
} from '@materyalph/api-client-ts';
import type { ListVendorMaterialsAnalyticsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorMaterialsAnalyticsApi(config);

  const body = {
    // 7 | 30 | 90 (optional)
    presetDays: 56,
    // Date (optional)
    startDate: 2013-10-20,
    // Date (optional)
    endDate: 2013-10-20,
    // string (optional)
    categoryId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string (optional)
    q: q_example,
    // string (optional)
    cursor: cursor_example,
    // number (optional)
    perPage: 56,
    // 5 | 10 | 20 | 30 | 40 | 50 | Around your own verified store point (default 50 km). Any origin or competitor field is refused. (optional)
    radiusKm: 56,
  } satisfies ListVendorMaterialsAnalyticsRequest;

  try {
    const data = await api.listVendorMaterialsAnalytics(body);
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
| **presetDays** | `7`, `30`, `90` |  | [Optional] [Defaults to `undefined`] [Enum: 7, 30, 90] |
| **startDate** | `Date` |  | [Optional] [Defaults to `undefined`] |
| **endDate** | `Date` |  | [Optional] [Defaults to `undefined`] |
| **categoryId** | `string` |  | [Optional] [Defaults to `undefined`] |
| **q** | `string` |  | [Optional] [Defaults to `undefined`] |
| **cursor** | `string` |  | [Optional] [Defaults to `undefined`] |
| **perPage** | `number` |  | [Optional] [Defaults to `undefined`] |
| **radiusKm** | `5`, `10`, `20`, `30`, `40`, `50` | Around your own verified store point (default 50 km). Any origin or competitor field is refused. | [Optional] [Defaults to `undefined`] [Enum: 5, 10, 20, 30, 40, 50] |

### Return type

[**VendorMaterialsAnalyticsListEnvelope**](VendorMaterialsAnalyticsListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized result. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **409** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **503** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

