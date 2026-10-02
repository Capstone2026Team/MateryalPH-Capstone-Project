# materyalph_api_client.model.OrderSummary

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  |
**reference** | **String** |  |
**vendor** | [**OrderVendorRef**](OrderVendorRef.md) |  |
**submittedAt** | [**DateTime**](DateTime.md) |  |
**procurementType** | **String** |  |
**confirmationSource** | **String** |  |
**states** | [**BuiltList&lt;OrderStateRow&gt;**](OrderStateRow.md) |  |
**fulfillmentMethod** | **String** |  |
**paymentMethod** | **String** |  |
**lineCount** | **int** |  |
**firstLine** | [**OrderFirstLine**](OrderFirstLine.md) |  |
**materialsCentavos** | **int** |  |
**deliveryCentavos** | **int** |  |
**commercialTotalCentavos** | **int** |  |
**deliveryPending** | **bool** |  |
**deadline** | [**OrderDeadline**](OrderDeadline.md) |  |
**expectedFulfillmentDate** | [**Date**](Date.md) |  |
**nextAction** | **String** |  | [optional]
**paymentRetryable** | **bool** | Buyer list only. True when the order is Pending Payment and its latest checkout attempt failed or expired. Retry uses the same order and principal. | [optional]
**buyer** | [**OrderBuyerRef**](OrderBuyerRef.md) |  | [optional]
**primaryAction** | [**VendorOrderPrimaryAction**](VendorOrderPrimaryAction.md) |  | [optional]
**nrpcIndicator** | **bool** |  | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


