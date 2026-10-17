# materyalph_api_client.model.VendorEarnings

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**demo** | **bool** |  |
**environment** | **String** |  |
**notice** | **String** |  |
**commercialSalesCentavos** | **int** | Latest financial-snapshot total (materials after vendor discount, VAT included, plus delivery) of orders accepted in the range, leaving out declined, expired, cancelled and unconfirmed orders and orders whose payment was fully refunded. The Dashboard's Product sales value uses the same rule. |
**includedVatCentavos** | **int** |  |
**onlineCollectionsCentavos** | **int** | Verified online principal less confirmed refunded principal, attributed to the original payment date; fully refunded principal contributes zero. |
**onlineRefundsCentavos** | **int** | Confirmed online refunds, including their refunded Buyer fees, attributed to the original payment date. Pending and failed refunds do not reduce collections. |
**buyerProcessingFeesCentavos** | **int** |  |
**physicalCollectionsCentavos** | **int** |  |
**providerChargesCentavos** | **int** |  |
**simulatedCwtCentavos** | **int** |  |
**estimatedRemittanceCashCentavos** | **int** |  |
**remittanceCollectionsCentavos** | **int** | Original collected amounts, including Buyer processing fees, of POSTED assessments and confirmed fully refunded VOIDED assessments in the selected assessment-date range. Fully refunded amounts appear in both collections and refunds and cancel out; their provider charge, CWT and net cash remain zero. |
**remittanceRefundsCentavos** | **int** | Refund allocations already applied to remittances plus subsequent confirmed full and partial refunds, counted once and allocated up to the original collection. Includes fully refunded VOIDED assessments, so refund visibility is preserved without counting refunded money as earnings. Pending and failed refunds do not reduce cash. Uses the same assessment-date range as estimated_remittance_cash_centavos. |
**earnedCommissionCentavos** | **int** | Signed commission earnings less approved credits, by earned_at and approved_at respectively; shared with Admin Finance. Can be negative in a credit-only period. |
**estimatedCommissionCentavos** | **int** |  |
**unpaidStatementsCentavos** | **int** |  |
**breakdown** | [**VendorEarningsBreakdown**](VendorEarningsBreakdown.md) |  |
**products** | [**VendorEarningsProducts**](VendorEarningsProducts.md) |  |
**trend** | [**VendorEarningsTrend**](VendorEarningsTrend.md) |  |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


