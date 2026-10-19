# materyalph_api_client.model.DirectoryBuyerProfile

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  |
**subjectType** | **String** |  |
**name** | **String** |  |
**status** | **String** |  |
**profile** | [**DirectoryBuyerProfileProfile**](DirectoryBuyerProfileProfile.md) |  |
**ratings** | [**DirectoryBuyerProfileRatings**](DirectoryBuyerProfileRatings.md) |  |
**activity** | [**DirectoryBuyerProfileActivity**](DirectoryBuyerProfileActivity.md) |  |
**recentOrders** | [**BuiltList&lt;DirectoryBuyerProfileRecentOrdersInner&gt;**](DirectoryBuyerProfileRecentOrdersInner.md) |  |
**sanctions** | [**BuiltList&lt;DirectorySanction&gt;**](DirectorySanction.md) | Empty unless the caller also holds enforcement.view. |
**canViewEnforcement** | **bool** |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


