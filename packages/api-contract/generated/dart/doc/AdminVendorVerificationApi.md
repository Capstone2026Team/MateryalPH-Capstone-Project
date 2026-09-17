# materyalph_api_client.api.AdminVendorVerificationApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**decideVendorVerificationRequirement**](AdminVendorVerificationApi.md#decidevendorverificationrequirement) | **POST** /admin/vendor-verification/{organizationId}/requirements/{requirementKey}/decision |
[**getAdminDashboard**](AdminVendorVerificationApi.md#getadmindashboard) | **GET** /admin/dashboard |
[**getAdminVendorEvidenceUrl**](AdminVendorVerificationApi.md#getadminvendorevidenceurl) | **GET** /admin/vendor-verification/files/{fileId} |
[**getVendorVerificationCase**](AdminVendorVerificationApi.md#getvendorverificationcase) | **GET** /admin/vendor-verification/{organizationId} |
[**listAdminDashboardAudit**](AdminVendorVerificationApi.md#listadmindashboardaudit) | **GET** /admin/dashboard/audit |
[**listVendorVerificationQueue**](AdminVendorVerificationApi.md#listvendorverificationqueue) | **GET** /admin/vendor-verification |
[**restoreVendorActivation**](AdminVendorVerificationApi.md#restorevendoractivation) | **POST** /admin/vendor-verification/{organizationId}/restore |
[**restrictVendorActivation**](AdminVendorVerificationApi.md#restrictvendoractivation) | **POST** /admin/vendor-verification/{organizationId}/restrict |


# **decideVendorVerificationRequirement**
> AdminVendorVerificationDetailEnvelope decideVendorVerificationRequirement(organizationId, requirementKey, idempotencyKey, adminVendorVerificationDecision)



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

final api = MateryalphApiClient().getAdminVendorVerificationApi();
final String organizationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String requirementKey = requirementKey_example; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final AdminVendorVerificationDecision adminVendorVerificationDecision = ; // AdminVendorVerificationDecision |

try {
    final response = api.decideVendorVerificationRequirement(organizationId, requirementKey, idempotencyKey, adminVendorVerificationDecision);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminVendorVerificationApi->decideVendorVerificationRequirement: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organizationId** | **String**|  |
 **requirementKey** | **String**|  |
 **idempotencyKey** | **String**|  |
 **adminVendorVerificationDecision** | [**AdminVendorVerificationDecision**](AdminVendorVerificationDecision.md)|  |

### Return type

[**AdminVendorVerificationDetailEnvelope**](AdminVendorVerificationDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAdminDashboard**
> AdminDashboardEnvelope getAdminDashboard()



### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAdminVendorVerificationApi();

try {
    final response = api.getAdminDashboard();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminVendorVerificationApi->getAdminDashboard: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AdminDashboardEnvelope**](AdminDashboardEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAdminVendorEvidenceUrl**
> VendorFileEnvelope getAdminVendorEvidenceUrl(fileId)



### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAdminVendorVerificationApi();
final String fileId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getAdminVendorEvidenceUrl(fileId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminVendorVerificationApi->getAdminVendorEvidenceUrl: $e\n');
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

# **getVendorVerificationCase**
> AdminVendorVerificationDetailEnvelope getVendorVerificationCase(organizationId)



### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAdminVendorVerificationApi();
final String organizationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getVendorVerificationCase(organizationId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminVendorVerificationApi->getVendorVerificationCase: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organizationId** | **String**|  |

### Return type

[**AdminVendorVerificationDetailEnvelope**](AdminVendorVerificationDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAdminDashboardAudit**
> AdminDashboardAuditEnvelope listAdminDashboardAudit(page)



### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAdminVendorVerificationApi();
final int page = 56; // int |

try {
    final response = api.listAdminDashboardAudit(page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminVendorVerificationApi->listAdminDashboardAudit: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **int**|  | [optional]

### Return type

[**AdminDashboardAuditEnvelope**](AdminDashboardAuditEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listVendorVerificationQueue**
> AdminVendorVerificationQueueEnvelope listVendorVerificationQueue(status, businessType, regionCode, submittedFrom, submittedTo, sort, page)



### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getAdminVendorVerificationApi();
final String status = status_example; // String |
final String businessType = businessType_example; // String |
final String regionCode = regionCode_example; // String | Current PSGC region code or UNASSIGNED. Region options are included in meta.regions.
final Date submittedFrom = 2013-10-20; // Date | Inclusive Asia/Manila submission date.
final Date submittedTo = 2013-10-20; // Date | Inclusive Asia/Manila submission date.
final String sort = sort_example; // String |
final int page = 56; // int |

try {
    final response = api.listVendorVerificationQueue(status, businessType, regionCode, submittedFrom, submittedTo, sort, page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminVendorVerificationApi->listVendorVerificationQueue: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **status** | **String**|  | [optional]
 **businessType** | **String**|  | [optional]
 **regionCode** | **String**| Current PSGC region code or UNASSIGNED. Region options are included in meta.regions. | [optional]
 **submittedFrom** | **Date**| Inclusive Asia/Manila submission date. | [optional]
 **submittedTo** | **Date**| Inclusive Asia/Manila submission date. | [optional]
 **sort** | **String**|  | [optional] [default to 'submitted_desc']
 **page** | **int**|  | [optional]

### Return type

[**AdminVendorVerificationQueueEnvelope**](AdminVendorVerificationQueueEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **restoreVendorActivation**
> VendorRestrictionEnvelope restoreVendorActivation(organizationId, idempotencyKey, vendorRestriction)



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

final api = MateryalphApiClient().getAdminVendorVerificationApi();
final String organizationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final VendorRestriction vendorRestriction = ; // VendorRestriction |

try {
    final response = api.restoreVendorActivation(organizationId, idempotencyKey, vendorRestriction);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminVendorVerificationApi->restoreVendorActivation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organizationId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **vendorRestriction** | [**VendorRestriction**](VendorRestriction.md)|  |

### Return type

[**VendorRestrictionEnvelope**](VendorRestrictionEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **restrictVendorActivation**
> VendorRestrictionEnvelope restrictVendorActivation(organizationId, idempotencyKey, vendorRestriction)



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

final api = MateryalphApiClient().getAdminVendorVerificationApi();
final String organizationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final VendorRestriction vendorRestriction = ; // VendorRestriction |

try {
    final response = api.restrictVendorActivation(organizationId, idempotencyKey, vendorRestriction);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminVendorVerificationApi->restrictVendorActivation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **organizationId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **vendorRestriction** | [**VendorRestriction**](VendorRestriction.md)|  |

### Return type

[**VendorRestrictionEnvelope**](VendorRestrictionEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

