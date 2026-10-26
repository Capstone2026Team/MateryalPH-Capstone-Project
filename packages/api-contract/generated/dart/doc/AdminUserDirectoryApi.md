# materyalph_api_client.api.AdminUserDirectoryApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getDirectoryBuyer**](AdminUserDirectoryApi.md#getdirectorybuyer) | **GET** /admin/buyers/{buyerId} |
[**getDirectoryBuyerPhoto**](AdminUserDirectoryApi.md#getdirectorybuyerphoto) | **GET** /admin/buyers/{buyerId}/photo |
[**getDirectoryVendor**](AdminUserDirectoryApi.md#getdirectoryvendor) | **GET** /admin/vendors/{vendorId} |
[**listDirectoryBuyerReviews**](AdminUserDirectoryApi.md#listdirectorybuyerreviews) | **GET** /admin/buyers/{buyerId}/reviews |
[**listDirectoryBuyers**](AdminUserDirectoryApi.md#listdirectorybuyers) | **GET** /admin/buyers |
[**listDirectoryVendorListings**](AdminUserDirectoryApi.md#listdirectoryvendorlistings) | **GET** /admin/vendors/{vendorId}/listings |
[**listDirectoryVendorReviews**](AdminUserDirectoryApi.md#listdirectoryvendorreviews) | **GET** /admin/vendors/{vendorId}/reviews |
[**listDirectoryVendors**](AdminUserDirectoryApi.md#listdirectoryvendors) | **GET** /admin/vendors |


# **getDirectoryBuyer**
> DirectoryBuyerEnvelope getDirectoryBuyer(buyerId)



user_directory.view. Buyer profile with contact details, ratings, activity and recent orders. Opening a profile is audited; a self-deleted Buyer's email is masked and mobile and profile photo omitted.

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

final api = MateryalphApiClient().getAdminUserDirectoryApi();
final String buyerId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getDirectoryBuyer(buyerId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminUserDirectoryApi->getDirectoryBuyer: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **buyerId** | **String**|  |

### Return type

[**DirectoryBuyerEnvelope**](DirectoryBuyerEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getDirectoryBuyerPhoto**
> Uint8List getDirectoryBuyerPhoto(buyerId, expires, owner, version, viewer, signature)



user_directory.view. Fetch the sanitized private Buyer profile photo using the five-minute signed avatar_url from the directory profile. The URL is bound to the Buyer, current profile version and viewing Admin; it grants no access without the current Admin session and permission. Deleted Buyers have no photo. Authorization and photo version are checked again after private storage is read. Responses are private and no-store.

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

final api = MateryalphApiClient().getAdminUserDirectoryApi();
final String buyerId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final int expires = 56; // int |
final String owner = owner_example; // String |
final int version = 56; // int |
final String viewer = viewer_example; // String |
final String signature = signature_example; // String |

try {
    final response = api.getDirectoryBuyerPhoto(buyerId, expires, owner, version, viewer, signature);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminUserDirectoryApi->getDirectoryBuyerPhoto: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **buyerId** | **String**|  |
 **expires** | **int**|  |
 **owner** | **String**|  |
 **version** | **int**|  |
 **viewer** | **String**|  |
 **signature** | **String**|  |

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: image/png, application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getDirectoryVendor**
> DirectoryVendorEnvelope getDirectoryVendor(vendorId)



user_directory.view. Store profile, Owner contact, ratings and activity. Opening a profile is audited. Exact inventory is never returned.

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

final api = MateryalphApiClient().getAdminUserDirectoryApi();
final String vendorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getDirectoryVendor(vendorId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminUserDirectoryApi->getDirectoryVendor: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **vendorId** | **String**|  |

### Return type

[**DirectoryVendorEnvelope**](DirectoryVendorEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listDirectoryBuyerReviews**
> DirectoryReviewListEnvelope listDirectoryBuyerReviews(buyerId, direction, page)



user_directory.view. Ratings the Buyer received from Vendors (RECEIVED) or reviews the Buyer wrote (WRITTEN). Hidden or removed text is shown only to roles with reviews.moderate.

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

final api = MateryalphApiClient().getAdminUserDirectoryApi();
final String buyerId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String direction = direction_example; // String |
final int page = 56; // int |

try {
    final response = api.listDirectoryBuyerReviews(buyerId, direction, page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminUserDirectoryApi->listDirectoryBuyerReviews: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **buyerId** | **String**|  |
 **direction** | **String**|  | [optional]
 **page** | **int**|  | [optional]

### Return type

[**DirectoryReviewListEnvelope**](DirectoryReviewListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listDirectoryBuyers**
> DirectoryBuyerListEnvelope listDirectoryBuyers(q, status, buyerType, sort, page, from, to)



user_directory.view (Super Admin, User Management, Support). Buyer Management → Users. Search matches name, email and company; the date range filters the join date.

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

final api = MateryalphApiClient().getAdminUserDirectoryApi();
final String q = q_example; // String |
final String status = status_example; // String |
final String buyerType = buyerType_example; // String |
final String sort = sort_example; // String |
final int page = 56; // int |
final Date from = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. User created_at.
final Date to = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. User created_at.

try {
    final response = api.listDirectoryBuyers(q, status, buyerType, sort, page, from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminUserDirectoryApi->listDirectoryBuyers: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **q** | **String**|  | [optional]
 **status** | **String**|  | [optional]
 **buyerType** | **String**|  | [optional]
 **sort** | **String**|  | [optional]
 **page** | **int**|  | [optional]
 **from** | **Date**| Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. User created_at. | [optional]
 **to** | **Date**| Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. User created_at. | [optional]

### Return type

[**DirectoryBuyerListEnvelope**](DirectoryBuyerListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listDirectoryVendorListings**
> DirectoryListingListEnvelope listDirectoryVendorListings(vendorId, q, status, page)



user_directory.view. Basic listing facts only (image, name, price range, public stock label and status); never exact inventory.

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

final api = MateryalphApiClient().getAdminUserDirectoryApi();
final String vendorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String q = q_example; // String |
final String status = status_example; // String |
final int page = 56; // int |

try {
    final response = api.listDirectoryVendorListings(vendorId, q, status, page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminUserDirectoryApi->listDirectoryVendorListings: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **vendorId** | **String**|  |
 **q** | **String**|  | [optional]
 **status** | **String**|  | [optional]
 **page** | **int**|  | [optional]

### Return type

[**DirectoryListingListEnvelope**](DirectoryListingListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listDirectoryVendorReviews**
> DirectoryReviewListEnvelope listDirectoryVendorReviews(vendorId, type, page)



user_directory.view. Store reviews (VENDOR) or Product Reviews (PRODUCT) the Vendor received. Hidden or removed text is shown only to roles with reviews.moderate.

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

final api = MateryalphApiClient().getAdminUserDirectoryApi();
final String vendorId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final String type = type_example; // String |
final int page = 56; // int |

try {
    final response = api.listDirectoryVendorReviews(vendorId, type, page);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminUserDirectoryApi->listDirectoryVendorReviews: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **vendorId** | **String**|  |
 **type** | **String**|  | [optional]
 **page** | **int**|  | [optional]

### Return type

[**DirectoryReviewListEnvelope**](DirectoryReviewListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listDirectoryVendors**
> DirectoryVendorListEnvelope listDirectoryVendors(q, status, verification, discoverability, sort, page, from, to)



user_directory.view (Super Admin, User Management, Support). Vendor Management → Users. Search matches store, legal name and Owner name or email; status is the Store Activation status.

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

final api = MateryalphApiClient().getAdminUserDirectoryApi();
final String q = q_example; // String |
final String status = status_example; // String |
final String verification = verification_example; // String |
final String discoverability = discoverability_example; // String |
final String sort = sort_example; // String |
final int page = 56; // int |
final Date from = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Store created_at.
final Date to = 2013-10-20; // Date | Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Store created_at.

try {
    final response = api.listDirectoryVendors(q, status, verification, discoverability, sort, page, from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AdminUserDirectoryApi->listDirectoryVendors: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **q** | **String**|  | [optional]
 **status** | **String**|  | [optional]
 **verification** | **String**|  | [optional]
 **discoverability** | **String**|  | [optional]
 **sort** | **String**|  | [optional]
 **page** | **int**|  | [optional]
 **from** | **Date**| Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Store created_at. | [optional]
 **to** | **Date**| Inclusive Asia/Manila calendar date; omit to leave this boundary unrestricted. Store created_at. | [optional]

### Return type

[**DirectoryVendorListEnvelope**](DirectoryVendorListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

