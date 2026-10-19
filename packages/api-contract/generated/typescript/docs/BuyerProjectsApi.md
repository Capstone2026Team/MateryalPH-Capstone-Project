# BuyerProjectsApi

All URIs are relative to */api/v1*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**activateWorkPackage**](BuyerProjectsApi.md#activateworkpackage) | **POST** /buyers/work-packages/{packageId}/activate |  |
| [**closeWorkPackage**](BuyerProjectsApi.md#closeworkpackage) | **POST** /buyers/work-packages/{packageId}/close |  |
| [**compileProjectEstimates**](BuyerProjectsApi.md#compileprojectestimates) | **POST** /buyers/work-packages/{packageId}/estimates |  |
| [**createProject**](BuyerProjectsApi.md#createproject) | **POST** /buyers/projects |  |
| [**createProjectArrangement**](BuyerProjectsApi.md#createprojectarrangement) | **POST** /buyers/work-packages/{packageId}/arrangements |  |
| [**createWorkPackage**](BuyerProjectsApi.md#createworkpackage) | **POST** /buyers/projects/{projectId}/work-packages |  |
| [**deleteProject**](BuyerProjectsApi.md#deleteproject) | **DELETE** /buyers/projects/{projectId} |  |
| [**deleteWorkPackage**](BuyerProjectsApi.md#deleteworkpackage) | **DELETE** /buyers/work-packages/{packageId} |  |
| [**editProjectArrangement**](BuyerProjectsApi.md#editprojectarrangement) | **PATCH** /buyers/work-packages/{packageId}/arrangements/{arrangementId} |  |
| [**editWorkPackage**](BuyerProjectsApi.md#editworkpackage) | **PUT** /buyers/work-packages/{packageId} |  |
| [**estimateWorkPackageBudget**](BuyerProjectsApi.md#estimateworkpackagebudget) | **POST** /buyers/projects/{projectId}/work-package-estimate |  |
| [**getProject**](BuyerProjectsApi.md#getproject) | **GET** /buyers/projects/{projectId} |  |
| [**getProjectArrangement**](BuyerProjectsApi.md#getprojectarrangement) | **GET** /buyers/work-packages/{packageId}/arrangements/{arrangementId} |  |
| [**getProjectCandidateRoute**](BuyerProjectsApi.md#getprojectcandidateroute) | **POST** /buyers/work-packages/{packageId}/candidates/{candidateId}/route |  |
| [**getProjectEstimates**](BuyerProjectsApi.md#getprojectestimates) | **GET** /buyers/work-packages/{packageId}/estimates |  |
| [**getProjectRankingPreferences**](BuyerProjectsApi.md#getprojectrankingpreferences) | **GET** /buyers/project-ranking-preferences |  |
| [**getWorkPackage**](BuyerProjectsApi.md#getworkpackage) | **GET** /buyers/work-packages/{packageId} |  |
| [**inquireProjectArrangementVendor**](BuyerProjectsApi.md#inquireprojectarrangementvendor) | **POST** /buyers/work-packages/{packageId}/arrangements/{arrangementId}/vendors/{vendorId}/inquiry |  |
| [**inquireProjectVendor**](BuyerProjectsApi.md#inquireprojectvendor) | **POST** /buyers/work-packages/{packageId}/inquiries |  |
| [**listProjectArrangementOptions**](BuyerProjectsApi.md#listprojectarrangementoptions) | **GET** /buyers/work-packages/{packageId}/arrangement-options |  |
| [**listProjects**](BuyerProjectsApi.md#listprojects) | **GET** /buyers/projects |  |
| [**listWorkPackageLineAlternatives**](BuyerProjectsApi.md#listworkpackagelinealternatives) | **GET** /buyers/work-packages/{packageId}/lines/{lineId}/alternatives |  |
| [**previewProjectSpecificationSelection**](BuyerProjectsApi.md#previewprojectspecificationselection) | **POST** /buyers/work-packages/{packageId}/candidates/{candidateId}/selection-preview |  |
| [**previewWorkPackageCsv**](BuyerProjectsApi.md#previewworkpackagecsv) | **POST** /buyers/work-packages/import-preview |  |
| [**reactivateWorkPackage**](BuyerProjectsApi.md#reactivateworkpackage) | **POST** /buyers/work-packages/{packageId}/reactivate |  |
| [**removeProjectDraftItem**](BuyerProjectsApi.md#removeprojectdraftitem) | **DELETE** /buyers/work-packages/{packageId}/candidates/{candidateId}/draft-items/{lineId}/{variantId} |  |
| [**requestProjectDraftSupplier**](BuyerProjectsApi.md#requestprojectdraftsupplier) | **POST** /buyers/work-packages/{packageId}/candidates/{candidateId}/suppliers/{vendorId}/request |  |
| [**resetProjectRankingPreferences**](BuyerProjectsApi.md#resetprojectrankingpreferences) | **POST** /buyers/project-ranking-preferences/reset |  |
| [**resolveProjectMissingLine**](BuyerProjectsApi.md#resolveprojectmissingline) | **PUT** /buyers/work-packages/{packageId}/missing-lines/{lineId} |  |
| [**saveProjectDraftItem**](BuyerProjectsApi.md#saveprojectdraftitem) | **PUT** /buyers/work-packages/{packageId}/candidates/{candidateId}/draft-items/{lineId}/{variantId} |  |
| [**saveProjectRankingPreferences**](BuyerProjectsApi.md#saveprojectrankingpreferences) | **PUT** /buyers/project-ranking-preferences |  |
| [**searchProjectMaterials**](BuyerProjectsApi.md#searchprojectmaterials) | **GET** /buyers/project-materials |  |
| [**selectProjectVendor**](BuyerProjectsApi.md#selectprojectvendor) | **POST** /buyers/work-packages/{packageId}/selection |  |
| [**submitProjectArrangement**](BuyerProjectsApi.md#submitprojectarrangement) | **POST** /buyers/work-packages/{packageId}/arrangements/{arrangementId}/submit |  |
| [**updateProject**](BuyerProjectsApi.md#updateproject) | **PATCH** /buyers/projects/{projectId} |  |



## activateWorkPackage

> WorkPackageViewResponse activateWorkPackage(packageId, idempotencyKey, projectVersionRequest)



Lock the original version; scan explicitly afterward.

### Example

```ts
import {
  Configuration,
  BuyerProjectsApi,
} from '@materyalph/api-client-ts';
import type { ActivateWorkPackageRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerProjectsApi(config);

  const body = {
    // string
    packageId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    idempotencyKey: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // ProjectVersionRequest
    projectVersionRequest: ...,
  } satisfies ActivateWorkPackageRequest;

  try {
    const data = await api.activateWorkPackage(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **packageId** | `string` |  | [Defaults to `undefined`] |
| **idempotencyKey** | `string` |  | [Defaults to `undefined`] |
| **projectVersionRequest** | [ProjectVersionRequest](ProjectVersionRequest.md) |  | |

### Return type

[**WorkPackageViewResponse**](WorkPackageViewResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized Project procurement result. |  -  |
| **401** | Authentication required. |  -  |
| **403** | Current Buyer authorization required. |  -  |
| **404** | No owned resource or current candidate. |  -  |
| **409** | Stale version, expired estimate, source change or already selected Vendor; no mutation. |  -  |
| **422** | Validation, fulfillment review or written budget override required. |  -  |
| **503** | Provider unavailable; retry without fabricated values. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## closeWorkPackage

> WorkPackageViewResponse closeWorkPackage(packageId, projectVersionRequest)



Cancel an unassigned package, retaining its saved contents. Selected work follows order cancellation rules.

### Example

```ts
import {
  Configuration,
  BuyerProjectsApi,
} from '@materyalph/api-client-ts';
import type { CloseWorkPackageRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerProjectsApi(config);

  const body = {
    // string
    packageId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // ProjectVersionRequest
    projectVersionRequest: ...,
  } satisfies CloseWorkPackageRequest;

  try {
    const data = await api.closeWorkPackage(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **packageId** | `string` |  | [Defaults to `undefined`] |
| **projectVersionRequest** | [ProjectVersionRequest](ProjectVersionRequest.md) |  | |

### Return type

[**WorkPackageViewResponse**](WorkPackageViewResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized Project procurement result. |  -  |
| **401** | Authentication required. |  -  |
| **403** | Current Buyer authorization required. |  -  |
| **404** | No owned resource or current candidate. |  -  |
| **409** | Stale version, expired estimate, source change or already selected Vendor; no mutation. |  -  |
| **422** | Validation, fulfillment review or written budget override required. |  -  |
| **503** | Provider unavailable; retry without fabricated values. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## compileProjectEstimates

> ProjectEstimatePageResponse compileProjectEstimates(packageId, projectCompile)



Scan eligible Bulk Yes Tier 2 offers within the fixed 50 km Project-Based radius from the Project site. FMS uses exact normalized weights. Unknown delivery cost remains pending; schedules never change validity or score.

### Example

```ts
import {
  Configuration,
  BuyerProjectsApi,
} from '@materyalph/api-client-ts';
import type { CompileProjectEstimatesRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerProjectsApi(config);

  const body = {
    // string
    packageId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // ProjectCompile
    projectCompile: ...,
  } satisfies CompileProjectEstimatesRequest;

  try {
    const data = await api.compileProjectEstimates(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **packageId** | `string` |  | [Defaults to `undefined`] |
| **projectCompile** | [ProjectCompile](ProjectCompile.md) |  | |

### Return type

[**ProjectEstimatePageResponse**](ProjectEstimatePageResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized Project procurement result. |  -  |
| **401** | Authentication required. |  -  |
| **403** | Current Buyer authorization required. |  -  |
| **404** | No owned resource or current candidate. |  -  |
| **409** | Stale version, expired estimate, source change or already selected Vendor; no mutation. |  -  |
| **422** | Validation, fulfillment review or written budget override required. |  -  |
| **503** | Provider unavailable; retry without fabricated values. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## createProject

> ProjectViewResponse createProject(idempotencyKey, projectCreate)



Create an Active Project with a frozen site copied from the authenticated Buyer saved location.

### Example

```ts
import {
  Configuration,
  BuyerProjectsApi,
} from '@materyalph/api-client-ts';
import type { CreateProjectRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerProjectsApi(config);

  const body = {
    // string
    idempotencyKey: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // ProjectCreate
    projectCreate: ...,
  } satisfies CreateProjectRequest;

  try {
    const data = await api.createProject(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **idempotencyKey** | `string` |  | [Defaults to `undefined`] |
| **projectCreate** | [ProjectCreate](ProjectCreate.md) |  | |

### Return type

[**ProjectViewResponse**](ProjectViewResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **201** | Authorized Project procurement result. |  -  |
| **401** | Authentication required. |  -  |
| **403** | Current Buyer authorization required. |  -  |
| **404** | No owned resource or current candidate. |  -  |
| **409** | Stale version, expired estimate, source change or already selected Vendor; no mutation. |  -  |
| **422** | Validation, fulfillment review or written budget override required. |  -  |
| **503** | Provider unavailable; retry without fabricated values. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## createProjectArrangement

> ProjectArrangementResponse createProjectArrangement(packageId, idempotencyKey, projectArrangementCreate)



### Example

```ts
import {
  Configuration,
  BuyerProjectsApi,
} from '@materyalph/api-client-ts';
import type { CreateProjectArrangementRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerProjectsApi(config);

  const body = {
    // string
    packageId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    idempotencyKey: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // ProjectArrangementCreate
    projectArrangementCreate: ...,
  } satisfies CreateProjectArrangementRequest;

  try {
    const data = await api.createProjectArrangement(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **packageId** | `string` |  | [Defaults to `undefined`] |
| **idempotencyKey** | `string` |  | [Defaults to `undefined`] |
| **projectArrangementCreate** | [ProjectArrangementCreate](ProjectArrangementCreate.md) |  | |

### Return type

[**ProjectArrangementResponse**](ProjectArrangementResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **201** | Saved successfully. |  -  |
| **401** | Authentication required. |  -  |
| **403** | Current Buyer authorization required. |  -  |
| **404** | Owned Work Package or current arrangement not found. |  -  |
| **409** | Arrangement, inventory, price or version changed; refresh. |  -  |
| **422** | Review specifications, fulfillment, payment or budget. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## createWorkPackage

> WorkPackageViewResponse createWorkPackage(projectId, idempotencyKey, workPackageInput)



Save a Draft. Normalized units, positive quantities, explicit site and access are validated. The budget is deducted from the Project budget immediately; WORK_PACKAGE_BUDGET_EXCEEDS_PROJECT (422) when non-cancelled allocations would exceed it.

### Example

```ts
import {
  Configuration,
  BuyerProjectsApi,
} from '@materyalph/api-client-ts';
import type { CreateWorkPackageRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerProjectsApi(config);

  const body = {
    // string
    projectId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    idempotencyKey: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // WorkPackageInput
    workPackageInput: ...,
  } satisfies CreateWorkPackageRequest;

  try {
    const data = await api.createWorkPackage(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **projectId** | `string` |  | [Defaults to `undefined`] |
| **idempotencyKey** | `string` |  | [Defaults to `undefined`] |
| **workPackageInput** | [WorkPackageInput](WorkPackageInput.md) |  | |

### Return type

[**WorkPackageViewResponse**](WorkPackageViewResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **201** | Authorized Project procurement result. |  -  |
| **401** | Authentication required. |  -  |
| **403** | Current Buyer authorization required. |  -  |
| **404** | No owned resource or current candidate. |  -  |
| **409** | Stale version, expired estimate, source change or already selected Vendor; no mutation. |  -  |
| **422** | Validation, fulfillment review or written budget override required. |  -  |
| **503** | Provider unavailable; retry without fabricated values. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## deleteProject

> ChatEmptyResponse deleteProject(projectId, projectVersionRequest)



Delete only when no Work Packages or procurement history exists. Otherwise archive.

### Example

```ts
import {
  Configuration,
  BuyerProjectsApi,
} from '@materyalph/api-client-ts';
import type { DeleteProjectRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerProjectsApi(config);

  const body = {
    // string
    projectId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // ProjectVersionRequest
    projectVersionRequest: ...,
  } satisfies DeleteProjectRequest;

  try {
    const data = await api.deleteProject(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **projectId** | `string` |  | [Defaults to `undefined`] |
| **projectVersionRequest** | [ProjectVersionRequest](ProjectVersionRequest.md) |  | |

### Return type

[**ChatEmptyResponse**](ChatEmptyResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized Project procurement result. |  -  |
| **401** | Authentication required. |  -  |
| **403** | Current Buyer authorization required. |  -  |
| **404** | No owned resource or current candidate. |  -  |
| **409** | Stale version, expired estimate, source change or already selected Vendor; no mutation. |  -  |
| **422** | Validation, fulfillment review or written budget override required. |  -  |
| **503** | Provider unavailable; retry without fabricated values. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## deleteWorkPackage

> ChatEmptyResponse deleteWorkPackage(packageId, projectVersionRequest)



Delete a Work Package that has no order, tagged purchase or selected Vendor. A Draft with no locked history is removed; any other package is cancelled and hidden from the Buyer while its saved originals, estimates and quotations are retained. A package with an order returns WORK_PACKAGE_HAS_ORDER.

### Example

```ts
import {
  Configuration,
  BuyerProjectsApi,
} from '@materyalph/api-client-ts';
import type { DeleteWorkPackageRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerProjectsApi(config);

  const body = {
    // string
    packageId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // ProjectVersionRequest
    projectVersionRequest: ...,
  } satisfies DeleteWorkPackageRequest;

  try {
    const data = await api.deleteWorkPackage(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **packageId** | `string` |  | [Defaults to `undefined`] |
| **projectVersionRequest** | [ProjectVersionRequest](ProjectVersionRequest.md) |  | |

### Return type

[**ChatEmptyResponse**](ChatEmptyResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized Project procurement result. |  -  |
| **401** | Authentication required. |  -  |
| **403** | Current Buyer authorization required. |  -  |
| **404** | No owned resource or current candidate. |  -  |
| **409** | Stale version, expired estimate, source change or already selected Vendor; no mutation. |  -  |
| **422** | Validation, fulfillment review or written budget override required. |  -  |
| **503** | Provider unavailable; retry without fabricated values. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## editProjectArrangement

> ProjectArrangementResponse editProjectArrangement(packageId, arrangementId, projectArrangementEdit)



### Example

```ts
import {
  Configuration,
  BuyerProjectsApi,
} from '@materyalph/api-client-ts';
import type { EditProjectArrangementRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerProjectsApi(config);

  const body = {
    // string
    packageId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    arrangementId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // ProjectArrangementEdit
    projectArrangementEdit: ...,
  } satisfies EditProjectArrangementRequest;

  try {
    const data = await api.editProjectArrangement(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **packageId** | `string` |  | [Defaults to `undefined`] |
| **arrangementId** | `string` |  | [Defaults to `undefined`] |
| **projectArrangementEdit** | [ProjectArrangementEdit](ProjectArrangementEdit.md) |  | |

### Return type

[**ProjectArrangementResponse**](ProjectArrangementResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Server-authoritative procurement arrangement. |  -  |
| **401** | Authentication required. |  -  |
| **403** | Current Buyer authorization required. |  -  |
| **404** | Owned Work Package or current arrangement not found. |  -  |
| **409** | Arrangement, inventory, price or version changed; refresh. |  -  |
| **422** | Review specifications, fulfillment, payment or budget. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## editWorkPackage

> WorkPackageViewResponse editWorkPackage(packageId, idempotencyKey, workPackageInput)



Edit the Work Package directly, with no new list entry. Allowed until an order, tagged purchase or selected Vendor exists (otherwise WORK_PACKAGE_HAS_ORDER). Estimates and open quotation requests built on the old materials are invalidated; a compared or quoted package returns to Active.

### Example

```ts
import {
  Configuration,
  BuyerProjectsApi,
} from '@materyalph/api-client-ts';
import type { EditWorkPackageRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerProjectsApi(config);

  const body = {
    // string
    packageId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    idempotencyKey: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // WorkPackageInput
    workPackageInput: ...,
  } satisfies EditWorkPackageRequest;

  try {
    const data = await api.editWorkPackage(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **packageId** | `string` |  | [Defaults to `undefined`] |
| **idempotencyKey** | `string` |  | [Defaults to `undefined`] |
| **workPackageInput** | [WorkPackageInput](WorkPackageInput.md) |  | |

### Return type

[**WorkPackageViewResponse**](WorkPackageViewResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized Project procurement result. |  -  |
| **401** | Authentication required. |  -  |
| **403** | Current Buyer authorization required. |  -  |
| **404** | No owned resource or current candidate. |  -  |
| **409** | Stale version, expired estimate, source change or already selected Vendor; no mutation. |  -  |
| **422** | Validation, fulfillment review or written budget override required. |  -  |
| **503** | Provider unavailable; retry without fabricated values. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## estimateWorkPackageBudget

> WorkPackageBudgetEstimateResponse estimateWorkPackageBudget(projectId, workPackageBudgetEstimateRequest)



Advisory budget estimate for a Work Package being drafted. Each catalog line is priced at the half-up average of one price per eligible Vendor (that Vendor\&#39;s lowest exact match) within the radius of the site. Unlisted and unmatched lines carry no price. Excludes labor and processing fees. Site Delivery and Both include actual route/vehicle estimates for a representative exact-match supplier plan, consolidated per supplier. Unknown delivery remains null. Nothing is stored.

### Example

```ts
import {
  Configuration,
  BuyerProjectsApi,
} from '@materyalph/api-client-ts';
import type { EstimateWorkPackageBudgetRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerProjectsApi(config);

  const body = {
    // string
    projectId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // WorkPackageBudgetEstimateRequest
    workPackageBudgetEstimateRequest: ...,
  } satisfies EstimateWorkPackageBudgetRequest;

  try {
    const data = await api.estimateWorkPackageBudget(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **projectId** | `string` |  | [Defaults to `undefined`] |
| **workPackageBudgetEstimateRequest** | [WorkPackageBudgetEstimateRequest](WorkPackageBudgetEstimateRequest.md) |  | |

### Return type

[**WorkPackageBudgetEstimateResponse**](WorkPackageBudgetEstimateResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Advisory estimate. |  -  |
| **401** | Authentication required. |  -  |
| **403** | Current Buyer authorization required. |  -  |
| **404** | No owned resource or current candidate. |  -  |
| **409** | Stale version, expired estimate, source change or already selected Vendor; no mutation. |  -  |
| **422** | Validation failed or the site is not part of this Project. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getProject

> ProjectViewResponse getProject(projectId, page)



Project sites and paginated Work Packages.

### Example

```ts
import {
  Configuration,
  BuyerProjectsApi,
} from '@materyalph/api-client-ts';
import type { GetProjectRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerProjectsApi(config);

  const body = {
    // string
    projectId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // number (optional)
    page: 56,
  } satisfies GetProjectRequest;

  try {
    const data = await api.getProject(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **projectId** | `string` |  | [Defaults to `undefined`] |
| **page** | `number` |  | [Optional] [Defaults to `undefined`] |

### Return type

[**ProjectViewResponse**](ProjectViewResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized Project procurement result. |  -  |
| **401** | Authentication required. |  -  |
| **403** | Current Buyer authorization required. |  -  |
| **404** | No owned resource or current candidate. |  -  |
| **409** | Stale version, expired estimate, source change or already selected Vendor; no mutation. |  -  |
| **422** | Validation, fulfillment review or written budget override required. |  -  |
| **503** | Provider unavailable; retry without fabricated values. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getProjectArrangement

> ProjectArrangementResponse getProjectArrangement(packageId, arrangementId)



### Example

```ts
import {
  Configuration,
  BuyerProjectsApi,
} from '@materyalph/api-client-ts';
import type { GetProjectArrangementRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerProjectsApi(config);

  const body = {
    // string
    packageId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    arrangementId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies GetProjectArrangementRequest;

  try {
    const data = await api.getProjectArrangement(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **packageId** | `string` |  | [Defaults to `undefined`] |
| **arrangementId** | `string` |  | [Defaults to `undefined`] |

### Return type

[**ProjectArrangementResponse**](ProjectArrangementResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Server-authoritative procurement arrangement. |  -  |
| **401** | Authentication required. |  -  |
| **403** | Current Buyer authorization required. |  -  |
| **404** | Owned Work Package or current arrangement not found. |  -  |
| **409** | Arrangement, inventory, price or version changed; refresh. |  -  |
| **422** | Review specifications, fulfillment, payment or budget. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getProjectCandidateRoute

> ProjectRouteResponse getProjectCandidateRoute(packageId, candidateId)



One decision route from the frozen Project site. Separate delivery endpoint/rate basis remains in the advisory estimate.

### Example

```ts
import {
  Configuration,
  BuyerProjectsApi,
} from '@materyalph/api-client-ts';
import type { GetProjectCandidateRouteRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerProjectsApi(config);

  const body = {
    // string
    packageId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    candidateId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies GetProjectCandidateRouteRequest;

  try {
    const data = await api.getProjectCandidateRoute(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **packageId** | `string` |  | [Defaults to `undefined`] |
| **candidateId** | `string` |  | [Defaults to `undefined`] |

### Return type

[**ProjectRouteResponse**](ProjectRouteResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized Project procurement result. |  -  |
| **401** | Authentication required. |  -  |
| **403** | Current Buyer authorization required. |  -  |
| **404** | No owned resource or current candidate. |  -  |
| **409** | Stale version, expired estimate, source change or already selected Vendor; no mutation. |  -  |
| **422** | Validation, fulfillment review or written budget override required. |  -  |
| **503** | Provider unavailable; retry without fabricated values. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getProjectEstimates

> ProjectEstimatePageResponse getProjectEstimates(packageId, page, sort, direction, favoritesOnly, completeOnly, withinBudget)



Immutable, paginated snapshots. Complete one-Vendor matches first by default; missing lines explicit. Expiry is exactly 48 hours. Sorting and filters run on the server so every page is consistent; each ordering ends on the system rank.

### Example

```ts
import {
  Configuration,
  BuyerProjectsApi,
} from '@materyalph/api-client-ts';
import type { GetProjectEstimatesRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerProjectsApi(config);

  const body = {
    // string
    packageId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // number (optional)
    page: 56,
    // 'BEST_MATCH' | 'BUDGET_FIT' | 'RATING' | 'PRICE' (optional)
    sort: sort_example,
    // 'ASC' | 'DESC' | ASC is low to high and DESC high to low. Omitted, each ordering opens on its default: BUDGET_FIT and RATING DESC (best first), PRICE ASC (cheapest first). Ignored for BEST_MATCH, a fixed ranking. A Vendor without a value (no rating, cost under review) is always last, and ties go to the nearest store. (optional)
    direction: direction_example,
    // boolean (optional)
    favoritesOnly: true,
    // boolean (optional)
    completeOnly: true,
    // boolean (optional)
    withinBudget: true,
  } satisfies GetProjectEstimatesRequest;

  try {
    const data = await api.getProjectEstimates(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **packageId** | `string` |  | [Defaults to `undefined`] |
| **page** | `number` |  | [Optional] [Defaults to `undefined`] |
| **sort** | `BEST_MATCH`, `BUDGET_FIT`, `RATING`, `PRICE` |  | [Optional] [Defaults to `undefined`] [Enum: BEST_MATCH, BUDGET_FIT, RATING, PRICE] |
| **direction** | `ASC`, `DESC` | ASC is low to high and DESC high to low. Omitted, each ordering opens on its default: BUDGET_FIT and RATING DESC (best first), PRICE ASC (cheapest first). Ignored for BEST_MATCH, a fixed ranking. A Vendor without a value (no rating, cost under review) is always last, and ties go to the nearest store. | [Optional] [Defaults to `undefined`] [Enum: ASC, DESC] |
| **favoritesOnly** | `boolean` |  | [Optional] [Defaults to `undefined`] |
| **completeOnly** | `boolean` |  | [Optional] [Defaults to `undefined`] |
| **withinBudget** | `boolean` |  | [Optional] [Defaults to `undefined`] |

### Return type

[**ProjectEstimatePageResponse**](ProjectEstimatePageResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized Project procurement result. |  -  |
| **401** | Authentication required. |  -  |
| **403** | Current Buyer authorization required. |  -  |
| **404** | No owned resource or current candidate. |  -  |
| **409** | Stale version, expired estimate, source change or already selected Vendor; no mutation. |  -  |
| **422** | Validation, fulfillment review or written budget override required. |  -  |
| **503** | Provider unavailable; retry without fabricated values. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getProjectRankingPreferences

> ProjectPreferencesResponse getProjectRankingPreferences()



Separate Project-Based preference record and active personalized indicator.

### Example

```ts
import {
  Configuration,
  BuyerProjectsApi,
} from '@materyalph/api-client-ts';
import type { GetProjectRankingPreferencesRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerProjectsApi(config);

  try {
    const data = await api.getProjectRankingPreferences();
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters

This endpoint does not need any parameter.

### Return type

[**ProjectPreferencesResponse**](ProjectPreferencesResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized Project procurement result. |  -  |
| **401** | Authentication required. |  -  |
| **403** | Current Buyer authorization required. |  -  |
| **404** | No owned resource or current candidate. |  -  |
| **409** | Stale version, expired estimate, source change or already selected Vendor; no mutation. |  -  |
| **422** | Validation, fulfillment review or written budget override required. |  -  |
| **503** | Provider unavailable; retry without fabricated values. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getWorkPackage

> WorkPackageViewResponse getWorkPackage(packageId, page)



The package\&#39;s current materials, missing-item resolution, budget metrics and delete/edit availability. PDF generation remains Phase 15.

### Example

```ts
import {
  Configuration,
  BuyerProjectsApi,
} from '@materyalph/api-client-ts';
import type { GetWorkPackageRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerProjectsApi(config);

  const body = {
    // string
    packageId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // number (optional)
    page: 56,
  } satisfies GetWorkPackageRequest;

  try {
    const data = await api.getWorkPackage(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **packageId** | `string` |  | [Defaults to `undefined`] |
| **page** | `number` |  | [Optional] [Defaults to `undefined`] |

### Return type

[**WorkPackageViewResponse**](WorkPackageViewResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized Project procurement result. |  -  |
| **401** | Authentication required. |  -  |
| **403** | Current Buyer authorization required. |  -  |
| **404** | No owned resource or current candidate. |  -  |
| **409** | Stale version, expired estimate, source change or already selected Vendor; no mutation. |  -  |
| **422** | Validation, fulfillment review or written budget override required. |  -  |
| **503** | Provider unavailable; retry without fabricated values. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## inquireProjectArrangementVendor

> ProjectArrangementResponse inquireProjectArrangementVendor(packageId, arrangementId, vendorId, projectArrangementInquiry)



### Example

```ts
import {
  Configuration,
  BuyerProjectsApi,
} from '@materyalph/api-client-ts';
import type { InquireProjectArrangementVendorRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerProjectsApi(config);

  const body = {
    // string
    packageId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    arrangementId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    vendorId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // ProjectArrangementInquiry
    projectArrangementInquiry: ...,
  } satisfies InquireProjectArrangementVendorRequest;

  try {
    const data = await api.inquireProjectArrangementVendor(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **packageId** | `string` |  | [Defaults to `undefined`] |
| **arrangementId** | `string` |  | [Defaults to `undefined`] |
| **vendorId** | `string` |  | [Defaults to `undefined`] |
| **projectArrangementInquiry** | [ProjectArrangementInquiry](ProjectArrangementInquiry.md) |  | |

### Return type

[**ProjectArrangementResponse**](ProjectArrangementResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Server-authoritative procurement arrangement. |  -  |
| **401** | Authentication required. |  -  |
| **403** | Current Buyer authorization required. |  -  |
| **404** | Owned Work Package or current arrangement not found. |  -  |
| **409** | Arrangement, inventory, price or version changed; refresh. |  -  |
| **422** | Review specifications, fulfillment, payment or budget. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## inquireProjectVendor

> ChatIdResponse inquireProjectVendor(packageId, idempotencyKey, projectCandidateRequest)



Open/resume this eligible candidate inquiry only; attach locked original and Vendor-editable duplicate to the shared quotation engine.

### Example

```ts
import {
  Configuration,
  BuyerProjectsApi,
} from '@materyalph/api-client-ts';
import type { InquireProjectVendorRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerProjectsApi(config);

  const body = {
    // string
    packageId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    idempotencyKey: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // ProjectCandidateRequest
    projectCandidateRequest: ...,
  } satisfies InquireProjectVendorRequest;

  try {
    const data = await api.inquireProjectVendor(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **packageId** | `string` |  | [Defaults to `undefined`] |
| **idempotencyKey** | `string` |  | [Defaults to `undefined`] |
| **projectCandidateRequest** | [ProjectCandidateRequest](ProjectCandidateRequest.md) |  | |

### Return type

[**ChatIdResponse**](ChatIdResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **201** | Authorized Project procurement result. |  -  |
| **401** | Authentication required. |  -  |
| **403** | Current Buyer authorization required. |  -  |
| **404** | No owned resource or current candidate. |  -  |
| **409** | Stale version, expired estimate, source change or already selected Vendor; no mutation. |  -  |
| **422** | Validation, fulfillment review or written budget override required. |  -  |
| **503** | Provider unavailable; retry without fabricated values. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## listProjectArrangementOptions

> ProjectArrangementPageResponse listProjectArrangementOptions(packageId, page, sort, direction, favoritesOnly, completeOnly, withinBudget)



### Example

```ts
import {
  Configuration,
  BuyerProjectsApi,
} from '@materyalph/api-client-ts';
import type { ListProjectArrangementOptionsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerProjectsApi(config);

  const body = {
    // string
    packageId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // number (optional)
    page: 56,
    // 'BEST_MATCH' | 'PRICE' (optional)
    sort: sort_example,
    // 'ASC' | 'DESC' (optional)
    direction: direction_example,
    // boolean (optional)
    favoritesOnly: true,
    // boolean (optional)
    completeOnly: true,
    // boolean (optional)
    withinBudget: true,
  } satisfies ListProjectArrangementOptionsRequest;

  try {
    const data = await api.listProjectArrangementOptions(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **packageId** | `string` |  | [Defaults to `undefined`] |
| **page** | `number` |  | [Optional] [Defaults to `undefined`] |
| **sort** | `BEST_MATCH`, `PRICE` |  | [Optional] [Defaults to `undefined`] [Enum: BEST_MATCH, PRICE] |
| **direction** | `ASC`, `DESC` |  | [Optional] [Defaults to `undefined`] [Enum: ASC, DESC] |
| **favoritesOnly** | `boolean` |  | [Optional] [Defaults to `undefined`] |
| **completeOnly** | `boolean` |  | [Optional] [Defaults to `undefined`] |
| **withinBudget** | `boolean` |  | [Optional] [Defaults to `undefined`] |

### Return type

[**ProjectArrangementPageResponse**](ProjectArrangementPageResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Server-authoritative procurement arrangement. |  -  |
| **401** | Authentication required. |  -  |
| **403** | Current Buyer authorization required. |  -  |
| **404** | Owned Work Package or current arrangement not found. |  -  |
| **409** | Arrangement, inventory, price or version changed; refresh. |  -  |
| **422** | Review specifications, fulfillment, payment or budget. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## listProjects

> ProjectPageResponse listProjects(page)



Paginated owned Projects and disjoint FIN-11 metrics.

### Example

```ts
import {
  Configuration,
  BuyerProjectsApi,
} from '@materyalph/api-client-ts';
import type { ListProjectsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerProjectsApi(config);

  const body = {
    // number (optional)
    page: 56,
  } satisfies ListProjectsRequest;

  try {
    const data = await api.listProjects(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **page** | `number` |  | [Optional] [Defaults to `undefined`] |

### Return type

[**ProjectPageResponse**](ProjectPageResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized Project procurement result. |  -  |
| **401** | Authentication required. |  -  |
| **403** | Current Buyer authorization required. |  -  |
| **404** | No owned resource or current candidate. |  -  |
| **409** | Stale version, expired estimate, source change or already selected Vendor; no mutation. |  -  |
| **422** | Validation, fulfillment review or written budget override required. |  -  |
| **503** | Provider unavailable; retry without fabricated values. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## listWorkPackageLineAlternatives

> WorkPackageAlternativePageResponse listWorkPackageLineAlternatives(packageId, lineId, arrangementId, replace, page, excludeVendorId, candidateId, specificationChoices, fulfillmentMethod)



Eligible Item-Based offers for the same canonical material and unit within the fixed 50 km Project-Based radius of the package site, for buying a missing line separately. Ranked by specification match, whether the store covers the quantity, whether it can serve the package\&#39;s fulfillment method, total price, then distance. Unlisted lines return status UNLISTED with no items; a line already covered returns COVERED; no suitable store returns NO_SUITABLE_ALTERNATIVE with the reasons in &#x60;excluded&#x60;.

### Example

```ts
import {
  Configuration,
  BuyerProjectsApi,
} from '@materyalph/api-client-ts';
import type { ListWorkPackageLineAlternativesRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerProjectsApi(config);

  const body = {
    // string
    packageId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    lineId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string (optional)
    arrangementId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // boolean (optional)
    replace: true,
    // number (optional)
    page: 56,
    // string (optional)
    excludeVendorId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string | The compared Vendor candidate. The quantity to source becomes that Vendor\'s gap less the separate purchases that satisfy the line, and the Vendor itself is left out. (optional)
    candidateId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string | JSON array of {line_id, option_id} choices. Sizes the recommendation from the same selected specifications as quotation review. (optional)
    specificationChoices: specificationChoices_example,
    // 'DELIVERY' | 'PICKUP' | Concrete method chosen on quotation review; suggestions must support it. (optional)
    fulfillmentMethod: fulfillmentMethod_example,
  } satisfies ListWorkPackageLineAlternativesRequest;

  try {
    const data = await api.listWorkPackageLineAlternatives(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **packageId** | `string` |  | [Defaults to `undefined`] |
| **lineId** | `string` |  | [Defaults to `undefined`] |
| **arrangementId** | `string` |  | [Optional] [Defaults to `undefined`] |
| **replace** | `boolean` |  | [Optional] [Defaults to `undefined`] |
| **page** | `number` |  | [Optional] [Defaults to `undefined`] |
| **excludeVendorId** | `string` |  | [Optional] [Defaults to `undefined`] |
| **candidateId** | `string` | The compared Vendor candidate. The quantity to source becomes that Vendor\&#39;s gap less the separate purchases that satisfy the line, and the Vendor itself is left out. | [Optional] [Defaults to `undefined`] |
| **specificationChoices** | `string` | JSON array of {line_id, option_id} choices. Sizes the recommendation from the same selected specifications as quotation review. | [Optional] [Defaults to `undefined`] |
| **fulfillmentMethod** | `DELIVERY`, `PICKUP` | Concrete method chosen on quotation review; suggestions must support it. | [Optional] [Defaults to `undefined`] [Enum: DELIVERY, PICKUP] |

### Return type

[**WorkPackageAlternativePageResponse**](WorkPackageAlternativePageResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Item-Based offers within the fixed 50 km Project-Based radius, ranked by specification match, availability, fulfillment capability, total price and distance. |  -  |
| **401** | Authentication required. |  -  |
| **403** | Current Buyer authorization required. |  -  |
| **404** | No owned resource or current candidate. |  -  |
| **409** | Stale version, expired estimate, source change or already selected Vendor; no mutation. |  -  |
| **422** | Validation failed. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## previewProjectSpecificationSelection

> ProjectCandidateResponse previewProjectSpecificationSelection(packageId, candidateId, projectSelectionPreview)



Re-price a fresh candidate with the Buyer\&#39;s specification choices (lines, totals, delivery estimate, score and budget label). Exact-match defaults for missing materials are saved to the draft arrangement; explicit removals and manual replacements are preserved. No regular cart, order or payment is created. Send the same selections when selecting or inquiring. An unknown option is SPECIFICATION_OPTION_INVALID.

### Example

```ts
import {
  Configuration,
  BuyerProjectsApi,
} from '@materyalph/api-client-ts';
import type { PreviewProjectSpecificationSelectionRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerProjectsApi(config);

  const body = {
    // string
    packageId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    candidateId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // ProjectSelectionPreview
    projectSelectionPreview: ...,
  } satisfies PreviewProjectSpecificationSelectionRequest;

  try {
    const data = await api.previewProjectSpecificationSelection(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **packageId** | `string` |  | [Defaults to `undefined`] |
| **candidateId** | `string` |  | [Defaults to `undefined`] |
| **projectSelectionPreview** | [ProjectSelectionPreview](ProjectSelectionPreview.md) |  | |

### Return type

[**ProjectCandidateResponse**](ProjectCandidateResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | The candidate with the choices applied. |  -  |
| **401** | Authentication required. |  -  |
| **403** | Current Buyer authorization required. |  -  |
| **404** | No owned resource or current candidate. |  -  |
| **409** | Expired estimate or source change; refresh the estimate. |  -  |
| **422** | Validation or an option that is not offered for the line. |  -  |
| **503** | Provider unavailable; retry without fabricated values. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## previewWorkPackageCsv

> ProjectImportPreviewResponse previewWorkPackageCsv(projectImportRequest)



Validate at most 100 CSV lines without saving. Header: material_code,name,unit_code,quantity,preferred_brand,specifications.

### Example

```ts
import {
  Configuration,
  BuyerProjectsApi,
} from '@materyalph/api-client-ts';
import type { PreviewWorkPackageCsvRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerProjectsApi(config);

  const body = {
    // ProjectImportRequest
    projectImportRequest: ...,
  } satisfies PreviewWorkPackageCsvRequest;

  try {
    const data = await api.previewWorkPackageCsv(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **projectImportRequest** | [ProjectImportRequest](ProjectImportRequest.md) |  | |

### Return type

[**ProjectImportPreviewResponse**](ProjectImportPreviewResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized Project procurement result. |  -  |
| **401** | Authentication required. |  -  |
| **403** | Current Buyer authorization required. |  -  |
| **404** | No owned resource or current candidate. |  -  |
| **409** | Stale version, expired estimate, source change or already selected Vendor; no mutation. |  -  |
| **422** | Validation, fulfillment review or written budget override required. |  -  |
| **503** | Provider unavailable; retry without fabricated values. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## reactivateWorkPackage

> WorkPackageViewResponse reactivateWorkPackage(packageId, idempotencyKey, projectVersionRequest)



Reactivate the same owned Cancelled Work Package after current version, open-order and Project budget checks. Cancelled, declined and expired orders do not keep the old Vendor selection locked. A cancelled order original is retained internally and the reactivated package uses fresh requirement identities, estimates and inquiries; no order is reopened or duplicated.

### Example

```ts
import {
  Configuration,
  BuyerProjectsApi,
} from '@materyalph/api-client-ts';
import type { ReactivateWorkPackageRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerProjectsApi(config);

  const body = {
    // string
    packageId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    idempotencyKey: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // ProjectVersionRequest
    projectVersionRequest: ...,
  } satisfies ReactivateWorkPackageRequest;

  try {
    const data = await api.reactivateWorkPackage(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **packageId** | `string` |  | [Defaults to `undefined`] |
| **idempotencyKey** | `string` |  | [Defaults to `undefined`] |
| **projectVersionRequest** | [ProjectVersionRequest](ProjectVersionRequest.md) |  | |

### Return type

[**WorkPackageViewResponse**](WorkPackageViewResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized Project procurement result. |  -  |
| **401** | Authentication required. |  -  |
| **403** | Current Buyer authorization required. |  -  |
| **404** | No owned package. |  -  |
| **409** | PROJECT_VERSION_CONFLICT, WORK_PACKAGE_NOT_CANCELLED, WORK_PACKAGE_HAS_ORDER, PROJECT_CLOSED or IDEMPOTENCY_CONFLICT; no mutation. |  -  |
| **422** | WORK_PACKAGE_BUDGET_EXCEEDS_PROJECT; no mutation. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## removeProjectDraftItem

> ChatIdResponse removeProjectDraftItem(packageId, candidateId, lineId, variantId, projectVersionRequest)



Remove an unsubmitted supplementary selection, preserving the requirement and restoring remaining fulfillment on the next preview. Submitted orders retain existing cancellation rules.

### Example

```ts
import {
  Configuration,
  BuyerProjectsApi,
} from '@materyalph/api-client-ts';
import type { RemoveProjectDraftItemRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerProjectsApi(config);

  const body = {
    // string
    packageId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    candidateId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    lineId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    variantId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // ProjectVersionRequest
    projectVersionRequest: ...,
  } satisfies RemoveProjectDraftItemRequest;

  try {
    const data = await api.removeProjectDraftItem(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **packageId** | `string` |  | [Defaults to `undefined`] |
| **candidateId** | `string` |  | [Defaults to `undefined`] |
| **lineId** | `string` |  | [Defaults to `undefined`] |
| **variantId** | `string` |  | [Defaults to `undefined`] |
| **projectVersionRequest** | [ProjectVersionRequest](ProjectVersionRequest.md) |  | |

### Return type

[**ChatIdResponse**](ChatIdResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Applied successfully. |  -  |
| **401** | Authentication required. |  -  |
| **403** | Current Buyer authorization required. |  -  |
| **404** | No owned resource or matching candidate. |  -  |
| **409** | Work Package, draft, price, stock or estimate changed; review again. |  -  |
| **422** | Validation, payment, budget or fulfillment choice needs attention. |  -  |
| **503** | Delivery provider unavailable; retry. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## requestProjectDraftSupplier

> ChatIdResponse requestProjectDraftSupplier(packageId, candidateId, vendorId, idempotencyKey, projectDraftSupplierRequest)



Explicit request to ONE supplementary supplier after the primary Project-Based request exists. Revalidate the reviewed fingerprint, prices, eligibility, fulfillment, payment, ownership and budgets. Create a separate linked Item-Based order awaiting manual Vendor confirmation; never touch the regular cart, auto-accept an order, request other suppliers or start payment.

### Example

```ts
import {
  Configuration,
  BuyerProjectsApi,
} from '@materyalph/api-client-ts';
import type { RequestProjectDraftSupplierRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerProjectsApi(config);

  const body = {
    // string
    packageId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    candidateId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    vendorId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    idempotencyKey: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // ProjectDraftSupplierRequest
    projectDraftSupplierRequest: ...,
  } satisfies RequestProjectDraftSupplierRequest;

  try {
    const data = await api.requestProjectDraftSupplier(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **packageId** | `string` |  | [Defaults to `undefined`] |
| **candidateId** | `string` |  | [Defaults to `undefined`] |
| **vendorId** | `string` |  | [Defaults to `undefined`] |
| **idempotencyKey** | `string` |  | [Defaults to `undefined`] |
| **projectDraftSupplierRequest** | [ProjectDraftSupplierRequest](ProjectDraftSupplierRequest.md) |  | |

### Return type

[**ChatIdResponse**](ChatIdResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **201** | Applied successfully. |  -  |
| **401** | Authentication required. |  -  |
| **403** | Current Buyer authorization required. |  -  |
| **404** | No owned resource or matching candidate. |  -  |
| **409** | Work Package, draft, price, stock or estimate changed; review again. |  -  |
| **422** | Validation, payment, budget or fulfillment choice needs attention. |  -  |
| **503** | Delivery provider unavailable; retry. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## resetProjectRankingPreferences

> ProjectPreferencesResponse resetProjectRankingPreferences(projectPreferenceReset)



Reset to current platform defaults with version conflict protection.

### Example

```ts
import {
  Configuration,
  BuyerProjectsApi,
} from '@materyalph/api-client-ts';
import type { ResetProjectRankingPreferencesRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerProjectsApi(config);

  const body = {
    // ProjectPreferenceReset
    projectPreferenceReset: ...,
  } satisfies ResetProjectRankingPreferencesRequest;

  try {
    const data = await api.resetProjectRankingPreferences(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **projectPreferenceReset** | [ProjectPreferenceReset](ProjectPreferenceReset.md) |  | |

### Return type

[**ProjectPreferencesResponse**](ProjectPreferencesResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized Project procurement result. |  -  |
| **401** | Authentication required. |  -  |
| **403** | Current Buyer authorization required. |  -  |
| **404** | No owned resource or current candidate. |  -  |
| **409** | Stale version, expired estimate, source change or already selected Vendor; no mutation. |  -  |
| **422** | Validation, fulfillment review or written budget override required. |  -  |
| **503** | Provider unavailable; retry without fabricated values. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## resolveProjectMissingLine

> WorkPackageViewResponse resolveProjectMissingLine(packageId, lineId, projectMissingResolve)



Link a covering owned Item-Based order or explicitly waive with a reason. Linked child orders enter budgets once.

### Example

```ts
import {
  Configuration,
  BuyerProjectsApi,
} from '@materyalph/api-client-ts';
import type { ResolveProjectMissingLineRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerProjectsApi(config);

  const body = {
    // string
    packageId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    lineId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // ProjectMissingResolve
    projectMissingResolve: ...,
  } satisfies ResolveProjectMissingLineRequest;

  try {
    const data = await api.resolveProjectMissingLine(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **packageId** | `string` |  | [Defaults to `undefined`] |
| **lineId** | `string` |  | [Defaults to `undefined`] |
| **projectMissingResolve** | [ProjectMissingResolve](ProjectMissingResolve.md) |  | |

### Return type

[**WorkPackageViewResponse**](WorkPackageViewResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized Project procurement result. |  -  |
| **401** | Authentication required. |  -  |
| **403** | Current Buyer authorization required. |  -  |
| **404** | No owned resource or current candidate. |  -  |
| **409** | Stale package, changed resolution, or no active primary Vendor request (MISSING_LINE_INACTIVE). Cancelled procurement history cannot be resolved as current work. |  -  |
| **422** | Validation, fulfillment review or written budget override required. |  -  |
| **503** | Provider unavailable; retry without fabricated values. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## saveProjectDraftItem

> ChatIdResponse saveProjectDraftItem(packageId, candidateId, lineId, variantId, projectDraftItemInput)



Add one recommendation to the Work Package draft. Server caps quantity by the remaining requirement and available stock. Idempotent PUT never stacks duplicates. No cart, order, stock reservation or payment is created.

### Example

```ts
import {
  Configuration,
  BuyerProjectsApi,
} from '@materyalph/api-client-ts';
import type { SaveProjectDraftItemRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerProjectsApi(config);

  const body = {
    // string
    packageId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    candidateId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    lineId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    variantId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // ProjectDraftItemInput
    projectDraftItemInput: ...,
  } satisfies SaveProjectDraftItemRequest;

  try {
    const data = await api.saveProjectDraftItem(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **packageId** | `string` |  | [Defaults to `undefined`] |
| **candidateId** | `string` |  | [Defaults to `undefined`] |
| **lineId** | `string` |  | [Defaults to `undefined`] |
| **variantId** | `string` |  | [Defaults to `undefined`] |
| **projectDraftItemInput** | [ProjectDraftItemInput](ProjectDraftItemInput.md) |  | |

### Return type

[**ChatIdResponse**](ChatIdResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Applied successfully. |  -  |
| **401** | Authentication required. |  -  |
| **403** | Current Buyer authorization required. |  -  |
| **404** | No owned resource or matching candidate. |  -  |
| **409** | Work Package, draft, price, stock or estimate changed; review again. |  -  |
| **422** | Validation, payment, budget or fulfillment choice needs attention. |  -  |
| **503** | Delivery provider unavailable; retry. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## saveProjectRankingPreferences

> ProjectPreferencesResponse saveProjectRankingPreferences(projectPreferenceSave)



Exactly four independent integer weights in [0,100], at least one above zero (422 WEIGHTS_ALL_ZERO). Original values are stored and restored; scoring divides each by the sum of weights. Defaults: material_match 40, budget_fit 25, distance 20, vps 15.

### Example

```ts
import {
  Configuration,
  BuyerProjectsApi,
} from '@materyalph/api-client-ts';
import type { SaveProjectRankingPreferencesRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerProjectsApi(config);

  const body = {
    // ProjectPreferenceSave
    projectPreferenceSave: ...,
  } satisfies SaveProjectRankingPreferencesRequest;

  try {
    const data = await api.saveProjectRankingPreferences(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **projectPreferenceSave** | [ProjectPreferenceSave](ProjectPreferenceSave.md) |  | |

### Return type

[**ProjectPreferencesResponse**](ProjectPreferencesResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized Project procurement result. |  -  |
| **401** | Authentication required. |  -  |
| **403** | Current Buyer authorization required. |  -  |
| **404** | No owned resource or current candidate. |  -  |
| **409** | Stale version, expired estimate, source change or already selected Vendor; no mutation. |  -  |
| **422** | Validation, fulfillment review or written budget override required. |  -  |
| **503** | Provider unavailable; retry without fabricated values. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## searchProjectMaterials

> ProjectMaterialPageResponse searchProjectMaterials(query)



Up to eight canonical material suggestions, each with compatible normalized units. Buyer must explicitly select a suggestion.

### Example

```ts
import {
  Configuration,
  BuyerProjectsApi,
} from '@materyalph/api-client-ts';
import type { SearchProjectMaterialsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerProjectsApi(config);

  const body = {
    // string
    query: query_example,
  } satisfies SearchProjectMaterialsRequest;

  try {
    const data = await api.searchProjectMaterials(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **query** | `string` |  | [Defaults to `undefined`] |

### Return type

[**ProjectMaterialPageResponse**](ProjectMaterialPageResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized Project procurement result. |  -  |
| **401** | Authentication required. |  -  |
| **403** | Current Buyer authorization required. |  -  |
| **404** | No owned resource or current candidate. |  -  |
| **409** | Stale version, expired estimate, source change or already selected Vendor; no mutation. |  -  |
| **422** | Validation, fulfillment review or written budget override required. |  -  |
| **503** | Provider unavailable; retry without fabricated values. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## selectProjectVendor

> ChatIdResponse selectProjectVendor(packageId, idempotencyKey, projectVendorSelectionRequest)



Select exactly one Vendor from a fresh estimate and expire other active quotations. Creates a manual 24-hour package request. Optional Note needs no Vendor response. No auto-accept.

### Example

```ts
import {
  Configuration,
  BuyerProjectsApi,
} from '@materyalph/api-client-ts';
import type { SelectProjectVendorRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerProjectsApi(config);

  const body = {
    // string
    packageId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    idempotencyKey: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // ProjectVendorSelectionRequest
    projectVendorSelectionRequest: ...,
  } satisfies SelectProjectVendorRequest;

  try {
    const data = await api.selectProjectVendor(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **packageId** | `string` |  | [Defaults to `undefined`] |
| **idempotencyKey** | `string` |  | [Defaults to `undefined`] |
| **projectVendorSelectionRequest** | [ProjectVendorSelectionRequest](ProjectVendorSelectionRequest.md) |  | |

### Return type

[**ChatIdResponse**](ChatIdResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **201** | Authorized Project procurement result. |  -  |
| **401** | Authentication required. |  -  |
| **403** | Current Buyer authorization required. |  -  |
| **404** | No owned resource or current candidate. |  -  |
| **409** | Stale version, expired estimate, source change or already selected Vendor; no mutation. |  -  |
| **422** | Validation, fulfillment review or written budget override required. |  -  |
| **503** | Provider unavailable; retry without fabricated values. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## submitProjectArrangement

> ProjectArrangementResponse submitProjectArrangement(packageId, arrangementId, idempotencyKey, projectArrangementSubmit)



### Example

```ts
import {
  Configuration,
  BuyerProjectsApi,
} from '@materyalph/api-client-ts';
import type { SubmitProjectArrangementRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerProjectsApi(config);

  const body = {
    // string
    packageId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    arrangementId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    idempotencyKey: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // ProjectArrangementSubmit
    projectArrangementSubmit: ...,
  } satisfies SubmitProjectArrangementRequest;

  try {
    const data = await api.submitProjectArrangement(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **packageId** | `string` |  | [Defaults to `undefined`] |
| **arrangementId** | `string` |  | [Defaults to `undefined`] |
| **idempotencyKey** | `string` |  | [Defaults to `undefined`] |
| **projectArrangementSubmit** | [ProjectArrangementSubmit](ProjectArrangementSubmit.md) |  | |

### Return type

[**ProjectArrangementResponse**](ProjectArrangementResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **201** | Saved successfully. |  -  |
| **401** | Authentication required. |  -  |
| **403** | Current Buyer authorization required. |  -  |
| **404** | Owned Work Package or current arrangement not found. |  -  |
| **409** | Arrangement, inventory, price or version changed; refresh. |  -  |
| **422** | Review specifications, fulfillment, payment or budget. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## updateProject

> ProjectViewResponse updateProject(projectId, idempotencyKey, projectUpdate)



Edit before procurement history; complete/archive afterward. A site never replaces an accepted destination.

### Example

```ts
import {
  Configuration,
  BuyerProjectsApi,
} from '@materyalph/api-client-ts';
import type { UpdateProjectRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerProjectsApi(config);

  const body = {
    // string
    projectId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    idempotencyKey: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // ProjectUpdate
    projectUpdate: ...,
  } satisfies UpdateProjectRequest;

  try {
    const data = await api.updateProject(body);
    console.log(data);
  } catch (error) {
    console.error(error);
  }
}

// Run the test
example().catch(console.error);
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **projectId** | `string` |  | [Defaults to `undefined`] |
| **idempotencyKey** | `string` |  | [Defaults to `undefined`] |
| **projectUpdate** | [ProjectUpdate](ProjectUpdate.md) |  | |

### Return type

[**ProjectViewResponse**](ProjectViewResponse.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized Project procurement result. |  -  |
| **401** | Authentication required. |  -  |
| **403** | Current Buyer authorization required. |  -  |
| **404** | No owned resource or current candidate. |  -  |
| **409** | Stale version, expired estimate, source change or already selected Vendor; no mutation. |  -  |
| **422** | Validation, fulfillment review or written budget override required. |  -  |
| **503** | Provider unavailable; retry without fabricated values. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

