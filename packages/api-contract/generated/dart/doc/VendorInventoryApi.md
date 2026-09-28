# materyalph_api_client.api.VendorInventoryApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**confirmVendorStock**](VendorInventoryApi.md#confirmvendorstock) | **POST** /vendor/inventory/confirmations |
[**getVendorInventorySettings**](VendorInventoryApi.md#getvendorinventorysettings) | **GET** /vendor/inventory/settings |
[**listVendorInventoryItems**](VendorInventoryApi.md#listvendorinventoryitems) | **GET** /vendor/inventory/items |
[**listVendorInventoryMovements**](VendorInventoryApi.md#listvendorinventorymovements) | **GET** /vendor/inventory/items/{variantId}/movements |
[**listVendorPriceHistory**](VendorInventoryApi.md#listvendorpricehistory) | **GET** /vendor/inventory/items/{variantId}/prices |
[**saveVendorInventorySettings**](VendorInventoryApi.md#savevendorinventorysettings) | **PUT** /vendor/inventory/settings |
[**updateVendorInventoryItem**](VendorInventoryApi.md#updatevendorinventoryitem) | **PATCH** /vendor/inventory/items/{variantId} |


# **confirmVendorStock**
> InventoryRowListEnvelope confirmVendorStock(stockConfirmationRequest)



Confirms unchanged stock counts. All rows succeed or none do; any stale lock_version returns 409 with every conflict. A listing hidden as TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED is restored immediately when all its active variants are confirmed and no other restriction applies.

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

final api = MateryalphApiClient().getVendorInventoryApi();
final StockConfirmationRequest stockConfirmationRequest = ; // StockConfirmationRequest |

try {
    final response = api.confirmVendorStock(stockConfirmationRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorInventoryApi->confirmVendorStock: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **stockConfirmationRequest** | [**StockConfirmationRequest**](StockConfirmationRequest.md)|  |

### Return type

[**InventoryRowListEnvelope**](InventoryRowListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVendorInventorySettings**
> InventorySettingsEnvelope getVendorInventorySettings()



### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorInventoryApi();

try {
    final response = api.getVendorInventorySettings();
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorInventoryApi->getVendorInventorySettings: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**InventorySettingsEnvelope**](InventorySettingsEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listVendorInventoryItems**
> InventoryLedgerEnvelope listVendorInventoryItems(q, listingId, stock, confirmation, page)



Vendor-only inventory ledger, one row per active variant. Exact quantities are private to authorized Vendor users (Owner, Store Manager, Store Staff, Inventory Staff; Customer Service Staff read-only). Fulfillment Staff are denied. Buyers only ever receive public_label.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorInventoryApi();
final String q = q_example; // String |
final String listingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final StockLabel stock = ; // StockLabel |
final String confirmation = confirmation_example; // String |
final int page = 56; // int |

try {
    final response = api.listVendorInventoryItems(q, listingId, stock, confirmation, page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorInventoryApi->listVendorInventoryItems: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **q** | **String**|  | [optional]
 **listingId** | **String**|  | [optional]
 **stock** | [**StockLabel**](.md)|  | [optional]
 **confirmation** | **String**|  | [optional]
 **page** | **int**|  | [optional]

### Return type

[**InventoryLedgerEnvelope**](InventoryLedgerEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listVendorInventoryMovements**
> InventoryMovementListEnvelope listVendorInventoryMovements(variantId, page)



Append-only movement history with actor, reason and before/after quantities, newest first.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorInventoryApi();
final String variantId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final int page = 56; // int |

try {
    final response = api.listVendorInventoryMovements(variantId, page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorInventoryApi->listVendorInventoryMovements: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **variantId** | **String**|  |
 **page** | **int**|  | [optional]

### Return type

[**InventoryMovementListEnvelope**](InventoryMovementListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listVendorPriceHistory**
> PriceHistoryEnvelope listVendorPriceHistory(variantId)



Every immutable price version of the variant, newest first, including retired ordinary and volume-tier versions. Earlier versions are never edited in place (MAT-03).

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorInventoryApi();
final String variantId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.listVendorPriceHistory(variantId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorInventoryApi->listVendorPriceHistory: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **variantId** | **String**|  |

### Return type

[**PriceHistoryEnvelope**](PriceHistoryEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **saveVendorInventorySettings**
> InventorySettingsEnvelope saveVendorInventorySettings(inventorySettingsUpdate)



Owner or Store Manager sets the Asia/Manila time for Day 7 and Day 12 reminders and whether email accompanies the in-app notice. SMS is never sent.

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

final api = MateryalphApiClient().getVendorInventoryApi();
final InventorySettingsUpdate inventorySettingsUpdate = ; // InventorySettingsUpdate |

try {
    final response = api.saveVendorInventorySettings(inventorySettingsUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorInventoryApi->saveVendorInventorySettings: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **inventorySettingsUpdate** | [**InventorySettingsUpdate**](InventorySettingsUpdate.md)|  |

### Return type

[**InventorySettingsEnvelope**](InventorySettingsEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateVendorInventoryItem**
> InventoryRowEnvelope updateVendorInventoryItem(variantId, inventoryRowUpdate)



Inline row edit. A count or adjustment (with reason) and reorder level need inventory.manage; a quick ordinary-price change needs catalog.manage and the current price version id. One transaction appends an immutable movement and, for a price change, a new immutable price version. A stale lock_version returns 409 STALE_VERSION and a stale price version 409 PRICE_VERSION_CONFLICT, each with the current row in details.current. Physical stock never falls below hard reservations (422 STOCK_BELOW_RESERVED).

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

final api = MateryalphApiClient().getVendorInventoryApi();
final String variantId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final InventoryRowUpdate inventoryRowUpdate = ; // InventoryRowUpdate |

try {
    final response = api.updateVendorInventoryItem(variantId, inventoryRowUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorInventoryApi->updateVendorInventoryItem: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **variantId** | **String**|  |
 **inventoryRowUpdate** | [**InventoryRowUpdate**](InventoryRowUpdate.md)|  |

### Return type

[**InventoryRowEnvelope**](InventoryRowEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

