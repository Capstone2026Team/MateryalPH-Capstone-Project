import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:materyalph/design_system/components/discovery_controls.dart';
import 'package:materyalph/design_system/components/vendor_performance.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/map_discovery/discovery_controller.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';
import 'package:materyalph/features/map_discovery/supplier_panels.dart';
import 'package:materyalph/features/map_discovery/supplier_map.dart';
import 'package:materyalph/features/projects/vendor_selection_widgets.dart';
import 'package:materyalph/features/trust/trust_models.dart';

import 'map_discovery_fakes.dart';
import 'typed_project_fixtures.dart';
import 'vendor_selection_test.dart' show candidate;

const _badges = [
  StoreBadgeView(
    code: 'FAST_RESPONDER',
    name: 'Fast Responder',
    description:
        'Answers at least 85% of inquiries within 12 hours (last 30 days, 10+ inquiries).',
  ),
  StoreBadgeView(
    code: 'HIGHLY_RATED',
    name: 'Highly Rated',
    description:
        'Vendor Community Score of 4.50 or higher from 10+ verified ratings (last 90 days).',
  ),
  StoreBadgeView(
    code: 'HIGH_QUALITY_MATERIALS',
    name: 'High-Quality Materials',
    description:
        'Material Quality Score of 4.60 or higher from 10+ verified product ratings (last 90 days).',
  ),
  StoreBadgeView(
    code: 'MOST_ORDERED',
    name: 'Most Ordered',
    scopeLabel: 'Cement · Metro Manila',
    description:
        'Top 10% by completed orders in this category and province (last 90 days, 20+ orders).',
  ),
  StoreBadgeView(
    code: 'ON_TIME',
    name: 'On-Time',
    description:
        'Fulfills at least 95% of orders on or before the confirmed date (last 90 days, 10+ orders).',
  ),
  StoreBadgeView(
    code: 'TRUSTED_SUPPLIER',
    name: 'Trusted Supplier',
    description:
        'Verified for 90+ days with VCS and OHS of 4.50 or higher and 25+ completed orders.',
  ),
];

const _supplier = SupplierResultView(
  resultId: 'awarded',
  tier: SupplierTier.verified,
  rank: 1,
  name: 'BuildSphere Construction Supply',
  point: GeoPoint(14.61, 120.99),
  distanceMeters: 4200,
  scoreKind: ScoreKind.vps,
  scoreText: 'VPS 4.6',
  scoreValue: '4.6',
  badges: _badges,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    for (final font in {
      'MaterialIcons': 'fonts/MaterialIcons-Regular.otf',
      'Inter': 'assets/fonts/Inter-Variable.ttf',
      'packages/lucide_icons_flutter/Lucide':
          'packages/lucide_icons_flutter/assets/lucide.ttf',
    }.entries) {
      await (FontLoader(font.key)..addFont(rootBundle.load(font.value))).load();
    }
  });
  test('star labels preserve published precision and never invent a score', () {
    expect(vendorScoreDisplayText('VPS 2.8'), '★ 2.8');
    expect(vendorScoreDisplayText('VPS 4.40 of 5'), '★ 4.40');
    expect(
      vendorScoreDisplayText('New Vendor — Building Track Record'),
      'New Vendor — Building Track Record',
    );
    expect(vendorScoreDisplayText('Directory'), 'Directory');
    expect(publishedVpsValue('VPS 0.0'), isNull);
    expect(publishedVpsValue('VPS 6.0'), isNull);
    expect(_supplier.markerLabel, 'BuildSphere Construction Supply · ★ 4.6');
    expect(_supplier.withFavorite(true).badges, _badges);
    expect(_supplier.compactMarkerLabel(28), endsWith(' · ★ 4.6'));
    expect(_supplier.compactMarkerLabel(28).length, lessThanOrEqualTo(28));
  });

  testWidgets(
    'published chip puts the star before its score and announces VPS',
    (tester) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: const [
                ScoreBadge(kind: ScoreKind.vps, text: 'VPS 2.8', value: '2.8'),
                ScoreBadge(kind: ScoreKind.newVendor, text: 'New Vendor'),
                ScoreBadge(kind: ScoreKind.directory, text: 'Directory'),
              ],
            ),
          ),
        ),
      );
      expect(find.text('VPS 2.8'), findsNothing);
      expect(find.text('2.8'), findsOneWidget);
      expect(find.byIcon(Icons.star_rounded), findsOneWidget);
      expect(
        tester.getCenter(find.byIcon(Icons.star_rounded)).dx,
        lessThan(tester.getCenter(find.text('2.8')).dx),
      );
      expect(
        find.bySemanticsLabel('Vendor Performance Score 2.8 out of 5'),
        findsOneWidget,
      );
      expect(find.byIcon(LucideIcons.sprout), findsOneWidget);
      expect(find.text('Directory'), findsOneWidget);
      semantics.dispose();
    },
  );

  for (final width in [320.0, 390.0, 768.0]) {
    for (final scale in [1.0, 2.0]) {
      testWidgets(
        'Vendor selection and badge graphics fit $width at ${scale}x text',
        (tester) async {
          await tester.binding.setSurfaceSize(Size(width, 1000));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          await tester.pumpWidget(
            MaterialApp(
              theme: BuyerTheme.light,
              home: MediaQuery(
                data: MediaQueryData(
                  size: Size(width, 1000),
                  textScaler: TextScaler.linear(scale),
                ),
                child: Scaffold(
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        SupplierRow(
                          item: _supplier,
                          selected: false,
                          onTap: () {},
                        ),
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: VendorBadges(badges: _badges),
                        ),
                        VendorResultCard(
                          candidate: typedCandidate({
                            ...candidate(
                              '01995000-0000-7000-8000-0000000000c1',
                              'BuildSphere',
                            ),
                            'vps': '4.60',
                            'score_label': 'VPS 4.6',
                            'badges': [
                              for (final badge in _badges)
                                {
                                  'code': badge.code,
                                  'name': badge.name,
                                  'description': badge.description,
                                  'scope_label': badge.scopeLabel,
                                  'earned_at': '2026-11-06T00:00:00Z',
                                },
                            ],
                          }),
                          selected: false,
                          onSelect: () {},
                          onMessage: null,
                          onViewQuotation: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(find.text('Fast Responder'), findsNWidgets(3));
          expect(find.byType(VendorBadgeEmblem), findsNWidgets(18));
        },
      );
    }
  }

  testWidgets(
    'selected Vendor preview displays the public badges and star score',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 960));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final controller = DiscoveryController(
        repository: FakeDiscoveryRepository(page: resultPage([_supplier])),
      );
      addTearDown(controller.dispose);
      await controller.initialize();
      await controller.select('awarded');
      await tester.pumpWidget(
        MaterialApp(
          theme: BuyerTheme.light,
          home: Scaffold(
            body: RepaintBoundary(
              child: SingleChildScrollView(
                child: SupplierPreview(
                  controller: controller,
                  onViewStore: (_) {},
                  onMessage: (_) {},
                  onClose: () {},
                  onOpenLink: (_) async {},
                  onShare: (_) {},
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('4.6'), findsOneWidget);
      expect(find.byType(VendorBadgeEmblem), findsNWidgets(6));
      expect(find.text('Most Ordered · Cement · Metro Manila'), findsOneWidget);
      expect(find.text('View Storefront'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byType(RepaintBoundary).first,
        matchesGoldenFile('goldens/vendor-awards-selection.png'),
      );
    },
  );

  testWidgets(
    'native map label keeps the star score beside a long store name',
    (tester) async {
      final label = await tester.runAsync(() async {
        final bytes = await paintSupplierLabel(
          _supplier,
          selected: false,
          ratio: 2,
        );
        final codec = await ui.instantiateImageCodec(bytes);
        final frame = await codec.getNextFrame();
        codec.dispose();
        return frame.image;
      });
      await expectLater(
        label!,
        matchesGoldenFile('goldens/vendor-vps-map-label.png'),
      );
      label.dispose();
    },
  );
}
