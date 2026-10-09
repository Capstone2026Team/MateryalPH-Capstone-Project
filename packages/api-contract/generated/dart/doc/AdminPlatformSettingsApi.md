# materyalph_api_client.api.AdminPlatformSettingsApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**listPlatformSettingHistory**](AdminPlatformSettingsApi.md#listplatformsettinghistory) | **GET** /admin/platform-settings/{key}/history |
[**listPlatformSettings**](AdminPlatformSettingsApi.md#listplatformsettings) | **GET** /admin/platform-settings |
[**updatePlatformSetting**](AdminPlatformSettingsApi.md#updateplatformsetting) | **PUT** /admin/platform-settings/{key} |


# **listPlatformSettingHistory**
> PlatformSettingHistoryEnvelope listPlatformSettingHistory(key)



platform_settings.view. Append-only versions with previous value, reason, actor role and correlation ID.

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

final api = MateryalphApiClient().getAdminPlatformSettingsApi();
final String key = key_example; // String |

try {
    final response = api.listPlatformSettingHistory(key);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminPlatformSettingsApi->listPlatformSettingHistory: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **key** | **String**|  |

### Return type

[**PlatformSettingHistoryEnvelope**](PlatformSettingHistoryEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listPlatformSettings**
> PlatformSettingListEnvelope listPlatformSettings()



platform_settings.view. Every approved non-secret default with its current version, validation rule and previous value, plus the fixed references that have no control.

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

final api = MateryalphApiClient().getAdminPlatformSettingsApi();

try {
    final response = api.listPlatformSettings();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminPlatformSettingsApi->listPlatformSettings: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**PlatformSettingListEnvelope**](PlatformSettingListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updatePlatformSetting**
> PlatformSettingEnvelope updatePlatformSetting(key, platformSettingUpdateRequest)



platform_settings.manage with recent re-authentication. Writes a new version; consuming rules apply it to new records only.

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

final api = MateryalphApiClient().getAdminPlatformSettingsApi();
final String key = key_example; // String |
final PlatformSettingUpdateRequest platformSettingUpdateRequest = ; // PlatformSettingUpdateRequest |

try {
    final response = api.updatePlatformSetting(key, platformSettingUpdateRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminPlatformSettingsApi->updatePlatformSetting: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **key** | **String**|  |
 **platformSettingUpdateRequest** | [**PlatformSettingUpdateRequest**](PlatformSettingUpdateRequest.md)|  |

### Return type

[**PlatformSettingEnvelope**](PlatformSettingEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

