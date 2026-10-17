# materyalph_api_client.api.AdminOrderOperationsApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**confirmAdminReimbursement**](AdminOrderOperationsApi.md#confirmadminreimbursement) | **POST** /admin/order-operations/reimbursements/{reimbursementId}/confirm |
[**getAdminOrderOperationsSummary**](AdminOrderOperationsApi.md#getadminorderoperationssummary) | **GET** /admin/order-operations/summary |
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
> AdminReimbursementListEnvelope listAdminReimbursements(from, to)



orders.operations.view. Vendor cash reimbursements of cancelled orders.

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
final Date from = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omitted boundary unrestricted. Reimbursement instruction created_at; existing 100-record bound retained.
final Date to = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omitted boundary unrestricted. Reimbursement instruction created_at; existing 100-record bound retained.

try {
    final response = api.listAdminReimbursements(from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminOrderOperationsApi->listAdminReimbursements: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **Date**| Inclusive Asia/Manila calendar date; omitted boundary unrestricted. Reimbursement instruction created_at; existing 100-record bound retained. | [optional]
 **to** | **Date**| Inclusive Asia/Manila calendar date; omitted boundary unrestricted. Reimbursement instruction created_at; existing 100-record bound retained. | [optional]

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

