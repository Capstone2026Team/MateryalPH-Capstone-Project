# materyalph_api_client.api.VendorFinanceReviewsApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getVendorFinanceReviews**](VendorFinanceReviewsApi.md#getvendorfinancereviews) | **GET** /vendor/finance/reviews |


# **getVendorFinanceReviews**
> VendorFinanceReviewsEnvelope getVendorFinanceReviews()



Vendor Owner only (finance.view). FIN-10 review status for this store.

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

final api = MateryalphApiClient().getVendorFinanceReviewsApi();

try {
    final response = api.getVendorFinanceReviews();
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorFinanceReviewsApi->getVendorFinanceReviews: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**VendorFinanceReviewsEnvelope**](VendorFinanceReviewsEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

