import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for VendorEarningsBreakdownPhysical
void main() {
  final instance = VendorEarningsBreakdownPhysicalBuilder();
  // TODO add properties to the builder and call build()

  group(VendorEarningsBreakdownPhysical, () {
    // int records
    test('to test the property `records`', () async {
      // TODO
    });

    // int cashOnDeliveryCentavos
    test('to test the property `cashOnDeliveryCentavos`', () async {
      // TODO
    });

    // int inStoreCentavos
    test('to test the property `inStoreCentavos`', () async {
      // TODO
    });

    // Not a collection and not part of physical_collections_centavos: the cash still owed on Cash on Delivery and In-Store orders already delivered or picked up, for the same orders and dates as commercial sales. It falls as the Vendor records or confirms the cash.
    // int unrecordedCentavos
    test('to test the property `unrecordedCentavos`', () async {
      // TODO
    });

    // int unrecordedOrders
    test('to test the property `unrecordedOrders`', () async {
      // TODO
    });

  });
}
