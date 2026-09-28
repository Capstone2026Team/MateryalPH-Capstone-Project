# materyalph_api_client.api.BuyerLocationsApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createBuyerLocation**](BuyerLocationsApi.md#createbuyerlocation) | **POST** /buyers/locations |
[**getBuyerOnboarding**](BuyerLocationsApi.md#getbuyeronboarding) | **GET** /buyers/onboarding |
[**listBuyerLocations**](BuyerLocationsApi.md#listbuyerlocations) | **GET** /buyers/locations |
[**listBuyerPsgcAreas**](BuyerLocationsApi.md#listbuyerpsgcareas) | **GET** /buyers/geography/areas |
[**makeBuyerLocationPrimary**](BuyerLocationsApi.md#makebuyerlocationprimary) | **POST** /buyers/locations/{locationId}/primary |
[**removeBuyerLocation**](BuyerLocationsApi.md#removebuyerlocation) | **DELETE** /buyers/locations/{locationId} |
[**resolveBuyerLocation**](BuyerLocationsApi.md#resolvebuyerlocation) | **POST** /buyers/locations/resolve |
[**saveBuyerOnboarding**](BuyerLocationsApi.md#savebuyeronboarding) | **PUT** /buyers/onboarding |
[**updateBuyerLocation**](BuyerLocationsApi.md#updatebuyerlocation) | **PATCH** /buyers/locations/{locationId} |


# **createBuyerLocation**
> BuyerLocationEnvelope createBuyerLocation(idempotencyKey, buyerLocationCreate)



Saves a location from a resolution_token issued to this Buyer within 30 minutes. The first location becomes primary. When the address provider was unavailable, address_line is required (ADDRESS_DESCRIPTION_REQUIRED). Retrying with the same Idempotency-Key returns the same location.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerLocationsApi();
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final BuyerLocationCreate buyerLocationCreate = ; // BuyerLocationCreate |

try {
    final response = api.createBuyerLocation(idempotencyKey, buyerLocationCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerLocationsApi->createBuyerLocation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String**|  |
 **buyerLocationCreate** | [**BuyerLocationCreate**](BuyerLocationCreate.md)|  |

### Return type

[**BuyerLocationEnvelope**](BuyerLocationEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getBuyerOnboarding**
> BuyerOnboardingEnvelope getBuyerOnboarding()



Optional Buyer profile onboarding snapshot with the approved industry list, active material categories and the saved discovery radius. Skipping never blocks the account.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerLocationsApi();

try {
    final response = api.getBuyerOnboarding();
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerLocationsApi->getBuyerOnboarding: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuyerOnboardingEnvelope**](BuyerOnboardingEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listBuyerLocations**
> BuyerLocationListEnvelope listBuyerLocations()



The Buyer's own active saved locations, primary first. Coordinates, contacts and site instructions are returned only to their owner.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerLocationsApi();

try {
    final response = api.listBuyerLocations();
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerLocationsApi->listBuyerLocations: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuyerLocationListEnvelope**](BuyerLocationListEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listBuyerPsgcAreas**
> PsgcAreaListEnvelope listBuyerPsgcAreas(level, parentCode, q, page)



Paginated PSGC area picker from the ACTIVE imported version. PROVINCE returns provinces plus independent cities directly under a region. Returns an empty list with status NO_ACTIVE_PSGC_VERSION when nothing is imported.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerLocationsApi();
final String level = level_example; // String |
final String parentCode = parentCode_example; // String |
final String q = q_example; // String |
final int page = 56; // int |

try {
    final response = api.listBuyerPsgcAreas(level, parentCode, q, page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerLocationsApi->listBuyerPsgcAreas: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **level** | **String**|  |
 **parentCode** | **String**|  | [optional]
 **q** | **String**|  | [optional]
 **page** | **int**|  | [optional]

### Return type

[**PsgcAreaListEnvelope**](PsgcAreaListEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **makeBuyerLocationPrimary**
> BuyerLocationEnvelope makeBuyerLocationPrimary(locationId, lockVersionRequest)



Makes this location the single primary location.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerLocationsApi();
final String locationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final LockVersionRequest lockVersionRequest = ; // LockVersionRequest |

try {
    final response = api.makeBuyerLocationPrimary(locationId, lockVersionRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerLocationsApi->makeBuyerLocationPrimary: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **locationId** | **String**|  |
 **lockVersionRequest** | [**LockVersionRequest**](LockVersionRequest.md)|  |

### Return type

[**BuyerLocationEnvelope**](BuyerLocationEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **removeBuyerLocation**
> BuyerLocationRemovedEnvelope removeBuyerLocation(lockVersion, locationId)



Archives a saved location. The primary location cannot be removed while other locations exist (409 PRIMARY_LOCATION_REQUIRED).

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerLocationsApi();
final int lockVersion = 56; // int |
final String locationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.removeBuyerLocation(lockVersion, locationId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerLocationsApi->removeBuyerLocation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **lockVersion** | **int**|  |
 **locationId** | **String**|  |

### Return type

[**BuyerLocationRemovedEnvelope**](BuyerLocationRemovedEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resolveBuyerLocation**
> BuyerLocationPreviewEnvelope resolveBuyerLocation(buyerLocationResolveRequest)



Resolves a dropped pin, an explicitly granted device point or a typed Philippine address into a reviewable preview with the best resolved versioned PSGC codes. Nothing is stored. GPS is optional; PIN and ADDRESS are complete alternatives. Pin resolution degrades to coordinates only when the address provider is unavailable; ADDRESS returns 503 ADDRESS_PROVIDER_UNAVAILABLE so the Buyer can drop a pin instead.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerLocationsApi();
final BuyerLocationResolveRequest buyerLocationResolveRequest = ; // BuyerLocationResolveRequest |

try {
    final response = api.resolveBuyerLocation(buyerLocationResolveRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerLocationsApi->resolveBuyerLocation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **buyerLocationResolveRequest** | [**BuyerLocationResolveRequest**](BuyerLocationResolveRequest.md)|  |

### Return type

[**BuyerLocationPreviewEnvelope**](BuyerLocationPreviewEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **saveBuyerOnboarding**
> BuyerOnboardingEnvelope saveBuyerOnboarding(buyerOnboardingUpdate)



Saves, completes or skips optional onboarding with optimistic concurrency. OTHER requires industry_other_label. A stale lock_version returns 409 ONBOARDING_VERSION_CONFLICT.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerLocationsApi();
final BuyerOnboardingUpdate buyerOnboardingUpdate = ; // BuyerOnboardingUpdate |

try {
    final response = api.saveBuyerOnboarding(buyerOnboardingUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerLocationsApi->saveBuyerOnboarding: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **buyerOnboardingUpdate** | [**BuyerOnboardingUpdate**](BuyerOnboardingUpdate.md)|  |

### Return type

[**BuyerOnboardingEnvelope**](BuyerOnboardingEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateBuyerLocation**
> BuyerLocationEnvelope updateBuyerLocation(locationId, buyerLocationUpdate)



Updates details with optimistic concurrency. A new resolution_token appends a new address version; earlier versions stay intact for snapshots. Another Buyer's location returns 404.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerLocationsApi();
final String locationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final BuyerLocationUpdate buyerLocationUpdate = ; // BuyerLocationUpdate |

try {
    final response = api.updateBuyerLocation(locationId, buyerLocationUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerLocationsApi->updateBuyerLocation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **locationId** | **String**|  |
 **buyerLocationUpdate** | [**BuyerLocationUpdate**](BuyerLocationUpdate.md)|  |

### Return type

[**BuyerLocationEnvelope**](BuyerLocationEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

