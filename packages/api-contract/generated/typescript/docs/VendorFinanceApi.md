# VendorFinanceApi

All URIs are relative to */api/v1*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**approveVendorOnlineBalance**](VendorFinanceApi.md#approvevendoronlinebalance) | **POST** /vendor/orders/{orderId}/online-balance/approve |  |
| [**confirmVendorHandoverCash**](VendorFinanceApi.md#confirmvendorhandovercash) | **POST** /vendor/orders/{orderId}/physical-payments/handover-confirmation |  |
| [**exportVendorTransactions**](VendorFinanceApi.md#exportvendortransactions) | **GET** /vendor/finance/transactions/export |  |
| [**getVendorCommissionMonitoring**](VendorFinanceApi.md#getvendorcommissionmonitoring) | **GET** /vendor/finance/commissions |  |
| [**getVendorEarnings**](VendorFinanceApi.md#getvendorearnings) | **GET** /vendor/finance/earnings |  |
| [**getVendorFeePayment**](VendorFinanceApi.md#getvendorfeepayment) | **GET** /vendor/finance/payments/{paymentId} |  |
| [**getVendorFeeStatement**](VendorFinanceApi.md#getvendorfeestatement) | **GET** /vendor/finance/statements/{statementId} |  |
| [**getVendorFinanceOverview**](VendorFinanceApi.md#getvendorfinanceoverview) | **GET** /vendor/finance |  |
| [**listVendorTransactions**](VendorFinanceApi.md#listvendortransactions) | **GET** /vendor/finance/transactions |  |
| [**payVendorFeeStatement**](VendorFinanceApi.md#payvendorfeestatement) | **POST** /vendor/finance/statements/{statementId}/payments |  |
| [**recordVendorPhysicalPayment**](VendorFinanceApi.md#recordvendorphysicalpayment) | **POST** /vendor/orders/{orderId}/physical-payments |  |
| [**refreshVendorFeePayment**](VendorFinanceApi.md#refreshvendorfeepayment) | **POST** /vendor/finance/payments/{paymentId}/refresh |  |
| [**revealVendorTin**](VendorFinanceApi.md#revealvendortin) | **POST** /vendor/tax-profile/tin/reveal |  |
| [**updateVendorPhysicalPayments**](VendorFinanceApi.md#updatevendorphysicalpayments) | **PUT** /vendor/finance/physical-payments |  |



## approveVendorOnlineBalance

> FinanceActionResultEnvelope approveVendorOnlineBalance(orderId, idempotencyKey)



Owner, Manager or Store Staff approve paying the uncollected physical balance online (ORDER_BALANCE_PAYMENT).

### Example

```ts
import {
  Configuration,
  VendorFinanceApi,
} from '@materyalph/api-client-ts';
import type { ApproveVendorOnlineBalanceRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorFinanceApi(config);

  const body = {
    // string
    orderId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    idempotencyKey: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies ApproveVendorOnlineBalanceRequest;

  try {
    const data = await api.approveVendorOnlineBalance(body);
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
| **idempotencyKey** | `string` |  | [Defaults to `undefined`] |

### Return type

[**FinanceActionResultEnvelope**](FinanceActionResultEnvelope.md)

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

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## confirmVendorHandoverCash

> PhysicalPaymentSummaryEnvelope confirmVendorHandoverCash(orderId, idempotencyKey, file)



Owner, Store Manager or Store Staff (payments.record_physical) confirm the cash Fulfillment Staff reported at Delivered or Picked up. Records one COLLECTION for the reported amount capped at the outstanding balance, with the handover photo (or the attached receipt) as evidence and the handover time as the received time. Once per handover; 409 HANDOVER_CASH_NOT_PENDING or PHYSICAL_PAYMENT_NOT_OPEN when nothing waits.

### Example

```ts
import {
  Configuration,
  VendorFinanceApi,
} from '@materyalph/api-client-ts';
import type { ConfirmVendorHandoverCashRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorFinanceApi(config);

  const body = {
    // string
    orderId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    idempotencyKey: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // Blob | Optional receipt (JPG, PNG, WebP or PDF up to 10 MB). Required only when the handover has no photo; otherwise the handover photo is the evidence. (optional)
    file: BINARY_DATA_HERE,
  } satisfies ConfirmVendorHandoverCashRequest;

  try {
    const data = await api.confirmVendorHandoverCash(body);
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
| **idempotencyKey** | `string` |  | [Defaults to `undefined`] |
| **file** | `Blob` | Optional receipt (JPG, PNG, WebP or PDF up to 10 MB). Required only when the handover has no photo; otherwise the handover photo is the evidence. | [Optional] [Defaults to `undefined`] |

### Return type

[**PhysicalPaymentSummaryEnvelope**](PhysicalPaymentSummaryEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `multipart/form-data`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **201** | Recorded, or an idempotent replay. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **404** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **409** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## exportVendorTransactions

> string exportVendorTransactions(tab, status, from, to)



Owner-only audited CSV export: Internal Operational Report — Not a Tax Invoice.

### Example

```ts
import {
  Configuration,
  VendorFinanceApi,
} from '@materyalph/api-client-ts';
import type { ExportVendorTransactionsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorFinanceApi(config);

  const body = {
    // 'PAYMENTS' | 'PHYSICAL' | 'REMITTANCES' | 'STATEMENTS' | 'REFUNDS' | 'TAX_DOCUMENTS'
    tab: tab_example,
    // 'PAID' | 'PAID_PARTIALLY_REFUNDED' | 'PAID_REFUND_PENDING' | 'PAID_REFUNDED' | 'PAID_REFUND_FAILED' | 'PENDING' | 'FAILED' | 'EXPIRED' | 'LATE_CAPTURE' | 'PHYSICAL_COLLECTED' | 'PHYSICAL_PARTIAL' | 'PHYSICAL_TO_RECORD' | 'PHYSICAL_AWAITING' | 'PHYSICAL_RELEASED' | Payments tab only; ignored by every other tab. Each value matches the status badge a Payments row shows. PAID has no refund activity; LATE_CAPTURE covers every late-captured payment awaiting or after its refund; PENDING is any attempt not yet settled. PHYSICAL_* values select Cash on Delivery / In-Store obligations: COLLECTED (nothing remains), PARTIAL (part recorded), TO_RECORD (delivered or picked up, no cash recorded yet), AWAITING (before handover), RELEASED (cancelled unpaid). (optional)
    status: status_example,
    // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Same timestamp and filters as the selected Transaction History tab; filtered before the existing 5000-row export bound. (optional)
    from: 2013-10-20,
    // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Same timestamp and filters as the selected Transaction History tab; filtered before the existing 5000-row export bound. (optional)
    to: 2013-10-20,
  } satisfies ExportVendorTransactionsRequest;

  try {
    const data = await api.exportVendorTransactions(body);
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
| **tab** | `PAYMENTS`, `PHYSICAL`, `REMITTANCES`, `STATEMENTS`, `REFUNDS`, `TAX_DOCUMENTS` |  | [Defaults to `undefined`] [Enum: PAYMENTS, PHYSICAL, REMITTANCES, STATEMENTS, REFUNDS, TAX_DOCUMENTS] |
| **status** | `PAID`, `PAID_PARTIALLY_REFUNDED`, `PAID_REFUND_PENDING`, `PAID_REFUNDED`, `PAID_REFUND_FAILED`, `PENDING`, `FAILED`, `EXPIRED`, `LATE_CAPTURE`, `PHYSICAL_COLLECTED`, `PHYSICAL_PARTIAL`, `PHYSICAL_TO_RECORD`, `PHYSICAL_AWAITING`, `PHYSICAL_RELEASED` | Payments tab only; ignored by every other tab. Each value matches the status badge a Payments row shows. PAID has no refund activity; LATE_CAPTURE covers every late-captured payment awaiting or after its refund; PENDING is any attempt not yet settled. PHYSICAL_* values select Cash on Delivery / In-Store obligations: COLLECTED (nothing remains), PARTIAL (part recorded), TO_RECORD (delivered or picked up, no cash recorded yet), AWAITING (before handover), RELEASED (cancelled unpaid). | [Optional] [Defaults to `undefined`] [Enum: PAID, PAID_PARTIALLY_REFUNDED, PAID_REFUND_PENDING, PAID_REFUNDED, PAID_REFUND_FAILED, PENDING, FAILED, EXPIRED, LATE_CAPTURE, PHYSICAL_COLLECTED, PHYSICAL_PARTIAL, PHYSICAL_TO_RECORD, PHYSICAL_AWAITING, PHYSICAL_RELEASED] |
| **from** | `Date` | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Same timestamp and filters as the selected Transaction History tab; filtered before the existing 5000-row export bound. | [Optional] [Defaults to `undefined`] |
| **to** | `Date` | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Same timestamp and filters as the selected Transaction History tab; filtered before the existing 5000-row export bound. | [Optional] [Defaults to `undefined`] |

### Return type

**string**

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `text/csv`, `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | CSV export. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getVendorCommissionMonitoring

> VendorCommissionMonitoringEnvelope getVendorCommissionMonitoring(page)



Owner-only all-time commission monitoring with current and next policy, estimated and earned fees, approved credits, unbilled fees, draft bills, issued outstanding and overdue debt, verified allocations and successful fee refunds. Assessments are paginated and retain their original basis and percentage. Cash and earnings are separate; no wallet balance is represented.

### Example

```ts
import {
  Configuration,
  VendorFinanceApi,
} from '@materyalph/api-client-ts';
import type { GetVendorCommissionMonitoringRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorFinanceApi(config);

  const body = {
    // number (optional)
    page: 56,
  } satisfies GetVendorCommissionMonitoringRequest;

  try {
    const data = await api.getVendorCommissionMonitoring(body);
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
| **page** | `number` |  | [Optional] [Defaults to `1`] |

### Return type

[**VendorCommissionMonitoringEnvelope**](VendorCommissionMonitoringEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Store-scoped monitoring and paginated assessment records. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getVendorEarnings

> VendorEarningsEnvelope getVendorEarnings(from, to)



Owner-only FIN-11 Earnings with separate sales, confirmed online refunds, net online collections, charges, simulated CWT and commission. Confirmed refunds adjust the original payment and assessment date buckets; pending and failed refunds leave collections unchanged. Posted provider charges, CWT and FIN-04A thresholds remain unchanged; estimated remittance cash deducts confirmed refunds without deducting refunds already included in the assessment twice.

### Example

```ts
import {
  Configuration,
  VendorFinanceApi,
} from '@materyalph/api-client-ts';
import type { GetVendorEarningsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorFinanceApi(config);

  const body = {
    // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Commercial sales use order accepted_at; online collections paid_at; physical collections recorded_at; remittances created_at; commission earned_at and approved credit approved_at; estimates created_at; unpaid statements issued_on. Taxpayer thresholds are never recalculated by this view. (optional)
    from: 2013-10-20,
    // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Commercial sales use order accepted_at; online collections paid_at; physical collections recorded_at; remittances created_at; commission earned_at and approved credit approved_at; estimates created_at; unpaid statements issued_on. Taxpayer thresholds are never recalculated by this view. (optional)
    to: 2013-10-20,
  } satisfies GetVendorEarningsRequest;

  try {
    const data = await api.getVendorEarnings(body);
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
| **from** | `Date` | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Commercial sales use order accepted_at; online collections paid_at; physical collections recorded_at; remittances created_at; commission earned_at and approved credit approved_at; estimates created_at; unpaid statements issued_on. Taxpayer thresholds are never recalculated by this view. | [Optional] [Defaults to `undefined`] |
| **to** | `Date` | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Commercial sales use order accepted_at; online collections paid_at; physical collections recorded_at; remittances created_at; commission earned_at and approved credit approved_at; estimates created_at; unpaid statements issued_on. Taxpayer thresholds are never recalculated by this view. | [Optional] [Defaults to `undefined`] |

### Return type

[**VendorEarningsEnvelope**](VendorEarningsEnvelope.md)

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


## getVendorFeePayment

> PaymentAttemptEnvelope getVendorFeePayment(paymentId)



Owner-only platform-fee payment attempt.

### Example

```ts
import {
  Configuration,
  VendorFinanceApi,
} from '@materyalph/api-client-ts';
import type { GetVendorFeePaymentRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorFinanceApi(config);

  const body = {
    // string
    paymentId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies GetVendorFeePaymentRequest;

  try {
    const data = await api.getVendorFeePayment(body);
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
| **paymentId** | `string` |  | [Defaults to `undefined`] |

### Return type

[**PaymentAttemptEnvelope**](PaymentAttemptEnvelope.md)

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

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getVendorFeeStatement

> FeeStatementDetailEnvelope getVendorFeeStatement(statementId)



Owner-only issued commission statement with lines, payments and payable channels (platform absorbs its bill processing charge).

### Example

```ts
import {
  Configuration,
  VendorFinanceApi,
} from '@materyalph/api-client-ts';
import type { GetVendorFeeStatementRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorFinanceApi(config);

  const body = {
    // string
    statementId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies GetVendorFeeStatementRequest;

  try {
    const data = await api.getVendorFeeStatement(body);
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
| **statementId** | `string` |  | [Defaults to `undefined`] |

### Return type

[**FeeStatementDetailEnvelope**](FeeStatementDetailEnvelope.md)

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

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getVendorFinanceOverview

> VendorFinanceOverviewEnvelope getVendorFinanceOverview()



Owner-only. Separate Xendit connection, Vendor Tax Profile summary, withholding arrangement (Production assignment unconfirmed), FIN-04A threshold panel, Commission Terms, online channels, physical payments and refund capability. Every simulated figure is DEMO.

### Example

```ts
import {
  Configuration,
  VendorFinanceApi,
} from '@materyalph/api-client-ts';
import type { GetVendorFinanceOverviewRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorFinanceApi(config);

  try {
    const data = await api.getVendorFinanceOverview();
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

[**VendorFinanceOverviewEnvelope**](VendorFinanceOverviewEnvelope.md)

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


## listVendorTransactions

> FinanceTransactionListEnvelope listVendorTransactions(tab, page, status, from, to)



Owner-only read-only Transaction History (former Wallet label). No balance, wallet or escrow.

### Example

```ts
import {
  Configuration,
  VendorFinanceApi,
} from '@materyalph/api-client-ts';
import type { ListVendorTransactionsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorFinanceApi(config);

  const body = {
    // 'PAYMENTS' | 'PHYSICAL' | 'REMITTANCES' | 'STATEMENTS' | 'REFUNDS' | 'TAX_DOCUMENTS' (optional)
    tab: tab_example,
    // number (optional)
    page: 56,
    // 'PAID' | 'PAID_PARTIALLY_REFUNDED' | 'PAID_REFUND_PENDING' | 'PAID_REFUNDED' | 'PAID_REFUND_FAILED' | 'PENDING' | 'FAILED' | 'EXPIRED' | 'LATE_CAPTURE' | 'PHYSICAL_COLLECTED' | 'PHYSICAL_PARTIAL' | 'PHYSICAL_TO_RECORD' | 'PHYSICAL_AWAITING' | 'PHYSICAL_RELEASED' | Payments tab only; ignored by every other tab. Each value matches the status badge a Payments row shows. PAID has no refund activity; LATE_CAPTURE covers every late-captured payment awaiting or after its refund; PENDING is any attempt not yet settled. PHYSICAL_* values select Cash on Delivery / In-Store obligations: COLLECTED (nothing remains), PARTIAL (part recorded), TO_RECORD (delivered or picked up, no cash recorded yet), AWAITING (before handover), RELEASED (cancelled unpaid). (optional)
    status: status_example,
    // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. PAYMENTS paid_at with created_at fallback; PHYSICAL recorded_at; REMITTANCES created_at; STATEMENTS issued_on; REFUNDS created_at; TAX_DOCUMENTS period_end. (optional)
    from: 2013-10-20,
    // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. PAYMENTS paid_at with created_at fallback; PHYSICAL recorded_at; REMITTANCES created_at; STATEMENTS issued_on; REFUNDS created_at; TAX_DOCUMENTS period_end. (optional)
    to: 2013-10-20,
  } satisfies ListVendorTransactionsRequest;

  try {
    const data = await api.listVendorTransactions(body);
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
| **tab** | `PAYMENTS`, `PHYSICAL`, `REMITTANCES`, `STATEMENTS`, `REFUNDS`, `TAX_DOCUMENTS` |  | [Optional] [Defaults to `undefined`] [Enum: PAYMENTS, PHYSICAL, REMITTANCES, STATEMENTS, REFUNDS, TAX_DOCUMENTS] |
| **page** | `number` |  | [Optional] [Defaults to `undefined`] |
| **status** | `PAID`, `PAID_PARTIALLY_REFUNDED`, `PAID_REFUND_PENDING`, `PAID_REFUNDED`, `PAID_REFUND_FAILED`, `PENDING`, `FAILED`, `EXPIRED`, `LATE_CAPTURE`, `PHYSICAL_COLLECTED`, `PHYSICAL_PARTIAL`, `PHYSICAL_TO_RECORD`, `PHYSICAL_AWAITING`, `PHYSICAL_RELEASED` | Payments tab only; ignored by every other tab. Each value matches the status badge a Payments row shows. PAID has no refund activity; LATE_CAPTURE covers every late-captured payment awaiting or after its refund; PENDING is any attempt not yet settled. PHYSICAL_* values select Cash on Delivery / In-Store obligations: COLLECTED (nothing remains), PARTIAL (part recorded), TO_RECORD (delivered or picked up, no cash recorded yet), AWAITING (before handover), RELEASED (cancelled unpaid). | [Optional] [Defaults to `undefined`] [Enum: PAID, PAID_PARTIALLY_REFUNDED, PAID_REFUND_PENDING, PAID_REFUNDED, PAID_REFUND_FAILED, PENDING, FAILED, EXPIRED, LATE_CAPTURE, PHYSICAL_COLLECTED, PHYSICAL_PARTIAL, PHYSICAL_TO_RECORD, PHYSICAL_AWAITING, PHYSICAL_RELEASED] |
| **from** | `Date` | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. PAYMENTS paid_at with created_at fallback; PHYSICAL recorded_at; REMITTANCES created_at; STATEMENTS issued_on; REFUNDS created_at; TAX_DOCUMENTS period_end. | [Optional] [Defaults to `undefined`] |
| **to** | `Date` | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. PAYMENTS paid_at with created_at fallback; PHYSICAL recorded_at; REMITTANCES created_at; STATEMENTS issued_on; REFUNDS created_at; TAX_DOCUMENTS period_end. | [Optional] [Defaults to `undefined`] |

### Return type

[**FinanceTransactionListEnvelope**](FinanceTransactionListEnvelope.md)

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


## payVendorFeeStatement

> PaymentAttemptEnvelope payVendorFeeStatement(statementId, idempotencyKey, statementPaymentRequest)



Owner-only PLATFORM_FEE_PAYMENT to the platform TEST account, 45-minute attempt, optional installment amount. No auto debit or split. Open attempts are reconciled first.

### Example

```ts
import {
  Configuration,
  VendorFinanceApi,
} from '@materyalph/api-client-ts';
import type { PayVendorFeeStatementRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorFinanceApi(config);

  const body = {
    // string
    statementId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    idempotencyKey: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // StatementPaymentRequest
    statementPaymentRequest: ...,
  } satisfies PayVendorFeeStatementRequest;

  try {
    const data = await api.payVendorFeeStatement(body);
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
| **statementId** | `string` |  | [Defaults to `undefined`] |
| **idempotencyKey** | `string` |  | [Defaults to `undefined`] |
| **statementPaymentRequest** | [StatementPaymentRequest](StatementPaymentRequest.md) |  | |

### Return type

[**PaymentAttemptEnvelope**](PaymentAttemptEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Idempotent replay. |  -  |
| **201** | Authorized result. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **404** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **409** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **503** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## recordVendorPhysicalPayment

> PhysicalPaymentSummaryEnvelope recordVendorPhysicalPayment(orderId, idempotencyKey, amountCentavos, file, receivedAt, note)



Owner, Store Manager or Store Staff (payments.record_physical) record cash received with private evidence. Partial collection leaves an outstanding balance; never above it; never an online success.

### Example

```ts
import {
  Configuration,
  VendorFinanceApi,
} from '@materyalph/api-client-ts';
import type { RecordVendorPhysicalPaymentRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorFinanceApi(config);

  const body = {
    // string
    orderId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    idempotencyKey: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // number
    amountCentavos: 56,
    // Blob | Private receipt evidence: JPG, PNG, WebP or PDF up to 10 MB; scanned fail-closed.
    file: BINARY_DATA_HERE,
    // Date (optional)
    receivedAt: 2013-10-20T19:20:30+01:00,
    // string (optional)
    note: note_example,
  } satisfies RecordVendorPhysicalPaymentRequest;

  try {
    const data = await api.recordVendorPhysicalPayment(body);
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
| **idempotencyKey** | `string` |  | [Defaults to `undefined`] |
| **amountCentavos** | `number` |  | [Defaults to `undefined`] |
| **file** | `Blob` | Private receipt evidence: JPG, PNG, WebP or PDF up to 10 MB; scanned fail-closed. | [Defaults to `undefined`] |
| **receivedAt** | `Date` |  | [Optional] [Defaults to `undefined`] |
| **note** | `string` |  | [Optional] [Defaults to `undefined`] |

### Return type

[**PhysicalPaymentSummaryEnvelope**](PhysicalPaymentSummaryEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `multipart/form-data`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Idempotent replay. |  -  |
| **201** | Authorized result. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **404** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **409** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **503** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## refreshVendorFeePayment

> PaymentAttemptEnvelope refreshVendorFeePayment(paymentId)



Owner-only authoritative status check.

### Example

```ts
import {
  Configuration,
  VendorFinanceApi,
} from '@materyalph/api-client-ts';
import type { RefreshVendorFeePaymentRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorFinanceApi(config);

  const body = {
    // string
    paymentId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies RefreshVendorFeePaymentRequest;

  try {
    const data = await api.refreshVendorFeePayment(body);
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
| **paymentId** | `string` |  | [Defaults to `undefined`] |

### Return type

[**PaymentAttemptEnvelope**](PaymentAttemptEnvelope.md)

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

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## revealVendorTin

> VendorTinRevealEnvelope revealVendorTin()



Owner-only. Returns the store\&#39;s own full TIN and branch code on demand so the Owner can unmask the masked value shown in the Vendor Tax Profile summary and Tax registration. The response is never cached, each reveal is audited without recording the number, and the number is never returned to a Manager, staff member, Buyer, another Vendor or public surface.

### Example

```ts
import {
  Configuration,
  VendorFinanceApi,
} from '@materyalph/api-client-ts';
import type { RevealVendorTinRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorFinanceApi(config);

  try {
    const data = await api.revealVendorTin();
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

[**VendorTinRevealEnvelope**](VendorTinRevealEnvelope.md)

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

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## updateVendorPhysicalPayments

> PhysicalPaymentSettingsEnvelope updateVendorPhysicalPayments(physicalPaymentSettingsUpdate)



Owner-only. Enable Cash on Delivery (Site Delivery) or In-Store Payment (Self-Pickup) for future orders; both default off. lock_version 0 before the first save.

### Example

```ts
import {
  Configuration,
  VendorFinanceApi,
} from '@materyalph/api-client-ts';
import type { UpdateVendorPhysicalPaymentsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorFinanceApi(config);

  const body = {
    // PhysicalPaymentSettingsUpdate
    physicalPaymentSettingsUpdate: ...,
  } satisfies UpdateVendorPhysicalPaymentsRequest;

  try {
    const data = await api.updateVendorPhysicalPayments(body);
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
| **physicalPaymentSettingsUpdate** | [PhysicalPaymentSettingsUpdate](PhysicalPaymentSettingsUpdate.md) |  | |

### Return type

[**PhysicalPaymentSettingsEnvelope**](PhysicalPaymentSettingsEnvelope.md)

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
| **409** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

