# materyalph_api_client.model.WorkPackageSummary

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**selectedArrangementId** | **String** |  | [optional]
**vendorOrders** | [**BuiltList&lt;BuiltMap&lt;String, JsonObject&gt;&gt;**](BuiltMap.md) |  | [optional]
**id** | **String** |  |
**projectId** | **String** |  |
**name** | **String** |  |
**status** | **String** |  |
**budgetCentavos** | **int** |  |
**lockVersion** | **int** |  |
**currentVersionId** | **String** |  | [optional]
**selectedVendorId** | **String** | Current active Vendor selection; null when the corresponding order is cancelled, declined or expired. The order itself remains available as history. | [optional]
**orderId** | **String** |  | [optional]
**procurementCandidateId** | **String** | Candidate used by the open primary request; reopens the saved supplementary procurement arrangement. | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


