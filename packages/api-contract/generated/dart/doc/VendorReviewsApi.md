# materyalph_api_client.api.VendorReviewsApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**editVendorBuyerRating**](VendorReviewsApi.md#editvendorbuyerrating) | **PATCH** /vendor/reviews/{reviewId} |
[**getVendorOrderReviews**](VendorReviewsApi.md#getvendororderreviews) | **GET** /vendor/orders/{orderId}/reviews |
[**getVendorReviewPhoto**](VendorReviewsApi.md#getvendorreviewphoto) | **GET** /vendor/reviews/{reviewId}/media/{mediaId}/content |
[**listVendorReviews**](VendorReviewsApi.md#listvendorreviews) | **GET** /vendor/reviews |
[**reportVendorReview**](VendorReviewsApi.md#reportvendorreview) | **POST** /vendor/reviews/{reviewId}/flags |
[**submitVendorBuyerRating**](VendorReviewsApi.md#submitvendorbuyerrating) | **POST** /vendor/orders/{orderId}/buyer-rating |


# **editVendorBuyerRating**
> VendorOrderReviewsEnvelope editVendorBuyerRating(reviewId, vendorReviewEditRequest)



reviews.rate_buyer. Correct your store's Buyer rating within 24 hours.

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

final api = MateryalphApiClient().getVendorReviewsApi();
final String reviewId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final VendorReviewEditRequest vendorReviewEditRequest = ; // VendorReviewEditRequest |

try {
    final response = api.editVendorBuyerRating(reviewId, vendorReviewEditRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorReviewsApi->editVendorBuyerRating: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **reviewId** | **String**|  |
 **vendorReviewEditRequest** | [**VendorReviewEditRequest**](VendorReviewEditRequest.md)|  |

### Return type

[**VendorOrderReviewsEnvelope**](VendorOrderReviewsEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVendorOrderReviews**
> VendorOrderReviewsEnvelope getVendorOrderReviews(orderId)



reviews.view. The order's rating window; Buyer ratings appear only after the blind reveal.

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

final api = MateryalphApiClient().getVendorReviewsApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getVendorOrderReviews(orderId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorReviewsApi->getVendorOrderReviews: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |

### Return type

[**VendorOrderReviewsEnvelope**](VendorOrderReviewsEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVendorReviewPhoto**
> Uint8List getVendorReviewPhoto(reviewId, mediaId, expires, signature)



Photo of a visible review of your store behind a signed link.

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

final api = MateryalphApiClient().getVendorReviewsApi();
final String reviewId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String mediaId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final int expires = 56; // int |
final String signature = signature_example; // String |

try {
    final response = api.getVendorReviewPhoto(reviewId, mediaId, expires, signature);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorReviewsApi->getVendorReviewPhoto: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **reviewId** | **String**|  |
 **mediaId** | **String**|  |
 **expires** | **int**|  |
 **signature** | **String**|  |

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: image/png, image/jpeg, application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listVendorReviews**
> VendorReviewListEnvelope listVendorReviews(type, page)



reviews.view (Owner, Store Manager, Store Staff, Customer Service). Visible received Vendor ratings or Product Reviews, or your store's Buyer ratings. There is no delete operation.

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

final api = MateryalphApiClient().getVendorReviewsApi();
final String type = type_example; // String |
final int page = 56; // int |

try {
    final response = api.listVendorReviews(type, page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorReviewsApi->listVendorReviews: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **type** | **String**|  | [optional]
 **page** | **int**|  | [optional]

### Return type

[**VendorReviewListEnvelope**](VendorReviewListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reportVendorReview**
> ReviewReportedEnvelope reportVendorReview(reviewId, idempotencyKey, reviewFlagRequest)



reviews.report. Report a review of your store; a Vendor can never remove a Buyer review.

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

final api = MateryalphApiClient().getVendorReviewsApi();
final String reviewId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ReviewFlagRequest reviewFlagRequest = ; // ReviewFlagRequest |

try {
    final response = api.reportVendorReview(reviewId, idempotencyKey, reviewFlagRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorReviewsApi->reportVendorReview: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **reviewId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **reviewFlagRequest** | [**ReviewFlagRequest**](ReviewFlagRequest.md)|  |

### Return type

[**ReviewReportedEnvelope**](ReviewReportedEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **submitVendorBuyerRating**
> VendorOrderReviewsEnvelope submitVendorBuyerRating(orderId, idempotencyKey, vendorBuyerRatingRequest)



reviews.rate_buyer (Owner, Store Manager, Store Staff, Customer Service): Inquiry Seriousness, Communication Quality and Payment Reliability (CCS inputs).

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

final api = MateryalphApiClient().getVendorReviewsApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final VendorBuyerRatingRequest vendorBuyerRatingRequest = ; // VendorBuyerRatingRequest |

try {
    final response = api.submitVendorBuyerRating(orderId, idempotencyKey, vendorBuyerRatingRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorReviewsApi->submitVendorBuyerRating: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **vendorBuyerRatingRequest** | [**VendorBuyerRatingRequest**](VendorBuyerRatingRequest.md)|  |

### Return type

[**VendorOrderReviewsEnvelope**](VendorOrderReviewsEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

