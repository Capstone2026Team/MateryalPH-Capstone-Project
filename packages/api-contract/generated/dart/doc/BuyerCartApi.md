# materyalph_api_client.api.BuyerCartApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**addBuyerCartItem**](BuyerCartApi.md#addbuyercartitem) | **POST** /buyers/cart/items |
[**getBuyerCart**](BuyerCartApi.md#getbuyercart) | **GET** /buyers/cart |
[**previewBuyerCheckout**](BuyerCartApi.md#previewbuyercheckout) | **POST** /buyers/cart/checkout-preview |
[**removeBuyerCartItem**](BuyerCartApi.md#removebuyercartitem) | **DELETE** /buyers/cart/items/{itemId} |
[**setBuyerCartDestination**](BuyerCartApi.md#setbuyercartdestination) | **PUT** /buyers/cart/destination |
[**setBuyerCartFulfillment**](BuyerCartApi.md#setbuyercartfulfillment) | **PUT** /buyers/cart/vendor-groups/{vendorId}/fulfillment |
[**updateBuyerCartItem**](BuyerCartApi.md#updatebuyercartitem) | **PATCH** /buyers/cart/items/{itemId} |


# **addBuyerCartItem**
> CartEnvelope addBuyerCartItem(idempotencyKey, cartItemCreate)



Adds a variant (or increases an existing line) after revalidating eligibility, radius, the expected price version (409 PRICE_CHANGED) and quantity (422 QUANTITY_INVALID or QUANTITY_UNAVAILABLE without revealing stock). Creates no inventory hold or reservation. Idempotency-Key makes retries safe; a changed body under the same key is 409.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerCartApi();
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final CartItemCreate cartItemCreate = ; // CartItemCreate |

try {
    final response = api.addBuyerCartItem(idempotencyKey, cartItemCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerCartApi->addBuyerCartItem: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String**|  |
 **cartItemCreate** | [**CartItemCreate**](CartItemCreate.md)|  |

### Return type

[**CartEnvelope**](CartEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getBuyerCart**
> CartEnvelope getBuyerCart()



The Buyer's active cart grouped by Vendor with each line's snapshot, current public state and inline issues. Viewing never reserves stock.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerCartApi();

try {
    final response = api.getBuyerCart();
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerCartApi->getBuyerCart: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**CartEnvelope**](CartEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **previewBuyerCheckout**
> CheckoutPreviewEnvelope previewBuyerCheckout(checkoutPreviewRequest)



One child group per Vendor, each revalidated for listing state, price version, availability label, destination and serviceability, delivery/pickup capability and payment-method eligibility, with stale or blocked results inline on the affected group. Delivery shows the Phase 5 advisory estimate (road route from store to the vehicle drop-off) and never a confirmed offer; unknown measurements stay manual review. Amounts follow FIN-02 included VAT and exclude Vendor commission and withholding. Creates no order, hold or reservation and never discards cart lines.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerCartApi();
final CheckoutPreviewRequest checkoutPreviewRequest = ; // CheckoutPreviewRequest |

try {
    final response = api.previewBuyerCheckout(checkoutPreviewRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerCartApi->previewBuyerCheckout: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **checkoutPreviewRequest** | [**CheckoutPreviewRequest**](CheckoutPreviewRequest.md)|  |

### Return type

[**CheckoutPreviewEnvelope**](CheckoutPreviewEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **removeBuyerCartItem**
> CartEnvelope removeBuyerCartItem(lockVersion, itemId)



Removes one cart line. Requires the cart lock_version.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerCartApi();
final int lockVersion = 56; // int |
final String itemId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.removeBuyerCartItem(lockVersion, itemId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerCartApi->removeBuyerCartItem: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lockVersion** | **int**|  |
 **itemId** | **String**|  |

### Return type

[**CartEnvelope**](CartEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **setBuyerCartDestination**
> CartEnvelope setBuyerCartDestination(cartDestinationUpdate)



Sets the intended destination or Project site and the known heavy-vehicle restriction answer. YES requires a distinct saved alternate drop-off and access instructions (422 ALTERNATE_DROP_OFF_REQUIRED); both locations stay stored and labelled and the intended site is never replaced. Only the Buyer's own active saved locations are accepted.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerCartApi();
final CartDestinationUpdate cartDestinationUpdate = ; // CartDestinationUpdate |

try {
    final response = api.setBuyerCartDestination(cartDestinationUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerCartApi->setBuyerCartDestination: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cartDestinationUpdate** | [**CartDestinationUpdate**](CartDestinationUpdate.md)|  |

### Return type

[**CartEnvelope**](CartEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **setBuyerCartFulfillment**
> CartEnvelope setBuyerCartFulfillment(vendorId, cartFulfillmentUpdate)



Chooses Site Delivery or Self-Pickup for one Vendor group; 422 FULFILLMENT_NOT_OFFERED when the store does not offer it.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerCartApi();
final String vendorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final CartFulfillmentUpdate cartFulfillmentUpdate = ; // CartFulfillmentUpdate |

try {
    final response = api.setBuyerCartFulfillment(vendorId, cartFulfillmentUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerCartApi->setBuyerCartFulfillment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **vendorId** | **String**|  |
 **cartFulfillmentUpdate** | [**CartFulfillmentUpdate**](CartFulfillmentUpdate.md)|  |

### Return type

[**CartEnvelope**](CartEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateBuyerCartItem**
> CartEnvelope updateBuyerCartItem(itemId, cartItemUpdate)



Changes quantity (revalidated), saves for later, or explicitly accepts the current price version. Requires the cart lock_version (409 CART_VERSION_CONFLICT).

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerCartApi();
final String itemId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final CartItemUpdate cartItemUpdate = ; // CartItemUpdate |

try {
    final response = api.updateBuyerCartItem(itemId, cartItemUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerCartApi->updateBuyerCartItem: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **itemId** | **String**|  |
 **cartItemUpdate** | [**CartItemUpdate**](CartItemUpdate.md)|  |

### Return type

[**CartEnvelope**](CartEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

