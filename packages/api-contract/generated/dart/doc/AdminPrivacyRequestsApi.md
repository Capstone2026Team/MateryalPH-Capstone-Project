# materyalph_api_client.api.AdminPrivacyRequestsApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getPrivacyRequest**](AdminPrivacyRequestsApi.md#getprivacyrequest) | **GET** /admin/privacy-requests/{requestId} |
[**listPrivacyRequests**](AdminPrivacyRequestsApi.md#listprivacyrequests) | **GET** /admin/privacy-requests |
[**recordPrivacyRequest**](AdminPrivacyRequestsApi.md#recordprivacyrequest) | **POST** /admin/privacy-requests |
[**transitionPrivacyRequest**](AdminPrivacyRequestsApi.md#transitionprivacyrequest) | **POST** /admin/privacy-requests/{requestId}/{command} |


# **getPrivacyRequest**
> PrivacyRequestDetailEnvelope getPrivacyRequest(requestId)



Assigned handler or privacy.manage; each opening is audited. Unassigned handlers receive 404.

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

final api = MateryalphApiClient().getAdminPrivacyRequestsApi();
final String requestId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getPrivacyRequest(requestId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminPrivacyRequestsApi->getPrivacyRequest: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **requestId** | **String**|  |

### Return type

[**PrivacyRequestDetailEnvelope**](PrivacyRequestDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listPrivacyRequests**
> PrivacyRequestListEnvelope listPrivacyRequests(state, requestType, handler, page)



privacy.manage sees every request; privacy.handle sees only requests assigned to you.

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

final api = MateryalphApiClient().getAdminPrivacyRequestsApi();
final String state = state_example; // String |
final String requestType = requestType_example; // String |
final String handler = handler_example; // String |
final int page = 56; // int |

try {
    final response = api.listPrivacyRequests(state, requestType, handler, page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminPrivacyRequestsApi->listPrivacyRequests: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **state** | **String**|  | [optional]
 **requestType** | **String**|  | [optional]
 **handler** | **String**|  | [optional]
 **page** | **int**|  | [optional]

### Return type

[**PrivacyRequestListEnvelope**](PrivacyRequestListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **recordPrivacyRequest**
> PrivacyRequestDetailEnvelope recordPrivacyRequest(idempotencyKey, privacyRequestCreateRequest)



privacy.manage. Record a request received through an official channel.

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

final api = MateryalphApiClient().getAdminPrivacyRequestsApi();
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final PrivacyRequestCreateRequest privacyRequestCreateRequest = ; // PrivacyRequestCreateRequest |

try {
    final response = api.recordPrivacyRequest(idempotencyKey, privacyRequestCreateRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminPrivacyRequestsApi->recordPrivacyRequest: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String**|  |
 **privacyRequestCreateRequest** | [**PrivacyRequestCreateRequest**](PrivacyRequestCreateRequest.md)|  |

### Return type

[**PrivacyRequestDetailEnvelope**](PrivacyRequestDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **transitionPrivacyRequest**
> PrivacyRequestDetailEnvelope transitionPrivacyRequest(requestId, command, privacyTransitionRequest)



Assign (privacy.manage), verify identity, start, complete, reject or withdraw with the current lock_version; closed requests are final.

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

final api = MateryalphApiClient().getAdminPrivacyRequestsApi();
final String requestId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String command = command_example; // String |
final PrivacyTransitionRequest privacyTransitionRequest = ; // PrivacyTransitionRequest |

try {
    final response = api.transitionPrivacyRequest(requestId, command, privacyTransitionRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminPrivacyRequestsApi->transitionPrivacyRequest: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **requestId** | **String**|  |
 **command** | **String**|  |
 **privacyTransitionRequest** | [**PrivacyTransitionRequest**](PrivacyTransitionRequest.md)|  |

### Return type

[**PrivacyRequestDetailEnvelope**](PrivacyRequestDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

