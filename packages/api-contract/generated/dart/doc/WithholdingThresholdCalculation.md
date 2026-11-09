# materyalph_api_client.model.WithholdingThresholdCalculation

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**assessedPayments** | **int** | Number of POSTED merchant online-payment assessments included for this taxpayer and taxable year. Direct COD and In-Store cash records are excluded. |
**paymentPrincipalCentavos** | **int** | Original online order principal in the included assessments, before refunds. Not the all-method, date-filtered Net sales figure. |
**buyerProcessingFeesCentavos** | **int** | Buyer fees included in the assessed online collections. Payment principal plus these fees equals collections_centavos; Buyer fees are not sales revenue. |
**collectionsCentavos** | **int** |  |
**refundsCentavos** | **int** |  |
**deliveryCentavos** | **int** |  |
**materialVatCentavos** | **int** |  |
**providerChargesCentavos** | **int** |  |
**grossBasisCentavos** | **int** |  |
**withheldCentavos** | **int** |  |
**assessedCashCentavos** | **int** |  |
**withholdingBreakdown** | [**WithholdingCalculationBreakdown**](WithholdingCalculationBreakdown.md) | Optional read-only preview for explaining the recorded withholding total. Null when concurrent source changes prevent a consistent preview; the recorded total is retained. Other stores remain aggregate-only. | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


