# materyalph_api_client.model.FinancialPreview

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**currency** | **String** |  |
**calculationVersion** | **String** |  |
**lines** | [**BuiltList&lt;FinancialPreviewLine&gt;**](FinancialPreviewLine.md) |  |
**materialsSubtotalCentavos** | **int** |  |
**includedVatCentavos** | **int** |  |
**vatExclusiveMaterialsCentavos** | **int** |  |
**vatTreatment** | **String** |  |
**delivery** | [**DeliveryAmount**](DeliveryAmount.md) |  |
**processingFee** | [**ProcessingFeeAmount**](ProcessingFeeAmount.md) |  |
**totalBeforeProcessingMinCentavos** | **int** |  |
**totalBeforeProcessingMaxCentavos** | **int** |  |
**excludes** | **BuiltList&lt;String&gt;** |  |
**status** | **String** |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


