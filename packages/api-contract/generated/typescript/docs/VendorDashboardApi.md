# VendorDashboardApi

All URIs are relative to */api/v1*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**getVendorDashboardInsights**](VendorDashboardApi.md#getvendordashboardinsights) | **GET** /vendor/dashboard/insights |  |



## getVendorDashboardInsights

> VendorDashboardInsightsEnvelope getVendorDashboardInsights(days, from, to)



Any active Vendor member. Sections follow the fixed-role grants: orders.confirm, finance.view (peso values), scores.view_store, inventory.view and portal.disputes; a section without its grant is null. Unknown parameters return 422 DASHBOARD_FILTER_UNSUPPORTED.

### Example

```ts
import {
  Configuration,
  VendorDashboardApi,
} from '@materyalph/api-client-ts';
import type { GetVendorDashboardInsightsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorDashboardApi(config);

  const body = {
    // 7 | 30 | 90 (optional)
    days: 56,
    // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Order first confirmation for sales and volume, submitted_at for responses, and event created_at for the demand funnel and filed cases. Omitted days and dates mean all own order history through today. Stock, scores and work queues remain current; forecasting and basket mining retain independent 90-day history. (optional)
    from: 2013-10-20,
    // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Order first confirmation for sales and volume, submitted_at for responses, and event created_at for the demand funnel and filed cases. Omitted days and dates mean all own order history through today. Stock, scores and work queues remain current; forecasting and basket mining retain independent 90-day history. (optional)
    to: 2013-10-20,
  } satisfies GetVendorDashboardInsightsRequest;

  try {
    const data = await api.getVendorDashboardInsights(body);
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
| **days** | `7`, `30`, `90` |  | [Optional] [Defaults to `undefined`] [Enum: 7, 30, 90] |
| **from** | `Date` | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Order first confirmation for sales and volume, submitted_at for responses, and event created_at for the demand funnel and filed cases. Omitted days and dates mean all own order history through today. Stock, scores and work queues remain current; forecasting and basket mining retain independent 90-day history. | [Optional] [Defaults to `undefined`] |
| **to** | `Date` | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Order first confirmation for sales and volume, submitted_at for responses, and event created_at for the demand funnel and filed cases. Omitted days and dates mean all own order history through today. Stock, scores and work queues remain current; forecasting and basket mining retain independent 90-day history. | [Optional] [Defaults to `undefined`] |

### Return type

[**VendorDashboardInsightsEnvelope**](VendorDashboardInsightsEnvelope.md)

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

