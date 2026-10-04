# materyalph_api_client.api.AdminDisputesApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**assignAdminDispute**](AdminDisputesApi.md#assignadmindispute) | **POST** /admin/disputes/{caseId}/assign |
[**authorizeAdminDisputeChannel**](AdminDisputesApi.md#authorizeadmindisputechannel) | **POST** /admin/disputes/realtime/auth |
[**confirmAdminDisputeRemedy**](AdminDisputesApi.md#confirmadmindisputeremedy) | **POST** /admin/disputes/{caseId}/remedies/{remedyId}/confirm |
[**decideAdminDispute**](AdminDisputesApi.md#decideadmindispute) | **POST** /admin/disputes/{caseId}/decision |
[**decideAdminDisputeAppeal**](AdminDisputesApi.md#decideadmindisputeappeal) | **POST** /admin/disputes/{caseId}/appeal-decision |
[**escalateAdminDispute**](AdminDisputesApi.md#escalateadmindispute) | **POST** /admin/disputes/{caseId}/escalate |
[**getAdminDispute**](AdminDisputesApi.md#getadmindispute) | **GET** /admin/disputes/{caseId} |
[**getAdminDisputeEvidenceFile**](AdminDisputesApi.md#getadmindisputeevidencefile) | **GET** /admin/disputes/{caseId}/files/{fileId}/content |
[**getAdminDisputeRealtime**](AdminDisputesApi.md#getadmindisputerealtime) | **GET** /admin/disputes/realtime |
[**listAdminDisputes**](AdminDisputesApi.md#listadmindisputes) | **GET** /admin/disputes |
[**requestAdminDisputeClarification**](AdminDisputesApi.md#requestadmindisputeclarification) | **POST** /admin/disputes/{caseId}/clarifications |


# **assignAdminDispute**
> DisputeDetailEnvelope assignAdminDispute(caseId, idempotencyKey)



disputes.decide. Take the case.

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

final api = MateryalphApiClient().getAdminDisputesApi();
final String caseId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.assignAdminDispute(caseId, idempotencyKey);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminDisputesApi->assignAdminDispute: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **caseId** | **String**|  |
 **idempotencyKey** | **String**|  |

### Return type

[**DisputeDetailEnvelope**](DisputeDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authorizeAdminDisputeChannel**
> BuiltMap<String, JsonObject> authorizeAdminDisputeChannel(disputeChannelAuthRequest)



Authorize the current dispute channel.

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

final api = MateryalphApiClient().getAdminDisputesApi();
final DisputeChannelAuthRequest disputeChannelAuthRequest = ; // DisputeChannelAuthRequest |

try {
    final response = api.authorizeAdminDisputeChannel(disputeChannelAuthRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminDisputesApi->authorizeAdminDisputeChannel: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **disputeChannelAuthRequest** | [**DisputeChannelAuthRequest**](DisputeChannelAuthRequest.md)|  |

### Return type

[**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **confirmAdminDisputeRemedy**
> DisputeDetailEnvelope confirmAdminDisputeRemedy(caseId, remedyId, idempotencyKey, disputeRemedyConfirmRequest)



disputes.decide. Reasoned confirmation of a recorded replacement the Buyer did not acknowledge.

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

final api = MateryalphApiClient().getAdminDisputesApi();
final String caseId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String remedyId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final DisputeRemedyConfirmRequest disputeRemedyConfirmRequest = ; // DisputeRemedyConfirmRequest |

try {
    final response = api.confirmAdminDisputeRemedy(caseId, remedyId, idempotencyKey, disputeRemedyConfirmRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminDisputesApi->confirmAdminDisputeRemedy: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **caseId** | **String**|  |
 **remedyId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **disputeRemedyConfirmRequest** | [**DisputeRemedyConfirmRequest**](DisputeRemedyConfirmRequest.md)|  |

### Return type

[**DisputeDetailEnvelope**](DisputeDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **decideAdminDispute**
> DisputeDetailEnvelope decideAdminDispute(caseId, idempotencyKey, adminDisputeDecisionRequest)



disputes.decide. A new immutable decision version with the remedy, reason and conflict check. A money award executes now when immediately enforceable, otherwise after the appeal window lapses.

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

final api = MateryalphApiClient().getAdminDisputesApi();
final String caseId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final AdminDisputeDecisionRequest adminDisputeDecisionRequest = ; // AdminDisputeDecisionRequest |

try {
    final response = api.decideAdminDispute(caseId, idempotencyKey, adminDisputeDecisionRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminDisputesApi->decideAdminDispute: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **caseId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **adminDisputeDecisionRequest** | [**AdminDisputeDecisionRequest**](AdminDisputeDecisionRequest.md)|  |

### Return type

[**DisputeDetailEnvelope**](DisputeDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **decideAdminDisputeAppeal**
> DisputeDetailEnvelope decideAdminDisputeAppeal(caseId, idempotencyKey, adminDisputeAppealDecisionRequest)



disputes.decide by a different Admin than the appealed decision. Affirmed, Modified or Reversed; final.

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

final api = MateryalphApiClient().getAdminDisputesApi();
final String caseId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final AdminDisputeAppealDecisionRequest adminDisputeAppealDecisionRequest = ; // AdminDisputeAppealDecisionRequest |

try {
    final response = api.decideAdminDisputeAppeal(caseId, idempotencyKey, adminDisputeAppealDecisionRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminDisputesApi->decideAdminDisputeAppeal: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **caseId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **adminDisputeAppealDecisionRequest** | [**AdminDisputeAppealDecisionRequest**](AdminDisputeAppealDecisionRequest.md)|  |

### Return type

[**DisputeDetailEnvelope**](DisputeDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **escalateAdminDispute**
> DisputeDetailEnvelope escalateAdminDispute(caseId, idempotencyKey, disputeEscalateRequest)



disputes.decide. Direct safety or compliance escalation.

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

final api = MateryalphApiClient().getAdminDisputesApi();
final String caseId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final DisputeEscalateRequest disputeEscalateRequest = ; // DisputeEscalateRequest |

try {
    final response = api.escalateAdminDispute(caseId, idempotencyKey, disputeEscalateRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminDisputesApi->escalateAdminDispute: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **caseId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **disputeEscalateRequest** | [**DisputeEscalateRequest**](DisputeEscalateRequest.md)|  |

### Return type

[**DisputeDetailEnvelope**](DisputeDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAdminDispute**
> DisputeDetailEnvelope getAdminDispute(caseId)



disputes.view. The case with decision support.

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

final api = MateryalphApiClient().getAdminDisputesApi();
final String caseId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getAdminDispute(caseId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminDisputesApi->getAdminDispute: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **caseId** | **String**|  |

### Return type

[**DisputeDetailEnvelope**](DisputeDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAdminDisputeEvidenceFile**
> Uint8List getAdminDisputeEvidenceFile(caseId, fileId, expires, signature)



disputes.view. Evidence behind a signed link.

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

final api = MateryalphApiClient().getAdminDisputesApi();
final String caseId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String fileId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final int expires = 56; // int |
final String signature = signature_example; // String |

try {
    final response = api.getAdminDisputeEvidenceFile(caseId, fileId, expires, signature);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminDisputesApi->getAdminDisputeEvidenceFile: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **caseId** | **String**|  |
 **fileId** | **String**|  |
 **expires** | **int**|  |
 **signature** | **String**|  |

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: image/png, image/jpeg, application/pdf, application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAdminDisputeRealtime**
> DisputeRealtimeEnvelope getAdminDisputeRealtime()



disputes.view. The caller's dispute channel.

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

final api = MateryalphApiClient().getAdminDisputesApi();

try {
    final response = api.getAdminDisputeRealtime();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminDisputesApi->getAdminDisputeRealtime: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**DisputeRealtimeEnvelope**](DisputeRealtimeEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAdminDisputes**
> DisputeListEnvelope listAdminDisputes(status, page)



disputes.view. Case ID, order, parties, issue, handler, deadline, status, requested remedy and refund state.

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

final api = MateryalphApiClient().getAdminDisputesApi();
final String status = status_example; // String |
final int page = 56; // int |

try {
    final response = api.listAdminDisputes(status, page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminDisputesApi->listAdminDisputes: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional]
 **page** | **int**|  | [optional]

### Return type

[**DisputeListEnvelope**](DisputeListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **requestAdminDisputeClarification**
> DisputeDetailEnvelope requestAdminDisputeClarification(caseId, idempotencyKey, adminDisputeClarificationRequest)



disputes.decide. Structured question with a 24-hour deadline per requested party.

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

final api = MateryalphApiClient().getAdminDisputesApi();
final String caseId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final AdminDisputeClarificationRequest adminDisputeClarificationRequest = ; // AdminDisputeClarificationRequest |

try {
    final response = api.requestAdminDisputeClarification(caseId, idempotencyKey, adminDisputeClarificationRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminDisputesApi->requestAdminDisputeClarification: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **caseId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **adminDisputeClarificationRequest** | [**AdminDisputeClarificationRequest**](AdminDisputeClarificationRequest.md)|  |

### Return type

[**DisputeDetailEnvelope**](DisputeDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

