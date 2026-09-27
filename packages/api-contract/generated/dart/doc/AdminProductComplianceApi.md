# materyalph_api_client.api.AdminProductComplianceApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**activateComplianceRegister**](AdminProductComplianceApi.md#activatecomplianceregister) | **POST** /admin/product-compliance/registers/{registerId}/activate |
[**createComparableGroup**](AdminProductComplianceApi.md#createcomparablegroup) | **POST** /admin/taxonomy/comparable-groups |
[**decideProductCompliance**](AdminProductComplianceApi.md#decideproductcompliance) | **POST** /admin/product-compliance/{submissionId}/decision |
[**getProductComplianceCase**](AdminProductComplianceApi.md#getproductcompliancecase) | **GET** /admin/product-compliance/{submissionId} |
[**getProductComplianceFileUrl**](AdminProductComplianceApi.md#getproductcompliancefileurl) | **GET** /admin/product-compliance/files/{fileId} |
[**importComplianceRegister**](AdminProductComplianceApi.md#importcomplianceregister) | **POST** /admin/product-compliance/registers |
[**listComplianceRegisters**](AdminProductComplianceApi.md#listcomplianceregisters) | **GET** /admin/product-compliance/registers |
[**listProductComplianceQueue**](AdminProductComplianceApi.md#listproductcompliancequeue) | **GET** /admin/product-compliance |


# **activateComplianceRegister**
> ComplianceRegisterEnvelope activateComplianceRegister(registerId)



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

final api = MateryalphApiClient().getAdminProductComplianceApi();
final String registerId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.activateComplianceRegister(registerId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminProductComplianceApi->activateComplianceRegister: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **registerId** | **String**|  |

### Return type

[**ComplianceRegisterEnvelope**](ComplianceRegisterEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createComparableGroup**
> ComparableGroupEnvelope createComparableGroup(comparableGroupCreate)



MAT-03. Creates an approved comparable group version from an exact controlled key (material, brand, model, every controlled specification, canonical unit and conversion version) and maps exactly matching active variants.

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

final api = MateryalphApiClient().getAdminProductComplianceApi();
final ComparableGroupCreate comparableGroupCreate = ; // ComparableGroupCreate |

try {
    final response = api.createComparableGroup(comparableGroupCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminProductComplianceApi->createComparableGroup: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **comparableGroupCreate** | [**ComparableGroupCreate**](ComparableGroupCreate.md)|  |

### Return type

[**ComparableGroupEnvelope**](ComparableGroupEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **decideProductCompliance**
> ProductComplianceCaseEnvelope decideProductCompliance(submissionId, idempotencyKey, productComplianceDecision)



Approve, Return for Correction or Reject the named submission version. A reason is required unless approving; a stale lock_version is rejected with STALE_REVIEW. The decision never changes Store Activation.

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

final api = MateryalphApiClient().getAdminProductComplianceApi();
final String submissionId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ProductComplianceDecision productComplianceDecision = ; // ProductComplianceDecision |

try {
    final response = api.decideProductCompliance(submissionId, idempotencyKey, productComplianceDecision);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminProductComplianceApi->decideProductCompliance: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **submissionId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **productComplianceDecision** | [**ProductComplianceDecision**](ProductComplianceDecision.md)|  |

### Return type

[**ProductComplianceCaseEnvelope**](ProductComplianceCaseEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getProductComplianceCase**
> ProductComplianceCaseEnvelope getProductComplianceCase(submissionId)



### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAdminProductComplianceApi();
final String submissionId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getProductComplianceCase(submissionId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminProductComplianceApi->getProductComplianceCase: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **submissionId** | **String**|  |

### Return type

[**ProductComplianceCaseEnvelope**](ProductComplianceCaseEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getProductComplianceFileUrl**
> VendorFileEnvelope getProductComplianceFileUrl(fileId)



### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAdminProductComplianceApi();
final String fileId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getProductComplianceFileUrl(fileId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminProductComplianceApi->getProductComplianceFileUrl: $e\n');
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

# **importComplianceRegister**
> ComplianceRegisterEnvelope importComplianceRegister(registerKind, sourceReference, snapshotDate, file)



Imports a CSV snapshot of the DTI-BPS PS licensee or ICC certificate register as an immutable DRAFT. It is used for matching only after activation.

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

final api = MateryalphApiClient().getAdminProductComplianceApi();
final String registerKind = registerKind_example; // String |
final String sourceReference = sourceReference_example; // String |
final Date snapshotDate = 2013-10-20; // Date |
final MultipartFile file = BINARY_DATA_HERE; // MultipartFile |

try {
    final response = api.importComplianceRegister(registerKind, sourceReference, snapshotDate, file);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminProductComplianceApi->importComplianceRegister: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **registerKind** | **String**|  |
 **sourceReference** | **String**|  |
 **snapshotDate** | **Date**|  |
 **file** | **MultipartFile**|  |

### Return type

[**ComplianceRegisterEnvelope**](ComplianceRegisterEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listComplianceRegisters**
> ComplianceRegisterListEnvelope listComplianceRegisters(page)



### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAdminProductComplianceApi();
final int page = 56; // int |

try {
    final response = api.listComplianceRegisters(page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminProductComplianceApi->listComplianceRegisters: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **int**|  | [optional]

### Return type

[**ComplianceRegisterListEnvelope**](ComplianceRegisterListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listProductComplianceQueue**
> ProductComplianceQueueEnvelope listProductComplianceQueue(status, path, referenceResult, sort, page)



### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAdminProductComplianceApi();
final String status = status_example; // String |
final CompliancePath path = ; // CompliancePath |
final ComplianceReferenceResult referenceResult = ; // ComplianceReferenceResult |
final String sort = sort_example; // String |
final int page = 56; // int |

try {
    final response = api.listProductComplianceQueue(status, path, referenceResult, sort, page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminProductComplianceApi->listProductComplianceQueue: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional] [default to 'PENDING_ADMIN_REVIEW']
 **path** | [**CompliancePath**](.md)|  | [optional]
 **referenceResult** | [**ComplianceReferenceResult**](.md)|  | [optional]
 **sort** | **String**|  | [optional] [default to 'oldest']
 **page** | **int**|  | [optional]

### Return type

[**ProductComplianceQueueEnvelope**](ProductComplianceQueueEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

