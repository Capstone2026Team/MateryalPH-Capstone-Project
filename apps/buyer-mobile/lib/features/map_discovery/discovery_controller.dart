import 'package:flutter/foundation.dart';

import 'discovery_models.dart';
import 'directory_photo_loader.dart';
import 'discovery_repository.dart';
import 'discovery_result_cache.dart';

/// Directory details (hours, phone, reviews) are live Google content: kept in memory for this app
/// session only and never written to disk. Reselecting a supplier inside this window reuses them
/// instead of paying for another Place Details call.
const Duration kDirectoryDetailsSessionTtl = Duration(minutes: 15);

enum DiscoveryPhase { initializing, needsOrigin, loading, ready, failed }

enum RoutePhase { idle, loading, ready, failed }

/// Shared state for the map and its synchronized list. Both surfaces render the same [items]
/// in the same server order and share [selectedId]. Every asynchronous result is tagged with a
/// sequence and the origin/selection it was requested for; a result that no longer matches the
/// current origin, radius or selection is discarded so a slow response never overwrites newer state.
class DiscoveryController extends ChangeNotifier {
  DiscoveryController({
    required DiscoveryRepository repository,
    DiscoveryResultStore? store,
    DateTime Function()? now,
  }) : _repository = repository,
       _store = store,
       _now = now ?? DateTime.now;

  final DiscoveryRepository _repository;
  final DiscoveryResultStore? _store;
  final DateTime Function() _now;
  late final directoryPhotos = DirectoryPhotoLoader(_repository);
  final Map<String, (DirectoryDetailsView, DateTime)> _detailsCache = {};

  /// True while the list on screen came from the saved copy and has not been confirmed yet.
  bool showingSavedResults = false;

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
  Future<void> refresh() => search(keepSelection: true, force: true);

  /// [force] skips the saved copy's fresh window (pull-to-refresh, retry) and always asks the server.
  Future<void> search({bool keepSelection = false, bool force = false}) async {
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
    final cacheKey = discoveryCacheKey(currentOrigin, radius, activeFilters);
    // A saved copy of this exact location + radius is shown immediately, before any request.
    final saved = cacheKey == null || force || _store == null
        ? null
        : await _store.read(cacheKey);
    if (!_current(sequence, currentOrigin, radius, activeFilters)) return;
    if (saved != null && !saved.isExpired(_now())) {
      _clearSelection();
      page = saved.page;
      items = saved.items;
      _loadedPage = 1;
      failure = null;
      resultsStale = false;
      showingSavedResults = true;
      phase = DiscoveryPhase.ready;
      _notify();
      // Recent enough: no request at all. The server's own place cache covers Google separately.
      if (saved.isFresh(_now())) {
        showingSavedResults = false;
        _notify();
        return;
      }
      keepSelection = true;
    }
    // With a saved copy on screen the list stays visible while the server confirms it.
    if (!showingSavedResults) phase = DiscoveryPhase.loading;
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
      if (showingSavedResults) {
        // Swap once, after every page arrived, so the visible list never shrinks to page 1 and regrows.
        var latest = result;
        var loaded = 1;
        final merged = [...result.items];
        final known = merged.map((item) => item.resultId).toSet();
        while (latest.hasMore && loaded < 50) {
          latest = await _repository.search(
            origin: currentOrigin,
            radiusKm: radius,
            filters: activeFilters,
            page: loaded + 1,
          );
          if (!_current(sequence, currentOrigin, radius, activeFilters)) return;
          loaded++;
          merged.addAll(latest.items.where((item) => known.add(item.resultId)));
        }
        page = latest;
        items = merged;
        _loadedPage = loaded;
        showingSavedResults = false;
        resultsStale = false;
        phase = DiscoveryPhase.ready;
        if (selected == null) _clearSelection();
        _notify();
        if (selected != null) await _requestRoute(selected!);
        await _persist();
        return;
      }
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
      await _persist();
    } on DiscoveryFailure catch (error) {
      if (!_current(sequence, currentOrigin, radius, activeFilters)) return;
      showingSavedResults = false;
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

  /// Saves the complete result set for this saved location + radius. Never saves a partial set, a
  /// stale one, or one for device/pin coordinates.
  Future<void> _persist() async {
    final store = _store;
    final currentOrigin = origin;
    final current = page;
    if (store == null ||
        currentOrigin == null ||
        current == null ||
        current.hasMore ||
        resultsStale ||
        failure != null) {
      return;
    }
    final key = discoveryCacheKey(currentOrigin, radiusKm, filters);
    if (key == null) return;
    await store.write(
      key,
      CachedDiscovery(items: items, page: current, savedAt: _now()),
    );
  }

  /// Forget every saved result set (sign-out, expired session).
  Future<void> clearSavedResults() async => _store?.clear();

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
      await _persist();
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
      await _persist();
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
    final reusable = _detailsCache[supplier.resultId];
    if (reusable != null &&
        _now().difference(reusable.$2) < kDirectoryDetailsSessionTtl) {
      directoryDetails = reusable.$1;
      directoryLoading = false;
      directoryFailure = null;
      _notify();
      return;
    }
    directoryLoading = true;
    directoryFailure = null;
    _notify();
    try {
      final details = await _repository.directoryDetails(supplier.resultId);
      if (_detailsCache.length >= 50) {
        _detailsCache.remove(_detailsCache.keys.first);
      }
      _detailsCache[supplier.resultId] = (details, _now());
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
