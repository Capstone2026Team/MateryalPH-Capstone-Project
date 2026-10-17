# materyalph_api_client.model.DisputeDecision

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  |
**version** | **int** |  |
**kind** | **String** |  |
**outcome** | **String** |  |
**appealResult** | **String** |  | [optional]
**awardedCentavos** | **int** |  |
**reason** | **String** |  | [optional]
**evidenceLimitation** | **String** |  | [optional]
**enforceable** | **bool** |  |
**decidedAt** | [**DateTime**](DateTime.md) |  | [optional]
**appealDueAt** | [**DateTime**](DateTime.md) |  | [optional]
**supersedesDecisionId** | **String** |  | [optional]
**deciderRole** | **String** |  |
**deciderName** | **String** |  | [optional]
**sanctions** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  | [optional]
**current** | **bool** |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


