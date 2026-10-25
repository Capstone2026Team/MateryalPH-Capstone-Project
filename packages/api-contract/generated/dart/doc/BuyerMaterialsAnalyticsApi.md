# materyalph_api_client.api.BuyerMaterialsAnalyticsApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getBuyerAnalyticsProduct**](BuyerMaterialsAnalyticsApi.md#getbuyeranalyticsproduct) | **POST** /buyers/materials-analytics/products/{materialId} |
[**getBuyerMaterialPriceDetails**](BuyerMaterialsAnalyticsApi.md#getbuyermaterialpricedetails) | **POST** /buyers/materials-analytics/{groupId} |
[**listBuyerAnalyticsProducts**](BuyerMaterialsAnalyticsApi.md#listbuyeranalyticsproducts) | **POST** /buyers/materials-analytics/products |
[**listBuyerMaterialOffers**](BuyerMaterialsAnalyticsApi.md#listbuyermaterialoffers) | **POST** /buyers/materials-analytics/{groupId}/offers |
[**listBuyerMaterialsAnalytics**](BuyerMaterialsAnalyticsApi.md#listbuyermaterialsanalytics) | **POST** /buyers/materials-analytics |


# **getBuyerAnalyticsProduct**
> BuyerAnalyticsProductDetailEnvelope getBuyerAnalyticsProduct(materialId, buyerMaterialsAnalyticsRequest)



Product analytics: the product summary, its variants (each with its own price range, Vendor count and best stock label) and the most-offered variant's average, trend and daily series. Averages never blend different variants (MAT-03).

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerMaterialsAnalyticsApi();
final String materialId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final BuyerMaterialsAnalyticsRequest buyerMaterialsAnalyticsRequest = ; // BuyerMaterialsAnalyticsRequest |

try {
    final response = api.getBuyerAnalyticsProduct(materialId, buyerMaterialsAnalyticsRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerMaterialsAnalyticsApi->getBuyerAnalyticsProduct: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **materialId** | **String**|  |
 **buyerMaterialsAnalyticsRequest** | [**BuyerMaterialsAnalyticsRequest**](BuyerMaterialsAnalyticsRequest.md)|  |

### Return type

[**BuyerAnalyticsProductDetailEnvelope**](BuyerAnalyticsProductDetailEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getBuyerMaterialPriceDetails**
> BuyerMaterialsAnalyticsDetailEnvelope getBuyerMaterialPriceDetails(groupId, buyerMaterialsAnalyticsRequest)



Material Price Details: every date in the window (gaps are MISSING_DAY), the trend and the comparable variant selector.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerMaterialsAnalyticsApi();
final String groupId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final BuyerMaterialsAnalyticsRequest buyerMaterialsAnalyticsRequest = ; // BuyerMaterialsAnalyticsRequest |

try {
    final response = api.getBuyerMaterialPriceDetails(groupId, buyerMaterialsAnalyticsRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerMaterialsAnalyticsApi->getBuyerMaterialPriceDetails: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **groupId** | **String**|  |
 **buyerMaterialsAnalyticsRequest** | [**BuyerMaterialsAnalyticsRequest**](BuyerMaterialsAnalyticsRequest.md)|  |

### Return type

[**BuyerMaterialsAnalyticsDetailEnvelope**](BuyerMaterialsAnalyticsDetailEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listBuyerAnalyticsProducts**
> BuyerAnalyticsProductListEnvelope listBuyerAnalyticsProducts(buyerMaterialsAnalyticsRequest)



One row per canonical product (material) within your origin and radius: comparable variant count, distinct current Vendor count and the min / median / max current price per canonical unit (each Vendor once per variant at its lowest price; ranges span variants and are not like-for-like). `categories` counts every product in scope for the overview tiles regardless of category_id or q. Read-only; POST keeps the origin out of URLs.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerMaterialsAnalyticsApi();
final BuyerMaterialsAnalyticsRequest buyerMaterialsAnalyticsRequest = ; // BuyerMaterialsAnalyticsRequest |

try {
    final response = api.listBuyerAnalyticsProducts(buyerMaterialsAnalyticsRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerMaterialsAnalyticsApi->listBuyerAnalyticsProducts: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **buyerMaterialsAnalyticsRequest** | [**BuyerMaterialsAnalyticsRequest**](BuyerMaterialsAnalyticsRequest.md)|  |

### Return type

[**BuyerAnalyticsProductListEnvelope**](BuyerAnalyticsProductListEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listBuyerMaterialOffers**
> MaterialOfferListEnvelope listBuyerMaterialOffers(groupId, buyerMaterialsAnalyticsRequest)



Current public offers (Buyer only), cheapest per canonical unit first; each opens the existing Product Details.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerMaterialsAnalyticsApi();
final String groupId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final BuyerMaterialsAnalyticsRequest buyerMaterialsAnalyticsRequest = ; // BuyerMaterialsAnalyticsRequest |

try {
    final response = api.listBuyerMaterialOffers(groupId, buyerMaterialsAnalyticsRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerMaterialsAnalyticsApi->listBuyerMaterialOffers: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **groupId** | **String**|  |
 **buyerMaterialsAnalyticsRequest** | [**BuyerMaterialsAnalyticsRequest**](BuyerMaterialsAnalyticsRequest.md)|  |

### Return type

[**MaterialOfferListEnvelope**](MaterialOfferListEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listBuyerMaterialsAnalytics**
> BuyerMaterialsAnalyticsListEnvelope listBuyerMaterialsAnalytics(buyerMaterialsAnalyticsRequest)



Categorized comparable variants within your origin and radius: daily equal-Vendor averages (one-Vendor limited data), exact-endpoint trends needing two Vendors at each endpoint, and current offering counts. Read-only; POST keeps the origin out of URLs.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerMaterialsAnalyticsApi();
final BuyerMaterialsAnalyticsRequest buyerMaterialsAnalyticsRequest = ; // BuyerMaterialsAnalyticsRequest |

try {
    final response = api.listBuyerMaterialsAnalytics(buyerMaterialsAnalyticsRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerMaterialsAnalyticsApi->listBuyerMaterialsAnalytics: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **buyerMaterialsAnalyticsRequest** | [**BuyerMaterialsAnalyticsRequest**](BuyerMaterialsAnalyticsRequest.md)|  |

### Return type

[**BuyerMaterialsAnalyticsListEnvelope**](BuyerMaterialsAnalyticsListEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

