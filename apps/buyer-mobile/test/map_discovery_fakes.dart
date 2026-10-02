import 'dart:async';

import 'package:flutter/material.dart';
import 'package:materyalph/features/map_discovery/device_location.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';
import 'package:materyalph/features/map_discovery/discovery_repository.dart';
import 'package:materyalph/features/map_discovery/discovery_result_cache.dart';
import 'package:materyalph/features/map_discovery/map_geometry.dart';
import 'package:materyalph/features/map_discovery/supplier_map.dart';

SupplierResultView verifiedSupplier(
  String id, {
  int rank = 1,
  String name = 'Sampaloc Lumber Hardware',
  String? logoUrl,
  int distance = 1900,
  bool favorite = false,
  double latitude = 14.61,
  double longitude = 120.99,
  ScoreKind scoreKind = ScoreKind.newVendor,
  String scoreText = 'New Vendor',
}) => SupplierResultView(
  resultId: id,
  tier: SupplierTier.verified,
  rank: rank,
  name: name,
  point: GeoPoint(latitude, longitude),
  distanceMeters: distance,
  scoreKind: scoreKind,
  scoreText: scoreText,
  isFavorite: favorite,
  logoUrl: logoUrl,
  supplierType: 'RETAIL_HARDWARE_STORE',
  niches: const ['Plywood', 'Cement', 'Steelbar'],
  fulfillmentMethod: 'BOTH',
  pickupAvailable: true,
  delivery: 'WITHIN_STATED_AREA',
  deliveryMaximumKm: 10,
  address: '123 Aurora Boulevard, Quezon City',
  openState: const SupplierOpenState(
    status: 'OPEN',
    opensAt: '08:30',
    closesAt: '17:30',
  ),
);

SupplierResultView directorySupplier(
  String id, {
  int rank = 2,
  int distance = 2400,
  double latitude = 14.62,
  double longitude = 121.0,
}) => SupplierResultView(
  resultId: id,
  tier: SupplierTier.directory,
  rank: rank,
  name: 'Panda Construction Supply',
  point: GeoPoint(latitude, longitude),
  distanceMeters: distance,
  scoreKind: ScoreKind.directory,
  scoreText: 'Directory',
  directoryAddress: 'Sampaloc, Manila',
);

DiscoveryResultPage resultPage(
  List<SupplierResultView> items, {
  int radiusKm = 5,
  String originVersion = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
  int? suggested,
  String directoryStatus = 'AVAILABLE',
  bool hasMore = false,
  int? total,
}) => DiscoveryResultPage(
  items: items,
  originVersion: originVersion,
  radiusKm: radiusKm,
  currentAsOf: DateTime.utc(2026, 9, 28, 2),
  verifiedCount: items.where((item) => item.isVerified).length,
  directoryCount: items.where((item) => !item.isVerified).length,
  favoriteCount: items.where((item) => item.isFavorite).length,
  eligibleVerifiedCount: items.where((item) => item.isVerified).length,
  suggestedRadiusKm: suggested,
  atMaximum: radiusKm == 50,
  directoryStatus: directoryStatus,
  directoryAttribution:
      'Source: Google Maps. Directory information may be outdated.',
  total: total ?? items.length,
  hasMore: hasMore,
);

const primaryLocation = SavedLocationView(
  id: 'loc-1',
  label: '629 J Nepomuceno St',
  kind: 'DELIVERY',
  isPrimary: true,
  formattedAddress: '629 J Nepomuceno St, Quiapo, Manila',
  point: GeoPoint(14.5995, 120.9842),
  psgc: PsgcSummary(
    resolution: 'RESOLVED',
    version: '2025Q2',
    region: 'National Capital Region (NCR)',
    city: 'City of Manila',
  ),
  lockVersion: 1,
);

/// In-memory stand-in for the on-disk result store, so tests never touch the file system.
class MemoryDiscoveryResultStore implements DiscoveryResultStore {
  final entries = <String, CachedDiscovery>{};
  @override
  Future<CachedDiscovery?> read(String key) async => entries[key];
  @override
  Future<void> write(String key, CachedDiscovery value) async =>
      entries[key] = value;
  @override
  Future<void> clear() async => entries.clear();
}

class SearchCall {
  SearchCall(
    this.origin,
    this.radiusKm,
    this.filters,
    this.completer,
    this.page,
  );
  final int page;
  final DiscoveryOrigin origin;
  final int radiusKm;
  final DiscoveryFilters filters;
  final Completer<DiscoveryResultPage> completer;
}

class RouteCall {
  RouteCall(this.supplier, this.requestVersion, this.completer);
  final SupplierResultView supplier;
  final String requestVersion;
  final Completer<RouteEstimateView> completer;
}

/// Fake repository. By default it answers immediately from [page]; set [manual] to control
/// completion order and prove stale responses are discarded.
class FakeDiscoveryRepository implements DiscoveryRepository {
  FakeDiscoveryRepository({
    this.locationsList = const [primaryLocation],
    DiscoveryResultPage? page,
    this.manual = false,
    this.onboardingStatus = 'COMPLETED',
  }) : page =
           page ??
           resultPage([verifiedSupplier('v-1'), directorySupplier('d-1')]);

  List<SavedLocationView> locationsList;
  DiscoveryResultPage page;
  bool manual;
  String onboardingStatus;
  DiscoveryFailure? searchFailure;
  DiscoveryFailure? routeFailure;
  DiscoveryFailure? detailsFailure;

  /// Street address returned when a point is resolved; null behaves like an unavailable lookup.
  String? pointAddress;
  final resolvedPoints = <(GeoPoint, bool)>[];
  final searches = <SearchCall>[];
  final routes = <RouteCall>[];
  final savedRadii = <int>[];
  final favoriteChanges = <(String, bool)>[];
  int detailCalls = 0;

  RouteEstimateView routeFor(
    SupplierResultView supplier,
    String requestVersion, {
    String? originVersion,
  }) => RouteEstimateView(
    requestVersion: requestVersion,
    originVersion: originVersion ?? page.originVersion,
    supplierId: supplier.resultId,
    distanceMeters: 4200,
    durationSeconds: 1080,
    straightLineMeters: supplier.distanceMeters,
    path: [const GeoPoint(14.5995, 120.9842), supplier.point],
    computedAt: DateTime.utc(2026, 9, 28, 2),
    trafficAware: true,
  );

  List<LocationSuggestionView> suggestions = const [];
  Completer<List<LocationSuggestionView>>? pendingSuggestions;
  int saveCalls = 0;
  Completer<SavedLocationView>? pendingSave;
  final savedKeys = <String>[];

  @override
  Future<List<LocationSuggestionView>> autocomplete(
    String query,
    String sessionToken,
  ) async => pendingSuggestions == null
      ? suggestions
      : await pendingSuggestions!.future;

  @override
  Future<LocationPreviewView> resolvePlace(
    String placeId,
    String sessionToken,
  ) =>
      resolveAddress(addressLine: 'Selected place', cityMunicipality: 'Manila');

  @override
  Future<BuyerOnboardingView> onboarding() async => BuyerOnboardingView(
    status: onboardingStatus,
    radiusKm: savedRadii.isEmpty ? 5 : savedRadii.last,
    hasPrimaryLocation: locationsList.any((location) => location.isPrimary),
    lockVersion: 1,
    categories: const [
      CategoryOption('cat-1', 'Cement and Concrete'),
      CategoryOption('cat-2', 'Wood and Lumber'),
    ],
  );

  @override
  Future<BuyerOnboardingView> saveOnboarding({
    required int lockVersion,
    required String action,
    String? companyName,
    String? positionTitle,
    String? industry,
    String? industryOtherLabel,
    List<String>? preferredCategoryIds,
  }) async {
    onboardingStatus = action == 'SKIP' ? 'SKIPPED' : 'COMPLETED';
    return onboarding();
  }

  @override
  Future<int> saveRadius(int radiusKm) async {
    savedRadii.add(radiusKm);
    return radiusKm;
  }

  @override
  Future<List<SavedLocationView>> locations() async => locationsList;

  @override
  Future<LocationPreviewView> resolvePoint(
    GeoPoint point, {
    required bool device,
  }) async {
    resolvedPoints.add((point, device));
    return LocationPreviewView(
      point: point,
      providerStatus: pointAddress == null ? 'UNAVAILABLE' : 'AVAILABLE',
      psgc: const PsgcSummary(resolution: 'UNRESOLVED'),
      resolutionToken: 'token',
      formattedAddress: pointAddress,
    );
  }

  @override
  Future<LocationPreviewView> resolveAddress({
    required String addressLine,
    required String cityMunicipality,
    String? barangay,
    String? province,
    String? postalCode,
  }) async => const LocationPreviewView(
    point: GeoPoint(14.5995, 120.9842),
    providerStatus: 'AVAILABLE',
    psgc: PsgcSummary(
      resolution: 'RESOLVED',
      version: '2025Q2',
      region: 'National Capital Region (NCR)',
      city: 'City of Manila',
    ),
    resolutionToken: 'token',
    formattedAddress: '629 J Nepomuceno St, Quiapo, Manila',
  );

  @override
  Future<SavedLocationView> saveLocation({
    required String resolutionToken,
    required String label,
    required String kind,
    required String idempotencyKey,
    bool makePrimary = false,
    String? addressLine,
  }) async {
    saveCalls++;
    savedKeys.add(idempotencyKey);
    locationsList = [primaryLocation];
    return pendingSave == null ? primaryLocation : await pendingSave!.future;
  }

  @override
  Future<SavedLocationView> makePrimary(SavedLocationView location) async =>
      location;

  @override
  Future<void> removeLocation(SavedLocationView location) async {}

  @override
  Future<DiscoveryResultPage> search({
    required DiscoveryOrigin origin,
    required int radiusKm,
    required DiscoveryFilters filters,
    int page = 1,
  }) {
    final completer = Completer<DiscoveryResultPage>();
    searches.add(SearchCall(origin, radiusKm, filters, completer, page));
    if (!manual) {
      final failure = searchFailure;
      failure == null
          ? completer.complete(this.page)
          : completer.completeError(failure);
    }
    return completer.future;
  }

  @override
  Future<RouteEstimateView> route({
    required DiscoveryOrigin origin,
    required int radiusKm,
    required SupplierResultView supplier,
    required String requestVersion,
  }) {
    final completer = Completer<RouteEstimateView>();
    routes.add(RouteCall(supplier, requestVersion, completer));
    if (!manual) {
      final failure = routeFailure;
      failure == null
          ? completer.complete(routeFor(supplier, requestVersion))
          : completer.completeError(failure);
    }
    return completer.future;
  }

  int photoCalls = 0;
  DirectoryPhotoView photo = const DirectoryPhotoView(null, []);

  @override
  Future<DirectoryPhotoView> directoryPhoto(String resultId) async {
    photoCalls++;
    if (detailsFailure != null) throw detailsFailure!;
    return photo;
  }

  @override
  Future<DirectoryDetailsView> directoryDetails(String resultId) async {
    detailCalls++;
    final failure = detailsFailure;
    if (failure != null) throw failure;
    return DirectoryDetailsView(
      resultId: resultId,
      name: 'Panda Construction Supply',
      attribution:
          'Source: Google Maps. Directory information may be outdated.',
      fetchedAt: DateTime.utc(2026, 9, 28, 2),
      actions: const ['CALL', 'OPEN_IN_MAPS', 'WEBSITE', 'SHARE'],
      formattedAddress: '3682 Redbud Drive, Sampaloc, Manila',
      publicPhone: '(02) 8236 5500',
      websiteUri: 'https://panda.example.test',
      googleMapsUri: 'https://maps.google.com/?cid=1',
      openingHours: const ['Monday: 8:30 AM – 5:30 PM'],
      googleRatingValue: '4.8',
      googleRatingCount: 120,
    );
  }

  @override
  Future<void> setFavorite(String vendorId, {required bool favorite}) async =>
      favoriteChanges.add((vendorId, favorite));

  @override
  Future<List<FavoriteSupplierView>> favorites() async => const [];
}

class FakeDeviceLocation implements DeviceLocationService {
  FakeDeviceLocation(this.result);
  DeviceLocationResult result;
  int requests = 0;

  @override
  Future<DeviceLocationResult> requestCurrent() async {
    requests++;
    return result;
  }

  @override
  Future<bool> openSettings() async => true;
}

/// Records every map render so tests can compare map and list data and order. Markers follow the
/// real map's isolation rule, so only the selected supplier is drawn while one is selected.
class RecordingMap {
  final renders = <SupplierMapProps>[];

  SupplierMapProps get last => renders.last;

  Widget build(BuildContext context, SupplierMapProps props) {
    renders.add(props);
    return Semantics(
      label: 'Test map with ${props.items.length} suppliers',
      child: ListView(
        children: [
          for (final item in mapVisibleSuppliers(props.items, props.selectedId))
            TextButton(
              key: ValueKey('marker-${item.resultId}'),
              onPressed: () => props.onSelect(item.resultId),
              child: Text('marker ${item.markerLabel}'),
            ),
        ],
      ),
    );
  }
}
