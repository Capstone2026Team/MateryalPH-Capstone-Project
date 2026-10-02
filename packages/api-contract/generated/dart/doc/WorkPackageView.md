# materyalph_api_client.model.WorkPackageView

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  |
**projectId** | **String** |  |
**projectStatus** | **String** |  |
**name** | **String** |  |
**status** | **String** |  |
**budgetCentavos** | **int** |  |
**lockVersion** | **int** |  |
**currentVersionId** | **String** |  | [optional]
**selectedVendorId** | **String** |  | [optional]
**orderId** | **String** |  | [optional]
**version** | [**WorkPackageVersion**](WorkPackageVersion.md) |  | [optional]
**versions** | [**WorkPackageVersionPage**](WorkPackageVersionPage.md) |  |
**budget** | [**ProjectBudget**](ProjectBudget.md) |  |
**missingLines** | [**BuiltList&lt;BuiltMap&lt;String, JsonObject&gt;&gt;**](BuiltMap.md) |  |
**document** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


