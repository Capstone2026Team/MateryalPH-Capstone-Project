import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for VendorOrderConfirmRequest
void main() {
  final instance = VendorOrderConfirmRequestBuilder();
  // TODO add properties to the builder and call build()

  group(VendorOrderConfirmRequest, () {
    // int lockVersion
    test('to test the property `lockVersion`', () async {
      // TODO
    });

    // BuiltList<OrderLineQuantity> lines
    test('to test the property `lines`', () async {
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

    // Available only for COD or In-Store Payment orders awaiting Vendor confirmation.
    // NrpcProposal nrpc
    test('to test the property `nrpc`', () async {
      // TODO
    });

    // PickupConfirmation pickup
    test('to test the property `pickup`', () async {
      // TODO
    });

    // DeliveryConfirmation delivery
    test('to test the property `delivery`', () async {
      // TODO
    });

  });
}
