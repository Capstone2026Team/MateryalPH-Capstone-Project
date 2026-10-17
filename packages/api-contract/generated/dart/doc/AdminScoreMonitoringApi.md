# materyalph_api_client.api.AdminScoreMonitoringApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**excludeAdminScoreSource**](AdminScoreMonitoringApi.md#excludeadminscoresource) | **POST** /admin/scores/{vendorId}/exclusions |
[**getAdminScore**](AdminScoreMonitoringApi.md#getadminscore) | **GET** /admin/scores/{vendorId} |
[**liftAdminBadgeSuppression**](AdminScoreMonitoringApi.md#liftadminbadgesuppression) | **POST** /admin/scores/badge-suppressions/{suppressionId}/lift |
[**listAdminScores**](AdminScoreMonitoringApi.md#listadminscores) | **GET** /admin/scores |
[**revokeAdminScoreExclusion**](AdminScoreMonitoringApi.md#revokeadminscoreexclusion) | **POST** /admin/scores/exclusions/{exclusionId}/revoke |
[**suppressAdminBadge**](AdminScoreMonitoringApi.md#suppressadminbadge) | **POST** /admin/scores/{vendorId}/badge-suppressions |


# **excludeAdminScoreSource**
> AdminScoreDetailEnvelope excludeAdminScoreSource(vendorId, idempotencyKey, scoreExclusionRequest)



scores.investigate. Reversibly exclude one order (fraud, duplicate, test, invalid source) from later snapshots.

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

final api = MateryalphApiClient().getAdminScoreMonitoringApi();
final String vendorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ScoreExclusionRequest scoreExclusionRequest = ; // ScoreExclusionRequest |

try {
    final response = api.excludeAdminScoreSource(vendorId, idempotencyKey, scoreExclusionRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminScoreMonitoringApi->excludeAdminScoreSource: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **vendorId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **scoreExclusionRequest** | [**ScoreExclusionRequest**](ScoreExclusionRequest.md)|  |

### Return type

[**AdminScoreDetailEnvelope**](AdminScoreDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAdminScore**
> AdminScoreDetailEnvelope getAdminScore(vendorId, metric, page)



scores.view. Components, sample sizes, windows, badge history, suppressions, exclusions and paginated source events.

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

final api = MateryalphApiClient().getAdminScoreMonitoringApi();
final String vendorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String metric = metric_example; // String |
final int page = 56; // int |

try {
    final response = api.getAdminScore(vendorId, metric, page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminScoreMonitoringApi->getAdminScore: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **vendorId** | **String**|  |
 **metric** | **String**|  | [optional]
 **page** | **int**|  | [optional]

### Return type

[**AdminScoreDetailEnvelope**](AdminScoreDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **liftAdminBadgeSuppression**
> InvestigationAckEnvelope liftAdminBadgeSuppression(suppressionId, idempotencyKey, investigationReasonRequest)



scores.investigate. Lift a suppression with a reason.

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

final api = MateryalphApiClient().getAdminScoreMonitoringApi();
final String suppressionId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final InvestigationReasonRequest investigationReasonRequest = ; // InvestigationReasonRequest |

try {
    final response = api.liftAdminBadgeSuppression(suppressionId, idempotencyKey, investigationReasonRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminScoreMonitoringApi->liftAdminBadgeSuppression: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **suppressionId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **investigationReasonRequest** | [**InvestigationReasonRequest**](InvestigationReasonRequest.md)|  |

### Return type

[**InvestigationAckEnvelope**](InvestigationAckEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAdminScores**
> AdminScoreListEnvelope listAdminScores(q, page)



scores.view (Super Admin, User Management Staff, Order and Dispute Staff).

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

final api = MateryalphApiClient().getAdminScoreMonitoringApi();
final String q = q_example; // String |
final int page = 56; // int |

try {
    final response = api.listAdminScores(q, page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminScoreMonitoringApi->listAdminScores: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **q** | **String**|  | [optional]
 **page** | **int**|  | [optional]

### Return type

[**AdminScoreListEnvelope**](AdminScoreListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **revokeAdminScoreExclusion**
> InvestigationAckEnvelope revokeAdminScoreExclusion(exclusionId, idempotencyKey, investigationReasonRequest)



scores.investigate. Reverse an exclusion with a reason.

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

final api = MateryalphApiClient().getAdminScoreMonitoringApi();
final String exclusionId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final InvestigationReasonRequest investigationReasonRequest = ; // InvestigationReasonRequest |

try {
    final response = api.revokeAdminScoreExclusion(exclusionId, idempotencyKey, investigationReasonRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminScoreMonitoringApi->revokeAdminScoreExclusion: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **exclusionId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **investigationReasonRequest** | [**InvestigationReasonRequest**](InvestigationReasonRequest.md)|  |

### Return type

[**InvestigationAckEnvelope**](InvestigationAckEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **suppressAdminBadge**
> AdminScoreDetailEnvelope suppressAdminBadge(vendorId, idempotencyKey, badgeSuppressionRequest)



scores.investigate. Suppress a badge's display for a documented fraud or compliance case. Admins can never award a badge.

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

final api = MateryalphApiClient().getAdminScoreMonitoringApi();
final String vendorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final BadgeSuppressionRequest badgeSuppressionRequest = ; // BadgeSuppressionRequest |

try {
    final response = api.suppressAdminBadge(vendorId, idempotencyKey, badgeSuppressionRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminScoreMonitoringApi->suppressAdminBadge: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **vendorId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **badgeSuppressionRequest** | [**BadgeSuppressionRequest**](BadgeSuppressionRequest.md)|  |

### Return type

[**AdminScoreDetailEnvelope**](AdminScoreDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

