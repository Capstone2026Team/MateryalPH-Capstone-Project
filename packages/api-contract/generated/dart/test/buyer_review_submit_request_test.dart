import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for BuyerReviewSubmitRequest
void main() {
  final instance = BuyerReviewSubmitRequestBuilder();
  // TODO add properties to the builder and call build()

  group(BuyerReviewSubmitRequest, () {
    // Deprecated compatibility field; FULL_NAME is always used. Legacy choices are accepted from older clients but cannot hide identity.
    // String displayNameChoice (default value: 'FULL_NAME')
    test('to test the property `displayNameChoice`', () async {
      // TODO
    });

    // BuyerReviewSubmitRequestVendorRating vendorRating
    test('to test the property `vendorRating`', () async {
      // TODO
    });

    // BuiltList<BuyerReviewSubmitRequestProductReviewsInner> productReviews
    test('to test the property `productReviews`', () async {
      // TODO
    });

  });
}
