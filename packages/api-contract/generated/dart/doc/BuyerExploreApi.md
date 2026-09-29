# materyalph_api_client.api.BuyerExploreApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getBuyerExploreSummary**](BuyerExploreApi.md#getbuyerexploresummary) | **POST** /buyers/explore/summary |
[**getBuyerItemRankingPreferences**](BuyerExploreApi.md#getbuyeritemrankingpreferences) | **GET** /buyers/ranking-preferences/item-based |
[**getBuyerListingDetails**](BuyerExploreApi.md#getbuyerlistingdetails) | **POST** /buyers/listings/{listingId}/details |
[**resetBuyerItemRankingPreferences**](BuyerExploreApi.md#resetbuyeritemrankingpreferences) | **DELETE** /buyers/ranking-preferences/item-based |
[**saveBuyerItemRankingPreferences**](BuyerExploreApi.md#savebuyeritemrankingpreferences) | **PUT** /buyers/ranking-preferences/item-based |
[**searchBuyerListings**](BuyerExploreApi.md#searchbuyerlistings) | **POST** /buyers/listings/search |


# **getBuyerExploreSummary**
> ExploreSummaryEnvelope getBuyerExploreSummary(buyerOriginRequest)



MAT-01/MAT-02 Explore dashboard. Nearby Verified Vendors and Available Products (counted as distinct Vendor listings, never variants or canonical materials) and every category count come from one server snapshot with one current_as_of, scoped to all categories at the selected location and radius before any category or search filter. Materials Analytics stays explicitly unavailable until its end-to-end feature is installed. The origin travels in the body and is never echoed.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerExploreApi();
final BuyerOriginRequest buyerOriginRequest = ; // BuyerOriginRequest |

try {
    final response = api.getBuyerExploreSummary(buyerOriginRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerExploreApi->getBuyerExploreSummary: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **buyerOriginRequest** | [**BuyerOriginRequest**](BuyerOriginRequest.md)|  |

### Return type

[**ExploreSummaryEnvelope**](ExploreSummaryEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getBuyerItemRankingPreferences**
> RankingPreferencesEnvelope getBuyerItemRankingPreferences()



The Buyer's own Item-Based SRS weights, the current platform defaults and whether personalization is active. Never accepts a Buyer id.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerExploreApi();

try {
    final response = api.getBuyerItemRankingPreferences();
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerExploreApi->getBuyerItemRankingPreferences: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**RankingPreferencesEnvelope**](RankingPreferencesEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getBuyerListingDetails**
> ListingDetailsEnvelope getBuyerListingDetails(listingId, buyerOriginRequest)



Product Details for one Tier 2 listing while it has at least one eligible variant; a stale card returns 404 LISTING_UNAVAILABLE. Outside the radius it is described with purchasable false. Unoffered variants carry no price or stock label; exact quantities are never returned. A PS/ICC badge is MateryalPH evidence review, not a certification.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerExploreApi();
final String listingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final BuyerOriginRequest buyerOriginRequest = ; // BuyerOriginRequest |

try {
    final response = api.getBuyerListingDetails(listingId, buyerOriginRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerExploreApi->getBuyerListingDetails: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **listingId** | **String**|  |
 **buyerOriginRequest** | [**BuyerOriginRequest**](BuyerOriginRequest.md)|  |

### Return type

[**ListingDetailsEnvelope**](ListingDetailsEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resetBuyerItemRankingPreferences**
> RankingPreferencesEnvelope resetBuyerItemRankingPreferences(version)



Reset to Default. Removes the Item-Based override so the current platform defaults apply. Audited.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerExploreApi();
final int version = 56; // int |

try {
    final response = api.resetBuyerItemRankingPreferences(version);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerExploreApi->resetBuyerItemRankingPreferences: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **version** | **int**|  |

### Return type

[**RankingPreferencesEnvelope**](RankingPreferencesEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **saveBuyerItemRankingPreferences**
> RankingPreferencesEnvelope saveBuyerItemRankingPreferences(rankingPreferencesUpdate)



Saves a separate Item-Based override. Whole percentages 0–100 for exactly the five components, totalling 100 (422 WEIGHTS_TOTAL_INVALID); all-zero is 422 WEIGHTS_ALL_ZERO. version 0 creates; a stale version is 409 PREFERENCE_VERSION_CONFLICT. Audited.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerExploreApi();
final RankingPreferencesUpdate rankingPreferencesUpdate = ; // RankingPreferencesUpdate |

try {
    final response = api.saveBuyerItemRankingPreferences(rankingPreferencesUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerExploreApi->saveBuyerItemRankingPreferences: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **rankingPreferencesUpdate** | [**RankingPreferencesUpdate**](RankingPreferencesUpdate.md)|  |

### Return type

[**RankingPreferencesEnvelope**](RankingPreferencesEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchBuyerListings**
> ListingSearchEnvelope searchBuyerListings(listingSearchRequest)



Item-Based search over MAT-02 eligible Tier 2 listings inside the radius; Directory Suppliers are never inventory. Browsing defaults to DISTANCE and a text query defaults to BEST_DEAL (SRS, a normalized weighted sum with the Buyer's Item-Based weights). FAVORITES_FIRST is a separate explicit sort that never changes Best Deal. Best Price compares the MAT-03 normalized price of the same comparable group and canonical unit across in-stock offers in the radius and needs two Vendors. One card per listing, deterministic tie-breaking and a signed keyset cursor that rejects changed filters.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerExploreApi();
final ListingSearchRequest listingSearchRequest = ; // ListingSearchRequest |

try {
    final response = api.searchBuyerListings(listingSearchRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerExploreApi->searchBuyerListings: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **listingSearchRequest** | [**ListingSearchRequest**](ListingSearchRequest.md)|  |

### Return type

[**ListingSearchEnvelope**](ListingSearchEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

