# PaymentWebhooksApi

All URIs are relative to */api/v1*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**receiveXenditPaymentWebhook**](PaymentWebhooksApi.md#receivexenditpaymentwebhook) | **POST** /webhooks/xendit |  |
| [**showPaymentReturnPage**](PaymentWebhooksApi.md#showpaymentreturnpage) | **GET** /payments/return |  |



## receiveXenditPaymentWebhook

> PaymentWebhookAckEnvelope receiveXenditPaymentWebhook(xCallbackToken, paymentWebhookPayload, webhookId)



Fast inbox. Verifies x-callback-token in constant time (Xendit documents no HMAC signature header), stores the raw event once by webhook-id, acknowledges, then processes asynchronously. Processing re-reads the session authoritatively and checks identifier, reference, amount, currency, account and transition before anything is PAID. Forged, duplicate, reordered, mismatched or unknown events never create a paid order.

### Example

```ts
import {
  Configuration,
  PaymentWebhooksApi,
} from '@materyalph/api-client-ts';
import type { ReceiveXenditPaymentWebhookRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const api = new PaymentWebhooksApi();

  const body = {
    // string
    xCallbackToken: xCallbackToken_example,
    // PaymentWebhookPayload
    paymentWebhookPayload: ...,
    // string (optional)
    webhookId: webhookId_example,
  } satisfies ReceiveXenditPaymentWebhookRequest;

  try {
    const data = await api.receiveXenditPaymentWebhook(body);
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
| **xCallbackToken** | `string` |  | [Defaults to `undefined`] |
| **paymentWebhookPayload** | [PaymentWebhookPayload](PaymentWebhookPayload.md) |  | |
| **webhookId** | `string` |  | [Optional] [Defaults to `undefined`] |

### Return type

[**PaymentWebhookAckEnvelope**](PaymentWebhookAckEnvelope.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized result. |  -  |
| **400** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **413** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **503** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## showPaymentReturnPage

> string showPaymentReturnPage(attempt)



Browser return page after the hosted payment page. Always renders Pending with a deep link back to the app; never reads or changes payment state.

### Example

```ts
import {
  Configuration,
  PaymentWebhooksApi,
} from '@materyalph/api-client-ts';
import type { ShowPaymentReturnPageRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const api = new PaymentWebhooksApi();

  const body = {
    // string (optional)
    attempt: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies ShowPaymentReturnPageRequest;

  try {
    const data = await api.showPaymentReturnPage(body);
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
| **attempt** | `string` |  | [Optional] [Defaults to `undefined`] |

### Return type

**string**

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `text/html`, `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Pending HTML page. |  -  |
| **429** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

