import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for ChatQuotationVersion
void main() {
  final instance = ChatQuotationVersionBuilder();
  // TODO add properties to the builder and call build()

  group(ChatQuotationVersion, () {
    // Buyer's exact recorded counter-offer for this version, retained after revision. Omitted when no changes were requested. Only visible to authorized conversation participants.
    // String requestedChanges
    test('to test the property `requestedChanges`', () async {
      // TODO
    });

    // UTC ISO 8601 timestamp of the recorded counter-offer for this version.
    // String changeRequestedAt
    test('to test the property `changeRequestedAt`', () async {
      // TODO
    });

    // Exact recorded UTC ISO 8601 deadline for the Vendor to revise and republish. Historical requests retain their original deadline; it is active only while the version is current and COUNTERED.
    // String vendorResponseDueAt
    test('to test the property `vendorResponseDueAt`', () async {
      // TODO
    });

    // Currently available Buyer choices for this quotation's fulfillment, subject to Vendor settings. Revalidated at acceptance.
    // BuiltSet<String> availablePaymentMethods
    test('to test the property `availablePaymentMethods`', () async {
      // TODO
    });

    // The Buyer's recorded method from the accepted order, including historical accepted quotations.
    // String selectedPaymentMethod
    test('to test the property `selectedPaymentMethod`', () async {
      // TODO
    });

    // String id
    test('to test the property `id`', () async {
      // TODO
    });

    // int version
    test('to test the property `version`', () async {
      // TODO
    });

    // bool latest
    test('to test the property `latest`', () async {
      // TODO
    });

    // String state
    test('to test the property `state`', () async {
      // TODO
    });

    // String publishedAt
    test('to test the property `publishedAt`', () async {
      // TODO
    });

    // String expiresAt
    test('to test the property `expiresAt`', () async {
      // TODO
    });

    // String contentHash
    test('to test the property `contentHash`', () async {
      // TODO
    });

    // ChatQuotationContent content
    test('to test the property `content`', () async {
      // TODO
    });

    // bool viewed
    test('to test the property `viewed`', () async {
      // TODO
    });

    // BuiltList<String> actions
    test('to test the property `actions`', () async {
      // TODO
    });

    // String quotationId
    test('to test the property `quotationId`', () async {
      // TODO
    });

    // String acceptedOrderId
    test('to test the property `acceptedOrderId`', () async {
      // TODO
    });

  });
}
