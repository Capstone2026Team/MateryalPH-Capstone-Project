# materyalph_api_client.api.VendorInvoicesApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**explainVendorInvoiceDifference**](VendorInvoicesApi.md#explainvendorinvoicedifference) | **POST** /vendor/orders/{orderId}/invoices/{recordId}/explanation |
[**getVendorInvoiceFile**](VendorInvoicesApi.md#getvendorinvoicefile) | **GET** /vendor/invoice-records/{recordId}/content |
[**getVendorOrderInvoices**](VendorInvoicesApi.md#getvendororderinvoices) | **GET** /vendor/orders/{orderId}/invoices |
[**listVendorInvoices**](VendorInvoicesApi.md#listvendorinvoices) | **GET** /vendor/invoices |
[**uploadVendorInvoice**](VendorInvoicesApi.md#uploadvendorinvoice) | **POST** /vendor/orders/{orderId}/invoices |


# **explainVendorInvoiceDifference**
> VendorOrderInvoicesEnvelope explainVendorInvoiceDifference(orderId, recordId, idempotencyKey, invoiceExplanationRequest)



invoices.upload. Explain a reconciliation difference.

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

final api = MateryalphApiClient().getVendorInvoicesApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String recordId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final InvoiceExplanationRequest invoiceExplanationRequest = ; // InvoiceExplanationRequest |

try {
    final response = api.explainVendorInvoiceDifference(orderId, recordId, idempotencyKey, invoiceExplanationRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorInvoicesApi->explainVendorInvoiceDifference: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |
 **recordId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **invoiceExplanationRequest** | [**InvoiceExplanationRequest**](InvoiceExplanationRequest.md)|  |

### Return type

[**VendorOrderInvoicesEnvelope**](VendorOrderInvoicesEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVendorInvoiceFile**
> Uint8List getVendorInvoiceFile(recordId, expires, signature)



Owner, Store Manager, Store Staff, or the assigned Fulfillment Staff; signed link; recorded.

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

final api = MateryalphApiClient().getVendorInvoicesApi();
final String recordId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final int expires = 56; // int |
final String signature = signature_example; // String |

try {
    final response = api.getVendorInvoiceFile(recordId, expires, signature);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorInvoicesApi->getVendorInvoiceFile: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **recordId** | **String**|  |
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

# **getVendorOrderInvoices**
> VendorOrderInvoicesEnvelope getVendorOrderInvoices(orderId)



invoices.view. Customer Service sees status and metadata only; the full Buyer TIN only for roles that upload.

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

final api = MateryalphApiClient().getVendorInvoicesApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getVendorOrderInvoices(orderId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorInvoicesApi->getVendorOrderInvoices: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |

### Return type

[**VendorOrderInvoicesEnvelope**](VendorOrderInvoicesEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listVendorInvoices**
> InvoiceLogEnvelope listVendorInvoices(view, page, from, to)



invoices.view. Open requests, orders without an invoice copy yet, uploaded records and reconciliation items. Never Earnings or other protected finance.

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

final api = MateryalphApiClient().getVendorInvoicesApi();
final String view = view_example; // String |
final int page = 56; // int |
final Date from = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Invoice issued_on for RECORDS/RECONCILIATION, request created_at for REQUESTS, and accepted_at for DUE orders. Tab counts retain their existing unrestricted scope.
final Date to = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Invoice issued_on for RECORDS/RECONCILIATION, request created_at for REQUESTS, and accepted_at for DUE orders. Tab counts retain their existing unrestricted scope.

try {
    final response = api.listVendorInvoices(view, page, from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorInvoicesApi->listVendorInvoices: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **view** | **String**|  | [optional]
 **page** | **int**|  | [optional]
 **from** | **Date**| Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Invoice issued_on for RECORDS/RECONCILIATION, request created_at for REQUESTS, and accepted_at for DUE orders. Tab counts retain their existing unrestricted scope. | [optional]
 **to** | **Date**| Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Invoice issued_on for RECORDS/RECONCILIATION, request created_at for REQUESTS, and accepted_at for DUE orders. Tab counts retain their existing unrestricted scope. | [optional]

### Return type

[**InvoiceLogEnvelope**](InvoiceLogEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **uploadVendorInvoice**
> VendorOrderInvoicesEnvelope uploadVendorInvoice(orderId, idempotencyKey, invoiceType, issuerName, invoiceNumber, issuedOn, amountCentavos, sourceSystem, invoicingMethod, file, vatCentavos, vatExemptCentavos, zeroRatedCentavos, relatedLineIds, amendsInvoiceRecordId, invoiceRequestId)



invoices.upload (Owner, Store Manager, Store Staff). Validates type and issuer; a total or VAT difference opens INVOICE_RECONCILIATION_REQUIRED without changing the accepted Buyer total.

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

final api = MateryalphApiClient().getVendorInvoicesApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String invoiceType = invoiceType_example; // String |
final String issuerName = issuerName_example; // String | Must equal the registered business name.
final String invoiceNumber = invoiceNumber_example; // String |
final Date issuedOn = 2013-10-20; // Date |
final int amountCentavos = 56; // int |
final String sourceSystem = sourceSystem_example; // String |
final String invoicingMethod = invoicingMethod_example; // String |
final MultipartFile file = BINARY_DATA_HERE; // MultipartFile | PDF, JPG or PNG copy, validated and scanned fail-closed, stored privately.
final int vatCentavos = 56; // int |
final int vatExemptCentavos = 56; // int |
final int zeroRatedCentavos = 56; // int |
final BuiltList<String> relatedLineIds = ; // BuiltList<String> |
final String amendsInvoiceRecordId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String invoiceRequestId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.uploadVendorInvoice(orderId, idempotencyKey, invoiceType, issuerName, invoiceNumber, issuedOn, amountCentavos, sourceSystem, invoicingMethod, file, vatCentavos, vatExemptCentavos, zeroRatedCentavos, relatedLineIds, amendsInvoiceRecordId, invoiceRequestId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorInvoicesApi->uploadVendorInvoice: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **invoiceType** | **String**|  |
 **issuerName** | **String**| Must equal the registered business name. |
 **invoiceNumber** | **String**|  |
 **issuedOn** | **Date**|  |
 **amountCentavos** | **int**|  |
 **sourceSystem** | **String**|  |
 **invoicingMethod** | **String**|  |
 **file** | **MultipartFile**| PDF, JPG or PNG copy, validated and scanned fail-closed, stored privately. |
 **vatCentavos** | **int**|  | [optional]
 **vatExemptCentavos** | **int**|  | [optional]
 **zeroRatedCentavos** | **int**|  | [optional]
 **relatedLineIds** | [**BuiltList&lt;String&gt;**](String.md)|  | [optional]
 **amendsInvoiceRecordId** | **String**|  | [optional]
 **invoiceRequestId** | **String**|  | [optional]

### Return type

[**VendorOrderInvoicesEnvelope**](VendorOrderInvoicesEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

