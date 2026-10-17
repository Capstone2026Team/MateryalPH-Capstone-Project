import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for VendorReviewsApi
void main() {
  final instance = MateryalphApiClient().getVendorReviewsApi();

  group(VendorReviewsApi, () {
    // reviews.rate_buyer. Correct your store's Buyer rating within 24 hours.
    //
    //Future<VendorOrderReviewsEnvelope> editVendorBuyerRating(String reviewId, VendorReviewEditRequest vendorReviewEditRequest) async
    test('test editVendorBuyerRating', () async {
      // TODO
    });

    // reviews.view. The order's rating window; Buyer ratings appear only after the blind reveal.
    //
    //Future<VendorOrderReviewsEnvelope> getVendorOrderReviews(String orderId) async
    test('test getVendorOrderReviews', () async {
      // TODO
    });

    // reviews.view. Read one review belonging to the current store with its privacy-safe author, immutable purchased-product snapshot, rating, comment and authorized media links. Received reviews must still satisfy blind reveal, dispute withholding, moderation and score-exclusion visibility. The store may also read its own Buyer ratings. Foreign and unavailable reviews return 404.
    //
    //Future<VendorReviewEnvelope> getVendorReview(String reviewId) async
    test('test getVendorReview', () async {
      // TODO
    });

    // Photo of a visible review of your store behind a signed link.
    //
    //Future<Uint8List> getVendorReviewPhoto(String reviewId, String mediaId, int expires, String signature) async
    test('test getVendorReviewPhoto', () async {
      // TODO
    });

    // reviews.view (Owner, Store Manager, Store Staff, Customer Service). Visible received Vendor ratings or Product Reviews, or your store's Buyer ratings. Optional listing_id restricts PRODUCT reviews to a listing owned by the current store. PRODUCT results include a rating summary of every visible review matching the product and date filters, calculated before pagination. There is no delete operation.
    //
    //Future<VendorReviewListEnvelope> listVendorReviews({ String type, String listingId, int page, Date from, Date to }) async
    test('test listVendorReviews', () async {
      // TODO
    });

    // reviews.report. Report a review of your store; a Vendor can never remove a Buyer review.
    //
    //Future<ReviewReportedEnvelope> reportVendorReview(String reviewId, String idempotencyKey, ReviewFlagRequest reviewFlagRequest) async
    test('test reportVendorReview', () async {
      // TODO
    });

    // reviews.rate_buyer (Owner, Store Manager, Store Staff, Customer Service): Inquiry Seriousness, Communication Quality and Payment Reliability (CCS inputs).
    //
    //Future<VendorOrderReviewsEnvelope> submitVendorBuyerRating(String orderId, String idempotencyKey, VendorBuyerRatingRequest vendorBuyerRatingRequest) async
    test('test submitVendorBuyerRating', () async {
      // TODO
    });

  });
}
