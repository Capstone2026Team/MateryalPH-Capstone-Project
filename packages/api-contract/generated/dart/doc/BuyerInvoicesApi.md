# materyalph_api_client.api.BuyerInvoicesApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**answerBuyerInvoiceRequest**](BuyerInvoicesApi.md#answerbuyerinvoicerequest) | **POST** /buyers/orders/{orderId}/invoices/requests/{requestId}/answer |
[**getBuyerInvoiceFile**](BuyerInvoicesApi.md#getbuyerinvoicefile) | **GET** /buyers/invoice-records/{recordId}/content |
[**getBuyerOrderInvoices**](BuyerInvoicesApi.md#getbuyerorderinvoices) | **GET** /buyers/orders/{orderId}/invoices |
[**requestBuyerInvoice**](BuyerInvoicesApi.md#requestbuyerinvoice) | **POST** /buyers/orders/{orderId}/invoices/requests |
[**saveBuyerInvoiceDetails**](BuyerInvoicesApi.md#savebuyerinvoicedetails) | **PUT** /buyers/orders/{orderId}/invoices/details |


# **answerBuyerInvoiceRequest**
> BuyerOrderInvoicesEnvelope answerBuyerInvoiceRequest(orderId, requestId, idempotencyKey, invoiceRequestAnswer)



Return an uploaded document for correction, or close the request.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerInvoicesApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String requestId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final InvoiceRequestAnswer invoiceRequestAnswer = ; // InvoiceRequestAnswer |

try {
    final response = api.answerBuyerInvoiceRequest(orderId, requestId, idempotencyKey, invoiceRequestAnswer);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerInvoicesApi->answerBuyerInvoiceRequest: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |
 **requestId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **invoiceRequestAnswer** | [**InvoiceRequestAnswer**](InvoiceRequestAnswer.md)|  |

### Return type

[**BuyerOrderInvoicesEnvelope**](BuyerOrderInvoicesEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getBuyerInvoiceFile**
> Uint8List getBuyerInvoiceFile(recordId, expires, signature)



Invoice copy behind a signed link; the download is recorded.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerInvoicesApi();
final String recordId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final int expires = 56; // int |
final String signature = signature_example; // String |

try {
    final response = api.getBuyerInvoiceFile(recordId, expires, signature);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerInvoicesApi->getBuyerInvoiceFile: $e\n');
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

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: image/png, image/jpeg, application/pdf, application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getBuyerOrderInvoices**
> BuyerOrderInvoicesEnvelope getBuyerOrderInvoices(orderId)



Invoice copies as soon as the Vendor uploads them (not only after completion), requests with their three-business-day target and MateryalPH documents labelled not a tax invoice.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerInvoicesApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getBuyerOrderInvoices(orderId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerInvoicesApi->getBuyerOrderInvoices: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |

### Return type

[**BuyerOrderInvoicesEnvelope**](BuyerOrderInvoicesEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **requestBuyerInvoice**
> BuyerOrderInvoicesEnvelope requestBuyerInvoice(orderId, idempotencyKey, invoiceRequestCreate)



Request a copy or a correction. The service target never extends the Vendor's legal issuance deadline.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerInvoicesApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final InvoiceRequestCreate invoiceRequestCreate = ; // InvoiceRequestCreate |

try {
    final response = api.requestBuyerInvoice(orderId, idempotencyKey, invoiceRequestCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerInvoicesApi->requestBuyerInvoice: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **invoiceRequestCreate** | [**InvoiceRequestCreate**](InvoiceRequestCreate.md)|  |

### Return type

[**BuyerOrderInvoicesEnvelope**](BuyerOrderInvoicesEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **saveBuyerInvoiceDetails**
> BuyerOrderInvoicesEnvelope saveBuyerInvoiceDetails(orderId, invoiceBillingDetailsRequest)



Billing name, address and optional TIN for the Vendor's invoice. Stale lock_version returns 409.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerInvoicesApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final InvoiceBillingDetailsRequest invoiceBillingDetailsRequest = ; // InvoiceBillingDetailsRequest |

try {
    final response = api.saveBuyerInvoiceDetails(orderId, invoiceBillingDetailsRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerInvoicesApi->saveBuyerInvoiceDetails: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |
 **invoiceBillingDetailsRequest** | [**InvoiceBillingDetailsRequest**](InvoiceBillingDetailsRequest.md)|  |

### Return type

[**BuyerOrderInvoicesEnvelope**](BuyerOrderInvoicesEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

