import 'dart:typed_data';
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
  final List<String?> categoryIds = [];
  final List<String?> queries = [];

  /// Applies [categoryId] to [page] the way the API's `category_id` filter does.
  @override
  Future<MaterialsAnalyticsPage> list({
    required DiscoveryOrigin origin,
    required int radiusKm,
    required AnalyticsWindowChoice window,
    String? query,
    String? categoryId,
    String? cursor,
    int? perPage,
  }) async {
    calls.add('list');
    windows.add(window);
    radii.add(radiusKm);
    categoryIds.add(categoryId);
    queries.add(query);
    if (failure != null) throw failure!;
    final result = page!;
    if (categoryId == null) return result;
    return MaterialsAnalyticsPage(
      envelope: result.envelope,
      items: result.items
          .where((item) => item.categoryId == categoryId)
          .toList(growable: false),
      nextCursor: result.nextCursor,
    );
  }

  AnalyticsProductsPage? productsPage;
  AnalyticsProductDetailView? productDetail;
  final List<String> productIds = [];

  /// Applies [categoryId] and [query] to [productsPage] the way the API filters do; the
  /// overview categories always cover the whole scope.
  @override
  Future<AnalyticsProductsPage> products({
    required DiscoveryOrigin origin,
    required int radiusKm,
    required AnalyticsWindowChoice window,
    String? query,
    String? categoryId,
    String? cursor,
  }) async {
    calls.add('products');
    windows.add(window);
    radii.add(radiusKm);
    categoryIds.add(categoryId);
    queries.add(query);
    if (failure != null) throw failure!;
    final page = productsPage!;
    final term = query?.toLowerCase();
    return AnalyticsProductsPage(
      envelope: page.envelope,
      categories: page.categories,
      items: page.items
          .where(
            (item) =>
                (categoryId == null || item.categoryId == categoryId) &&
                (term == null || item.name.toLowerCase().contains(term)),
          )
          .toList(growable: false),
      notYetComparable: page.notYetComparable,
      nextCursor: page.nextCursor,
    );
  }

  @override
  Future<AnalyticsProductDetailView> product({
    required String materialId,
    required DiscoveryOrigin origin,
    required int radiusKm,
    required AnalyticsWindowChoice window,
  }) async {
    calls.add('product:$materialId');
    productIds.add(materialId);
    windows.add(window);
    radii.add(radiusKm);
    if (failure != null) throw failure!;
    return productDetail!;
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
  Future<OrderReviewsView> addMedia({
    required String reviewId,
    required String path,
    required String filename,
    required String idempotencyKey,
  }) async => order!;

  @override
  Future<OrderReviewsView> removeMedia({
    required String reviewId,
    required String mediaId,
  }) async => order!;

  @override
  Future<Uint8List> media(String reviewId, ReviewMediaView media) async =>
      Uint8List(0);

  @override
  Future<ListingReviewsView> listingReviews(
    String listingId, {
    int page = 1,
  }) async => listing;

  StoreRatingView store = const StoreRatingView(
    ratingCount: 0,
    scoreLabel: 'New Vendor — Building Track Record',
    newVendor: true,
  );
  final List<String> storeRatingCalls = [];

  @override
  Future<StoreRatingView> storeRating(String vendorId) async {
    storeRatingCalls.add(vendorId);
    if (failure != null) throw failure!;
    return store;
  }

  @override
  Future<void> report({
    required String reviewId,
    required String reasonCode,
    String? details,
    required String idempotencyKey,
  }) async => reports.add('$reviewId:$reasonCode');
}
