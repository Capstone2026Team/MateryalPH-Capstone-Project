# materyalph_api_client.model.WorkPackageView

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**selectedArrangementId** | **String** |  | [optional]
**procurementCandidateId** | **String** |  | [optional]
**vendorOrders** | [**BuiltList&lt;BuiltMap&lt;String, JsonObject&gt;&gt;**](BuiltMap.md) |  | [optional]
**id** | **String** |  |
**projectId** | **String** |  |
**projectStatus** | **String** |  |
**name** | **String** |  |
**status** | **String** |  |
**budgetCentavos** | **int** |  |
**lockVersion** | **int** |  |
**currentVersionId** | **String** |  | [optional]
**selectedVendorId** | **String** | Current active Vendor selection; null when the corresponding order is cancelled, declined or expired. The order itself remains available as history. | [optional]
**orderId** | **String** |  | [optional]
**version** | [**WorkPackageVersion**](WorkPackageVersion.md) |  | [optional]
**budget** | [**ProjectBudget**](ProjectBudget.md) |  |
**missingLines** | [**BuiltList&lt;BuiltMap&lt;String, JsonObject&gt;&gt;**](BuiltMap.md) |  |
**document** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  |
**hasOrder** | **bool** | True while a non-cancelled, non-declined, non-expired order or tagged purchase is tied to this package, or a Vendor selection has no matching closed order. A historical closed order and its old selection do not block editing, reactivation or deletion. Completed commercial work remains protected. | [optional]
**canDelete** | **bool** | True when has_order is false and the Project is Active. Cancelled order history is retained; deleting a package with locked history hides it instead of deleting commercial records. | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


