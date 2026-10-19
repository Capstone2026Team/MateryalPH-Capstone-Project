# materyalph_api_client.api.VendorFinanceApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**approveVendorOnlineBalance**](VendorFinanceApi.md#approvevendoronlinebalance) | **POST** /vendor/orders/{orderId}/online-balance/approve |
[**exportVendorTransactions**](VendorFinanceApi.md#exportvendortransactions) | **GET** /vendor/finance/transactions/export |
[**getVendorCommissionMonitoring**](VendorFinanceApi.md#getvendorcommissionmonitoring) | **GET** /vendor/finance/commissions |
[**getVendorEarnings**](VendorFinanceApi.md#getvendorearnings) | **GET** /vendor/finance/earnings |
[**getVendorFeePayment**](VendorFinanceApi.md#getvendorfeepayment) | **GET** /vendor/finance/payments/{paymentId} |
[**getVendorFeeStatement**](VendorFinanceApi.md#getvendorfeestatement) | **GET** /vendor/finance/statements/{statementId} |
[**getVendorFinanceOverview**](VendorFinanceApi.md#getvendorfinanceoverview) | **GET** /vendor/finance |
[**listVendorTransactions**](VendorFinanceApi.md#listvendortransactions) | **GET** /vendor/finance/transactions |
[**payVendorFeeStatement**](VendorFinanceApi.md#payvendorfeestatement) | **POST** /vendor/finance/statements/{statementId}/payments |
[**recordVendorPhysicalPayment**](VendorFinanceApi.md#recordvendorphysicalpayment) | **POST** /vendor/orders/{orderId}/physical-payments |
[**refreshVendorFeePayment**](VendorFinanceApi.md#refreshvendorfeepayment) | **POST** /vendor/finance/payments/{paymentId}/refresh |
[**revealVendorTin**](VendorFinanceApi.md#revealvendortin) | **POST** /vendor/tax-profile/tin/reveal |
[**updateVendorPhysicalPayments**](VendorFinanceApi.md#updatevendorphysicalpayments) | **PUT** /vendor/finance/physical-payments |


# **approveVendorOnlineBalance**
> FinanceActionResultEnvelope approveVendorOnlineBalance(orderId, idempotencyKey)



Owner, Manager or Store Staff approve paying the uncollected physical balance online (ORDER_BALANCE_PAYMENT).

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

final api = MateryalphApiClient().getVendorFinanceApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.approveVendorOnlineBalance(orderId, idempotencyKey);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorFinanceApi->approveVendorOnlineBalance: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |
 **idempotencyKey** | **String**|  |

### Return type

[**FinanceActionResultEnvelope**](FinanceActionResultEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **exportVendorTransactions**
> String exportVendorTransactions(tab, status, from, to)



Owner-only audited CSV export: Internal Operational Report — Not a Tax Invoice.

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

final api = MateryalphApiClient().getVendorFinanceApi();
final String tab = tab_example; // String |
final String status = status_example; // String | Payments tab only; ignored by every other tab. Each value matches the status badge a Payments row shows. PAID has no refund activity; LATE_CAPTURE covers every late-captured payment awaiting or after its refund; PENDING is any attempt not yet settled.
final Date from = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Same timestamp and filters as the selected Transaction History tab; filtered before the existing 5000-row export bound.
final Date to = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Same timestamp and filters as the selected Transaction History tab; filtered before the existing 5000-row export bound.

try {
    final response = api.exportVendorTransactions(tab, status, from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorFinanceApi->exportVendorTransactions: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tab** | **String**|  |
 **status** | **String**| Payments tab only; ignored by every other tab. Each value matches the status badge a Payments row shows. PAID has no refund activity; LATE_CAPTURE covers every late-captured payment awaiting or after its refund; PENDING is any attempt not yet settled. | [optional]
 **from** | **Date**| Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Same timestamp and filters as the selected Transaction History tab; filtered before the existing 5000-row export bound. | [optional]
 **to** | **Date**| Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Same timestamp and filters as the selected Transaction History tab; filtered before the existing 5000-row export bound. | [optional]

### Return type

**String**

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/csv, application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVendorCommissionMonitoring**
> VendorCommissionMonitoringEnvelope getVendorCommissionMonitoring(page)



Owner-only all-time commission monitoring with current and next policy, estimated and earned fees, approved credits, unbilled fees, draft bills, issued outstanding and overdue debt, verified allocations and successful fee refunds. Assessments are paginated and retain their original basis and percentage. Cash and earnings are separate; no wallet balance is represented.

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

final api = MateryalphApiClient().getVendorFinanceApi();
final int page = 56; // int |

try {
    final response = api.getVendorCommissionMonitoring(page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorFinanceApi->getVendorCommissionMonitoring: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **int**|  | [optional] [default to 1]

### Return type

[**VendorCommissionMonitoringEnvelope**](VendorCommissionMonitoringEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVendorEarnings**
> VendorEarningsEnvelope getVendorEarnings(from, to)



Owner-only FIN-11 Earnings with separate sales, confirmed online refunds, net online collections, charges, simulated CWT and commission. Confirmed refunds adjust the original payment and assessment date buckets; pending and failed refunds leave collections unchanged. Posted provider charges, CWT and FIN-04A thresholds remain unchanged; estimated remittance cash deducts confirmed refunds without deducting refunds already included in the assessment twice.

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

final api = MateryalphApiClient().getVendorFinanceApi();
final Date from = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Commercial sales use order accepted_at; online collections paid_at; physical collections recorded_at; remittances created_at; commission earned_at and approved credit approved_at; estimates created_at; unpaid statements issued_on. Taxpayer thresholds are never recalculated by this view.
final Date to = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Commercial sales use order accepted_at; online collections paid_at; physical collections recorded_at; remittances created_at; commission earned_at and approved credit approved_at; estimates created_at; unpaid statements issued_on. Taxpayer thresholds are never recalculated by this view.

try {
    final response = api.getVendorEarnings(from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorFinanceApi->getVendorEarnings: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **Date**| Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Commercial sales use order accepted_at; online collections paid_at; physical collections recorded_at; remittances created_at; commission earned_at and approved credit approved_at; estimates created_at; unpaid statements issued_on. Taxpayer thresholds are never recalculated by this view. | [optional]
 **to** | **Date**| Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Commercial sales use order accepted_at; online collections paid_at; physical collections recorded_at; remittances created_at; commission earned_at and approved credit approved_at; estimates created_at; unpaid statements issued_on. Taxpayer thresholds are never recalculated by this view. | [optional]

### Return type

[**VendorEarningsEnvelope**](VendorEarningsEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVendorFeePayment**
> PaymentAttemptEnvelope getVendorFeePayment(paymentId)



Owner-only platform-fee payment attempt.

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

final api = MateryalphApiClient().getVendorFinanceApi();
final String paymentId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getVendorFeePayment(paymentId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorFinanceApi->getVendorFeePayment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **paymentId** | **String**|  |

### Return type

[**PaymentAttemptEnvelope**](PaymentAttemptEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVendorFeeStatement**
> FeeStatementDetailEnvelope getVendorFeeStatement(statementId)



Owner-only issued commission statement with lines, payments and payable channels (platform absorbs its bill processing charge).

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

final api = MateryalphApiClient().getVendorFinanceApi();
final String statementId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getVendorFeeStatement(statementId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorFinanceApi->getVendorFeeStatement: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **statementId** | **String**|  |

### Return type

[**FeeStatementDetailEnvelope**](FeeStatementDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVendorFinanceOverview**
> VendorFinanceOverviewEnvelope getVendorFinanceOverview()



Owner-only. Separate Xendit connection, Vendor Tax Profile summary, withholding arrangement (Production assignment unconfirmed), FIN-04A threshold panel, Commission Terms, online channels, physical payments and refund capability. Every simulated figure is DEMO.

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

final api = MateryalphApiClient().getVendorFinanceApi();

try {
    final response = api.getVendorFinanceOverview();
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorFinanceApi->getVendorFinanceOverview: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**VendorFinanceOverviewEnvelope**](VendorFinanceOverviewEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listVendorTransactions**
> FinanceTransactionListEnvelope listVendorTransactions(tab, page, status, from, to)



Owner-only read-only Transaction History (former Wallet label). No balance, wallet or escrow.

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

final api = MateryalphApiClient().getVendorFinanceApi();
final String tab = tab_example; // String |
final int page = 56; // int |
final String status = status_example; // String | Payments tab only; ignored by every other tab. Each value matches the status badge a Payments row shows. PAID has no refund activity; LATE_CAPTURE covers every late-captured payment awaiting or after its refund; PENDING is any attempt not yet settled.
final Date from = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. PAYMENTS paid_at with created_at fallback; PHYSICAL recorded_at; REMITTANCES created_at; STATEMENTS issued_on; REFUNDS created_at; TAX_DOCUMENTS period_end.
final Date to = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. PAYMENTS paid_at with created_at fallback; PHYSICAL recorded_at; REMITTANCES created_at; STATEMENTS issued_on; REFUNDS created_at; TAX_DOCUMENTS period_end.

try {
    final response = api.listVendorTransactions(tab, page, status, from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorFinanceApi->listVendorTransactions: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tab** | **String**|  | [optional]
 **page** | **int**|  | [optional]
 **status** | **String**| Payments tab only; ignored by every other tab. Each value matches the status badge a Payments row shows. PAID has no refund activity; LATE_CAPTURE covers every late-captured payment awaiting or after its refund; PENDING is any attempt not yet settled. | [optional]
 **from** | **Date**| Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. PAYMENTS paid_at with created_at fallback; PHYSICAL recorded_at; REMITTANCES created_at; STATEMENTS issued_on; REFUNDS created_at; TAX_DOCUMENTS period_end. | [optional]
 **to** | **Date**| Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. PAYMENTS paid_at with created_at fallback; PHYSICAL recorded_at; REMITTANCES created_at; STATEMENTS issued_on; REFUNDS created_at; TAX_DOCUMENTS period_end. | [optional]

### Return type

[**FinanceTransactionListEnvelope**](FinanceTransactionListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **payVendorFeeStatement**
> PaymentAttemptEnvelope payVendorFeeStatement(statementId, idempotencyKey, statementPaymentRequest)



Owner-only PLATFORM_FEE_PAYMENT to the platform TEST account, 45-minute attempt, optional installment amount. No auto debit or split. Open attempts are reconciled first.

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

final api = MateryalphApiClient().getVendorFinanceApi();
final String statementId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final StatementPaymentRequest statementPaymentRequest = ; // StatementPaymentRequest |

try {
    final response = api.payVendorFeeStatement(statementId, idempotencyKey, statementPaymentRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorFinanceApi->payVendorFeeStatement: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **statementId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **statementPaymentRequest** | [**StatementPaymentRequest**](StatementPaymentRequest.md)|  |

### Return type

[**PaymentAttemptEnvelope**](PaymentAttemptEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **recordVendorPhysicalPayment**
> PhysicalPaymentSummaryEnvelope recordVendorPhysicalPayment(orderId, idempotencyKey, amountCentavos, file, receivedAt, note)



Owner, Store Manager or Store Staff (payments.record_physical) record cash received with private evidence. Partial collection leaves an outstanding balance; never above it; never an online success.

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

final api = MateryalphApiClient().getVendorFinanceApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final int amountCentavos = 56; // int |
final MultipartFile file = BINARY_DATA_HERE; // MultipartFile | Private receipt evidence: JPG, PNG, WebP or PDF up to 10 MB; scanned fail-closed.
final DateTime receivedAt = 2013-10-20T19:20:30+01:00; // DateTime |
final String note = note_example; // String |

try {
    final response = api.recordVendorPhysicalPayment(orderId, idempotencyKey, amountCentavos, file, receivedAt, note);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorFinanceApi->recordVendorPhysicalPayment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **amountCentavos** | **int**|  |
 **file** | **MultipartFile**| Private receipt evidence: JPG, PNG, WebP or PDF up to 10 MB; scanned fail-closed. |
 **receivedAt** | **DateTime**|  | [optional]
 **note** | **String**|  | [optional]

### Return type

[**PhysicalPaymentSummaryEnvelope**](PhysicalPaymentSummaryEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **refreshVendorFeePayment**
> PaymentAttemptEnvelope refreshVendorFeePayment(paymentId)



Owner-only authoritative status check.

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

final api = MateryalphApiClient().getVendorFinanceApi();
final String paymentId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.refreshVendorFeePayment(paymentId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorFinanceApi->refreshVendorFeePayment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **paymentId** | **String**|  |

### Return type

[**PaymentAttemptEnvelope**](PaymentAttemptEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **revealVendorTin**
> VendorTinRevealEnvelope revealVendorTin()



Owner-only. Returns the store's own full TIN and branch code on demand so the Owner can unmask the masked value shown in the Vendor Tax Profile summary and Tax registration. The response is never cached, each reveal is audited without recording the number, and the number is never returned to a Manager, staff member, Buyer, another Vendor or public surface.

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

final api = MateryalphApiClient().getVendorFinanceApi();

try {
    final response = api.revealVendorTin();
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorFinanceApi->revealVendorTin: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**VendorTinRevealEnvelope**](VendorTinRevealEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateVendorPhysicalPayments**
> PhysicalPaymentSettingsEnvelope updateVendorPhysicalPayments(physicalPaymentSettingsUpdate)



Owner-only. Enable Cash on Delivery (Site Delivery) or In-Store Payment (Self-Pickup) for future orders; both default off. lock_version 0 before the first save.

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

final api = MateryalphApiClient().getVendorFinanceApi();
final PhysicalPaymentSettingsUpdate physicalPaymentSettingsUpdate = ; // PhysicalPaymentSettingsUpdate |

try {
    final response = api.updateVendorPhysicalPayments(physicalPaymentSettingsUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorFinanceApi->updateVendorPhysicalPayments: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **physicalPaymentSettingsUpdate** | [**PhysicalPaymentSettingsUpdate**](PhysicalPaymentSettingsUpdate.md)|  |

### Return type

[**PhysicalPaymentSettingsEnvelope**](PhysicalPaymentSettingsEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

