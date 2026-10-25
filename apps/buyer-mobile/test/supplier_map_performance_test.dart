import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';
import 'package:materyalph/features/map_discovery/map_geometry.dart';

import 'map_discovery_fakes.dart';

// The previous exhaustive algorithms provide an independent behavioral reference.
List<MapGroup> _referenceClusters(
  List<SupplierResultView> items,
  double zoom, {
  String? selectedId,
}) {
  final radius = clusterCellSize(zoom);
  final groups = <List<SupplierResultView>>[];
  final anchors = <Offset>[];
  for (final item in items) {
    final point = projectToWorld(item.point, zoom);
    var target = -1;
    if (radius > 0 && item.resultId != selectedId) {
      for (var index = 0; index < groups.length; index++) {
        if (groups[index].first.resultId != selectedId &&
            (anchors[index] - point).distance <= radius) {
          target = index;
          break;
        }
      }
    }
    if (target < 0) {
      groups.add([item]);
      anchors.add(point);
    } else {
      groups[target].add(item);
    }
  }
  return groups.map(MapGroup.new).toList();
}

Set<String> _referenceLabels(
  List<MapGroup> groups,
  double zoom, {
  String? selectedId,
  double textScale = 1,
}) {
  final singles = groups.where((group) => !group.isCluster).toList()
    ..sort((a, b) {
      if (a.single.resultId == selectedId) return -1;
      if (b.single.resultId == selectedId) return 1;
      return a.single.rank.compareTo(b.single.rank);
    });
  final placed = <Rect>[];
  final labeled = <String>{};
  for (final group in singles) {
    final item = group.single;
    final anchor = projectToWorld(item.point, zoom);
    final size = estimateLabelSize(item.markerLabel, textScale: textScale);
    final rect = Rect.fromCenter(
      center: anchor.translate(0, -44 * textScale),
      width: size.width,
      height: size.height,
    ).inflate(2);
    if (item.resultId != selectedId &&
        placed.any((other) => other.overlaps(rect))) {
      continue;
    }
    placed.add(rect);
    labeled.add(item.resultId);
  }
  return labeled;
}

List<SupplierResultView> _manyStores(int count) {
  final random = math.Random(617);
  return [
    for (var index = 0; index < count; index++)
      index.isEven
          ? verifiedSupplier(
              'store-$index',
              rank: index,
              latitude: 14.4 + random.nextDouble() * .5,
              longitude: 120.7 + random.nextDouble() * .6,
              favorite: index % 7 == 0,
            )
          : directorySupplier(
              'store-$index',
              rank: index,
              latitude: 14.4 + random.nextDouble() * .5,
              longitude: 120.7 + random.nextDouble() * .6,
            ),
  ];
}

List<List<String>> _members(List<MapGroup> groups) => [
  for (final group in groups) [for (final item in group.members) item.resultId],
];

void main() {
  test(
    'spatial clustering preserves greedy membership, order and selected pins',
    () {
      final items = _manyStores(1500);
      for (final zoom in [10.0, 11.0, 12.0, 13.0, 13.49, 13.5, 18.0]) {
        for (final selected in [null, 'store-733']) {
          final expected = _referenceClusters(
            items,
            zoom,
            selectedId: selected,
          );
          final actual = clusterSuppliers(items, zoom, selectedId: selected);
          expect(
            _members(actual),
            _members(expected),
            reason: 'zoom=$zoom, selected=$selected',
          );
          expect(actual.map((g) => g.id), expected.map((g) => g.id));
        }
      }
    },
  );

  test(
    'label spatial index preserves collision priority at normal and large text',
    () {
      final items = _manyStores(1500);
      for (final zoom in [12.0, 13.5, 16.0, 18.0]) {
        final groups = clusterSuppliers(items, zoom);
        for (final scale in [1.0, 1.6]) {
          for (final selected in [null, 'store-733']) {
            expect(
              placeLabels(groups, zoom, selectedId: selected, textScale: scale),
              _referenceLabels(
                groups,
                zoom,
                selectedId: selected,
                textScale: scale,
              ),
            );
          }
        }
      }
    },
  );

  test(
    'viewport keeps buffered pins and offscreen selection without dropping list results',
    () {
      const zoom = 16.0;
      const center = GeoPoint(14.6, 121);
      final anchor = projectToWorld(center, zoom);
      final southwest = unprojectFromWorld(
        anchor + const Offset(-100, 100),
        zoom,
      );
      final northeast = unprojectFromWorld(
        anchor + const Offset(100, -100),
        zoom,
      );
      final buffered = unprojectFromWorld(anchor + const Offset(280, 0), zoom);
      final outside = unprojectFromWorld(anchor + const Offset(1000, 0), zoom);
      final items = [
        verifiedSupplier(
          'inside',
          latitude: center.latitude,
          longitude: center.longitude,
        ),
        directorySupplier(
          'buffered',
          latitude: buffered.latitude,
          longitude: buffered.longitude,
        ),
        verifiedSupplier(
          'outside',
          latitude: outside.latitude,
          longitude: outside.longitude,
        ),
      ];
      final viewport = SupplierMapViewport(
        southwest: southwest,
        northeast: northeast,
      );
      expect(viewport.suppliers(items, zoom).map((i) => i.resultId), [
        'inside',
        'buffered',
      ]);
      expect(viewport.suppliers(items, zoom, selectedId: 'outside'), items);
      final panned = SupplierMapViewport(
        southwest: unprojectFromWorld(anchor + const Offset(900, 100), zoom),
        northeast: unprojectFromWorld(anchor + const Offset(1100, -100), zoom),
      );
      expect(panned.suppliers(items, zoom).map((i) => i.resultId), ['outside']);
      expect(items, hasLength(3));
    },
  );

  test(
    'unchanged refreshes skip marker work while visible data changes invalidate it',
    () {
      final previous = [verifiedSupplier('v'), directorySupplier('d')];
      expect(
        sameSupplierMarkers(previous, [
          verifiedSupplier('v', distance: 2000),
          directorySupplier('d'),
        ]),
        isTrue,
      );
      final changed = [
        verifiedSupplier('v', name: 'Updated store'),
        verifiedSupplier('v', latitude: 14.7),
        verifiedSupplier('v', rank: 2),
        verifiedSupplier('v', favorite: true),
        verifiedSupplier('v', scoreKind: ScoreKind.vps, scoreText: 'VPS 4.5'),
        directorySupplier('v'),
        verifiedSupplier('new'),
      ];
      for (final item in changed) {
        expect(
          sameSupplierMarkers(previous, [item, directorySupplier('d')]),
          isFalse,
        );
      }
      expect(sameSupplierMarkers(previous, [verifiedSupplier('v')]), isFalse);
    },
  );

  test('5000-store host CPU benchmark and viewport workload', () {
    final items = _manyStores(5000);
    double medianMs(void Function() work) {
      work(); // Warm JIT and allocations before measuring.
      final samples = <int>[];
      for (var run = 0; run < 5; run++) {
        final watch = Stopwatch()..start();
        work();
        samples.add(watch.elapsedMicroseconds);
      }
      samples.sort();
      return samples[2] / 1000;
    }

    final oldCluster = medianMs(() => _referenceClusters(items, 13));
    final newCluster = medianMs(() => clusterSuppliers(items, 13));
    final singles = clusterSuppliers(items, 18);
    final oldLabels = medianMs(() => _referenceLabels(singles, 18));
    final newLabels = medianMs(() => placeLabels(singles, 18));
    const viewport = SupplierMapViewport(
      southwest: GeoPoint(14.59, 120.97),
      northeast: GeoPoint(14.63, 121.02),
    );
    final visible = viewport.suppliers(items, 16);
    expect(visible.length, lessThan(items.length ~/ 10));
    debugPrint(
      '5000 stores, median of 5 host runs (ms): '
      'clusters ${oldCluster.toStringAsFixed(2)} -> ${newCluster.toStringAsFixed(2)}; '
      'labels ${oldLabels.toStringAsFixed(2)} -> ${newLabels.toStringAsFixed(2)}; '
      'buffered viewport ${visible.length}/${items.length} stores. Device FPS not measured.',
    );
  });
}
