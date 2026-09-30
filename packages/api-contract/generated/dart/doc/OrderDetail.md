# materyalph_api_client.model.OrderDetail

## Load the model package
```dart
import 'package:materyalph_api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  |
**reference** | **String** |  |
**checkout** | [**OrderCheckoutRef**](OrderCheckoutRef.md) |  |
**vendor** | [**OrderVendorRef**](OrderVendorRef.md) |  |
**procurementType** | **String** |  |
**fulfillmentMethod** | **String** |  |
**paymentMethod** | **String** |  |
**submittedAt** | [**DateTime**](DateTime.md) |  |
**acceptedAt** | [**DateTime**](DateTime.md) |  |
**closedAt** | [**DateTime**](DateTime.md) |  |
**terminalReasonCode** | **String** |  |
**confirmationSource** | **String** |  |
**states** | [**BuiltList&lt;OrderStateRow&gt;**](OrderStateRow.md) |  |
**deadlines** | [**OrderDeadlines**](OrderDeadlines.md) |  |
**commercialVersion** | [**OrderCommercialVersion**](OrderCommercialVersion.md) |  |
**changes** | [**BuiltList&lt;OrderChange&gt;**](OrderChange.md) |  |
**expectedFulfillmentDate** | [**Date**](Date.md) |  |
**lines** | [**BuiltList&lt;OrderLine&gt;**](OrderLine.md) |  |
**destination** | [**OrderDestination**](OrderDestination.md) |  |
**delivery** | [**OrderDelivery**](OrderDelivery.md) |  |
**money** | [**MoneyBreakdown**](MoneyBreakdown.md) |  |
**nrpc** | [**OrderNrpc**](OrderNrpc.md) |  |
**timeline** | [**BuiltList&lt;OrderTimelineEvent&gt;**](OrderTimelineEvent.md) |  |
**lockVersion** | **int** |  |
**availableActions** | **BuiltList&lt;String&gt;** |  | [optional]
**payment** | [**OrderPaymentAvailability**](OrderPaymentAvailability.md) |  | [optional]
**buyer** | [**OrderBuyerRef**](OrderBuyerRef.md) |  | [optional]
**autoAccept** | [**AutoAcceptOutcome**](AutoAcceptOutcome.md) |  | [optional]
**reservations** | [**BuiltList&lt;OrderReservation&gt;**](OrderReservation.md) |  | [optional]
**permissions** | [**VendorOrderPermissions**](VendorOrderPermissions.md) |  | [optional]
**primaryAction** | [**VendorOrderPrimaryAction**](VendorOrderPrimaryAction.md) |  | [optional]
**nrpcTerms** | [**NrpcTermsRef**](NrpcTermsRef.md) |  | [optional]
**declineReasons** | [**BuiltList&lt;VendorOrderDeclineReason&gt;**](VendorOrderDeclineReason.md) |  | [optional]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


