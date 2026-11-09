# materyalph_api_client.api.VendorInvoicesApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**downloadVendorInvoiceDraft**](VendorInvoicesApi.md#downloadvendorinvoicedraft) | **GET** /vendor/invoice-drafts/{draftId}/files/{fileId} |
[**explainVendorInvoiceDifference**](VendorInvoicesApi.md#explainvendorinvoicedifference) | **POST** /vendor/orders/{orderId}/invoices/{recordId}/explanation |
[**getVendorInvoiceFile**](VendorInvoicesApi.md#getvendorinvoicefile) | **GET** /vendor/invoice-records/{recordId}/content |
[**getVendorInvoicePreset**](VendorInvoicesApi.md#getvendorinvoicepreset) | **GET** /vendor/invoices/preset |
[**getVendorOrderInvoices**](VendorInvoicesApi.md#getvendororderinvoices) | **GET** /vendor/orders/{orderId}/invoices |
[**listVendorInvoices**](VendorInvoicesApi.md#listvendorinvoices) | **GET** /vendor/invoices |
[**saveVendorInvoicePreset**](VendorInvoicesApi.md#savevendorinvoicepreset) | **PUT** /vendor/invoices/preset |
[**sendVendorInvoice**](VendorInvoicesApi.md#sendvendorinvoice) | **POST** /vendor/orders/{orderId}/invoices/send |
[**uploadVendorInvoice**](VendorInvoicesApi.md#uploadvendorinvoice) | **POST** /vendor/orders/{orderId}/invoices |


# **downloadVendorInvoiceDraft**
> Uint8List downloadVendorInvoiceDraft(draftId, fileId, expires, signature)



invoices.upload. Authorized, short-lived private draft preview. Reauthorizes the current Vendor role, store, order and current file. A replaced file link fails closed. Never available to Buyers.

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
final String draftId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String fileId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final int expires = 56; // int |
final String signature = signature_example; // String |

try {
    final response = api.downloadVendorInvoiceDraft(draftId, fileId, expires, signature);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorInvoicesApi->downloadVendorInvoiceDraft: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **draftId** | **String**|  |
 **fileId** | **String**|  |
 **expires** | **int**|  |
 **signature** | **String**|  |

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/octet-stream, application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

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

# **getVendorInvoicePreset**
> VendorInvoicePresetEnvelope getVendorInvoicePreset()



invoices.view. Returns the store invoice defaults and current lock_version. Invoice dates default to today in Asia/Manila.

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

try {
    final response = api.getVendorInvoicePreset();
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorInvoicesApi->getVendorInvoicePreset: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**VendorInvoicePresetEnvelope**](VendorInvoicePresetEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

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



invoices.view. Open requests, orders without an invoice copy yet, uploaded records and reconciliation items. Never Earnings or other protected finance. Every Vendor list row includes its authorized order_id for opening the order invoice details.

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

# **saveVendorInvoicePreset**
> VendorInvoicePresetEnvelope saveVendorInvoicePreset(idempotencyKey, invoicePresetInput)



invoices.upload. Saves the store invoice defaults with current lock_version and Idempotency-Key. Presets apply to future preparations only; sent records never change. Invoice dates default to today in Asia/Manila, while invoice numbers and amounts stay document-specific.

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
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final InvoicePresetInput invoicePresetInput = ; // InvoicePresetInput |

try {
    final response = api.saveVendorInvoicePreset(idempotencyKey, invoicePresetInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorInvoicesApi->saveVendorInvoicePreset: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String**|  |
 **invoicePresetInput** | [**InvoicePresetInput**](InvoicePresetInput.md)|  |

### Return type

[**VendorInvoicePresetEnvelope**](VendorInvoicePresetEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **sendVendorInvoice**
> VendorOrderInvoicesEnvelope sendVendorInvoice(orderId, idempotencyKey, invoiceSendInput)



invoices.upload. Sends the saved, clean draft exactly once, creates an immutable invoice version, fulfills the applicable Buyer request and notifies the Buyer after commit. The Buyer email includes the exact uploaded invoice file and a summary of the sent invoice. Delivery rechecks current Buyer access, clean private storage and attachment integrity. Requires the current lock_version. No file means no send. A sent version cannot be edited or resent with a new key until the Buyer returns it or requests a correction.

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
final InvoiceSendInput invoiceSendInput = ; // InvoiceSendInput |

try {
    final response = api.sendVendorInvoice(orderId, idempotencyKey, invoiceSendInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorInvoicesApi->sendVendorInvoice: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **invoiceSendInput** | [**InvoiceSendInput**](InvoiceSendInput.md)|  |

### Return type

[**VendorOrderInvoicesEnvelope**](VendorOrderInvoicesEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **uploadVendorInvoice**
> VendorOrderInvoicesEnvelope uploadVendorInvoice(orderId, idempotencyKey, invoiceType, issuerName, invoiceNumber, issuedOn, amountCentavos, sourceSystem, invoicingMethod, lockVersion, vatCentavos, vatExemptCentavos, zeroRatedCentavos, relatedLineIds, amendsInvoiceRecordId, invoiceRequestId, file)



invoices.upload. Save or replace the private invoice draft with optimistic concurrency and Idempotency-Key. Uploading never sends to the Buyer. After Send, preparation is locked until the Buyer requests a correction or returns the latest copy. No accepted Buyer total changes.

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
final Date issuedOn = 2013-10-20; // Date | Invoice calendar date; must not be later than today in Asia/Manila.
final int amountCentavos = 56; // int |
final String sourceSystem = sourceSystem_example; // String |
final String invoicingMethod = invoicingMethod_example; // String |
final int lockVersion = 56; // int | Current lock version; zero creates a new draft or preset.
final int vatCentavos = 56; // int |
final int vatExemptCentavos = 56; // int |
final int zeroRatedCentavos = 56; // int |
final BuiltList<String> relatedLineIds = ; // BuiltList<String> |
final String amendsInvoiceRecordId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String invoiceRequestId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final MultipartFile file = BINARY_DATA_HERE; // MultipartFile | PDF, JPG or PNG, validated and scanned fail-closed. Required for a new draft; omit to retain its current file.

try {
    final response = api.uploadVendorInvoice(orderId, idempotencyKey, invoiceType, issuerName, invoiceNumber, issuedOn, amountCentavos, sourceSystem, invoicingMethod, lockVersion, vatCentavos, vatExemptCentavos, zeroRatedCentavos, relatedLineIds, amendsInvoiceRecordId, invoiceRequestId, file);
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
 **issuedOn** | **Date**| Invoice calendar date; must not be later than today in Asia/Manila. |
 **amountCentavos** | **int**|  |
 **sourceSystem** | **String**|  |
 **invoicingMethod** | **String**|  |
 **lockVersion** | **int**| Current lock version; zero creates a new draft or preset. |
 **vatCentavos** | **int**|  | [optional]
 **vatExemptCentavos** | **int**|  | [optional]
 **zeroRatedCentavos** | **int**|  | [optional]
 **relatedLineIds** | [**BuiltList&lt;String&gt;**](String.md)|  | [optional]
 **amendsInvoiceRecordId** | **String**|  | [optional]
 **invoiceRequestId** | **String**|  | [optional]
 **file** | **MultipartFile**| PDF, JPG or PNG, validated and scanned fail-closed. Required for a new draft; omit to retain its current file. | [optional]

### Return type

[**VendorOrderInvoicesEnvelope**](VendorOrderInvoicesEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

