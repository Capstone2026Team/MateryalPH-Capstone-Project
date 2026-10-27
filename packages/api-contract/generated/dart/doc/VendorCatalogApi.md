# materyalph_api_client.api.VendorCatalogApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**applyCatalogImport**](VendorCatalogApi.md#applycatalogimport) | **POST** /vendor/catalog/imports/{jobId}/apply |
[**createVendorCatalogListing**](VendorCatalogApi.md#createvendorcataloglisting) | **POST** /vendor/catalog/listings |
[**deactivateVendorCatalogListing**](VendorCatalogApi.md#deactivatevendorcataloglisting) | **POST** /vendor/catalog/listings/{listingId}/deactivate |
[**deleteVendorCatalogListing**](VendorCatalogApi.md#deletevendorcataloglisting) | **DELETE** /vendor/catalog/listings/{listingId} |
[**downloadCatalogFile**](VendorCatalogApi.md#downloadcatalogfile) | **GET** /catalog-files/{fileId}/content |
[**getCatalogImport**](VendorCatalogApi.md#getcatalogimport) | **GET** /vendor/catalog/imports/{jobId} |
[**getCatalogImportTemplate**](VendorCatalogApi.md#getcatalogimporttemplate) | **GET** /vendor/catalog/imports/template |
[**getCatalogMaterial**](VendorCatalogApi.md#getcatalogmaterial) | **GET** /vendor/catalog/materials/{materialId} |
[**getVendorCatalogFileUrl**](VendorCatalogApi.md#getvendorcatalogfileurl) | **GET** /vendor/catalog/files/{fileId} |
[**getVendorCatalogListing**](VendorCatalogApi.md#getvendorcataloglisting) | **GET** /vendor/catalog/listings/{listingId} |
[**getVendorCatalogTaxonomy**](VendorCatalogApi.md#getvendorcatalogtaxonomy) | **GET** /vendor/catalog/taxonomy |
[**listVendorCatalogListings**](VendorCatalogApi.md#listvendorcataloglistings) | **GET** /vendor/catalog/listings |
[**lookupListingCompliance**](VendorCatalogApi.md#lookuplistingcompliance) | **POST** /vendor/catalog/listings/{listingId}/compliance/lookup |
[**publishVendorCatalogListing**](VendorCatalogApi.md#publishvendorcataloglisting) | **POST** /vendor/catalog/listings/{listingId}/publish |
[**removeVendorListingMedia**](VendorCatalogApi.md#removevendorlistingmedia) | **DELETE** /vendor/catalog/listings/{listingId}/media/{mediaId} |
[**saveVendorCatalogVariants**](VendorCatalogApi.md#savevendorcatalogvariants) | **PUT** /vendor/catalog/listings/{listingId}/variants |
[**searchCatalogMaterials**](VendorCatalogApi.md#searchcatalogmaterials) | **GET** /vendor/catalog/materials/search |
[**submitListingCompliance**](VendorCatalogApi.md#submitlistingcompliance) | **POST** /vendor/catalog/listings/{listingId}/compliance |
[**updateVendorCatalogListing**](VendorCatalogApi.md#updatevendorcataloglisting) | **PATCH** /vendor/catalog/listings/{listingId} |
[**uploadCatalogImport**](VendorCatalogApi.md#uploadcatalogimport) | **POST** /vendor/catalog/imports |
[**uploadListingComplianceEvidence**](VendorCatalogApi.md#uploadlistingcomplianceevidence) | **POST** /vendor/catalog/listings/{listingId}/compliance/evidence |
[**uploadVendorListingMedia**](VendorCatalogApi.md#uploadvendorlistingmedia) | **POST** /vendor/catalog/listings/{listingId}/media |


# **applyCatalogImport**
> CatalogImportJobEnvelope applyCatalogImport(jobId, idempotencyKey)



Revalidates and creates DRAFT listings from every valid row in one transaction; any failure applies nothing. APPLIED_WITH_REJECTIONS reports rows that were not imported.

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

final api = MateryalphApiClient().getVendorCatalogApi();
final String jobId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.applyCatalogImport(jobId, idempotencyKey);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorCatalogApi->applyCatalogImport: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **jobId** | **String**|  |
 **idempotencyKey** | **String**|  |

### Return type

[**CatalogImportJobEnvelope**](CatalogImportJobEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createVendorCatalogListing**
> CatalogListingEnvelope createVendorCatalogListing(idempotencyKey, catalogListingCreate)



Creates a DRAFT listing. Requires catalog.manage and Store Activation. Rental services are rejected.

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

final api = MateryalphApiClient().getVendorCatalogApi();
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final CatalogListingCreate catalogListingCreate = ; // CatalogListingCreate |

try {
    final response = api.createVendorCatalogListing(idempotencyKey, catalogListingCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorCatalogApi->createVendorCatalogListing: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String**|  |
 **catalogListingCreate** | [**CatalogListingCreate**](CatalogListingCreate.md)|  |

### Return type

[**CatalogListingEnvelope**](CatalogListingEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deactivateVendorCatalogListing**
> CatalogListingEnvelope deactivateVendorCatalogListing(listingId, catalogDeactivation)



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

final api = MateryalphApiClient().getVendorCatalogApi();
final String listingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final CatalogDeactivation catalogDeactivation = ; // CatalogDeactivation |

try {
    final response = api.deactivateVendorCatalogListing(listingId, catalogDeactivation);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorCatalogApi->deactivateVendorCatalogListing: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **listingId** | **String**|  |
 **catalogDeactivation** | [**CatalogDeactivation**](CatalogDeactivation.md)|  |

### Return type

[**CatalogListingEnvelope**](CatalogListingEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteVendorCatalogListing**
> CatalogListingDeletedEnvelope deleteVendorCatalogListing(listingId, lockVersion)



Deletes a listing that was never published (publication_version 0). It disappears from the catalog and its Vendor SKU can be reused; the record and audit trail are kept, and a pending PS/ICC submission is superseded. A listing that was ever published returns 409 LISTING_HAS_PUBLICATION_HISTORY and must be deactivated instead.

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

final api = MateryalphApiClient().getVendorCatalogApi();
final String listingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final int lockVersion = 56; // int |

try {
    final response = api.deleteVendorCatalogListing(listingId, lockVersion);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorCatalogApi->deleteVendorCatalogListing: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **listingId** | **String**|  |
 **lockVersion** | **int**|  |

### Return type

[**CatalogListingDeletedEnvelope**](CatalogListingDeletedEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **downloadCatalogFile**
> Uint8List downloadCatalogFile(fileId)



### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorCatalogApi();
final String fileId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.downloadCatalogFile(fileId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorCatalogApi->downloadCatalogFile: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **fileId** | **String**|  |

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/octet-stream, application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getCatalogImport**
> CatalogImportJobEnvelope getCatalogImport(jobId, page)



### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorCatalogApi();
final String jobId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final int page = 56; // int | Page of the row-error table.

try {
    final response = api.getCatalogImport(jobId, page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorCatalogApi->getCatalogImport: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **jobId** | **String**|  |
 **page** | **int**| Page of the row-error table. | [optional]

### Return type

[**CatalogImportJobEnvelope**](CatalogImportJobEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getCatalogImportTemplate**
> CatalogImportTemplateEnvelope getCatalogImportTemplate()



### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorCatalogApi();

try {
    final response = api.getCatalogImportTemplate();
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorCatalogApi->getCatalogImportTemplate: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**CatalogImportTemplateEnvelope**](CatalogImportTemplateEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getCatalogMaterial**
> CatalogMaterialEnvelope getCatalogMaterial(materialId)



### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorCatalogApi();
final String materialId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getCatalogMaterial(materialId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorCatalogApi->getCatalogMaterial: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **materialId** | **String**|  |

### Return type

[**CatalogMaterialEnvelope**](CatalogMaterialEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVendorCatalogFileUrl**
> VendorFileEnvelope getVendorCatalogFileUrl(fileId)



### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorCatalogApi();
final String fileId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getVendorCatalogFileUrl(fileId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorCatalogApi->getVendorCatalogFileUrl: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **fileId** | **String**|  |

### Return type

[**VendorFileEnvelope**](VendorFileEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVendorCatalogListing**
> CatalogListingEnvelope getVendorCatalogListing(listingId)



### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorCatalogApi();
final String listingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getVendorCatalogListing(listingId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorCatalogApi->getVendorCatalogListing: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **listingId** | **String**|  |

### Return type

[**CatalogListingEnvelope**](CatalogListingEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVendorCatalogTaxonomy**
> CatalogTaxonomyEnvelope getVendorCatalogTaxonomy()



Canonical categories, units, approved search tags, category technical attributes, FIN-02 tax classifications and the classifications permitted by the Vendor's reviewed VAT profile. An empty allowed list means payable publication is blocked.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorCatalogApi();

try {
    final response = api.getVendorCatalogTaxonomy();
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorCatalogApi->getVendorCatalogTaxonomy: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**CatalogTaxonomyEnvelope**](CatalogTaxonomyEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listVendorCatalogListings**
> CatalogListingSummaryListEnvelope listVendorCatalogListings(group, status, complianceStatus, categoryId, q, page)



Paginated organization listings. Customer Service Staff receive the sales stock view; Fulfillment Staff receive only assigned products (meta.scope ASSIGNED_ONLY).

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorCatalogApi();
final String group = group_example; // String | Read-only aggregate filter applied before pagination; summary counts ignore group and status. OUT_OF_STOCK means active listings with no available active variant.
final ListingStatus status = ; // ListingStatus |
final ListingComplianceStatus complianceStatus = ; // ListingComplianceStatus |
final String categoryId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String q = q_example; // String |
final int page = 56; // int |

try {
    final response = api.listVendorCatalogListings(group, status, complianceStatus, categoryId, q, page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorCatalogApi->listVendorCatalogListings: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **group** | **String**| Read-only aggregate filter applied before pagination; summary counts ignore group and status. OUT_OF_STOCK means active listings with no available active variant. | [optional]
 **status** | [**ListingStatus**](.md)|  | [optional]
 **complianceStatus** | [**ListingComplianceStatus**](.md)|  | [optional]
 **categoryId** | **String**|  | [optional]
 **q** | **String**|  | [optional]
 **page** | **int**|  | [optional]

### Return type

[**CatalogListingSummaryListEnvelope**](CatalogListingSummaryListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **lookupListingCompliance**
> ComplianceLookupEnvelope lookupListingCompliance(listingId, complianceLookupRequest)



Looks up a PS License No. or ICC sticker serial in the active DTI-BPS register snapshot for this listing's regulated product (rule compliance.register-number.v2) and returns the register record used to prefill the declaration. Read-only — nothing is submitted and nothing reaches Admin review. MATCHED means automatic verification is possible; UNCERTAIN means the number is listed for another product or an expired record; UNMATCHED means it is not listed or is not in the printed format; UNAVAILABLE means no snapshot is active.

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

final api = MateryalphApiClient().getVendorCatalogApi();
final String listingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ComplianceLookupRequest complianceLookupRequest = ; // ComplianceLookupRequest |

try {
    final response = api.lookupListingCompliance(listingId, complianceLookupRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorCatalogApi->lookupListingCompliance: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **listingId** | **String**|  |
 **complianceLookupRequest** | [**ComplianceLookupRequest**](ComplianceLookupRequest.md)|  |

### Return type

[**ComplianceLookupEnvelope**](ComplianceLookupEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **publishVendorCatalogListing**
> CatalogListingEnvelope publishVendorCatalogListing(listingId, idempotencyKey, catalogLockVersion)



Requests publication. The backend evaluates every blocker; a regulated listing moves to PENDING_COMPLIANCE or PENDING_ADMIN_REVIEW until its PS/ICC evidence is VERIFIED and only then becomes ACTIVE.

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

final api = MateryalphApiClient().getVendorCatalogApi();
final String listingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final CatalogLockVersion catalogLockVersion = ; // CatalogLockVersion |

try {
    final response = api.publishVendorCatalogListing(listingId, idempotencyKey, catalogLockVersion);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorCatalogApi->publishVendorCatalogListing: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **listingId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **catalogLockVersion** | [**CatalogLockVersion**](CatalogLockVersion.md)|  |

### Return type

[**CatalogListingEnvelope**](CatalogListingEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **removeVendorListingMedia**
> CatalogListingEnvelope removeVendorListingMedia(listingId, mediaId)



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

final api = MateryalphApiClient().getVendorCatalogApi();
final String listingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String mediaId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.removeVendorListingMedia(listingId, mediaId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorCatalogApi->removeVendorListingMedia: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **listingId** | **String**|  |
 **mediaId** | **String**|  |

### Return type

[**CatalogListingEnvelope**](CatalogListingEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **saveVendorCatalogVariants**
> CatalogListingEnvelope saveVendorCatalogVariants(listingId, catalogVariantsSave)



Replaces the variant row group atomically. All row errors return together keyed variants.{index}.{field}. Price changes create a new immutable ordinary price version; omitted variants are deactivated, never deleted.

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

final api = MateryalphApiClient().getVendorCatalogApi();
final String listingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final CatalogVariantsSave catalogVariantsSave = ; // CatalogVariantsSave |

try {
    final response = api.saveVendorCatalogVariants(listingId, catalogVariantsSave);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorCatalogApi->saveVendorCatalogVariants: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **listingId** | **String**|  |
 **catalogVariantsSave** | [**CatalogVariantsSave**](CatalogVariantsSave.md)|  |

### Return type

[**CatalogListingEnvelope**](CatalogListingEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchCatalogMaterials**
> CatalogMaterialMatchListEnvelope searchCatalogMaterials(q)



Normalizes the query, returns exact canonical or alias matches first and pg_trgm suggestions after them. A FUZZY suggestion must be confirmed by the Vendor and never establishes comparability.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorCatalogApi();
final String q = q_example; // String |

try {
    final response = api.searchCatalogMaterials(q);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorCatalogApi->searchCatalogMaterials: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **q** | **String**|  |

### Return type

[**CatalogMaterialMatchListEnvelope**](CatalogMaterialMatchListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **submitListingCompliance**
> CatalogListingEnvelope submitListingCompliance(listingId, idempotencyKey, complianceSubmission)



Review and Confirm for all three paths. The Vendor supplies the PS License No. or ICC sticker serial and marking evidence. With review_mode AUTOMATIC (default) a MATCHED register lookup (rule compliance.register-number.v2) is VERIFIED as an audited system decision and the register record supplies the manufacturer or importer. On a match, non-empty brand and model values that fit the listing fields are applied to the product; PS records also supply manufacturer and address, and a Local PS record supplies country PH. Missing or oversized fields preserve the listing values; ICC importers never replace manufacturers. This update is audited in the submission transaction before capturing the verified listing fingerprint. Any other result returns 422 COMPLIANCE_REGISTER_NOT_MATCHED with details.lookup and records nothing. With review_mode MANUAL_REVIEW, which the Vendor chooses explicitly, an unmatched declaration becomes PENDING_ADMIN_REVIEW, never a counterfeit finding.

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

final api = MateryalphApiClient().getVendorCatalogApi();
final String listingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ComplianceSubmission complianceSubmission = ; // ComplianceSubmission |

try {
    final response = api.submitListingCompliance(listingId, idempotencyKey, complianceSubmission);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorCatalogApi->submitListingCompliance: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **listingId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **complianceSubmission** | [**ComplianceSubmission**](ComplianceSubmission.md)|  |

### Return type

[**CatalogListingEnvelope**](CatalogListingEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateVendorCatalogListing**
> CatalogListingEnvelope updateVendorCatalogListing(listingId, catalogListingUpdate)



Saves listing details as a draft. Other labels are listing text only and never create taxonomy. A compliance-sensitive edit of a regulated listing withdraws verification and returns it to PENDING_COMPLIANCE. An edit that would leave an ACTIVE listing incomplete is rejected.

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

final api = MateryalphApiClient().getVendorCatalogApi();
final String listingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final CatalogListingUpdate catalogListingUpdate = ; // CatalogListingUpdate |

try {
    final response = api.updateVendorCatalogListing(listingId, catalogListingUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorCatalogApi->updateVendorCatalogListing: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **listingId** | **String**|  |
 **catalogListingUpdate** | [**CatalogListingUpdate**](CatalogListingUpdate.md)|  |

### Return type

[**CatalogListingEnvelope**](CatalogListingEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **uploadCatalogImport**
> CatalogImportJobEnvelope uploadCatalogImport(file)



Validates every CSV row and applies nothing. Rows with errors are reported; HAS_ERRORS is never a success state.

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

final api = MateryalphApiClient().getVendorCatalogApi();
final MultipartFile file = BINARY_DATA_HERE; // MultipartFile |

try {
    final response = api.uploadCatalogImport(file);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorCatalogApi->uploadCatalogImport: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **file** | **MultipartFile**|  |

### Return type

[**CatalogImportJobEnvelope**](CatalogImportJobEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **uploadListingComplianceEvidence**
> ComplianceEvidenceEnvelope uploadListingComplianceEvidence(listingId, path, file, qrPayload, markingType)



Stores a private PS Mark/ICC marking photo or QR image and returns editable extraction assistance. OCR and QR values are suggestions only; PHOTO_OCR uses local Tesseract after malware scanning and returns only labelled marking fields, never raw OCR text. UNAVAILABLE (engine missing) or FAILED (unreadable image, timeout or engine failure) retains the private evidence for manual Review and Confirm. Current authorization and listing eligibility are checked again after extraction. OCR never changes compliance or publication status. With marking_type, OCR and QR read the PS License No. or ICC sticker serial by its printed shape; look-alike readings are checked against the active DTI-BPS register and the listed one is suggested (register_listed). A QR payload sent with a PHOTO_OCR photo is used instead of OCR when it holds the number.

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

final api = MateryalphApiClient().getVendorCatalogApi();
final String listingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final CompliancePath path = ; // CompliancePath |
final MultipartFile file = BINARY_DATA_HERE; // MultipartFile |
final String qrPayload = qrPayload_example; // String | Text decoded by the browser from the QR image or from a QR code visible in a marking photo; untrusted.
final MarkingType markingType = ; // MarkingType | The marking the Vendor selected

try {
    final response = api.uploadListingComplianceEvidence(listingId, path, file, qrPayload, markingType);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorCatalogApi->uploadListingComplianceEvidence: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **listingId** | **String**|  |
 **path** | [**CompliancePath**](CompliancePath.md)|  |
 **file** | **MultipartFile**|  |
 **qrPayload** | **String**| Text decoded by the browser from the QR image or from a QR code visible in a marking photo; untrusted. | [optional]
 **markingType** | [**MarkingType**](MarkingType.md)| The marking the Vendor selected | [optional]

### Return type

[**ComplianceEvidenceEnvelope**](ComplianceEvidenceEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **uploadVendorListingMedia**
> CatalogListingEnvelope uploadVendorListingMedia(listingId, file, altText, replacesMediaId)



Uploads a public product photo (JPG, PNG or WebP, content-sniffed, malware-scanned fail-closed). A replacement increments the media version. Private verification or compliance evidence can never be attached as listing media.

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

final api = MateryalphApiClient().getVendorCatalogApi();
final String listingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final MultipartFile file = BINARY_DATA_HERE; // MultipartFile |
final String altText = altText_example; // String |
final String replacesMediaId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.uploadVendorListingMedia(listingId, file, altText, replacesMediaId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorCatalogApi->uploadVendorListingMedia: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **listingId** | **String**|  |
 **file** | **MultipartFile**|  |
 **altText** | **String**|  | [optional]
 **replacesMediaId** | **String**|  | [optional]

### Return type

[**CatalogListingEnvelope**](CatalogListingEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

