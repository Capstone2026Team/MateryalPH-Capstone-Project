# materyalph_api_client.api.PublicFinanceApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getPublicCommissionPolicy**](PublicFinanceApi.md#getpubliccommissionpolicy) | **GET** /commission-policy |


# **getPublicCommissionPolicy**
> PublicCommissionPolicyEnvelope getPublicCommissionPolicy(policy)



Public, no-store projection of the current and next effective commercial policy and rendered TEST terms. No Admin reason, staff identity, acceptance or delivery data. Resolved by timestamp, independently of scheduler execution.

### Example
```dart
import 'package:materyalph_api_client/api.dart';

final api = MateryalphApiClient().getPublicFinanceApi();
final String policy = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getPublicCommissionPolicy(policy);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PublicFinanceApi->getPublicCommissionPolicy: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **policy** | **String**|  | [optional]

### Return type

[**PublicCommissionPolicyEnvelope**](PublicCommissionPolicyEnvelope.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

