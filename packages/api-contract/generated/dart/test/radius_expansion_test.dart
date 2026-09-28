import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for RadiusExpansion
void main() {
  final instance = RadiusExpansionBuilder();
  // TODO add properties to the builder and call build()

  group(RadiusExpansion, () {
    // int eligibleVerifiedCount
    test('to test the property `eligibleVerifiedCount`', () async {
      // TODO
    });

    // The next allowed radius (10, 20, 30, 40 or 50), or null at 50 km or with three or more Verified Vendors.
    // int suggestedRadiusKm
    test('to test the property `suggestedRadiusKm`', () async {
      // TODO
    });

    // bool atMaximum
    test('to test the property `atMaximum`', () async {
      // TODO
    });

    // FEWER_THAN_THREE_VERIFIED_VENDORS or null.
    // String reason
    test('to test the property `reason`', () async {
      // TODO
    });

    // Always true; clients ask before changing the radius.
    // bool requiresConfirmation
    test('to test the property `requiresConfirmation`', () async {
      // TODO
    });

  });
}
