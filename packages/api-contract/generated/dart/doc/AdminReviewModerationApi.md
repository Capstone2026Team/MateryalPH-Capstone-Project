# materyalph_api_client.api.AdminReviewModerationApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getAdminReviewModeration**](AdminReviewModerationApi.md#getadminreviewmoderation) | **GET** /admin/reviews/{reviewId} |
[**getAdminReviewPhoto**](AdminReviewModerationApi.md#getadminreviewphoto) | **GET** /admin/reviews/{reviewId}/media/{mediaId}/content |
[**listAdminReviewModeration**](AdminReviewModerationApi.md#listadminreviewmoderation) | **GET** /admin/reviews |
[**moderateAdminReview**](AdminReviewModerationApi.md#moderateadminreview) | **POST** /admin/reviews/{reviewId}/moderation |


# **getAdminReviewModeration**
> ModerationDetailEnvelope getAdminReviewModeration(reviewId)



reviews.moderate. Review, media, flags, verified-purchase reference, related dispute, immutable revisions and moderation history.

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

final api = MateryalphApiClient().getAdminReviewModerationApi();
final String reviewId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getAdminReviewModeration(reviewId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminReviewModerationApi->getAdminReviewModeration: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **reviewId** | **String**|  |

### Return type

[**ModerationDetailEnvelope**](ModerationDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAdminReviewPhoto**
> Uint8List getAdminReviewPhoto(reviewId, mediaId, expires, signature)



reviews.moderate. Photo behind a signed link.

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

final api = MateryalphApiClient().getAdminReviewModerationApi();
final String reviewId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String mediaId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final int expires = 56; // int |
final String signature = signature_example; // String |

try {
    final response = api.getAdminReviewPhoto(reviewId, mediaId, expires, signature);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminReviewModerationApi->getAdminReviewPhoto: $e\n');
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

# **listAdminReviewModeration**
> ModerationQueueEnvelope listAdminReviewModeration(state, page)



reviews.moderate (Super Admin, User Management Staff). The Product Review Moderation Queue.

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

final api = MateryalphApiClient().getAdminReviewModerationApi();
final String state = state_example; // String |
final int page = 56; // int |

try {
    final response = api.listAdminReviewModeration(state, page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminReviewModerationApi->listAdminReviewModeration: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **state** | **String**|  | [optional]
 **page** | **int**|  | [optional]

### Return type

[**ModerationQueueEnvelope**](ModerationQueueEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **moderateAdminReview**
> ModerationDetailEnvelope moderateAdminReview(reviewId, idempotencyKey, reviewModerationRequest)



reviews.moderate. Dismiss Flag, Request Correction, Hide Pending Review, Remove or Restore, each with a reason and audit record; original content is preserved.

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

final api = MateryalphApiClient().getAdminReviewModerationApi();
final String reviewId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ReviewModerationRequest reviewModerationRequest = ; // ReviewModerationRequest |

try {
    final response = api.moderateAdminReview(reviewId, idempotencyKey, reviewModerationRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminReviewModerationApi->moderateAdminReview: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **reviewId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **reviewModerationRequest** | [**ReviewModerationRequest**](ReviewModerationRequest.md)|  |

### Return type

[**ModerationDetailEnvelope**](ModerationDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

