import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/features/item_procurement/explore_controller.dart';
import 'package:materyalph/features/item_procurement/procurement_models.dart';
import 'package:materyalph/features/map_discovery/discovery_controller.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';

import 'item_procurement_fakes.dart';
import 'map_discovery_fakes.dart';

void main() {
  late FakeProcurementRepository repo;
  late DiscoveryController discovery;
  late ExploreController controller;
  setUp(() async {
    discovery = DiscoveryController(repository: FakeDiscoveryRepository());
    await discovery.initialize();
    repo = FakeProcurementRepository();
    controller = ExploreController(repository: repo, discovery: discovery);
  });
  tearDown(() {
    controller.dispose();
    discovery.dispose();
  });

  test(
    'summary refresh keeps current content while loading and prevents overlap',
    () async {
      await controller.loadSummary();
      repo.manualSummary = true;
      final pending = controller.revalidateSummary();
      await controller.revalidateSummary();
      expect(repo.summaryCalls, hasLength(2));
      expect(controller.summaryPhase, LoadPhase.ready);
      expect(controller.summary?.verifiedVendors, 12);
      repo.summaryCalls.last.complete(summaryFixture(vendors: 13));
      expect(await pending, isTrue);
      expect(controller.summary?.verifiedVendors, 13);
    },
  );

  test(
    'search refresh preserves loaded pages, query, sort and scroll position',
    () async {
      repo.page = searchPage([listingCard('l-1')], hasMore: true);
      await controller.search(
        query: 'cement',
        sort: () => ListingSort.distance,
      );
      repo.page = searchPage([listingCard('l-2')]);
      await controller.loadMore();
      controller.rememberResultsScroll(440);
      repo.manualSearch = true;
      final pending = controller.revalidateSearch();
      await controller.revalidateSearch();
      await controller.loadMore();
      expect(repo.searchCalls, hasLength(3));
      expect(controller.searchPhase, LoadPhase.ready);
      repo.searchCalls.last.complete(
        searchPage([listingCard('l-new')], hasMore: true),
      );
      await Future<void>.delayed(Duration.zero);
      expect(controller.results.map((i) => i.listingId), ['l-1', 'l-2']);
      repo.searchCalls.last.complete(searchPage([listingCard('l-2-updated')]));
      expect(await pending, isTrue);
      expect(controller.results.map((i) => i.listingId), [
        'l-new',
        'l-2-updated',
      ]);
      expect(controller.query, 'cement');
      expect(controller.sort, ListingSort.distance);
      expect(controller.resultsScrollOffset, 440);
    },
  );

  test(
    'failed search refresh retains loaded results and reports failure',
    () async {
      await controller.search();
      repo.searchFailure = const DiscoveryFailure(
        DiscoveryFailureKind.offline,
        'Offline',
      );
      expect(await controller.revalidateSearch(), isFalse);
      expect(controller.results.single.listingId, 'l-1');
      expect(controller.searchFailure, isNotNull);
    },
  );

  test('forbidden refresh clears the catalog summary and results', () async {
    await controller.loadSummary();
    await controller.search();
    const error = DiscoveryFailure(
      DiscoveryFailureKind.forbidden,
      'Unavailable',
    );
    repo.summaryFailure = error;
    repo.searchFailure = error;
    expect(await controller.revalidateSummary(), isFalse);
    expect(await controller.revalidateSearch(), isFalse);
    expect(controller.summary, isNull);
    expect(controller.results, isEmpty);
  });
}
