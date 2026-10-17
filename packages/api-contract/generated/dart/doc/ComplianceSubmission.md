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
**certificateNumber** | **String** | The PS License No. (e.g. Q-1234) for a PS Mark |
**reviewMode** | **String** | MANUAL_REVIEW is the Vendor's explicit request for Product Compliance review when the register cannot confirm the number. | [optional] [default to 'AUTOMATIC']
**reviewNote** | **String** |  | [optional]
**manufacturerName** | **String** |  | [optional]
**manufacturerAddress** | **String** |  | [optional]
**importerName** | **String** |  | [optional]
**importerAddress** | **String** |  | [optional]
**countryOfManufacture** | **String** |  | [optional]
**brand** | **String** |  | [optional]
**batchNumber** | **String** |  | [optional]
**confirmed** | **bool** |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


