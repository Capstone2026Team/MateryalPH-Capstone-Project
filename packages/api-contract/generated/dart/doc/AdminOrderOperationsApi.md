# materyalph_api_client.api.AdminOrderOperationsApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**confirmAdminReimbursement**](AdminOrderOperationsApi.md#confirmadminreimbursement) | **POST** /admin/order-operations/reimbursements/{reimbursementId}/confirm |
[**getAdminAuditOrder**](AdminOrderOperationsApi.md#getadminauditorder) | **GET** /admin/order-operations/orders/{orderId} |
[**getAdminAuditOrderFile**](AdminOrderOperationsApi.md#getadminauditorderfile) | **GET** /admin/order-operations/orders/{orderId}/files/{fileId} |
[**getAdminOrderOperationsSummary**](AdminOrderOperationsApi.md#getadminorderoperationssummary) | **GET** /admin/order-operations/summary |
[**listAdminAuditOrders**](AdminOrderOperationsApi.md#listadminauditorders) | **GET** /admin/order-operations/orders |
[**listAdminCancellationRequests**](AdminOrderOperationsApi.md#listadmincancellationrequests) | **GET** /admin/order-operations/cancellation-requests |
[**listAdminRefunds**](AdminOrderOperationsApi.md#listadminrefunds) | **GET** /admin/order-operations/refunds |
[**listAdminReimbursements**](AdminOrderOperationsApi.md#listadminreimbursements) | **GET** /admin/order-operations/reimbursements |
[**retryAdminRefund**](AdminOrderOperationsApi.md#retryadminrefund) | **POST** /admin/order-operations/refunds/{refundId}/retry |


# **confirmAdminReimbursement**
> AdminOrderActionResultEnvelope confirmAdminReimbursement(reimbursementId, adminReimbursementDecision)



reimbursements.decide. Reasoned confirmation of an evidenced reimbursement.

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

final api = MateryalphApiClient().getAdminOrderOperationsApi();
final String reimbursementId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final AdminReimbursementDecision adminReimbursementDecision = ; // AdminReimbursementDecision |

try {
    final response = api.confirmAdminReimbursement(reimbursementId, adminReimbursementDecision);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminOrderOperationsApi->confirmAdminReimbursement: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **reimbursementId** | **String**|  |
 **adminReimbursementDecision** | [**AdminReimbursementDecision**](AdminReimbursementDecision.md)|  |

### Return type

[**AdminOrderActionResultEnvelope**](AdminOrderActionResultEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAdminAuditOrder**
> OrderDetailEnvelope getAdminAuditOrder(orderId, caseId)



Audited read-only order detail with immutable commercial terms, all recorded payment attempts, cash records, fulfillment evidence, cancellation decision, refunds and state history. Requires orders.operations.view; when case_id is provided requires disputes.view and an existing matching case/order relationship. No inventory, Buyer budget, staff contacts, provider identifiers or checkout URLs. No actions or transitions.

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

final api = MateryalphApiClient().getAdminOrderOperationsApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String caseId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getAdminAuditOrder(orderId, caseId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminOrderOperationsApi->getAdminAuditOrder: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |
 **caseId** | **String**|  | [optional]

### Return type

[**OrderDetailEnvelope**](OrderDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAdminAuditOrderFile**
> Uint8List getAdminAuditOrderFile(orderId, fileId, caseId)



Audited private evidence read. Reauthorizes orders.operations.view or disputes.view plus matching case_id on every request. Only CLEAN private files referenced by this order are available; no public storage URL is returned.

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

final api = MateryalphApiClient().getAdminOrderOperationsApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String fileId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String caseId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getAdminAuditOrderFile(orderId, fileId, caseId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminOrderOperationsApi->getAdminAuditOrderFile: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |
 **fileId** | **String**|  |
 **caseId** | **String**|  | [optional]

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/octet-stream, application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAdminOrderOperationsSummary**
> AdminOrderOperationsSummaryEnvelope getAdminOrderOperationsSummary()



orders.operations.view. All-record refund and order-linked reimbursement totals, independent of list filters, plus counts of failed and pending refunds, pending reimbursements, open cancellation requests and recent NFR events.

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

final api = MateryalphApiClient().getAdminOrderOperationsApi();

try {
    final response = api.getAdminOrderOperationsSummary();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminOrderOperationsApi->getAdminOrderOperationsSummary: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AdminOrderOperationsSummaryEnvelope**](AdminOrderOperationsSummaryEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAdminAuditOrders**
> OrderListEnvelope listAdminAuditOrders(q, page, orderState, paymentState, refundState, paymentMethod, from, to)



Read-only platform order history; requires orders.operations.view. No expiry, reconciliation or commercial mutation runs on a read. Buyer names and public store names only in the paginated list.

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

final api = MateryalphApiClient().getAdminOrderOperationsApi();
final String q = q_example; // String | Order reference or Buyer or public store name.
final int page = 56; // int |
final OrderState orderState = ; // OrderState |
final OrderPaymentState paymentState = ; // OrderPaymentState |
final String refundState = refundState_example; // String |
final String paymentMethod = paymentMethod_example; // String |
final Date from = 2013-10-20; // Date | Inclusive submitted date in Asia/Manila; omit for all history.
final Date to = 2013-10-20; // Date | Inclusive submitted date in Asia/Manila; omit for all history.

try {
    final response = api.listAdminAuditOrders(q, page, orderState, paymentState, refundState, paymentMethod, from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminOrderOperationsApi->listAdminAuditOrders: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **q** | **String**| Order reference or Buyer or public store name. | [optional]
 **page** | **int**|  | [optional]
 **orderState** | [**OrderState**](.md)|  | [optional]
 **paymentState** | [**OrderPaymentState**](.md)|  | [optional]
 **refundState** | **String**|  | [optional]
 **paymentMethod** | **String**|  | [optional]
 **from** | **Date**| Inclusive submitted date in Asia/Manila; omit for all history. | [optional]
 **to** | **Date**| Inclusive submitted date in Asia/Manila; omit for all history. | [optional]

### Return type

[**OrderListEnvelope**](OrderListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAdminCancellationRequests**
> AdminCancellationRequestListEnvelope listAdminCancellationRequests(from, to)



orders.operations.view. Open Buyer requests awaiting the Vendor, earliest deadline first.

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

final api = MateryalphApiClient().getAdminOrderOperationsApi();
final Date from = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omitted boundary unrestricted. Open cancellation request created_at; existing 100-record bound retained.
final Date to = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omitted boundary unrestricted. Open cancellation request created_at; existing 100-record bound retained.

try {
    final response = api.listAdminCancellationRequests(from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminOrderOperationsApi->listAdminCancellationRequests: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **Date**| Inclusive Asia/Manila calendar date; omitted boundary unrestricted. Open cancellation request created_at; existing 100-record bound retained. | [optional]
 **to** | **Date**| Inclusive Asia/Manila calendar date; omitted boundary unrestricted. Open cancellation request created_at; existing 100-record bound retained. | [optional]

### Return type

[**AdminCancellationRequestListEnvelope**](AdminCancellationRequestListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAdminRefunds**
> AdminRefundListEnvelope listAdminRefunds(state, trigger, page, from, to)



orders.operations.view. Refund instructions, failures first. Admins never hold or disburse funds.

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

final api = MateryalphApiClient().getAdminOrderOperationsApi();
final String state = state_example; // String |
final String trigger = trigger_example; // String |
final int page = 56; // int |
final Date from = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Refund requested_at with created_at fallback.
final Date to = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Refund requested_at with created_at fallback.

try {
    final response = api.listAdminRefunds(state, trigger, page, from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminOrderOperationsApi->listAdminRefunds: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **state** | **String**|  | [optional]
 **trigger** | **String**|  | [optional]
 **page** | **int**|  | [optional]
 **from** | **Date**| Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Refund requested_at with created_at fallback. | [optional]
 **to** | **Date**| Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Refund requested_at with created_at fallback. | [optional]

### Return type

[**AdminRefundListEnvelope**](AdminRefundListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAdminReimbursements**
> AdminReimbursementListEnvelope listAdminReimbursements(page, from, to)



orders.operations.view. Paginated Vendor cash reimbursement instructions and confirmed records, including cancellation and dispute remedies.

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

final api = MateryalphApiClient().getAdminOrderOperationsApi();
final int page = 56; // int |
final Date from = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omitted boundary unrestricted. Reimbursement instruction created_at.
final Date to = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omitted boundary unrestricted. Reimbursement instruction created_at.

try {
    final response = api.listAdminReimbursements(page, from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminOrderOperationsApi->listAdminReimbursements: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **int**|  | [optional]
 **from** | **Date**| Inclusive Asia/Manila calendar date; omitted boundary unrestricted. Reimbursement instruction created_at. | [optional]
 **to** | **Date**| Inclusive Asia/Manila calendar date; omitted boundary unrestricted. Reimbursement instruction created_at. | [optional]

### Return type

[**AdminReimbursementListEnvelope**](AdminReimbursementListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **retryAdminRefund**
> AdminOrderActionResultEnvelope retryAdminRefund(refundId, idempotencyKey)



refunds.retry. Re-send a failed instruction to the original payment only.

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

final api = MateryalphApiClient().getAdminOrderOperationsApi();
final String refundId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.retryAdminRefund(refundId, idempotencyKey);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminOrderOperationsApi->retryAdminRefund: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **refundId** | **String**|  |
 **idempotencyKey** | **String**|  |

### Return type

[**AdminOrderActionResultEnvelope**](AdminOrderActionResultEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

