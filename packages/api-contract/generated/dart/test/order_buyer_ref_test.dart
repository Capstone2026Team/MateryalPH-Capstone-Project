import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for OrderBuyerRef
void main() {
  final instance = OrderBuyerRefBuilder();
  // TODO add properties to the builder and call build()

  group(OrderBuyerRef, () {
    // String displayName
    test('to test the property `displayName`', () async {
      // TODO
    });

    // Current Buyer phone for delivery coordination. Only Owner/Manager or current active assigned Fulfillment Staff on an accepted, open Site Delivery order receives it. Other roles and closed/pickup orders receive null.
    // String mobileE164
    test('to test the property `mobileE164`', () async {
      // TODO
    });

    // Authorized order-scoped API photo path with the Buyer profile version. Uses the same delivery-contact authorization as mobile_e164; never a public storage URL. Null when the Buyer has no photo or contact is unavailable.
    // String avatarPath
    test('to test the property `avatarPath`', () async {
      // TODO
    });

  });
}
