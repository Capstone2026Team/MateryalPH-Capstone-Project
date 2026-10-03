# materyalph_api_client.model.WithholdingThresholdPanel

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**demo** | **bool** |  |
**taxableYear** | **int** |  |
**yearStartAt** | [**DateTime**](DateTime.md) |  |
**yearEndAt** | [**DateTime**](DateTime.md) |  |
**thresholdCentavos** | **int** |  |
**cumulativeGrossCentavos** | **int** |  |
**remainingAllowanceCentavos** | **int** |  |
**localGrossCentavos** | **int** |  |
**externalDeclaredCentavos** | **int** |  |
**externalOverlapCentavos** | **int** |  |
**externalOverlapState** | **String** |  |
**percentOfThreshold** | **int** |  |
**advisory** | **bool** |  |
**status** | **String** |  |
**statusLabel** | **String** |  |
**statusIcon** | **String** |  |
**reasonCode** | **String** |  | [optional]
**crossedAt** | [**DateTime**](DateTime.md) |  | [optional]
**crossedAtManila** | **String** |  | [optional]
**priorYearTotalCentavos** | **int** |  | [optional]
**finalForYearNotice** | **String** |  |
**events** | [**BuiltList&lt;ThresholdStatusEvent&gt;**](ThresholdStatusEvent.md) |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


