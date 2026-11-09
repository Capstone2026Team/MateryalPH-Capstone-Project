# materyalph_api_client.model.RemittanceQueueRow

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  |
**orderReference** | **String** |  |
**vendorName** | **String** |  |
**environment** | **String** |  |
**taxpayerKeySuffix** | **String** |  |
**scenario** | **String** |  | [optional]
**components** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  |
**thresholdStatusBefore** | **String** |  | [optional]
**thresholdStatusAfter** | **String** |  | [optional]
**gEffectiveBeforeCentavos** | **int** |  | [optional]
**gEffectiveAfterCentavos** | **int** |  | [optional]
**calculationState** | **String** |  |
**deductionEvidenceState** | **String** |  |
**reconciliationState** | **String** |  |
**sourceVersion** | **String** | Version of the assessment source and current reconciliation state for backup approval. |
**canApproveReconciliation** | **bool** | Current caller has the restricted role and permission and this assessment can be submitted for fresh validation. |
**reconciliationMethod** | **String** |  | [optional]
**reconciliationActorRole** | **String** |  | [optional]
**reconciledAt** | [**DateTime**](DateTime.md) |  | [optional]
**reviewItemId** | **String** |  | [optional]
**reason** | **String** |  |
**createdAt** | [**DateTime**](DateTime.md) |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


