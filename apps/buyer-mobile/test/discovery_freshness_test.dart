import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/features/map_discovery/discovery_controller.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';

import 'map_discovery_fakes.dart';

void main() {
  test(
    'revalidation replaces both tiers atomically across all pages',
    () async {
      final repo = FakeDiscoveryRepository();
      final controller = DiscoveryController(repository: repo);
      addTearDown(controller.dispose);
      await controller.initialize();
      await controller.select('v-1');
      repo.manual = true;
      final pending = controller.revalidate();
      await controller.revalidate();
      expect(repo.searches, hasLength(2), reason: 'No overlapping poll.');
      expect(controller.phase, DiscoveryPhase.ready);
      expect(controller.route, isNotNull);
      repo.searches.last.completer.complete(
        resultPage(
          [verifiedSupplier('v-1'), verifiedSupplier('v-new')],
          hasMore: true,
          total: 3,
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect(repo.searches.last.page, 2);
      expect(controller.items.map((i) => i.resultId), ['v-1', 'd-1']);
      repo.searches.last.completer.complete(
        resultPage([directorySupplier('d-new')], total: 3),
      );
      expect(await pending, isTrue);
      expect(controller.items.map((i) => i.resultId), [
        'v-1',
        'v-new',
        'd-new',
      ]);
      expect(controller.selectedId, 'v-1');
      expect(
        repo.routes,
        hasLength(1),
        reason: 'Polling does not refetch unchanged routes.',
      );
    },
  );

  test('failed page refresh retains the entire earlier set as stale', () async {
    final repo = FakeDiscoveryRepository();
    final controller = DiscoveryController(repository: repo);
    addTearDown(controller.dispose);
    await controller.initialize();
    await controller.select('v-1');
    repo.manual = true;
    final pending = controller.revalidate();
    repo.searches.last.completer.complete(
      resultPage([verifiedSupplier('v-new')], hasMore: true),
    );
    await Future<void>.delayed(Duration.zero);
    repo.searches.last.completer.completeError(
      const DiscoveryFailure(DiscoveryFailureKind.offline, 'Offline'),
    );
    expect(await pending, isFalse);
    expect(controller.items.map((i) => i.resultId), ['v-1', 'd-1']);
    expect(controller.resultsStale, isTrue);
    expect(controller.route, isNull);
  });

  test(
    'a vendor losing eligibility is removed with its selection and route',
    () async {
      final repo = FakeDiscoveryRepository();
      final controller = DiscoveryController(repository: repo);
      addTearDown(controller.dispose);
      await controller.initialize();
      await controller.select('v-1');
      repo.page = resultPage([directorySupplier('d-1')]);
      await controller.revalidate();
      expect(controller.selectedId, isNull);
      expect(controller.route, isNull);
      expect(controller.items.single.isVerified, isFalse);
    },
  );

  test(
    'unauthorized refresh clears saved results instead of retaining them',
    () async {
      final store = MemoryDiscoveryResultStore();
      final repo = FakeDiscoveryRepository();
      final controller = DiscoveryController(repository: repo, store: store);
      addTearDown(controller.dispose);
      await controller.initialize();
      expect(store.entries, isNotEmpty);
      repo.searchFailure = const DiscoveryFailure(
        DiscoveryFailureKind.forbidden,
        'Unavailable',
      );
      expect(await controller.revalidate(), isFalse);
      expect(controller.items, isEmpty);
      expect(controller.page, isNull);
      expect(store.entries, isEmpty);
    },
  );

  test(
    'a background response from a previous radius cannot overwrite the new radius',
    () async {
      final repo = FakeDiscoveryRepository();
      final controller = DiscoveryController(repository: repo);
      addTearDown(controller.dispose);
      await controller.initialize();
      repo.manual = true;
      final refresh = controller.revalidate();
      final change = controller.selectRadius(10);
      repo.searches.last.completer.complete(
        resultPage([verifiedSupplier('new-radius')], radiusKm: 10),
      );
      await change;
      repo.searches[1].completer.complete(
        resultPage([verifiedSupplier('old-radius')]),
      );
      await refresh;
      expect(controller.items.single.resultId, 'new-radius');
      expect(controller.page?.radiusKm, 10);
    },
  );
}
