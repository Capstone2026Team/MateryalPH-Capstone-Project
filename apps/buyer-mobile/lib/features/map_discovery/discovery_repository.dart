import 'dart:math';

import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

import '../../core/api_guard.dart';
import 'discovery_models.dart';
import 'map_geometry.dart';

/// Buyer locations, onboarding and map/list discovery. Every call goes through the versioned
/// `/api/v1` contract; no provider key or provider API is used from the app for data.
abstract interface class DiscoveryRepository {
  Future<BuyerOnboardingView> onboarding();

  Future<BuyerOnboardingView> saveOnboarding({
    required int lockVersion,
    required String action,
    String? companyName,
    String? positionTitle,
    String? industry,
    String? industryOtherLabel,
    List<String>? preferredCategoryIds,
  });

  Future<int> saveRadius(int radiusKm);

  Future<List<SavedLocationView>> locations();

  Future<LocationPreviewView> resolvePoint(
    GeoPoint point, {
    required bool device,
  });

  Future<LocationPreviewView> resolveAddress({
    required String addressLine,
    required String cityMunicipality,
    String? barangay,
    String? province,
    String? postalCode,
  });

  Future<SavedLocationView> saveLocation({
    required String resolutionToken,
    required String label,
    required String kind,
    required String idempotencyKey,
    bool makePrimary = false,
    String? addressLine,
  });

  Future<SavedLocationView> makePrimary(SavedLocationView location);

  Future<void> removeLocation(SavedLocationView location);

  Future<DiscoveryResultPage> search({
    required DiscoveryOrigin origin,
    required int radiusKm,
    required DiscoveryFilters filters,
    int page = 1,
  });

  Future<RouteEstimateView> route({
    required DiscoveryOrigin origin,
    required int radiusKm,
    required SupplierResultView supplier,
    required String requestVersion,
  });

  Future<DirectoryDetailsView> directoryDetails(String resultId);

  Future<void> setFavorite(String vendorId, {required bool favorite});

  Future<List<FavoriteSupplierView>> favorites();
}

final class ApiDiscoveryRepository implements DiscoveryRepository {
  ApiDiscoveryRepository({
    required api.MateryalphApiClient client,
    required Future<void> Function() onSessionExpired,
  }) : _client = client,
       _api = ApiGuard(onSessionExpired);

  final api.MateryalphApiClient _client;
  final ApiGuard _api;

  api.BuyerDiscoveryApi get _discovery => _client.getBuyerDiscoveryApi();
  api.BuyerLocationsApi get _locations => _client.getBuyerLocationsApi();

  @override
  Future<BuyerOnboardingView> onboarding() => _guard(() async {
    final response = await _locations.getBuyerOnboarding();
    return _onboarding(_required(response.data?.data));
  });

  @override
  Future<BuyerOnboardingView> saveOnboarding({
    required int lockVersion,
    required String action,
    String? companyName,
    String? positionTitle,
    String? industry,
    String? industryOtherLabel,
    List<String>? preferredCategoryIds,
  }) => _guard(() async {
    final response = await _locations.saveBuyerOnboarding(
      buyerOnboardingUpdate: api.BuyerOnboardingUpdate(
        (b) => b
          ..lockVersion = lockVersion
          ..action = api.BuyerOnboardingUpdateActionEnum.valueOf(action)
          ..companyName = companyName
          ..positionTitle = positionTitle
          ..industryClassification = industry == null
              ? null
              : api.BuyerIndustryClassification.valueOf(industry)
          ..industryOtherLabel = industryOtherLabel
          ..preferredCategoryIds = preferredCategoryIds == null
              ? null
              : ListBuilder<String>(preferredCategoryIds),
      ),
    );
    return _onboarding(_required(response.data?.data));
  });

  @override
  Future<int> saveRadius(int radiusKm) => _guard(() async {
    final response = await _discovery.saveBuyerDiscoveryRadius(
      discoveryPreferences: api.DiscoveryPreferences(
        (b) => b..radiusKm = radiusKm,
      ),
    );
    return _required(response.data?.data).radiusKm;
  });

  @override
  Future<List<SavedLocationView>> locations() => _guard(() async {
    final response = await _locations.listBuyerLocations();
    return _required(response.data).data.map(_location).toList();
  });

  @override
  Future<LocationPreviewView> resolvePoint(
    GeoPoint point, {
    required bool device,
  }) => _guard(() async {
    final response = await _locations.resolveBuyerLocation(
      buyerLocationResolveRequest: api.BuyerLocationResolveRequest(
        (b) => b
          ..mode = device
              ? api.BuyerLocationResolveRequestModeEnum.DEVICE
              : api.BuyerLocationResolveRequestModeEnum.PIN
          ..latitude = point.latitude
          ..longitude = point.longitude,
      ),
    );
    return _preview(_required(response.data?.data));
  });

  @override
  Future<LocationPreviewView> resolveAddress({
    required String addressLine,
    required String cityMunicipality,
    String? barangay,
    String? province,
    String? postalCode,
  }) => _guard(() async {
    final response = await _locations.resolveBuyerLocation(
      buyerLocationResolveRequest: api.BuyerLocationResolveRequest(
        (b) => b
          ..mode = api.BuyerLocationResolveRequestModeEnum.ADDRESS
          ..addressLine = addressLine
          ..cityMunicipality = cityMunicipality
          ..barangay = _blankToNull(barangay)
          ..province = _blankToNull(province)
          ..postalCode = _blankToNull(postalCode),
      ),
    );
    return _preview(_required(response.data?.data));
  });

  @override
  Future<SavedLocationView> saveLocation({
    required String resolutionToken,
    required String label,
    required String kind,
    required String idempotencyKey,
    bool makePrimary = false,
    String? addressLine,
  }) => _guard(() async {
    final response = await _locations.createBuyerLocation(
      idempotencyKey: idempotencyKey,
      buyerLocationCreate: api.BuyerLocationCreate(
        (b) => b
          ..resolutionToken = resolutionToken
          ..label = label
          ..locationKind = api.BuyerLocationKind.valueOf(kind)
          ..makePrimary = makePrimary
          ..addressLine = _blankToNull(addressLine),
      ),
    );
    return _location(_required(response.data?.data));
  });

  @override
  Future<SavedLocationView> makePrimary(SavedLocationView location) =>
      _guard(() async {
        final response = await _locations.makeBuyerLocationPrimary(
          locationId: location.id,
          lockVersionRequest: api.LockVersionRequest(
            (b) => b..lockVersion = location.lockVersion,
          ),
        );
        return _location(_required(response.data?.data));
      });

  @override
  Future<void> removeLocation(SavedLocationView location) => _guard(() async {
    await _locations.removeBuyerLocation(
      locationId: location.id,
      lockVersion: location.lockVersion,
    );
  });

  @override
  Future<DiscoveryResultPage> search({
    required DiscoveryOrigin origin,
    required int radiusKm,
    required DiscoveryFilters filters,
    int page = 1,
  }) => _guard(() async {
    final response = await _discovery.searchBuyerSuppliers(
      discoverySearchRequest: api.DiscoverySearchRequest(
        (b) => b
          ..locationId = origin.locationId
          ..latitude = origin.locationId == null ? origin.point!.latitude : null
          ..longitude = origin.locationId == null
              ? origin.point!.longitude
              : null
          ..originSource = origin.locationId == null
              ? api.DiscoverySearchRequestOriginSourceEnum.valueOf(
                  _sourceName(origin.source),
                )
              : null
          ..radiusKm = radiusKm
          ..includeVerified = filters.includeVerified
          ..includeDirectory = filters.includeDirectory
          ..favoritesOnly = filters.favoritesOnly
          ..supplierType = filters.supplierType
          ..categoryId = filters.categoryId
          ..page = page
          ..perPage = 100,
      ),
    );
    final envelope = _required(response.data);
    final meta = envelope.meta;
    return DiscoveryResultPage(
      items: envelope.data.map(_supplier).toList(),
      originVersion: meta.scope.originVersion,
      radiusKm: _radius(meta.scope.radiusKm),
      currentAsOf: meta.currentAsOf,
      verifiedCount: meta.counts.verifiedVendors,
      directoryCount: meta.counts.directorySuppliers,
      favoriteCount: meta.counts.favoriteSuppliers,
      eligibleVerifiedCount: meta.expansion.eligibleVerifiedCount,
      suggestedRadiusKm: meta.expansion.suggestedRadiusKm,
      atMaximum: meta.expansion.atMaximum,
      directoryStatus: meta.directory.status.name,
      directoryAttribution: meta.directory.attribution.text,
      directoryAsOf: meta.directory.asOf,
      total: meta.total,
      hasMore: meta.hasMore,
    );
  });

  @override
  Future<RouteEstimateView> route({
    required DiscoveryOrigin origin,
    required int radiusKm,
    required SupplierResultView supplier,
    required String requestVersion,
  }) => _guard(() async {
    final response = await _discovery.estimateBuyerRoute(
      routeEstimateRequest: api.RouteEstimateRequest(
        (b) => b
          ..locationId = origin.locationId
          ..latitude = origin.locationId == null ? origin.point!.latitude : null
          ..longitude = origin.locationId == null
              ? origin.point!.longitude
              : null
          ..originSource = origin.locationId == null
              ? api.RouteEstimateRequestOriginSourceEnum.valueOf(
                  _sourceName(origin.source),
                )
              : null
          ..radiusKm = radiusKm
          ..tier = supplier.isVerified
              ? api.SupplierTier.VERIFIED_VENDOR
              : api.SupplierTier.DIRECTORY_SUPPLIER
          ..supplierId = supplier.resultId
          ..requestVersion = requestVersion,
      ),
    );
    final route = _required(response.data?.data);
    return RouteEstimateView(
      requestVersion: route.requestVersion,
      originVersion: route.originVersion,
      supplierId: route.supplierId,
      distanceMeters: route.distanceMeters,
      durationSeconds: route.durationSeconds,
      straightLineMeters: route.straightLineMeters,
      path: decodePolyline(route.encodedPolyline),
      computedAt: route.computedAt,
      trafficAware:
          route.durationBasis ==
          api.RouteEstimateDurationBasisEnum.TRAFFIC_AWARE,
    );
  });

  @override
  Future<DirectoryDetailsView> directoryDetails(String resultId) =>
      _guard(() async {
        final response = await _discovery.getDirectorySupplierDetails(
          supplierId: resultId,
        );
        final detail = _required(response.data?.data);
        return DirectoryDetailsView(
          resultId: detail.resultId,
          name: detail.name,
          attribution: detail.attribution.text,
          fetchedAt: detail.fetchedAt,
          actions: detail.actions.map((action) => action.name).toList(),
          formattedAddress: detail.formattedAddress,
          publicPhone: detail.publicPhone,
          websiteUri: detail.websiteUri,
          googleMapsUri: detail.googleMapsUri,
          openingHours: detail.openingHours.toList(),
          googleRatingValue: detail.googleRating?.value,
          googleRatingCount: detail.googleRating?.count,
        );
      });

  @override
  Future<void> setFavorite(String vendorId, {required bool favorite}) =>
      _guard(() async {
        if (favorite) {
          await _discovery.addFavoriteSupplier(vendorId: vendorId);
        } else {
          await _discovery.removeFavoriteSupplier(vendorId: vendorId);
        }
      });

  @override
  Future<List<FavoriteSupplierView>> favorites() => _guard(() async {
    final response = await _discovery.listFavoriteSuppliers();
    return _required(response.data).data
        .map(
          (favorite) => FavoriteSupplierView(
            vendorId: favorite.vendorId,
            name: favorite.name,
            scoreText: favorite.scoreLabel.text,
            currentlyDiscoverable: favorite.currentlyDiscoverable,
          ),
        )
        .toList();
  });

  SupplierResultView _supplier(api.SupplierResult result) {
    final vendor = result.vendor;
    final open = vendor?.openStatus;
    return SupplierResultView(
      resultId: result.resultId,
      tier: result.tier == api.SupplierTier.VERIFIED_VENDOR
          ? SupplierTier.verified
          : SupplierTier.directory,
      rank: result.rank,
      name: result.name,
      point: GeoPoint(result.marker.latitude, result.marker.longitude),
      distanceMeters: result.distanceMeters,
      scoreKind: switch (result.scoreLabel.kind.name) {
        'VPS' => ScoreKind.vps,
        'NEW_VENDOR' => ScoreKind.newVendor,
        _ => ScoreKind.directory,
      },
      scoreText: result.scoreLabel.text,
      scoreValue: result.scoreLabel.value,
      isFavorite: result.isFavorite,
      logoUrl: vendor?.logoUrl,
      supplierType: vendor?.supplierType,
      niches: vendor?.niches.toList() ?? const [],
      fulfillmentMethod: vendor?.fulfillmentMethod,
      vacationMode: vendor?.vacationMode ?? false,
      publicPhone: vendor?.publicPhone,
      address: vendor?.address.formattedAddress,
      openState: open == null
          ? null
          : SupplierOpenState(
              status: open.status.name,
              opensAt: open.opensAt,
              closesAt: open.closesAt,
              fromDateOverride: open.basis.name == 'DATE_OVERRIDE',
            ),
      pickupAvailable: vendor?.serviceability.pickupAvailable ?? false,
      delivery: vendor?.serviceability.delivery.name,
      deliveryMaximumKm: vendor?.serviceability.deliveryMaximumKm,
      directoryAddress: result.directory?.formattedAddress,
      directoryType: result.directory?.primaryType,
    );
  }

  SavedLocationView _location(api.BuyerLocation location) => SavedLocationView(
    id: location.id,
    label: location.label ?? 'Saved location',
    kind: location.locationKind.name,
    isPrimary: location.isPrimary,
    formattedAddress: location.formattedAddress,
    point: GeoPoint(location.latitude, location.longitude),
    psgc: _psgc(location.psgc),
    lockVersion: location.lockVersion,
  );

  LocationPreviewView _preview(api.BuyerLocationPreview preview) =>
      LocationPreviewView(
        point: GeoPoint(preview.latitude, preview.longitude),
        providerStatus: preview.providerStatus.name,
        psgc: _psgc(preview.psgc),
        resolutionToken: preview.resolutionToken,
        formattedAddress: preview.formattedAddress,
      );

  PsgcSummary _psgc(api.PsgcResolution psgc) => PsgcSummary(
    resolution: psgc.resolution.name,
    version: psgc.version,
    region: psgc.region?.name ?? psgc.region?.code,
    province: psgc.province?.name,
    city: psgc.cityMunicipality?.name,
    barangay: psgc.barangay?.name,
  );

  BuyerOnboardingView _onboarding(api.BuyerOnboarding onboarding) =>
      BuyerOnboardingView(
        status: onboarding.status.name,
        radiusKm: _radius(onboarding.discoveryRadiusKm),
        hasPrimaryLocation: onboarding.hasPrimaryLocation,
        lockVersion: onboarding.lockVersion,
        categories: onboarding.categories
            .map((category) => CategoryOption(category.id, category.name))
            .toList(),
        companyName: onboarding.companyName,
        positionTitle: onboarding.positionTitle,
        industry: onboarding.industryClassification?.name,
        industryOtherLabel: onboarding.industryOtherLabel,
        preferredCategoryIds: onboarding.preferredCategoryIds.toList(),
      );

  Future<T> _guard<T>(Future<T> Function() operation) => _api(operation);

  T _required<T>(T? value) => _api.required(value);

  int _radius(api.RadiusKm radius) =>
      int.tryParse(radius.name.replaceFirst('number', '')) ?? kDefaultRadiusKm;

  String _sourceName(OriginSource source) => switch (source) {
    OriginSource.device => 'DEVICE',
    OriginSource.search => 'SEARCH',
    _ => 'MAP_PIN',
  };

  String? _blankToNull(String? value) =>
      value == null || value.trim().isEmpty ? null : value.trim();
}

final Random _secureRandom = Random.secure();

/// A random UUIDv4 for Idempotency-Key. Callers reuse one key for every retry of the same save.
String newIdempotencyKey() {
  final bytes = List<int>.generate(16, (_) => _secureRandom.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;
  final hex = bytes
      .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
      .join();
  return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
}
