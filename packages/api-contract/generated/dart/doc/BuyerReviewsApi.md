# materyalph_api_client.api.BuyerReviewsApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**addBuyerReviewMedia**](BuyerReviewsApi.md#addbuyerreviewmedia) | **POST** /buyers/reviews/{reviewId}/media |
[**editBuyerReview**](BuyerReviewsApi.md#editbuyerreview) | **PATCH** /buyers/reviews/{reviewId} |
[**getBuyerOrderReviews**](BuyerReviewsApi.md#getbuyerorderreviews) | **GET** /buyers/orders/{orderId}/reviews |
[**getBuyerReviewPhoto**](BuyerReviewsApi.md#getbuyerreviewphoto) | **GET** /buyers/reviews/{reviewId}/media/{mediaId}/content |
[**listListingReviews**](BuyerReviewsApi.md#listlistingreviews) | **GET** /buyers/listings/{listingId}/reviews |
[**listStoreReviews**](BuyerReviewsApi.md#liststorereviews) | **GET** /buyers/stores/{vendorId}/reviews |
[**removeBuyerReviewMedia**](BuyerReviewsApi.md#removebuyerreviewmedia) | **DELETE** /buyers/reviews/{reviewId}/media/{mediaId} |
[**reportBuyerReview**](BuyerReviewsApi.md#reportbuyerreview) | **POST** /buyers/reviews/{reviewId}/flags |
[**submitBuyerOrderReviews**](BuyerReviewsApi.md#submitbuyerorderreviews) | **POST** /buyers/orders/{orderId}/reviews |


# **addBuyerReviewMedia**
> BuyerOrderReviewsEnvelope addBuyerReviewMedia(reviewId, idempotencyKey, files)



Up to three photos or videos on your Product Review while it can still be edited. JPG/PNG up to 10 MB; MP4/MOV up to 25 MB. Content validated and scanned before private storage.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerReviewsApi();
final String reviewId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final BuiltList<MultipartFile> files = /path/to/file.txt; // BuiltList<MultipartFile> | JPG/PNG up to 10 MB or MP4/MOV up to 25 MB, content-validated and scanned fail-closed.

try {
    final response = api.addBuyerReviewMedia(reviewId, idempotencyKey, files);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerReviewsApi->addBuyerReviewMedia: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **reviewId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **files** | [**BuiltList&lt;MultipartFile&gt;**](MultipartFile.md)| JPG/PNG up to 10 MB or MP4/MOV up to 25 MB, content-validated and scanned fail-closed. |

### Return type

[**BuyerOrderReviewsEnvelope**](BuyerOrderReviewsEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **editBuyerReview**
> BuyerOrderReviewsEnvelope editBuyerReview(reviewId, buyerReviewEditRequest)



Correct your review within 24 hours of submitting (409 REVIEW_LOCKED at the exact instant), or once within 7 days after an Admin requests a correction.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerReviewsApi();
final String reviewId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final BuyerReviewEditRequest buyerReviewEditRequest = ; // BuyerReviewEditRequest |

try {
    final response = api.editBuyerReview(reviewId, buyerReviewEditRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerReviewsApi->editBuyerReview: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **reviewId** | **String**|  |
 **buyerReviewEditRequest** | [**BuyerReviewEditRequest**](BuyerReviewEditRequest.md)|  |

### Return type

[**BuyerOrderReviewsEnvelope**](BuyerOrderReviewsEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getBuyerOrderReviews**
> BuyerOrderReviewsEnvelope getBuyerOrderReviews(orderId)



Rating eligibility, the exact 14-day deadline (with its Asia/Manila label), your submissions and, after the blind reveal, the Vendor's rating of you.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerReviewsApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getBuyerOrderReviews(orderId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerReviewsApi->getBuyerOrderReviews: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |

### Return type

[**BuyerOrderReviewsEnvelope**](BuyerOrderReviewsEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getBuyerReviewPhoto**
> Uint8List getBuyerReviewPhoto(reviewId, mediaId, expires, signature)



Photo behind a five-minute signed link; re-authorized on every fetch.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerReviewsApi();
final String reviewId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String mediaId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final int expires = 56; // int |
final String signature = signature_example; // String |

try {
    final response = api.getBuyerReviewPhoto(reviewId, mediaId, expires, signature);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerReviewsApi->getBuyerReviewPhoto: $e\n');
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

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: image/png, image/jpeg, video/mp4, video/quicktime, application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listListingReviews**
> PublicReviewListEnvelope listListingReviews(listingId, page)



Visible Product Reviews of one listing with its own product average (separate from the Vendor's MQS).

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerReviewsApi();
final String listingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final int page = 56; // int |

try {
    final response = api.listListingReviews(listingId, page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerReviewsApi->listListingReviews: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **listingId** | **String**|  |
 **page** | **int**|  | [optional]

### Return type

[**PublicReviewListEnvelope**](PublicReviewListEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listStoreReviews**
> PublicReviewListEnvelope listStoreReviews(vendorId, page)



Visible Vendor ratings, published scores (or New Vendor — Building Track Record) and active badges.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerReviewsApi();
final String vendorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final int page = 56; // int |

try {
    final response = api.listStoreReviews(vendorId, page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerReviewsApi->listStoreReviews: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **vendorId** | **String**|  |
 **page** | **int**|  | [optional]

### Return type

[**PublicReviewListEnvelope**](PublicReviewListEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **removeBuyerReviewMedia**
> BuyerOrderReviewsEnvelope removeBuyerReviewMedia(reviewId, mediaId)



Remove one of your photos while the review can still be edited (retired, not erased from history).

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerReviewsApi();
final String reviewId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String mediaId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.removeBuyerReviewMedia(reviewId, mediaId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerReviewsApi->removeBuyerReviewMedia: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **reviewId** | **String**|  |
 **mediaId** | **String**|  |

### Return type

[**BuyerOrderReviewsEnvelope**](BuyerOrderReviewsEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reportBuyerReview**
> ReviewReportedEnvelope reportBuyerReview(reviewId, idempotencyKey, reviewFlagRequest)



Report a public review for moderation. Nothing is hidden or deleted by a report.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerReviewsApi();
final String reviewId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ReviewFlagRequest reviewFlagRequest = ; // ReviewFlagRequest |

try {
    final response = api.reportBuyerReview(reviewId, idempotencyKey, reviewFlagRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerReviewsApi->reportBuyerReview: $e\n');
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

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **submitBuyerOrderReviews**
> BuyerOrderReviewsEnvelope submitBuyerOrderReviews(orderId, idempotencyKey, buyerReviewSubmitRequest)



Rate the Vendor (Service Quality and Delivery or Processing Speed) and purchased lines (Product Quality). 409 REVIEW_NOT_ELIGIBLE before COMPLETED, REVIEW_WINDOW_CLOSED at 14 days, REVIEW_ALREADY_SUBMITTED for a repeat.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerReviewsApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final BuyerReviewSubmitRequest buyerReviewSubmitRequest = ; // BuyerReviewSubmitRequest |

try {
    final response = api.submitBuyerOrderReviews(orderId, idempotencyKey, buyerReviewSubmitRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerReviewsApi->submitBuyerOrderReviews: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **buyerReviewSubmitRequest** | [**BuyerReviewSubmitRequest**](BuyerReviewSubmitRequest.md)|  |

### Return type

[**BuyerOrderReviewsEnvelope**](BuyerOrderReviewsEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

