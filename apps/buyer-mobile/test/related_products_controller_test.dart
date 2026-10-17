import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/features/item_procurement/explore_controller.dart';
import 'package:materyalph/features/item_procurement/procurement_models.dart';
import 'package:materyalph/features/item_procurement/related_products_controller.dart';
import 'package:materyalph/features/map_discovery/discovery_controller.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';

import 'item_procurement_fakes.dart';
import 'map_discovery_fakes.dart';

class _Repository extends FakeProcurementRepository {
  final scopes = <({String origin, int radius, String? cursor})>[];

  @override
  Future<ListingSearchPage> search({
    required DiscoveryOrigin origin,
    required int radiusKm,
    required String query,
    required ListingFilters filters,
    ListingSort? sort,
    String? cursor,
  }) {
    scopes.add((origin: origin.identity, radius: radiusKm, cursor: cursor));
    return super.search(
      origin: origin,
      radiusKm: radiusKm,
      query: query,
      filters: filters,
      sort: sort,
      cursor: cursor,
    );
  }
}

Future<void> _settle() => Future<void>.delayed(Duration.zero);

void main() {
  late _Repository repository;
  late DiscoveryController discovery;
  late ExploreController explore;
  late RelatedProductsController related;

  setUp(() async {
    repository = _Repository();
    discovery = DiscoveryController(repository: FakeDiscoveryRepository());
    await discovery.setOrigin(
      DiscoveryOrigin.saved(
        locationId: primaryLocation.id,
        label: primaryLocation.label,
        point: primaryLocation.point,
      ),
    );
    explore = ExploreController(repository: repository, discovery: discovery);
    related = RelatedProductsController(
      repository: repository,
      explore: explore,
    );
  });

  tearDown(() {
    related.dispose();
    explore.dispose();
    discovery.dispose();
  });

  test(
    'loads same-category offers from all vendors without altering search',
    () async {
      repository.page = searchPage([
        listingCard('listing-1'),
        listingCard('same-store'),
        listingCard('other-store', vendorId: 'vendor-2'),
      ]);
      explore.query = 'steel';
      explore.filters = const ListingFilters(vendorId: 'unrelated-vendor');

      await related.show(listingDetail());

      expect(related.items.map((item) => item.listingId), [
        'same-store',
        'other-store',
      ]);
      expect(repository.searches.single.query, '');
      expect(repository.searches.single.filters.categoryId, 'cat-roof');
      expect(repository.searches.single.filters.vendorId, isNull);
      expect(repository.searches.single.sort, ListingSort.distance);
      expect(repository.scopes.single.radius, discovery.radiusKm);
      expect(repository.scopes.single.origin, discovery.origin!.identity);
      expect(explore.query, 'steel');
      expect(explore.filters.vendorId, 'unrelated-vendor');
      await related.show(listingDetail());
      expect(repository.searches, hasLength(1));
    },
  );

  test('no category never falls back to unrelated catalog products', () async {
    await related.show(listingDetail(categoryId: null));
    expect(repository.searches, isEmpty);
    expect(related.items, isEmpty);
    expect(related.failure, isNull);
    expect(related.loading, isFalse);
  });

  test('only the current listing produces a genuine empty result', () async {
    repository.page = searchPage([listingCard('listing-1')]);
    await related.show(listingDetail());
    expect(related.items, isEmpty);
    expect(related.hasMore, isFalse);
    expect(related.failure, isNull);
  });

  test(
    'follows the next page before declaring an excluded page empty',
    () async {
      repository.manualSearch = true;
      final loading = related.show(listingDetail());
      expect(related.loading, isTrue);
      repository.searchCalls[0].complete(
        searchPage([listingCard('listing-1')], hasMore: true),
      );
      await _settle();
      expect(repository.scopes[1].cursor, 'cursor-2');
      repository.searchCalls[1].complete(searchPage([listingCard('related')]));
      await loading;
      expect(related.items.single.listingId, 'related');
      expect(related.loading, isFalse);
    },
  );

  test('pagination deduplicates listings and retries a failed page', () async {
    repository.page = searchPage([listingCard('first')], hasMore: true);
    await related.show(listingDetail());
    repository.searchFailure = const DiscoveryFailure(
      DiscoveryFailureKind.offline,
      'Offline',
    );
    await related.loadMore();
    expect(related.items.single.listingId, 'first');
    expect(related.failure?.kind, DiscoveryFailureKind.offline);
    expect(related.hasMore, isTrue);
    repository.searchFailure = null;
    repository.page = searchPage([
      listingCard('listing-1'),
      listingCard('first'),
      listingCard('second'),
      listingCard('second'),
    ]);
    await related.loadMore();
    expect(related.items.map((item) => item.listingId), ['first', 'second']);
    expect(related.failure, isNull);
    expect(repository.scopes.last.cursor, 'cursor-2');
    expect(related.hasMore, isFalse);
  });

  test('initial failure is recoverable and not an empty result', () async {
    repository.searchFailure = const DiscoveryFailure(
      DiscoveryFailureKind.forbidden,
      'Access denied',
    );
    await related.show(listingDetail());
    expect(related.failure?.kind, DiscoveryFailureKind.forbidden);
    repository.searchFailure = null;
    repository.page = searchPage([listingCard('related')]);
    await related.reload();
    expect(related.failure, isNull);
    expect(related.items.single.listingId, 'related');
  });

  test('radius changes discard old offers and reject late responses', () async {
    repository.manualSearch = true;
    final oldLoad = related.show(listingDetail());
    await discovery.selectRadius(10);
    expect(repository.scopes.last.radius, 10);
    repository.searchCalls[1].complete(searchPage([listingCard('new-scope')]));
    await _settle();
    repository.searchCalls[0].complete(searchPage([listingCard('old-scope')]));
    await oldLoad;
    expect(related.items.single.listingId, 'new-scope');
    expect(related.loading, isFalse);
  });

  test('disposed controllers ignore pending responses', () async {
    repository.manualSearch = true;
    final loading = related.show(listingDetail());
    related.dispose();
    // Replace the disposed controller so tearDown owns one live instance.
    related = RelatedProductsController(
      repository: repository,
      explore: explore,
    );
    repository.searchCalls.single.complete(searchPage([listingCard('late')]));
    await loading;
    expect(related.items, isEmpty);
  });
}
