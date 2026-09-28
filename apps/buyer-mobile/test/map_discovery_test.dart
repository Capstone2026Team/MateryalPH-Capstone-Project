import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/map_discovery/device_location.dart';
import 'package:materyalph/features/map_discovery/discovery_controller.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';
import 'package:materyalph/features/map_discovery/map_geometry.dart';
import 'package:materyalph/features/map_discovery/map_home_screen.dart';
import 'package:materyalph/features/map_discovery/supplier_map.dart';

import 'map_discovery_fakes.dart';

void main() {
  group('map geometry', () {
    test('decodes the Routes API encoded polyline', () {
      final points = decodePolyline('_p~iF~ps|U_ulLnnqC_mqNvxq`@');
      expect(points, const [
        GeoPoint(38.5, -120.2),
        GeoPoint(40.7, -120.95),
        GeoPoint(43.252, -126.453),
      ]);
    });

    test(
      'clusters when zoomed out, separates from zoom 14 and never hides the selection',
      () {
        final items = [
          verifiedSupplier(
            'a',
            rank: 1,
            latitude: 14.6100,
            longitude: 120.9900,
          ),
          verifiedSupplier(
            'b',
            rank: 2,
            latitude: 14.6102,
            longitude: 120.9902,
            favorite: true,
          ),
          directorySupplier(
            'c',
            rank: 3,
            latitude: 14.6101,
            longitude: 120.9901,
          ),
        ];
        final clustered = clusterSuppliers(items, 10);
        expect(clustered, hasLength(1));
        expect(
          clustered.single.semanticsLabel,
          contains(
            '3 suppliers in this area: 2 Verified Vendors and 1 Directory Supplier',
          ),
        );
        expect(clusterSuppliers(items, 15), hasLength(3));
        final withSelection = clusterSuppliers(items, 10, selectedId: 'b');
        expect(
          withSelection
              .where((group) => !group.isCluster)
              .single
              .single
              .resultId,
          'b',
        );
      },
    );

    test(
      'labels avoid collisions by keeping the selected supplier and then server rank',
      () {
        final items = [
          verifiedSupplier(
            'first',
            rank: 1,
            latitude: 14.61,
            longitude: 120.99,
          ),
          verifiedSupplier(
            'second',
            rank: 2,
            latitude: 14.61001,
            longitude: 120.99001,
          ),
          verifiedSupplier('far', rank: 3, latitude: 14.70, longitude: 121.10),
        ];
        final groups = clusterSuppliers(items, 16);
        expect(placeLabels(groups, 16), {'first', 'far'});
        expect(placeLabels(groups, 16, selectedId: 'second'), {
          'second',
          'far',
        });
        expect(
          items.first.markerLabel,
          'Sampaloc Lumber Hardware · New Vendor',
        );
        expect(
          directorySupplier('d').markerLabel,
          'Panda Construction Supply · Directory',
        );
      },
    );
  });

  test('a selection isolates its marker; a stale selection shows all', () {
    final items = [
      verifiedSupplier('a', rank: 1),
      directorySupplier('b', rank: 2),
    ];
    expect(mapVisibleSuppliers(items, null), items);
    expect(mapVisibleSuppliers(items, 'b').map((item) => item.resultId), ['b']);
    expect(mapVisibleSuppliers(items, 'gone'), items);
  });

  group('discovery controller', () {
    test('discards a slow search for an earlier origin', () async {
      final repository = FakeDiscoveryRepository(manual: true);
      final controller = DiscoveryController(repository: repository);
      final first = controller.setOrigin(
        const DiscoveryOrigin.point(
          point: GeoPoint(14.6, 121.0),
          source: OriginSource.mapPin,
          label: 'First',
        ),
      );
      final second = controller.setOrigin(
        const DiscoveryOrigin.point(
          point: GeoPoint(14.7, 121.1),
          source: OriginSource.mapPin,
          label: 'Second',
        ),
      );
      repository.searches[1].completer.complete(
        resultPage([verifiedSupplier('new-origin')]),
      );
      await second;
      repository.searches[0].completer.complete(
        resultPage([verifiedSupplier('old-origin')]),
      );
      await first;
      expect(controller.items.map((item) => item.resultId), ['new-origin']);
      expect(controller.origin!.label, 'Second');
    });

    test(
      'applies only the route for the current selection and origin version',
      () async {
        final repository = FakeDiscoveryRepository(manual: true);
        final controller = DiscoveryController(repository: repository);
        final origin = controller.setOrigin(
          const DiscoveryOrigin.point(
            point: GeoPoint(14.6, 121.0),
            source: OriginSource.device,
            label: 'Current location',
          ),
        );
        repository.searches.single.completer.complete(repository.page);
        await origin;
        final supplierA = controller.items.first;
        final supplierB = controller.items.last;
        final selectA = controller.select(supplierA.resultId);
        final selectB = controller.select(supplierB.resultId);
        await Future<void>.delayed(Duration.zero);
        repository.routes.last.completer.complete(
          repository.routeFor(supplierB, repository.routes.last.requestVersion),
        );
        repository.routes.first.completer.complete(
          repository.routeFor(
            supplierA,
            repository.routes.first.requestVersion,
          ),
        );
        await Future.wait([selectA, selectB]);
        expect(controller.selectedId, supplierB.resultId);
        expect(controller.route!.supplierId, supplierB.resultId);

        final retry = controller.retryRoute();
        repository.routes.last.completer.complete(
          repository.routeFor(
            supplierB,
            repository.routes.last.requestVersion,
            originVersion: 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb',
          ),
        );
        await retry;
        expect(
          controller.routePhase,
          RoutePhase.loading,
          reason: 'A route for another origin version is ignored.',
        );
      },
    );

    test('expansion is only suggested until the Buyer accepts it', () async {
      final repository = FakeDiscoveryRepository(
        page: resultPage([verifiedSupplier('only')], suggested: 10),
      );
      final controller = DiscoveryController(repository: repository);
      await controller.initialize();
      expect(controller.radiusKm, 5);
      expect(controller.suggestedRadiusKm, 10);
      expect(repository.savedRadii, isEmpty);
      expect(repository.searches.every((call) => call.radiusKm == 5), isTrue);
      await controller.acceptExpansion();
      expect(controller.radiusKm, 10);
      expect(repository.savedRadii, [10]);
      expect(repository.searches.last.radiusKm, 10);
    });

    test(
      'offline refresh keeps labelled results and never shows an old ETA as current',
      () async {
        final repository = FakeDiscoveryRepository();
        final controller = DiscoveryController(repository: repository);
        await controller.initialize();
        await controller.select('v-1');
        expect(controller.route, isNotNull);
        repository.searchFailure = const DiscoveryFailure(
          DiscoveryFailureKind.offline,
          'You appear to be offline.',
        );
        await controller.refresh();
        expect(controller.items, isNotEmpty);
        expect(controller.resultsStale, isTrue);
        expect(controller.route, isNull);
      },
    );

    test('favorites apply only to Verified Vendors', () async {
      final repository = FakeDiscoveryRepository();
      final controller = DiscoveryController(repository: repository);
      await controller.initialize();
      await controller.toggleFavorite(controller.items.last);
      expect(repository.favoriteChanges, isEmpty);
      await controller.toggleFavorite(controller.items.first);
      expect(repository.favoriteChanges, [('v-1', true)]);
      expect(controller.items.first.isFavorite, isTrue);
    });
  });

  group('Map Home', () {
    Future<(FakeDiscoveryRepository, RecordingMap)> pumpMapHome(
      WidgetTester tester, {
      FakeDiscoveryRepository? repository,
      DeviceLocationService? device,
      bool reduceMotion = false,
    }) async {
      final repo = repository ?? FakeDiscoveryRepository();
      final map = RecordingMap();
      await tester.pumpWidget(
        MaterialApp(
          theme: BuyerTheme.light,
          home: Builder(
            builder: (context) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(disableAnimations: reduceMotion),
              child: MapHomeScreen(
                repository: repo,
                deviceLocation:
                    device ??
                    FakeDeviceLocation(
                      const DeviceLocationResult(DeviceLocationStatus.denied),
                    ),
                mapBuilder: map.build,
                onOpenStore: (_, _) {},
                openLink: (_) async {},
                share: (_) {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      return (repo, map);
    }

    testWidgets('denied GPS keeps manual address and pin paths complete', (
      tester,
    ) async {
      final device = FakeDeviceLocation(
        const DeviceLocationResult(DeviceLocationStatus.denied),
      );
      await pumpMapHome(
        tester,
        repository: FakeDiscoveryRepository(locationsList: const []),
        device: device,
      );
      // First entry is its own full-screen page, not part of Map Home.
      expect(find.text('Hi, nice to meet you!'), findsOneWidget);
      expect(find.text('Suppliers near you'), findsNothing);
      expect(find.byTooltip('Search'), findsNothing);
      await tester.ensureVisible(find.text('Use current location'));
      await tester.tap(find.text('Use current location'));
      await tester.pumpAndSettle();
      expect(device.requests, 1);
      expect(
        find.textContaining('Location permission was not granted'),
        findsOneWidget,
      );
      await tester.ensureVisible(find.text('Select it manually'));
      await tester.tap(find.text('Select it manually'));
      await tester.pumpAndSettle();
      expect(find.text('Search address'), findsOneWidget);
      expect(find.text('Drop pin'), findsOneWidget);
      expect(find.text('City or municipality'), findsOneWidget);
      await tester.tap(find.text('Drop pin'));
      await tester.pumpAndSettle();
      for (final removed in ['Latitude', 'Longitude', 'Enter coordinates']) {
        expect(find.text(removed), findsNothing);
      }
    });

    testWidgets(
      'current location from the location page shows its street address',
      (tester) async {
        final repository = FakeDiscoveryRepository(locationsList: const [])
          ..pointAddress =
              '123 Rizal Avenue, Santa Cruz, Manila, 1003 Metro Manila, Philippines';
        final (_, map) = await pumpMapHome(
          tester,
          repository: repository,
          device: FakeDeviceLocation(
            const DeviceLocationResult(
              DeviceLocationStatus.granted,
              GeoPoint(14.6177, 120.9836),
            ),
          ),
        );
        await tester.ensureVisible(find.text('Use current location'));
        await tester.tap(find.text('Use current location'));
        await tester.pumpAndSettle();
        expect(find.text('Hi, nice to meet you!'), findsNothing);
        expect(repository.resolvedPoints.single.$2, isTrue);
        expect(
          find.text('123 Rizal Avenue, Santa Cruz, Manila, 1003 Metro Manila'),
          findsOneWidget,
        );
        expect(find.text('Current location'), findsNothing);
        expect(map.last.origin, const GeoPoint(14.6177, 120.9836));
      },
    );

    testWidgets('leaving the location page shows a prompt that reopens it', (
      tester,
    ) async {
      await pumpMapHome(
        tester,
        repository: FakeDiscoveryRepository(locationsList: const []),
      );
      // System back (Android back button or gesture); the page has no app bar.
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Hi, nice to meet you!'), findsNothing);
      await tester.tap(find.text('Choose a location').last);
      await tester.pumpAndSettle();
      expect(find.text('Hi, nice to meet you!'), findsOneWidget);
    });

    testWidgets(
      'selecting a supplier isolates its pin until the selection closes',
      (tester) async {
        final (_, map) = await pumpMapHome(tester);
        expect(find.byKey(const ValueKey('marker-v-1')), findsOneWidget);
        expect(find.byKey(const ValueKey('marker-d-1')), findsOneWidget);
        await tester.tap(find.byKey(const ValueKey('marker-d-1')));
        await tester.pumpAndSettle();
        expect(find.byKey(const ValueKey('marker-v-1')), findsNothing);
        expect(find.byKey(const ValueKey('marker-d-1')), findsOneWidget);
        expect(
          map.last.items,
          hasLength(2),
          reason: 'Isolation is a map rendering rule; results are unchanged.',
        );
        await tester.tap(find.byTooltip('Close preview'));
        await tester.pumpAndSettle();
        expect(find.byKey(const ValueKey('marker-v-1')), findsOneWidget);
        expect(find.byKey(const ValueKey('marker-d-1')), findsOneWidget);
      },
    );

    testWidgets('the layers control switches between Map and Satellite', (
      tester,
    ) async {
      final (_, map) = await pumpMapHome(tester);
      expect(map.last.baseMap, BaseMapStyle.standard);
      await tester.tap(find.byTooltip('Map type and legend'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Satellite'));
      await tester.pumpAndSettle();
      expect(map.last.baseMap, BaseMapStyle.satellite);
      await tester.tap(find.byTooltip('Map type and legend'));
      await tester.pumpAndSettle();
      expect(find.bySemanticsLabel('Satellite map, selected'), findsOneWidget);
      await tester.tap(find.text('Map legend'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Directory Supplier: gray'), findsOneWidget);
    });

    testWidgets(
      'the list and map receive the same suppliers in the same order',
      (tester) async {
        final (_, map) = await pumpMapHome(tester);
        expect(map.last.items.map((item) => item.resultId), ['v-1', 'd-1']);
        final listed =
            tester
                .widgetList<Text>(find.text('Sampaloc Lumber Hardware'))
                .length +
            tester
                .widgetList<Text>(find.text('Panda Construction Supply'))
                .length;
        expect(listed, 2);
        expect(
          tester.getTopLeft(find.text('Sampaloc Lumber Hardware')).dy,
          lessThan(
            tester.getTopLeft(find.text('Panda Construction Supply')).dy,
          ),
        );
        expect(
          find.textContaining('°'),
          findsNothing,
          reason: 'No weather widget.',
        );
      },
    );

    testWidgets(
      'Tier 2 selection synchronizes map and list, shows route and one View Store action',
      (tester) async {
        final (repository, map) = await pumpMapHome(tester);
        await tester.tap(find.text('Sampaloc Lumber Hardware'));
        await tester.pumpAndSettle();
        expect(map.last.selectedId, 'v-1');
        expect(map.last.routePath, isNotNull);
        expect(repository.routes, hasLength(1));
        expect(find.text('View Store'), findsOneWidget);
        expect(find.byTooltip('Message this store'), findsOneWidget);
        expect(find.byTooltip('Save as Favorite Supplier'), findsOneWidget);
        expect(find.textContaining('4.2 km · 18 min drive'), findsOneWidget);
        expect(
          find.textContaining('New Vendor — Building Track Record'),
          findsOneWidget,
        );
        expect(find.textContaining('Google rating'), findsNothing);
      },
    );

    testWidgets(
      'Tier 1 selection shows attributed details and only informational actions',
      (tester) async {
        final (repository, _) = await pumpMapHome(tester);
        await tester.tap(find.byKey(const ValueKey('marker-d-1')));
        await tester.pumpAndSettle();
        expect(repository.detailCalls, 1);
        expect(find.byTooltip('Share'), findsOneWidget);
        for (final action in ['Call', 'Open in Google Maps', 'Website']) {
          await tester.scrollUntilVisible(
            find.text(action),
            100,
            scrollable: find.byType(Scrollable).last,
          );
          expect(find.text(action), findsOneWidget);
        }
        expect(find.text('Google rating 4.8 (120)'), findsOneWidget);
        expect(find.textContaining('Source: Google Maps'), findsWidgets);
        // Overview and About only: no review tab and no photos for Directory Suppliers.
        expect(find.text('Overview'), findsOneWidget);
        await tester.tap(find.text('About'));
        await tester.pumpAndSettle();
        expect(find.text('Opening hours'), findsOneWidget);
        for (final forbidden in [
          'View Store',
          'Message',
          'Add to Cart',
          'Order',
          'Review',
          'Reviews',
          'Save as Favorite Supplier',
        ]) {
          expect(find.text(forbidden), findsNothing);
        }
        expect(find.byTooltip('Save as Favorite Supplier'), findsNothing);
        expect(find.byTooltip('Message this store'), findsNothing);
        expect(find.textContaining('VPS'), findsNothing);
      },
    );

    testWidgets(
      'route failure keeps the supplier selected with straight-line distance and retry',
      (tester) async {
        final repository = FakeDiscoveryRepository()
          ..routeFailure = const DiscoveryFailure(
            DiscoveryFailureKind.provider,
            'Driving time is unavailable.',
            details: {'straight_line_meters': 1900},
          );
        await pumpMapHome(tester, repository: repository);
        await tester.tap(find.text('Sampaloc Lumber Hardware'));
        await tester.pumpAndSettle();
        expect(
          find.textContaining(
            'Driving time unavailable · 1.9 km straight-line',
          ),
          findsOneWidget,
        );
        expect(find.text('View Store'), findsOneWidget);
        repository.routeFailure = null;
        await tester.tap(find.text('Retry'));
        await tester.pumpAndSettle();
        expect(repository.routes, hasLength(2));
      },
    );

    testWidgets('expansion asks first and keeps the radius when declined', (
      tester,
    ) async {
      final repository = FakeDiscoveryRepository(
        page: resultPage([verifiedSupplier('only')], suggested: 10),
      );
      await pumpMapHome(tester, repository: repository);
      await tester.scrollUntilVisible(
        find.text('Search within 10 km'),
        100,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.tap(find.text('Search within 10 km'));
      await tester.pumpAndSettle();
      expect(find.text('Search within 10 km?'), findsOneWidget);
      await tester.tap(find.text('Keep 5 km'));
      await tester.pumpAndSettle();
      expect(repository.savedRadii, isEmpty);
      expect(repository.searches.last.radiusKm, 5);
      await tester.tap(find.text('Search within 10 km'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Expand to 10 km'));
      await tester.pumpAndSettle();
      expect(repository.searches.last.radiusKm, 10);
    });

    testWidgets('Reduce Motion renders the selection sheet immediately', (
      tester,
    ) async {
      await pumpMapHome(tester, reduceMotion: true);
      await tester.tap(find.text('Sampaloc Lumber Hardware'));
      await tester.pump();
      await tester.pump();
      expect(tester.hasRunningAnimations, isFalse);
      expect(find.text('View Store'), findsOneWidget);
    });

    for (final (size, scale) in [
      (const Size(320, 568), 1.0),
      (const Size(320, 568), 2.0),
      (const Size(844, 390), 1.0),
      (const Size(844, 390), 2.0),
    ]) {
      testWidgets('reflows without overflow at $size and ${scale}x text', (
        tester,
      ) async {
        await tester.binding.setSurfaceSize(size);
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(() {
          tester.platformDispatcher.clearTextScaleFactorTestValue();
          return tester.binding.setSurfaceSize(null);
        });
        await pumpMapHome(tester);
        expect(tester.takeException(), isNull);
        expect(
          find.text('Sampaloc Lumber Hardware', skipOffstage: false),
          findsOneWidget,
        );
        // The accessible list is a peer surface; use it directly at tight sizes.
        await tester.tap(find.byTooltip('List view'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.scrollUntilVisible(
          find.text('Sampaloc Lumber Hardware'),
          60,
          scrollable: find
              .byWidgetPredicate(
                (widget) =>
                    widget is Scrollable &&
                    widget.axisDirection == AxisDirection.down,
              )
              .last,
        );
        await tester.ensureVisible(find.text('Sampaloc Lumber Hardware'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Sampaloc Lumber Hardware'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.text('View Store', skipOffstage: false), findsOneWidget);
      });
    }
  });
}
