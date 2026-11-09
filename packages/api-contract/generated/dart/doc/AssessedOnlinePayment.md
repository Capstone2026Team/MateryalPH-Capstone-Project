# materyalph_api_client.model.AssessedOnlinePayment

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | Assessment record ID, not a provider identifier. |
**orderReference** | **String** |  |
**assessedAt** | [**DateTime**](DateTime.md) |  |
**grossBasisCentavos** | **int** | Original posted tax basis; later refunds do not rewrite it. |
**rateBasisPoints** | **int** | Recorded effective withholding rate in basis points; 50 is 0.5 percent, 0 is recorded relief. |
**withheldCentavos** | **int** | Original tax amount rounded half-up per assessment; never recomputed from retained principal or an annual basis. |
**assessedPaymentCentavos** | **int** | Original assessment collection minus its recorded pre-assessment refunds and provider charge, before delivery and material VAT exclusions. Matches the annual tax-basis calculation's Online payments line; later refunds do not change this amount. |
**deliveryCentavos** | **int** | Separately billed delivery excluded in the original posted tax assessment. |
**materialVatCentavos** | **int** | Included material VAT excluded in the original posted tax assessment. |
**paymentPrincipalCentavos** | **int** |  |
**buyerProcessingFeesCentavos** | **int** |  |
**collectionsCentavos** | **int** |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


