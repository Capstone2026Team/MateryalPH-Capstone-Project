# materyalph_api_client.api.BuyerPaymentsApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**acknowledgePhysicalPayment**](BuyerPaymentsApi.md#acknowledgephysicalpayment) | **POST** /buyers/orders/{orderId}/physical-payments/{recordId}/acknowledge |
[**createBuyerPayment**](BuyerPaymentsApi.md#createbuyerpayment) | **POST** /buyers/orders/{orderId}/payments |
[**getBuyerPayment**](BuyerPaymentsApi.md#getbuyerpayment) | **GET** /buyers/payments/{paymentId} |
[**getBuyerPaymentOptions**](BuyerPaymentsApi.md#getbuyerpaymentoptions) | **GET** /buyers/orders/{orderId}/payment-options |
[**refreshBuyerPayment**](BuyerPaymentsApi.md#refreshbuyerpayment) | **POST** /buyers/payments/{paymentId}/refresh |


# **acknowledgePhysicalPayment**
> PhysicalPaymentSummaryEnvelope acknowledgePhysicalPayment(orderId, recordId, idempotencyKey)



Acknowledge one Vendor-recorded direct collection. Set once; never an online payment confirmation.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerPaymentsApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String recordId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.acknowledgePhysicalPayment(orderId, recordId, idempotencyKey);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerPaymentsApi->acknowledgePhysicalPayment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |
 **recordId** | **String**|  |
 **idempotencyKey** | **String**|  |

### Return type

[**PhysicalPaymentSummaryEnvelope**](PhysicalPaymentSummaryEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createBuyerPayment**
> PaymentAttemptEnvelope createBuyerPayment(orderId, idempotencyKey, paymentCreateRequest)



Opens one provider session for the due purpose through the reconciled Vendor TEST sub-account. expected_total_centavos must equal the server total (409 PAYMENT_AMOUNT_CHANGED). An open attempt blocks another charge (409 PAYMENT_ATTEMPT_IN_PROGRESS). Payment and provisioning idempotency are separate scopes.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerPaymentsApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final PaymentCreateRequest paymentCreateRequest = ; // PaymentCreateRequest |

try {
    final response = api.createBuyerPayment(orderId, idempotencyKey, paymentCreateRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerPaymentsApi->createBuyerPayment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **paymentCreateRequest** | [**PaymentCreateRequest**](PaymentCreateRequest.md)|  |

### Return type

[**PaymentAttemptEnvelope**](PaymentAttemptEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getBuyerPayment**
> PaymentAttemptEnvelope getBuyerPayment(paymentId)



The Buyer's own attempt. Pending until a verified event or authoritative reconciliation.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerPaymentsApi();
final String paymentId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getBuyerPayment(paymentId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerPaymentsApi->getBuyerPayment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **paymentId** | **String**|  |

### Return type

[**PaymentAttemptEnvelope**](PaymentAttemptEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getBuyerPaymentOptions**
> PaymentOptionsEnvelope getBuyerPaymentOptions(orderId)



Server-computed purpose, principal and per-channel Payment Processing Fee (versioned DEMO schedule, grossed up, no markup). Refund-incompatible channels are listed as unavailable with a reason.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerPaymentsApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getBuyerPaymentOptions(orderId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerPaymentsApi->getBuyerPaymentOptions: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |

### Return type

[**PaymentOptionsEnvelope**](PaymentOptionsEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **refreshBuyerPayment**
> PaymentAttemptEnvelope refreshBuyerPayment(paymentId)



Asks the provider for the authoritative session state; a provider outage keeps the attempt pending.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerPaymentsApi();
final String paymentId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.refreshBuyerPayment(paymentId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerPaymentsApi->refreshBuyerPayment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **paymentId** | **String**|  |

### Return type

[**PaymentAttemptEnvelope**](PaymentAttemptEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

