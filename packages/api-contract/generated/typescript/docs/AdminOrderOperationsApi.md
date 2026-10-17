# AdminOrderOperationsApi

All URIs are relative to */api/v1*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**confirmAdminReimbursement**](AdminOrderOperationsApi.md#confirmadminreimbursement) | **POST** /admin/order-operations/reimbursements/{reimbursementId}/confirm |  |
| [**getAdminOrderOperationsSummary**](AdminOrderOperationsApi.md#getadminorderoperationssummary) | **GET** /admin/order-operations/summary |  |
| [**listAdminCancellationRequests**](AdminOrderOperationsApi.md#listadmincancellationrequests) | **GET** /admin/order-operations/cancellation-requests |  |
| [**listAdminRefunds**](AdminOrderOperationsApi.md#listadminrefunds) | **GET** /admin/order-operations/refunds |  |
| [**listAdminReimbursements**](AdminOrderOperationsApi.md#listadminreimbursements) | **GET** /admin/order-operations/reimbursements |  |
| [**retryAdminRefund**](AdminOrderOperationsApi.md#retryadminrefund) | **POST** /admin/order-operations/refunds/{refundId}/retry |  |



## confirmAdminReimbursement

> AdminOrderActionResultEnvelope confirmAdminReimbursement(reimbursementId, adminReimbursementDecision)



reimbursements.decide. Reasoned confirmation of an evidenced reimbursement.

### Example

```ts
import {
  Configuration,
  AdminOrderOperationsApi,
} from '@materyalph/api-client-ts';
import type { ConfirmAdminReimbursementRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AdminOrderOperationsApi(config);

  const body = {
    // string
    reimbursementId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // AdminReimbursementDecision
    adminReimbursementDecision: ...,
  } satisfies ConfirmAdminReimbursementRequest;

  try {
    const data = await api.confirmAdminReimbursement(body);
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
| **reimbursementId** | `string` |  | [Defaults to `undefined`] |
| **adminReimbursementDecision** | [AdminReimbursementDecision](AdminReimbursementDecision.md) |  | |

### Return type

[**AdminOrderActionResultEnvelope**](AdminOrderActionResultEnvelope.md)

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


## getAdminOrderOperationsSummary

> AdminOrderOperationsSummaryEnvelope getAdminOrderOperationsSummary()



orders.operations.view. All-record refund and order-linked reimbursement totals, independent of list filters, plus counts of failed and pending refunds, pending reimbursements, open cancellation requests and recent NFR events.

### Example

```ts
import {
  Configuration,
  AdminOrderOperationsApi,
} from '@materyalph/api-client-ts';
import type { GetAdminOrderOperationsSummaryRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AdminOrderOperationsApi(config);

  try {
    const data = await api.getAdminOrderOperationsSummary();
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

[**AdminOrderOperationsSummaryEnvelope**](AdminOrderOperationsSummaryEnvelope.md)

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


## listAdminCancellationRequests

> AdminCancellationRequestListEnvelope listAdminCancellationRequests(from, to)



orders.operations.view. Open Buyer requests awaiting the Vendor, earliest deadline first.

### Example

```ts
import {
  Configuration,
  AdminOrderOperationsApi,
} from '@materyalph/api-client-ts';
import type { ListAdminCancellationRequestsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AdminOrderOperationsApi(config);

  const body = {
    // Date | Inclusive Asia/Manila calendar date; omitted boundary unrestricted. Open cancellation request created_at; existing 100-record bound retained. (optional)
    from: 2013-10-20,
    // Date | Inclusive Asia/Manila calendar date; omitted boundary unrestricted. Open cancellation request created_at; existing 100-record bound retained. (optional)
    to: 2013-10-20,
  } satisfies ListAdminCancellationRequestsRequest;

  try {
    const data = await api.listAdminCancellationRequests(body);
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
| **from** | `Date` | Inclusive Asia/Manila calendar date; omitted boundary unrestricted. Open cancellation request created_at; existing 100-record bound retained. | [Optional] [Defaults to `undefined`] |
| **to** | `Date` | Inclusive Asia/Manila calendar date; omitted boundary unrestricted. Open cancellation request created_at; existing 100-record bound retained. | [Optional] [Defaults to `undefined`] |

### Return type

[**AdminCancellationRequestListEnvelope**](AdminCancellationRequestListEnvelope.md)

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


## listAdminRefunds

> AdminRefundListEnvelope listAdminRefunds(state, trigger, page, from, to)



orders.operations.view. Refund instructions, failures first. Admins never hold or disburse funds.

### Example

```ts
import {
  Configuration,
  AdminOrderOperationsApi,
} from '@materyalph/api-client-ts';
import type { ListAdminRefundsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AdminOrderOperationsApi(config);

  const body = {
    // 'REFUND_PENDING' | 'REFUNDED' | 'REFUND_FAILED' (optional)
    state: state_example,
    // 'CANCELLATION' | 'DISPUTE_CONCLUSION' | 'TECHNICAL_COMPENSATION' | 'FEE_CREDIT' (optional)
    trigger: trigger_example,
    // number (optional)
    page: 56,
    // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Refund requested_at with created_at fallback. (optional)
    from: 2013-10-20,
    // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Refund requested_at with created_at fallback. (optional)
    to: 2013-10-20,
  } satisfies ListAdminRefundsRequest;

  try {
    const data = await api.listAdminRefunds(body);
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
| **state** | `REFUND_PENDING`, `REFUNDED`, `REFUND_FAILED` |  | [Optional] [Defaults to `undefined`] [Enum: REFUND_PENDING, REFUNDED, REFUND_FAILED] |
| **trigger** | `CANCELLATION`, `DISPUTE_CONCLUSION`, `TECHNICAL_COMPENSATION`, `FEE_CREDIT` |  | [Optional] [Defaults to `undefined`] [Enum: CANCELLATION, DISPUTE_CONCLUSION, TECHNICAL_COMPENSATION, FEE_CREDIT] |
| **page** | `number` |  | [Optional] [Defaults to `undefined`] |
| **from** | `Date` | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Refund requested_at with created_at fallback. | [Optional] [Defaults to `undefined`] |
| **to** | `Date` | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Refund requested_at with created_at fallback. | [Optional] [Defaults to `undefined`] |

### Return type

[**AdminRefundListEnvelope**](AdminRefundListEnvelope.md)

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


## listAdminReimbursements

> AdminReimbursementListEnvelope listAdminReimbursements(from, to)



orders.operations.view. Vendor cash reimbursements of cancelled orders.

### Example

```ts
import {
  Configuration,
  AdminOrderOperationsApi,
} from '@materyalph/api-client-ts';
import type { ListAdminReimbursementsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AdminOrderOperationsApi(config);

  const body = {
    // Date | Inclusive Asia/Manila calendar date; omitted boundary unrestricted. Reimbursement instruction created_at; existing 100-record bound retained. (optional)
    from: 2013-10-20,
    // Date | Inclusive Asia/Manila calendar date; omitted boundary unrestricted. Reimbursement instruction created_at; existing 100-record bound retained. (optional)
    to: 2013-10-20,
  } satisfies ListAdminReimbursementsRequest;

  try {
    const data = await api.listAdminReimbursements(body);
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
| **from** | `Date` | Inclusive Asia/Manila calendar date; omitted boundary unrestricted. Reimbursement instruction created_at; existing 100-record bound retained. | [Optional] [Defaults to `undefined`] |
| **to** | `Date` | Inclusive Asia/Manila calendar date; omitted boundary unrestricted. Reimbursement instruction created_at; existing 100-record bound retained. | [Optional] [Defaults to `undefined`] |

### Return type

[**AdminReimbursementListEnvelope**](AdminReimbursementListEnvelope.md)

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


## retryAdminRefund

> AdminOrderActionResultEnvelope retryAdminRefund(refundId, idempotencyKey)



refunds.retry. Re-send a failed instruction to the original payment only.

### Example

```ts
import {
  Configuration,
  AdminOrderOperationsApi,
} from '@materyalph/api-client-ts';
import type { RetryAdminRefundRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AdminOrderOperationsApi(config);

  const body = {
    // string
    refundId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    idempotencyKey: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies RetryAdminRefundRequest;

  try {
    const data = await api.retryAdminRefund(body);
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
| **refundId** | `string` |  | [Defaults to `undefined`] |
| **idempotencyKey** | `string` |  | [Defaults to `undefined`] |

### Return type

[**AdminOrderActionResultEnvelope**](AdminOrderActionResultEnvelope.md)

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
| **409** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

