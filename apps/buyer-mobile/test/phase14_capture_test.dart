import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';
import 'package:materyalph/features/trust/materials_analytics_screen.dart';
import 'package:materyalph/features/trust/order_reviews_screen.dart';
import 'package:materyalph/features/trust/trust_models.dart';

import 'trust_fakes.dart';

// Synthetic DEMO layout evidence only; no live marketplace or provider claim.
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

  const origin = DiscoveryOrigin.point(
    point: GeoPoint(14.5995, 120.9842),
    source: OriginSource.mapPin,
    label: 'Quezon City site',
  );
  final envelope = AnalyticsEnvelopeView(
    datasetLabel: 'DEMO — Simulated Marketplace Data',
    updateSchedule: 'Updated daily at 00:10 Asia/Manila',
    explanation:
        'Listed-price movement from public prices, equal weight per seller. Not an official index.',
    currentAsOf: DateTime.utc(2026, 10, 4, 2),
    snapshotAt: DateTime.utc(2026, 10, 3, 16, 10),
    latestDate: '2026-10-04',
  );
  ComparableGroupView group(
    String id,
    String name,
    AnalyticsPointView end,
    AnalyticsTrendView trend,
    int vendors,
  ) => ComparableGroupView(
    groupId: id,
    displayName: name,
    materialName: 'Concrete hollow block',
    categoryName: 'Masonry',
    unitName: 'Piece',
    specification: const ['DemoBlock', 'thickness mm: 100'],
    startPoint: const AnalyticsPointView(
      date: '2026-09-04',
      status: 'OK',
      average: '17.80',
      vendorCount: 4,
    ),
    endPoint: end,
    trend: trend,
    currentVendors: vendors,
    currentListings: vendors,
  );
  final rows = [
    group(
      'g1',
      '4-inch (100 mm) CHB — DemoBlock',
      const AnalyticsPointView(
        date: '2026-10-04',
        status: 'OK',
        average: '18.42',
        vendorCount: 5,
      ),
      const AnalyticsTrendView(
        changePercent: '3.48',
        direction: 'INCREASING',
        compositionChanged: true,
      ),
      5,
    ),
    group(
      'g2',
      '6-inch (150 mm) CHB — DemoBlock',
      const AnalyticsPointView(
        date: '2026-10-04',
        status: 'LIMITED_DATA',
        average: '26.10',
        vendorCount: 1,
      ),
      const AnalyticsTrendView(
        reason: 'INSUFFICIENT_LOCAL_DATA',
        label: 'Insufficient Local Data',
      ),
      1,
    ),
  ];
  final series = [
    for (var day = 20; day <= 30; day++)
      AnalyticsPointView(
        date: '2026-09-$day',
        status: day == 24 ? 'MISSING_DAY' : 'OK',
        label: day == 24 ? 'No snapshot recorded for this date' : null,
        average: day == 24
            ? null
            : (17.8 + (day - 20) * 0.06).toStringAsFixed(2),
        vendorCount: day == 24 ? null : (day >= 27 ? 5 : 4),
        participantsChanged: day == 27 ? true : null,
      ),
  ];

  Future<void> capture(
    WidgetTester tester,
    String name,
    Widget page, {
    double scale = 1,
    double width = 390,
  }) async {
    await tester.binding.setSurfaceSize(Size(width, 1400));
    tester.platformDispatcher.textScaleFactorTestValue = scale;
    addTearDown(() {
      tester.platformDispatcher.clearTextScaleFactorTestValue();
      return tester.binding.setSurfaceSize(null);
    });
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: BuyerTheme.light,
        home: page,
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../../../docs/design/evidence/phase-14/$name.png'),
    );
  }

  testWidgets('materials analytics list', (tester) async {
    final repository = FakeAnalyticsRepository()
      ..page = MaterialsAnalyticsPage(envelope: envelope, items: rows);
    await capture(
      tester,
      '390-materials-analytics',
      MaterialsAnalyticsScreen(
        repository: repository,
        origin: origin,
        radiusKm: 10,
        onOpenListing: (_, _) {},
      ),
    );
  });

  testWidgets('materials analytics list at 320 px with 2x text', (
    tester,
  ) async {
    final repository = FakeAnalyticsRepository()
      ..page = MaterialsAnalyticsPage(envelope: envelope, items: rows);
    await capture(
      tester,
      '320-materials-analytics-2x-text',
      MaterialsAnalyticsScreen(
        repository: repository,
        origin: origin,
        radiusKm: 10,
        onOpenListing: (_, _) {},
      ),
      scale: 2,
      width: 320,
    );
  });

  testWidgets('material price details', (tester) async {
    final repository = FakeAnalyticsRepository()
      ..detail = MaterialPriceDetailsView(
        envelope: envelope,
        group: rows.first,
        description: 'Load-bearing concrete masonry unit.',
        variants: [
          (groupId: 'g1', displayName: rows.first.displayName),
          (groupId: 'g2', displayName: rows.last.displayName),
        ],
        series: series,
      )
      ..currentOffers = const [
        MaterialOfferView(
          vendorId: 'v1',
          storeName: 'DEMO — Santos Hardware',
          listingId: 'l1',
          displayName: 'CHB 4-inch',
          variantLabel: 'Standard',
          priceCentavos: 1790,
          normalizedPhp: '17.90',
          taxLabel: 'Non-VAT seller',
          availability: 'IN_STOCK',
          distanceMeters: 1200,
        ),
        MaterialOfferView(
          vendorId: 'v2',
          storeName: 'DEMO — Bayanihan Builders Supply',
          listingId: 'l2',
          displayName: 'CHB 4-inch',
          variantLabel: 'Standard',
          priceCentavos: 1880,
          normalizedPhp: '18.80',
          taxLabel: 'VAT inclusive',
          availability: 'LIMITED_STOCK',
          distanceMeters: 2500,
        ),
      ];
    await capture(
      tester,
      '390-material-price-details',
      MaterialPriceDetailsScreen(
        repository: repository,
        origin: origin,
        radiusKm: 10,
        groupId: 'g1',
        window: const AnalyticsWindowChoice.preset(7),
        onOpenListing: (_, _) {},
      ),
    );
  });

  testWidgets('rate an order', (tester) async {
    final repository = FakeReviewsRepository()
      ..order = const OrderReviewsView(
        orderId: 'o1',
        orderReference: 'ORD-2026-0042',
        state: 'OPEN',
        closesAtLabel: 'Oct 18, 2026 10:00 AM (Asia/Manila)',
        revealed: false,
        withheldForDispute: false,
        blindRevealText:
            'Ratings stay hidden until both parties submit or the 14-day window ends.',
        speedLabel: 'Processing Speed',
        displayOptions: [
          (choice: 'FIRST_NAME_LAST_INITIAL', preview: 'Juan C.'),
          (choice: 'VERIFIED_BUYER', preview: 'Verified Buyer'),
        ],
        vendorRating: null,
        canSubmitVendorRating: true,
        lines: [
          ReviewLineView(
            orderLineId: 'line-1',
            listingId: 'l1',
            displayName: 'CHB 4-inch',
            variantLabel: 'Standard',
            review: null,
            canReview: true,
          ),
        ],
      );
    await capture(
      tester,
      '390-rate-order',
      OrderReviewsScreen(repository: repository, orderId: 'o1'),
    );
  });
}
