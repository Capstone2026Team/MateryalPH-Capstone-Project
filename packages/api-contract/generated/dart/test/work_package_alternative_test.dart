import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for WorkPackageAlternative
void main() {
  final instance = WorkPackageAlternativeBuilder();
  // TODO add properties to the builder and call build()

  group(WorkPackageAlternative, () {
    // String listingId
    test('to test the property `listingId`', () async {
      // TODO
    });

    // String variantId
    test('to test the property `variantId`', () async {
      // TODO
    });

    // String priceVersionId
    test('to test the property `priceVersionId`', () async {
      // TODO
    });

    // String displayName
    test('to test the property `displayName`', () async {
      // TODO
    });

    // String variantLabel
    test('to test the property `variantLabel`', () async {
      // TODO
    });

    // String brand
    test('to test the property `brand`', () async {
      // TODO
    });

    // String vendorId
    test('to test the property `vendorId`', () async {
      // TODO
    });

    // String storeName
    test('to test the property `storeName`', () async {
      // TODO
    });

    // First public photo of the listing. The server returns an object ({url, alt_text}); declaring it as a string made the generated client reject any page containing a photographed offer, which surfaced as a generic 'Something went wrong' instead of the recommendations.
    // ListingImage image
    test('to test the property `image`', () async {
      // TODO
    });

    // int unitPriceCentavos
    test('to test the property `unitPriceCentavos`', () async {
      // TODO
    });

    // String unitCode
    test('to test the property `unitCode`', () async {
      // TODO
    });

    // int unitPrecision
    test('to test the property `unitPrecision`', () async {
      // TODO
    });

    // int distanceMeters
    test('to test the property `distanceMeters`', () async {
      // TODO
    });

    // Availability label only; exact inventory is never returned.
    // String stockLabel
    test('to test the property `stockLabel`', () async {
      // TODO
    });

    // Listing and variant details as the category names them.
    // BuiltList<ProjectSpecificationDetail> specifications
    test('to test the property `specifications`', () async {
      // TODO
    });

    // Brand (when set) and every stated specification match the Work Package line.
    // bool exactMatch
    test('to test the property `exactMatch`', () async {
      // TODO
    });

    // Whether the store can confirm the whole quantity still needed. PARTIAL stores can be added with `allow_partial_stock` for what they can confirm.
    // String availability
    test('to test the property `availability`', () async {
      // TODO
    });

    // Unit price times the quantity still needed.
    // int estimatedTotalCentavos
    test('to test the property `estimatedTotalCentavos`', () async {
      // TODO
    });

    // Methods the store can serve for this product. Ready-mixed concrete uses DELIVERY only even when the primary quotation or package uses PICKUP.
    // BuiltList<String> fulfillmentMethods
    test('to test the property `fulfillmentMethods`', () async {
      // TODO
    });

    // This product is already in the cart or an open order for the line; adding it again never stacks the quantity.
    // bool alreadyAdded
    test('to test the property `alreadyAdded`', () async {
      // TODO
    });

  });
}
