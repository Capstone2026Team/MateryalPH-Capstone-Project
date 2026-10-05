import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for BuyerReviewsApi
void main() {
  final instance = MateryalphApiClient().getBuyerReviewsApi();

  group(BuyerReviewsApi, () {
    // Up to three photos on your Product Review while it can still be edited.
    //
    //Future<BuyerOrderReviewsEnvelope> addBuyerReviewMedia(String reviewId, String idempotencyKey, BuiltList<MultipartFile> files) async
    test('test addBuyerReviewMedia', () async {
      // TODO
    });

    // Correct your review within 24 hours of submitting (409 REVIEW_LOCKED at the exact instant), or once within 7 days after an Admin requests a correction.
    //
    //Future<BuyerOrderReviewsEnvelope> editBuyerReview(String reviewId, BuyerReviewEditRequest buyerReviewEditRequest) async
    test('test editBuyerReview', () async {
      // TODO
    });

    // Rating eligibility, the exact 14-day deadline (with its Asia/Manila label), your submissions and, after the blind reveal, the Vendor's rating of you.
    //
    //Future<BuyerOrderReviewsEnvelope> getBuyerOrderReviews(String orderId) async
    test('test getBuyerOrderReviews', () async {
      // TODO
    });

    // Photo behind a five-minute signed link; re-authorized on every fetch.
    //
    //Future<Uint8List> getBuyerReviewPhoto(String reviewId, String mediaId, int expires, String signature) async
    test('test getBuyerReviewPhoto', () async {
      // TODO
    });

    // Visible Product Reviews of one listing with its own product average (separate from the Vendor's MQS).
    //
    //Future<PublicReviewListEnvelope> listListingReviews(String listingId, { int page }) async
    test('test listListingReviews', () async {
      // TODO
    });

    // Visible Vendor ratings, published scores (or New Vendor — Building Track Record) and active badges.
    //
    //Future<PublicReviewListEnvelope> listStoreReviews(String vendorId, { int page }) async
    test('test listStoreReviews', () async {
      // TODO
    });

    // Remove one of your photos while the review can still be edited (retired, not erased from history).
    //
    //Future<BuyerOrderReviewsEnvelope> removeBuyerReviewMedia(String reviewId, String mediaId) async
    test('test removeBuyerReviewMedia', () async {
      // TODO
    });

    // Report a public review for moderation. Nothing is hidden or deleted by a report.
    //
    //Future<ReviewReportedEnvelope> reportBuyerReview(String reviewId, String idempotencyKey, ReviewFlagRequest reviewFlagRequest) async
    test('test reportBuyerReview', () async {
      // TODO
    });

    // Rate the Vendor (Service Quality and Delivery or Processing Speed) and purchased lines (Product Quality). 409 REVIEW_NOT_ELIGIBLE before COMPLETED, REVIEW_WINDOW_CLOSED at 14 days, REVIEW_ALREADY_SUBMITTED for a repeat.
    //
    //Future<BuyerOrderReviewsEnvelope> submitBuyerOrderReviews(String orderId, String idempotencyKey, BuyerReviewSubmitRequest buyerReviewSubmitRequest) async
    test('test submitBuyerOrderReviews', () async {
      // TODO
    });

  });
}
