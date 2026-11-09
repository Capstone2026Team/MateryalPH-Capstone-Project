# materyalph_api_client.model.VendorDashboardSeriesPoint

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**date** | [**Date**](Date.md) |  |
**orders** | **int** |  |
**orderRequests** | **int** |  |
**ordersAverage** | **num** |  | [optional]
**grossSalesCentavos** | **int** |  | [optional]
**netSalesCentavos** | **int** | Displayed as Earnings. Gross sales less completed online refund principal, confirmed physical reimbursements and cancelled-order value not already refunded. Before commission, other charges and business costs; not profit. Null without finance.view. | [optional]
**refundsCentavos** | **int** | Completed online refund principal and confirmed physical reimbursements deducted from this store's orders first confirmed on this Asia/Manila day, including cancellation refunds, capped at each confirmed sale value. Excludes Buyer processing fees, late-capture compensation and pending or failed refunds. Null without finance.view. Not grouped by refund payout date. | [optional]
**cancellationDeductionsCentavos** | **int** | Cancelled confirmed order value not already included in refunds_centavos, grouped by first confirmation day. Gross sales minus refunds minus these other cancellation deductions equals net sales (displayed as Earnings). Null without finance.view. | [optional]
**salesAverageCentavos** | **int** |  | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


