# PublicFinanceApi

All URIs are relative to */api/v1*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**getPublicCommissionPolicy**](PublicFinanceApi.md#getpubliccommissionpolicy) | **GET** /commission-policy |  |



## getPublicCommissionPolicy

> PublicCommissionPolicyEnvelope getPublicCommissionPolicy(policy)



Public, no-store projection of the current and next effective commercial policy and rendered TEST terms. No Admin reason, staff identity, acceptance or delivery data. Resolved by timestamp, independently of scheduler execution.

### Example

```ts
import {
  Configuration,
  PublicFinanceApi,
} from '@materyalph/api-client-ts';
import type { GetPublicCommissionPolicyRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const api = new PublicFinanceApi();

  const body = {
    // string (optional)
    policy: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies GetPublicCommissionPolicyRequest;

  try {
    const data = await api.getPublicCommissionPolicy(body);
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
| **policy** | `string` |  | [Optional] [Defaults to `undefined`] |

### Return type

[**PublicCommissionPolicyEnvelope**](PublicCommissionPolicyEnvelope.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Public policy and optional selected historical version. |  -  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

