# BuyerPaymentsApi

All URIs are relative to */api/v1*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**acknowledgePhysicalPayment**](BuyerPaymentsApi.md#acknowledgephysicalpayment) | **POST** /buyers/orders/{orderId}/physical-payments/{recordId}/acknowledge |  |
| [**createBuyerPayment**](BuyerPaymentsApi.md#createbuyerpayment) | **POST** /buyers/orders/{orderId}/payments |  |
| [**getBuyerPayment**](BuyerPaymentsApi.md#getbuyerpayment) | **GET** /buyers/payments/{paymentId} |  |
| [**getBuyerPaymentOptions**](BuyerPaymentsApi.md#getbuyerpaymentoptions) | **GET** /buyers/orders/{orderId}/payment-options |  |
| [**refreshBuyerPayment**](BuyerPaymentsApi.md#refreshbuyerpayment) | **POST** /buyers/payments/{paymentId}/refresh |  |



## acknowledgePhysicalPayment

> PhysicalPaymentSummaryEnvelope acknowledgePhysicalPayment(orderId, recordId, idempotencyKey)



Acknowledge one Vendor-recorded direct collection. Set once; never an online payment confirmation.

### Example

```ts
import {
  Configuration,
  BuyerPaymentsApi,
} from '@materyalph/api-client-ts';
import type { AcknowledgePhysicalPaymentRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerPaymentsApi(config);

  const body = {
    // string
    orderId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    recordId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    idempotencyKey: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies AcknowledgePhysicalPaymentRequest;

  try {
    const data = await api.acknowledgePhysicalPayment(body);
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

### Return type

[**PhysicalPaymentSummaryEnvelope**](PhysicalPaymentSummaryEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

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

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## createBuyerPayment

> PaymentAttemptEnvelope createBuyerPayment(orderId, idempotencyKey, paymentCreateRequest)



Opens one provider session for the due purpose through the reconciled Vendor TEST sub-account. expected_total_centavos must equal the server total (409 PAYMENT_AMOUNT_CHANGED). An open attempt blocks another charge (409 PAYMENT_ATTEMPT_IN_PROGRESS). Payment and provisioning idempotency are separate scopes.

### Example

```ts
import {
  Configuration,
  BuyerPaymentsApi,
} from '@materyalph/api-client-ts';
import type { CreateBuyerPaymentRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerPaymentsApi(config);

  const body = {
    // string
    orderId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    idempotencyKey: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // PaymentCreateRequest
    paymentCreateRequest: ...,
  } satisfies CreateBuyerPaymentRequest;

  try {
    const data = await api.createBuyerPayment(body);
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
| **paymentCreateRequest** | [PaymentCreateRequest](PaymentCreateRequest.md) |  | |

### Return type

[**PaymentAttemptEnvelope**](PaymentAttemptEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Idempotent replay. |  -  |
| **201** | Authorized result. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **404** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **409** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **503** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getBuyerPayment

> PaymentAttemptEnvelope getBuyerPayment(paymentId)



The Buyer\&#39;s own attempt. Pending until a verified event or authoritative reconciliation.

### Example

```ts
import {
  Configuration,
  BuyerPaymentsApi,
} from '@materyalph/api-client-ts';
import type { GetBuyerPaymentRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerPaymentsApi(config);

  const body = {
    // string
    paymentId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies GetBuyerPaymentRequest;

  try {
    const data = await api.getBuyerPayment(body);
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

[passportBearer](../README.md#passportBearer)

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

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getBuyerPaymentOptions

> PaymentOptionsEnvelope getBuyerPaymentOptions(orderId)



Server-computed purpose, principal and per-channel Payment Processing Fee (versioned DEMO schedule, grossed up, no markup). Refund-incompatible channels are listed as unavailable with a reason.

### Example

```ts
import {
  Configuration,
  BuyerPaymentsApi,
} from '@materyalph/api-client-ts';
import type { GetBuyerPaymentOptionsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerPaymentsApi(config);

  const body = {
    // string
    orderId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies GetBuyerPaymentOptionsRequest;

  try {
    const data = await api.getBuyerPaymentOptions(body);
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

[**PaymentOptionsEnvelope**](PaymentOptionsEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

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


## refreshBuyerPayment

> PaymentAttemptEnvelope refreshBuyerPayment(paymentId)



Asks the provider for the authoritative session state; a provider outage keeps the attempt pending.

### Example

```ts
import {
  Configuration,
  BuyerPaymentsApi,
} from '@materyalph/api-client-ts';
import type { RefreshBuyerPaymentRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerPaymentsApi(config);

  const body = {
    // string
    paymentId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies RefreshBuyerPaymentRequest;

  try {
    const data = await api.refreshBuyerPayment(body);
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

[passportBearer](../README.md#passportBearer)

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
| **429** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

