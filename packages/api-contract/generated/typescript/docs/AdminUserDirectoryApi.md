# AdminUserDirectoryApi

All URIs are relative to */api/v1*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**getDirectoryBuyer**](AdminUserDirectoryApi.md#getdirectorybuyer) | **GET** /admin/buyers/{buyerId} |  |
| [**getDirectoryVendor**](AdminUserDirectoryApi.md#getdirectoryvendor) | **GET** /admin/vendors/{vendorId} |  |
| [**listDirectoryBuyerReviews**](AdminUserDirectoryApi.md#listdirectorybuyerreviews) | **GET** /admin/buyers/{buyerId}/reviews |  |
| [**listDirectoryBuyers**](AdminUserDirectoryApi.md#listdirectorybuyers) | **GET** /admin/buyers |  |
| [**listDirectoryVendorListings**](AdminUserDirectoryApi.md#listdirectoryvendorlistings) | **GET** /admin/vendors/{vendorId}/listings |  |
| [**listDirectoryVendorReviews**](AdminUserDirectoryApi.md#listdirectoryvendorreviews) | **GET** /admin/vendors/{vendorId}/reviews |  |
| [**listDirectoryVendors**](AdminUserDirectoryApi.md#listdirectoryvendors) | **GET** /admin/vendors |  |



## getDirectoryBuyer

> DirectoryBuyerEnvelope getDirectoryBuyer(buyerId)



user_directory.view. Buyer profile with contact details, ratings, activity and recent orders. Opening a profile is audited; a self-deleted Buyer\&#39;s email is masked and mobile omitted.

### Example

```ts
import {
  Configuration,
  AdminUserDirectoryApi,
} from '@materyalph/api-client-ts';
import type { GetDirectoryBuyerRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AdminUserDirectoryApi(config);

  const body = {
    // string
    buyerId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies GetDirectoryBuyerRequest;

  try {
    const data = await api.getDirectoryBuyer(body);
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
| **buyerId** | `string` |  | [Defaults to `undefined`] |

### Return type

[**DirectoryBuyerEnvelope**](DirectoryBuyerEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized result. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **404** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getDirectoryVendor

> DirectoryVendorEnvelope getDirectoryVendor(vendorId)



user_directory.view. Store profile, Owner contact, ratings and activity. Opening a profile is audited. Exact inventory is never returned.

### Example

```ts
import {
  Configuration,
  AdminUserDirectoryApi,
} from '@materyalph/api-client-ts';
import type { GetDirectoryVendorRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AdminUserDirectoryApi(config);

  const body = {
    // string
    vendorId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies GetDirectoryVendorRequest;

  try {
    const data = await api.getDirectoryVendor(body);
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
| **vendorId** | `string` |  | [Defaults to `undefined`] |

### Return type

[**DirectoryVendorEnvelope**](DirectoryVendorEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized result. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **404** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## listDirectoryBuyerReviews

> DirectoryReviewListEnvelope listDirectoryBuyerReviews(buyerId, direction, page)



user_directory.view. Ratings the Buyer received from Vendors (RECEIVED) or reviews the Buyer wrote (WRITTEN). Hidden or removed text is shown only to roles with reviews.moderate.

### Example

```ts
import {
  Configuration,
  AdminUserDirectoryApi,
} from '@materyalph/api-client-ts';
import type { ListDirectoryBuyerReviewsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AdminUserDirectoryApi(config);

  const body = {
    // string
    buyerId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // 'RECEIVED' | 'WRITTEN' (optional)
    direction: direction_example,
    // number (optional)
    page: 56,
  } satisfies ListDirectoryBuyerReviewsRequest;

  try {
    const data = await api.listDirectoryBuyerReviews(body);
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
| **buyerId** | `string` |  | [Defaults to `undefined`] |
| **direction** | `RECEIVED`, `WRITTEN` |  | [Optional] [Defaults to `undefined`] [Enum: RECEIVED, WRITTEN] |
| **page** | `number` |  | [Optional] [Defaults to `undefined`] |

### Return type

[**DirectoryReviewListEnvelope**](DirectoryReviewListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized result. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **404** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## listDirectoryBuyers

> DirectoryBuyerListEnvelope listDirectoryBuyers(q, status, buyerType, sort, page, from, to)



user_directory.view (Super Admin, User Management, Support). Buyer Management → Users. Search matches name, email and company; the date range filters the join date.

### Example

```ts
import {
  Configuration,
  AdminUserDirectoryApi,
} from '@materyalph/api-client-ts';
import type { ListDirectoryBuyersRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AdminUserDirectoryApi(config);

  const body = {
    // string (optional)
    q: q_example,
    // 'ACTIVE' | 'PENDING_VERIFICATION' | 'SUSPENDED' | 'DEACTIVATED' | 'DELETED' (optional)
    status: status_example,
    // 'INDIVIDUAL' | 'BUSINESS' (optional)
    buyerType: buyerType_example,
    // 'joined_desc' | 'joined_asc' | 'name_asc' | 'name_desc' (optional)
    sort: sort_example,
    // number (optional)
    page: 56,
    // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. User created_at. (optional)
    from: 2013-10-20,
    // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. User created_at. (optional)
    to: 2013-10-20,
  } satisfies ListDirectoryBuyersRequest;

  try {
    const data = await api.listDirectoryBuyers(body);
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
| **q** | `string` |  | [Optional] [Defaults to `undefined`] |
| **status** | `ACTIVE`, `PENDING_VERIFICATION`, `SUSPENDED`, `DEACTIVATED`, `DELETED` |  | [Optional] [Defaults to `undefined`] [Enum: ACTIVE, PENDING_VERIFICATION, SUSPENDED, DEACTIVATED, DELETED] |
| **buyerType** | `INDIVIDUAL`, `BUSINESS` |  | [Optional] [Defaults to `undefined`] [Enum: INDIVIDUAL, BUSINESS] |
| **sort** | `joined_desc`, `joined_asc`, `name_asc`, `name_desc` |  | [Optional] [Defaults to `undefined`] [Enum: joined_desc, joined_asc, name_asc, name_desc] |
| **page** | `number` |  | [Optional] [Defaults to `undefined`] |
| **from** | `Date` | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. User created_at. | [Optional] [Defaults to `undefined`] |
| **to** | `Date` | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. User created_at. | [Optional] [Defaults to `undefined`] |

### Return type

[**DirectoryBuyerListEnvelope**](DirectoryBuyerListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized result. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## listDirectoryVendorListings

> DirectoryListingListEnvelope listDirectoryVendorListings(vendorId, q, status, page)



user_directory.view. Basic listing facts only (image, name, price range, public stock label and status); never exact inventory.

### Example

```ts
import {
  Configuration,
  AdminUserDirectoryApi,
} from '@materyalph/api-client-ts';
import type { ListDirectoryVendorListingsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AdminUserDirectoryApi(config);

  const body = {
    // string
    vendorId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // string (optional)
    q: q_example,
    // string (optional)
    status: status_example,
    // number (optional)
    page: 56,
  } satisfies ListDirectoryVendorListingsRequest;

  try {
    const data = await api.listDirectoryVendorListings(body);
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
| **vendorId** | `string` |  | [Defaults to `undefined`] |
| **q** | `string` |  | [Optional] [Defaults to `undefined`] |
| **status** | `string` |  | [Optional] [Defaults to `undefined`] |
| **page** | `number` |  | [Optional] [Defaults to `undefined`] |

### Return type

[**DirectoryListingListEnvelope**](DirectoryListingListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized result. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **404** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## listDirectoryVendorReviews

> DirectoryReviewListEnvelope listDirectoryVendorReviews(vendorId, type, page)



user_directory.view. Store reviews (VENDOR) or Product Reviews (PRODUCT) the Vendor received. Hidden or removed text is shown only to roles with reviews.moderate.

### Example

```ts
import {
  Configuration,
  AdminUserDirectoryApi,
} from '@materyalph/api-client-ts';
import type { ListDirectoryVendorReviewsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AdminUserDirectoryApi(config);

  const body = {
    // string
    vendorId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // 'VENDOR' | 'PRODUCT' (optional)
    type: type_example,
    // number (optional)
    page: 56,
  } satisfies ListDirectoryVendorReviewsRequest;

  try {
    const data = await api.listDirectoryVendorReviews(body);
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
| **vendorId** | `string` |  | [Defaults to `undefined`] |
| **type** | `VENDOR`, `PRODUCT` |  | [Optional] [Defaults to `undefined`] [Enum: VENDOR, PRODUCT] |
| **page** | `number` |  | [Optional] [Defaults to `undefined`] |

### Return type

[**DirectoryReviewListEnvelope**](DirectoryReviewListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized result. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **404** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## listDirectoryVendors

> DirectoryVendorListEnvelope listDirectoryVendors(q, status, verification, discoverability, sort, page, from, to)



user_directory.view (Super Admin, User Management, Support). Vendor Management → Users. Search matches store, legal name and Owner name or email; status is the Store Activation status.

### Example

```ts
import {
  Configuration,
  AdminUserDirectoryApi,
} from '@materyalph/api-client-ts';
import type { ListDirectoryVendorsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new AdminUserDirectoryApi(config);

  const body = {
    // string (optional)
    q: q_example,
    // 'NOT_READY' | 'READY' | 'ACTIVE' | 'RESTRICTED' | 'SUSPENDED' (optional)
    status: status_example,
    // 'NOT_STARTED' | 'IN_PROGRESS' | 'SUBMITTED' | 'PENDING_VERIFICATION' | 'APPROVED' | 'CHANGES_REQUIRED' | 'REJECTED' | 'EXPIRED' (optional)
    verification: verification_example,
    // 'DISCOVERABLE' | 'NOT_DISCOVERABLE' (optional)
    discoverability: discoverability_example,
    // 'joined_desc' | 'joined_asc' | 'name_asc' | 'name_desc' (optional)
    sort: sort_example,
    // number (optional)
    page: 56,
    // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Store created_at. (optional)
    from: 2013-10-20,
    // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Store created_at. (optional)
    to: 2013-10-20,
  } satisfies ListDirectoryVendorsRequest;

  try {
    const data = await api.listDirectoryVendors(body);
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
| **q** | `string` |  | [Optional] [Defaults to `undefined`] |
| **status** | `NOT_READY`, `READY`, `ACTIVE`, `RESTRICTED`, `SUSPENDED` |  | [Optional] [Defaults to `undefined`] [Enum: NOT_READY, READY, ACTIVE, RESTRICTED, SUSPENDED] |
| **verification** | `NOT_STARTED`, `IN_PROGRESS`, `SUBMITTED`, `PENDING_VERIFICATION`, `APPROVED`, `CHANGES_REQUIRED`, `REJECTED`, `EXPIRED` |  | [Optional] [Defaults to `undefined`] [Enum: NOT_STARTED, IN_PROGRESS, SUBMITTED, PENDING_VERIFICATION, APPROVED, CHANGES_REQUIRED, REJECTED, EXPIRED] |
| **discoverability** | `DISCOVERABLE`, `NOT_DISCOVERABLE` |  | [Optional] [Defaults to `undefined`] [Enum: DISCOVERABLE, NOT_DISCOVERABLE] |
| **sort** | `joined_desc`, `joined_asc`, `name_asc`, `name_desc` |  | [Optional] [Defaults to `undefined`] [Enum: joined_desc, joined_asc, name_asc, name_desc] |
| **page** | `number` |  | [Optional] [Defaults to `undefined`] |
| **from** | `Date` | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Store created_at. | [Optional] [Defaults to `undefined`] |
| **to** | `Date` | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Store created_at. | [Optional] [Defaults to `undefined`] |

### Return type

[**DirectoryVendorListEnvelope**](DirectoryVendorListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized result. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

