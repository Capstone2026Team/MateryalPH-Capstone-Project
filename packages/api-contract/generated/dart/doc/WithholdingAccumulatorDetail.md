# materyalph_api_client.model.WithholdingAccumulatorDetail

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  |
**vendor** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  |
**environment** | **String** |  |
**taxpayerKeySuffix** | **String** |  |
**taxableYear** | **int** |  |
**thresholdCentavos** | **int** |  |
**gAccumulatedCentavos** | **int** |  |
**gExternalDeclaredCentavos** | **int** |  |
**gExternalOverlapCentavos** | **int** |  |
**gEffectiveCentavos** | **int** |  |
**remainingAllowanceCentavos** | **int** |  |
**externalOverlapState** | **String** |  |
**status** | **String** |  |
**statusLabel** | **String** |  |
**reasonCode** | **String** |  |
**breached** | **bool** |  |
**crossedAt** | [**DateTime**](DateTime.md) |  | [optional]
**priorYearTotalCentavos** | **int** |  | [optional]
**lockVersion** | **int** |  |
**demo** | **bool** |  |
**taxProfile** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  |
**events** | [**BuiltList&lt;BuiltMap&lt;String, JsonObject&gt;&gt;**](BuiltMap.md) |  |
**assessments** | [**BuiltList&lt;BuiltMap&lt;String, JsonObject&gt;&gt;**](BuiltMap.md) |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


