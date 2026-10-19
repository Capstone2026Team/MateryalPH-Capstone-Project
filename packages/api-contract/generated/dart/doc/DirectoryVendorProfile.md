# materyalph_api_client.model.DirectoryVendorProfile

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  |
**subjectType** | **String** |  |
**storeName** | **String** |  |
**status** | **String** |  |
**store** | [**DirectoryVendorProfileStore**](DirectoryVendorProfileStore.md) |  |
**owner** | [**DirectoryVendorProfileOwner**](DirectoryVendorProfileOwner.md) |  |
**ratings** | [**DirectoryVendorProfileRatings**](DirectoryVendorProfileRatings.md) |  |
**activity** | [**DirectoryVendorProfileActivity**](DirectoryVendorProfileActivity.md) |  |
**sanctions** | [**BuiltList&lt;DirectorySanction&gt;**](DirectorySanction.md) | Empty unless the caller also holds enforcement.view. |
**canViewEnforcement** | **bool** |  |
**canViewVerification** | **bool** |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


