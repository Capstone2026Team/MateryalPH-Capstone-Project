# materyalph_api_client.api.AdminIntegrationHealthApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getIntegrationHealth**](AdminIntegrationHealthApi.md#getintegrationhealth) | **GET** /admin/integrations |
[**listOperationFailures**](AdminIntegrationHealthApi.md#listoperationfailures) | **GET** /admin/integrations/failures |
[**listOperationRetries**](AdminIntegrationHealthApi.md#listoperationretries) | **GET** /admin/integrations/retries |
[**retryOperation**](AdminIntegrationHealthApi.md#retryoperation) | **POST** /admin/integrations/retries |


# **getIntegrationHealth**
> IntegrationOverviewEnvelope getIntegrationHealth()



integrations.view. Provider, queue, scheduled-task, aggregation, Materials snapshot and PSGC health without secrets.

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

final api = MateryalphApiClient().getAdminIntegrationHealthApi();

try {
    final response = api.getIntegrationHealth();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminIntegrationHealthApi->getIntegrationHealth: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**IntegrationOverviewEnvelope**](IntegrationOverviewEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listOperationFailures**
> OperationFailureListEnvelope listOperationFailures(kind, page)



integrations.view. Dead-lettered outbox deliveries or failed jobs: type and failure class only.

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

final api = MateryalphApiClient().getAdminIntegrationHealthApi();
final String kind = kind_example; // String |
final int page = 56; // int |

try {
    final response = api.listOperationFailures(kind, page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminIntegrationHealthApi->listOperationFailures: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **kind** | **String**|  | [optional]
 **page** | **int**|  | [optional]

### Return type

[**OperationFailureListEnvelope**](OperationFailureListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listOperationRetries**
> OperationRetryListEnvelope listOperationRetries()



integrations.view. Recent authorized retries with reasons.

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

final api = MateryalphApiClient().getAdminIntegrationHealthApi();

try {
    final response = api.listOperationRetries();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminIntegrationHealthApi->listOperationRetries: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**OperationRetryListEnvelope**](OperationRetryListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **retryOperation**
> OperationRetryEnvelope retryOperation(idempotencyKey, operationRetryRequest)



jobs.retry. Retry an allowlisted idempotent failed job, outbox delivery or daily analytics run with a reason. Payment and refund work belongs to reconciliation (409 RETRY_NOT_ALLOWED).

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

final api = MateryalphApiClient().getAdminIntegrationHealthApi();
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final OperationRetryRequest operationRetryRequest = ; // OperationRetryRequest |

try {
    final response = api.retryOperation(idempotencyKey, operationRetryRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminIntegrationHealthApi->retryOperation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **idempotencyKey** | **String**|  |
 **operationRetryRequest** | [**OperationRetryRequest**](OperationRetryRequest.md)|  |

### Return type

[**OperationRetryEnvelope**](OperationRetryEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

