import 'package:flutter/foundation.dart';

import '../map_discovery/discovery_controller.dart';
import '../map_discovery/discovery_models.dart';
import 'procurement_models.dart';
import 'procurement_repository.dart';

/// Explore dashboard and Search Results state. The origin and radius are the Map's (one shared
/// DiscoveryController), so Explore never picks a different location silently. Every request is
/// tagged with a sequence and the origin/radius/query/filters it was made for; a response that no
/// longer matches the current selection is discarded, so a slow reply never overwrites newer state.
/// Filters, sort, query and scroll offsets live here and survive navigation.
class ExploreController extends ChangeNotifier {
  ExploreController({
    required ProcurementRepository repository,
    required DiscoveryController discovery,
  }) : _repository = repository,
       _discovery = discovery {
    _discovery.addListener(_onDiscoveryChanged);
    _scopeKey = _currentScopeKey;
  }

  final ProcurementRepository _repository;
  final DiscoveryController _discovery;

  LoadPhase summaryPhase = LoadPhase.loading;
  ExploreSummaryView? summary;
  DiscoveryFailure? summaryFailure;

  /// True while an earlier summary stays visible after a failed refresh; it is labelled, never current.
  bool summaryStale = false;

  String query = '';
  ListingFilters filters = const ListingFilters();
  ListingSort? sort;
  LoadPhase searchPhase = LoadPhase.loading;
  ListingSearchPage? page;
  List<ListingCardView> results = const [];
  DiscoveryFailure? searchFailure;
  bool loadingMore = false;
  bool searchActive = false;
  final List<String> _recentSearches = [];
  List<String> get recentSearches => List.unmodifiable(_recentSearches);

  void clearRecentSearches() {
    _recentSearches.clear();
    _notify();
  }

  /// Suggestions use the same authorized, radius-scoped search, without changing
  /// the catalog's query, filters, cursor or scroll position.
  Future<List<String>> suggestions(
    String text, {
    ListingFilters? withinFilters,
  }) async {
    final selectedOrigin = origin;
    if (selectedOrigin == null || text.trim().isEmpty) return const [];
    final response = await _repository.search(
      origin: selectedOrigin,
      radiusKm: radiusKm,
      query: text.trim(),
      filters: withinFilters ?? filters,
      sort: ListingSort.bestDeal,
    );
    return response.items
        .map((item) => item.displayName)
        .toSet()
        .take(8)
        .toList();
  }

  double exploreScrollOffset = 0;
  double resultsScrollOffset = 0;

  int _summarySequence = 0;
  int _searchSequence = 0;
  String _scopeKey = '';
  bool _disposed = false;

  DiscoveryOrigin? get origin => _discovery.origin;
  int get radiusKm => _discovery.radiusKm;
  List<SavedLocationView> get savedLocations => _discovery.savedLocations;
  DiscoveryController get discovery => _discovery;

  ListingSort get effectiveSort =>
      sort ??
      page?.defaultSort ??
      (query.trim().isEmpty ? ListingSort.distance : ListingSort.bestDeal);

  String get _currentScopeKey => '${origin?.identity ?? '-'}|$radiusKm';

  Future<void> loadSummary() async {
    final currentOrigin = origin;
    if (currentOrigin == null) {
      summaryPhase = LoadPhase.needsOrigin;
      _notify();
      return;
    }
    final sequence = ++_summarySequence;
    final scope = _currentScopeKey;
    summaryPhase = LoadPhase.loading;
    summaryFailure = null;
    _notify();
    try {
      final result = await _repository.exploreSummary(
        origin: currentOrigin,
        radiusKm: radiusKm,
      );
      if (_disposed ||
          sequence != _summarySequence ||
          scope != _currentScopeKey) {
        return;
      }
      summary = result;
      summaryStale = false;
      summaryPhase = LoadPhase.ready;
    } on DiscoveryFailure catch (error) {
      if (_disposed ||
          sequence != _summarySequence ||
          scope != _currentScopeKey) {
        return;
      }
      summaryFailure = error;
      summaryStale = summary != null;
      summaryPhase = summary == null ? LoadPhase.failed : LoadPhase.ready;
    }
    _notify();
  }

  /// Starts a new result set for the query and filters; the previous cursor is dropped.
  Future<void> search({
    String? query,
    ListingFilters? filters,
    ValueGetter<ListingSort?>? sort,
  }) async {
    final previousQuery = this.query;
    final previousFilters = this.filters;
    if (query != null) {
      this.query = query.trim();
      if (this.query.isNotEmpty) {
        _recentSearches.removeWhere(
          (item) => item.toLowerCase() == this.query.toLowerCase(),
        );
        _recentSearches.insert(0, this.query);
        if (_recentSearches.length > 10) _recentSearches.removeLast();
      }
    }
    if (filters != null) this.filters = filters;
    if (sort != null) this.sort = sort();
    if (previousQuery != this.query || previousFilters != this.filters) {
      results = const [];
      page = null;
    }
    searchActive = true;
    resultsScrollOffset = 0;
    await _runSearch();
  }

  Future<void> retrySearch() => _runSearch();

  Future<void> loadMore() async {
    final current = page;
    final currentOrigin = origin;
    if (current == null ||
        !current.hasMore ||
        current.nextCursor == null ||
        loadingMore ||
        currentOrigin == null) {
      return;
    }
    if (searchPhase != LoadPhase.ready || searchFailure != null) return;
    final sequence = _searchSequence;
    loadingMore = true;
    _notify();
    try {
      final next = await _repository.search(
        origin: currentOrigin,
        radiusKm: radiusKm,
        query: query,
        filters: filters,
        sort: sort,
        cursor: current.nextCursor,
      );
      if (_disposed || sequence != _searchSequence) return;
      final known = results.map((card) => card.listingId).toSet();
      results = [
        ...results,
        ...next.items.where((card) => !known.contains(card.listingId)),
      ];
      page = next;
      _applyFavoriteUpdates();
    } on DiscoveryFailure catch (error) {
      if (!_disposed && sequence == _searchSequence) searchFailure = error;
    } finally {
      if (!_disposed && sequence == _searchSequence) {
        loadingMore = false;
        _notify();
      }
    }
  }

  void clearFilters() {
    search(filters: const ListingFilters());
  }

  void rememberExploreScroll(double offset) => exploreScrollOffset = offset;

  void rememberResultsScroll(double offset) => resultsScrollOffset = offset;

  /// A Favorite toggled elsewhere updates the visible cards without re-ranking them.
  bool favoriteBusy(String vendorId) => _discovery.favoriteBusy(vendorId);

  Future<void> setFavorite(String vendorId, {required bool favorite}) =>
      _discovery.setFavorite(vendorId, favorite: favorite);

  void markFavorite(String vendorId, {required bool favorite}) {
    results = [
      for (final card in results)
        card.vendorId == vendorId
            ? ListingCardView(
                listingId: card.listingId,
                variantId: card.variantId,
                rank: card.rank,
                displayName: card.displayName,
                unitPriceCentavos: card.unitPriceCentavos,
                unitName: card.unitName,
                vatLabel: card.vatLabel,
                stockLabel: card.stockLabel,
                stockConfirmedAt: card.stockConfirmedAt,
                ratingLabel: card.ratingLabel,
                ratingAverage: card.ratingAverage,
                unitsSold: card.unitsSold,
                distanceMeters: card.distanceMeters,
                badges: card.badges,
                isFavorite: favorite,
                vendorId: card.vendorId,
                vendorName: card.vendorName,
                vendorScore: card.vendorScore,
                pickupAvailable: card.pickupAvailable,
                delivery: card.delivery,
                optionsCount: card.optionsCount,
                srs: card.srs,
                components: card.components,
                imageUrl: card.imageUrl,
                imageAlt: card.imageAlt,
                brand: card.brand,
                variantLabel: card.variantLabel,
                normalizedUnitPrice: card.normalizedUnitPrice,
                canonicalUnitCode: card.canonicalUnitCode,
              )
            : card,
    ];
    _notify();
  }

  Future<void> _runSearch() async {
    final currentOrigin = origin;
    if (currentOrigin == null) {
      searchPhase = LoadPhase.needsOrigin;
      _notify();
      return;
    }
    final sequence = ++_searchSequence;
    final scope = _currentScopeKey;
    final requestedQuery = query;
    final requestedFilters = filters;
    final requestedSort = sort;
    searchPhase = LoadPhase.loading;
    searchFailure = null;
    loadingMore = false;
    _notify();
    try {
      final result = await _repository.search(
        origin: currentOrigin,
        radiusKm: radiusKm,
        query: requestedQuery,
        filters: requestedFilters,
        sort: requestedSort,
      );
      if (!_stillCurrent(
        sequence,
        scope,
        requestedQuery,
        requestedFilters,
        requestedSort,
      )) {
        return;
      }
      page = result;
      results = result.items;
      _applyFavoriteUpdates();
      searchPhase = LoadPhase.ready;
    } on DiscoveryFailure catch (error) {
      if (!_stillCurrent(
        sequence,
        scope,
        requestedQuery,
        requestedFilters,
        requestedSort,
      )) {
        return;
      }
      searchFailure = error;
      searchPhase = results.isEmpty ? LoadPhase.failed : LoadPhase.ready;
    }
    _notify();
  }

  bool _stillCurrent(
    int sequence,
    String scope,
    String requestedQuery,
    ListingFilters requestedFilters,
    ListingSort? requestedSort,
  ) =>
      !_disposed &&
      sequence == _searchSequence &&
      scope == _currentScopeKey &&
      requestedQuery == query &&
      requestedFilters == filters &&
      requestedSort == sort;

  void _applyFavoriteUpdates() {
    for (final entry in _discovery.favoriteUpdates.entries) {
      if (results.any(
        (card) => card.vendorId == entry.key && card.isFavorite != entry.value,
      )) {
        markFavorite(entry.key, favorite: entry.value);
      }
    }
  }

  void _onDiscoveryChanged() {
    _applyFavoriteUpdates();
    _notify();
    final next = _currentScopeKey;
    if (next == _scopeKey) return;
    // A new Map origin or radius makes every count and ranking stale: reload both.
    _scopeKey = next;
    results = const [];
    page = null;
    loadSummary();
    if (searchActive) _runSearch();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _discovery.removeListener(_onDiscoveryChanged);
    super.dispose();
  }
}
