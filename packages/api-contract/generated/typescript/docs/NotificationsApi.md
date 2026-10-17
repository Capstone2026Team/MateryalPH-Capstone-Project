# NotificationsApi

All URIs are relative to */api/v1*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**authorizeNotificationChannel**](NotificationsApi.md#authorizenotificationchannel) | **POST** /{audience}/notifications/auth |  |
| [**getNavigationUpdates**](NotificationsApi.md#getnavigationupdates) | **GET** /{audience}/navigation-updates | Authorized navigation counters for the current account |
| [**getNotificationPreferences**](NotificationsApi.md#getnotificationpreferences) | **GET** /{audience}/notifications/preferences | get Notification Preferences |
| [**getNotificationRealtime**](NotificationsApi.md#getnotificationrealtime) | **GET** /{audience}/notifications/realtime |  |
| [**getNotificationUnreadCount**](NotificationsApi.md#getnotificationunreadcount) | **GET** /{audience}/notifications/unread-count |  |
| [**getVendorNavigationUpdates**](NotificationsApi.md#getvendornavigationupdates) | **GET** /vendor/navigation-updates | Active orders and unread updates for Vendor navigation |
| [**listNotificationFailures**](NotificationsApi.md#listnotificationfailures) | **GET** /admin/notifications/failures | list Notification Failures |
| [**listNotifications**](NotificationsApi.md#listnotifications) | **GET** /{audience}/notifications | list Notifications |
| [**markNotificationsRead**](NotificationsApi.md#marknotificationsread) | **POST** /{audience}/notifications/read-all | Mark the current filtered notification view read |
| [**readNotification**](NotificationsApi.md#readnotification) | **POST** /{audience}/notifications/{noticeId}/read | read Notification |
| [**registerNotificationDevice**](NotificationsApi.md#registernotificationdevice) | **POST** /{audience}/notifications/devices | register Notification Device |
| [**resolveNotification**](NotificationsApi.md#resolvenotification) | **POST** /{audience}/notifications/{noticeId}/resolve | resolve Notification |
| [**revokeNotificationDevice**](NotificationsApi.md#revokenotificationdevice) | **DELETE** /{audience}/notifications/devices/{deviceId} | revoke Notification Device |
| [**updateNotificationPreference**](NotificationsApi.md#updatenotificationpreference) | **PUT** /{audience}/notifications/preferences | update Notification Preference |



## authorizeNotificationChannel

> NotificationChannelAuthResponse authorizeNotificationChannel(audience, chatChannelAuth)



Pusher protocol signature only for the caller\&#39;s current private-notifications channel. Foreign, stale and other domain channels are denied; current account, audience and membership are rechecked. Web requires HttpOnly cookies and CSRF; native Buyer uses bearer transport. Events carry only content-free notifications.changed and navigation.changed invalidations and never authorize REST data access.

### Example

```ts
import {
  Configuration,
  NotificationsApi,
} from '@materyalph/api-client-ts';
import type { AuthorizeNotificationChannelRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new NotificationsApi(config);

  const body = {
    // 'buyers' | 'vendor' | 'admin'
    audience: audience_example,
    // ChatChannelAuth
    chatChannelAuth: ...,
  } satisfies AuthorizeNotificationChannelRequest;

  try {
    const data = await api.authorizeNotificationChannel(body);
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
| **audience** | `buyers`, `vendor`, `admin` |  | [Defaults to `undefined`] [Enum: buyers, vendor, admin] |
| **chatChannelAuth** | [ChatChannelAuth](ChatChannelAuth.md) |  | |

### Return type

[**NotificationChannelAuthResponse**](NotificationChannelAuthResponse.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Signature for the authorized private channel. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **419** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **422** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **503** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getNavigationUpdates

> GetNavigationUpdates200Response getNavigationUpdates(audience)

Authorized navigation counters for the current account

Authoritative totals across all records, independent of list pagination. Buyer Messages counts unread received messages in the unarchived SALES inbox; Orders excludes COMPLETED, DECLINED, EXPIRED and CANCELLED; Disputes uses the existing active case states including DECIDED while remedies are pending. Buyer cart_quantity sums selected active cart quantities exactly, excludes saved-for-later lines, and retains material unit precision; cart_version prevents stale remote snapshots overwriting local cart changes. Admin sections count permission-scoped pending work, combining distinct dispute review and appeal queues. Vendor Messages counts unread received sales and fulfillment messages within current role and assignment access; the sales inbox contents remain unchanged. Realtime sends content-free navigation.changed invalidations on the current private notification channel; clients refetch after invalidation, reconnect, foreground resume and successful mutations, with REST recovery polling.

### Example

```ts
import {
  Configuration,
  NotificationsApi,
} from '@materyalph/api-client-ts';
import type { GetNavigationUpdatesRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new NotificationsApi(config);

  const body = {
    // 'buyers' | 'vendor' | 'admin'
    audience: audience_example,
  } satisfies GetNavigationUpdatesRequest;

  try {
    const data = await api.getNavigationUpdates(body);
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
| **audience** | `buyers`, `vendor`, `admin` |  | [Defaults to `undefined`] [Enum: buyers, vendor, admin] |

### Return type

[**GetNavigationUpdates200Response**](GetNavigationUpdates200Response.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Current authorized totals; zero or absent counts hide badges |  -  |
| **401** | Authentication required |  -  |
| **403** | Current account or audience access unavailable |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


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


## getNotificationRealtime

> ChatRealtimeResponse getNotificationRealtime(audience)



Current Buyer, Vendor or Admin notification invalidation channel and public Reverb connection settings. The opaque channel rotates with account or membership authority. No notice contents or backend credentials are returned. Clients re-fetch on reconnect and poll while unavailable.

### Example

```ts
import {
  Configuration,
  NotificationsApi,
} from '@materyalph/api-client-ts';
import type { GetNotificationRealtimeRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new NotificationsApi(config);

  const body = {
    // 'buyers' | 'vendor' | 'admin'
    audience: audience_example,
  } satisfies GetNotificationRealtimeRequest;

  try {
    const data = await api.getNotificationRealtime(body);
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
| **audience** | `buyers`, `vendor`, `admin` |  | [Defaults to `undefined`] [Enum: buyers, vendor, admin] |

### Return type

[**ChatRealtimeResponse**](ChatRealtimeResponse.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Current authorized private channel configuration. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getNotificationUnreadCount

> GetNotificationUnreadCount200Response getNotificationUnreadCount(audience)



Current caller\&#39;s authorized unread in-app notice count across all types. Read, foreign, revoked and disabled optional notices are excluded. Web uses HttpOnly cookies; mobile Buyer uses bearer transport.

### Example

```ts
import {
  Configuration,
  NotificationsApi,
} from '@materyalph/api-client-ts';
import type { GetNotificationUnreadCountRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // To configure API key authorization: accessCookie
    apiKey: "YOUR API KEY",
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
    // To configure API key authorization: webCsrf
    apiKey: "YOUR API KEY",
  });
  const api = new NotificationsApi(config);

  const body = {
    // 'buyers' | 'vendor' | 'admin'
    audience: audience_example,
  } satisfies GetNotificationUnreadCountRequest;

  try {
    const data = await api.getNotificationUnreadCount(body);
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
| **audience** | `buyers`, `vendor`, `admin` |  | [Defaults to `undefined`] [Enum: buyers, vendor, admin] |

### Return type

[**GetNotificationUnreadCount200Response**](GetNotificationUnreadCount200Response.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized unread badge count. |  -  |
| **401** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |
| **403** | Safe structured error with X-Correlation-ID response header. |  * Retry-After - For authentication, credential, verification and provider-webhook rate limits (429), seconds until retry is allowed. Clients must not automatically retry mutations. Everyday Buyer, Vendor and Admin requests, including uploads, have no application request-rate limit. <br>  * X-RateLimit-Limit - Maximum requests in the applicable rate-limit window. <br>  * X-RateLimit-Remaining - Requests remaining in the applicable rate-limit window. <br>  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## getVendorNavigationUpdates

> GetVendorNavigationUpdates200Response getVendorNavigationUpdates()

Active orders and unread updates for Vendor navigation

Orders counts currently visible nonterminal orders, excluding COMPLETED, DECLINED, EXPIRED and CANCELLED, independently of notification history. Team Accounts counts manageable active non-Owner memberships whose user accounts are active; deleted memberships and unaccepted invitations are excluded, and delegated Managers count only non-manager staff. Fulfillment counts visible orders at confirmed, processing or handover stages. Disputes counts currently active authorized cases. E-Invoices counts outstanding requests. Products counts unread authorized notices; Messages counts unread received messages in the current inbox. Team headcounts are retained for compatibility and are not attention badges. Store Profile has no indicator. Rechecks current membership, role, delegation, assignment and preferences. Only fixed sidebar paths and counts are returned; visiting a section does not mark updates read.

### Example

```ts
import {
  Configuration,
  NotificationsApi,
} from '@materyalph/api-client-ts';
import type { GetVendorNavigationUpdatesRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new NotificationsApi(config);

  try {
    const data = await api.getVendorNavigationUpdates();
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

[**GetVendorNavigationUpdates200Response**](GetVendorNavigationUpdates200Response.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Current section counts, including zero totals for Orders, Notifications and Messages |  -  |
| **401** | Authentication required |  -  |
| **403** | Vendor account or current membership unavailable |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#api-endpoints) [[Back to Model list]](../README.md#models) [[Back to README]](../README.md)


## listNotificationFailures

> ListNotificationFailures200Response listNotificationFailures(page, from, to)

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
    // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Failure updated_at. (optional)
    from: 2013-10-20,
    // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Failure updated_at. (optional)
    to: 2013-10-20,
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
| **from** | `Date` | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Failure updated_at. | [Optional] [Defaults to `undefined`] |
| **to** | `Date` | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Failure updated_at. | [Optional] [Defaults to `undefined`] |

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

> ListNotifications200Response listNotifications(audience, cursor, from, to)

list Notifications

Cursor feed filtered by current membership, role, assignment and preferences, newest first. Read notices are retained server-side and clients list only unread notices; no notification is deleted by reading it. Clients can assemble cursor pages for immediate local status and notification-category filters. Authoritative records precede delivery.

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
    // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Notification created_at. Resource and membership authorization still applies. (optional)
    from: 2013-10-20,
    // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Notification created_at. Resource and membership authorization still applies. (optional)
    to: 2013-10-20,
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
| **from** | `Date` | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Notification created_at. Resource and membership authorization still applies. | [Optional] [Defaults to `undefined`] |
| **to** | `Date` | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Notification created_at. Resource and membership authorization still applies. | [Optional] [Defaults to `undefined`] |

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


## markNotificationsRead

> MarkNotificationsRead200Response markNotificationsRead(audience, notificationReadFilter)

Mark the current filtered notification view read

Atomically marks the caller\&#39;s authorized unread notices at or before through_id as read, optionally matching a notification category, legacy exact display title and inclusive Asia/Manila created_at date boundaries. The captured upper bound leaves later arrivals unread. Rechecks current account, membership, role, resource access and in-app preferences. Notices and required security history are retained. Naturally idempotent; retries do not change existing read timestamps. Audits the changed count and queues a private content-free inbox invalidation after commit.

### Example

```ts
import {
  Configuration,
  NotificationsApi,
} from '@materyalph/api-client-ts';
import type { MarkNotificationsReadRequest } from '@materyalph/api-client-ts';

async function example() {
  console.log("🚀 Testing @materyalph/api-client-ts SDK...");
  const config = new Configuration({
    // Configure HTTP bearer authorization: passportBearer
    accessToken: "YOUR BEARER TOKEN",
  });
  const api = new NotificationsApi(config);

  const body = {
    // 'buyers' | 'vendor' | 'admin' | Authenticated surface. Web requests require the current HttpOnly session cookie and CSRF header.
    audience: audience_example,
    // NotificationReadFilter
    notificationReadFilter: ...,
  } satisfies MarkNotificationsReadRequest;

  try {
    const data = await api.markNotificationsRead(body);
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
| **audience** | `buyers`, `vendor`, `admin` | Authenticated surface. Web requests require the current HttpOnly session cookie and CSRF header. | [Defaults to `undefined`] [Enum: buyers, vendor, admin] |
| **notificationReadFilter** | [NotificationReadFilter](NotificationReadFilter.md) |  | |

### Return type

[**MarkNotificationsRead200Response**](MarkNotificationsRead200Response.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

- **Content-Type**: `application/json`
- **Accept**: `application/json`


### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | Authorized matching notices marked read and retained. |  -  |
| **401** | Authentication required. |  -  |
| **403** | Current account or portal access denied. |  -  |
| **419** | Missing or invalid web CSRF header. |  -  |
| **422** | Invalid captured cursor, category or legacy display-title filter. |  -  |
| **503** | Service unavailable; the transaction does not partially mark notices. |  -  |

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

Fresh authenticated session and resource authorization required. Returns only an allowlisted same-application path; denied links return NOTICE_ACCESS_REVOKED. Buyer MESSAGES notifications resolve to /messages/{conversationId} after checking current conversation access.

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

