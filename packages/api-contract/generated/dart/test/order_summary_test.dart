import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for OrderSummary
void main() {
  final instance = OrderSummaryBuilder();
  // TODO add properties to the builder and call build()

  group(OrderSummary, () {
    // String id
    test('to test the property `id`', () async {
      // TODO
    });

    // String reference
    test('to test the property `reference`', () async {
      // TODO
    });

    // OrderVendorRef vendor
    test('to test the property `vendor`', () async {
      // TODO
    });

    // DateTime submittedAt
    test('to test the property `submittedAt`', () async {
      // TODO
    });

    // String procurementType
    test('to test the property `procurementType`', () async {
      // TODO
    });

    // String confirmationSource
    test('to test the property `confirmationSource`', () async {
      // TODO
    });

    // BuiltList<OrderStateRow> states
    test('to test the property `states`', () async {
      // TODO
    });

    // String fulfillmentMethod
    test('to test the property `fulfillmentMethod`', () async {
      // TODO
    });

    // String paymentMethod
    test('to test the property `paymentMethod`', () async {
      // TODO
    });

    // int lineCount
    test('to test the property `lineCount`', () async {
      // TODO
    });

    // OrderFirstLine firstLine
    test('to test the property `firstLine`', () async {
      // TODO
    });

    // int materialsCentavos
    test('to test the property `materialsCentavos`', () async {
      // TODO
    });

    // int deliveryCentavos
    test('to test the property `deliveryCentavos`', () async {
      // TODO
    });

    // int commercialTotalCentavos
    test('to test the property `commercialTotalCentavos`', () async {
      // TODO
    });

    // bool deliveryPending
    test('to test the property `deliveryPending`', () async {
      // TODO
    });

    // OrderDeadline deadline
    test('to test the property `deadline`', () async {
      // TODO
    });

    // Date expectedFulfillmentDate
    test('to test the property `expectedFulfillmentDate`', () async {
      // TODO
    });

    // String nextAction
    test('to test the property `nextAction`', () async {
      // TODO
    });

    // Buyer list only. True when the order is Pending Payment and its latest checkout attempt failed or expired. Retry uses the same order and principal.
    // bool paymentRetryable
    test('to test the property `paymentRetryable`', () async {
      // TODO
    });

    // Buyer list only. The order's Fulfillment Messages thread; null only for an order submitted before threads opened at submission.
    // OrderConversationRef fulfillmentConversation
    test('to test the property `fulfillmentConversation`', () async {
      // TODO
    });

    // Buyer list only. Card shortcuts, each also allowed in Order Details: CONFIRM_RECEIPT and REPORT_PROBLEM while awaiting receipt, FILE_DISPUTE (Return/Refund) or VIEW_DISPUTE after completion, BUY_AGAIN for closed Item-Based orders, VIEW_CANCELLATION for cancelled, declined or expired orders.
    // BuiltList<String> cardActions
    test('to test the property `cardActions`', () async {
      // TODO
    });

    // Buyer list only. End of the post-completion return and dispute window while FILE_DISPUTE is offered.
    // DateTime returnRefundDueAt
    test('to test the property `returnRefundDueAt`', () async {
      // TODO
    });

    // Buyer list only. The active case when VIEW_DISPUTE is offered.
    // String disputeCaseId
    test('to test the property `disputeCaseId`', () async {
      // TODO
    });

    // Buyer list only. Display name of the channel of the latest verified online payment.
    // String paymentChannelName
    test('to test the property `paymentChannelName`', () async {
      // TODO
    });

    // Buyer list only. Why a cancelled, declined or expired order ended, in Buyer-facing words.
    // OrderClosureReason closureReason
    test('to test the property `closureReason`', () async {
      // TODO
    });

    // OrderBuyerRef buyer
    test('to test the property `buyer`', () async {
      // TODO
    });

    // VendorOrderPrimaryAction primaryAction
    test('to test the property `primaryAction`', () async {
      // TODO
    });

    // bool nrpcIndicator
    test('to test the property `nrpcIndicator`', () async {
      // TODO
    });

  });
}
