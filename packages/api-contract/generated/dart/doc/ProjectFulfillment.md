# materyalph_api_client.model.ProjectFulfillment

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**status** | **String** |  |
**linesTotal** | **int** |  |
**linesFulfilled** | **int** |  |
**linesPartial** | **int** |  |
**linesUnfulfilled** | **int** |  |
**vendorLinesFulfilled** | **int** | Lines this Vendor supplies in full by itself. |
**lines** | [**BuiltList&lt;ProjectFulfillmentLine&gt;**](ProjectFulfillmentLine.md) |  |
**separateItems** | [**BuiltList&lt;ProjectSeparatePurchase&gt;**](ProjectSeparatePurchase.md) |  |
**separateTotalCentavos** | **int** |  |
**combinedTotalCentavos** | **int** | Projected total (materials when delivery is under review) plus the separate purchases. |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


