# AdminDashboardApi

All URIs are relative to */api/v1*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**getAdminDashboardInsights**](AdminDashboardApi.md#getadmindashboardinsights) | **GET** /admin/dashboard/insights |  |



## getAdminDashboardInsights

> AdminDashboardInsightsEnvelope getAdminDashboardInsights(days, dataset, area, from, to)



Any active Admin. marketplace needs analytics.view_aggregates and the geo_analytics flag; vendor_health needs scores.view. Unknown parameters return 422 DASHBOARD_FILTER_UNSUPPORTED; no point or radius filter exists.

### Example

```ts
import {
  Configuration,
  AdminDashboardApi,
} from '@materyalph/api-client-ts';
import type { GetAdminDashboardInsightsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AdminDashboardApi(config);

  const body = {
    // 30 | 90 (optional)
    days: 56,
    // 'TEST' | 'DEMO' (optional)
    dataset: dataset_example,
    // string | Active-version PSGC code; omit for the Philippines. (optional)
    area: area_example,
    // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Existing geographic date basis (confirmed_on and reporting cutoff). Custom ranges remain bounded to 366 inclusive dates; omitted dates retain the legacy 30-day period. (optional)
    from: 2013-10-20,
    // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Existing geographic date basis (confirmed_on and reporting cutoff). Custom ranges remain bounded to 366 inclusive dates; omitted dates retain the legacy 30-day period. (optional)
    to: 2013-10-20,
  } satisfies GetAdminDashboardInsightsRequest;

  try {
    const data = await api.getAdminDashboardInsights(body);
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
| **days** | `30`, `90` |  | [Optional] [Defaults to `30`] [Enum: 30, 90] |
| **dataset** | `TEST`, `DEMO` |  | [Optional] [Defaults to `undefined`] [Enum: TEST, DEMO] |
| **area** | `string` | Active-version PSGC code; omit for the Philippines. | [Optional] [Defaults to `undefined`] |
| **from** | `Date` | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Existing geographic date basis (confirmed_on and reporting cutoff). Custom ranges remain bounded to 366 inclusive dates; omitted dates retain the legacy 30-day period. | [Optional] [Defaults to `undefined`] |
| **to** | `Date` | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Existing geographic date basis (confirmed_on and reporting cutoff). Custom ranges remain bounded to 366 inclusive dates; omitted dates retain the legacy 30-day period. | [Optional] [Defaults to `undefined`] |

### Return type

[**AdminDashboardInsightsEnvelope**](AdminDashboardInsightsEnvelope.md)

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

