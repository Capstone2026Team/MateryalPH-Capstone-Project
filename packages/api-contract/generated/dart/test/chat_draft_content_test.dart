import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for ChatDraftContent
void main() {
  final instance = ChatDraftContentBuilder();
  // TODO add properties to the builder and call build()

  group(ChatDraftContent, () {
    // Optional message to the Buyer, published with the quotation.
    // String message
    test('to test the property `message`', () async {
      // TODO
    });

    // BuiltList<ChatDraftLine> lines
    test('to test the property `lines`', () async {
      // TODO
    });

    // String fulfillmentMethod
    test('to test the property `fulfillmentMethod`', () async {
      // TODO
    });

    // Legacy editor preference, ignored. The Buyer selects payment before accepting the quotation.
    // String paymentMethod
    test('to test the property `paymentMethod`', () async {
      // TODO
    });

    // May be empty in an autosaved draft; a current or future date is required for publication.
    // String fulfillmentDate
    test('to test the property `fulfillmentDate`', () async {
      // TODO
    });

    // int deadlineHours (default value: 24)
    test('to test the property `deadlineHours`', () async {
      // TODO
    });

    // Legacy fixed materials discount. Omit when discount is supplied.
    // int vendorDiscountCentavos
    test('to test the property `vendorDiscountCentavos`', () async {
      // TODO
    });

    // ChatQuotationDiscount discount
    test('to test the property `discount`', () async {
      // TODO
    });

    // ChatQuotationDestination destination
    test('to test the property `destination`', () async {
      // TODO
    });

    // Vehicles, counts, trips, arrangement and access confirmations. Set fee_override to true with a 10-2000 character change_reason to propose a manual gross fee; eligibility, route and capacity checks still apply.
    // BuiltMap<String, JsonObject> delivery
    test('to test the property `delivery`', () async {
      // TODO
    });

    // Historical drafts only. Omit when saving; new quotation NRPC is prohibited.
    // BuiltMap<String, JsonObject> nrpc
    test('to test the property `nrpc`', () async {
      // TODO
    });

  });
}
