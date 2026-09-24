# AdminVendorVerificationApi

All URIs are relative to */api/v1*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**decideVendorVerificationRequirement**](AdminVendorVerificationApi.md#decidevendorverificationrequirement) | **POST** /admin/vendor-verification/{organizationId}/requirements/{requirementKey}/decision |  |
| [**getAdminDashboard**](AdminVendorVerificationApi.md#getadmindashboard) | **GET** /admin/dashboard |  |
| [**getAdminVendorEvidenceUrl**](AdminVendorVerificationApi.md#getadminvendorevidenceurl) | **GET** /admin/vendor-verification/files/{fileId} |  |
| [**getVendorVerificationCase**](AdminVendorVerificationApi.md#getvendorverificationcase) | **GET** /admin/vendor-verification/{organizationId} |  |
| [**listAdminDashboardAudit**](AdminVendorVerificationApi.md#listadmindashboardaudit) | **GET** /admin/dashboard/audit |  |
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
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **409** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getAdminDashboard

> AdminDashboardEnvelope getAdminDashboard()



### Example

```ts
import {
  Configuration,
  AdminVendorVerificationApi,
} from '@materyalph/api-client-ts';
import type { GetAdminDashboardRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
  });
  const api = new AdminVendorVerificationApi(config);

  try {
    const data = await api.getAdminDashboard();
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

[**AdminDashboardEnvelope**](AdminDashboardEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Permission-scoped platform counts. Active Buyers means ACTIVE account status; null metrics are outside role scope. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

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
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **404** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

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
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **404** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## listAdminDashboardAudit

> AdminDashboardAuditEnvelope listAdminDashboardAudit(page)



### Example

```ts
import {
  Configuration,
  AdminVendorVerificationApi,
} from '@materyalph/api-client-ts';
import type { ListAdminDashboardAuditRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
  });
  const api = new AdminVendorVerificationApi(config);

  const body = {
    // number (optional)
    page: 56,
  } satisfies ListAdminDashboardAuditRequest;

  try {
    const data = await api.listAdminDashboardAudit(body);
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

[**AdminDashboardAuditEnvelope**](AdminDashboardAuditEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Super Admin only. Paginated safe audit projection excluding private payloads and contact data. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## listVendorVerificationQueue

> AdminVendorVerificationQueueEnvelope listVendorVerificationQueue(status, businessType, regionCode, submittedFrom, submittedTo, sort, page)



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
    // string | Current PSGC region code or UNASSIGNED. Region options are included in meta.regions. (optional)
    regionCode: regionCode_example,
    // Date | Inclusive Asia/Manila submission date. (optional)
    submittedFrom: 2013-10-20,
    // Date | Inclusive Asia/Manila submission date. (optional)
    submittedTo: 2013-10-20,
    // 'submitted_asc' | 'submitted_desc' | 'location' (optional)
    sort: sort_example,
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
| **regionCode** | `string` | Current PSGC region code or UNASSIGNED. Region options are included in meta.regions. | [Optional] [Defaults to `undefined`] |
| **submittedFrom** | `Date` | Inclusive Asia/Manila submission date. | [Optional] [Defaults to `undefined`] |
| **submittedTo** | `Date` | Inclusive Asia/Manila submission date. | [Optional] [Defaults to `undefined`] |
| **sort** | `submitted_asc`, `submitted_desc`, `location` |  | [Optional] [Defaults to `&#39;submitted_desc&#39;`] [Enum: submitted_asc, submitted_desc, location] |
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
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

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
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **409** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

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
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **404** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

