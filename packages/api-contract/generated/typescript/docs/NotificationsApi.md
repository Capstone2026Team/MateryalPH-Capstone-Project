# NotificationsApi

All URIs are relative to */api/v1*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**getNotificationPreferences**](NotificationsApi.md#getnotificationpreferences) | **GET** /{audience}/notifications/preferences | get Notification Preferences |
| [**listNotificationFailures**](NotificationsApi.md#listnotificationfailures) | **GET** /admin/notifications/failures | list Notification Failures |
| [**listNotifications**](NotificationsApi.md#listnotifications) | **GET** /{audience}/notifications | list Notifications |
| [**readNotification**](NotificationsApi.md#readnotification) | **POST** /{audience}/notifications/{noticeId}/read | read Notification |
| [**registerNotificationDevice**](NotificationsApi.md#registernotificationdevice) | **POST** /{audience}/notifications/devices | register Notification Device |
| [**resolveNotification**](NotificationsApi.md#resolvenotification) | **POST** /{audience}/notifications/{noticeId}/resolve | resolve Notification |
| [**revokeNotificationDevice**](NotificationsApi.md#revokenotificationdevice) | **DELETE** /{audience}/notifications/devices/{deviceId} | revoke Notification Device |
| [**updateNotificationPreference**](NotificationsApi.md#updatenotificationpreference) | **PUT** /{audience}/notifications/preferences | update Notification Preference |



## getNotificationPreferences

> GetNotificationPreferences200Response getNotificationPreferences(audience)

get Notification Preferences



### Example

```ts
import {
  Configuration,
  NotificationsApi,
} from '@materyalph/api-client-ts';
import type { GetNotificationPreferencesRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new NotificationsApi(config);

  const body = {
    // 'buyers' | 'vendor' | 'admin' | Authenticated surface. The server rejects mismatched account types.
    audience: audience_example,
  } satisfies GetNotificationPreferencesRequest;

  try {
    const data = await api.getNotificationPreferences(body);
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
| **audience** | `buyers`, `vendor`, `admin` | Authenticated surface. The server rejects mismatched account types. | [Defaults to `undefined`] [Enum: buyers, vendor, admin] |

### Return type

[**GetNotificationPreferences200Response**](GetNotificationPreferences200Response.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Success |  -  |
| **401** | Structured error; see errors[0].code and correlation ID. |  -  |
| **403** | Structured error; see errors[0].code and correlation ID. |  -  |
| **409** | Structured error; see errors[0].code and correlation ID. |  -  |
| **410** | Structured error; see errors[0].code and correlation ID. |  -  |
| **422** | Structured error; see errors[0].code and correlation ID. |  -  |
| **503** | Structured error; see errors[0].code and correlation ID. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## listNotificationFailures

> ListNotificationFailures200Response listNotificationFailures(page)

list Notification Failures



### Example

```ts
import {
  Configuration,
  NotificationsApi,
} from '@materyalph/api-client-ts';
import type { ListNotificationFailuresRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new NotificationsApi(config);

  const body = {
    // number (optional)
    page: 56,
  } satisfies ListNotificationFailuresRequest;

  try {
    const data = await api.listNotificationFailures(body);
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

[**ListNotificationFailures200Response**](ListNotificationFailures200Response.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Success |  -  |
| **401** | Structured error; see errors[0].code and correlation ID. |  -  |
| **403** | Structured error; see errors[0].code and correlation ID. |  -  |
| **409** | Structured error; see errors[0].code and correlation ID. |  -  |
| **410** | Structured error; see errors[0].code and correlation ID. |  -  |
| **422** | Structured error; see errors[0].code and correlation ID. |  -  |
| **503** | Structured error; see errors[0].code and correlation ID. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## listNotifications

> ListNotifications200Response listNotifications(audience, cursor)

list Notifications

Cursor feed filtered by current membership, role, assignment and preferences. Authoritative records precede delivery.

### Example

```ts
import {
  Configuration,
  NotificationsApi,
} from '@materyalph/api-client-ts';
import type { ListNotificationsRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new NotificationsApi(config);

  const body = {
    // 'buyers' | 'vendor' | 'admin' | Authenticated surface. The server rejects mismatched account types.
    audience: audience_example,
    // string (optional)
    cursor: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies ListNotificationsRequest;

  try {
    const data = await api.listNotifications(body);
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
| **audience** | `buyers`, `vendor`, `admin` | Authenticated surface. The server rejects mismatched account types. | [Defaults to `undefined`] [Enum: buyers, vendor, admin] |
| **cursor** | `string` |  | [Optional] [Defaults to `undefined`] |

### Return type

[**ListNotifications200Response**](ListNotifications200Response.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Success |  -  |
| **401** | Structured error; see errors[0].code and correlation ID. |  -  |
| **403** | Structured error; see errors[0].code and correlation ID. |  -  |
| **409** | Structured error; see errors[0].code and correlation ID. |  -  |
| **410** | Structured error; see errors[0].code and correlation ID. |  -  |
| **422** | Structured error; see errors[0].code and correlation ID. |  -  |
| **503** | Structured error; see errors[0].code and correlation ID. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## readNotification

> RevokeNotificationDevice200Response readNotification(audience, noticeId)

read Notification



### Example

```ts
import {
  Configuration,
  NotificationsApi,
} from '@materyalph/api-client-ts';
import type { ReadNotificationRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new NotificationsApi(config);

  const body = {
    // 'buyers' | 'vendor' | 'admin' | Authenticated surface. The server rejects mismatched account types.
    audience: audience_example,
    // string
    noticeId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies ReadNotificationRequest;

  try {
    const data = await api.readNotification(body);
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
| **audience** | `buyers`, `vendor`, `admin` | Authenticated surface. The server rejects mismatched account types. | [Defaults to `undefined`] [Enum: buyers, vendor, admin] |
| **noticeId** | `string` |  | [Defaults to `undefined`] |

### Return type

[**RevokeNotificationDevice200Response**](RevokeNotificationDevice200Response.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Success |  -  |
| **401** | Structured error; see errors[0].code and correlation ID. |  -  |
| **403** | Structured error; see errors[0].code and correlation ID. |  -  |
| **409** | Structured error; see errors[0].code and correlation ID. |  -  |
| **410** | Structured error; see errors[0].code and correlation ID. |  -  |
| **422** | Structured error; see errors[0].code and correlation ID. |  -  |
| **503** | Structured error; see errors[0].code and correlation ID. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## registerNotificationDevice

> RegisterNotificationDevice201Response registerNotificationDevice(audience, notificationDeviceInput)

register Notification Device

Encrypted session-bound token registration. Web requires deployment approval. Token never returned.

### Example

```ts
import {
  Configuration,
  NotificationsApi,
} from '@materyalph/api-client-ts';
import type { RegisterNotificationDeviceRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new NotificationsApi(config);

  const body = {
    // 'buyers' | 'vendor' | 'admin' | Authenticated surface. The server rejects mismatched account types.
    audience: audience_example,
    // NotificationDeviceInput
    notificationDeviceInput: ...,
  } satisfies RegisterNotificationDeviceRequest;

  try {
    const data = await api.registerNotificationDevice(body);
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
| **audience** | `buyers`, `vendor`, `admin` | Authenticated surface. The server rejects mismatched account types. | [Defaults to `undefined`] [Enum: buyers, vendor, admin] |
| **notificationDeviceInput** | [NotificationDeviceInput](NotificationDeviceInput.md) |  | |

### Return type

[**RegisterNotificationDevice201Response**](RegisterNotificationDevice201Response.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **201** | Success |  -  |
| **401** | Structured error; see errors[0].code and correlation ID. |  -  |
| **403** | Structured error; see errors[0].code and correlation ID. |  -  |
| **409** | Structured error; see errors[0].code and correlation ID. |  -  |
| **410** | Structured error; see errors[0].code and correlation ID. |  -  |
| **422** | Structured error; see errors[0].code and correlation ID. |  -  |
| **503** | Structured error; see errors[0].code and correlation ID. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## resolveNotification

> ResolveNotification200Response resolveNotification(audience, noticeId)

resolve Notification

Fresh authenticated session and resource authorization required. Returns only an allowlisted same-application path; denied links return NOTICE_ACCESS_REVOKED.

### Example

```ts
import {
  Configuration,
  NotificationsApi,
} from '@materyalph/api-client-ts';
import type { ResolveNotificationRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new NotificationsApi(config);

  const body = {
    // 'buyers' | 'vendor' | 'admin' | Authenticated surface. The server rejects mismatched account types.
    audience: audience_example,
    // string
    noticeId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies ResolveNotificationRequest;

  try {
    const data = await api.resolveNotification(body);
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
| **audience** | `buyers`, `vendor`, `admin` | Authenticated surface. The server rejects mismatched account types. | [Defaults to `undefined`] [Enum: buyers, vendor, admin] |
| **noticeId** | `string` |  | [Defaults to `undefined`] |

### Return type

[**ResolveNotification200Response**](ResolveNotification200Response.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Success |  -  |
| **401** | Structured error; see errors[0].code and correlation ID. |  -  |
| **403** | Structured error; see errors[0].code and correlation ID. |  -  |
| **409** | Structured error; see errors[0].code and correlation ID. |  -  |
| **410** | Structured error; see errors[0].code and correlation ID. |  -  |
| **422** | Structured error; see errors[0].code and correlation ID. |  -  |
| **503** | Structured error; see errors[0].code and correlation ID. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## revokeNotificationDevice

> RevokeNotificationDevice200Response revokeNotificationDevice(audience, deviceId)

revoke Notification Device



### Example

```ts
import {
  Configuration,
  NotificationsApi,
} from '@materyalph/api-client-ts';
import type { RevokeNotificationDeviceRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new NotificationsApi(config);

  const body = {
    // 'buyers' | 'vendor' | 'admin' | Authenticated surface. The server rejects mismatched account types.
    audience: audience_example,
    // string
    deviceId: 38400000-8cf0-11bd-b23e-10b96e4ef00d,
  } satisfies RevokeNotificationDeviceRequest;

  try {
    const data = await api.revokeNotificationDevice(body);
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
| **audience** | `buyers`, `vendor`, `admin` | Authenticated surface. The server rejects mismatched account types. | [Defaults to `undefined`] [Enum: buyers, vendor, admin] |
| **deviceId** | `string` |  | [Defaults to `undefined`] |

### Return type

[**RevokeNotificationDevice200Response**](RevokeNotificationDevice200Response.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Success |  -  |
| **401** | Structured error; see errors[0].code and correlation ID. |  -  |
| **403** | Structured error; see errors[0].code and correlation ID. |  -  |
| **409** | Structured error; see errors[0].code and correlation ID. |  -  |
| **410** | Structured error; see errors[0].code and correlation ID. |  -  |
| **422** | Structured error; see errors[0].code and correlation ID. |  -  |
| **503** | Structured error; see errors[0].code and correlation ID. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## updateNotificationPreference

> GetNotificationPreferences200Response updateNotificationPreference(audience, notificationPreferenceInput)

update Notification Preference

Mandatory classes cannot be disabled. Unknown categories are rejected.

### Example

```ts
import {
  Configuration,
  NotificationsApi,
} from '@materyalph/api-client-ts';
import type { UpdateNotificationPreferenceRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new NotificationsApi(config);

  const body = {
    // 'buyers' | 'vendor' | 'admin' | Authenticated surface. The server rejects mismatched account types.
    audience: audience_example,
    // NotificationPreferenceInput
    notificationPreferenceInput: ...,
  } satisfies UpdateNotificationPreferenceRequest;

  try {
    const data = await api.updateNotificationPreference(body);
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
| **audience** | `buyers`, `vendor`, `admin` | Authenticated surface. The server rejects mismatched account types. | [Defaults to `undefined`] [Enum: buyers, vendor, admin] |
| **notificationPreferenceInput** | [NotificationPreferenceInput](NotificationPreferenceInput.md) |  | |

### Return type

[**GetNotificationPreferences200Response**](GetNotificationPreferences200Response.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Success |  -  |
| **401** | Structured error; see errors[0].code and correlation ID. |  -  |
| **403** | Structured error; see errors[0].code and correlation ID. |  -  |
| **409** | Structured error; see errors[0].code and correlation ID. |  -  |
| **410** | Structured error; see errors[0].code and correlation ID. |  -  |
| **422** | Structured error; see errors[0].code and correlation ID. |  -  |
| **503** | Structured error; see errors[0].code and correlation ID. |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)

