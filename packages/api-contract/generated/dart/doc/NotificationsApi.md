# materyalph_api_client.api.NotificationsApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**authorizeNotificationChannel**](NotificationsApi.md#authorizenotificationchannel) | **POST** /{audience}/notifications/auth |
[**getNotificationPreferences**](NotificationsApi.md#getnotificationpreferences) | **GET** /{audience}/notifications/preferences | get Notification Preferences
[**getNotificationRealtime**](NotificationsApi.md#getnotificationrealtime) | **GET** /{audience}/notifications/realtime |
[**getNotificationUnreadCount**](NotificationsApi.md#getnotificationunreadcount) | **GET** /{audience}/notifications/unread-count |
[**getVendorNavigationUpdates**](NotificationsApi.md#getvendornavigationupdates) | **GET** /vendor/navigation-updates | Active orders and unread updates for Vendor navigation
[**listNotificationFailures**](NotificationsApi.md#listnotificationfailures) | **GET** /admin/notifications/failures | list Notification Failures
[**listNotifications**](NotificationsApi.md#listnotifications) | **GET** /{audience}/notifications | list Notifications
[**markNotificationsRead**](NotificationsApi.md#marknotificationsread) | **POST** /{audience}/notifications/read-all | Mark the current filtered notification view read and archived
[**readNotification**](NotificationsApi.md#readnotification) | **POST** /{audience}/notifications/{noticeId}/read | read Notification
[**registerNotificationDevice**](NotificationsApi.md#registernotificationdevice) | **POST** /{audience}/notifications/devices | register Notification Device
[**resolveNotification**](NotificationsApi.md#resolvenotification) | **POST** /{audience}/notifications/{noticeId}/resolve | resolve Notification
[**revokeNotificationDevice**](NotificationsApi.md#revokenotificationdevice) | **DELETE** /{audience}/notifications/devices/{deviceId} | revoke Notification Device
[**updateNotificationPreference**](NotificationsApi.md#updatenotificationpreference) | **PUT** /{audience}/notifications/preferences | update Notification Preference


# **authorizeNotificationChannel**
> NotificationChannelAuthResponse authorizeNotificationChannel(audience, chatChannelAuth)



Pusher protocol signature only for the caller's current private-notifications channel. Foreign, stale and other domain channels are denied; current account, audience and membership are rechecked. Web requires HttpOnly cookies and CSRF; native Buyer uses bearer transport. Events carry only content-free notifications.changed invalidations and never authorize REST data access.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getNotificationsApi();
final String audience = audience_example; // String |
final ChatChannelAuth chatChannelAuth = ; // ChatChannelAuth |

try {
    final response = api.authorizeNotificationChannel(audience, chatChannelAuth);
    print(response);
} on DioException catch (e) {
    print('Exception when calling NotificationsApi->authorizeNotificationChannel: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **audience** | **String**|  |
 **chatChannelAuth** | [**ChatChannelAuth**](ChatChannelAuth.md)|  |

### Return type

[**NotificationChannelAuthResponse**](NotificationChannelAuthResponse.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getNotificationPreferences**
> GetNotificationPreferences200Response getNotificationPreferences(audience)

get Notification Preferences



### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getNotificationsApi();
final String audience = audience_example; // String | Authenticated surface. The server rejects mismatched account types.

try {
    final response = api.getNotificationPreferences(audience);
    print(response);
} on DioException catch (e) {
    print('Exception when calling NotificationsApi->getNotificationPreferences: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **audience** | **String**| Authenticated surface. The server rejects mismatched account types. |

### Return type

[**GetNotificationPreferences200Response**](GetNotificationPreferences200Response.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getNotificationRealtime**
> ChatRealtimeResponse getNotificationRealtime(audience)



Current Buyer, Vendor or Admin notification invalidation channel and public Reverb connection settings. The opaque channel rotates with account or membership authority. No notice contents or backend credentials are returned. Clients re-fetch on reconnect and poll while unavailable.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getNotificationsApi();
final String audience = audience_example; // String |

try {
    final response = api.getNotificationRealtime(audience);
    print(response);
} on DioException catch (e) {
    print('Exception when calling NotificationsApi->getNotificationRealtime: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **audience** | **String**|  |

### Return type

[**ChatRealtimeResponse**](ChatRealtimeResponse.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getNotificationUnreadCount**
> GetNotificationUnreadCount200Response getNotificationUnreadCount(audience)



Current caller's authorized unread in-app notice count across all types. Archived, foreign, revoked and disabled optional notices are excluded. Web uses HttpOnly cookies; mobile Buyer uses bearer transport.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';
// TODO Configure API key authorization: webCsrf
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('webCsrf').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getNotificationsApi();
final String audience = audience_example; // String |

try {
    final response = api.getNotificationUnreadCount(audience);
    print(response);
} on DioException catch (e) {
    print('Exception when calling NotificationsApi->getNotificationUnreadCount: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **audience** | **String**|  |

### Return type

[**GetNotificationUnreadCount200Response**](GetNotificationUnreadCount200Response.md)

### Authorization

[accessCookie](../README.md#accessCookie), [passportBearer](../README.md#passportBearer), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVendorNavigationUpdates**
> GetVendorNavigationUpdates200Response getVendorNavigationUpdates()

Active orders and unread updates for Vendor navigation

Orders counts currently visible nonterminal orders, excluding COMPLETED, DECLINED, EXPIRED and CANCELLED, independently of notification history. Team Accounts counts manageable active non-Owner memberships whose user accounts are active; deleted memberships and unaccepted invitations are excluded, and delegated Managers count only non-manager staff. Other sections count unread in-app notifications by their authorized destination and unread messages in the current user's inbox. Store Profile has no indicator. Rechecks current membership, role, delegation, assignment and preferences. Only fixed sidebar paths and counts are returned; visiting a section does not mark updates read.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getNotificationsApi();

try {
    final response = api.getVendorNavigationUpdates();
    print(response);
} on DioException catch (e) {
    print('Exception when calling NotificationsApi->getVendorNavigationUpdates: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**GetVendorNavigationUpdates200Response**](GetVendorNavigationUpdates200Response.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listNotificationFailures**
> ListNotificationFailures200Response listNotificationFailures(page)

list Notification Failures



### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getNotificationsApi();
final int page = 56; // int |

try {
    final response = api.listNotificationFailures(page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling NotificationsApi->listNotificationFailures: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **page** | **int**|  | [optional]

### Return type

[**ListNotificationFailures200Response**](ListNotificationFailures200Response.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listNotifications**
> ListNotifications200Response listNotifications(audience, cursor)

list Notifications

Cursor feed filtered by current membership, role, assignment and preferences, newest first. Read notices are retained and available in the Archived view; no notification is deleted by reading it. Clients can assemble cursor pages for immediate local status and notification-category filters. Authoritative records precede delivery.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getNotificationsApi();
final String audience = audience_example; // String | Authenticated surface. The server rejects mismatched account types.
final String cursor = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.listNotifications(audience, cursor);
    print(response);
} on DioException catch (e) {
    print('Exception when calling NotificationsApi->listNotifications: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **audience** | **String**| Authenticated surface. The server rejects mismatched account types. |
 **cursor** | **String**|  | [optional]

### Return type

[**ListNotifications200Response**](ListNotifications200Response.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **markNotificationsRead**
> MarkNotificationsRead200Response markNotificationsRead(audience, notificationReadFilter)

Mark the current filtered notification view read and archived

Atomically marks the caller's authorized unread notices at or before through_id as read, optionally matching a notification category or legacy exact display title. The captured upper bound leaves later arrivals unread. Rechecks current account, membership, role, resource access and in-app preferences. Notices and required security history are retained and remain accessible in Archived. Naturally idempotent; retries do not change existing read timestamps. Audits the changed count and queues a private content-free inbox invalidation after commit.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getNotificationsApi();
final String audience = audience_example; // String | Authenticated surface. Web requests require the current HttpOnly session cookie and CSRF header.
final NotificationReadFilter notificationReadFilter = ; // NotificationReadFilter |

try {
    final response = api.markNotificationsRead(audience, notificationReadFilter);
    print(response);
} on DioException catch (e) {
    print('Exception when calling NotificationsApi->markNotificationsRead: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **audience** | **String**| Authenticated surface. Web requests require the current HttpOnly session cookie and CSRF header. |
 **notificationReadFilter** | [**NotificationReadFilter**](NotificationReadFilter.md)|  |

### Return type

[**MarkNotificationsRead200Response**](MarkNotificationsRead200Response.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **readNotification**
> RevokeNotificationDevice200Response readNotification(audience, noticeId)

read Notification



### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getNotificationsApi();
final String audience = audience_example; // String | Authenticated surface. The server rejects mismatched account types.
final String noticeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.readNotification(audience, noticeId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling NotificationsApi->readNotification: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **audience** | **String**| Authenticated surface. The server rejects mismatched account types. |
 **noticeId** | **String**|  |

### Return type

[**RevokeNotificationDevice200Response**](RevokeNotificationDevice200Response.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **registerNotificationDevice**
> RegisterNotificationDevice201Response registerNotificationDevice(audience, notificationDeviceInput)

register Notification Device

Encrypted session-bound token registration. Web requires deployment approval. Token never returned.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getNotificationsApi();
final String audience = audience_example; // String | Authenticated surface. The server rejects mismatched account types.
final NotificationDeviceInput notificationDeviceInput = ; // NotificationDeviceInput |

try {
    final response = api.registerNotificationDevice(audience, notificationDeviceInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling NotificationsApi->registerNotificationDevice: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **audience** | **String**| Authenticated surface. The server rejects mismatched account types. |
 **notificationDeviceInput** | [**NotificationDeviceInput**](NotificationDeviceInput.md)|  |

### Return type

[**RegisterNotificationDevice201Response**](RegisterNotificationDevice201Response.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resolveNotification**
> ResolveNotification200Response resolveNotification(audience, noticeId)

resolve Notification

Fresh authenticated session and resource authorization required. Returns only an allowlisted same-application path; denied links return NOTICE_ACCESS_REVOKED.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getNotificationsApi();
final String audience = audience_example; // String | Authenticated surface. The server rejects mismatched account types.
final String noticeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.resolveNotification(audience, noticeId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling NotificationsApi->resolveNotification: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **audience** | **String**| Authenticated surface. The server rejects mismatched account types. |
 **noticeId** | **String**|  |

### Return type

[**ResolveNotification200Response**](ResolveNotification200Response.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **revokeNotificationDevice**
> RevokeNotificationDevice200Response revokeNotificationDevice(audience, deviceId)

revoke Notification Device



### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getNotificationsApi();
final String audience = audience_example; // String | Authenticated surface. The server rejects mismatched account types.
final String deviceId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.revokeNotificationDevice(audience, deviceId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling NotificationsApi->revokeNotificationDevice: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **audience** | **String**| Authenticated surface. The server rejects mismatched account types. |
 **deviceId** | **String**|  |

### Return type

[**RevokeNotificationDevice200Response**](RevokeNotificationDevice200Response.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateNotificationPreference**
> GetNotificationPreferences200Response updateNotificationPreference(audience, notificationPreferenceInput)

update Notification Preference

Mandatory classes cannot be disabled. Unknown categories are rejected.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getNotificationsApi();
final String audience = audience_example; // String | Authenticated surface. The server rejects mismatched account types.
final NotificationPreferenceInput notificationPreferenceInput = ; // NotificationPreferenceInput |

try {
    final response = api.updateNotificationPreference(audience, notificationPreferenceInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling NotificationsApi->updateNotificationPreference: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **audience** | **String**| Authenticated surface. The server rejects mismatched account types. |
 **notificationPreferenceInput** | [**NotificationPreferenceInput**](NotificationPreferenceInput.md)|  |

### Return type

[**GetNotificationPreferences200Response**](GetNotificationPreferences200Response.md)

### Authorization

[passportBearer](../README.md#passportBearer)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

