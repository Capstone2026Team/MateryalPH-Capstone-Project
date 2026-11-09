# materyalph_api_client.api.AdminFinanceApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**approveFeeCredit**](AdminFinanceApi.md#approvefeecredit) | **POST** /admin/finance/fee-credits/{proposalId}/approve |
[**approveFeeStatement**](AdminFinanceApi.md#approvefeestatement) | **POST** /admin/finance/statements/{statementId}/approve |
[**draftFeeStatements**](AdminFinanceApi.md#draftfeestatements) | **POST** /admin/finance/statements/draft |
[**getAdminCommissionStatement**](AdminFinanceApi.md#getadmincommissionstatement) | **GET** /admin/finance/statements/{statementId} |
[**getWithholdingAccumulator**](AdminFinanceApi.md#getwithholdingaccumulator) | **GET** /admin/finance/withholding-accumulators/{accumulatorId} |
[**listAdminPayments**](AdminFinanceApi.md#listadminpayments) | **GET** /admin/finance/payments |
[**listChannelFees**](AdminFinanceApi.md#listchannelfees) | **GET** /admin/finance/channel-fees |
[**listCommissionPolicies**](AdminFinanceApi.md#listcommissionpolicies) | **GET** /admin/finance/commission-policies |
[**listCommissionTransactions**](AdminFinanceApi.md#listcommissiontransactions) | **GET** /admin/finance/commission-transactions |
[**listFeeStatements**](AdminFinanceApi.md#listfeestatements) | **GET** /admin/finance/statements |
[**listFinanceReviewItems**](AdminFinanceApi.md#listfinancereviewitems) | **GET** /admin/finance/review-items |
[**listWithholdingAccumulators**](AdminFinanceApi.md#listwithholdingaccumulators) | **GET** /admin/finance/withholding-accumulators |
[**previewCommissionPolicy**](AdminFinanceApi.md#previewcommissionpolicy) | **POST** /admin/finance/commission-policies/preview |
[**proposeFeeCredit**](AdminFinanceApi.md#proposefeecredit) | **POST** /admin/finance/fee-credits |
[**publishCommissionPolicy**](AdminFinanceApi.md#publishcommissionpolicy) | **POST** /admin/finance/commission-policies |
[**resendCommissionEmail**](AdminFinanceApi.md#resendcommissionemail) | **POST** /admin/finance/commission-emails/{eventId}/resend |
[**resendFailedCommissionEmails**](AdminFinanceApi.md#resendfailedcommissionemails) | **POST** /admin/finance/commission-policies/{policyId}/resend-failed |
[**resolveFinanceReviewItem**](AdminFinanceApi.md#resolvefinancereviewitem) | **POST** /admin/finance/review-items/{itemId}/resolve |
[**resolveWithholdingOverlap**](AdminFinanceApi.md#resolvewithholdingoverlap) | **POST** /admin/finance/withholding-accumulators/{accumulatorId}/overlap |
[**runPaymentReconciliation**](AdminFinanceApi.md#runpaymentreconciliation) | **POST** /admin/finance/reconciliation/run |
[**updateFeeStatementInvoice**](AdminFinanceApi.md#updatefeestatementinvoice) | **PUT** /admin/finance/statements/{statementId}/invoice |


# **approveFeeCredit**
> FinanceActionResultEnvelope approveFeeCredit(proposalId)



Manual corrections only: finance.approve_statements by a user different from the preparer (403 PREPARER_REVIEWER_SAME). Routine dispute credits and monthly statement issuance are automatic.

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

final api = MateryalphApiClient().getAdminFinanceApi();
final String proposalId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.approveFeeCredit(proposalId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceApi->approveFeeCredit: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **proposalId** | **String**|  |

### Return type

[**FinanceActionResultEnvelope**](FinanceActionResultEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **approveFeeStatement**
> FeeStatementEnvelope approveFeeStatement(statementId, statementApproveRequest)



finance.approve_statements. Issue a DRAFT; due = max(15th of next month, issue + 12 days).

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

final api = MateryalphApiClient().getAdminFinanceApi();
final String statementId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final StatementApproveRequest statementApproveRequest = ; // StatementApproveRequest |

try {
    final response = api.approveFeeStatement(statementId, statementApproveRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceApi->approveFeeStatement: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **statementId** | **String**|  |
 **statementApproveRequest** | [**StatementApproveRequest**](StatementApproveRequest.md)|  |

### Return type

[**FeeStatementEnvelope**](FeeStatementEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **draftFeeStatements**
> FinanceActionResultEnvelope draftFeeStatements()



finance.approve_statements. Idempotently draft last month's statements (also scheduled 00:05 Asia/Manila on the 1st).

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

final api = MateryalphApiClient().getAdminFinanceApi();

try {
    final response = api.draftFeeStatements();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceApi->draftFeeStatements: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**FinanceActionResultEnvelope**](FinanceActionResultEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAdminCommissionStatement**
> GenericDataEnvelope getAdminCommissionStatement(statementId, page, paymentsPage)



finance.view. Read-only statement detail, all-rate aggregate breakdown, separately paginated lines and payments (25 per page), and Owner email delivery activity without recipient contacts. Includes can_resend and can_export permissions.

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

final api = MateryalphApiClient().getAdminFinanceApi();
final String statementId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final int page = 56; // int |
final int paymentsPage = 56; // int |

try {
    final response = api.getAdminCommissionStatement(statementId, page, paymentsPage);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceApi->getAdminCommissionStatement: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **statementId** | **String**|  |
 **page** | **int**|  | [optional]
 **paymentsPage** | **int**|  | [optional]

### Return type

[**GenericDataEnvelope**](GenericDataEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getWithholdingAccumulator**
> WithholdingAccumulatorDetailEnvelope getWithholdingAccumulator(accumulatorId)



finance.view. Figures, prior-year position, declaration year, overlap, breach, reason code and status-event history. Raw TIN never returned.

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

final api = MateryalphApiClient().getAdminFinanceApi();
final String accumulatorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getWithholdingAccumulator(accumulatorId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceApi->getWithholdingAccumulator: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **accumulatorId** | **String**|  |

### Return type

[**WithholdingAccumulatorDetailEnvelope**](WithholdingAccumulatorDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAdminPayments**
> AdminPaymentListEnvelope listAdminPayments(page, state, purpose, evidenceOrigin, reconciliationState, from, to)



finance.view. Payment log with evidence origin, reconciliation state, refunded_centavos, net_collected_centavos, refund_pending_count and refund_failed_count. Refunds are aggregated per original capture; only confirmed refunds reduce net collections, and a PAID payment retains its original state even when refunded.

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

final api = MateryalphApiClient().getAdminFinanceApi();
final int page = 56; // int |
final String state = state_example; // String |
final String purpose = purpose_example; // String |
final String evidenceOrigin = evidenceOrigin_example; // String |
final String reconciliationState = reconciliationState_example; // String |
final Date from = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Payment request created_at.
final Date to = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Payment request created_at.

try {
    final response = api.listAdminPayments(page, state, purpose, evidenceOrigin, reconciliationState, from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceApi->listAdminPayments: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **int**|  | [optional]
 **state** | **String**|  | [optional]
 **purpose** | **String**|  | [optional]
 **evidenceOrigin** | **String**|  | [optional]
 **reconciliationState** | **String**|  | [optional]
 **from** | **Date**| Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Payment request created_at. | [optional]
 **to** | **Date**| Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Payment request created_at. | [optional]

### Return type

[**AdminPaymentListEnvelope**](AdminPaymentListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listChannelFees**
> ChannelFeeVersionListEnvelope listChannelFees()



finance.view. Versioned TEST channel fee schedule (DEMO published rates; validate against the active Xendit agreement).

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

final api = MateryalphApiClient().getAdminFinanceApi();

try {
    final response = api.listChannelFees();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceApi->listChannelFees: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ChannelFeeVersionListEnvelope**](ChannelFeeVersionListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listCommissionPolicies**
> CommissionPoliciesEnvelope listCommissionPolicies(page)



finance.view. Current and next commercial commission policies and paginated append-only history. can_manage additionally requires platform_settings.manage.

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

final api = MateryalphApiClient().getAdminFinanceApi();
final int page = 56; // int |

try {
    final response = api.listCommissionPolicies(page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceApi->listCommissionPolicies: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **int**|  | [optional] [default to 1]

### Return type

[**CommissionPoliciesEnvelope**](CommissionPoliciesEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listCommissionTransactions**
> AdminPaymentListEnvelope listCommissionTransactions(page, from, to, status, search, statuses)



finance.view. Paginated successful PLATFORM_FEE_PAYMENT captures to the platform account, excluding late captures. Dates and descending order use paid_at in Asia/Manila. Original captures remain visible after refunds; refunded_centavos and net_collected_centavos distinguish gross payments from retained collections. Gateway mode and evidence origin are retained. Optional status filters apply before pagination and exports.

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

final api = MateryalphApiClient().getAdminFinanceApi();
final int page = 56; // int |
final Date from = 2013-10-20; // Date |
final Date to = 2013-10-20; // Date |
final String status = status_example; // String |
final String search = search_example; // String |
final String statuses = statuses_example; // String | Comma-separated payment statuses combined with OR before pagination.

try {
    final response = api.listCommissionTransactions(page, from, to, status, search, statuses);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceApi->listCommissionTransactions: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **int**|  | [optional]
 **from** | **Date**|  | [optional]
 **to** | **Date**|  | [optional]
 **status** | **String**|  | [optional]
 **search** | **String**|  | [optional]
 **statuses** | **String**| Comma-separated payment statuses combined with OR before pagination. | [optional]

### Return type

[**AdminPaymentListEnvelope**](AdminPaymentListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listFeeStatements**
> FeeStatementListEnvelope listFeeStatements(search, states, overdue, page, state, from, to)



finance.view. Monthly commission statements shared with Vendor Finance. Inclusive Manila dates filter issued_on. overdue=true returns only issued/partially paid positive balances past the due date; drafts, settled and voided statements are excluded. Approved credits reduce debt on the original statement and any paid excess becomes a separate original-payment refund payable.

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

final api = MateryalphApiClient().getAdminFinanceApi();
final String search = search_example; // String |
final String states = states_example; // String | Comma-separated statement states combined with OR before pagination. Filter totals are returned in meta.totals.
final bool overdue = true; // bool | Issued balances past their due date.
final int page = 56; // int |
final String state = state_example; // String |
final Date from = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Statement issued_on, including drafts.
final Date to = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Statement issued_on, including drafts.

try {
    final response = api.listFeeStatements(search, states, overdue, page, state, from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceApi->listFeeStatements: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **search** | **String**|  | [optional]
 **states** | **String**| Comma-separated statement states combined with OR before pagination. Filter totals are returned in meta.totals. | [optional]
 **overdue** | **bool**| Issued balances past their due date. | [optional]
 **page** | **int**|  | [optional]
 **state** | **String**|  | [optional]
 **from** | **Date**| Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Statement issued_on, including drafts. | [optional]
 **to** | **Date**| Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Statement issued_on, including drafts. | [optional]

### Return type

[**FeeStatementListEnvelope**](FeeStatementListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listFinanceReviewItems**
> FinanceReviewItemListEnvelope listFinanceReviewItems(page, state, kind, from, to)



finance.view. Reconciliation exceptions, payment mismatches, late captures, unresolved overlap, threshold adjustments, base reviews, overdue statements and manual fee-credit proposals. Executed dispute awards create automatic credits without review items.

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

final api = MateryalphApiClient().getAdminFinanceApi();
final int page = 56; // int |
final String state = state_example; // String |
final String kind = kind_example; // String |
final Date from = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Review item created_at.
final Date to = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Review item created_at.

try {
    final response = api.listFinanceReviewItems(page, state, kind, from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceApi->listFinanceReviewItems: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **int**|  | [optional]
 **state** | **String**|  | [optional]
 **kind** | **String**|  | [optional]
 **from** | **Date**| Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Review item created_at. | [optional]
 **to** | **Date**| Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Review item created_at. | [optional]

### Return type

[**FinanceReviewItemListEnvelope**](FinanceReviewItemListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listWithholdingAccumulators**
> WithholdingAccumulatorListEnvelope listWithholdingAccumulators(page, status, taxableYear)



finance.view. FIN-04A accumulators.

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

final api = MateryalphApiClient().getAdminFinanceApi();
final int page = 56; // int |
final String status = status_example; // String |
final int taxableYear = 56; // int |

try {
    final response = api.listWithholdingAccumulators(page, status, taxableYear);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceApi->listWithholdingAccumulators: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **int**|  | [optional]
 **status** | **String**|  | [optional]
 **taxableYear** | **int**|  | [optional]

### Return type

[**WithholdingAccumulatorListEnvelope**](WithholdingAccumulatorListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **previewCommissionPolicy**
> CommissionPolicyPreviewEnvelope previewCommissionPolicy(commissionPolicyPublishRequest)



Read-only impact, rendered mail and terms preview. Requires finance.view and platform_settings.manage. Estimates use the last three complete Manila calendar months of recorded eligible basis, not a revenue forecast.

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

final api = MateryalphApiClient().getAdminFinanceApi();
final CommissionPolicyPublishRequest commissionPolicyPublishRequest = ; // CommissionPolicyPublishRequest |

try {
    final response = api.previewCommissionPolicy(commissionPolicyPublishRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceApi->previewCommissionPolicy: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **commissionPolicyPublishRequest** | [**CommissionPolicyPublishRequest**](CommissionPolicyPublishRequest.md)|  |

### Return type

[**CommissionPolicyPreviewEnvelope**](CommissionPolicyPreviewEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **proposeFeeCredit**
> FinanceActionResultEnvelope proposeFeeCredit(feeCreditProposalRequest)



finance.review_tax. Prepare a manual FIN-03 correction from returned exclusive value after completion. Executed dispute awards are credited automatically.

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

final api = MateryalphApiClient().getAdminFinanceApi();
final FeeCreditProposalRequest feeCreditProposalRequest = ; // FeeCreditProposalRequest |

try {
    final response = api.proposeFeeCredit(feeCreditProposalRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceApi->proposeFeeCredit: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **feeCreditProposalRequest** | [**FeeCreditProposalRequest**](FeeCreditProposalRequest.md)|  |

### Return type

[**FinanceActionResultEnvelope**](FinanceActionResultEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **publishCommissionPolicy**
> CommissionPolicyEnvelope publishCommissionPolicy(idempotencyKey, commissionPolicyPublishRequest)



Requires finance.view, platform_settings.manage, recent authentication, CSRF, Idempotency-Key and expected_version. Publishes immutable policy and terms with unique queued verified-Owner emails per eligible Vendor (active account or unsettled bill). Increases need configured notice (default 30 days) or explicit reasoned audited override. Set supersedes_policy_id to edit the next scheduled change; cancel_scheduled appends a replacement at the current rate and cancellation notice. Earlier versions and saved transactions remain intact. No rate cache or scheduler flip is required.

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

final api = MateryalphApiClient().getAdminFinanceApi();
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final CommissionPolicyPublishRequest commissionPolicyPublishRequest = ; // CommissionPolicyPublishRequest |

try {
    final response = api.publishCommissionPolicy(idempotencyKey, commissionPolicyPublishRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceApi->publishCommissionPolicy: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String**|  |
 **commissionPolicyPublishRequest** | [**CommissionPolicyPublishRequest**](CommissionPolicyPublishRequest.md)|  |

### Return type

[**CommissionPolicyEnvelope**](CommissionPolicyEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resendCommissionEmail**
> GenericDataEnvelope resendCommissionEmail(eventId, idempotencyKey)



finance.view plus finance.approve_statements for a statement, or platform_settings.manage for a rate notice. Requeues a sent or failed email. One-minute per-email throttle, audit event and idempotency required. Does not change any financial record.

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

final api = MateryalphApiClient().getAdminFinanceApi();
final String eventId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.resendCommissionEmail(eventId, idempotencyKey);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceApi->resendCommissionEmail: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **eventId** | **String**|  |
 **idempotencyKey** | **String**|  |

### Return type

[**GenericDataEnvelope**](GenericDataEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resendFailedCommissionEmails**
> GenericDataEnvelope resendFailedCommissionEmails(policyId, idempotencyKey)



Requires finance.view and platform_settings.manage. Requeues failed emails only, with per-email one-minute throttling, idempotency and an audit event. Existing immutable attempt history is retained.

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

final api = MateryalphApiClient().getAdminFinanceApi();
final String policyId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.resendFailedCommissionEmails(policyId, idempotencyKey);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceApi->resendFailedCommissionEmails: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **policyId** | **String**|  |
 **idempotencyKey** | **String**|  |

### Return type

[**GenericDataEnvelope**](GenericDataEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resolveFinanceReviewItem**
> FinanceActionResultEnvelope resolveFinanceReviewItem(itemId, reviewResolveRequest)



finance.record_external_evidence. Record a reasoned resolution.

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

final api = MateryalphApiClient().getAdminFinanceApi();
final String itemId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ReviewResolveRequest reviewResolveRequest = ; // ReviewResolveRequest |

try {
    final response = api.resolveFinanceReviewItem(itemId, reviewResolveRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceApi->resolveFinanceReviewItem: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **itemId** | **String**|  |
 **reviewResolveRequest** | [**ReviewResolveRequest**](ReviewResolveRequest.md)|  |

### Return type

[**FinanceActionResultEnvelope**](FinanceActionResultEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resolveWithholdingOverlap**
> WithholdingAccumulatorDetailEnvelope resolveWithholdingOverlap(accumulatorId, overlapResolveRequest)



finance.review_tax. Record the outside-platform overlap of an UNDER_REVIEW accumulator; a total above the limit breaches.

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

final api = MateryalphApiClient().getAdminFinanceApi();
final String accumulatorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final OverlapResolveRequest overlapResolveRequest = ; // OverlapResolveRequest |

try {
    final response = api.resolveWithholdingOverlap(accumulatorId, overlapResolveRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceApi->resolveWithholdingOverlap: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **accumulatorId** | **String**|  |
 **overlapResolveRequest** | [**OverlapResolveRequest**](OverlapResolveRequest.md)|  |

### Return type

[**WithholdingAccumulatorDetailEnvelope**](WithholdingAccumulatorDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **runPaymentReconciliation**
> FinanceActionResultEnvelope runPaymentReconciliation()



finance.view. Run the bounded reconciliation sweep now.

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

final api = MateryalphApiClient().getAdminFinanceApi();

try {
    final response = api.runPaymentReconciliation();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceApi->runPaymentReconciliation: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**FinanceActionResultEnvelope**](FinanceActionResultEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateFeeStatementInvoice**
> FeeStatementEnvelope updateFeeStatementInvoice(statementId, idempotencyKey, statementInvoiceUpdateRequest)



finance.approve_statements. Edit a DRAFT commission invoice heading and Vendor message with optimistic concurrency and idempotency. Does not send mail. Amounts, issuer, recipients and deadlines remain system controlled. Approval freezes the copy into the immutable SAMPLE/TEST PDF and Owner email. Issued statements reject editing.

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

final api = MateryalphApiClient().getAdminFinanceApi();
final String statementId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final StatementInvoiceUpdateRequest statementInvoiceUpdateRequest = ; // StatementInvoiceUpdateRequest |

try {
    final response = api.updateFeeStatementInvoice(statementId, idempotencyKey, statementInvoiceUpdateRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminFinanceApi->updateFeeStatementInvoice: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **statementId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **statementInvoiceUpdateRequest** | [**StatementInvoiceUpdateRequest**](StatementInvoiceUpdateRequest.md)|  |

### Return type

[**FeeStatementEnvelope**](FeeStatementEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

