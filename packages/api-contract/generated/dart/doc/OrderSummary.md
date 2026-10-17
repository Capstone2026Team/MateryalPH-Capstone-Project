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
**fulfillmentConversation** | [**OrderConversationRef**](OrderConversationRef.md) | Buyer list only. The order's Fulfillment Messages thread; null only for an order submitted before threads opened at submission. | [optional]
**cardActions** | **BuiltList&lt;String&gt;** | Buyer list only. Card shortcuts, each also allowed in Order Details: CONFIRM_RECEIPT and REPORT_PROBLEM while awaiting receipt, FILE_DISPUTE (Return/Refund) or VIEW_DISPUTE after completion, BUY_AGAIN for closed Item-Based orders, VIEW_CANCELLATION for cancelled, declined or expired orders. | [optional]
**returnRefundDueAt** | [**DateTime**](DateTime.md) | Buyer list only. End of the post-completion return and dispute window while FILE_DISPUTE is offered. | [optional]
**disputeCaseId** | **String** | Buyer list only. The active case when VIEW_DISPUTE is offered. | [optional]
**paymentChannelName** | **String** | Buyer list only. Display name of the channel of the latest verified online payment. | [optional]
**closureReason** | [**OrderClosureReason**](OrderClosureReason.md) | Buyer list only. Why a cancelled, declined or expired order ended, in Buyer-facing words. | [optional]
**buyer** | [**OrderBuyerRef**](OrderBuyerRef.md) |  | [optional]
**primaryAction** | [**VendorOrderPrimaryAction**](VendorOrderPrimaryAction.md) |  | [optional]
**nrpcIndicator** | **bool** |  | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


