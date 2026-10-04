# materyalph_api_client.api.VendorDisputesApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**addVendorDisputeEvidence**](VendorDisputesApi.md#addvendordisputeevidence) | **POST** /vendor/disputes/{caseId}/evidence |
[**answerVendorDisputeClarification**](VendorDisputesApi.md#answervendordisputeclarification) | **POST** /vendor/disputes/{caseId}/clarifications/{clarificationId}/answer |
[**answerVendorDisputeProposal**](VendorDisputesApi.md#answervendordisputeproposal) | **POST** /vendor/disputes/{caseId}/proposals/{proposalId}/answer |
[**appealVendorDispute**](VendorDisputesApi.md#appealvendordispute) | **POST** /vendor/disputes/{caseId}/appeal |
[**authorizeVendorDisputeChannel**](VendorDisputesApi.md#authorizevendordisputechannel) | **POST** /vendor/disputes/realtime/auth |
[**downloadVendorDisputeExport**](VendorDisputesApi.md#downloadvendordisputeexport) | **GET** /vendor/disputes/exports/{exportId}/download |
[**escalateVendorDispute**](VendorDisputesApi.md#escalatevendordispute) | **POST** /vendor/disputes/{caseId}/escalate |
[**fileVendorDispute**](VendorDisputesApi.md#filevendordispute) | **POST** /vendor/disputes |
[**getVendorDispute**](VendorDisputesApi.md#getvendordispute) | **GET** /vendor/disputes/{caseId} |
[**getVendorDisputeEligibility**](VendorDisputesApi.md#getvendordisputeeligibility) | **GET** /vendor/orders/{orderId}/dispute-eligibility |
[**getVendorDisputeEvidenceFile**](VendorDisputesApi.md#getvendordisputeevidencefile) | **GET** /vendor/disputes/{caseId}/files/{fileId}/content |
[**getVendorDisputeRealtime**](VendorDisputesApi.md#getvendordisputerealtime) | **GET** /vendor/disputes/realtime |
[**listVendorDisputeExports**](VendorDisputesApi.md#listvendordisputeexports) | **GET** /vendor/disputes/exports |
[**listVendorDisputes**](VendorDisputesApi.md#listvendordisputes) | **GET** /vendor/disputes |
[**proposeVendorDisputeResolution**](VendorDisputesApi.md#proposevendordisputeresolution) | **POST** /vendor/disputes/{caseId}/proposals |
[**recordVendorDisputeReplacement**](VendorDisputesApi.md#recordvendordisputereplacement) | **POST** /vendor/disputes/{caseId}/remedies/{remedyId}/record |
[**requestVendorDisputeExport**](VendorDisputesApi.md#requestvendordisputeexport) | **POST** /vendor/disputes/exports |
[**respondVendorDispute**](VendorDisputesApi.md#respondvendordispute) | **POST** /vendor/disputes/{caseId}/respond |
[**sendVendorDisputeMessage**](VendorDisputesApi.md#sendvendordisputemessage) | **POST** /vendor/disputes/{caseId}/messages |


# **addVendorDisputeEvidence**
> DisputeDetailEnvelope addVendorDisputeEvidence(caseId, idempotencyKey, files, description)



Labeled supplemental evidence; the original complaint is never edited.

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

final api = MateryalphApiClient().getVendorDisputesApi();
final String caseId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final BuiltList<MultipartFile> files = /path/to/file.txt; // BuiltList<MultipartFile> | Labeled supplemental (or assigned Fulfillment Staff fulfillment) evidence; the original complaint is never edited.
final String description = description_example; // String |

try {
    final response = api.addVendorDisputeEvidence(caseId, idempotencyKey, files, description);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorDisputesApi->addVendorDisputeEvidence: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **caseId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **files** | [**BuiltList&lt;MultipartFile&gt;**](MultipartFile.md)| Labeled supplemental (or assigned Fulfillment Staff fulfillment) evidence; the original complaint is never edited. |
 **description** | **String**|  | [optional]

### Return type

[**DisputeDetailEnvelope**](DisputeDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **answerVendorDisputeClarification**
> DisputeDetailEnvelope answerVendorDisputeClarification(caseId, clarificationId, idempotencyKey, response, files)



Answer an Admin clarification within 24 hours.

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

final api = MateryalphApiClient().getVendorDisputesApi();
final String caseId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String clarificationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String response = response_example; // String |
final BuiltList<MultipartFile> files = /path/to/file.txt; // BuiltList<MultipartFile> | Optional supporting files.

try {
    final response = api.answerVendorDisputeClarification(caseId, clarificationId, idempotencyKey, response, files);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorDisputesApi->answerVendorDisputeClarification: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **caseId** | **String**|  |
 **clarificationId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **response** | **String**|  |
 **files** | [**BuiltList&lt;MultipartFile&gt;**](MultipartFile.md)| Optional supporting files. | [optional]

### Return type

[**DisputeDetailEnvelope**](DisputeDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **answerVendorDisputeProposal**
> DisputeDetailEnvelope answerVendorDisputeProposal(caseId, proposalId, idempotencyKey, disputeProposalAnswer)



The other party accepts or rejects. Acceptance records the agreement as a final decision; a money agreement creates one DISPUTE_CONCLUSION refund per original payment and the case resolves only when it completes.

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

final api = MateryalphApiClient().getVendorDisputesApi();
final String caseId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String proposalId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final DisputeProposalAnswer disputeProposalAnswer = ; // DisputeProposalAnswer |

try {
    final response = api.answerVendorDisputeProposal(caseId, proposalId, idempotencyKey, disputeProposalAnswer);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorDisputesApi->answerVendorDisputeProposal: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **caseId** | **String**|  |
 **proposalId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **disputeProposalAnswer** | [**DisputeProposalAnswer**](DisputeProposalAnswer.md)|  |

### Return type

[**DisputeDetailEnvelope**](DisputeDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **appealVendorDispute**
> DisputeDetailEnvelope appealVendorDispute(caseId, idempotencyKey, grounds, statement, files)



The case's one appeal, within five business days of an Admin decision, with new evidence or a material process error.

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

final api = MateryalphApiClient().getVendorDisputesApi();
final String caseId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String grounds = grounds_example; // String |
final String statement = statement_example; // String |
final BuiltList<MultipartFile> files = /path/to/file.txt; // BuiltList<MultipartFile> | Required for NEW_EVIDENCE.

try {
    final response = api.appealVendorDispute(caseId, idempotencyKey, grounds, statement, files);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorDisputesApi->appealVendorDispute: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **caseId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **grounds** | **String**|  |
 **statement** | **String**|  |
 **files** | [**BuiltList&lt;MultipartFile&gt;**](MultipartFile.md)| Required for NEW_EVIDENCE. | [optional]

### Return type

[**DisputeDetailEnvelope**](DisputeDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authorizeVendorDisputeChannel**
> BuiltMap<String, JsonObject> authorizeVendorDisputeChannel(disputeChannelAuthRequest)



Authorize the current dispute channel; a stale or revoked channel is refused.

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

final api = MateryalphApiClient().getVendorDisputesApi();
final DisputeChannelAuthRequest disputeChannelAuthRequest = ; // DisputeChannelAuthRequest |

try {
    final response = api.authorizeVendorDisputeChannel(disputeChannelAuthRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorDisputesApi->authorizeVendorDisputeChannel: $e\n');
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

# **downloadVendorDisputeExport**
> Uint8List downloadVendorDisputeExport(exportId)



Download a ready, unexpired export (audited).

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

final api = MateryalphApiClient().getVendorDisputesApi();
final String exportId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.downloadVendorDisputeExport(exportId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorDisputesApi->downloadVendorDisputeExport: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **exportId** | **String**|  |

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/csv, application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **escalateVendorDispute**
> DisputeDetailEnvelope escalateVendorDispute(caseId, idempotencyKey, disputeEscalateRequest)



Ask for Admin review during mutual resolution (or as the responding party).

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

final api = MateryalphApiClient().getVendorDisputesApi();
final String caseId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final DisputeEscalateRequest disputeEscalateRequest = ; // DisputeEscalateRequest |

try {
    final response = api.escalateVendorDispute(caseId, idempotencyKey, disputeEscalateRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorDisputesApi->escalateVendorDispute: $e\n');
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

# **fileVendorDispute**
> DisputeDetailEnvelope fileVendorDispute(idempotencyKey, orderId, issueType, requestedRemedy, description, requestedAmountCentavos, affectedLineIds, preferredContactChannel, files)



File a structured case. Creates a Case ID and the dispute state only — never a refund or REFUND_PENDING. A transaction case opens from PROCESSING; a post-completion return within seven days after COMPLETED. An active case on the order returns 409 DISPUTE_ALREADY_OPEN with its id.

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

final api = MateryalphApiClient().getVendorDisputesApi();
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String issueType = issueType_example; // String |
final String requestedRemedy = requestedRemedy_example; // String |
final String description = description_example; // String |
final int requestedAmountCentavos = 56; // int | Required for PARTIAL_REFUND; at most the affected lines less earlier refunds.
final BuiltList<String> affectedLineIds = ; // BuiltList<String> |
final String preferredContactChannel = preferredContactChannel_example; // String |
final BuiltList<MultipartFile> files = /path/to/file.txt; // BuiltList<MultipartFile> | Up to five JPG, PNG or PDF files, validated and scanned, stored privately.

try {
    final response = api.fileVendorDispute(idempotencyKey, orderId, issueType, requestedRemedy, description, requestedAmountCentavos, affectedLineIds, preferredContactChannel, files);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorDisputesApi->fileVendorDispute: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String**|  |
 **orderId** | **String**|  |
 **issueType** | **String**|  |
 **requestedRemedy** | **String**|  |
 **description** | **String**|  |
 **requestedAmountCentavos** | **int**| Required for PARTIAL_REFUND; at most the affected lines less earlier refunds. | [optional]
 **affectedLineIds** | [**BuiltList&lt;String&gt;**](String.md)|  | [optional]
 **preferredContactChannel** | **String**|  | [optional]
 **files** | [**BuiltList&lt;MultipartFile&gt;**](MultipartFile.md)| Up to five JPG, PNG or PDF files, validated and scanned, stored privately. | [optional]

### Return type

[**DisputeDetailEnvelope**](DisputeDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVendorDispute**
> DisputeDetailEnvelope getVendorDispute(caseId)



The case with its single chronological timeline, signed evidence links, deadlines and server-computed actions.

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

final api = MateryalphApiClient().getVendorDisputesApi();
final String caseId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getVendorDispute(caseId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorDisputesApi->getVendorDispute: $e\n');
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

# **getVendorDisputeEligibility**
> DisputeEligibilityEnvelope getVendorDisputeEligibility(orderId)



Whether a case can be filed, the read-only masked original payment method and the affected-line amounts. Never a refund destination.

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

final api = MateryalphApiClient().getVendorDisputesApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getVendorDisputeEligibility(orderId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorDisputesApi->getVendorDisputeEligibility: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |

### Return type

[**DisputeEligibilityEnvelope**](DisputeEligibilityEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVendorDisputeEvidenceFile**
> Uint8List getVendorDisputeEvidenceFile(caseId, fileId, expires, signature)



Evidence bytes behind a five-minute signed link; the caller is re-authorized against the case.

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

final api = MateryalphApiClient().getVendorDisputesApi();
final String caseId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String fileId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final int expires = 56; // int |
final String signature = signature_example; // String |

try {
    final response = api.getVendorDisputeEvidenceFile(caseId, fileId, expires, signature);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorDisputesApi->getVendorDisputeEvidenceFile: $e\n');
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

# **getVendorDisputeRealtime**
> DisputeRealtimeEnvelope getVendorDisputeRealtime()



The caller's private dispute channel. Its name changes whenever the caller's access changes; only \"case changed\" signals travel over it.

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

final api = MateryalphApiClient().getVendorDisputesApi();

try {
    final response = api.getVendorDisputeRealtime();
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorDisputesApi->getVendorDisputeRealtime: $e\n');
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

# **listVendorDisputeExports**
> DisputeExportListEnvelope listVendorDisputeExports()



Your recent case exports.

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

final api = MateryalphApiClient().getVendorDisputesApi();

try {
    final response = api.listVendorDisputeExports();
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorDisputesApi->listVendorDisputeExports: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**DisputeExportListEnvelope**](DisputeExportListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listVendorDisputes**
> DisputeListEnvelope listVendorDisputes(group, q, page)



Owner and Store Manager; Store Staff and Customer Service while the Owner's staff dispute flag is on (403 otherwise); assigned Fulfillment Staff see a limited case and add fulfillment evidence only; Inventory Staff are denied. Paginated, active first.

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

final api = MateryalphApiClient().getVendorDisputesApi();
final String group = group_example; // String |
final String q = q_example; // String |
final int page = 56; // int |

try {
    final response = api.listVendorDisputes(group, q, page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorDisputesApi->listVendorDisputes: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group** | **String**|  | [optional]
 **q** | **String**|  | [optional]
 **page** | **int**|  | [optional]

### Return type

[**DisputeListEnvelope**](DisputeListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **proposeVendorDisputeResolution**
> DisputeDetailEnvelope proposeVendorDisputeResolution(caseId, idempotencyKey, disputeProposalRequest)



Propose a remedy during mutual resolution; it supersedes your earlier open proposal. Vendor refund proposals are Owner-only.

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

final api = MateryalphApiClient().getVendorDisputesApi();
final String caseId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final DisputeProposalRequest disputeProposalRequest = ; // DisputeProposalRequest |

try {
    final response = api.proposeVendorDisputeResolution(caseId, idempotencyKey, disputeProposalRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorDisputesApi->proposeVendorDisputeResolution: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **caseId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **disputeProposalRequest** | [**DisputeProposalRequest**](DisputeProposalRequest.md)|  |

### Return type

[**DisputeDetailEnvelope**](DisputeDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **recordVendorDisputeReplacement**
> DisputeDetailEnvelope recordVendorDisputeReplacement(caseId, remedyId, idempotencyKey, note, files)



Record the replacement; the Buyer confirms it.

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

final api = MateryalphApiClient().getVendorDisputesApi();
final String caseId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String remedyId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String note = note_example; // String |
final BuiltList<MultipartFile> files = /path/to/file.txt; // BuiltList<MultipartFile> | Optional proof of the replacement.

try {
    final response = api.recordVendorDisputeReplacement(caseId, remedyId, idempotencyKey, note, files);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorDisputesApi->recordVendorDisputeReplacement: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **caseId** | **String**|  |
 **remedyId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **note** | **String**|  |
 **files** | [**BuiltList&lt;MultipartFile&gt;**](MultipartFile.md)| Optional proof of the replacement. | [optional]

### Return type

[**DisputeDetailEnvelope**](DisputeDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **requestVendorDisputeExport**
> DisputeExportEnvelope requestVendorDisputeExport(disputeExportRequest)



Queue a CSV of case headers. The job re-checks access when it runs and on download; switching the staff dispute flag off revokes staff exports.

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

final api = MateryalphApiClient().getVendorDisputesApi();
final DisputeExportRequest disputeExportRequest = ; // DisputeExportRequest |

try {
    final response = api.requestVendorDisputeExport(disputeExportRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorDisputesApi->requestVendorDisputeExport: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **disputeExportRequest** | [**DisputeExportRequest**](DisputeExportRequest.md)|  |

### Return type

[**DisputeExportEnvelope**](DisputeExportEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **respondVendorDispute**
> DisputeDetailEnvelope respondVendorDispute(caseId, idempotencyKey, position, body, amountCentavos, files)



The responding party answers within 48 hours. A response opens 72 hours of mutual resolution; REQUEST_ADMIN_REVIEW escalates. A late response returns 409 RESPONSE_WINDOW_CLOSED.

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

final api = MateryalphApiClient().getVendorDisputesApi();
final String caseId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String position = position_example; // String |
final String body = body_example; // String |
final int amountCentavos = 56; // int | OFFER_REFUND only; omit for a full refund. Vendor refund offers are Owner-only.
final BuiltList<MultipartFile> files = /path/to/file.txt; // BuiltList<MultipartFile> | Evidence; required to REJECT_WITH_EVIDENCE.

try {
    final response = api.respondVendorDispute(caseId, idempotencyKey, position, body, amountCentavos, files);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorDisputesApi->respondVendorDispute: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **caseId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **position** | **String**|  |
 **body** | **String**|  |
 **amountCentavos** | **int**| OFFER_REFUND only; omit for a full refund. Vendor refund offers are Owner-only. | [optional]
 **files** | [**BuiltList&lt;MultipartFile&gt;**](MultipartFile.md)| Evidence; required to REJECT_WITH_EVIDENCE. | [optional]

### Return type

[**DisputeDetailEnvelope**](DisputeDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **sendVendorDisputeMessage**
> DisputeDetailEnvelope sendVendorDisputeMessage(caseId, idempotencyKey, disputeMessageRequest)



A case message, appended to the timeline.

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

final api = MateryalphApiClient().getVendorDisputesApi();
final String caseId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final DisputeMessageRequest disputeMessageRequest = ; // DisputeMessageRequest |

try {
    final response = api.sendVendorDisputeMessage(caseId, idempotencyKey, disputeMessageRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorDisputesApi->sendVendorDisputeMessage: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **caseId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **disputeMessageRequest** | [**DisputeMessageRequest**](DisputeMessageRequest.md)|  |

### Return type

[**DisputeDetailEnvelope**](DisputeDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

