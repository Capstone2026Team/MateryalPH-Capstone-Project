import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/map_discovery/device_location.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';
import 'package:materyalph/features/map_discovery/map_home_screen.dart';
import 'package:materyalph/features/map_discovery/select_location_screen.dart';

import 'map_discovery_fakes.dart';

/// Phase 6 layout evidence from synthetic fixtures. The map area is a labelled test surface:
/// screenshots illustrate layout and states, not live Google Maps rendering or provider readiness.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await (FontLoader(
      'MaterialIcons',
    )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
    await (FontLoader(
      'Inter',
    )..addFont(rootBundle.load('assets/fonts/Inter-Variable.ttf'))).load();
    await (FontLoader('packages/lucide_icons_flutter/Lucide')..addFont(
          rootBundle.load('packages/lucide_icons_flutter/assets/lucide.ttf'),
        ))
        .load();
  });

  FakeDiscoveryRepository repository() => FakeDiscoveryRepository(
    page: resultPage([
      verifiedSupplier(
        'v-1',
        rank: 1,
        distance: 1200,
        favorite: true,
        scoreKind: ScoreKind.vps,
        scoreText: 'VPS 4.7',
      ),
      directorySupplier('d-1', rank: 2, distance: 1900),
      verifiedSupplier(
        'v-2',
        rank: 3,
        name: 'Kulitz Magical Hardware and Construction Supply',
        distance: 3100,
      ),
    ], suggested: 10),
  );

  Future<void> capture(
    WidgetTester tester,
    String name,
    Size size, {
    double scale = 1,
    FakeDiscoveryRepository? repo,
    Future<void> Function()? act,
  }) async {
    await tester.binding.setSurfaceSize(size);
    tester.platformDispatcher.textScaleFactorTestValue = scale;
    addTearDown(() {
      tester.platformDispatcher.clearTextScaleFactorTestValue();
      return tester.binding.setSurfaceSize(null);
    });
    final map = RecordingMap();
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: BuyerTheme.light,
        home: MapHomeScreen(
          repository: repo ?? repository(),
          deviceLocation: FakeDeviceLocation(
            const DeviceLocationResult(DeviceLocationStatus.denied),
          ),
          mapBuilder: map.build,
          onOpenStore: (_, _) {},
          openLink: (_) async {},
          share: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    if (act != null) await act();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../../../docs/design/evidence/phase-6/$name.png'),
    );
  }

  testWidgets('unified location details at 390 px', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: BuyerTheme.light,
        home: SelectLocationScreen(
          repository: repository()
            ..pointAddress =
                '629 J Nepomuceno St, Quiapo, Manila, 1001 Metro Manila',
          deviceLocation: FakeDeviceLocation(
            const DeviceLocationResult(DeviceLocationStatus.denied),
          ),
          savedLocations: const [],
          mapsAvailable: false,
          initialPoint: primaryLocation.point,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile(
        '../../../docs/design/evidence/phase-6/390-unified-location-details.png',
      ),
    );
  });

  testWidgets(
    'Tier 1 Google reviews section',
    (tester) => capture(
      tester,
      '390-tier1-google-reviews',
      const Size(390, 844),
      act: () async {
        await tester.tap(find.byKey(const ValueKey('marker-d-1')));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Reviews'));
      },
    ),
  );

  testWidgets(
    'map home list at 390 px',
    (tester) => capture(tester, '390-map-home-list', const Size(390, 844)),
  );
  testWidgets(
    'map home at 320 px with 2x text',
    (tester) =>
        capture(tester, '320-map-home-2x-text', const Size(320, 568), scale: 2),
  );
  testWidgets(
    'map home landscape split view',
    (tester) =>
        capture(tester, '844x390-landscape-split', const Size(844, 390)),
  );
  testWidgets(
    'Tier 2 preview with route',
    (tester) => capture(
      tester,
      '390-tier2-preview',
      const Size(390, 844),
      act: () async {
        await tester.tap(find.byKey(const ValueKey('marker-v-1')));
      },
    ),
  );
  testWidgets(
    'Tier 1 directory details',
    (tester) => capture(
      tester,
      '390-tier1-directory-details',
      const Size(390, 844),
      act: () async {
        await tester.tap(find.byKey(const ValueKey('marker-d-1')));
      },
    ),
  );
  testWidgets(
    'Tier 1 directory about section',
    (tester) => capture(
      tester,
      '390-tier1-directory-about',
      const Size(390, 844),
      act: () async {
        await tester.tap(find.byKey(const ValueKey('marker-d-1')));
        await tester.pumpAndSettle();
        await tester.tap(find.text('About'));
      },
    ),
  );
  testWidgets(
    'map type and legend sheet',
    (tester) => capture(
      tester,
      '390-map-layers',
      const Size(390, 844),
      act: () async => tester.tap(find.byTooltip('Map type and legend')),
    ),
  );
  testWidgets(
    'route unavailable',
    (tester) => capture(
      tester,
      '390-route-unavailable',
      const Size(390, 844),
      repo: repository()
        ..routeFailure = const DiscoveryFailure(
          DiscoveryFailureKind.provider,
          'Driving time is unavailable.',
          details: {'straight_line_meters': 1200},
        ),
      act: () async => tester.tap(find.byKey(const ValueKey('marker-v-1'))),
    ),
  );
  testWidgets(
    'denied location first entry',
    (tester) => capture(
      tester,
      '390-denied-location',
      const Size(390, 844),
      repo: FakeDiscoveryRepository(locationsList: const []),
      act: () async {
        // Asset images decode asynchronously; precache so the illustration is in the capture.
        await tester.runAsync(
          () => precacheImage(
            const AssetImage('assets/states/location.png'),
            tester.element(find.byType(Image)),
          ),
        );
        await tester.tap(find.text('Use current location'));
      },
    ),
  );
  testWidgets(
    'directory provider unavailable',
    (tester) => capture(
      tester,
      '390-directory-unavailable',
      const Size(390, 844),
      repo: FakeDiscoveryRepository(
        page: resultPage([
          verifiedSupplier('v-1'),
        ], directoryStatus: 'UNAVAILABLE'),
      ),
    ),
  );
  testWidgets(
    'offline without results',
    (tester) => capture(
      tester,
      '390-offline',
      const Size(390, 844),
      repo: FakeDiscoveryRepository()
        ..searchFailure = const DiscoveryFailure(
          DiscoveryFailureKind.offline,
          'You appear to be offline.',
        ),
    ),
  );
}
