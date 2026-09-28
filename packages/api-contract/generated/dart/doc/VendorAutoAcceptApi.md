# materyalph_api_client.api.VendorAutoAcceptApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**configureAutoAcceptPolicy**](VendorAutoAcceptApi.md#configureautoacceptpolicy) | **PUT** /vendor/auto-accept/policies/{variantId} |
[**getAutoAcceptPolicy**](VendorAutoAcceptApi.md#getautoacceptpolicy) | **GET** /vendor/auto-accept/policies/{variantId} |
[**pauseAutoAcceptPolicy**](VendorAutoAcceptApi.md#pauseautoacceptpolicy) | **POST** /vendor/auto-accept/policies/{variantId}/pause |
[**resumeAutoAcceptPolicy**](VendorAutoAcceptApi.md#resumeautoacceptpolicy) | **POST** /vendor/auto-accept/policies/{variantId}/resume |
[**updateAutoAcceptAllotment**](VendorAutoAcceptApi.md#updateautoacceptallotment) | **PATCH** /vendor/auto-accept/policies/{variantId}/allotment |


# **configureAutoAcceptPolicy**
> AutoAcceptPolicyDetailEnvelope configureAutoAcceptPolicy(variantId, autoAcceptPolicyConfigure)



Owner or Store Manager enables or disables Item-Based auto-accept and sets the independent allotment, unit and amount safeguards. Disabled by default; enabling needs an ACTIVE listing, a validated price-tax classification and a whole-number allotment above zero. Reconfiguring a paused policy never resumes it. Project-Based procurement and NRPC orders are never auto-accepted.

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

final api = MateryalphApiClient().getVendorAutoAcceptApi();
final String variantId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final AutoAcceptPolicyConfigure autoAcceptPolicyConfigure = ; // AutoAcceptPolicyConfigure |

try {
    final response = api.configureAutoAcceptPolicy(variantId, autoAcceptPolicyConfigure);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorAutoAcceptApi->configureAutoAcceptPolicy: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **variantId** | **String**|  |
 **autoAcceptPolicyConfigure** | [**AutoAcceptPolicyConfigure**](AutoAcceptPolicyConfigure.md)|  |

### Return type

[**AutoAcceptPolicyDetailEnvelope**](AutoAcceptPolicyDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAutoAcceptPolicy**
> AutoAcceptPolicyDetailEnvelope getAutoAcceptPolicy(variantId)



Vendor-only Item-Based auto-accept configuration with the private stock context and immutable version history. Store Staff and Customer Service Staff view outcomes only; Fulfillment Staff are denied.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorAutoAcceptApi();
final String variantId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getAutoAcceptPolicy(variantId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorAutoAcceptApi->getAutoAcceptPolicy: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **variantId** | **String**|  |

### Return type

[**AutoAcceptPolicyDetailEnvelope**](AutoAcceptPolicyDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **pauseAutoAcceptPolicy**
> AutoAcceptPolicyDetailEnvelope pauseAutoAcceptPolicy(variantId, autoAcceptPause)



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

final api = MateryalphApiClient().getVendorAutoAcceptApi();
final String variantId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final AutoAcceptPause autoAcceptPause = ; // AutoAcceptPause |

try {
    final response = api.pauseAutoAcceptPolicy(variantId, autoAcceptPause);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorAutoAcceptApi->pauseAutoAcceptPolicy: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **variantId** | **String**|  |
 **autoAcceptPause** | [**AutoAcceptPause**](AutoAcceptPause.md)|  |

### Return type

[**AutoAcceptPolicyDetailEnvelope**](AutoAcceptPolicyDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resumeAutoAcceptPolicy**
> AutoAcceptPolicyDetailEnvelope resumeAutoAcceptPolicy(variantId, idempotencyKey, autoAcceptResume)



Deliberate Owner or Store Manager resume. confirmed_allotment_quantity must equal the remaining allotment being restored (409 AUTO_ACCEPT_ALLOTMENT_CHANGED otherwise); a zero allotment returns 422 AUTO_ACCEPT_ALLOTMENT_REQUIRED.

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

final api = MateryalphApiClient().getVendorAutoAcceptApi();
final String variantId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String idempotencyKey = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final AutoAcceptResume autoAcceptResume = ; // AutoAcceptResume |

try {
    final response = api.resumeAutoAcceptPolicy(variantId, idempotencyKey, autoAcceptResume);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorAutoAcceptApi->resumeAutoAcceptPolicy: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **variantId** | **String**|  |
 **idempotencyKey** | **String**|  |
 **autoAcceptResume** | [**AutoAcceptResume**](AutoAcceptResume.md)|  |

### Return type

[**AutoAcceptPolicyDetailEnvelope**](AutoAcceptPolicyDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateAutoAcceptAllotment**
> AutoAcceptPolicyDetailEnvelope updateAutoAcceptAllotment(variantId, autoAcceptAllotmentUpdate)



Sets the remaining allotment only (Inventory Staff grant; Owner and Store Manager also). Zero pauses an active policy and notifies permitted users. A higher allotment never resumes a paused policy.

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

final api = MateryalphApiClient().getVendorAutoAcceptApi();
final String variantId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final AutoAcceptAllotmentUpdate autoAcceptAllotmentUpdate = ; // AutoAcceptAllotmentUpdate |

try {
    final response = api.updateAutoAcceptAllotment(variantId, autoAcceptAllotmentUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorAutoAcceptApi->updateAutoAcceptAllotment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **variantId** | **String**|  |
 **autoAcceptAllotmentUpdate** | [**AutoAcceptAllotmentUpdate**](AutoAcceptAllotmentUpdate.md)|  |

### Return type

[**AutoAcceptPolicyDetailEnvelope**](AutoAcceptPolicyDetailEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

