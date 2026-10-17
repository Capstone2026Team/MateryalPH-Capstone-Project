# materyalph_api_client.api.AdminEnforcementApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**applyEnforcementAction**](AdminEnforcementApi.md#applyenforcementaction) | **POST** /admin/enforcement/{actionId}/apply |
[**declineEnforcementAction**](AdminEnforcementApi.md#declineenforcementaction) | **POST** /admin/enforcement/{actionId}/decline |
[**getEnforcementAction**](AdminEnforcementApi.md#getenforcementaction) | **GET** /admin/enforcement/{actionId} |
[**getEnforcementSubject**](AdminEnforcementApi.md#getenforcementsubject) | **GET** /admin/enforcement/subjects/{type}/{subjectId} |
[**liftEnforcementAction**](AdminEnforcementApi.md#liftenforcementaction) | **POST** /admin/enforcement/{actionId}/lift |
[**listEnforcementActions**](AdminEnforcementApi.md#listenforcementactions) | **GET** /admin/enforcement |
[**recordEnforcementAction**](AdminEnforcementApi.md#recordenforcementaction) | **POST** /admin/enforcement |
[**searchEnforcementSubjects**](AdminEnforcementApi.md#searchenforcementsubjects) | **GET** /admin/enforcement/subjects |


# **applyEnforcementAction**
> EnforcementDetailEnvelope applyEnforcementAction(actionId, enforcementApplyRequest)



enforcement.apply (ban: enforcement.ban plus recent re-authentication). Apply a referred sanction; 409 on a stale lock_version.

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

final api = MateryalphApiClient().getAdminEnforcementApi();
final String actionId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final EnforcementApplyRequest enforcementApplyRequest = ; // EnforcementApplyRequest |

try {
    final response = api.applyEnforcementAction(actionId, enforcementApplyRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminEnforcementApi->applyEnforcementAction: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **actionId** | **String**|  |
 **enforcementApplyRequest** | [**EnforcementApplyRequest**](EnforcementApplyRequest.md)|  |

### Return type

[**EnforcementDetailEnvelope**](EnforcementDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **declineEnforcementAction**
> EnforcementDetailEnvelope declineEnforcementAction(actionId, reasonedVersionRequest)



enforcement.apply. Decline a referred sanction with a reason.

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

final api = MateryalphApiClient().getAdminEnforcementApi();
final String actionId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ReasonedVersionRequest reasonedVersionRequest = ; // ReasonedVersionRequest |

try {
    final response = api.declineEnforcementAction(actionId, reasonedVersionRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminEnforcementApi->declineEnforcementAction: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **actionId** | **String**|  |
 **reasonedVersionRequest** | [**ReasonedVersionRequest**](ReasonedVersionRequest.md)|  |

### Return type

[**EnforcementDetailEnvelope**](EnforcementDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getEnforcementAction**
> EnforcementDetailEnvelope getEnforcementAction(actionId)



enforcement.view. Sanction, subject review, append-only events and the actions your role may take.

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

final api = MateryalphApiClient().getAdminEnforcementApi();
final String actionId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getEnforcementAction(actionId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminEnforcementApi->getEnforcementAction: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **actionId** | **String**|  |

### Return type

[**EnforcementDetailEnvelope**](EnforcementDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getEnforcementSubject**
> EnforcementSubjectEnvelope getEnforcementSubject(type, subjectId)



enforcement.view. Account-review facts and the sanction history of one Buyer or Vendor.

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

final api = MateryalphApiClient().getAdminEnforcementApi();
final String type = type_example; // String |
final String subjectId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getEnforcementSubject(type, subjectId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminEnforcementApi->getEnforcementSubject: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **type** | **String**|  |
 **subjectId** | **String**|  |

### Return type

[**EnforcementSubjectEnvelope**](EnforcementSubjectEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **liftEnforcementAction**
> EnforcementDetailEnvelope liftEnforcementAction(actionId, reasonedVersionRequest)



enforcement.apply (ban: enforcement.ban plus recent re-authentication). Lift an applied sanction; a store returns to READY or NOT_READY, never ACTIVE.

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

final api = MateryalphApiClient().getAdminEnforcementApi();
final String actionId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ReasonedVersionRequest reasonedVersionRequest = ; // ReasonedVersionRequest |

try {
    final response = api.liftEnforcementAction(actionId, reasonedVersionRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminEnforcementApi->liftEnforcementAction: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **actionId** | **String**|  |
 **reasonedVersionRequest** | [**ReasonedVersionRequest**](ReasonedVersionRequest.md)|  |

### Return type

[**EnforcementDetailEnvelope**](EnforcementDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listEnforcementActions**
> EnforcementListEnvelope listEnforcementActions(state, subjectType, action, source_, subjectId, page, from, to)



enforcement.view (Super Admin, User Management, Order and Dispute read-only). Referred sanctions first, oldest first.

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

final api = MateryalphApiClient().getAdminEnforcementApi();
final String state = state_example; // String |
final String subjectType = subjectType_example; // String |
final String action = action_example; // String |
final String source_ = source__example; // String |
final String subjectId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final int page = 56; // int |
final Date from = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Action created_at.
final Date to = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Action created_at.

try {
    final response = api.listEnforcementActions(state, subjectType, action, source_, subjectId, page, from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminEnforcementApi->listEnforcementActions: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **state** | **String**|  | [optional]
 **subjectType** | **String**|  | [optional]
 **action** | **String**|  | [optional]
 **source_** | **String**|  | [optional]
 **subjectId** | **String**|  | [optional]
 **page** | **int**|  | [optional]
 **from** | **Date**| Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Action created_at. | [optional]
 **to** | **Date**| Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Action created_at. | [optional]

### Return type

[**EnforcementListEnvelope**](EnforcementListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **recordEnforcementAction**
> EnforcementDetailEnvelope recordEnforcementAction(idempotencyKey, enforcementRecordRequest)



enforcement.apply. Record a Warning or apply a restriction, suspension or (Super Admin) ban with a reason, restoration condition and continuation plan for open orders.

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

final api = MateryalphApiClient().getAdminEnforcementApi();
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final EnforcementRecordRequest enforcementRecordRequest = ; // EnforcementRecordRequest |

try {
    final response = api.recordEnforcementAction(idempotencyKey, enforcementRecordRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminEnforcementApi->recordEnforcementAction: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String**|  |
 **enforcementRecordRequest** | [**EnforcementRecordRequest**](EnforcementRecordRequest.md)|  |

### Return type

[**EnforcementDetailEnvelope**](EnforcementDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchEnforcementSubjects**
> EnforcementSubjectMatchListEnvelope searchEnforcementSubjects(type, q)



enforcement.view. A Vendor by store name or a Buyer by exact account email; minimal identity only.

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

final api = MateryalphApiClient().getAdminEnforcementApi();
final String type = type_example; // String |
final String q = q_example; // String |

try {
    final response = api.searchEnforcementSubjects(type, q);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminEnforcementApi->searchEnforcementSubjects: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **type** | **String**|  |
 **q** | **String**|  |

### Return type

[**EnforcementSubjectMatchListEnvelope**](EnforcementSubjectMatchListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

