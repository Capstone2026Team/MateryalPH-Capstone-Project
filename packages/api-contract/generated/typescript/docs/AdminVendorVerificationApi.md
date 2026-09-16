# AdminVendorVerificationApi

All URIs are relative to */api/v1*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**decideVendorVerificationRequirement**](AdminVendorVerificationApi.md#decidevendorverificationrequirement) | **POST** /admin/vendor-verification/{organizationId}/requirements/{requirementKey}/decision |  |
| [**getAdminVendorEvidenceUrl**](AdminVendorVerificationApi.md#getadminvendorevidenceurl) | **GET** /admin/vendor-verification/files/{fileId} |  |
| [**getVendorVerificationCase**](AdminVendorVerificationApi.md#getvendorverificationcase) | **GET** /admin/vendor-verification/{organizationId} |  |
| [**listVendorVerificationQueue**](AdminVendorVerificationApi.md#listvendorverificationqueue) | **GET** /admin/vendor-verification |  |
| [**restoreVendorActivation**](AdminVendorVerificationApi.md#restorevendoractivation) | **POST** /admin/vendor-verification/{organizationId}/restore |  |
| [**restrictVendorActivation**](AdminVendorVerificationApi.md#restrictvendoractivation) | **POST** /admin/vendor-verification/{organizationId}/restrict |  |



## decideVendorVerificationRequirement

> AdminVendorVerificationDetailEnvelope decideVendorVerificationRequirement(organizationId, requirementKey, idempotencyKey, adminVendorVerificationDecision)



### Example

```ts
import {
  Configuration,
  AdminVendorVerificationApi,
} from '@materyalph/api-client-ts';
import type { DecideVendorVerificationRequirementRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({ 
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AdminVendorVerificationApi(config);

  const body = {
    // string
    organizationId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    requirementKey: requirementKey_example,
    // string
    idempotencyKey: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // AdminVendorVerificationDecision
    adminVendorVerificationDecision: ...,
  } satisfies DecideVendorVerificationRequirementRequest;

  try {
    const data = await api.decideVendorVerificationRequirement(body);
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
| **organizationId** | `string` |  | [Defaults to `undefined`] |
| **requirementKey** | `string` |  | [Defaults to `undefined`] |
| **idempotencyKey** | `string` |  | [Defaults to `undefined`] |
| **adminVendorVerificationDecision** | [AdminVendorVerificationDecision](AdminVendorVerificationDecision.md) |  | |

### Return type

[**AdminVendorVerificationDetailEnvelope**](AdminVendorVerificationDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Immutable review decision recorded. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  -  |
| **403** | Safe structured error with X-Correlation-ID response header. |  -  |
| **409** | Safe structured error with X-Correlation-ID response header. |  -  |
| **422** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getAdminVendorEvidenceUrl

> VendorFileEnvelope getAdminVendorEvidenceUrl(fileId)



### Example

```ts
import {
  Configuration,
  AdminVendorVerificationApi,
} from '@materyalph/api-client-ts';
import type { GetAdminVendorEvidenceUrlRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({ 
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
  });
  const api = new AdminVendorVerificationApi(config);

  const body = {
    // string
    fileId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies GetAdminVendorEvidenceUrlRequest;

  try {
    const data = await api.getAdminVendorEvidenceUrl(body);
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
| **fileId** | `string` |  | [Defaults to `undefined`] |

### Return type

[**VendorFileEnvelope**](VendorFileEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Five-minute authorized signed private-evidence URL. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  -  |
| **403** | Safe structured error with X-Correlation-ID response header. |  -  |
| **404** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getVendorVerificationCase

> AdminVendorVerificationDetailEnvelope getVendorVerificationCase(organizationId)



### Example

```ts
import {
  Configuration,
  AdminVendorVerificationApi,
} from '@materyalph/api-client-ts';
import type { GetVendorVerificationCaseRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({ 
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
  });
  const api = new AdminVendorVerificationApi(config);

  const body = {
    // string
    organizationId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies GetVendorVerificationCaseRequest;

  try {
    const data = await api.getVendorVerificationCase(body);
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
| **organizationId** | `string` |  | [Defaults to `undefined`] |

### Return type

[**AdminVendorVerificationDetailEnvelope**](AdminVendorVerificationDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized Vendor case detail with private-evidence metadata and immutable review history. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  -  |
| **403** | Safe structured error with X-Correlation-ID response header. |  -  |
| **404** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## listVendorVerificationQueue

> AdminVendorVerificationQueueEnvelope listVendorVerificationQueue(status, businessType, page)



### Example

```ts
import {
  Configuration,
  AdminVendorVerificationApi,
} from '@materyalph/api-client-ts';
import type { ListVendorVerificationQueueRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({ 
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
  });
  const api = new AdminVendorVerificationApi(config);

  const body = {
    // string (optional)
    status: status_example,
    // string (optional)
    businessType: businessType_example,
    // number (optional)
    page: 56,
  } satisfies ListVendorVerificationQueueRequest;

  try {
    const data = await api.listVendorVerificationQueue(body);
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
| **status** | `string` |  | [Optional] [Defaults to `undefined`] |
| **businessType** | `string` |  | [Optional] [Defaults to `undefined`] |
| **page** | `number` |  | [Optional] [Defaults to `undefined`] |

### Return type

[**AdminVendorVerificationQueueEnvelope**](AdminVendorVerificationQueueEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Paginated manual Store Verification queue. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  -  |
| **403** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## restoreVendorActivation

> VendorRestrictionEnvelope restoreVendorActivation(organizationId, idempotencyKey, vendorRestriction)



### Example

```ts
import {
  Configuration,
  AdminVendorVerificationApi,
} from '@materyalph/api-client-ts';
import type { RestoreVendorActivationRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({ 
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AdminVendorVerificationApi(config);

  const body = {
    // string
    organizationId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    idempotencyKey: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // VendorRestriction
    vendorRestriction: ...,
  } satisfies RestoreVendorActivationRequest;

  try {
    const data = await api.restoreVendorActivation(body);
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
| **organizationId** | `string` |  | [Defaults to `undefined`] |
| **idempotencyKey** | `string` |  | [Defaults to `undefined`] |
| **vendorRestriction** | [VendorRestriction](VendorRestriction.md) |  | |

### Return type

[**VendorRestrictionEnvelope**](VendorRestrictionEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Administrative activation restoration recorded. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  -  |
| **403** | Safe structured error with X-Correlation-ID response header. |  -  |
| **409** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## restrictVendorActivation

> VendorRestrictionEnvelope restrictVendorActivation(organizationId, idempotencyKey, vendorRestriction)



### Example

```ts
import {
  Configuration,
  AdminVendorVerificationApi,
} from '@materyalph/api-client-ts';
import type { RestrictVendorActivationRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({ 
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AdminVendorVerificationApi(config);

  const body = {
    // string
    organizationId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string
    idempotencyKey: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // VendorRestriction
    vendorRestriction: ...,
  } satisfies RestrictVendorActivationRequest;

  try {
    const data = await api.restrictVendorActivation(body);
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
| **organizationId** | `string` |  | [Defaults to `undefined`] |
| **idempotencyKey** | `string` |  | [Defaults to `undefined`] |
| **vendorRestriction** | [VendorRestriction](VendorRestriction.md) |  | |

### Return type

[**VendorRestrictionEnvelope**](VendorRestrictionEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Administrative activation restriction recorded. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  -  |
| **403** | Safe structured error with X-Correlation-ID response header. |  -  |
| **404** | Safe structured error with X-Correlation-ID response header. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

