# materyalph_api_client.api.BuyerProjectsApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**activateWorkPackage**](BuyerProjectsApi.md#activateworkpackage) | **POST** /buyers/work-packages/{packageId}/activate |
[**closeWorkPackage**](BuyerProjectsApi.md#closeworkpackage) | **POST** /buyers/work-packages/{packageId}/close |
[**compileProjectEstimates**](BuyerProjectsApi.md#compileprojectestimates) | **POST** /buyers/work-packages/{packageId}/estimates |
[**createProject**](BuyerProjectsApi.md#createproject) | **POST** /buyers/projects |
[**createWorkPackage**](BuyerProjectsApi.md#createworkpackage) | **POST** /buyers/projects/{projectId}/work-packages |
[**createWorkPackageVersion**](BuyerProjectsApi.md#createworkpackageversion) | **POST** /buyers/work-packages/{packageId}/versions |
[**deleteProject**](BuyerProjectsApi.md#deleteproject) | **DELETE** /buyers/projects/{projectId} |
[**deleteWorkPackage**](BuyerProjectsApi.md#deleteworkpackage) | **DELETE** /buyers/work-packages/{packageId} |
[**editWorkPackage**](BuyerProjectsApi.md#editworkpackage) | **PUT** /buyers/work-packages/{packageId} |
[**getProject**](BuyerProjectsApi.md#getproject) | **GET** /buyers/projects/{projectId} |
[**getProjectCandidateRoute**](BuyerProjectsApi.md#getprojectcandidateroute) | **POST** /buyers/work-packages/{packageId}/candidates/{candidateId}/route |
[**getProjectEstimates**](BuyerProjectsApi.md#getprojectestimates) | **GET** /buyers/work-packages/{packageId}/estimates |
[**getProjectRankingPreferences**](BuyerProjectsApi.md#getprojectrankingpreferences) | **GET** /buyers/project-ranking-preferences |
[**getWorkPackage**](BuyerProjectsApi.md#getworkpackage) | **GET** /buyers/work-packages/{packageId} |
[**inquireProjectVendor**](BuyerProjectsApi.md#inquireprojectvendor) | **POST** /buyers/work-packages/{packageId}/inquiries |
[**listProjects**](BuyerProjectsApi.md#listprojects) | **GET** /buyers/projects |
[**previewWorkPackageCsv**](BuyerProjectsApi.md#previewworkpackagecsv) | **POST** /buyers/work-packages/import-preview |
[**resetProjectRankingPreferences**](BuyerProjectsApi.md#resetprojectrankingpreferences) | **POST** /buyers/project-ranking-preferences/reset |
[**resolveProjectMissingLine**](BuyerProjectsApi.md#resolveprojectmissingline) | **PUT** /buyers/work-packages/{packageId}/missing-lines/{lineId} |
[**saveProjectRankingPreferences**](BuyerProjectsApi.md#saveprojectrankingpreferences) | **PUT** /buyers/project-ranking-preferences |
[**searchProjectMaterials**](BuyerProjectsApi.md#searchprojectmaterials) | **GET** /buyers/project-materials |
[**selectProjectVendor**](BuyerProjectsApi.md#selectprojectvendor) | **POST** /buyers/work-packages/{packageId}/selection |
[**updateProject**](BuyerProjectsApi.md#updateproject) | **PATCH** /buyers/projects/{projectId} |


# **activateWorkPackage**
> WorkPackageViewResponse activateWorkPackage(packageId, idempotencyKey, projectVersionRequest)



Lock the original version; scan explicitly afterward.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerProjectsApi();
final String packageId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ProjectVersionRequest projectVersionRequest = ; // ProjectVersionRequest |

try {
    final response = api.activateWorkPackage(packageId, idempotencyKey, projectVersionRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerProjectsApi->activateWorkPackage: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **packageId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **projectVersionRequest** | [**ProjectVersionRequest**](ProjectVersionRequest.md)|  |

### Return type

[**WorkPackageViewResponse**](WorkPackageViewResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **closeWorkPackage**
> WorkPackageViewResponse closeWorkPackage(packageId, projectVersionRequest)



Cancel an unassigned package, retaining every locked version. Selected work follows order cancellation rules.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerProjectsApi();
final String packageId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ProjectVersionRequest projectVersionRequest = ; // ProjectVersionRequest |

try {
    final response = api.closeWorkPackage(packageId, projectVersionRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerProjectsApi->closeWorkPackage: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **packageId** | **String**|  |
 **projectVersionRequest** | [**ProjectVersionRequest**](ProjectVersionRequest.md)|  |

### Return type

[**WorkPackageViewResponse**](WorkPackageViewResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **compileProjectEstimates**
> ProjectEstimatePageResponse compileProjectEstimates(packageId, projectCompile)



Scan eligible Bulk Yes Tier 2 offers within the confirmed radius from the Project site. FMS uses exact normalized weights. Unknown delivery cost remains pending; schedules never change validity or score.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerProjectsApi();
final String packageId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ProjectCompile projectCompile = ; // ProjectCompile |

try {
    final response = api.compileProjectEstimates(packageId, projectCompile);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerProjectsApi->compileProjectEstimates: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **packageId** | **String**|  |
 **projectCompile** | [**ProjectCompile**](ProjectCompile.md)|  |

### Return type

[**ProjectEstimatePageResponse**](ProjectEstimatePageResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createProject**
> ProjectViewResponse createProject(idempotencyKey, projectCreate)



Create an Active Project with a frozen site copied from the authenticated Buyer saved location.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerProjectsApi();
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ProjectCreate projectCreate = ; // ProjectCreate |

try {
    final response = api.createProject(idempotencyKey, projectCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerProjectsApi->createProject: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String**|  |
 **projectCreate** | [**ProjectCreate**](ProjectCreate.md)|  |

### Return type

[**ProjectViewResponse**](ProjectViewResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createWorkPackage**
> WorkPackageViewResponse createWorkPackage(projectId, idempotencyKey, workPackageInput)



Save a Draft. Normalized units, positive quantities, explicit site and access are validated.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerProjectsApi();
final String projectId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final WorkPackageInput workPackageInput = ; // WorkPackageInput |

try {
    final response = api.createWorkPackage(projectId, idempotencyKey, workPackageInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerProjectsApi->createWorkPackage: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **projectId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **workPackageInput** | [**WorkPackageInput**](WorkPackageInput.md)|  |

### Return type

[**WorkPackageViewResponse**](WorkPackageViewResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createWorkPackageVersion**
> WorkPackageViewResponse createWorkPackageVersion(packageId, idempotencyKey, workPackageInput)



Explicit correction version invalidates estimates and expires inquiries. Selected work requires prior order cancellation.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerProjectsApi();
final String packageId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final WorkPackageInput workPackageInput = ; // WorkPackageInput |

try {
    final response = api.createWorkPackageVersion(packageId, idempotencyKey, workPackageInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerProjectsApi->createWorkPackageVersion: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **packageId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **workPackageInput** | [**WorkPackageInput**](WorkPackageInput.md)|  |

### Return type

[**WorkPackageViewResponse**](WorkPackageViewResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteProject**
> ChatEmptyResponse deleteProject(projectId, projectVersionRequest)



Delete only when no Work Packages or procurement history exists. Otherwise archive.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerProjectsApi();
final String projectId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ProjectVersionRequest projectVersionRequest = ; // ProjectVersionRequest |

try {
    final response = api.deleteProject(projectId, projectVersionRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerProjectsApi->deleteProject: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **projectId** | **String**|  |
 **projectVersionRequest** | [**ProjectVersionRequest**](ProjectVersionRequest.md)|  |

### Return type

[**ChatEmptyResponse**](ChatEmptyResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteWorkPackage**
> ChatEmptyResponse deleteWorkPackage(packageId, projectVersionRequest)



Delete only a Draft with no locked historical version. Retain activated evidence.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerProjectsApi();
final String packageId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ProjectVersionRequest projectVersionRequest = ; // ProjectVersionRequest |

try {
    final response = api.deleteWorkPackage(packageId, projectVersionRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerProjectsApi->deleteWorkPackage: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **packageId** | **String**|  |
 **projectVersionRequest** | [**ProjectVersionRequest**](ProjectVersionRequest.md)|  |

### Return type

[**ChatEmptyResponse**](ChatEmptyResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **editWorkPackage**
> WorkPackageViewResponse editWorkPackage(packageId, idempotencyKey, workPackageInput)



Editable Draft only; saves an append-only draft version.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerProjectsApi();
final String packageId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final WorkPackageInput workPackageInput = ; // WorkPackageInput |

try {
    final response = api.editWorkPackage(packageId, idempotencyKey, workPackageInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerProjectsApi->editWorkPackage: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **packageId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **workPackageInput** | [**WorkPackageInput**](WorkPackageInput.md)|  |

### Return type

[**WorkPackageViewResponse**](WorkPackageViewResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getProject**
> ProjectViewResponse getProject(projectId, page)



Project sites and paginated Work Packages.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerProjectsApi();
final String projectId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final int page = 56; // int |

try {
    final response = api.getProject(projectId, page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerProjectsApi->getProject: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **projectId** | **String**|  |
 **page** | **int**|  | [optional]

### Return type

[**ProjectViewResponse**](ProjectViewResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getProjectCandidateRoute**
> ProjectRouteResponse getProjectCandidateRoute(packageId, candidateId)



One decision route from the frozen Project site. Separate delivery endpoint/rate basis remains in the advisory estimate.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerProjectsApi();
final String packageId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String candidateId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getProjectCandidateRoute(packageId, candidateId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerProjectsApi->getProjectCandidateRoute: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **packageId** | **String**|  |
 **candidateId** | **String**|  |

### Return type

[**ProjectRouteResponse**](ProjectRouteResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getProjectEstimates**
> ProjectEstimatePageResponse getProjectEstimates(packageId, page)



Immutable, paginated snapshots. Complete one-Vendor matches first; missing lines explicit. Expiry is exactly 48 hours.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerProjectsApi();
final String packageId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final int page = 56; // int |

try {
    final response = api.getProjectEstimates(packageId, page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerProjectsApi->getProjectEstimates: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **packageId** | **String**|  |
 **page** | **int**|  | [optional]

### Return type

[**ProjectEstimatePageResponse**](ProjectEstimatePageResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getProjectRankingPreferences**
> ProjectPreferencesResponse getProjectRankingPreferences()



Separate Project-Based preference record and active personalized indicator.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerProjectsApi();

try {
    final response = api.getProjectRankingPreferences();
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerProjectsApi->getProjectRankingPreferences: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ProjectPreferencesResponse**](ProjectPreferencesResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getWorkPackage**
> WorkPackageViewResponse getWorkPackage(packageId, page)



Locked original, paginated version history, missing-item resolution and budget metrics. PDF generation remains Phase 15.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerProjectsApi();
final String packageId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final int page = 56; // int |

try {
    final response = api.getWorkPackage(packageId, page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerProjectsApi->getWorkPackage: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **packageId** | **String**|  |
 **page** | **int**|  | [optional]

### Return type

[**WorkPackageViewResponse**](WorkPackageViewResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **inquireProjectVendor**
> ChatIdResponse inquireProjectVendor(packageId, idempotencyKey, projectCandidateRequest)



Open/resume this eligible candidate inquiry only; attach locked original and Vendor-editable duplicate to the shared quotation engine.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerProjectsApi();
final String packageId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ProjectCandidateRequest projectCandidateRequest = ; // ProjectCandidateRequest |

try {
    final response = api.inquireProjectVendor(packageId, idempotencyKey, projectCandidateRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerProjectsApi->inquireProjectVendor: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **packageId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **projectCandidateRequest** | [**ProjectCandidateRequest**](ProjectCandidateRequest.md)|  |

### Return type

[**ChatIdResponse**](ChatIdResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listProjects**
> ProjectPageResponse listProjects(page)



Paginated owned Projects and disjoint FIN-11 metrics.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerProjectsApi();
final int page = 56; // int |

try {
    final response = api.listProjects(page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerProjectsApi->listProjects: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **int**|  | [optional]

### Return type

[**ProjectPageResponse**](ProjectPageResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **previewWorkPackageCsv**
> ProjectImportPreviewResponse previewWorkPackageCsv(projectImportRequest)



Validate at most 100 CSV lines without saving. Header: material_code,name,unit_code,quantity,preferred_brand,specifications.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerProjectsApi();
final ProjectImportRequest projectImportRequest = ; // ProjectImportRequest |

try {
    final response = api.previewWorkPackageCsv(projectImportRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerProjectsApi->previewWorkPackageCsv: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **projectImportRequest** | [**ProjectImportRequest**](ProjectImportRequest.md)|  |

### Return type

[**ProjectImportPreviewResponse**](ProjectImportPreviewResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resetProjectRankingPreferences**
> ProjectPreferencesResponse resetProjectRankingPreferences(projectPreferenceReset)



Reset to current platform defaults with version conflict protection.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerProjectsApi();
final ProjectPreferenceReset projectPreferenceReset = ; // ProjectPreferenceReset |

try {
    final response = api.resetProjectRankingPreferences(projectPreferenceReset);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerProjectsApi->resetProjectRankingPreferences: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **projectPreferenceReset** | [**ProjectPreferenceReset**](ProjectPreferenceReset.md)|  |

### Return type

[**ProjectPreferencesResponse**](ProjectPreferencesResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resolveProjectMissingLine**
> WorkPackageViewResponse resolveProjectMissingLine(packageId, lineId, projectMissingResolve)



Link a covering owned Item-Based order or explicitly waive with a reason. Linked child orders enter budgets once.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerProjectsApi();
final String packageId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String lineId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ProjectMissingResolve projectMissingResolve = ; // ProjectMissingResolve |

try {
    final response = api.resolveProjectMissingLine(packageId, lineId, projectMissingResolve);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerProjectsApi->resolveProjectMissingLine: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **packageId** | **String**|  |
 **lineId** | **String**|  |
 **projectMissingResolve** | [**ProjectMissingResolve**](ProjectMissingResolve.md)|  |

### Return type

[**WorkPackageViewResponse**](WorkPackageViewResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **saveProjectRankingPreferences**
> ProjectPreferencesResponse saveProjectRankingPreferences(projectPreferenceSave)



Exactly four integer weights in [0,100] totaling 100. Defaults: material_match 40, budget_fit 25, distance 20, vps 15.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerProjectsApi();
final ProjectPreferenceSave projectPreferenceSave = ; // ProjectPreferenceSave |

try {
    final response = api.saveProjectRankingPreferences(projectPreferenceSave);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerProjectsApi->saveProjectRankingPreferences: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **projectPreferenceSave** | [**ProjectPreferenceSave**](ProjectPreferenceSave.md)|  |

### Return type

[**ProjectPreferencesResponse**](ProjectPreferencesResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchProjectMaterials**
> ProjectMaterialPageResponse searchProjectMaterials(query)



Up to eight canonical material suggestions, each with compatible normalized units. Buyer must explicitly select a suggestion.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerProjectsApi();
final String query = query_example; // String |

try {
    final response = api.searchProjectMaterials(query);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerProjectsApi->searchProjectMaterials: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **query** | **String**|  |

### Return type

[**ProjectMaterialPageResponse**](ProjectMaterialPageResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **selectProjectVendor**
> ChatIdResponse selectProjectVendor(packageId, idempotencyKey, projectCandidateRequest)



Select exactly one Vendor from a fresh estimate and expire other active quotations. Creates a manual 24-hour package request. Optional Note needs no Vendor response. No auto-accept.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerProjectsApi();
final String packageId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ProjectCandidateRequest projectCandidateRequest = ; // ProjectCandidateRequest |

try {
    final response = api.selectProjectVendor(packageId, idempotencyKey, projectCandidateRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerProjectsApi->selectProjectVendor: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **packageId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **projectCandidateRequest** | [**ProjectCandidateRequest**](ProjectCandidateRequest.md)|  |

### Return type

[**ChatIdResponse**](ChatIdResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateProject**
> ProjectViewResponse updateProject(projectId, idempotencyKey, projectUpdate)



Edit before procurement history; complete/archive afterward. A site never replaces an accepted destination.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerProjectsApi();
final String projectId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ProjectUpdate projectUpdate = ; // ProjectUpdate |

try {
    final response = api.updateProject(projectId, idempotencyKey, projectUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerProjectsApi->updateProject: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **projectId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **projectUpdate** | [**ProjectUpdate**](ProjectUpdate.md)|  |

### Return type

[**ProjectViewResponse**](ProjectViewResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

