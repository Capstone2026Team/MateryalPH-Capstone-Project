# materyalph_api_client.api.BuyerDiscoveryApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**addFavoriteSupplier**](BuyerDiscoveryApi.md#addfavoritesupplier) | **PUT** /buyers/favorite-suppliers/{vendorId} |
[**estimateBuyerRoute**](BuyerDiscoveryApi.md#estimatebuyerroute) | **POST** /buyers/discovery/routes |
[**getDirectorySupplierDetails**](BuyerDiscoveryApi.md#getdirectorysupplierdetails) | **GET** /buyers/discovery/directory-suppliers/{supplierId} |
[**listFavoriteSuppliers**](BuyerDiscoveryApi.md#listfavoritesuppliers) | **GET** /buyers/favorite-suppliers |
[**removeFavoriteSupplier**](BuyerDiscoveryApi.md#removefavoritesupplier) | **DELETE** /buyers/favorite-suppliers/{vendorId} |
[**saveBuyerDiscoveryRadius**](BuyerDiscoveryApi.md#savebuyerdiscoveryradius) | **PUT** /buyers/discovery/preferences |
[**searchBuyerSuppliers**](BuyerDiscoveryApi.md#searchbuyersuppliers) | **POST** /buyers/discovery/search |


# **addFavoriteSupplier**
> FavoriteSupplierStateEnvelope addFavoriteSupplier(vendorId)



Idempotently saves an active Verified Vendor as a Favorite Supplier. A Directory Supplier returns 422 FAVORITE_REQUIRES_VERIFIED_VENDOR.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerDiscoveryApi();
final String vendorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.addFavoriteSupplier(vendorId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerDiscoveryApi->addFavoriteSupplier: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **vendorId** | **String**|  |

### Return type

[**FavoriteSupplierStateEnvelope**](FavoriteSupplierStateEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **estimateBuyerRoute**
> RouteEstimateEnvelope estimateBuyerRoute(routeEstimateRequest)



One driving route from the active origin to the selected supplier inside the radius. Echoes request_version and the opaque origin_version so clients discard stale responses. Failures keep straight_line_meters in error details (503 ROUTE_UNAVAILABLE, 422 ROUTE_NOT_FOUND).

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerDiscoveryApi();
final RouteEstimateRequest routeEstimateRequest = ; // RouteEstimateRequest |

try {
    final response = api.estimateBuyerRoute(routeEstimateRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerDiscoveryApi->estimateBuyerRoute: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **routeEstimateRequest** | [**RouteEstimateRequest**](RouteEstimateRequest.md)|  |

### Return type

[**RouteEstimateEnvelope**](RouteEstimateEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getDirectorySupplierDetails**
> DirectorySupplierDetailEnvelope getDirectorySupplierDetails(supplierId)



Lazy-loaded, attributed Google Place Details for one unexpired Directory Supplier. Informational only; never exposes VPS, verification, messaging, ordering, reviews, payments or a storefront. A Google rating is labeled Google rating.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerDiscoveryApi();
final String supplierId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getDirectorySupplierDetails(supplierId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerDiscoveryApi->getDirectorySupplierDetails: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **supplierId** | **String**|  |

### Return type

[**DirectorySupplierDetailEnvelope**](DirectorySupplierDetailEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listFavoriteSuppliers**
> FavoriteSupplierListEnvelope listFavoriteSuppliers(page)



The Buyer's Favorite Suppliers (Verified Vendors only). A Favorite without eligible offerings stays listed with currently_discoverable false.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerDiscoveryApi();
final int page = 56; // int |

try {
    final response = api.listFavoriteSuppliers(page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerDiscoveryApi->listFavoriteSuppliers: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **int**|  | [optional]

### Return type

[**FavoriteSupplierListEnvelope**](FavoriteSupplierListEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **removeFavoriteSupplier**
> FavoriteSupplierStateEnvelope removeFavoriteSupplier(vendorId)



Idempotently removes a Favorite Supplier. Transaction and audit history are unaffected.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerDiscoveryApi();
final String vendorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.removeFavoriteSupplier(vendorId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerDiscoveryApi->removeFavoriteSupplier: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **vendorId** | **String**|  |

### Return type

[**FavoriteSupplierStateEnvelope**](FavoriteSupplierStateEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **saveBuyerDiscoveryRadius**
> DiscoveryPreferencesEnvelope saveBuyerDiscoveryRadius(discoveryPreferences)



Saves the Buyer's confirmed radius. Clients call this only after an explicit selection or a confirmed expansion; values outside 5, 10, 20, 30, 40 or 50 km return 422 RADIUS_UNSUPPORTED.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerDiscoveryApi();
final DiscoveryPreferences discoveryPreferences = ; // DiscoveryPreferences |

try {
    final response = api.saveBuyerDiscoveryRadius(discoveryPreferences);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerDiscoveryApi->saveBuyerDiscoveryRadius: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **discoveryPreferences** | [**DiscoveryPreferences**](DiscoveryPreferences.md)|  |

### Return type

[**DiscoveryPreferencesEnvelope**](DiscoveryPreferencesEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchBuyerSuppliers**
> DiscoverySearchEnvelope searchBuyerSuppliers(discoverySearchRequest)



Map and list results from one server response with one result identifier and one order (straight-line distance, then Verified Vendors before Directory Suppliers, then result id). Membership is PostGIS ST_DWithin on geography in metres with an inclusive boundary; route distance and saved hours never affect membership or order. The origin travels in the body, is never echoed, and is either an owned saved location, finite Philippine coordinates or the primary saved location. Radius expansion is only suggested in meta.expansion and requires Buyer confirmation. Directory Suppliers come from Google Places with attribution and are informational only.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerDiscoveryApi();
final DiscoverySearchRequest discoverySearchRequest = ; // DiscoverySearchRequest |

try {
    final response = api.searchBuyerSuppliers(discoverySearchRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerDiscoveryApi->searchBuyerSuppliers: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **discoverySearchRequest** | [**DiscoverySearchRequest**](DiscoverySearchRequest.md)|  |

### Return type

[**DiscoverySearchEnvelope**](DiscoverySearchEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

