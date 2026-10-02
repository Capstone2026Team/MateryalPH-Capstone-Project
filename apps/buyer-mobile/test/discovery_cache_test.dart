import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/features/map_discovery/directory_photo_loader.dart';
import 'package:materyalph/features/map_discovery/discovery_controller.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';
import 'package:materyalph/features/map_discovery/discovery_result_cache.dart';

import 'map_discovery_fakes.dart';

const _saved = DiscoveryOrigin.saved(
  locationId: 'loc-1',
  label: '629 J Nepomuceno St',
  point: GeoPoint(14.5995, 120.9842),
);

DiscoveryController _controller(
  FakeDiscoveryRepository repo,
  MemoryDiscoveryResultStore store,
  DateTime Function() now,
) => DiscoveryController(repository: repo, store: store, now: now);

void main() {
  test('results survive an app restart and cost no request while fresh', () async {
    var now = DateTime.utc(2026, 10, 3, 8);
    final store = MemoryDiscoveryResultStore();
    final firstRepo = FakeDiscoveryRepository();
    final first = _controller(firstRepo, store, () => now);
    await first.setOrigin(_saved);
    expect(firstRepo.searches, hasLength(1));
    expect(store.entries.keys, ['loc-loc-1-r5']);

    // A new launch: new controller and repository, same store, two minutes later.
    now = now.add(const Duration(minutes: 2));
    final secondRepo = FakeDiscoveryRepository();
    final second = _controller(secondRepo, store, () => now);
    await second.setOrigin(_saved);
    expect(secondRepo.searches, isEmpty);
    expect(second.phase, DiscoveryPhase.ready);
    expect(second.items.map((item) => item.resultId), ['v-1', 'd-1']);
    expect(second.items.first.name, 'Sampaloc Lumber Hardware');
    first.dispose();
    second.dispose();
  });

  test('a copy past the fresh window shows at once, then is confirmed by one request', () async {
    var now = DateTime.utc(2026, 10, 3, 8);
    final store = MemoryDiscoveryResultStore();
    final seed = FakeDiscoveryRepository();
    final first = _controller(seed, store, () => now);
    await first.setOrigin(_saved);

    now = now.add(const Duration(hours: 3));
    final repo = FakeDiscoveryRepository(
      page: resultPage([verifiedSupplier('v-9', name: 'Fresh Hardware')]),
    )..manual = true;
    final second = _controller(repo, store, () => now);
    final pending = second.setOrigin(_saved);
    await Future<void>.delayed(Duration.zero);
    // Instantly visible from the saved copy while the request is still in flight.
    expect(second.showingSavedResults, isTrue);
    expect(second.items.map((item) => item.resultId), ['v-1', 'd-1']);
    expect(repo.searches, hasLength(1));
    repo.searches.single.completer.complete(repo.page);
    await pending;
    expect(second.showingSavedResults, isFalse);
    expect(second.items.map((item) => item.resultId), ['v-9']);
    expect(store.entries['loc-loc-1-r5']!.items.single.name, 'Fresh Hardware');
    first.dispose();
    second.dispose();
  });

  test('a copy older than 24 hours is never shown', () async {
    var now = DateTime.utc(2026, 10, 3, 8);
    final store = MemoryDiscoveryResultStore();
    final first = _controller(FakeDiscoveryRepository(), store, () => now);
    await first.setOrigin(_saved);

    now = now.add(const Duration(hours: 25));
    final repo = FakeDiscoveryRepository()..manual = true;
    final second = _controller(repo, store, () => now);
    final pending = second.setOrigin(_saved);
    await Future<void>.delayed(Duration.zero);
    expect(second.showingSavedResults, isFalse);
    expect(second.items, isEmpty);
    repo.searches.single.completer.complete(repo.page);
    await pending;
    first.dispose();
    second.dispose();
  });

  test('a new radius is a new area and is requested once', () async {
    final now = DateTime.utc(2026, 10, 3, 8);
    final store = MemoryDiscoveryResultStore();
    final repo = FakeDiscoveryRepository();
    final controller = _controller(repo, store, () => now);
    await controller.setOrigin(_saved);
    await controller.selectRadius(10);
    expect(repo.searches.map((call) => call.radiusKm), [5, 10]);
    await controller.selectRadius(5);
    // Back to a radius already scanned: nothing is requested.
    expect(repo.searches, hasLength(2));
    expect(store.entries.keys.toSet(), {'loc-loc-1-r5', 'loc-loc-1-r10'});
    controller.dispose();
  });

  test('device or pin coordinates are never saved', () async {
    final store = MemoryDiscoveryResultStore();
    final repo = FakeDiscoveryRepository();
    final controller = _controller(repo, store, DateTime.now);
    await controller.setOrigin(
      const DiscoveryOrigin.point(
        point: GeoPoint(14.6, 121.0),
        source: OriginSource.device,
        label: 'Current location',
      ),
    );
    expect(store.entries, isEmpty);
    controller.dispose();
  });

  test('pull-to-refresh always asks the server', () async {
    final now = DateTime.utc(2026, 10, 3, 8);
    final store = MemoryDiscoveryResultStore();
    final repo = FakeDiscoveryRepository();
    final controller = _controller(repo, store, () => now);
    await controller.setOrigin(_saved);
    await controller.refresh();
    expect(repo.searches, hasLength(2));
    controller.dispose();
  });

  test('a saved favorite change updates the saved copy', () async {
    final store = MemoryDiscoveryResultStore();
    final controller = _controller(
      FakeDiscoveryRepository(),
      store,
      DateTime.now,
    );
    await controller.setOrigin(_saved);
    await controller.toggleFavorite(controller.items.first);
    expect(store.entries['loc-loc-1-r5']!.items.first.isFavorite, isTrue);
    controller.dispose();
  });

  test('Directory details are reused for the session instead of re-fetched', () async {
    var now = DateTime.utc(2026, 10, 3, 8);
    final repo = FakeDiscoveryRepository();
    final controller = _controller(repo, MemoryDiscoveryResultStore(), () => now);
    await controller.setOrigin(_saved);
    await controller.select('d-1');
    controller.clearSelection();
    await controller.select('d-1');
    expect(repo.detailCalls, 1);
    expect(controller.directoryDetails, isNotNull);
    now = now.add(const Duration(minutes: 16));
    controller.clearSelection();
    await controller.select('d-1');
    expect(repo.detailCalls, 2);
    controller.dispose();
  });

  test('the cache file round-trips every field and rejects corrupt data', () {
    final page = resultPage([
      verifiedSupplier('v-1', logoUrl: 'https://media.example.test/logo'),
      directorySupplier('d-1'),
    ], suggested: 10);
    final value = CachedDiscovery(
      items: page.items,
      page: page,
      savedAt: DateTime.utc(2026, 10, 3, 8),
    );
    final decoded = decodeCachedDiscovery(encodeCachedDiscovery(value))!;
    expect(decoded.savedAt, value.savedAt);
    expect(decoded.page.suggestedRadiusKm, 10);
    expect(decoded.page.hasMore, isFalse);
    expect(decoded.items.first.logoUrl, 'https://media.example.test/logo');
    expect(decoded.items.first.openState!.closesAt, '17:30');
    expect(decoded.items.last.tier, SupplierTier.directory);
    expect(decoded.items.last.point.latitude, 14.62);
    expect(decodeCachedDiscovery('{not json'), isNull);
  });

  test('a thumbnail is fetched once per place per session', () async {
    var now = DateTime.utc(2026, 10, 3, 8);
    final repo = FakeDiscoveryRepository();
    final loader = DirectoryPhotoLoader(repo, now: () => now);
    await loader.load('d-1', () => true);
    await loader.load('d-1', () => true);
    expect(repo.photoCalls, 1);
    expect(loader.cached('d-1'), isNotNull);
    now = now.add(const Duration(minutes: 31));
    expect(loader.cached('d-1'), isNull);
    await loader.load('d-1', () => true);
    expect(repo.photoCalls, 2);
    loader.dispose();
  });
}
