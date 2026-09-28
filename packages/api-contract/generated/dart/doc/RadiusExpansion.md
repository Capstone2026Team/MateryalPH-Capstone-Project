# materyalph_api_client.model.RadiusExpansion

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**eligibleVerifiedCount** | **int** |  |
**suggestedRadiusKm** | **int** | The next allowed radius (10, 20, 30, 40 or 50), or null at 50 km or with three or more Verified Vendors. |
**atMaximum** | **bool** |  |
**reason** | **String** | FEWER_THAN_THREE_VERIFIED_VENDORS or null. |
**requiresConfirmation** | **bool** | Always true; clients ask before changing the radius. |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


