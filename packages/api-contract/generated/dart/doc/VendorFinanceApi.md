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
[**getVendorEarnings**](VendorFinanceApi.md#getvendorearnings) | **GET** /vendor/finance/earnings |
[**getVendorFeePayment**](VendorFinanceApi.md#getvendorfeepayment) | **GET** /vendor/finance/payments/{paymentId} |
[**getVendorFeeStatement**](VendorFinanceApi.md#getvendorfeestatement) | **GET** /vendor/finance/statements/{statementId} |
[**getVendorFinanceOverview**](VendorFinanceApi.md#getvendorfinanceoverview) | **GET** /vendor/finance |
[**listVendorTransactions**](VendorFinanceApi.md#listvendortransactions) | **GET** /vendor/finance/transactions |
[**payVendorFeeStatement**](VendorFinanceApi.md#payvendorfeestatement) | **POST** /vendor/finance/statements/{statementId}/payments |
[**recordVendorPhysicalPayment**](VendorFinanceApi.md#recordvendorphysicalpayment) | **POST** /vendor/orders/{orderId}/physical-payments |
[**refreshVendorFeePayment**](VendorFinanceApi.md#refreshvendorfeepayment) | **POST** /vendor/finance/payments/{paymentId}/refresh |
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
> String exportVendorTransactions(tab)



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

try {
    final response = api.exportVendorTransactions(tab);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorFinanceApi->exportVendorTransactions: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **tab** | **String**|  |

### Return type

**String**

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: text/csv, application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVendorEarnings**
> VendorEarningsEnvelope getVendorEarnings()



Owner-only FIN-11 Earnings with separate sales, collections, charges, simulated CWT and commission.

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
    final response = api.getVendorEarnings();
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorFinanceApi->getVendorEarnings: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

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
> FinanceTransactionListEnvelope listVendorTransactions(tab, page)



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

try {
    final response = api.listVendorTransactions(tab, page);
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

