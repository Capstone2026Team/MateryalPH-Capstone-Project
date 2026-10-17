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
**budget** | [**ProjectBudget**](ProjectBudget.md) |  |
**missingLines** | [**BuiltList&lt;BuiltMap&lt;String, JsonObject&gt;&gt;**](BuiltMap.md) |  |
**document** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  |
**hasOrder** | **bool** | True when an order, tagged purchase for a missing line or selected Vendor is tied to the package. | [optional]
**canDelete** | **bool** | True while the package has no order and its Project is Active. Clients hide the delete action otherwise; the server enforces the rule. | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


