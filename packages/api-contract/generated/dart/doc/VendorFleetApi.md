# materyalph_api_client.api.VendorFleetApi

## Load the API package
```dart
import 'package:materyalph_api_client/api.dart';
```

All URIs are relative to */api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**downloadFleetVehicleImage**](VendorFleetApi.md#downloadfleetvehicleimage) | **GET** /fleet-files/{fileId}/content |
[**getFleetVehicleImageUrl**](VendorFleetApi.md#getfleetvehicleimageurl) | **GET** /vendor/fleet/vehicle-images/{fileId} |
[**listVendorFleetVehicles**](VendorFleetApi.md#listvendorfleetvehicles) | **GET** /vendor/fleet/vehicles |
[**saveVendorFleetVehicles**](VendorFleetApi.md#savevendorfleetvehicles) | **PUT** /vendor/fleet/vehicles |
[**uploadFleetVehicleImage**](VendorFleetApi.md#uploadfleetvehicleimage) | **POST** /vendor/fleet/vehicle-images |


# **downloadFleetVehicleImage**
> Uint8List downloadFleetVehicleImage(fileId)



### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorFleetApi();
final String fileId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.downloadFleetVehicleImage(fileId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorFleetApi->downloadFleetVehicleImage: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **fileId** | **String**|  |

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/octet-stream, application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getFleetVehicleImageUrl**
> VendorFileEnvelope getFleetVehicleImageUrl(fileId)



### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorFleetApi();
final String fileId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.getFleetVehicleImageUrl(fileId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorFleetApi->getFleetVehicleImageUrl: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **fileId** | **String**|  |

### Return type

[**VendorFileEnvelope**](VendorFileEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listVendorFleetVehicles**
> FleetVehicleListEnvelope listVendorFleetVehicles()



Owner and Store Manager receive every saved vehicle configuration with its eligibility reasons. Fulfillment Staff receive only confirmed vehicles on assigned orders (meta.scope ASSIGNED_ONLY). Other roles are denied.

### Example
```dart
import 'package:materyalph_api_client/api.dart';
// TODO Configure API key authorization: accessCookie
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('accessCookie').apiKeyPrefix = 'Bearer';

final api = MateryalphApiClient().getVendorFleetApi();

try {
    final response = api.listVendorFleetVehicles();
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorFleetApi->listVendorFleetVehicles: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**FleetVehicleListEnvelope**](FleetVehicleListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **saveVendorFleetVehicles**
> FleetVehicleListEnvelope saveVendorFleetVehicles(fleetVehiclesSave)



Owner or Store Manager saves a repeatable vehicle row set on the same records Store Setup uses. Every per-vehicle field error returns together keyed vehicles.{index}.{field}; a saved vehicle needs its lock_version (409 STALE_VERSION when stale). Changes append immutable configuration and rate versions and affect future proposals only; accepted delivery snapshots never change.

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

final api = MateryalphApiClient().getVendorFleetApi();
final FleetVehiclesSave fleetVehiclesSave = ; // FleetVehiclesSave |

try {
    final response = api.saveVendorFleetVehicles(fleetVehiclesSave);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorFleetApi->saveVendorFleetVehicles: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **fleetVehiclesSave** | [**FleetVehiclesSave**](FleetVehiclesSave.md)|  |

### Return type

[**FleetVehicleListEnvelope**](FleetVehicleListEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **uploadFleetVehicleImage**
> FleetVehicleImageEnvelope uploadFleetVehicleImage(file)



Stores a private, scanned and content-validated vehicle image for Owner or Store Manager.

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

final api = MateryalphApiClient().getVendorFleetApi();
final MultipartFile file = BINARY_DATA_HERE; // MultipartFile | JPG

try {
    final response = api.uploadFleetVehicleImage(file);
    print(response);
} on DioException catch (e) {
    print('Exception when calling VendorFleetApi->uploadFleetVehicleImage: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **file** | **MultipartFile**| JPG |

### Return type

[**FleetVehicleImageEnvelope**](FleetVehicleImageEnvelope.md)

### Authorization

[accessCookie](../README.md#accessCookie), [webCsrf](../README.md#webCsrf)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

