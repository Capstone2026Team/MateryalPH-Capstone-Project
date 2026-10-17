# materyalph_api_client.api.AdminAuditLogApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getAuditEvent**](AdminAuditLogApi.md#getauditevent) | **GET** /admin/audit-log/{auditId} |
[**listAuditActions**](AdminAuditLogApi.md#listauditactions) | **GET** /admin/audit-log/actions |
[**searchAuditLog**](AdminAuditLogApi.md#searchauditlog) | **GET** /admin/audit-log |


# **getAuditEvent**
> AuditEventDetailEnvelope getAuditEvent(auditId)



audit.view_sensitive. Redacted before/after; the opening is itself audited. There is no edit or delete operation.

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

final api = MateryalphApiClient().getAdminAuditLogApi();
final String auditId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getAuditEvent(auditId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminAuditLogApi->getAuditEvent: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **auditId** | **String**|  |

### Return type

[**AuditEventDetailEnvelope**](AuditEventDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAuditActions**
> AuditActionListEnvelope listAuditActions()



audit.view. Distinct action codes for the filter control.

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

final api = MateryalphApiClient().getAdminAuditLogApi();

try {
    final response = api.listAuditActions();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminAuditLogApi->listAuditActions: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AuditActionListEnvelope**](AuditActionListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchAuditLog**
> AuditEventListEnvelope searchAuditLog(actor, actorRole, action, resourceType, resourceId, organizationId, result, correlationId, reason, from, to, cursor)



audit.view. Append-only safe projection filterable by actor, role, action, resource, organization, result, date, correlation ID and reason; cursor paginated.

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

final api = MateryalphApiClient().getAdminAuditLogApi();
final String actor = actor_example; // String |
final String actorRole = actorRole_example; // String |
final String action = action_example; // String |
final String resourceType = resourceType_example; // String |
final String resourceId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String organizationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String result = result_example; // String |
final String correlationId = correlationId_example; // String |
final String reason = reason_example; // String |
final Date from = 2013-10-20; // Date |
final Date to = 2013-10-20; // Date |
final String cursor = cursor_example; // String |

try {
    final response = api.searchAuditLog(actor, actorRole, action, resourceType, resourceId, organizationId, result, correlationId, reason, from, to, cursor);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminAuditLogApi->searchAuditLog: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **actor** | **String**|  | [optional]
 **actorRole** | **String**|  | [optional]
 **action** | **String**|  | [optional]
 **resourceType** | **String**|  | [optional]
 **resourceId** | **String**|  | [optional]
 **organizationId** | **String**|  | [optional]
 **result** | **String**|  | [optional]
 **correlationId** | **String**|  | [optional]
 **reason** | **String**|  | [optional]
 **from** | **Date**|  | [optional]
 **to** | **Date**|  | [optional]
 **cursor** | **String**|  | [optional]

### Return type

[**AuditEventListEnvelope**](AuditEventListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

