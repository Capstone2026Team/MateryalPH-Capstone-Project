# materyalph_api_client.api.BuyerOrdersApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**acceptBuyerOrderNrpc**](BuyerOrdersApi.md#acceptbuyerordernrpc) | **POST** /buyers/orders/{orderId}/nrpc/accept |
[**approveBuyerOrderRevision**](BuyerOrdersApi.md#approvebuyerorderrevision) | **POST** /buyers/orders/{orderId}/revision/approve |
[**flagBuyerOrderNrpc**](BuyerOrdersApi.md#flagbuyerordernrpc) | **POST** /buyers/orders/{orderId}/nrpc/flag |
[**getBuyerCheckout**](BuyerOrdersApi.md#getbuyercheckout) | **GET** /buyers/checkouts/{checkoutId} |
[**getBuyerOrder**](BuyerOrdersApi.md#getbuyerorder) | **GET** /buyers/orders/{orderId} |
[**listBuyerOrders**](BuyerOrdersApi.md#listbuyerorders) | **GET** /buyers/orders |
[**rejectBuyerOrderNrpc**](BuyerOrdersApi.md#rejectbuyerordernrpc) | **POST** /buyers/orders/{orderId}/nrpc/reject |
[**rejectBuyerOrderRevision**](BuyerOrdersApi.md#rejectbuyerorderrevision) | **POST** /buyers/orders/{orderId}/revision/reject |
[**submitBuyerCheckout**](BuyerOrdersApi.md#submitbuyercheckout) | **POST** /buyers/checkouts |


# **acceptBuyerOrderNrpc**
> OrderDetailEnvelope acceptBuyerOrderNrpc(orderId, idempotencyKey, nrpcAcceptRequest)



Explicit acceptance of the current NRPC with the Terms version displayed with it (409 NRPC_TERMS_CHANGED otherwise) and acknowledged=true. Recorded with the Terms version and time; the version is then frozen and the order becomes payable.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerOrdersApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final NrpcAcceptRequest nrpcAcceptRequest = ; // NrpcAcceptRequest |

try {
    final response = api.acceptBuyerOrderNrpc(orderId, idempotencyKey, nrpcAcceptRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerOrdersApi->acceptBuyerOrderNrpc: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **nrpcAcceptRequest** | [**NrpcAcceptRequest**](NrpcAcceptRequest.md)|  |

### Return type

[**OrderDetailEnvelope**](OrderDetailEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **approveBuyerOrderRevision**
> OrderDetailEnvelope approveBuyerOrderRevision(orderId, idempotencyKey, orderRevisionDecision)



Accepts exactly the shown Vendor commercial version (snapshot_version). A stale version is 409 STALE_VERSION. With a proposed NRPC the order moves to AWAITING_NRPC_ACCEPTANCE; otherwise the version is frozen and the order becomes payable.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerOrdersApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final OrderRevisionDecision orderRevisionDecision = ; // OrderRevisionDecision |

try {
    final response = api.approveBuyerOrderRevision(orderId, idempotencyKey, orderRevisionDecision);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerOrdersApi->approveBuyerOrderRevision: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **orderRevisionDecision** | [**OrderRevisionDecision**](OrderRevisionDecision.md)|  |

### Return type

[**OrderDetailEnvelope**](OrderDetailEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **flagBuyerOrderNrpc**
> OrderDetailEnvelope flagBuyerOrderNrpc(orderId, idempotencyKey, nrpcFlagRequest)



Flags an NRPC as disproportionate for staff review. Separate from acceptance; never accepts, rejects or changes the order. One flag per NRPC.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerOrdersApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final NrpcFlagRequest nrpcFlagRequest = ; // NrpcFlagRequest |

try {
    final response = api.flagBuyerOrderNrpc(orderId, idempotencyKey, nrpcFlagRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerOrdersApi->flagBuyerOrderNrpc: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **nrpcFlagRequest** | [**NrpcFlagRequest**](NrpcFlagRequest.md)|  |

### Return type

[**OrderDetailEnvelope**](OrderDetailEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getBuyerCheckout**
> CheckoutSubmissionEnvelope getBuyerCheckout(checkoutId)



The parent checkout with its child orders. The parent status is derived from the children and never replaces them.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerOrdersApi();
final String checkoutId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getBuyerCheckout(checkoutId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerOrdersApi->getBuyerCheckout: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **checkoutId** | **String**|  |

### Return type

[**CheckoutSubmissionEnvelope**](CheckoutSubmissionEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getBuyerOrder**
> OrderDetailEnvelope getBuyerOrder(orderId)



Order details with immutable line snapshots, the current commercial version and change summary, separate state rows, the MoneyBreakdown (materials, discount, included VAT, delivery, NRPC within the order value, processing fee, total), the NRPC disclosure with its Terms version, the confirmed delivery drop-off before acceptance, deadlines in UTC with Asia/Manila as the display zone, and server-calculated actions. A window that has passed resolves to EXPIRED on read.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerOrdersApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getBuyerOrder(orderId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerOrdersApi->getBuyerOrder: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |

### Return type

[**OrderDetailEnvelope**](OrderDetailEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listBuyerOrders**
> OrderListEnvelope listBuyerOrders(group, page)



The Buyer's own orders, newest first, grouped by Awaiting Action, Active, Completed, Cancelled and Disputed. Order, payment, fulfillment, refund and dispute states are separate rows. Due windows are resolved before listing.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerOrdersApi();
final String group = group_example; // String |
final int page = 56; // int |

try {
    final response = api.listBuyerOrders(group, page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerOrdersApi->listBuyerOrders: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group** | **String**|  | [optional]
 **page** | **int**|  | [optional]

### Return type

[**OrderListEnvelope**](OrderListEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **rejectBuyerOrderNrpc**
> OrderDetailEnvelope rejectBuyerOrderNrpc(orderId, idempotencyKey, nrpcRejectRequest)



Rejects the current NRPC. The request is cancelled and its hard reservation released.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerOrdersApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final NrpcRejectRequest nrpcRejectRequest = ; // NrpcRejectRequest |

try {
    final response = api.rejectBuyerOrderNrpc(orderId, idempotencyKey, nrpcRejectRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerOrdersApi->rejectBuyerOrderNrpc: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **nrpcRejectRequest** | [**NrpcRejectRequest**](NrpcRejectRequest.md)|  |

### Return type

[**OrderDetailEnvelope**](OrderDetailEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **rejectBuyerOrderRevision**
> OrderDetailEnvelope rejectBuyerOrderRevision(orderId, idempotencyKey, orderRevisionDecision)



Rejects the shown Vendor version. The request is cancelled and its hard reservation released.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerOrdersApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final OrderRevisionDecision orderRevisionDecision = ; // OrderRevisionDecision |

try {
    final response = api.rejectBuyerOrderRevision(orderId, idempotencyKey, orderRevisionDecision);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerOrdersApi->rejectBuyerOrderRevision: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **orderRevisionDecision** | [**OrderRevisionDecision**](OrderRevisionDecision.md)|  |

### Return type

[**OrderDetailEnvelope**](OrderDetailEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **submitBuyerCheckout**
> CheckoutSubmissionEnvelope submitBuyerCheckout(idempotencyKey, checkoutSubmitRequest)



Submits the selected READY Vendor groups of the cart as one parent checkout with one child order request per Vendor. Each child snapshots its lines (listing, variant, unit, applied price version and frozen volume tiers, tax classification, displayed image) and keeps the intended destination and any heavy-vehicle alternate drop-off as separate references. Submission never reserves stock. Submitting fewer groups than the cart holds requires split_confirmed. A retry with the same Idempotency-Key and body returns the same checkout (200, meta.replayed=true); a changed body under the key is 409 IDEMPOTENCY_CONFLICT. After commit each child order gets one all-or-nothing Item-Based auto-accept attempt.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerOrdersApi();
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final CheckoutSubmitRequest checkoutSubmitRequest = ; // CheckoutSubmitRequest |

try {
    final response = api.submitBuyerCheckout(idempotencyKey, checkoutSubmitRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerOrdersApi->submitBuyerCheckout: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String**|  |
 **checkoutSubmitRequest** | [**CheckoutSubmitRequest**](CheckoutSubmitRequest.md)|  |

### Return type

[**CheckoutSubmissionEnvelope**](CheckoutSubmissionEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

