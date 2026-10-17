# materyalph_api_client.model.AdminDisputeDecisionRequest

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**outcome** | **String** |  |
**reason** | **String** |  |
**amountCentavos** | **int** |  | [optional]
**affectedLineIds** | **BuiltList&lt;String&gt;** |  | [optional]
**enforceable** | **bool** | Immediately enforceable; otherwise the award executes when the five-business-day appeal window lapses unappealed. |
**conflictCheckConfirmed** | **bool** |  |
**evidenceLimitation** | **String** |  | [optional]
**sanctions** | [**BuiltList&lt;DisputeSanctionInput&gt;**](DisputeSanctionInput.md) |  | [optional]
**metricEvent** | **String** |  | [optional]
**lockVersion** | **int** |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


