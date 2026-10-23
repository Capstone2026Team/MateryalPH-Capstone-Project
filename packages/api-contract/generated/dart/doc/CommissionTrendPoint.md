# materyalph_api_client.model.CommissionTrendPoint

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**period** | [**Date**](Date.md) | Asia/Manila day, or month start when the trend is monthly. |
**earnedCentavos** | **int** |  |
**creditsCentavos** | **int** |  |
**collectedCentavos** | **int** |  |
**refundedCentavos** | **int** |  |
**netEarningsCentavos** | **int** | Posted fee revenue net of credits and fee VAT, less platform commission payment processing expense. Can be negative in a refund period. |
**gmvCentavos** | **int** | Gross merchandise value of orders confirmed in the period (Vendor money, never platform revenue). |
**buyerPaymentsCentavos** | **int** | Verified online Buyer payments plus recorded Cash on Delivery and In-Store cash, received by Vendors. |
**buyerRefundsCentavos** | **int** | Confirmed online refunds and cash reimbursements to Buyers. |

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


