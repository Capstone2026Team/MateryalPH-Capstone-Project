import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for CartItemCreate
void main() {
  final instance = CartItemCreateBuilder();
  // TODO add properties to the builder and call build()

  group(CartItemCreate, () {
    // String listingVariantId
    test('to test the property `listingVariantId`', () async {
      // TODO
    });

    // The price version shown to the Buyer; a newer one returns 409 PRICE_CHANGED.
    // String expectedPriceVersionId
    test('to test the property `expectedPriceVersionId`', () async {
      // TODO
    });

    // String quantity
    test('to test the property `quantity`', () async {
      // TODO
    });

    // String fulfillmentMethod
    test('to test the property `fulfillmentMethod`', () async {
      // TODO
    });

    // String locationId
    test('to test the property `locationId`', () async {
      // TODO
    });

    // double latitude
    test('to test the property `latitude`', () async {
      // TODO
    });

    // double longitude
    test('to test the property `longitude`', () async {
      // TODO
    });

    // String originSource
    test('to test the property `originSource`', () async {
      // TODO
    });

    // int radiusKm
    test('to test the property `radiusKm`', () async {
      // TODO
    });

    // Work Package line this purchase covers; same material and unit only (422 MISSING_LINE_TAG_INVALID), at most the line quantity (422 TAGGED_QUANTITY_EXCEEDS_REQUIREMENT). The server scopes it from the package site at the fixed 50 km Project-Based radius, ignoring any radius_km sent. It never stacks: adding the same product again keeps the larger quantity.
    // String workPackageLineId
    test('to test the property `workPackageLineId`', () async {
      // TODO
    });

    // With work_package_line_id: add what the store can confirm when it holds less than quantity, instead of failing with QUANTITY_UNAVAILABLE.
    // bool allowPartialStock
    test('to test the property `allowPartialStock`', () async {
      // TODO
    });

  });
}
