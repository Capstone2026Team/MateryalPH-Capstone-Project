# materyalph_api_client.api.NotificationsApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getNotificationPreferences**](NotificationsApi.md#getnotificationpreferences) | **GET** /{audience}/notifications/preferences | get Notification Preferences
[**listNotificationFailures**](NotificationsApi.md#listnotificationfailures) | **GET** /admin/notifications/failures | list Notification Failures
[**listNotifications**](NotificationsApi.md#listnotifications) | **GET** /{audience}/notifications | list Notifications
[**readNotification**](NotificationsApi.md#readnotification) | **POST** /{audience}/notifications/{noticeId}/read | read Notification
[**registerNotificationDevice**](NotificationsApi.md#registernotificationdevice) | **POST** /{audience}/notifications/devices | register Notification Device
[**resolveNotification**](NotificationsApi.md#resolvenotification) | **POST** /{audience}/notifications/{noticeId}/resolve | resolve Notification
[**revokeNotificationDevice**](NotificationsApi.md#revokenotificationdevice) | **DELETE** /{audience}/notifications/devices/{deviceId} | revoke Notification Device
[**updateNotificationPreference**](NotificationsApi.md#updatenotificationpreference) | **PUT** /{audience}/notifications/preferences | update Notification Preference


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

Cursor feed filtered by current membership, role, assignment and preferences. Authoritative records precede delivery.

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

