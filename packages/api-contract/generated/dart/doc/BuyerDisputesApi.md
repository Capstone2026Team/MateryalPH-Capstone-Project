# materyalph_api_client.api.BuyerDisputesApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**addBuyerDisputeEvidence**](BuyerDisputesApi.md#addbuyerdisputeevidence) | **POST** /buyers/disputes/{caseId}/evidence |
[**answerBuyerDisputeClarification**](BuyerDisputesApi.md#answerbuyerdisputeclarification) | **POST** /buyers/disputes/{caseId}/clarifications/{clarificationId}/answer |
[**answerBuyerDisputeProposal**](BuyerDisputesApi.md#answerbuyerdisputeproposal) | **POST** /buyers/disputes/{caseId}/proposals/{proposalId}/answer |
[**appealBuyerDispute**](BuyerDisputesApi.md#appealbuyerdispute) | **POST** /buyers/disputes/{caseId}/appeal |
[**authorizeBuyerDisputeChannel**](BuyerDisputesApi.md#authorizebuyerdisputechannel) | **POST** /buyers/disputes/realtime/auth |
[**confirmBuyerDisputeReplacement**](BuyerDisputesApi.md#confirmbuyerdisputereplacement) | **POST** /buyers/disputes/{caseId}/remedies/{remedyId}/confirm |
[**escalateBuyerDispute**](BuyerDisputesApi.md#escalatebuyerdispute) | **POST** /buyers/disputes/{caseId}/escalate |
[**fileBuyerDispute**](BuyerDisputesApi.md#filebuyerdispute) | **POST** /buyers/disputes |
[**getBuyerDispute**](BuyerDisputesApi.md#getbuyerdispute) | **GET** /buyers/disputes/{caseId} |
[**getBuyerDisputeEligibility**](BuyerDisputesApi.md#getbuyerdisputeeligibility) | **GET** /buyers/orders/{orderId}/dispute-eligibility |
[**getBuyerDisputeEvidenceFile**](BuyerDisputesApi.md#getbuyerdisputeevidencefile) | **GET** /buyers/disputes/{caseId}/files/{fileId}/content |
[**getBuyerDisputeRealtime**](BuyerDisputesApi.md#getbuyerdisputerealtime) | **GET** /buyers/disputes/realtime |
[**listBuyerDisputes**](BuyerDisputesApi.md#listbuyerdisputes) | **GET** /buyers/disputes |
[**proposeBuyerDisputeResolution**](BuyerDisputesApi.md#proposebuyerdisputeresolution) | **POST** /buyers/disputes/{caseId}/proposals |
[**respondBuyerDispute**](BuyerDisputesApi.md#respondbuyerdispute) | **POST** /buyers/disputes/{caseId}/respond |
[**sendBuyerDisputeMessage**](BuyerDisputesApi.md#sendbuyerdisputemessage) | **POST** /buyers/disputes/{caseId}/messages |


# **addBuyerDisputeEvidence**
> DisputeDetailEnvelope addBuyerDisputeEvidence(caseId, idempotencyKey, files, description)



Labeled supplemental evidence; the original complaint is never edited.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerDisputesApi();
final String caseId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final BuiltList<MultipartFile> files = /path/to/file.txt; // BuiltList<MultipartFile> | Labeled supplemental (or assigned Fulfillment Staff fulfillment) evidence; the original complaint is never edited.
final String description = description_example; // String |

try {
    final response = api.addBuyerDisputeEvidence(caseId, idempotencyKey, files, description);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerDisputesApi->addBuyerDisputeEvidence: $e\n');
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

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **answerBuyerDisputeClarification**
> DisputeDetailEnvelope answerBuyerDisputeClarification(caseId, clarificationId, idempotencyKey, response, files)



Answer an Admin clarification within 24 hours.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerDisputesApi();
final String caseId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String clarificationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String response = response_example; // String |
final BuiltList<MultipartFile> files = /path/to/file.txt; // BuiltList<MultipartFile> | Optional supporting files.

try {
    final response = api.answerBuyerDisputeClarification(caseId, clarificationId, idempotencyKey, response, files);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerDisputesApi->answerBuyerDisputeClarification: $e\n');
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

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **answerBuyerDisputeProposal**
> DisputeDetailEnvelope answerBuyerDisputeProposal(caseId, proposalId, idempotencyKey, disputeProposalAnswer)



The other party accepts or rejects. Acceptance records the agreement as a final decision; a money agreement creates one DISPUTE_CONCLUSION refund per original payment and the case resolves only when it completes.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerDisputesApi();
final String caseId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String proposalId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final DisputeProposalAnswer disputeProposalAnswer = ; // DisputeProposalAnswer |

try {
    final response = api.answerBuyerDisputeProposal(caseId, proposalId, idempotencyKey, disputeProposalAnswer);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerDisputesApi->answerBuyerDisputeProposal: $e\n');
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

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **appealBuyerDispute**
> DisputeDetailEnvelope appealBuyerDispute(caseId, idempotencyKey, grounds, statement, files)



The case's one appeal, within five business days of an Admin decision, with new evidence or a material process error.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerDisputesApi();
final String caseId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String grounds = grounds_example; // String |
final String statement = statement_example; // String |
final BuiltList<MultipartFile> files = /path/to/file.txt; // BuiltList<MultipartFile> | Required for NEW_EVIDENCE.

try {
    final response = api.appealBuyerDispute(caseId, idempotencyKey, grounds, statement, files);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerDisputesApi->appealBuyerDispute: $e\n');
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

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authorizeBuyerDisputeChannel**
> BuiltMap<String, JsonObject> authorizeBuyerDisputeChannel(disputeChannelAuthRequest)



Authorize the current dispute channel; a stale or revoked channel is refused.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerDisputesApi();
final DisputeChannelAuthRequest disputeChannelAuthRequest = ; // DisputeChannelAuthRequest |

try {
    final response = api.authorizeBuyerDisputeChannel(disputeChannelAuthRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerDisputesApi->authorizeBuyerDisputeChannel: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **disputeChannelAuthRequest** | [**DisputeChannelAuthRequest**](DisputeChannelAuthRequest.md)|  |

### Return type

[**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **confirmBuyerDisputeReplacement**
> DisputeDetailEnvelope confirmBuyerDisputeReplacement(caseId, remedyId, idempotencyKey)



Confirm receiving a replacement the Vendor recorded.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerDisputesApi();
final String caseId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String remedyId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.confirmBuyerDisputeReplacement(caseId, remedyId, idempotencyKey);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerDisputesApi->confirmBuyerDisputeReplacement: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **caseId** | **String**|  |
 **remedyId** | **String**|  |
 **idempotencyKey** | **String**|  |

### Return type

[**DisputeDetailEnvelope**](DisputeDetailEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **escalateBuyerDispute**
> DisputeDetailEnvelope escalateBuyerDispute(caseId, idempotencyKey, disputeEscalateRequest)



Ask for Admin review during mutual resolution (or as the responding party).

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerDisputesApi();
final String caseId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final DisputeEscalateRequest disputeEscalateRequest = ; // DisputeEscalateRequest |

try {
    final response = api.escalateBuyerDispute(caseId, idempotencyKey, disputeEscalateRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerDisputesApi->escalateBuyerDispute: $e\n');
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

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **fileBuyerDispute**
> DisputeDetailEnvelope fileBuyerDispute(idempotencyKey, orderId, issueType, requestedRemedy, description, requestedAmountCentavos, affectedLineIds, preferredContactChannel, files)



File a structured case. Creates a Case ID and the dispute state only — never a refund or REFUND_PENDING. A transaction case opens from PROCESSING; a post-completion return within seven days after COMPLETED. An active case on the order returns 409 DISPUTE_ALREADY_OPEN with its id.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerDisputesApi();
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String issueType = issueType_example; // String |
final String requestedRemedy = requestedRemedy_example; // String |
final String description = description_example; // String |
final int requestedAmountCentavos = 56; // int | Required for PARTIAL_REFUND; at most the affected lines less earlier refunds.
final BuiltList<String> affectedLineIds = ; // BuiltList<String> | Selected order lines. Multipart clients send each UUID as an affected_line_ids[] part so the server receives an array. Buyers must select at least one line for every requested remedy.
final String preferredContactChannel = preferredContactChannel_example; // String |
final BuiltList<MultipartFile> files = /path/to/file.txt; // BuiltList<MultipartFile> | Up to five JPG, PNG or PDF files, validated and scanned, stored privately. Multipart clients send each upload as a files[] part.

try {
    final response = api.fileBuyerDispute(idempotencyKey, orderId, issueType, requestedRemedy, description, requestedAmountCentavos, affectedLineIds, preferredContactChannel, files);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerDisputesApi->fileBuyerDispute: $e\n');
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
 **affectedLineIds** | [**BuiltList&lt;String&gt;**](String.md)| Selected order lines. Multipart clients send each UUID as an affected_line_ids[] part so the server receives an array. Buyers must select at least one line for every requested remedy. | [optional]
 **preferredContactChannel** | **String**|  | [optional]
 **files** | [**BuiltList&lt;MultipartFile&gt;**](MultipartFile.md)| Up to five JPG, PNG or PDF files, validated and scanned, stored privately. Multipart clients send each upload as a files[] part. | [optional]

### Return type

[**DisputeDetailEnvelope**](DisputeDetailEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getBuyerDispute**
> DisputeDetailEnvelope getBuyerDispute(caseId)



The case with its single chronological timeline, signed evidence links, deadlines and server-computed actions.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerDisputesApi();
final String caseId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getBuyerDispute(caseId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerDisputesApi->getBuyerDispute: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **caseId** | **String**|  |

### Return type

[**DisputeDetailEnvelope**](DisputeDetailEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getBuyerDisputeEligibility**
> DisputeEligibilityEnvelope getBuyerDisputeEligibility(orderId)



Whether a case can be filed, the read-only masked original payment method and the affected-line amounts. Never a refund destination.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerDisputesApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getBuyerDisputeEligibility(orderId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerDisputesApi->getBuyerDisputeEligibility: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |

### Return type

[**DisputeEligibilityEnvelope**](DisputeEligibilityEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getBuyerDisputeEvidenceFile**
> Uint8List getBuyerDisputeEvidenceFile(caseId, fileId, expires, signature)



Evidence bytes behind a five-minute signed link; the caller is re-authorized against the case.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerDisputesApi();
final String caseId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String fileId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final int expires = 56; // int |
final String signature = signature_example; // String |

try {
    final response = api.getBuyerDisputeEvidenceFile(caseId, fileId, expires, signature);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerDisputesApi->getBuyerDisputeEvidenceFile: $e\n');
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

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: image/png, image/jpeg, application/pdf, application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getBuyerDisputeRealtime**
> DisputeRealtimeEnvelope getBuyerDisputeRealtime()



The caller's private dispute channel. Its name changes whenever the caller's access changes; only \"case changed\" signals travel over it.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerDisputesApi();

try {
    final response = api.getBuyerDisputeRealtime();
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerDisputesApi->getBuyerDisputeRealtime: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**DisputeRealtimeEnvelope**](DisputeRealtimeEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listBuyerDisputes**
> DisputeListEnvelope listBuyerDisputes(group, q, page)



The Buyer's own cases. Paginated, active first.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerDisputesApi();
final String group = group_example; // String |
final String q = q_example; // String |
final int page = 56; // int |

try {
    final response = api.listBuyerDisputes(group, q, page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerDisputesApi->listBuyerDisputes: $e\n');
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

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **proposeBuyerDisputeResolution**
> DisputeDetailEnvelope proposeBuyerDisputeResolution(caseId, idempotencyKey, disputeProposalRequest)



Propose a remedy during mutual resolution; it supersedes your earlier open proposal. Vendor refund proposals are Owner-only.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerDisputesApi();
final String caseId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final DisputeProposalRequest disputeProposalRequest = ; // DisputeProposalRequest |

try {
    final response = api.proposeBuyerDisputeResolution(caseId, idempotencyKey, disputeProposalRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerDisputesApi->proposeBuyerDisputeResolution: $e\n');
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

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **respondBuyerDispute**
> DisputeDetailEnvelope respondBuyerDispute(caseId, idempotencyKey, position, body, amountCentavos, files)



The responding party answers within 48 hours. A response opens 72 hours of mutual resolution; REQUEST_ADMIN_REVIEW escalates. A late response returns 409 RESPONSE_WINDOW_CLOSED.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerDisputesApi();
final String caseId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String position = position_example; // String |
final String body = body_example; // String |
final int amountCentavos = 56; // int | OFFER_REFUND only; omit for a full refund. Vendor refund offers are Owner-only.
final BuiltList<MultipartFile> files = /path/to/file.txt; // BuiltList<MultipartFile> | Evidence; required to REJECT_WITH_EVIDENCE.

try {
    final response = api.respondBuyerDispute(caseId, idempotencyKey, position, body, amountCentavos, files);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerDisputesApi->respondBuyerDispute: $e\n');
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

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **sendBuyerDisputeMessage**
> DisputeDetailEnvelope sendBuyerDisputeMessage(caseId, idempotencyKey, disputeMessageRequest)



A case message, appended to the timeline.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerDisputesApi();
final String caseId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final DisputeMessageRequest disputeMessageRequest = ; // DisputeMessageRequest |

try {
    final response = api.sendBuyerDisputeMessage(caseId, idempotencyKey, disputeMessageRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerDisputesApi->sendBuyerDisputeMessage: $e\n');
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

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

