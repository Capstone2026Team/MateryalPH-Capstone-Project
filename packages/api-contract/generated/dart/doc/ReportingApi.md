# materyalph_api_client.api.ReportingApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**downloadDocumentExport**](ReportingApi.md#downloaddocumentexport) | **GET** /{audience}/reports/{exportId}/download | download Document Export
[**getTaxPackage**](ReportingApi.md#gettaxpackage) | **GET** /admin/reports/tax/{packageId} | get Tax Package
[**listDocumentExports**](ReportingApi.md#listdocumentexports) | **GET** /{audience}/reports | list Document Exports
[**listTaxPackages**](ReportingApi.md#listtaxpackages) | **GET** /admin/reports/tax | list Tax Packages
[**prepareTaxPackage**](ReportingApi.md#preparetaxpackage) | **POST** /admin/reports/tax | prepare Tax Package
[**recordTaxSimulation**](ReportingApi.md#recordtaxsimulation) | **POST** /admin/reports/tax/{packageId}/simulation | record Tax Simulation
[**requestDocumentExport**](ReportingApi.md#requestdocumentexport) | **POST** /{audience}/reports | request Document Export
[**reviewTaxPackage**](ReportingApi.md#reviewtaxpackage) | **POST** /admin/reports/tax/{packageId}/review | review Tax Package


# **downloadDocumentExport**
> Uint8List downloadDocumentExport(audience, exportId)

download Document Export



### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getReportingApi();
final String audience = audience_example; // String | Authenticated surface. The server rejects mismatched account types.
final String exportId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.downloadDocumentExport(audience, exportId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ReportingApi->downloadDocumentExport: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **audience** | **String**| Authenticated surface. The server rejects mismatched account types. |
 **exportId** | **String**|  |

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/octet-stream, application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getTaxPackage**
> PrepareTaxPackage201Response getTaxPackage(packageId)

get Tax Package



### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getReportingApi();
final String packageId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getTaxPackage(packageId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ReportingApi->getTaxPackage: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **packageId** | **String**|  |

### Return type

[**PrepareTaxPackage201Response**](PrepareTaxPackage201Response.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listDocumentExports**
> ListDocumentExports200Response listDocumentExports(audience, page, type, resourceId, format, from, to)

list Document Exports

Lists the actor's currently authorized exports, optionally scoped to the document type, source record and format. READY artifacts past their download deadline are returned as EXPIRED.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getReportingApi();
final String audience = audience_example; // String | Authenticated surface. The server rejects mismatched account types.
final int page = 56; // int |
final String type = type_example; // String |
final String resourceId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String format = format_example; // String |
final Date from = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omitted boundary unrestricted. Export requested_at (created_at); each download rechecks current permissions.
final Date to = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omitted boundary unrestricted. Export requested_at (created_at); each download rechecks current permissions.

try {
    final response = api.listDocumentExports(audience, page, type, resourceId, format, from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ReportingApi->listDocumentExports: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **audience** | **String**| Authenticated surface. The server rejects mismatched account types. |
 **page** | **int**|  | [optional]
 **type** | **String**|  | [optional]
 **resourceId** | **String**|  | [optional]
 **format** | **String**|  | [optional]
 **from** | **Date**| Inclusive Asia/Manila calendar date; omitted boundary unrestricted. Export requested_at (created_at); each download rechecks current permissions. | [optional]
 **to** | **Date**| Inclusive Asia/Manila calendar date; omitted boundary unrestricted. Export requested_at (created_at); each download rechecks current permissions. | [optional]

### Return type

[**ListDocumentExports200Response**](ListDocumentExports200Response.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listTaxPackages**
> ListTaxPackages200Response listTaxPackages(page, from, to)

list Tax Packages



### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getReportingApi();
final int page = 56; // int |
final Date from = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omitted boundary unrestricted. Report package created_at; statutory reporting periods remain immutable.
final Date to = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omitted boundary unrestricted. Report package created_at; statutory reporting periods remain immutable.

try {
    final response = api.listTaxPackages(page, from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ReportingApi->listTaxPackages: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **int**|  | [optional]
 **from** | **Date**| Inclusive Asia/Manila calendar date; omitted boundary unrestricted. Report package created_at; statutory reporting periods remain immutable. | [optional]
 **to** | **Date**| Inclusive Asia/Manila calendar date; omitted boundary unrestricted. Report package created_at; statutory reporting periods remain immutable. | [optional]

### Return type

[**ListTaxPackages200Response**](ListTaxPackages200Response.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **prepareTaxPackage**
> PrepareTaxPackage201Response prepareTaxPackage(idempotencyKey, taxPackageInput)

prepare Tax Package



### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getReportingApi();
final String idempotencyKey = idempotencyKey_example; // String |
final TaxPackageInput taxPackageInput = ; // TaxPackageInput |

try {
    final response = api.prepareTaxPackage(idempotencyKey, taxPackageInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ReportingApi->prepareTaxPackage: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String**|  |
 **taxPackageInput** | [**TaxPackageInput**](TaxPackageInput.md)|  |

### Return type

[**PrepareTaxPackage201Response**](PrepareTaxPackage201Response.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **recordTaxSimulation**
> RecordTaxSimulation200Response recordTaxSimulation(packageId)

record Tax Simulation

Only SIMULATED_SUBMISSION_RECORDED after export; never FILED or BIR_PAID, no government receipt.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getReportingApi();
final String packageId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.recordTaxSimulation(packageId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ReportingApi->recordTaxSimulation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **packageId** | **String**|  |

### Return type

[**RecordTaxSimulation200Response**](RecordTaxSimulation200Response.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **requestDocumentExport**
> RequestDocumentExport202Response requestDocumentExport(audience, idempotencyKey, documentExportInput)

request Document Export

Private immutable snapshot. Current access checked at request, generation and download. Admin requires recent authentication. Files expire 24 hours after generation. MAT audience suppression applies.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getReportingApi();
final String audience = audience_example; // String | Authenticated surface. The server rejects mismatched account types.
final String idempotencyKey = idempotencyKey_example; // String |
final DocumentExportInput documentExportInput = ; // DocumentExportInput |

try {
    final response = api.requestDocumentExport(audience, idempotencyKey, documentExportInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ReportingApi->requestDocumentExport: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **audience** | **String**| Authenticated surface. The server rejects mismatched account types. |
 **idempotencyKey** | **String**|  |
 **documentExportInput** | [**DocumentExportInput**](DocumentExportInput.md)|  |

### Return type

[**RequestDocumentExport202Response**](RequestDocumentExport202Response.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reviewTaxPackage**
> PrepareTaxPackage201Response reviewTaxPackage(packageId, taxPackageReview)

review Tax Package

Independent finance reviewer, source reconciliation and cited actual deadline required. Nominal deadline retained. No live tax filing.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getReportingApi();
final String packageId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final TaxPackageReview taxPackageReview = ; // TaxPackageReview |

try {
    final response = api.reviewTaxPackage(packageId, taxPackageReview);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ReportingApi->reviewTaxPackage: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **packageId** | **String**|  |
 **taxPackageReview** | [**TaxPackageReview**](TaxPackageReview.md)|  |

### Return type

[**PrepareTaxPackage201Response**](PrepareTaxPackage201Response.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

