import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for VendorReviewRow
void main() {
  final instance = VendorReviewRowBuilder();
  // TODO add properties to the builder and call build()

  group(VendorReviewRow, () {
    // Five-minute signed review-scoped Buyer photo URL, including for legacy reviews now shown with full identity. Null for store-authored Buyer ratings or missing photos. Fetch with the current Vendor session; never use a private storage URL.
    // String buyerAvatarUrl
    test('to test the property `buyerAvatarUrl`', () async {
      // TODO
    });

    // String id
    test('to test the property `id`', () async {
      // TODO
    });

    // String type
    test('to test the property `type`', () async {
      // TODO
    });

    // ReviewRatings ratings
    test('to test the property `ratings`', () async {
      // TODO
    });

    // String comment
    test('to test the property `comment`', () async {
      // TODO
    });

    // String displayName
    test('to test the property `displayName`', () async {
      // TODO
    });

    // bool verifiedPurchase
    test('to test the property `verifiedPurchase`', () async {
      // TODO
    });

    // DateTime submittedAt
    test('to test the property `submittedAt`', () async {
      // TODO
    });

    // bool edited
    test('to test the property `edited`', () async {
      // TODO
    });

    // String variantLabel
    test('to test the property `variantLabel`', () async {
      // TODO
    });

    // Purchased-product identity from the immutable order line snapshot; null for Store and Buyer ratings.
    // ReviewProduct product
    test('to test the property `product`', () async {
      // TODO
    });

    // BuiltList<ReviewMediaLink> media
    test('to test the property `media`', () async {
      // TODO
    });

    // String visibility
    test('to test the property `visibility`', () async {
      // TODO
    });

    // String orderId
    test('to test the property `orderId`', () async {
      // TODO
    });

    // String orderReference
    test('to test the property `orderReference`', () async {
      // TODO
    });

    // bool canReport
    test('to test the property `canReport`', () async {
      // TODO
    });

  });
}
