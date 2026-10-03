import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/map_discovery/device_location.dart';
import 'package:materyalph/features/map_discovery/discovery_controller.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';
import 'package:materyalph/features/map_discovery/select_location_screen.dart';

import 'map_discovery_fakes.dart';

void main() {
  test(
    'restores saved location and does not reset on a map tab revisit',
    () async {
      final repo = FakeDiscoveryRepository();
      final controller = DiscoveryController(repository: repo);
      await controller.initialize();
      expect(controller.origin?.locationId, primaryLocation.id);
      await controller.selectRadius(30);
      await controller.initialize();
      expect(controller.radiusKm, 30);
      expect(repo.searches.length, 2);
      final reopened = DiscoveryController(repository: repo);
      await reopened.initialize();
      expect(reopened.origin?.point, primaryLocation.point);
      expect(reopened.radiusKm, 30);
      expect(reopened.phase, DiscoveryPhase.ready);
      controller.dispose();
      reopened.dispose();
    },
  );

  test(
    'loads outer-radius pages automatically and keeps map/list IDs deduplicated',
    () async {
      final repo = FakeDiscoveryRepository(manual: true);
      final controller = DiscoveryController(repository: repo);
      final search = controller.setOrigin(
        DiscoveryOrigin.saved(
          locationId: primaryLocation.id,
          label: 'Home',
          point: primaryLocation.point,
        ),
      );
      repo.searches.first.completer.complete(
        resultPage([directorySupplier('inner')], hasMore: true, total: 2),
      );
      await Future<void>.delayed(Duration.zero);
      expect(repo.searches.last.page, 2);
      repo.searches.last.completer.complete(
        resultPage([
          directorySupplier('inner'),
          directorySupplier('outer', distance: 45000),
        ], total: 2),
      );
      await search;
      expect(controller.items.map((item) => item.resultId), ['inner', 'outer']);
      expect(controller.loadingMore, isFalse);
      controller.dispose();
    },
  );

  test('uses a valid saved location when no primary is marked', () async {
    final repo = FakeDiscoveryRepository(
      locationsList: [
        SavedLocationView(
          id: 'other',
          label: 'Site',
          kind: 'PROJECT_SITE',
          isPrimary: false,
          formattedAddress: primaryLocation.formattedAddress,
          point: primaryLocation.point,
          psgc: primaryLocation.psgc,
          lockVersion: 1,
        ),
      ],
    );
    final controller = DiscoveryController(repository: repo);
    await controller.initialize();
    expect(controller.origin?.locationId, 'other');
    expect(controller.phase, DiscoveryPhase.ready);
    controller.dispose();
  });

  test(
    'invalid coordinates require selection instead of querying discovery',
    () async {
      final repo = FakeDiscoveryRepository(
        locationsList: [
          SavedLocationView(
            id: 'bad',
            label: 'Invalid',
            kind: 'DELIVERY',
            isPrimary: true,
            formattedAddress: '',
            point: const GeoPoint(double.nan, 121),
            psgc: primaryLocation.psgc,
            lockVersion: 1,
          ),
        ],
      );
      final controller = DiscoveryController(repository: repo);
      await controller.initialize();
      expect(controller.phase, DiscoveryPhase.needsOrigin);
      expect(repo.searches, isEmpty);
      controller.dispose();
    },
  );

  Future<void> pumpPicker(
    WidgetTester tester,
    FakeDiscoveryRepository repo, {
    double width = 390,
    double textScale = 1,
  }) async {
    tester.view.physicalSize = Size(width, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: BuyerTheme.light,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        ),
        home: SelectLocationScreen(
          repository: repo,
          deviceLocation: FakeDeviceLocation(
            const DeviceLocationResult(DeviceLocationStatus.denied),
          ),
          savedLocations: const [],
          mapsAvailable: false,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'autocomplete selects the same preview and Choose Location saves once',
    (tester) async {
      final repo = FakeDiscoveryRepository(locationsList: const [])
        ..suggestions = const [
          LocationSuggestionView('place-1', 'Quiapo', 'Manila'),
        ];
      await pumpPicker(tester, repo);
      await tester.enterText(find.byType(TextField).first, 'Qui');
      await tester.pump(const Duration(milliseconds: 450));
      await tester.pumpAndSettle();
      expect(find.text('Google Maps'), findsOneWidget);
      await tester.tap(find.text('Quiapo'));
      await tester.pumpAndSettle();
      expect(find.text('629 J Nepomuceno St, Quiapo, Manila'), findsOneWidget);
      repo.pendingSave = Completer<SavedLocationView>();
      await tester.tap(find.text('Choose Location'));
      await tester.tap(find.text('Choose Location'), warnIfMissed: false);
      repo.pendingSave!.complete(primaryLocation);
      await tester.pumpAndSettle();
      expect(repo.saveCalls, 1);
      expect(repo.locationsList.single.isPrimary, isTrue);
      expect(repo.savedKeys.single, isNotEmpty);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('late suggestions cannot repopulate a cleared search', (
    tester,
  ) async {
    final repo = FakeDiscoveryRepository()
      ..pendingSuggestions = Completer<List<LocationSuggestionView>>();
    await pumpPicker(tester, repo);
    await tester.enterText(find.byType(TextField).first, 'Manila');
    await tester.pump(const Duration(milliseconds: 450));
    await tester.tap(find.byTooltip('Clear search'));
    repo.pendingSuggestions!.complete(const [
      LocationSuggestionView('old', 'Old result', null),
    ]);
    await tester.pumpAndSettle();
    expect(find.text('Old result'), findsNothing);
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Choose Location'),
          )
          .onPressed,
      isNull,
    );
  });

  for (final width in [
    320.0,
    375.0,
    390.0,
    768.0,
    1024.0,
    1280.0,
    1440.0,
    1920.0,
  ]) {
    testWidgets('location selection reflows at $width with large text', (
      tester,
    ) async {
      await pumpPicker(
        tester,
        FakeDiscoveryRepository(),
        width: width,
        textScale: 2,
      );
      expect(tester.takeException(), isNull);
      expect(find.text('Choose Location'), findsOneWidget);
    });
  }
}
