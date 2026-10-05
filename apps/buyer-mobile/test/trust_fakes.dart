import 'package:materyalph/features/map_discovery/discovery_models.dart';
import 'package:materyalph/features/trust/analytics_repository.dart';
import 'package:materyalph/features/trust/reviews_repository.dart';
import 'package:materyalph/features/trust/trust_models.dart';

/// Scripted Phase 14 fakes: Materials Analytics pages/details/offers and verified-purchase reviews.
class FakeAnalyticsRepository implements AnalyticsRepository {
  MaterialsAnalyticsPage? page;
  MaterialPriceDetailsView? detail;
  List<MaterialOfferView> currentOffers = const [];
  Object? failure;
  final List<String> calls = [];
  final List<AnalyticsWindowChoice> windows = [];
  final List<int> radii = [];

  @override
  Future<MaterialsAnalyticsPage> list({
    required DiscoveryOrigin origin,
    required int radiusKm,
    required AnalyticsWindowChoice window,
    String? query,
    String? cursor,
  }) async {
    calls.add('list');
    windows.add(window);
    radii.add(radiusKm);
    if (failure != null) throw failure!;
    return page!;
  }

  @override
  Future<MaterialPriceDetailsView> details({
    required String groupId,
    required DiscoveryOrigin origin,
    required int radiusKm,
    required AnalyticsWindowChoice window,
  }) async {
    calls.add('details:$groupId');
    if (failure != null) throw failure!;
    return detail!;
  }

  @override
  Future<List<MaterialOfferView>> offers({
    required String groupId,
    required DiscoveryOrigin origin,
    required int radiusKm,
  }) async {
    calls.add('offers:$groupId');
    return currentOffers;
  }
}

class FakeReviewsRepository implements ReviewsRepository {
  OrderReviewsView? order;
  ListingReviewsView listing = const ListingReviewsView(
    average: null,
    count: 0,
    items: [],
  );
  final List<Map<String, Object?>> submissions = [];
  final List<String> reports = [];
  Object? failure;

  @override
  Future<OrderReviewsView> orderReviews(String orderId) async {
    if (failure != null) throw failure!;
    return order!;
  }

  @override
  Future<OrderReviewsView> submit({
    required String orderId,
    required String displayChoice,
    ({int service, int speed, String? comment})? vendorRating,
    List<({String orderLineId, int rating, String? comment})> productReviews =
        const [],
    required String idempotencyKey,
  }) async {
    submissions.add({
      'choice': displayChoice,
      'vendor': vendorRating,
      'products': productReviews,
    });
    return order!;
  }

  @override
  Future<OrderReviewsView> edit({
    required String reviewId,
    required int lockVersion,
    int? serviceQuality,
    int? speedRating,
    int? productQuality,
    String? comment,
  }) async => order!;

  @override
  Future<ListingReviewsView> listingReviews(String listingId) async => listing;

  @override
  Future<void> report({
    required String reviewId,
    required String reasonCode,
    String? details,
    required String idempotencyKey,
  }) async => reports.add('$reviewId:$reasonCode');
}
