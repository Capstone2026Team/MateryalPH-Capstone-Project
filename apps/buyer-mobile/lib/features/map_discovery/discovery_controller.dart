import 'package:flutter/foundation.dart';

import 'discovery_models.dart';
import 'directory_photo_loader.dart';
import 'discovery_repository.dart';

enum DiscoveryPhase { initializing, needsOrigin, loading, ready, failed }

enum RoutePhase { idle, loading, ready, failed }

/// Shared state for the map and its synchronized list. Both surfaces render the same [items]
/// in the same server order and share [selectedId]. Every asynchronous result is tagged with a
/// sequence and the origin/selection it was requested for; a result that no longer matches the
/// current origin, radius or selection is discarded so a slow response never overwrites newer state.
class DiscoveryController extends ChangeNotifier {
  DiscoveryController({required DiscoveryRepository repository})
    : _repository = repository;

  final DiscoveryRepository _repository;
  late final directoryPhotos = DirectoryPhotoLoader(_repository);

  DiscoveryPhase phase = DiscoveryPhase.initializing;
  DiscoveryOrigin? origin;
  int radiusKm = kDefaultRadiusKm;
  DiscoveryFilters filters = const DiscoveryFilters();
  List<SupplierResultView> items = const [];
  DiscoveryResultPage? page;
  DiscoveryFailure? failure;
  bool loadingMore = false;
  bool resultsStale = false;
  List<SavedLocationView> savedLocations = const [];
  BuyerOnboardingView? onboarding;

  String? selectedId;
  RoutePhase routePhase = RoutePhase.idle;
  RouteEstimateView? route;
  DiscoveryFailure? routeFailure;
  DirectoryDetailsView? directoryDetails;
  DiscoveryFailure? directoryFailure;
  bool directoryLoading = false;

  int _searchSequence = 0;
  int _loadedPage = 0;
  int _routeSequence = 0;
  int _detailsSequence = 0;
  bool _disposed = false;
  bool _initializing = false;

  SupplierResultView? get selected {
    for (final item in items) {
      if (item.resultId == selectedId) return item;
    }
    return null;
  }

  int? get suggestedRadiusKm => page?.suggestedRadiusKm;

  Future<void> initialize() async {
    // A shared controller survives tab visits. Never reset a valid active location on remount.
    if (_initializing || origin?.point?.usable == true) return;
    _initializing = true;
    phase = DiscoveryPhase.initializing;
    _notify();
    try {
      final results = await Future.wait([
        _repository.onboarding(),
        _repository.locations(),
      ]);
      onboarding = results[0] as BuyerOnboardingView;
      savedLocations = results[1] as List<SavedLocationView>;
      radiusKm = onboarding!.radiusKm;
    } on DiscoveryFailure catch (error) {
      failure = error;
      phase = DiscoveryPhase.failed;
      _notify();
      return;
    } finally {
      _initializing = false;
    }
    final valid = savedLocations
        .where((location) => location.point.usable)
        .toList();
    final primary = valid.where((location) => location.isPrimary);
    if (valid.isEmpty) {
      phase = DiscoveryPhase.needsOrigin;
      _notify();
      return;
    }
    final restored = primary.isEmpty ? valid.first : primary.first;
    await setOrigin(
      DiscoveryOrigin.saved(
        locationId: restored.id,
        label: displayAddress(restored.formattedAddress),
        point: restored.point,
      ),
    );
  }

  Future<void> reloadLocations() async {
    try {
      savedLocations = await _repository.locations();
      _notify();
    } on DiscoveryFailure catch (error) {
      failure = error;
      _notify();
    }
  }

  /// Changing the origin clears the selection and route because both belong to the old origin.
  Future<void> setOrigin(DiscoveryOrigin next) async {
    origin = next;
    _clearSelection();
    await search();
  }

  /// An explicit Buyer radius choice. It is saved as the preference; automatic expansion never
  /// calls this without the Buyer confirming first.
  Future<void> selectRadius(int km) async {
    if (!kDiscoveryRadiiKm.contains(km) || km == radiusKm) return;
    radiusKm = km;
    _clearSelection();
    final save = _repository.saveRadius(km).then((_) {}, onError: (_) {});
    await search();
    await save;
  }

  Future<void> acceptExpansion() async {
    final next = suggestedRadiusKm;
    if (next != null) await selectRadius(next);
  }

  Future<void> applyFilters(DiscoveryFilters next) async {
    filters = next;
    _clearSelection();
    await search();
  }

  /// Pull-to-refresh: reruns the search without changing saved preferences.
  Future<void> refresh() => search(keepSelection: true);

  Future<void> search({bool keepSelection = false}) async {
    final currentOrigin = origin;
    if (currentOrigin == null) {
      phase = DiscoveryPhase.needsOrigin;
      _notify();
      return;
    }
    final sequence = ++_searchSequence;
    loadingMore = false;
    final radius = radiusKm;
    final activeFilters = filters;
    phase = DiscoveryPhase.loading;
    failure = null;
    _routeSequence++;
    route = null;
    routePhase = RoutePhase.idle;
    if (!keepSelection) {
      _clearSelection();
      items = const [];
      page = null;
      resultsStale = false;
    }
    _notify();
    try {
      final result = await _repository.search(
        origin: currentOrigin,
        radiusKm: radius,
        filters: activeFilters,
      );
      if (!_current(sequence, currentOrigin, radius, activeFilters)) return;
      page = result;
      _loadedPage = 1;
      items = result.items;
      resultsStale = false;
      phase = DiscoveryPhase.ready;
      if (!keepSelection || selected == null) _clearSelection();
      _notify();
      if (keepSelection && selected != null) await _requestRoute(selected!);
      // Outer-radius suppliers may be beyond the first 100 rows. Populate the shared map/list
      // progressively through the existing paginated endpoint, stopping on failure or scope change.
      while (_current(sequence, currentOrigin, radius, activeFilters) &&
          (page?.hasMore ?? false) &&
          _loadedPage < 50) {
        final before = _loadedPage;
        await loadMore();
        if (_loadedPage == before) break;
      }
    } on DiscoveryFailure catch (error) {
      if (!_current(sequence, currentOrigin, radius, activeFilters)) return;
      failure = error;
      if (error.code == 'LOCATION_NOT_FOUND' ||
          error.code == 'LOCATION_OUTSIDE_PHILIPPINES') {
        origin = null;
        items = const [];
        page = null;
        _clearSelection();
        phase = DiscoveryPhase.needsOrigin;
        _notify();
        return;
      }
      // Keep earlier results visible but labelled, and never present an old ETA as current.
      resultsStale = items.isNotEmpty;
      route = null;
      routePhase = RoutePhase.idle;
      phase = items.isEmpty ? DiscoveryPhase.failed : DiscoveryPhase.ready;
      _notify();
    }
  }

  Future<void> loadMore() async {
    final current = page;
    final currentOrigin = origin;
    if (current == null ||
        !current.hasMore ||
        loadingMore ||
        currentOrigin == null) {
      return;
    }
    final sequence = _searchSequence;
    loadingMore = true;
    _notify();
    try {
      final next = await _repository.search(
        origin: currentOrigin,
        radiusKm: radiusKm,
        filters: filters,
        page: _loadedPage + 1,
      );
      if (sequence != _searchSequence) return;
      final known = items.map((item) => item.resultId).toSet();
      items = [
        ...items,
        ...next.items.where((item) => !known.contains(item.resultId)),
      ];
      page = next;
      _loadedPage++;
    } on DiscoveryFailure catch (error) {
      if (sequence == _searchSequence) failure = error;
    } finally {
      if (sequence == _searchSequence) {
        loadingMore = false;
        _notify();
      }
    }
  }

  /// Selecting a marker or list row: one route request for Tier 2 and Tier 1 alike, plus lazy
  /// Place Details for a Directory Supplier.
  Future<void> select(String resultId) async {
    final item = items.where((candidate) => candidate.resultId == resultId);
    if (item.isEmpty) return;
    selectedId = resultId;
    directoryDetails = null;
    directoryFailure = null;
    _notify();
    final supplier = item.first;
    await Future.wait([
      _requestRoute(supplier),
      if (!supplier.isVerified) _loadDirectoryDetails(supplier),
    ]);
  }

  void clearSelection() {
    _clearSelection();
    _notify();
  }

  Future<void> retryRoute() async {
    final supplier = selected;
    if (supplier != null) await _requestRoute(supplier);
  }

  Future<void> retryDirectoryDetails() async {
    final supplier = selected;
    if (supplier != null && !supplier.isVerified) {
      await _loadDirectoryDetails(supplier);
    }
  }

  Future<void> toggleFavorite(SupplierResultView supplier) async {
    if (!supplier.isVerified) return;
    final next = !supplier.isFavorite;
    items = [
      for (final item in items)
        item.resultId == supplier.resultId ? item.withFavorite(next) : item,
    ];
    _notify();
    try {
      await _repository.setFavorite(supplier.resultId, favorite: next);
    } on DiscoveryFailure catch (error) {
      items = [
        for (final item in items)
          item.resultId == supplier.resultId ? item.withFavorite(!next) : item,
      ];
      failure = error;
      _notify();
    }
  }

  /// Favorite from another page (Product Details, Store Profile). Keeps map rows in sync and lets
  /// the caller show a failure instead of swallowing it.
  Future<void> setFavorite(String vendorId, {required bool favorite}) async {
    if (_favoritePending.contains(vendorId)) return;
    _favoritePending.add(vendorId);
    _notify();
    try {
      await _repository.setFavorite(vendorId, favorite: favorite);
      favoriteUpdates[vendorId] = favorite;
      items = [
        for (final item in items)
          item.resultId == vendorId ? item.withFavorite(favorite) : item,
      ];
    } finally {
      _favoritePending.remove(vendorId);
      _notify();
    }
  }

  final Map<String, bool> favoriteUpdates = {};
  final Set<String> _favoritePending = {};
  bool favoriteBusy(String vendorId) => _favoritePending.contains(vendorId);

  Future<void> _requestRoute(SupplierResultView supplier) async {
    final currentOrigin = origin;
    final currentPage = page;
    if (currentOrigin == null || currentPage == null) return;
    final requestVersion = 'sel-${++_routeSequence}';
    routePhase = RoutePhase.loading;
    route = null;
    routeFailure = null;
    _notify();
    try {
      final result = await _repository.route(
        origin: currentOrigin,
        radiusKm: radiusKm,
        supplier: supplier,
        requestVersion: requestVersion,
      );
      final stillCurrent =
          result.requestVersion == 'sel-$_routeSequence' &&
          result.originVersion == page?.originVersion &&
          result.supplierId == selectedId;
      if (!stillCurrent) return;
      route = result;
      routePhase = RoutePhase.ready;
      _notify();
    } on DiscoveryFailure catch (error) {
      if (requestVersion != 'sel-$_routeSequence' ||
          supplier.resultId != selectedId) {
        return;
      }
      routeFailure = error;
      routePhase = RoutePhase.failed;
      _notify();
    }
  }

  Future<void> _loadDirectoryDetails(SupplierResultView supplier) async {
    final sequence = ++_detailsSequence;
    directoryLoading = true;
    directoryFailure = null;
    _notify();
    try {
      final details = await _repository.directoryDetails(supplier.resultId);
      if (sequence != _detailsSequence || selectedId != supplier.resultId) {
        return;
      }
      directoryDetails = details;
    } on DiscoveryFailure catch (error) {
      if (sequence != _detailsSequence || selectedId != supplier.resultId) {
        return;
      }
      directoryFailure = error;
    } finally {
      if (sequence == _detailsSequence) {
        directoryLoading = false;
        _notify();
      }
    }
  }

  bool _current(
    int sequence,
    DiscoveryOrigin requestedOrigin,
    int requestedRadius,
    DiscoveryFilters requestedFilters,
  ) =>
      !_disposed &&
      sequence == _searchSequence &&
      origin?.identity == requestedOrigin.identity &&
      radiusKm == requestedRadius &&
      identical(filters, requestedFilters);

  void _clearSelection() {
    selectedId = null;
    route = null;
    routeFailure = null;
    routePhase = RoutePhase.idle;
    directoryDetails = null;
    directoryFailure = null;
    directoryLoading = false;
    _routeSequence++;
    _detailsSequence++;
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    directoryPhotos.dispose();
    super.dispose();
  }
}
