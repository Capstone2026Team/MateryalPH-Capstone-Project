# BuyerLocationsApi

All URIs are relative to */api/v1*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**autocompleteBuyerLocation**](BuyerLocationsApi.md#autocompletebuyerlocation) | **POST** /buyers/locations/autocomplete |  |
| [**createBuyerLocation**](BuyerLocationsApi.md#createbuyerlocation) | **POST** /buyers/locations |  |
| [**getBuyerOnboarding**](BuyerLocationsApi.md#getbuyeronboarding) | **GET** /buyers/onboarding |  |
| [**listBuyerLocations**](BuyerLocationsApi.md#listbuyerlocations) | **GET** /buyers/locations |  |
| [**listBuyerPsgcAreas**](BuyerLocationsApi.md#listbuyerpsgcareas) | **GET** /buyers/geography/areas |  |
| [**makeBuyerLocationPrimary**](BuyerLocationsApi.md#makebuyerlocationprimary) | **POST** /buyers/locations/{locationId}/primary |  |
| [**removeBuyerLocation**](BuyerLocationsApi.md#removebuyerlocation) | **DELETE** /buyers/locations/{locationId} |  |
| [**resolveBuyerLocation**](BuyerLocationsApi.md#resolvebuyerlocation) | **POST** /buyers/locations/resolve |  |
| [**saveBuyerOnboarding**](BuyerLocationsApi.md#savebuyeronboarding) | **PUT** /buyers/onboarding |  |
| [**updateBuyerLocation**](BuyerLocationsApi.md#updatebuyerlocation) | **PATCH** /buyers/locations/{locationId} |  |



## autocompleteBuyerLocation

> LocationSuggestionEnvelope autocompleteBuyerLocation(locationAutocompleteRequest)



Up to five Google Places suggestions restricted to the Philippines. Query travels in the body; no content is persisted. Reuse the session token when resolving the selected Place ID.

### Example

```ts
import {
  Configuration,
  BuyerLocationsApi,
} from '@materyalph/api-client-ts';
import type { AutocompleteBuyerLocationRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerLocationsApi(config);

  const body = {
    // LocationAutocompleteRequest
    locationAutocompleteRequest: ...,
  } satisfies AutocompleteBuyerLocationRequest;

  try {
    const data = await api.autocompleteBuyerLocation(body);
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
| **locationAutocompleteRequest** | [LocationAutocompleteRequest](LocationAutocompleteRequest.md) |  | |

### Return type

[**LocationSuggestionEnvelope**](LocationSuggestionEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Attributed Google Places suggestions. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **429** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **503** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## createBuyerLocation

> BuyerLocationEnvelope createBuyerLocation(idempotencyKey, buyerLocationCreate)



Saves a location from a resolution_token issued to this Buyer within 30 minutes. The first location becomes primary. When the address provider was unavailable, address_line is required (ADDRESS_DESCRIPTION_REQUIRED). Retrying with the same Idempotency-Key returns the same location.

### Example

```ts
import {
  Configuration,
  BuyerLocationsApi,
} from '@materyalph/api-client-ts';
import type { CreateBuyerLocationRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerLocationsApi(config);

  const body = {
    // string
    idempotencyKey: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // BuyerLocationCreate
    buyerLocationCreate: ...,
  } satisfies CreateBuyerLocationRequest;

  try {
    const data = await api.createBuyerLocation(body);
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
| **buyerLocationCreate** | [BuyerLocationCreate](BuyerLocationCreate.md) |  | |

### Return type

[**BuyerLocationEnvelope**](BuyerLocationEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **201** | Saved location. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **409** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getBuyerOnboarding

> BuyerOnboardingEnvelope getBuyerOnboarding()



Optional Buyer profile onboarding snapshot with the approved industry list, active material categories and the saved discovery radius. Skipping never blocks the account.

### Example

```ts
import {
  Configuration,
  BuyerLocationsApi,
} from '@materyalph/api-client-ts';
import type { GetBuyerOnboardingRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerLocationsApi(config);

  try {
    const data = await api.getBuyerOnboarding();
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

[**BuyerOnboardingEnvelope**](BuyerOnboardingEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Onboarding snapshot. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **409** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## listBuyerLocations

> BuyerLocationListEnvelope listBuyerLocations()



The Buyer\&#39;s own active saved locations, primary first. Coordinates, contacts and site instructions are returned only to their owner.

### Example

```ts
import {
  Configuration,
  BuyerLocationsApi,
} from '@materyalph/api-client-ts';
import type { ListBuyerLocationsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerLocationsApi(config);

  try {
    const data = await api.listBuyerLocations();
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

[**BuyerLocationListEnvelope**](BuyerLocationListEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Saved locations (bounded to 20). |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## listBuyerPsgcAreas

> PsgcAreaListEnvelope listBuyerPsgcAreas(level, parentCode, q, page)



Paginated PSGC area picker from the ACTIVE imported version. PROVINCE returns provinces plus independent cities directly under a region. Returns an empty list with status NO_ACTIVE_PSGC_VERSION when nothing is imported.

### Example

```ts
import {
  Configuration,
  BuyerLocationsApi,
} from '@materyalph/api-client-ts';
import type { ListBuyerPsgcAreasRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerLocationsApi(config);

  const body = {
    // 'REGION' | 'PROVINCE' | 'CITY' | 'BARANGAY'
    level: level_example,
    // string (optional)
    parentCode: parentCode_example,
    // string (optional)
    q: q_example,
    // number (optional)
    page: 56,
  } satisfies ListBuyerPsgcAreasRequest;

  try {
    const data = await api.listBuyerPsgcAreas(body);
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
| **level** | `REGION`, `PROVINCE`, `CITY`, `BARANGAY` |  | [Defaults to `undefined`] [Enum: REGION, PROVINCE, CITY, BARANGAY] |
| **parentCode** | `string` |  | [Optional] [Defaults to `undefined`] |
| **q** | `string` |  | [Optional] [Defaults to `undefined`] |
| **page** | `number` |  | [Optional] [Defaults to `undefined`] |

### Return type

[**PsgcAreaListEnvelope**](PsgcAreaListEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | PSGC areas. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## makeBuyerLocationPrimary

> BuyerLocationEnvelope makeBuyerLocationPrimary(locationId, lockVersionRequest)



Makes this location the single primary location.

### Example

```ts
import {
  Configuration,
  BuyerLocationsApi,
} from '@materyalph/api-client-ts';
import type { MakeBuyerLocationPrimaryRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerLocationsApi(config);

  const body = {
    // string
    locationId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // LockVersionRequest
    lockVersionRequest: ...,
  } satisfies MakeBuyerLocationPrimaryRequest;

  try {
    const data = await api.makeBuyerLocationPrimary(body);
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
| **locationId** | `string` |  | [Defaults to `undefined`] |
| **lockVersionRequest** | [LockVersionRequest](LockVersionRequest.md) |  | |

### Return type

[**BuyerLocationEnvelope**](BuyerLocationEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Primary location. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **404** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **409** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## removeBuyerLocation

> BuyerLocationRemovedEnvelope removeBuyerLocation(lockVersion, locationId)



Archives a saved location. The primary location cannot be removed while other locations exist (409 PRIMARY_LOCATION_REQUIRED).

### Example

```ts
import {
  Configuration,
  BuyerLocationsApi,
} from '@materyalph/api-client-ts';
import type { RemoveBuyerLocationRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerLocationsApi(config);

  const body = {
    // number
    lockVersion: 56,
    // string
    locationId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies RemoveBuyerLocationRequest;

  try {
    const data = await api.removeBuyerLocation(body);
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
| **lockVersion** | `number` |  | [Defaults to `undefined`] |
| **locationId** | `string` |  | [Defaults to `undefined`] |

### Return type

[**BuyerLocationRemovedEnvelope**](BuyerLocationRemovedEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Location removed. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **404** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **409** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## resolveBuyerLocation

> BuyerLocationPreviewEnvelope resolveBuyerLocation(buyerLocationResolveRequest)



Resolves a dropped pin, an explicitly granted device point or a typed Philippine address into a reviewable preview with the best resolved versioned PSGC codes. Nothing is stored. GPS is optional; PIN and ADDRESS are complete alternatives. Pin resolution degrades to coordinates only when the address provider is unavailable; ADDRESS returns 503 ADDRESS_PROVIDER_UNAVAILABLE so the Buyer can drop a pin instead.

### Example

```ts
import {
  Configuration,
  BuyerLocationsApi,
} from '@materyalph/api-client-ts';
import type { ResolveBuyerLocationRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerLocationsApi(config);

  const body = {
    // BuyerLocationResolveRequest
    buyerLocationResolveRequest: ...,
  } satisfies ResolveBuyerLocationRequest;

  try {
    const data = await api.resolveBuyerLocation(body);
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
| **buyerLocationResolveRequest** | [BuyerLocationResolveRequest](BuyerLocationResolveRequest.md) |  | |

### Return type

[**BuyerLocationPreviewEnvelope**](BuyerLocationPreviewEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Location preview. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **429** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **503** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## saveBuyerOnboarding

> BuyerOnboardingEnvelope saveBuyerOnboarding(buyerOnboardingUpdate)



Saves, completes or skips optional onboarding with optimistic concurrency. OTHER requires industry_other_label. A stale lock_version returns 409 ONBOARDING_VERSION_CONFLICT.

### Example

```ts
import {
  Configuration,
  BuyerLocationsApi,
} from '@materyalph/api-client-ts';
import type { SaveBuyerOnboardingRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerLocationsApi(config);

  const body = {
    // BuyerOnboardingUpdate
    buyerOnboardingUpdate: ...,
  } satisfies SaveBuyerOnboardingRequest;

  try {
    const data = await api.saveBuyerOnboarding(body);
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
| **buyerOnboardingUpdate** | [BuyerOnboardingUpdate](BuyerOnboardingUpdate.md) |  | |

### Return type

[**BuyerOnboardingEnvelope**](BuyerOnboardingEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Updated onboarding snapshot. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **409** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## updateBuyerLocation

> BuyerLocationEnvelope updateBuyerLocation(locationId, buyerLocationUpdate)



Updates details with optimistic concurrency. A new resolution_token appends a new address version; earlier versions stay intact for snapshots. Another Buyer\&#39;s location returns 404.

### Example

```ts
import {
  Configuration,
  BuyerLocationsApi,
} from '@materyalph/api-client-ts';
import type { UpdateBuyerLocationRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new BuyerLocationsApi(config);

  const body = {
    // string
    locationId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
    // BuyerLocationUpdate
    buyerLocationUpdate: ...,
  } satisfies UpdateBuyerLocationRequest;

  try {
    const data = await api.updateBuyerLocation(body);
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
| **locationId** | `string` |  | [Defaults to `undefined`] |
| **buyerLocationUpdate** | [BuyerLocationUpdate](BuyerLocationUpdate.md) |  | |

### Return type

[**BuyerLocationEnvelope**](BuyerLocationEnvelope.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Updated location. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **404** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **409** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For middleware rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Document and media uploads share a 20/minute user and organization limit within the overall 60/minute account limit; security-action limits remain unchanged. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

