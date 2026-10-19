# materyalph_api_client.model.ProjectArrangement

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**fms** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) | Versioned arrangement FMS with score, normalized components, raw buyer weights, supplier material shares and calculation basis. Material coverage uses exact allocated quantities per requirement, budget fit uses all materials and delivery, and distance and normalized VPS use material-cost shares. Existing neutral treatment for New Vendors remains unchanged. |
**rank** | **int** | Position in the filtered Best Match result before pagination; null for Price sort, incomplete coverage or unresolved costs/data. | [optional]
**proposalToken** | **String** | Opaque Buyer and Work Package scoped server-issued proposal. Pass unchanged when creating this computed arrangement; never parse it in clients. | [optional]
**id** | **String** |  |
**sourceCandidateId** | **String** |  |
**version** | **int** |  |
**workPackageVersionId** | **String** |  |
**vendors** | [**BuiltList&lt;BuiltMap&lt;String, JsonObject&gt;&gt;**](BuiltMap.md) |  |
**vendorCount** | **int** |  |
**coverage** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  |
**materialsCentavos** | **int** |  |
**deliveryCentavos** | **int** |  |
**totalCentavos** | **int** |  |
**budgetLabel** | **String** |  |
**fingerprint** | **String** |  |
**issues** | **BuiltList&lt;String&gt;** |  |
**submitted** | **bool** |  |
**stale** | **bool** |  |
**previousVendors** | [**BuiltList&lt;BuiltMap&lt;String, JsonObject&gt;&gt;**](BuiltMap.md) |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


