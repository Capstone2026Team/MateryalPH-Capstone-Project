import 'package:flutter/foundation.dart';

import '../map_discovery/discovery_models.dart';
import 'explore_controller.dart';
import 'procurement_models.dart';
import 'procurement_repository.dart';

/// Same-category public offers, using the catalog's authorization, eligibility,
/// distance ordering and cursor pagination without changing Explore's search.
class RelatedProductsController extends ChangeNotifier {
  RelatedProductsController({
    required ProcurementRepository repository,
    required ExploreController explore,
  }) : _repository = repository,
       _explore = explore {
    _explore.addListener(_onScopeChanged);
  }

  final ProcurementRepository _repository;
  final ExploreController _explore;
  ListingDetailView? _detail;
  String? _scope;
  String? _cursor;
  int _sequence = 0;
  bool _disposed = false;

  List<ListingCardView> items = const [];
  DiscoveryFailure? failure;
  bool loading = false;
  bool loadingMore = false;
  bool hasMore = false;

  String get _currentScope =>
      '${_explore.origin?.identity ?? '-'}|${_explore.radiusKm}';

  Future<void> show(ListingDetailView detail, {bool refresh = false}) async {
    if (!refresh &&
        _detail?.listingId == detail.listingId &&
        _detail?.categoryId == detail.categoryId &&
        _scope == _currentScope) {
      return;
    }
    _detail = detail;
    await reload();
  }

  Future<void> reload() async {
    final detail = _detail;
    if (_disposed || detail == null) return;
    _sequence++;
    _scope = _currentScope;
    items = const [];
    failure = null;
    _cursor = null;
    hasMore = false;
    loadingMore = false;
    loading = false;
    if (_explore.origin == null) {
      failure = const DiscoveryFailure(
        DiscoveryFailureKind.validation,
        'Choose a location on the Map first.',
      );
    } else if (detail.categoryId != null) {
      await _fetch(more: false);
      return;
    }
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (_disposed || loading || loadingMore || !hasMore) return;
    await _fetch(more: true);
  }

  Future<void> _fetch({required bool more}) async {
    final detail = _detail!;
    final origin = _explore.origin!;
    final radiusKm = _explore.radiusKm;
    final sequence = ++_sequence;
    loading = !more;
    loadingMore = more;
    failure = null;
    notifyListeners();
    var cursor = more ? _cursor : null;
    final seen = {detail.listingId, ...items.map((item) => item.listingId)};
    try {
      // A page containing only the current product is not an empty result if
      // the server still has another page. Keep following its cursor.
      while (true) {
        final page = await _repository.search(
          origin: origin,
          radiusKm: radiusKm,
          query: '',
          filters: ListingFilters(categoryId: detail.categoryId),
          sort: ListingSort.distance,
          cursor: cursor,
        );
        if (!_current(sequence)) return;
        final additions = page.items
            .where((item) => seen.add(item.listingId))
            .toList();
        final next = page.nextCursor;
        final canContinue = page.hasMore && next != null && next != cursor;
        if (additions.isNotEmpty || !canContinue) {
          items = [...items, ...additions];
          _cursor = next;
          hasMore = canContinue;
          break;
        }
        cursor = next;
      }
    } on DiscoveryFailure catch (error) {
      if (!_current(sequence)) return;
      failure = error;
    }
    if (!_current(sequence)) return;
    loading = false;
    loadingMore = false;
    notifyListeners();
  }

  bool _current(int sequence) =>
      !_disposed && sequence == _sequence && _scope == _currentScope;

  void _onScopeChanged() {
    if (_detail != null && _scope != _currentScope) reload();
  }

  @override
  void dispose() {
    _disposed = true;
    _sequence++;
    _explore.removeListener(_onScopeChanged);
    super.dispose();
  }
}
