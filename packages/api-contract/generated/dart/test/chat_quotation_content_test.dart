import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for ChatQuotationContent
void main() {
  final instance = ChatQuotationContentBuilder();
  // TODO add properties to the builder and call build()

  group(ChatQuotationContent, () {
    // Optional Vendor message frozen with this published quotation version.
    // String message
    test('to test the property `message`', () async {
      // TODO
    });

    // ChatQuotationDiscountAssessment discount
    test('to test the property `discount`', () async {
      // TODO
    });

    // BuiltList<ChatQuotationLine> lines
    test('to test the property `lines`', () async {
      // TODO
    });

    // ChatQuotationMoney commercial
    test('to test the property `commercial`', () async {
      // TODO
    });

    // String fulfillmentMethod
    test('to test the property `fulfillmentMethod`', () async {
      // TODO
    });

    // Historical Vendor preference only. New quotations omit it; the Buyer chooses at acceptance.
    // String paymentMethod
    test('to test the property `paymentMethod`', () async {
      // TODO
    });

    // String fulfillmentDate
    test('to test the property `fulfillmentDate`', () async {
      // TODO
    });

    // Frozen intended destination, heavy-vehicle restriction, alternate drop-off and access instructions.
    // BuiltMap<String, JsonObject> destination
    test('to test the property `destination`', () async {
      // TODO
    });

    // BuiltMap<String, JsonObject> delivery
    test('to test the property `delivery`', () async {
      // TODO
    });

    // BuiltMap<String, JsonObject> nrpc
    test('to test the property `nrpc`', () async {
      // TODO
    });

    // BuiltList<ChatQuotationChange> changes
    test('to test the property `changes`', () async {
      // TODO
    });

    // BuiltList<ChatQuotationChange> originalChanges
    test('to test the property `originalChanges`', () async {
      // TODO
    });

    // String priceSource
    test('to test the property `priceSource`', () async {
      // TODO
    });

    // String processingFeeStatus
    test('to test the property `processingFeeStatus`', () async {
      // TODO
    });

  });
}
