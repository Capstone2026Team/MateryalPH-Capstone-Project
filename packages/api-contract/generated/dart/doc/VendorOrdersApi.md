# materyalph_api_client.api.VendorOrdersApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**confirmVendorOrder**](VendorOrdersApi.md#confirmvendororder) | **POST** /vendor/orders/{orderId}/confirm |
[**declineVendorOrder**](VendorOrdersApi.md#declinevendororder) | **POST** /vendor/orders/{orderId}/decline |
[**getVendorOrder**](VendorOrdersApi.md#getvendororder) | **GET** /vendor/orders/{orderId} |
[**getVendorOrderDeliveryPlan**](VendorOrdersApi.md#getvendororderdeliveryplan) | **POST** /vendor/orders/{orderId}/delivery-recommendations |
[**listVendorOrders**](VendorOrdersApi.md#listvendororders) | **GET** /vendor/orders |


# **confirmVendorOrder**
> OrderDetailEnvelope confirmVendorOrder(orderId, idempotencyKey, vendorOrderConfirmRequest)



Manual confirmation, permitted revision (lower quantities or an order-level discount; never a price increase) and optional manual NRPC. One transaction locks the organization, order and every inventory row in deterministic order, revalidates the store (activation, restriction, public profile), online payment capability, listings, tax classification and stock, and reserves every confirmed line or none (409 STOCK_INSUFFICIENT / STORE_NOT_ELIGIBLE / LINE_NOT_ELIGIBLE). Owner, Manager, Store Staff and Customer Service confirm unchanged orders; revisions and NRPC need Owner, Manager or Store Staff; Site Delivery vehicles, trips and the formula fee need Owner or Manager (409 DELIVERY_FEE_CHANGED if the fee differs from the formula).

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorOrdersApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final VendorOrderConfirmRequest vendorOrderConfirmRequest = ; // VendorOrderConfirmRequest |

try {
    final response = api.confirmVendorOrder(orderId, idempotencyKey, vendorOrderConfirmRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOrdersApi->confirmVendorOrder: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **vendorOrderConfirmRequest** | [**VendorOrderConfirmRequest**](VendorOrderConfirmRequest.md)|  |

### Return type

[**OrderDetailEnvelope**](OrderDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **declineVendorOrder**
> OrderDetailEnvelope declineVendorOrder(orderId, idempotencyKey, vendorOrderDeclineRequest)



Declines a request awaiting confirmation with a reason code and reason. Nothing is reserved before confirmation, so nothing is released.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorOrdersApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final VendorOrderDeclineRequest vendorOrderDeclineRequest = ; // VendorOrderDeclineRequest |

try {
    final response = api.declineVendorOrder(orderId, idempotencyKey, vendorOrderDeclineRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOrdersApi->declineVendorOrder: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **vendorOrderDeclineRequest** | [**VendorOrderDeclineRequest**](VendorOrderDeclineRequest.md)|  |

### Return type

[**OrderDetailEnvelope**](OrderDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVendorOrder**
> OrderDetailEnvelope getVendorOrder(orderId)



Job-order detail with lines, authorized inventory, reservations, auto-accept outcome, confirmed delivery, NRPC, money breakdown, history, role-aware permissions and one primary action per state. Buyer coordinates are never returned.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorOrdersApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getVendorOrder(orderId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOrdersApi->getVendorOrder: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |

### Return type

[**OrderDetailEnvelope**](OrderDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVendorOrderDeliveryPlan**
> DeliveryPlanEnvelope getVendorOrderDeliveryPlan(orderId, deliveryPlanRequest)



Advisory vehicle, trip and formula-fee options for a Site Delivery request, routed from the store's current address to the order's frozen vehicle drop-off. Advisory only; never a confirmation.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorOrdersApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final DeliveryPlanRequest deliveryPlanRequest = ; // DeliveryPlanRequest |

try {
    final response = api.getVendorOrderDeliveryPlan(orderId, deliveryPlanRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOrdersApi->getVendorOrderDeliveryPlan: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |
 **deliveryPlanRequest** | [**DeliveryPlanRequest**](DeliveryPlanRequest.md)|  |

### Return type

[**DeliveryPlanEnvelope**](DeliveryPlanEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listVendorOrders**
> OrderListEnvelope listVendorOrders(group, q, page)



Status-filtered order workspace for the current organization (NEW, WAITING_ON_BUYER, AWAITING_PAYMENT, CONFIRMED, CLOSED). Fulfillment Staff never see requests before confirmation and payment conditions. Search matches Order ID or Buyer name.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorOrdersApi();
final String group = group_example; // String |
final String q = q_example; // String |
final int page = 56; // int |

try {
    final response = api.listVendorOrders(group, q, page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorOrdersApi->listVendorOrders: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group** | **String**|  | [optional]
 **q** | **String**|  | [optional]
 **page** | **int**|  | [optional]

### Return type

[**OrderListEnvelope**](OrderListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

