import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for CheckoutSubmitRequest
void main() {
  final instance = CheckoutSubmitRequestBuilder();
  // TODO add properties to the builder and call build()

  group(CheckoutSubmitRequest, () {
    // int cartLockVersion
    test('to test the property `cartLockVersion`', () async {
      // TODO
    });

    // BuiltSet<String> vendorIds
    test('to test the property `vendorIds`', () async {
      // TODO
    });

    // Required when fewer Vendor groups are submitted than the cart holds.
    // bool splitConfirmed
    test('to test the property `splitConfirmed`', () async {
      // TODO
    });

    // Vendor id => chosen method; Online when omitted. COD pairs with Site Delivery, In-Store with Self-Pickup, each only when the Vendor enabled it.
    // BuiltMap<String, String> paymentMethods
    test('to test the property `paymentMethods`', () async {
      // TODO
    });

  });
}
