# StoresApi

All URIs are relative to */api/v1*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**getPublicStoreProfile**](StoresApi.md#getpublicstoreprofile) | **GET** /stores/{storeId}/profile |  |
| [**listPublicStores**](StoresApi.md#listpublicstores) | **GET** /stores |  |



## getPublicStoreProfile

> PublicStoreProfileEnvelope getPublicStoreProfile(storeId)



Public Store Profile for an active, completed store. Weekly Store Operation is canonical; an explicit date override takes precedence for effective_today in Asia/Manila. The schedule is informational and does not prove live availability.

### Example

```ts
import {
  Configuration,
  StoresApi,
} from '@materyalph/api-client-ts';
import type { GetPublicStoreProfileRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const api = new StoresApi();

  const body = {
    // string
    storeId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies GetPublicStoreProfileRequest;

  try {
    const data = await api.getPublicStoreProfile(body);
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
| **storeId** | `string` |  | [Defaults to `undefined`] |

### Return type

[**PublicStoreProfileEnvelope**](PublicStoreProfileEnvelope.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Public Store Profile. |  -  |
| **404** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## listPublicStores

> PublicStoreListEnvelope listPublicStores(page)



Paginated publicly discoverable active stores. Does not expose inventory or private Vendor data.

### Example

```ts
import {
  Configuration,
  StoresApi,
} from '@materyalph/api-client-ts';
import type { ListPublicStoresRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const api = new StoresApi();

  const body = {
    // number (optional)
    page: 56,
  } satisfies ListPublicStoresRequest;

  try {
    const data = await api.listPublicStores(body);
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

[**PublicStoreListEnvelope**](PublicStoreListEnvelope.md)

### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Discoverable stores. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

