# materyalph_api_client.api.VendorFulfillmentApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**assignVendorFulfillmentStaff**](VendorFulfillmentApi.md#assignvendorfulfillmentstaff) | **POST** /vendor/orders/{orderId}/fulfillment/assignment |
[**cancelVendorOrder**](VendorFulfillmentApi.md#cancelvendororder) | **POST** /vendor/orders/{orderId}/cancel |
[**finalizeVendorCancellationRequest**](VendorFulfillmentApi.md#finalizevendorcancellationrequest) | **POST** /vendor/orders/{orderId}/cancellation-request/finalize |
[**getVendorCancellationPreview**](VendorFulfillmentApi.md#getvendorcancellationpreview) | **GET** /vendor/orders/{orderId}/cancellation-preview |
[**getVendorOrderFile**](VendorFulfillmentApi.md#getvendororderfile) | **GET** /vendor/orders/{orderId}/files/{fileId} |
[**listVendorFulfillmentAssignees**](VendorFulfillmentApi.md#listvendorfulfillmentassignees) | **GET** /vendor/orders/{orderId}/fulfillment/assignees |
[**recordVendorFulfillmentMilestone**](VendorFulfillmentApi.md#recordvendorfulfillmentmilestone) | **POST** /vendor/orders/{orderId}/fulfillment/milestones |
[**recordVendorFulfillmentTrip**](VendorFulfillmentApi.md#recordvendorfulfillmenttrip) | **POST** /vendor/orders/{orderId}/fulfillment/trips |
[**recordVendorReimbursement**](VendorFulfillmentApi.md#recordvendorreimbursement) | **POST** /vendor/orders/{orderId}/reimbursements/{reimbursementId} |
[**reportVendorVehicleIssue**](VendorFulfillmentApi.md#reportvendorvehicleissue) | **POST** /vendor/orders/{orderId}/fulfillment/vehicle-issues |
[**respondVendorProblem**](VendorFulfillmentApi.md#respondvendorproblem) | **POST** /vendor/orders/{orderId}/problems/{issueId}/respond |
[**retryVendorRefund**](VendorFulfillmentApi.md#retryvendorrefund) | **POST** /vendor/orders/{orderId}/refunds/{refundId}/retry |


# **assignVendorFulfillmentStaff**
> OrderDetailEnvelope assignVendorFulfillmentStaff(orderId, idempotencyKey, fulfillmentAssignmentRequest)



Owner or Store Manager assign or reassign Fulfillment Staff. The former assignee loses order, thread, file and realtime access immediately; history keeps its attribution.

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

final api = MateryalphApiClient().getVendorFulfillmentApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final FulfillmentAssignmentRequest fulfillmentAssignmentRequest = ; // FulfillmentAssignmentRequest |

try {
    final response = api.assignVendorFulfillmentStaff(orderId, idempotencyKey, fulfillmentAssignmentRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorFulfillmentApi->assignVendorFulfillmentStaff: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **fulfillmentAssignmentRequest** | [**FulfillmentAssignmentRequest**](FulfillmentAssignmentRequest.md)|  |

### Return type

[**OrderDetailEnvelope**](OrderDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **cancelVendorOrder**
> OrderDetailEnvelope cancelVendorOrder(orderId, idempotencyKey, vendorCancelRequest)



Owner, Store Manager or Store Staff cancel with a reason before DELIVERED/PICKED_UP: NRPC forfeited, every Buyer-paid amount refunded to the original method, reservation released, NFR event recorded.

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

final api = MateryalphApiClient().getVendorFulfillmentApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final VendorCancelRequest vendorCancelRequest = ; // VendorCancelRequest |

try {
    final response = api.cancelVendorOrder(orderId, idempotencyKey, vendorCancelRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorFulfillmentApi->cancelVendorOrder: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **vendorCancelRequest** | [**VendorCancelRequest**](VendorCancelRequest.md)|  |

### Return type

[**OrderDetailEnvelope**](OrderDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **finalizeVendorCancellationRequest**
> OrderDetailEnvelope finalizeVendorCancellationRequest(orderId, idempotencyKey, retainNrpc, note, file)



Finalize a Buyer request within 24 hours. Retaining the accepted NRPC requires preparation evidence; otherwise everything is refunded. The Vendor cannot refuse a permitted request.

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

final api = MateryalphApiClient().getVendorFulfillmentApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final bool retainNrpc = true; // bool |
final String note = note_example; // String |
final MultipartFile file = BINARY_DATA_HERE; // MultipartFile | Required to retain NRPC: evidence of the actual irreversible preparation (JPG, PNG or PDF).

try {
    final response = api.finalizeVendorCancellationRequest(orderId, idempotencyKey, retainNrpc, note, file);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorFulfillmentApi->finalizeVendorCancellationRequest: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **retainNrpc** | **bool**|  |
 **note** | **String**|  | [optional]
 **file** | **MultipartFile**| Required to retain NRPC: evidence of the actual irreversible preparation (JPG, PNG or PDF). | [optional]

### Return type

[**OrderDetailEnvelope**](OrderDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVendorCancellationPreview**
> VendorCancellationPreviewEnvelope getVendorCancellationPreview(orderId)



Owner, Store Manager or Store Staff: FIN-07 amounts for a Vendor cancellation and for finalizing an open Buyer request.

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

final api = MateryalphApiClient().getVendorFulfillmentApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getVendorCancellationPreview(orderId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorFulfillmentApi->getVendorCancellationPreview: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |

### Return type

[**VendorCancellationPreviewEnvelope**](VendorCancellationPreviewEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVendorOrderFile**
> Uint8List getVendorOrderFile(orderId, fileId)



Order evidence for authorized Vendor users of this order; Fulfillment Staff only while assigned.

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

final api = MateryalphApiClient().getVendorFulfillmentApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String fileId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getVendorOrderFile(orderId, fileId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorFulfillmentApi->getVendorOrderFile: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |
 **fileId** | **String**|  |

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: image/png, image/jpeg, application/pdf, application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listVendorFulfillmentAssignees**
> FulfillmentAssigneeListEnvelope listVendorFulfillmentAssignees(orderId)



Owner or Store Manager: active Fulfillment Staff that can be assigned.

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

final api = MateryalphApiClient().getVendorFulfillmentApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.listVendorFulfillmentAssignees(orderId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorFulfillmentApi->listVendorFulfillmentAssignees: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |

### Return type

[**FulfillmentAssigneeListEnvelope**](FulfillmentAssigneeListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **recordVendorFulfillmentMilestone**
> OrderDetailEnvelope recordVendorFulfillmentMilestone(orderId, idempotencyKey, milestone, lockVersion, vehicleIndex, tripNumber, receiverName, receiverKind, handoverConfirmed, note, file, signature)



Owner, Store Manager or the assigned Fulfillment Staff record the next milestone through the shared state machine. Duplicate → replay or 409 MILESTONE_ALREADY_RECORDED; out of order → 409 ORDER_STATE_CONFLICT; open cancellation request → 409 CANCELLATION_PENDING; missing proof → 422 PROOF_REQUIRED. READY_FOR_PICKUP or OUT_FOR_DELIVERY opens the one fulfillment thread in the same transaction.

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

final api = MateryalphApiClient().getVendorFulfillmentApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String milestone = milestone_example; // String |
final int lockVersion = 56; // int |
final int vehicleIndex = 56; // int |
final int tripNumber = 56; // int |
final String receiverName = receiverName_example; // String |
final String receiverKind = receiverKind_example; // String |
final bool handoverConfirmed = true; // bool |
final String note = note_example; // String |
final MultipartFile file = BINARY_DATA_HERE; // MultipartFile | Delivery photo (required for DELIVERED): JPG or PNG up to 10 MB, scanned fail-closed, stored privately.
final MultipartFile signature = BINARY_DATA_HERE; // MultipartFile | Optional receiver signature image.

try {
    final response = api.recordVendorFulfillmentMilestone(orderId, idempotencyKey, milestone, lockVersion, vehicleIndex, tripNumber, receiverName, receiverKind, handoverConfirmed, note, file, signature);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorFulfillmentApi->recordVendorFulfillmentMilestone: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **milestone** | **String**|  |
 **lockVersion** | **int**|  |
 **vehicleIndex** | **int**|  | [optional]
 **tripNumber** | **int**|  | [optional]
 **receiverName** | **String**|  | [optional]
 **receiverKind** | **String**|  | [optional]
 **handoverConfirmed** | **bool**|  | [optional]
 **note** | **String**|  | [optional]
 **file** | **MultipartFile**| Delivery photo (required for DELIVERED): JPG or PNG up to 10 MB, scanned fail-closed, stored privately. | [optional]
 **signature** | **MultipartFile**| Optional receiver signature image. | [optional]

### Return type

[**OrderDetailEnvelope**](OrderDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **recordVendorFulfillmentTrip**
> OrderDetailEnvelope recordVendorFulfillmentTrip(orderId, idempotencyKey, fulfillmentTripRequest)



Record another accepted trip while out for delivery; never beyond the accepted trip count.

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

final api = MateryalphApiClient().getVendorFulfillmentApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final FulfillmentTripRequest fulfillmentTripRequest = ; // FulfillmentTripRequest |

try {
    final response = api.recordVendorFulfillmentTrip(orderId, idempotencyKey, fulfillmentTripRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorFulfillmentApi->recordVendorFulfillmentTrip: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **fulfillmentTripRequest** | [**FulfillmentTripRequest**](FulfillmentTripRequest.md)|  |

### Return type

[**OrderDetailEnvelope**](OrderDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **recordVendorReimbursement**
> OrderDetailEnvelope recordVendorReimbursement(orderId, reimbursementId, idempotencyKey, file, reimbursedAt, note)



Record returning cash collected directly, with private evidence. Confirmed by the Buyer or an authorized Admin decision.

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

final api = MateryalphApiClient().getVendorFulfillmentApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String reimbursementId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final MultipartFile file = BINARY_DATA_HERE; // MultipartFile |
final DateTime reimbursedAt = 2013-10-20T19:20:30+01:00; // DateTime |
final String note = note_example; // String |

try {
    final response = api.recordVendorReimbursement(orderId, reimbursementId, idempotencyKey, file, reimbursedAt, note);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorFulfillmentApi->recordVendorReimbursement: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |
 **reimbursementId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **file** | **MultipartFile**|  |
 **reimbursedAt** | **DateTime**|  | [optional]
 **note** | **String**|  | [optional]

### Return type

[**OrderDetailEnvelope**](OrderDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reportVendorVehicleIssue**
> OrderDetailEnvelope reportVendorVehicleIssue(orderId, idempotencyKey, vehicleIssueRequest)



Report a vehicle issue. The accepted arrangement and fee are unchanged; a different arrangement needs an authorized revision approved by the Buyer.

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

final api = MateryalphApiClient().getVendorFulfillmentApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final VehicleIssueRequest vehicleIssueRequest = ; // VehicleIssueRequest |

try {
    final response = api.reportVendorVehicleIssue(orderId, idempotencyKey, vehicleIssueRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorFulfillmentApi->reportVendorVehicleIssue: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **vehicleIssueRequest** | [**VehicleIssueRequest**](VehicleIssueRequest.md)|  |

### Return type

[**OrderDetailEnvelope**](OrderDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **respondVendorProblem**
> OrderDetailEnvelope respondVendorProblem(orderId, issueId, idempotencyKey, problemResponseRequest)



Respond to an open Buyer problem report.

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

final api = MateryalphApiClient().getVendorFulfillmentApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String issueId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ProblemResponseRequest problemResponseRequest = ; // ProblemResponseRequest |

try {
    final response = api.respondVendorProblem(orderId, issueId, idempotencyKey, problemResponseRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorFulfillmentApi->respondVendorProblem: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |
 **issueId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **problemResponseRequest** | [**ProblemResponseRequest**](ProblemResponseRequest.md)|  |

### Return type

[**OrderDetailEnvelope**](OrderDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **retryVendorRefund**
> OrderDetailEnvelope retryVendorRefund(orderId, refundId, idempotencyKey)



Owner only: retry a REFUND_FAILED instruction after funding is resolved. Same instruction and trigger; the next attempt uses a new provider idempotency key.

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

final api = MateryalphApiClient().getVendorFulfillmentApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String refundId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.retryVendorRefund(orderId, refundId, idempotencyKey);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorFulfillmentApi->retryVendorRefund: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |
 **refundId** | **String**|  |
 **idempotencyKey** | **String**|  |

### Return type

[**OrderDetailEnvelope**](OrderDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

