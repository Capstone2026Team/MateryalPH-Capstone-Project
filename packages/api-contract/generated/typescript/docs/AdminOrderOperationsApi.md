# AdminOrderOperationsApi

All URIs are relative to */api/v1*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**confirmAdminReimbursement**](AdminOrderOperationsApi.md#confirmadminreimbursement) | **POST** /admin/order-operations/reimbursements/{reimbursementId}/confirm |  |
| [**getAdminAuditOrder**](AdminOrderOperationsApi.md#getadminauditorder) | **GET** /admin/order-operations/orders/{orderId} |  |
| [**getAdminAuditOrderFile**](AdminOrderOperationsApi.md#getadminauditorderfile) | **GET** /admin/order-operations/orders/{orderId}/files/{fileId} |  |
| [**getAdminOrderOperationsSummary**](AdminOrderOperationsApi.md#getadminorderoperationssummary) | **GET** /admin/order-operations/summary |  |
| [**listAdminAuditOrders**](AdminOrderOperationsApi.md#listadminauditorders) | **GET** /admin/order-operations/orders |  |
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


## getAdminAuditOrder

> OrderDetailEnvelope getAdminAuditOrder(orderId, caseId)



Audited read-only order detail with immutable commercial terms, all recorded payment attempts, cash records, fulfillment evidence, cancellation decision, refunds and state history. Requires orders.operations.view; when case_id is provided requires disputes.view and an existing matching case/order relationship. No inventory, Buyer budget, staff contacts, provider identifiers or checkout URLs. No actions or transitions.

### Example

```ts
import {
  Configuration,
  AdminOrderOperationsApi,
} from '@materyalph/api-client-ts';
import type { GetAdminAuditOrderRequest } from '@materyalph/api-client-ts';

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
    orderId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string (optional)
    caseId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies GetAdminAuditOrderRequest;

  try {
    const data = await api.getAdminAuditOrder(body);
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
| **orderId** | `string` |  | [Defaults to `undefined`] |
| **caseId** | `string` |  | [Optional] [Defaults to `undefined`] |

### Return type

[**OrderDetailEnvelope**](OrderDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Read-only detail; available_actions is empty and payment and fulfillment actions are unavailable. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **404** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getAdminAuditOrderFile

> Blob getAdminAuditOrderFile(orderId, fileId, caseId)



Audited private evidence read. Reauthorizes orders.operations.view or disputes.view plus matching case_id on every request. Only CLEAN private files referenced by this order are available; no public storage URL is returned.

### Example

```ts
import {
  Configuration,
  AdminOrderOperationsApi,
} from '@materyalph/api-client-ts';
import type { GetAdminAuditOrderFileRequest } from '@materyalph/api-client-ts';

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
    orderId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    fileId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string (optional)
    caseId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies GetAdminAuditOrderFileRequest;

  try {
    const data = await api.getAdminAuditOrderFile(body);
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
| **orderId** | `string` |  | [Defaults to `undefined`] |
| **fileId** | `string` |  | [Defaults to `undefined`] |
| **caseId** | `string` |  | [Optional] [Defaults to `undefined`] |

### Return type

**Blob**

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/octet-stream`, `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Private evidence stream, never cached publicly. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **404** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **503** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

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


## listAdminAuditOrders

> OrderListEnvelope listAdminAuditOrders(q, page, orderState, paymentState, refundState, paymentMethod, from, to)



Read-only platform order history; requires orders.operations.view. No expiry, reconciliation or commercial mutation runs on a read. Buyer names and public store names only in the paginated list.

### Example

```ts
import {
  Configuration,
  AdminOrderOperationsApi,
} from '@materyalph/api-client-ts';
import type { ListAdminAuditOrdersRequest } from '@materyalph/api-client-ts';

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
    // string | Order reference or Buyer or public store name. (optional)
    q: q_example,
    // number (optional)
    page: 56,
    // OrderState (optional)
    orderState: ...,
    // OrderPaymentState (optional)
    paymentState: ...,
    // 'NOT_REQUESTED' | 'REFUND_PENDING' | 'PARTIALLY_REFUNDED' | 'REFUNDED' | 'REFUND_FAILED' (optional)
    refundState: refundState_example,
    // 'ONLINE' | 'CASH_ON_DELIVERY' | 'IN_STORE' (optional)
    paymentMethod: paymentMethod_example,
    // Date | Inclusive submitted date in Asia/Manila; omit for all history. (optional)
    from: 2013-10-20,
    // Date | Inclusive submitted date in Asia/Manila; omit for all history. (optional)
    to: 2013-10-20,
  } satisfies ListAdminAuditOrdersRequest;

  try {
    const data = await api.listAdminAuditOrders(body);
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
| **q** | `string` | Order reference or Buyer or public store name. | [Optional] [Defaults to `undefined`] |
| **page** | `number` |  | [Optional] [Defaults to `undefined`] |
| **orderState** | `OrderState` |  | [Optional] [Defaults to `undefined`] [Enum: AWAITING_VENDOR_CONFIRMATION, AWAITING_BUYER_APPROVAL, AWAITING_NRPC_ACCEPTANCE, AWAITING_PAYMENT, CONFIRMED, PROCESSING, READY_FOR_PICKUP, OUT_FOR_DELIVERY, DELIVERED, PICKED_UP, COMPLETED, CANCELLATION_REQUESTED, DECLINED, EXPIRED, CANCELLED, DISPUTED] |
| **paymentState** | `OrderPaymentState` |  | [Optional] [Defaults to `undefined`] [Enum: NOT_REQUIRED, PENDING, PAID, FAILED, EXPIRED] |
| **refundState** | `NOT_REQUESTED`, `REFUND_PENDING`, `PARTIALLY_REFUNDED`, `REFUNDED`, `REFUND_FAILED` |  | [Optional] [Defaults to `undefined`] [Enum: NOT_REQUESTED, REFUND_PENDING, PARTIALLY_REFUNDED, REFUNDED, REFUND_FAILED] |
| **paymentMethod** | `ONLINE`, `CASH_ON_DELIVERY`, `IN_STORE` |  | [Optional] [Defaults to `undefined`] [Enum: ONLINE, CASH_ON_DELIVERY, IN_STORE] |
| **from** | `Date` | Inclusive submitted date in Asia/Manila; omit for all history. | [Optional] [Defaults to `undefined`] |
| **to** | `Date` | Inclusive submitted date in Asia/Manila; omit for all history. | [Optional] [Defaults to `undefined`] |

### Return type

[**OrderListEnvelope**](OrderListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Paginated orders, including all five state families and recorded commercial amounts. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

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

> AdminReimbursementListEnvelope listAdminReimbursements(page, from, to)



orders.operations.view. Paginated Vendor cash reimbursement instructions and confirmed records, including cancellation and dispute remedies.

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
    // number (optional)
    page: 56,
    // Date | Inclusive Asia/Manila calendar date; omitted boundary unrestricted. Reimbursement instruction created_at. (optional)
    from: 2013-10-20,
    // Date | Inclusive Asia/Manila calendar date; omitted boundary unrestricted. Reimbursement instruction created_at. (optional)
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
| **page** | `number` |  | [Optional] [Defaults to `undefined`] |
| **from** | `Date` | Inclusive Asia/Manila calendar date; omitted boundary unrestricted. Reimbursement instruction created_at. | [Optional] [Defaults to `undefined`] |
| **to** | `Date` | Inclusive Asia/Manila calendar date; omitted boundary unrestricted. Reimbursement instruction created_at. | [Optional] [Defaults to `undefined`] |

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

