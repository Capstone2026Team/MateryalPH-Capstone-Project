# materyalph_api_client.api.PaymentWebhooksApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**receiveXenditPaymentWebhook**](PaymentWebhooksApi.md#receivexenditpaymentwebhook) | **POST** /webhooks/xendit |
[**showPaymentReturnPage**](PaymentWebhooksApi.md#showpaymentreturnpage) | **GET** /payments/return |


# **receiveXenditPaymentWebhook**
> PaymentWebhookAckEnvelope receiveXenditPaymentWebhook(xCallbackToken, paymentWebhookPayload, webhookId)



Fast inbox. Verifies x-callback-token in constant time (Xendit documents no HMAC signature header), stores the raw event once by webhook-id, acknowledges, then processes asynchronously. Processing re-reads the session authoritatively and checks identifier, reference, amount, currency, account and transition before anything is PAID. Forged, duplicate, reordered, mismatched or unknown events never create a paid order.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getPaymentWebhooksApi();
final String xCallbackToken = xCallbackToken_example; // String |
final PaymentWebhookPayload paymentWebhookPayload = ; // PaymentWebhookPayload |
final String webhookId = webhookId_example; // String |

try {
    final response = api.receiveXenditPaymentWebhook(xCallbackToken, paymentWebhookPayload, webhookId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PaymentWebhooksApi->receiveXenditPaymentWebhook: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **xCallbackToken** | **String**|  |
 **paymentWebhookPayload** | [**PaymentWebhookPayload**](PaymentWebhookPayload.md)|  |
 **webhookId** | **String**|  | [optional]

### Return type

[**PaymentWebhookAckEnvelope**](PaymentWebhookAckEnvelope.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **showPaymentReturnPage**
> String showPaymentReturnPage(attempt)



Browser return page after the hosted payment page. Always renders Pending with a deep link back to the app; never reads or changes payment state.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getPaymentWebhooksApi();
final String attempt = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.showPaymentReturnPage(attempt);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PaymentWebhooksApi->showPaymentReturnPage: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **attempt** | **String**|  | [optional]

### Return type

**String**

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/html, application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

