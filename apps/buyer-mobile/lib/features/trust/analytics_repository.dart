import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

import '../../core/api_guard.dart';
import '../map_discovery/discovery_models.dart';
import 'trust_models.dart';

/// MAT-05 Buyer Materials Analytics through `/api/v1` only. The audience is the Buyer session; the
/// Explore origin and the fixed analytics radius travel in request bodies.
abstract interface class AnalyticsRepository {
  Future<MaterialsAnalyticsPage> list({
    required DiscoveryOrigin origin,
    required int radiusKm,
    required AnalyticsWindowChoice window,
    String? query,
    String? categoryId,
    String? cursor,
    int? perPage,
  });

  /// One row per canonical product, plus every in-scope category for the overview tiles.
  Future<AnalyticsProductsPage> products({
    required DiscoveryOrigin origin,
    required int radiusKm,
    required AnalyticsWindowChoice window,
    String? query,
    String? categoryId,
    String? cursor,
  });

  Future<AnalyticsProductDetailView> product({
    required String materialId,
    required DiscoveryOrigin origin,
    required int radiusKm,
    required AnalyticsWindowChoice window,
  });

  Future<MaterialPriceDetailsView> details({
    required String groupId,
    required DiscoveryOrigin origin,
    required int radiusKm,
    required AnalyticsWindowChoice window,
  });

  Future<List<MaterialOfferView>> offers({
    required String groupId,
    required DiscoveryOrigin origin,
    required int radiusKm,
  });
}

final class ApiAnalyticsRepository implements AnalyticsRepository {
  ApiAnalyticsRepository({
    required api.MateryalphApiClient client,
    required Future<void> Function() onSessionExpired,
  }) : _client = client,
       _api = ApiGuard(onSessionExpired);

  final api.MateryalphApiClient _client;
  final ApiGuard _api;

  api.BuyerMaterialsAnalyticsApi get _analytics =>
      _client.getBuyerMaterialsAnalyticsApi();

  @override
  Future<MaterialsAnalyticsPage> list({
    required DiscoveryOrigin origin,
    required int radiusKm,
    required AnalyticsWindowChoice window,
    String? query,
    String? categoryId,
    String? cursor,
    int? perPage,
  }) => _api(() async {
    final response = await _analytics.listBuyerMaterialsAnalytics(
      buyerMaterialsAnalyticsRequest: _request(
        origin,
        radiusKm,
        window: window,
        query: query,
        categoryId: categoryId,
        cursor: cursor,
        perPage: perPage,
      ),
    );
    final data = _api.required(response.data?.data);
    return MaterialsAnalyticsPage(
      envelope: _envelope(
        data.dataset,
        data.updateSchedule,
        data.explanation,
        data.currentAsOf,
        data.snapshot,
        data.window,
      ),
      items: data.items.map(_row).toList(growable: false),
      nextCursor: data.nextCursor,
    );
  });

  @override
  Future<AnalyticsProductsPage> products({
    required DiscoveryOrigin origin,
    required int radiusKm,
    required AnalyticsWindowChoice window,
    String? query,
    String? categoryId,
    String? cursor,
  }) => _api(() async {
    final response = await _analytics.listBuyerAnalyticsProducts(
      buyerMaterialsAnalyticsRequest: _request(
        origin,
        radiusKm,
        window: window,
        query: query,
        categoryId: categoryId,
        cursor: cursor,
      ),
    );
    final data = _api.required(response.data?.data);
    return AnalyticsProductsPage(
      envelope: _envelope(
        data.dataset,
        data.updateSchedule,
        data.explanation,
        data.currentAsOf,
        data.snapshot,
        data.window,
      ),
      categories: data.categories
          .map(
            (summary) => AnalyticsCategorySummaryView(
              id: summary.category.id,
              name: summary.category.name,
              code: summary.category.code,
              productCount: summary.productCount,
              variantCount: summary.variantCount,
            ),
          )
          .toList(growable: false),
      items: data.items.map(_product).toList(growable: false),
      notYetComparable: data.notYetComparableListings,
      nextCursor: data.nextCursor,
    );
  });

  @override
  Future<AnalyticsProductDetailView> product({
    required String materialId,
    required DiscoveryOrigin origin,
    required int radiusKm,
    required AnalyticsWindowChoice window,
  }) => _api(() async {
    final response = await _analytics.getBuyerAnalyticsProduct(
      materialId: materialId,
      buyerMaterialsAnalyticsRequest: _request(
        origin,
        radiusKm,
        window: window,
      ),
    );
    final data = _api.required(response.data?.data);
    final row = data.product;
    final featured = data.featured;
    return AnalyticsProductDetailView(
      envelope: _envelope(
        data.dataset,
        data.updateSchedule,
        data.explanation,
        data.currentAsOf,
        data.snapshot,
        data.window,
      ),
      product: AnalyticsProductView(
        materialId: row.material.id,
        name: row.material.name,
        categoryId: row.category.id,
        categoryName: row.category.name,
        categoryCode: row.category.code,
        regulated: row.regulated,
        unitName: row.unit.name,
        variantCount: row.variantCount,
        vendorCount: row.vendorCount,
        price: _range(row.price),
      ),
      description: row.description,
      featured: featured == null ? null : _detailGroup(featured.group),
      series: featured?.series.map(_point).toList(growable: false) ?? const [],
      variants: data.variants
          .map(
            (variant) => AnalyticsProductVariantView(
              groupId: variant.groupId,
              displayName: variant.displayName,
              materialName: variant.material.name,
              specification: _specification(variant.specification),
              unitName: variant.unit.name,
              vendorCount: variant.vendorCount,
              listingCount: variant.listingCount,
              price: _range(variant.price),
              availability: variant.availability.name,
              categoryCode: variant.category.code,
              imageUrl: variant.image?.url,
            ),
          )
          .toList(growable: false),
    );
  });

  @override
  Future<MaterialPriceDetailsView> details({
    required String groupId,
    required DiscoveryOrigin origin,
    required int radiusKm,
    required AnalyticsWindowChoice window,
  }) => _api(() async {
    final response = await _analytics.getBuyerMaterialPriceDetails(
      groupId: groupId,
      buyerMaterialsAnalyticsRequest: _request(
        origin,
        radiusKm,
        window: window,
      ),
    );
    final data = _api.required(response.data?.data);
    final group = data.group;
    return MaterialPriceDetailsView(
      envelope: _envelope(
        data.dataset,
        data.updateSchedule,
        data.explanation,
        data.currentAsOf,
        data.snapshot,
        data.window,
      ),
      group: _detailGroup(group),
      description: group.description,
      variants: data.variants
          .map(
            (variant) =>
                (groupId: variant.groupId, displayName: variant.displayName),
          )
          .toList(growable: false),
      series: data.series.map(_point).toList(growable: false),
    );
  });

  @override
  Future<List<MaterialOfferView>> offers({
    required String groupId,
    required DiscoveryOrigin origin,
    required int radiusKm,
  }) => _api(() async {
    final response = await _analytics.listBuyerMaterialOffers(
      groupId: groupId,
      buyerMaterialsAnalyticsRequest: _request(origin, radiusKm),
    );
    return _api
        .required(response.data?.data)
        .map(
          (offer) => MaterialOfferView(
            vendorId: offer.vendorId,
            storeName: offer.storeName,
            listingId: offer.listingId,
            displayName: offer.displayName,
            variantLabel: offer.variantLabel,
            priceCentavos: offer.priceCentavos,
            normalizedPhp: offer.normalizedPhp,
            taxLabel: offer.taxLabel,
            availability: offer.availability.name,
            distanceMeters: offer.distanceMeters,
            imageUrl: offer.image?.url,
          ),
        )
        .toList(growable: false);
  });

  api.BuyerMaterialsAnalyticsRequest _request(
    DiscoveryOrigin origin,
    int radiusKm, {
    AnalyticsWindowChoice? window,
    String? query,
    String? categoryId,
    String? cursor,
    int? perPage,
  }) => api.BuyerMaterialsAnalyticsRequest((b) {
    b
      ..locationId = origin.locationId
      ..latitude = origin.locationId == null ? origin.point!.latitude : null
      ..longitude = origin.locationId == null ? origin.point!.longitude : null
      ..originSource = origin.locationId == null
          ? api.BuyerMaterialsAnalyticsRequestOriginSourceEnum.MAP_PIN
          : null
      ..radiusKm = api.BuyerMaterialsAnalyticsRequestRadiusKmEnum.values
          .firstWhere((value) => value.name == 'number$radiusKm')
      ..q = query == null || query.trim().isEmpty ? null : query.trim()
      ..categoryId = categoryId
      ..cursor = cursor
      ..perPage = perPage;
    if (window != null) {
      if (window.isCustom) {
        b
          ..startDate = _date(window.startDate!)
          ..endDate = _date(window.endDate!);
      } else {
        b.presetDays = api.BuyerMaterialsAnalyticsRequestPresetDaysEnum.values
            .firstWhere((value) => value.name == 'number${window.presetDays}');
      }
    }
  });

  static api.Date _date(String value) {
    final parts = value.split('-').map(int.parse).toList();
    return api.Date(parts[0], parts[1], parts[2]);
  }

  static String _day(api.Date date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  static List<String> _specification(api.ComparableSpecification value) => [
    if (value.brand != null) value.brand!,
    ...value.attributes.map(
      (attribute) =>
          '${attribute.key.replaceAll('_', ' ')}: ${attribute.value}',
    ),
  ];

  AnalyticsEnvelopeView _envelope(
    api.DatasetLabel dataset,
    String schedule,
    String explanation,
    DateTime currentAsOf,
    api.AnalyticsSnapshotRef? snapshot,
    api.AnalyticsWindow window,
  ) => AnalyticsEnvelopeView(
    datasetLabel: dataset.label ?? 'Listed-price history',
    updateSchedule: schedule,
    explanation: explanation,
    currentAsOf: currentAsOf,
    snapshotAt: snapshot?.observedAt,
    latestDate: window.latestAvailableDate == null
        ? null
        : _day(window.latestAvailableDate!),
    earliestDate: window.earliestAvailableDate == null
        ? null
        : _day(window.earliestAvailableDate!),
    startDate: window.startDate == null ? null : _day(window.startDate!),
    endDate: window.endDate == null ? null : _day(window.endDate!),
  );

  ComparableGroupView _row(api.BuyerAnalyticsRow row) => ComparableGroupView(
    groupId: row.groupId,
    displayName: row.displayName,
    materialName: row.material.name,
    categoryName: row.category.name,
    categoryId: row.category.id,
    categoryCode: row.category.code,
    imageUrl: row.image?.url,
    unitName: row.unit.name,
    specification: _specification(row.specification),
    startPoint: _point(row.startPoint),
    endPoint: _point(row.endPoint),
    trend: _trend(row.trend),
    currentVendors: row.current.vendorCount,
    currentListings: row.current.listingCount,
  );

  ComparableGroupView _detailGroup(
    api.BuyerMaterialsAnalyticsDetailGroup group,
  ) => ComparableGroupView(
    groupId: group.groupId,
    displayName: group.displayName,
    materialName: group.material.name,
    categoryName: group.category.name,
    categoryId: group.category.id,
    categoryCode: group.category.code,
    imageUrl: group.image?.url,
    unitName: group.unit.name,
    specification: _specification(group.specification),
    startPoint: _point(group.startPoint),
    endPoint: _point(group.endPoint),
    trend: _trend(group.trend),
    currentVendors: group.current.vendorCount,
    currentListings: group.current.listingCount,
  );

  AnalyticsProductView _product(api.BuyerAnalyticsProductRow row) =>
      AnalyticsProductView(
        materialId: row.material.id,
        name: row.material.name,
        categoryId: row.category.id,
        categoryName: row.category.name,
        categoryCode: row.category.code,
        regulated: row.regulated,
        unitName: row.unit.name,
        variantCount: row.variantCount,
        vendorCount: row.vendorCount,
        price: _range(row.price),
      );

  static PriceRangeView _range(api.AnalyticsPriceRange range) => PriceRangeView(
    min: range.minPhp,
    median: range.medianPhp,
    max: range.maxPhp,
  );

  AnalyticsPointView _point(api.BuyerAnalyticsPoint point) =>
      AnalyticsPointView(
        date: _day(point.date),
        status: point.status.name,
        label: point.label,
        average: point.averagePhp,
        vendorCount: point.vendorCount,
        participantsChanged: point.participantsChanged,
      );

  AnalyticsTrendView _trend(api.AnalyticsTrend trend) => AnalyticsTrendView(
    changePercent: trend.changePercent,
    direction: trend.direction?.name,
    reason: trend.reason?.name,
    label: trend.label,
    compositionChanged: trend.compositionChanged,
    compositionNote: trend.compositionNote,
    startDate: trend.startDate == null ? null : _day(trend.startDate!),
    endDate: trend.endDate == null ? null : _day(trend.endDate!),
  );
}
