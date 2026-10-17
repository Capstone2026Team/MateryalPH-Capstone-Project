# materyalph_api_client.model.VendorEarningsTrendPoint

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**date** | [**Date**](Date.md) | Bucket start: the day, or the first day of the month. |
**commercialSalesCentavos** | **int** |  |
**onlineCollectionsCentavos** | **int** | Verified online principal less confirmed refunded principal, attributed to the original payment date; fully refunded principal contributes zero. |
**onlineRefundsCentavos** | **int** | Confirmed online refunds, including their refunded Buyer fees, attributed to the original payment date. Pending and failed refunds do not reduce collections. |
**buyerProcessingFeesCentavos** | **int** |  |
**physicalCollectionsCentavos** | **int** |  |
**providerChargesCentavos** | **int** |  |
**simulatedCwtCentavos** | **int** |  |
**estimatedRemittanceCashCentavos** | **int** |  |
**earnedCommissionCentavos** | **int** |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


