# materyalph_api_client.api.BuyerFulfillmentApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**acknowledgeBuyerReimbursement**](BuyerFulfillmentApi.md#acknowledgebuyerreimbursement) | **POST** /buyers/orders/{orderId}/reimbursements/{reimbursementId}/acknowledge |
[**cancelBuyerOrder**](BuyerFulfillmentApi.md#cancelbuyerorder) | **POST** /buyers/orders/{orderId}/cancel |
[**confirmBuyerReceipt**](BuyerFulfillmentApi.md#confirmbuyerreceipt) | **POST** /buyers/orders/{orderId}/receipt/confirm |
[**getBuyerCancellationPreview**](BuyerFulfillmentApi.md#getbuyercancellationpreview) | **GET** /buyers/orders/{orderId}/cancellation-preview |
[**getBuyerOrderFile**](BuyerFulfillmentApi.md#getbuyerorderfile) | **GET** /buyers/orders/{orderId}/files/{fileId} |
[**reportBuyerProblem**](BuyerFulfillmentApi.md#reportbuyerproblem) | **POST** /buyers/orders/{orderId}/problems |
[**resolveBuyerProblem**](BuyerFulfillmentApi.md#resolvebuyerproblem) | **POST** /buyers/orders/{orderId}/problems/{issueId}/resolve |
[**withdrawBuyerCancellationRequest**](BuyerFulfillmentApi.md#withdrawbuyercancellationrequest) | **POST** /buyers/orders/{orderId}/cancellation-request/withdraw |


# **acknowledgeBuyerReimbursement**
> OrderDetailEnvelope acknowledgeBuyerReimbursement(orderId, reimbursementId, idempotencyKey)



Confirm receipt of an evidenced Vendor cash reimbursement (REIMBURSEMENT_CONFIRMED). Not a provider refund.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerFulfillmentApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String reimbursementId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.acknowledgeBuyerReimbursement(orderId, reimbursementId, idempotencyKey);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerFulfillmentApi->acknowledgeBuyerReimbursement: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |
 **reimbursementId** | **String**|  |
 **idempotencyKey** | **String**|  |

### Return type

[**OrderDetailEnvelope**](OrderDetailEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **cancelBuyerOrder**
> OrderDetailEnvelope cancelBuyerOrder(orderId, idempotencyKey, buyerCancelRequest)



Withdraw before Vendor confirmation, cancel before paying, cancel with a reason at CONFIRMED (final at once, full refund) or request cancellation with a reason during PROCESSING (CANCELLATION_REQUESTED; the Vendor has 24 hours). Unavailable at READY_FOR_PICKUP and later (409 CANCELLATION_UNAVAILABLE with remedies). A final paid cancellation creates exactly one Cancellation Refund per original payment and submits it immediately after commit.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerFulfillmentApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final BuyerCancelRequest buyerCancelRequest = ; // BuyerCancelRequest |

try {
    final response = api.cancelBuyerOrder(orderId, idempotencyKey, buyerCancelRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerFulfillmentApi->cancelBuyerOrder: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **buyerCancelRequest** | [**BuyerCancelRequest**](BuyerCancelRequest.md)|  |

### Return type

[**OrderDetailEnvelope**](OrderDetailEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **confirmBuyerReceipt**
> OrderDetailEnvelope confirmBuyerReceipt(orderId, idempotencyKey)



Confirm receipt after DELIVERED or PICKED_UP. Completes the order once and earns the commission once.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerFulfillmentApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.confirmBuyerReceipt(orderId, idempotencyKey);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerFulfillmentApi->confirmBuyerReceipt: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |
 **idempotencyKey** | **String**|  |

### Return type

[**OrderDetailEnvelope**](OrderDetailEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getBuyerCancellationPreview**
> BuyerCancellationPreviewEnvelope getBuyerCancellationPreview(orderId)



Server-computed availability and FIN-07 refund estimate from the original payments and allocations, with and without an evidenced NRPC retention.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerFulfillmentApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getBuyerCancellationPreview(orderId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerFulfillmentApi->getBuyerCancellationPreview: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |

### Return type

[**BuyerCancellationPreviewEnvelope**](BuyerCancellationPreviewEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getBuyerOrderFile**
> Uint8List getBuyerOrderFile(orderId, fileId)



Proof, problem and reimbursement evidence referenced by this order only.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerFulfillmentApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String fileId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getBuyerOrderFile(orderId, fileId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerFulfillmentApi->getBuyerOrderFile: $e\n');
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

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: image/png, image/jpeg, application/pdf, application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reportBuyerProblem**
> OrderDetailEnvelope reportBuyerProblem(orderId, idempotencyKey, category, description, files)



Report a Problem from READY_FOR_PICKUP until receipt. Pauses the 48-hour auto-confirmation; never opens a dispute or a refund.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerFulfillmentApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String category = category_example; // String |
final String description = description_example; // String |
final BuiltList<MultipartFile> files = /path/to/file.txt; // BuiltList<MultipartFile> | Up to three JPG or PNG photos.

try {
    final response = api.reportBuyerProblem(orderId, idempotencyKey, category, description, files);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerFulfillmentApi->reportBuyerProblem: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **category** | **String**|  |
 **description** | **String**|  |
 **files** | [**BuiltList&lt;MultipartFile&gt;**](MultipartFile.md)| Up to three JPG or PNG photos. | [optional]

### Return type

[**OrderDetailEnvelope**](OrderDetailEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resolveBuyerProblem**
> OrderDetailEnvelope resolveBuyerProblem(orderId, issueId, idempotencyKey, problemResolveRequest)



Mark the reported problem resolved; the remaining auto-confirmation time resumes.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerFulfillmentApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String issueId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ProblemResolveRequest problemResolveRequest = ; // ProblemResolveRequest |

try {
    final response = api.resolveBuyerProblem(orderId, issueId, idempotencyKey, problemResolveRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerFulfillmentApi->resolveBuyerProblem: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |
 **issueId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **problemResolveRequest** | [**ProblemResolveRequest**](ProblemResolveRequest.md)|  |

### Return type

[**OrderDetailEnvelope**](OrderDetailEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **withdrawBuyerCancellationRequest**
> OrderDetailEnvelope withdrawBuyerCancellationRequest(orderId, idempotencyKey)



Withdraw an open request; the order returns to PROCESSING.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerFulfillmentApi();
final String orderId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.withdrawBuyerCancellationRequest(orderId, idempotencyKey);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerFulfillmentApi->withdrawBuyerCancellationRequest: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderId** | **String**|  |
 **idempotencyKey** | **String**|  |

### Return type

[**OrderDetailEnvelope**](OrderDetailEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

