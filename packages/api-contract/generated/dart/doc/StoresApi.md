# materyalph_api_client.api.StoresApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getPublicStoreProfile**](StoresApi.md#getpublicstoreprofile) | **GET** /stores/{storeId}/profile |
[**listPublicStores**](StoresApi.md#listpublicstores) | **GET** /stores |


# **getPublicStoreProfile**
> PublicStoreProfileEnvelope getPublicStoreProfile(storeId)



Public Store Profile for an active, completed store, built from the same public projection as Buyer map, list and preview results. Weekly Store Operation is canonical; an explicit date override takes precedence for effective_today in Asia/Manila. The schedule is informational and does not prove live availability.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getStoresApi();
final String storeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getPublicStoreProfile(storeId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling StoresApi->getPublicStoreProfile: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **storeId** | **String**|  |

### Return type

[**PublicStoreProfileEnvelope**](PublicStoreProfileEnvelope.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listPublicStores**
> PublicStoreListEnvelope listPublicStores(page)



Paginated publicly discoverable active stores. Does not expose inventory or private Vendor data.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getStoresApi();
final int page = 56; // int |

try {
    final response = api.listPublicStores(page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling StoresApi->listPublicStores: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **int**|  | [optional]

### Return type

[**PublicStoreListEnvelope**](PublicStoreListEnvelope.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

