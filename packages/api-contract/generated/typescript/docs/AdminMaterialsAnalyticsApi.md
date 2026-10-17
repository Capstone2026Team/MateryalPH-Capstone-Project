# AdminMaterialsAnalyticsApi

All URIs are relative to */api/v1*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**correctAdminMaterialPriceRun**](AdminMaterialsAnalyticsApi.md#correctadminmaterialpricerun) | **POST** /admin/materials-analytics/runs/{runId}/corrections |  |
| [**exportAdminMaterialsAnalytics**](AdminMaterialsAnalyticsApi.md#exportadminmaterialsanalytics) | **GET** /admin/materials-analytics/export |  |
| [**getAdminMaterialPriceDetails**](AdminMaterialsAnalyticsApi.md#getadminmaterialpricedetails) | **GET** /admin/materials-analytics/{groupId} |  |
| [**listAdminMaterialPriceRuns**](AdminMaterialsAnalyticsApi.md#listadminmaterialpriceruns) | **GET** /admin/materials-analytics/runs |  |
| [**listAdminMaterialPriceSources**](AdminMaterialsAnalyticsApi.md#listadminmaterialpricesources) | **GET** /admin/materials-analytics/{groupId}/sources |  |
| [**listAdminMaterialsAnalytics**](AdminMaterialsAnalyticsApi.md#listadminmaterialsanalytics) | **GET** /admin/materials-analytics |  |



## correctAdminMaterialPriceRun

> AnalyticsCorrectionEnvelope correctAdminMaterialPriceRun(runId, idempotencyKey, analyticsCorrectionRequest)



materials_analytics.inspect_sources. Append a reviewed replacement revision excluding proven-invalid observations; originals are retained.

### Example

```ts
import {
  Configuration,
  AdminMaterialsAnalyticsApi,
} from '@materyalph/api-client-ts';
import type { CorrectAdminMaterialPriceRunRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AdminMaterialsAnalyticsApi(config);

  const body = {
    // string
    runId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    idempotencyKey: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // AnalyticsCorrectionRequest
    analyticsCorrectionRequest: ...,
  } satisfies CorrectAdminMaterialPriceRunRequest;

  try {
    const data = await api.correctAdminMaterialPriceRun(body);
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
| **runId** | `string` |  | [Defaults to `undefined`] |
| **idempotencyKey** | `string` |  | [Defaults to `undefined`] |
| **analyticsCorrectionRequest** | [AnalyticsCorrectionRequest](AnalyticsCorrectionRequest.md) |  | |

### Return type

[**AnalyticsCorrectionEnvelope**](AnalyticsCorrectionEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized result. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **404** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **409** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## exportAdminMaterialsAnalytics

> Blob exportAdminMaterialsAnalytics(presetDays, startDate, endDate, psgcCode, psgcVersionId)



analytics.view_aggregates and analytics.export. Aggregate CSV.

### Example

```ts
import {
  Configuration,
  AdminMaterialsAnalyticsApi,
} from '@materyalph/api-client-ts';
import type { ExportAdminMaterialsAnalyticsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AdminMaterialsAnalyticsApi(config);

  const body = {
    // 7 | 30 | 90 (optional)
    presetDays: 56,
    // Date (optional)
    startDate: 2013-10-20,
    // Date (optional)
    endDate: 2013-10-20,
    // string (optional)
    psgcCode: psgcCode_example,
    // string (optional)
    psgcVersionId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies ExportAdminMaterialsAnalyticsRequest;

  try {
    const data = await api.exportAdminMaterialsAnalytics(body);
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
| **psgcCode** | `string` |  | [Optional] [Defaults to `undefined`] |
| **psgcVersionId** | `string` |  | [Optional] [Defaults to `undefined`] |

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
| **200** | Aggregate CSV; formulas neutralized. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **503** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getAdminMaterialPriceDetails

> AdminMaterialsAnalyticsDetailEnvelope getAdminMaterialPriceDetails(groupId, presetDays, startDate, endDate, psgcCode, psgcVersionId)



analytics.view_aggregates. Graph/table with counts and exact means.

### Example

```ts
import {
  Configuration,
  AdminMaterialsAnalyticsApi,
} from '@materyalph/api-client-ts';
import type { GetAdminMaterialPriceDetailsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AdminMaterialsAnalyticsApi(config);

  const body = {
    // string
    groupId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // 7 | 30 | 90 (optional)
    presetDays: 56,
    // Date (optional)
    startDate: 2013-10-20,
    // Date (optional)
    endDate: 2013-10-20,
    // string (optional)
    psgcCode: psgcCode_example,
    // string (optional)
    psgcVersionId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies GetAdminMaterialPriceDetailsRequest;

  try {
    const data = await api.getAdminMaterialPriceDetails(body);
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
| **psgcCode** | `string` |  | [Optional] [Defaults to `undefined`] |
| **psgcVersionId** | `string` |  | [Optional] [Defaults to `undefined`] |

### Return type

[**AdminMaterialsAnalyticsDetailEnvelope**](AdminMaterialsAnalyticsDetailEnvelope.md)

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
| **503** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## listAdminMaterialPriceRuns

> AnalyticsRunListEnvelope listAdminMaterialPriceRuns()



analytics.view_aggregates. Snapshot health: state, revision, actual capture time and delay.

### Example

```ts
import {
  Configuration,
  AdminMaterialsAnalyticsApi,
} from '@materyalph/api-client-ts';
import type { ListAdminMaterialPriceRunsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AdminMaterialsAnalyticsApi(config);

  try {
    const data = await api.listAdminMaterialPriceRuns();
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters

This endpoint does not need any parameter.

### Return type

[**AnalyticsRunListEnvelope**](AnalyticsRunListEnvelope.md)

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
| **503** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## listAdminMaterialPriceSources

> AnalyticsSourceListEnvelope listAdminMaterialPriceSources(groupId, snapshotDate, reason, psgcCode)



materials_analytics.inspect_sources. Public listing identity, price/version, capture time and recorded geography for one published date; audited with your reason.

### Example

```ts
import {
  Configuration,
  AdminMaterialsAnalyticsApi,
} from '@materyalph/api-client-ts';
import type { ListAdminMaterialPriceSourcesRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AdminMaterialsAnalyticsApi(config);

  const body = {
    // string
    groupId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // Date
    snapshotDate: 2013-10-20,
    // string
    reason: reason_example,
    // string (optional)
    psgcCode: psgcCode_example,
  } satisfies ListAdminMaterialPriceSourcesRequest;

  try {
    const data = await api.listAdminMaterialPriceSources(body);
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
| **snapshotDate** | `Date` |  | [Defaults to `undefined`] |
| **reason** | `string` |  | [Defaults to `undefined`] |
| **psgcCode** | `string` |  | [Optional] [Defaults to `undefined`] |

### Return type

[**AnalyticsSourceListEnvelope**](AnalyticsSourceListEnvelope.md)

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
| **503** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## listAdminMaterialsAnalytics

> AdminMaterialsAnalyticsListEnvelope listAdminMaterialsAnalytics(presetDays, startDate, endDate, categoryId, q, cursor, perPage, psgcCode, psgcVersionId)



analytics.view_aggregates. PSGC-scoped (or Philippines-wide) aggregates; payment/order filters do not apply to listed-price history.

### Example

```ts
import {
  Configuration,
  AdminMaterialsAnalyticsApi,
} from '@materyalph/api-client-ts';
import type { ListAdminMaterialsAnalyticsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AdminMaterialsAnalyticsApi(config);

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
    // string (optional)
    psgcCode: psgcCode_example,
    // string (optional)
    psgcVersionId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies ListAdminMaterialsAnalyticsRequest;

  try {
    const data = await api.listAdminMaterialsAnalytics(body);
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
| **psgcCode** | `string` |  | [Optional] [Defaults to `undefined`] |
| **psgcVersionId** | `string` |  | [Optional] [Defaults to `undefined`] |

### Return type

[**AdminMaterialsAnalyticsListEnvelope**](AdminMaterialsAnalyticsListEnvelope.md)

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
| **503** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

