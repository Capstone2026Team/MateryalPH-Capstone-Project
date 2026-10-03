# BuyerProjectsApi

All URIs are relative to */api/v1*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**activateWorkPackage**](BuyerProjectsApi.md#activateworkpackage) | **POST** /buyers/work-packages/{packageId}/activate |  |
| [**closeWorkPackage**](BuyerProjectsApi.md#closeworkpackage) | **POST** /buyers/work-packages/{packageId}/close |  |
| [**compileProjectEstimates**](BuyerProjectsApi.md#compileprojectestimates) | **POST** /buyers/work-packages/{packageId}/estimates |  |
| [**createProject**](BuyerProjectsApi.md#createproject) | **POST** /buyers/projects |  |
| [**createWorkPackage**](BuyerProjectsApi.md#createworkpackage) | **POST** /buyers/projects/{projectId}/work-packages |  |
| [**createWorkPackageVersion**](BuyerProjectsApi.md#createworkpackageversion) | **POST** /buyers/work-packages/{packageId}/versions |  |
| [**deleteProject**](BuyerProjectsApi.md#deleteproject) | **DELETE** /buyers/projects/{projectId} |  |
| [**deleteWorkPackage**](BuyerProjectsApi.md#deleteworkpackage) | **DELETE** /buyers/work-packages/{packageId} |  |
| [**editWorkPackage**](BuyerProjectsApi.md#editworkpackage) | **PUT** /buyers/work-packages/{packageId} |  |
| [**getProject**](BuyerProjectsApi.md#getproject) | **GET** /buyers/projects/{projectId} |  |
| [**getProjectCandidateRoute**](BuyerProjectsApi.md#getprojectcandidateroute) | **POST** /buyers/work-packages/{packageId}/candidates/{candidateId}/route |  |
| [**getProjectEstimates**](BuyerProjectsApi.md#getprojectestimates) | **GET** /buyers/work-packages/{packageId}/estimates |  |
| [**getProjectRankingPreferences**](BuyerProjectsApi.md#getprojectrankingpreferences) | **GET** /buyers/project-ranking-preferences |  |
| [**getWorkPackage**](BuyerProjectsApi.md#getworkpackage) | **GET** /buyers/work-packages/{packageId} |  |
| [**inquireProjectVendor**](BuyerProjectsApi.md#inquireprojectvendor) | **POST** /buyers/work-packages/{packageId}/inquiries |  |
| [**listProjects**](BuyerProjectsApi.md#listprojects) | **GET** /buyers/projects |  |
| [**previewWorkPackageCsv**](BuyerProjectsApi.md#previewworkpackagecsv) | **POST** /buyers/work-packages/import-preview |  |
| [**resetProjectRankingPreferences**](BuyerProjectsApi.md#resetprojectrankingpreferences) | **POST** /buyers/project-ranking-preferences/reset |  |
| [**resolveProjectMissingLine**](BuyerProjectsApi.md#resolveprojectmissingline) | **PUT** /buyers/work-packages/{packageId}/missing-lines/{lineId} |  |
| [**saveProjectRankingPreferences**](BuyerProjectsApi.md#saveprojectrankingpreferences) | **PUT** /buyers/project-ranking-preferences |  |
| [**searchProjectMaterials**](BuyerProjectsApi.md#searchprojectmaterials) | **GET** /buyers/project-materials |  |
| [**selectProjectVendor**](BuyerProjectsApi.md#selectprojectvendor) | **POST** /buyers/work-packages/{packageId}/selection |  |
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



Cancel an unassigned package, retaining every locked version. Selected work follows order cancellation rules.

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



Scan eligible Bulk Yes Tier 2 offers within the confirmed radius from the Project site. FMS uses exact normalized weights. Unknown delivery cost remains pending; schedules never change validity or score.

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


## createWorkPackage

> WorkPackageViewResponse createWorkPackage(projectId, idempotencyKey, workPackageInput)



Save a Draft. Normalized units, positive quantities, explicit site and access are validated.

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


## createWorkPackageVersion

> WorkPackageViewResponse createWorkPackageVersion(packageId, idempotencyKey, workPackageInput)



Explicit correction version invalidates estimates and expires inquiries. Selected work requires prior order cancellation.

### Example

```ts
import {
  Configuration,
  BuyerProjectsApi,
} from '@materyalph/api-client-ts';
import type { CreateWorkPackageVersionRequest } from '@materyalph/api-client-ts';

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
  } satisfies CreateWorkPackageVersionRequest;

  try {
    const data = await api.createWorkPackageVersion(body);
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



Delete only a Draft with no locked historical version. Retain activated evidence.

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


## editWorkPackage

> WorkPackageViewResponse editWorkPackage(packageId, idempotencyKey, workPackageInput)



Editable Draft only; saves an append-only draft version.

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

> ProjectEstimatePageResponse getProjectEstimates(packageId, page)



Immutable, paginated snapshots. Complete one-Vendor matches first; missing lines explicit. Expiry is exactly 48 hours.

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



Locked original, paginated version history, missing-item resolution and budget metrics. PDF generation remains Phase 15.

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
| **409** | Stale version, expired estimate, source change or already selected Vendor; no mutation. |  -  |
| **422** | Validation, fulfillment review or written budget override required. |  -  |
| **503** | Provider unavailable; retry without fabricated values. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## saveProjectRankingPreferences

> ProjectPreferencesResponse saveProjectRankingPreferences(projectPreferenceSave)



Exactly four integer weights in [0,100] totaling 100. Defaults: material_match 40, budget_fit 25, distance 20, vps 15.

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

> ChatIdResponse selectProjectVendor(packageId, idempotencyKey, projectCandidateRequest)



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
    // ProjectCandidateRequest
    projectCandidateRequest: ...,
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

