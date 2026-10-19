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
[**createProjectArrangement**](BuyerProjectsApi.md#createprojectarrangement) | **POST** /buyers/work-packages/{packageId}/arrangements |
[**createWorkPackage**](BuyerProjectsApi.md#createworkpackage) | **POST** /buyers/projects/{projectId}/work-packages |
[**deleteProject**](BuyerProjectsApi.md#deleteproject) | **DELETE** /buyers/projects/{projectId} |
[**deleteWorkPackage**](BuyerProjectsApi.md#deleteworkpackage) | **DELETE** /buyers/work-packages/{packageId} |
[**editProjectArrangement**](BuyerProjectsApi.md#editprojectarrangement) | **PATCH** /buyers/work-packages/{packageId}/arrangements/{arrangementId} |
[**editWorkPackage**](BuyerProjectsApi.md#editworkpackage) | **PUT** /buyers/work-packages/{packageId} |
[**estimateWorkPackageBudget**](BuyerProjectsApi.md#estimateworkpackagebudget) | **POST** /buyers/projects/{projectId}/work-package-estimate |
[**getProject**](BuyerProjectsApi.md#getproject) | **GET** /buyers/projects/{projectId} |
[**getProjectArrangement**](BuyerProjectsApi.md#getprojectarrangement) | **GET** /buyers/work-packages/{packageId}/arrangements/{arrangementId} |
[**getProjectCandidateRoute**](BuyerProjectsApi.md#getprojectcandidateroute) | **POST** /buyers/work-packages/{packageId}/candidates/{candidateId}/route |
[**getProjectEstimates**](BuyerProjectsApi.md#getprojectestimates) | **GET** /buyers/work-packages/{packageId}/estimates |
[**getProjectRankingPreferences**](BuyerProjectsApi.md#getprojectrankingpreferences) | **GET** /buyers/project-ranking-preferences |
[**getWorkPackage**](BuyerProjectsApi.md#getworkpackage) | **GET** /buyers/work-packages/{packageId} |
[**inquireProjectArrangementVendor**](BuyerProjectsApi.md#inquireprojectarrangementvendor) | **POST** /buyers/work-packages/{packageId}/arrangements/{arrangementId}/vendors/{vendorId}/inquiry |
[**inquireProjectVendor**](BuyerProjectsApi.md#inquireprojectvendor) | **POST** /buyers/work-packages/{packageId}/inquiries |
[**listProjectArrangementOptions**](BuyerProjectsApi.md#listprojectarrangementoptions) | **GET** /buyers/work-packages/{packageId}/arrangement-options |
[**listProjects**](BuyerProjectsApi.md#listprojects) | **GET** /buyers/projects |
[**listWorkPackageLineAlternatives**](BuyerProjectsApi.md#listworkpackagelinealternatives) | **GET** /buyers/work-packages/{packageId}/lines/{lineId}/alternatives |
[**previewProjectSpecificationSelection**](BuyerProjectsApi.md#previewprojectspecificationselection) | **POST** /buyers/work-packages/{packageId}/candidates/{candidateId}/selection-preview |
[**previewWorkPackageCsv**](BuyerProjectsApi.md#previewworkpackagecsv) | **POST** /buyers/work-packages/import-preview |
[**reactivateWorkPackage**](BuyerProjectsApi.md#reactivateworkpackage) | **POST** /buyers/work-packages/{packageId}/reactivate |
[**removeProjectDraftItem**](BuyerProjectsApi.md#removeprojectdraftitem) | **DELETE** /buyers/work-packages/{packageId}/candidates/{candidateId}/draft-items/{lineId}/{variantId} |
[**requestProjectDraftSupplier**](BuyerProjectsApi.md#requestprojectdraftsupplier) | **POST** /buyers/work-packages/{packageId}/candidates/{candidateId}/suppliers/{vendorId}/request |
[**resetProjectRankingPreferences**](BuyerProjectsApi.md#resetprojectrankingpreferences) | **POST** /buyers/project-ranking-preferences/reset |
[**resolveProjectMissingLine**](BuyerProjectsApi.md#resolveprojectmissingline) | **PUT** /buyers/work-packages/{packageId}/missing-lines/{lineId} |
[**saveProjectDraftItem**](BuyerProjectsApi.md#saveprojectdraftitem) | **PUT** /buyers/work-packages/{packageId}/candidates/{candidateId}/draft-items/{lineId}/{variantId} |
[**saveProjectRankingPreferences**](BuyerProjectsApi.md#saveprojectrankingpreferences) | **PUT** /buyers/project-ranking-preferences |
[**searchProjectMaterials**](BuyerProjectsApi.md#searchprojectmaterials) | **GET** /buyers/project-materials |
[**selectProjectVendor**](BuyerProjectsApi.md#selectprojectvendor) | **POST** /buyers/work-packages/{packageId}/selection |
[**submitProjectArrangement**](BuyerProjectsApi.md#submitprojectarrangement) | **POST** /buyers/work-packages/{packageId}/arrangements/{arrangementId}/submit |
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



Cancel an unassigned package, retaining its saved contents. Selected work follows order cancellation rules.

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



Scan eligible Bulk Yes Tier 2 offers within the fixed 50 km Project-Based radius from the Project site. FMS uses exact normalized weights. Unknown delivery cost remains pending; schedules never change validity or score.

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

# **createProjectArrangement**
> ProjectArrangementResponse createProjectArrangement(packageId, idempotencyKey, projectArrangementCreate)



### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerProjectsApi();
final String packageId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ProjectArrangementCreate projectArrangementCreate = ; // ProjectArrangementCreate |

try {
    final response = api.createProjectArrangement(packageId, idempotencyKey, projectArrangementCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerProjectsApi->createProjectArrangement: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **packageId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **projectArrangementCreate** | [**ProjectArrangementCreate**](ProjectArrangementCreate.md)|  |

### Return type

[**ProjectArrangementResponse**](ProjectArrangementResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createWorkPackage**
> WorkPackageViewResponse createWorkPackage(projectId, idempotencyKey, workPackageInput)



Save a Draft. Normalized units, positive quantities, explicit site and access are validated. The budget is deducted from the Project budget immediately; WORK_PACKAGE_BUDGET_EXCEEDS_PROJECT (422) when non-cancelled allocations would exceed it.

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



Delete a Work Package that has no order, tagged purchase or selected Vendor. A Draft with no locked history is removed; any other package is cancelled and hidden from the Buyer while its saved originals, estimates and quotations are retained. A package with an order returns WORK_PACKAGE_HAS_ORDER.

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

# **editProjectArrangement**
> ProjectArrangementResponse editProjectArrangement(packageId, arrangementId, projectArrangementEdit)



### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerProjectsApi();
final String packageId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String arrangementId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ProjectArrangementEdit projectArrangementEdit = ; // ProjectArrangementEdit |

try {
    final response = api.editProjectArrangement(packageId, arrangementId, projectArrangementEdit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerProjectsApi->editProjectArrangement: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **packageId** | **String**|  |
 **arrangementId** | **String**|  |
 **projectArrangementEdit** | [**ProjectArrangementEdit**](ProjectArrangementEdit.md)|  |

### Return type

[**ProjectArrangementResponse**](ProjectArrangementResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **editWorkPackage**
> WorkPackageViewResponse editWorkPackage(packageId, idempotencyKey, workPackageInput)



Edit the Work Package directly, with no new list entry. Allowed until an order, tagged purchase or selected Vendor exists (otherwise WORK_PACKAGE_HAS_ORDER). Estimates and open quotation requests built on the old materials are invalidated; a compared or quoted package returns to Active.

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

# **estimateWorkPackageBudget**
> WorkPackageBudgetEstimateResponse estimateWorkPackageBudget(projectId, workPackageBudgetEstimateRequest)



Advisory budget estimate for a Work Package being drafted. Each catalog line is priced at the half-up average of one price per eligible Vendor (that Vendor's lowest exact match) within the radius of the site. Unlisted and unmatched lines carry no price. Excludes labor and processing fees. Site Delivery and Both include actual route/vehicle estimates for a representative exact-match supplier plan, consolidated per supplier. Unknown delivery remains null. Nothing is stored.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerProjectsApi();
final String projectId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final WorkPackageBudgetEstimateRequest workPackageBudgetEstimateRequest = ; // WorkPackageBudgetEstimateRequest |

try {
    final response = api.estimateWorkPackageBudget(projectId, workPackageBudgetEstimateRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerProjectsApi->estimateWorkPackageBudget: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **projectId** | **String**|  |
 **workPackageBudgetEstimateRequest** | [**WorkPackageBudgetEstimateRequest**](WorkPackageBudgetEstimateRequest.md)|  |

### Return type

[**WorkPackageBudgetEstimateResponse**](WorkPackageBudgetEstimateResponse.md)

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

# **getProjectArrangement**
> ProjectArrangementResponse getProjectArrangement(packageId, arrangementId)



### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerProjectsApi();
final String packageId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String arrangementId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getProjectArrangement(packageId, arrangementId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerProjectsApi->getProjectArrangement: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **packageId** | **String**|  |
 **arrangementId** | **String**|  |

### Return type

[**ProjectArrangementResponse**](ProjectArrangementResponse.md)

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
> ProjectEstimatePageResponse getProjectEstimates(packageId, page, sort, direction, favoritesOnly, completeOnly, withinBudget)



Immutable, paginated snapshots. Complete one-Vendor matches first by default; missing lines explicit. Expiry is exactly 48 hours. Sorting and filters run on the server so every page is consistent; each ordering ends on the system rank.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerProjectsApi();
final String packageId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final int page = 56; // int |
final String sort = sort_example; // String |
final String direction = direction_example; // String | ASC is low to high and DESC high to low. Omitted, each ordering opens on its default: BUDGET_FIT and RATING DESC (best first), PRICE ASC (cheapest first). Ignored for BEST_MATCH, a fixed ranking. A Vendor without a value (no rating, cost under review) is always last, and ties go to the nearest store.
final bool favoritesOnly = true; // bool |
final bool completeOnly = true; // bool |
final bool withinBudget = true; // bool |

try {
    final response = api.getProjectEstimates(packageId, page, sort, direction, favoritesOnly, completeOnly, withinBudget);
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
 **sort** | **String**|  | [optional]
 **direction** | **String**| ASC is low to high and DESC high to low. Omitted, each ordering opens on its default: BUDGET_FIT and RATING DESC (best first), PRICE ASC (cheapest first). Ignored for BEST_MATCH, a fixed ranking. A Vendor without a value (no rating, cost under review) is always last, and ties go to the nearest store. | [optional]
 **favoritesOnly** | **bool**|  | [optional]
 **completeOnly** | **bool**|  | [optional]
 **withinBudget** | **bool**|  | [optional]

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



The package's current materials, missing-item resolution, budget metrics and delete/edit availability. PDF generation remains Phase 15.

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

# **inquireProjectArrangementVendor**
> ProjectArrangementResponse inquireProjectArrangementVendor(packageId, arrangementId, vendorId, projectArrangementInquiry)



### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerProjectsApi();
final String packageId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String arrangementId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String vendorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ProjectArrangementInquiry projectArrangementInquiry = ; // ProjectArrangementInquiry |

try {
    final response = api.inquireProjectArrangementVendor(packageId, arrangementId, vendorId, projectArrangementInquiry);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerProjectsApi->inquireProjectArrangementVendor: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **packageId** | **String**|  |
 **arrangementId** | **String**|  |
 **vendorId** | **String**|  |
 **projectArrangementInquiry** | [**ProjectArrangementInquiry**](ProjectArrangementInquiry.md)|  |

### Return type

[**ProjectArrangementResponse**](ProjectArrangementResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
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

# **listProjectArrangementOptions**
> ProjectArrangementPageResponse listProjectArrangementOptions(packageId, page, sort, direction, favoritesOnly, completeOnly, withinBudget)



### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerProjectsApi();
final String packageId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final int page = 56; // int |
final String sort = sort_example; // String |
final String direction = direction_example; // String |
final bool favoritesOnly = true; // bool |
final bool completeOnly = true; // bool |
final bool withinBudget = true; // bool |

try {
    final response = api.listProjectArrangementOptions(packageId, page, sort, direction, favoritesOnly, completeOnly, withinBudget);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerProjectsApi->listProjectArrangementOptions: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **packageId** | **String**|  |
 **page** | **int**|  | [optional]
 **sort** | **String**|  | [optional]
 **direction** | **String**|  | [optional]
 **favoritesOnly** | **bool**|  | [optional]
 **completeOnly** | **bool**|  | [optional]
 **withinBudget** | **bool**|  | [optional]

### Return type

[**ProjectArrangementPageResponse**](ProjectArrangementPageResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
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

# **listWorkPackageLineAlternatives**
> WorkPackageAlternativePageResponse listWorkPackageLineAlternatives(packageId, lineId, arrangementId, replace, page, excludeVendorId, candidateId, specificationChoices, fulfillmentMethod)



Eligible Item-Based offers for the same canonical material and unit within the fixed 50 km Project-Based radius of the package site, for buying a missing line separately. Ranked by specification match, whether the store covers the quantity, whether it can serve the package's fulfillment method, total price, then distance. Unlisted lines return status UNLISTED with no items; a line already covered returns COVERED; no suitable store returns NO_SUITABLE_ALTERNATIVE with the reasons in `excluded`.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerProjectsApi();
final String packageId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String lineId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String arrangementId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final bool replace = true; // bool |
final int page = 56; // int |
final String excludeVendorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String candidateId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | The compared Vendor candidate. The quantity to source becomes that Vendor's gap less the separate purchases that satisfy the line, and the Vendor itself is left out.
final String specificationChoices = specificationChoices_example; // String | JSON array of {line_id, option_id} choices. Sizes the recommendation from the same selected specifications as quotation review.
final String fulfillmentMethod = fulfillmentMethod_example; // String | Concrete method chosen on quotation review; suggestions must support it.

try {
    final response = api.listWorkPackageLineAlternatives(packageId, lineId, arrangementId, replace, page, excludeVendorId, candidateId, specificationChoices, fulfillmentMethod);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerProjectsApi->listWorkPackageLineAlternatives: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **packageId** | **String**|  |
 **lineId** | **String**|  |
 **arrangementId** | **String**|  | [optional]
 **replace** | **bool**|  | [optional]
 **page** | **int**|  | [optional]
 **excludeVendorId** | **String**|  | [optional]
 **candidateId** | **String**| The compared Vendor candidate. The quantity to source becomes that Vendor's gap less the separate purchases that satisfy the line, and the Vendor itself is left out. | [optional]
 **specificationChoices** | **String**| JSON array of {line_id, option_id} choices. Sizes the recommendation from the same selected specifications as quotation review. | [optional]
 **fulfillmentMethod** | **String**| Concrete method chosen on quotation review; suggestions must support it. | [optional]

### Return type

[**WorkPackageAlternativePageResponse**](WorkPackageAlternativePageResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **previewProjectSpecificationSelection**
> ProjectCandidateResponse previewProjectSpecificationSelection(packageId, candidateId, projectSelectionPreview)



Re-price a fresh candidate with the Buyer's specification choices (lines, totals, delivery estimate, score and budget label). Exact-match defaults for missing materials are saved to the draft arrangement; explicit removals and manual replacements are preserved. No regular cart, order or payment is created. Send the same selections when selecting or inquiring. An unknown option is SPECIFICATION_OPTION_INVALID.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerProjectsApi();
final String packageId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String candidateId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ProjectSelectionPreview projectSelectionPreview = ; // ProjectSelectionPreview |

try {
    final response = api.previewProjectSpecificationSelection(packageId, candidateId, projectSelectionPreview);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerProjectsApi->previewProjectSpecificationSelection: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **packageId** | **String**|  |
 **candidateId** | **String**|  |
 **projectSelectionPreview** | [**ProjectSelectionPreview**](ProjectSelectionPreview.md)|  |

### Return type

[**ProjectCandidateResponse**](ProjectCandidateResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
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

# **reactivateWorkPackage**
> WorkPackageViewResponse reactivateWorkPackage(packageId, idempotencyKey, projectVersionRequest)



Reactivate the same owned Cancelled Work Package after current version, open-order and Project budget checks. Cancelled, declined and expired orders do not keep the old Vendor selection locked. A cancelled order original is retained internally and the reactivated package uses fresh requirement identities, estimates and inquiries; no order is reopened or duplicated.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerProjectsApi();
final String packageId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ProjectVersionRequest projectVersionRequest = ; // ProjectVersionRequest |

try {
    final response = api.reactivateWorkPackage(packageId, idempotencyKey, projectVersionRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerProjectsApi->reactivateWorkPackage: $e\n');
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

# **removeProjectDraftItem**
> ChatIdResponse removeProjectDraftItem(packageId, candidateId, lineId, variantId, projectVersionRequest)



Remove an unsubmitted supplementary selection, preserving the requirement and restoring remaining fulfillment on the next preview. Submitted orders retain existing cancellation rules.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerProjectsApi();
final String packageId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String candidateId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String lineId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String variantId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ProjectVersionRequest projectVersionRequest = ; // ProjectVersionRequest |

try {
    final response = api.removeProjectDraftItem(packageId, candidateId, lineId, variantId, projectVersionRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerProjectsApi->removeProjectDraftItem: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **packageId** | **String**|  |
 **candidateId** | **String**|  |
 **lineId** | **String**|  |
 **variantId** | **String**|  |
 **projectVersionRequest** | [**ProjectVersionRequest**](ProjectVersionRequest.md)|  |

### Return type

[**ChatIdResponse**](ChatIdResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **requestProjectDraftSupplier**
> ChatIdResponse requestProjectDraftSupplier(packageId, candidateId, vendorId, idempotencyKey, projectDraftSupplierRequest)



Explicit request to ONE supplementary supplier after the primary Project-Based request exists. Revalidate the reviewed fingerprint, prices, eligibility, fulfillment, payment, ownership and budgets. Create a separate linked Item-Based order awaiting manual Vendor confirmation; never touch the regular cart, auto-accept an order, request other suppliers or start payment.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerProjectsApi();
final String packageId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String candidateId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String vendorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ProjectDraftSupplierRequest projectDraftSupplierRequest = ; // ProjectDraftSupplierRequest |

try {
    final response = api.requestProjectDraftSupplier(packageId, candidateId, vendorId, idempotencyKey, projectDraftSupplierRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerProjectsApi->requestProjectDraftSupplier: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **packageId** | **String**|  |
 **candidateId** | **String**|  |
 **vendorId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **projectDraftSupplierRequest** | [**ProjectDraftSupplierRequest**](ProjectDraftSupplierRequest.md)|  |

### Return type

[**ChatIdResponse**](ChatIdResponse.md)

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

# **saveProjectDraftItem**
> ChatIdResponse saveProjectDraftItem(packageId, candidateId, lineId, variantId, projectDraftItemInput)



Add one recommendation to the Work Package draft. Server caps quantity by the remaining requirement and available stock. Idempotent PUT never stacks duplicates. No cart, order, stock reservation or payment is created.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerProjectsApi();
final String packageId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String candidateId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String lineId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String variantId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ProjectDraftItemInput projectDraftItemInput = ; // ProjectDraftItemInput |

try {
    final response = api.saveProjectDraftItem(packageId, candidateId, lineId, variantId, projectDraftItemInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerProjectsApi->saveProjectDraftItem: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **packageId** | **String**|  |
 **candidateId** | **String**|  |
 **lineId** | **String**|  |
 **variantId** | **String**|  |
 **projectDraftItemInput** | [**ProjectDraftItemInput**](ProjectDraftItemInput.md)|  |

### Return type

[**ChatIdResponse**](ChatIdResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **saveProjectRankingPreferences**
> ProjectPreferencesResponse saveProjectRankingPreferences(projectPreferenceSave)



Exactly four independent integer weights in [0,100], at least one above zero (422 WEIGHTS_ALL_ZERO). Original values are stored and restored; scoring divides each by the sum of weights. Defaults: material_match 40, budget_fit 25, distance 20, vps 15.

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
> ChatIdResponse selectProjectVendor(packageId, idempotencyKey, projectVendorSelectionRequest)



Select exactly one Vendor from a fresh estimate and expire other active quotations. Creates a manual 24-hour package request. Optional Note needs no Vendor response. No auto-accept.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerProjectsApi();
final String packageId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ProjectVendorSelectionRequest projectVendorSelectionRequest = ; // ProjectVendorSelectionRequest |

try {
    final response = api.selectProjectVendor(packageId, idempotencyKey, projectVendorSelectionRequest);
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
 **projectVendorSelectionRequest** | [**ProjectVendorSelectionRequest**](ProjectVendorSelectionRequest.md)|  |

### Return type

[**ChatIdResponse**](ChatIdResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **submitProjectArrangement**
> ProjectArrangementResponse submitProjectArrangement(packageId, arrangementId, idempotencyKey, projectArrangementSubmit)



### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getBuyerProjectsApi();
final String packageId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String arrangementId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final ProjectArrangementSubmit projectArrangementSubmit = ; // ProjectArrangementSubmit |

try {
    final response = api.submitProjectArrangement(packageId, arrangementId, idempotencyKey, projectArrangementSubmit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling BuyerProjectsApi->submitProjectArrangement: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **packageId** | **String**|  |
 **arrangementId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **projectArrangementSubmit** | [**ProjectArrangementSubmit**](ProjectArrangementSubmit.md)|  |

### Return type

[**ProjectArrangementResponse**](ProjectArrangementResponse.md)

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

