# VendorFinanceReviewsApi

All URIs are relative to */api/v1*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**getVendorFinanceReviews**](VendorFinanceReviewsApi.md#getvendorfinancereviews) | **GET** /vendor/finance/reviews |  |



## getVendorFinanceReviews

> VendorFinanceReviewsEnvelope getVendorFinanceReviews()



Vendor Owner only (finance.view). FIN-10 review status for this store.

### Example

```ts
import {
  Configuration,
  VendorFinanceReviewsApi,
} from '@materyalph/api-client-ts';
import type { GetVendorFinanceReviewsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorFinanceReviewsApi(config);

  try {
    const data = await api.getVendorFinanceReviews();
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

[**VendorFinanceReviewsEnvelope**](VendorFinanceReviewsEnvelope.md)

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

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

