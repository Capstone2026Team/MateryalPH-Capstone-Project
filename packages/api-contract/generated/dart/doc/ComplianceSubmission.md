# materyalph_api_client.model.ComplianceSubmission

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**listingLockVersion** | **int** |  |
**path** | [**CompliancePath**](CompliancePath.md) |  |
**evidenceIds** | **BuiltList&lt;String&gt;** |  |
**markingType** | [**MarkingType**](MarkingType.md) |  |
**certificateNumber** | **String** |  |
**manufacturerName** | **String** | Required for a PS Mark. | [optional]
**manufacturerAddress** | **String** |  | [optional]
**importerName** | **String** | Required for an ICC sticker. | [optional]
**importerAddress** | **String** |  | [optional]
**countryOfManufacture** | **String** |  | [optional]
**brand** | **String** |  | [optional]
**batchNumber** | **String** |  | [optional]
**confirmed** | **bool** |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


