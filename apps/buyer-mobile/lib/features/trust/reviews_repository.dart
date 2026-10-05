import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

import '../../core/api_guard.dart';
import 'trust_models.dart';

/// Verified-purchase reviews for the Buyer's own completed orders, public listing reviews and Report
/// Review — all through `/api/v1`. Nothing here deletes a review.
abstract interface class ReviewsRepository {
  Future<OrderReviewsView> orderReviews(String orderId);

  Future<OrderReviewsView> submit({
    required String orderId,
    required String displayChoice,
    ({int service, int speed, String? comment})? vendorRating,
    List<({String orderLineId, int rating, String? comment})> productReviews,
    required String idempotencyKey,
  });

  Future<OrderReviewsView> edit({
    required String reviewId,
    required int lockVersion,
    int? serviceQuality,
    int? speedRating,
    int? productQuality,
    String? comment,
  });

  Future<ListingReviewsView> listingReviews(String listingId);

  Future<void> report({
    required String reviewId,
    required String reasonCode,
    String? details,
    required String idempotencyKey,
  });
}

final class ApiReviewsRepository implements ReviewsRepository {
  ApiReviewsRepository({
    required api.MateryalphApiClient client,
    required ApiGuard guard,
  }) : _client = client,
       _api = guard;

  final api.MateryalphApiClient _client;
  final ApiGuard _api;

  api.BuyerReviewsApi get _reviews => _client.getBuyerReviewsApi();

  @override
  Future<OrderReviewsView> orderReviews(String orderId) => _api(() async {
    final response = await _reviews.getBuyerOrderReviews(orderId: orderId);
    return _order(_api.required(response.data?.data));
  });

  @override
  Future<OrderReviewsView> submit({
    required String orderId,
    required String displayChoice,
    ({int service, int speed, String? comment})? vendorRating,
    List<({String orderLineId, int rating, String? comment})> productReviews =
        const [],
    required String idempotencyKey,
  }) => _api(() async {
    final response = await _reviews.submitBuyerOrderReviews(
      orderId: orderId,
      idempotencyKey: idempotencyKey,
      buyerReviewSubmitRequest: api.BuyerReviewSubmitRequest(
        (b) => b
          ..displayNameChoice =
              api.BuyerReviewSubmitRequestDisplayNameChoiceEnum.valueOf(
                displayChoice,
              )
          ..vendorRating = vendorRating == null
              ? null
              : (api.BuyerReviewSubmitRequestVendorRatingBuilder()
                  ..serviceQuality = vendorRating.service
                  ..speedRating = vendorRating.speed
                  ..comment = vendorRating.comment)
          ..productReviews = ListBuilder(
            productReviews.map(
              (review) => api.BuyerReviewSubmitRequestProductReviewsInner(
                (line) => line
                  ..orderLineId = review.orderLineId
                  ..rating = review.rating
                  ..comment = review.comment,
              ),
            ),
          ),
      ),
    );
    return _order(_api.required(response.data?.data));
  });

  @override
  Future<OrderReviewsView> edit({
    required String reviewId,
    required int lockVersion,
    int? serviceQuality,
    int? speedRating,
    int? productQuality,
    String? comment,
  }) => _api(() async {
    final response = await _reviews.editBuyerReview(
      reviewId: reviewId,
      buyerReviewEditRequest: api.BuyerReviewEditRequest(
        (b) => b
          ..lockVersion = lockVersion
          ..serviceQuality = serviceQuality
          ..speedRating = speedRating
          ..rating = productQuality
          ..comment = comment,
      ),
    );
    return _order(_api.required(response.data?.data));
  });

  @override
  Future<ListingReviewsView> listingReviews(String listingId) => _api(() async {
    final response = await _reviews.listListingReviews(listingId: listingId);
    final envelope = _api.required(response.data);
    final summary = envelope.meta.summary?.asMap() ?? const {};
    return ListingReviewsView(
      average: summary['average']?.value.toString(),
      count: int.tryParse('${summary['count']?.value ?? 0}') ?? 0,
      items: envelope.data
          .map(
            (review) => PublicReviewView(
              id: review.id,
              ratings: _ratings(review.ratings),
              comment: review.comment,
              displayName: review.displayName,
              edited: review.edited,
              variantLabel: review.variantLabel,
              submittedAt: review.submittedAt,
            ),
          )
          .toList(growable: false),
    );
  });

  @override
  Future<void> report({
    required String reviewId,
    required String reasonCode,
    String? details,
    required String idempotencyKey,
  }) => _api(() async {
    await _reviews.reportBuyerReview(
      reviewId: reviewId,
      idempotencyKey: idempotencyKey,
      reviewFlagRequest: api.ReviewFlagRequest(
        (b) => b
          ..reasonCode = api.ReviewFlagRequestReasonCodeEnum.valueOf(reasonCode)
          ..details = details,
      ),
    );
  });

  static ReviewRatingsView _ratings(api.ReviewRatings ratings) =>
      ReviewRatingsView(
        serviceQuality: ratings.serviceQuality,
        speedRating: ratings.speedRating,
        speedKind: ratings.speedKind?.name,
        productQuality: ratings.productQuality,
        inquirySeriousness: ratings.inquirySeriousness,
        communicationQuality: ratings.communicationQuality,
        paymentReliability: ratings.paymentReliability,
      );

  static OwnReviewView? _own(api.OwnReview? review) => review == null
      ? null
      : OwnReviewView(
          id: review.id,
          ratings: _ratings(review.ratings),
          comment: review.comment,
          displayName: review.displayName,
          canEdit: review.canEdit,
          correctionRequested: review.correctionRequested,
          visibility: review.visibility.name,
          lockVersion: review.lockVersion,
          editableUntilLabel: review.editableUntilLabel,
        );

  static OrderReviewsView _order(api.BuyerOrderReviews data) =>
      OrderReviewsView(
        orderId: data.orderId,
        orderReference: data.orderReference,
        state: data.state.name,
        closesAtLabel: data.closesAtLabel,
        revealed: data.revealed,
        withheldForDispute: data.withheldForDispute,
        blindRevealText: data.rules.blindReveal,
        speedLabel: data.speedLabel,
        displayOptions: data.displayNameOptions
            .map(
              (option) => (choice: option.choice.name, preview: option.preview),
            )
            .toList(growable: false),
        vendorRating: _own(data.vendorRating),
        canSubmitVendorRating: data.canSubmitVendorRating,
        lines: data.lines
            .map(
              (line) => ReviewLineView(
                orderLineId: line.orderLineId,
                listingId: line.listingId,
                displayName: line.displayName,
                variantLabel: line.variantLabel,
                review: _own(line.review),
                canReview: line.canReview,
              ),
            )
            .toList(growable: false),
        counterpartRating: data.counterpartRating == null
            ? null
            : _ratings(data.counterpartRating!.ratings),
      );
}
