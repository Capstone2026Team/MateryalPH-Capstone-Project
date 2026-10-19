# materyalph_api_client.model.ProjectPreferences

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**weights** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) | Four independent integer importance values from 0 to 100: material_match, budget_fit, distance and vps. At least one above zero; persisted unchanged. Scores normalize by their sum. |
**defaultWeights** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  |
**personalized** | **bool** |  |
**version** | **int** |  |
**defaultsVersion** | **int** |  |
**algorithmVersion** | **String** |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


