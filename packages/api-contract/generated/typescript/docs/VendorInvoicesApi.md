# VendorInvoicesApi

All URIs are relative to */api/v1*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**explainVendorInvoiceDifference**](VendorInvoicesApi.md#explainvendorinvoicedifference) | **POST** /vendor/orders/{orderId}/invoices/{recordId}/explanation |  |
| [**getVendorInvoiceFile**](VendorInvoicesApi.md#getvendorinvoicefile) | **GET** /vendor/invoice-records/{recordId}/content |  |
| [**getVendorOrderInvoices**](VendorInvoicesApi.md#getvendororderinvoices) | **GET** /vendor/orders/{orderId}/invoices |  |
| [**listVendorInvoices**](VendorInvoicesApi.md#listvendorinvoices) | **GET** /vendor/invoices |  |
| [**uploadVendorInvoice**](VendorInvoicesApi.md#uploadvendorinvoice) | **POST** /vendor/orders/{orderId}/invoices |  |



## explainVendorInvoiceDifference

> VendorOrderInvoicesEnvelope explainVendorInvoiceDifference(orderId, recordId, idempotencyKey, invoiceExplanationRequest)



invoices.upload. Explain a reconciliation difference.

### Example

```ts
import {
  Configuration,
  VendorInvoicesApi,
} from '@materyalph/api-client-ts';
import type { ExplainVendorInvoiceDifferenceRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorInvoicesApi(config);

  const body = {
    // string
    orderId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    recordId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    idempotencyKey: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // InvoiceExplanationRequest
    invoiceExplanationRequest: ...,
  } satisfies ExplainVendorInvoiceDifferenceRequest;

  try {
    const data = await api.explainVendorInvoiceDifference(body);
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
| **recordId** | `string` |  | [Defaults to `undefined`] |
| **idempotencyKey** | `string` |  | [Defaults to `undefined`] |
| **invoiceExplanationRequest** | [InvoiceExplanationRequest](InvoiceExplanationRequest.md) |  | |

### Return type

[**VendorOrderInvoicesEnvelope**](VendorOrderInvoicesEnvelope.md)

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


## getVendorInvoiceFile

> Blob getVendorInvoiceFile(recordId, expires, signature)



Owner, Store Manager, Store Staff, or the assigned Fulfillment Staff; signed link; recorded.

### Example

```ts
import {
  Configuration,
  VendorInvoicesApi,
} from '@materyalph/api-client-ts';
import type { GetVendorInvoiceFileRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorInvoicesApi(config);

  const body = {
    // string
    recordId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // number
    expires: 56,
    // string
    signature: signature_example,
  } satisfies GetVendorInvoiceFileRequest;

  try {
    const data = await api.getVendorInvoiceFile(body);
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
| **recordId** | `string` |  | [Defaults to `undefined`] |
| **expires** | `number` |  | [Defaults to `undefined`] |
| **signature** | `string` |  | [Defaults to `undefined`] |

### Return type

**Blob**

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `image/png`, `image/jpeg`, `application/pdf`, `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Private evidence bytes for a signed, unexpired link and an authorized caller. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **404** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **503** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getVendorOrderInvoices

> VendorOrderInvoicesEnvelope getVendorOrderInvoices(orderId)



invoices.view. Customer Service sees status and metadata only; the full Buyer TIN only for roles that upload.

### Example

```ts
import {
  Configuration,
  VendorInvoicesApi,
} from '@materyalph/api-client-ts';
import type { GetVendorOrderInvoicesRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorInvoicesApi(config);

  const body = {
    // string
    orderId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies GetVendorOrderInvoicesRequest;

  try {
    const data = await api.getVendorOrderInvoices(body);
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

### Return type

[**VendorOrderInvoicesEnvelope**](VendorOrderInvoicesEnvelope.md)

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


## listVendorInvoices

> InvoiceLogEnvelope listVendorInvoices(view, page, from, to)



invoices.view. Open requests, orders without an invoice copy yet, uploaded records and reconciliation items. Never Earnings or other protected finance.

### Example

```ts
import {
  Configuration,
  VendorInvoicesApi,
} from '@materyalph/api-client-ts';
import type { ListVendorInvoicesRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorInvoicesApi(config);

  const body = {
    // 'REQUESTS' | 'DUE' | 'RECORDS' | 'RECONCILIATION' (optional)
    view: view_example,
    // number (optional)
    page: 56,
    // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Invoice issued_on for RECORDS/RECONCILIATION, request created_at for REQUESTS, and accepted_at for DUE orders. Tab counts retain their existing unrestricted scope. (optional)
    from: 2013-10-20,
    // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Invoice issued_on for RECORDS/RECONCILIATION, request created_at for REQUESTS, and accepted_at for DUE orders. Tab counts retain their existing unrestricted scope. (optional)
    to: 2013-10-20,
  } satisfies ListVendorInvoicesRequest;

  try {
    const data = await api.listVendorInvoices(body);
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
| **view** | `REQUESTS`, `DUE`, `RECORDS`, `RECONCILIATION` |  | [Optional] [Defaults to `undefined`] [Enum: REQUESTS, DUE, RECORDS, RECONCILIATION] |
| **page** | `number` |  | [Optional] [Defaults to `undefined`] |
| **from** | `Date` | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Invoice issued_on for RECORDS/RECONCILIATION, request created_at for REQUESTS, and accepted_at for DUE orders. Tab counts retain their existing unrestricted scope. | [Optional] [Defaults to `undefined`] |
| **to** | `Date` | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Invoice issued_on for RECORDS/RECONCILIATION, request created_at for REQUESTS, and accepted_at for DUE orders. Tab counts retain their existing unrestricted scope. | [Optional] [Defaults to `undefined`] |

### Return type

[**InvoiceLogEnvelope**](InvoiceLogEnvelope.md)

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


## uploadVendorInvoice

> VendorOrderInvoicesEnvelope uploadVendorInvoice(orderId, idempotencyKey, invoiceType, issuerName, invoiceNumber, issuedOn, amountCentavos, sourceSystem, invoicingMethod, file, vatCentavos, vatExemptCentavos, zeroRatedCentavos, relatedLineIds, amendsInvoiceRecordId, invoiceRequestId)



invoices.upload (Owner, Store Manager, Store Staff). Validates type and issuer; a total or VAT difference opens INVOICE_RECONCILIATION_REQUIRED without changing the accepted Buyer total.

### Example

```ts
import {
  Configuration,
  VendorInvoicesApi,
} from '@materyalph/api-client-ts';
import type { UploadVendorInvoiceRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new VendorInvoicesApi(config);

  const body = {
    // string
    orderId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    idempotencyKey: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    invoiceType: invoiceType_example,
    // string | Must equal the registered business name.
    issuerName: issuerName_example,
    // string
    invoiceNumber: invoiceNumber_example,
    // Date
    issuedOn: 2013-10-20,
    // number
    amountCentavos: 56,
    // string
    sourceSystem: sourceSystem_example,
    // string
    invoicingMethod: invoicingMethod_example,
    // Blob | PDF, JPG or PNG copy, validated and scanned fail-closed, stored privately.
    file: BINARY_DATA_HERE,
    // number (optional)
    vatCentavos: 56,
    // number (optional)
    vatExemptCentavos: 56,
    // number (optional)
    zeroRatedCentavos: 56,
    // Array<string> (optional)
    relatedLineIds: ...,
    // string (optional)
    amendsInvoiceRecordId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string (optional)
    invoiceRequestId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies UploadVendorInvoiceRequest;

  try {
    const data = await api.uploadVendorInvoice(body);
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
| **invoiceType** | `VENDOR_GOODS_INVOICE`, `VENDOR_ADJUSTMENT_DOCUMENT` |  | [Defaults to `undefined`] [Enum: VENDOR_GOODS_INVOICE, VENDOR_ADJUSTMENT_DOCUMENT] |
| **issuerName** | `string` | Must equal the registered business name. | [Defaults to `undefined`] |
| **invoiceNumber** | `string` |  | [Defaults to `undefined`] |
| **issuedOn** | `Date` |  | [Defaults to `undefined`] |
| **amountCentavos** | `number` |  | [Defaults to `undefined`] |
| **sourceSystem** | `REGISTERED_CAS`, `BIR_EIS`, `LOOSE_LEAF_OR_PRINTED`, `OTHER_REGISTERED` |  | [Defaults to `undefined`] [Enum: REGISTERED_CAS, BIR_EIS, LOOSE_LEAF_OR_PRINTED, OTHER_REGISTERED] |
| **invoicingMethod** | `ELECTRONIC`, `COMPUTERIZED`, `MANUAL` |  | [Defaults to `undefined`] [Enum: ELECTRONIC, COMPUTERIZED, MANUAL] |
| **file** | `Blob` | PDF, JPG or PNG copy, validated and scanned fail-closed, stored privately. | [Defaults to `undefined`] |
| **vatCentavos** | `number` |  | [Optional] [Defaults to `undefined`] |
| **vatExemptCentavos** | `number` |  | [Optional] [Defaults to `undefined`] |
| **zeroRatedCentavos** | `number` |  | [Optional] [Defaults to `undefined`] |
| **relatedLineIds** | `Array<string>` |  | [Optional] |
| **amendsInvoiceRecordId** | `string` |  | [Optional] [Defaults to `undefined`] |
| **invoiceRequestId** | `string` |  | [Optional] [Defaults to `undefined`] |

### Return type

[**VendorOrderInvoicesEnvelope**](VendorOrderInvoicesEnvelope.md)

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

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

