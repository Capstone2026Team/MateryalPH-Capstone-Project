import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';
import 'package:materyalph/features/trust/materials_analytics_screen.dart';
import 'package:materyalph/features/trust/order_reviews_screen.dart';
import 'package:materyalph/features/trust/trust_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'trust_fakes.dart';

// Synthetic DEMO layout evidence only; no live marketplace or provider claim.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    // The rating screen restores unsent media from device storage.
    SharedPreferences.setMockInitialValues({});
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
    categoryId: 'cat-masonry',
    categoryCode: 'MASONRY',
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

  // Product-level fixtures: a realistic overview, one category table and one product.
  AnalyticsCategorySummaryView summary(
    String name,
    String code,
    int products,
  ) => AnalyticsCategorySummaryView(
    id: 'cat-$code',
    name: name,
    code: code,
    productCount: products,
    variantCount: products * 2,
  );
  AnalyticsProductView product(
    String id,
    String name,
    String category,
    String code, {
    required bool regulated,
    required String unit,
    required int variants,
    required int vendors,
    PriceRangeView price = const PriceRangeView(),
  }) => AnalyticsProductView(
    materialId: id,
    name: name,
    categoryId: 'cat-$code',
    categoryName: category,
    categoryCode: code,
    regulated: regulated,
    unitName: unit,
    variantCount: variants,
    vendorCount: vendors,
    price: price,
  );
  final chb = product(
    'm-chb',
    'Concrete hollow block',
    'Masonry',
    'MASONRY',
    regulated: false,
    unit: 'Piece',
    variants: 2,
    vendors: 6,
    price: const PriceRangeView(min: '16.50', median: '18.42', max: '26.10'),
  );
  final productsPage = AnalyticsProductsPage(
    envelope: envelope,
    categories: [
      summary('Cement and Concrete', 'CEMENT_AND_CONCRETE', 2),
      summary('Masonry', 'MASONRY', 1),
      summary('Ready-Mixed Concrete', 'READY_MIXED_CONCRETE', 1),
      summary('Steel and Reinforcement', 'STEEL_AND_REINFORCEMENT', 2),
      summary('Electrical Supplies', 'ELECTRICAL_SUPPLIES', 3),
      summary('Paints and Finishes', 'PAINTS_AND_FINISHES', 4),
    ],
    items: [
      product(
        'm-portland',
        'Portland cement',
        'Cement and Concrete',
        'CEMENT_AND_CONCRETE',
        regulated: true,
        unit: 'Bag',
        variants: 4,
        vendors: 5,
        price: const PriceRangeView(
          min: '238.00',
          median: '252.50',
          max: '275.00',
        ),
      ),
      product(
        'm-blended',
        'Blended cement',
        'Cement and Concrete',
        'CEMENT_AND_CONCRETE',
        regulated: true,
        unit: 'Bag',
        variants: 2,
        vendors: 1,
        price: const PriceRangeView(
          min: '229.00',
          median: '229.00',
          max: '229.00',
        ),
      ),
      chb,
      product(
        'm-latex',
        'Latex paint',
        'Paints and Finishes',
        'PAINTS_AND_FINISHES',
        regulated: false,
        unit: 'Gallon (3.785 L can)',
        variants: 3,
        vendors: 0,
      ),
    ],
    notYetComparable: 117,
  );
  final productDetail = AnalyticsProductDetailView(
    envelope: envelope,
    product: chb,
    description:
        'Load-bearing and partition masonry unit sold by the piece; size is the wall thickness.',
    featured: rows.first,
    series: series,
    variants: [
      for (final (index, row) in rows.indexed)
        AnalyticsProductVariantView(
          groupId: row.groupId,
          displayName: row.displayName,
          materialName: row.materialName,
          specification: row.specification,
          unitName: row.unitName,
          vendorCount: row.currentVendors,
          listingCount: row.currentListings,
          price: index == 0
              ? const PriceRangeView(
                  min: '16.50',
                  median: '18.40',
                  max: '19.75',
                )
              : const PriceRangeView(
                  min: '26.10',
                  median: '26.10',
                  max: '26.10',
                ),
          availability: index == 0 ? 'IN_STOCK' : 'LIMITED_STOCK',
          categoryCode: 'MASONRY',
        ),
    ],
  );

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

  testWidgets('materials analytics overview', (tester) async {
    await capture(
      tester,
      '390-materials-analytics',
      MaterialsAnalyticsScreen(
        repository: FakeAnalyticsRepository()..productsPage = productsPage,
        origin: origin,
        onOpenListing: (_, _) {},
      ),
    );
  });

  testWidgets('materials analytics overview at 320 px with 2x text', (
    tester,
  ) async {
    await capture(
      tester,
      '320-materials-analytics-2x-text',
      MaterialsAnalyticsScreen(
        repository: FakeAnalyticsRepository()..productsPage = productsPage,
        origin: origin,
        onOpenListing: (_, _) {},
      ),
      scale: 2,
      width: 320,
    );
  });

  testWidgets('materials analytics product table', (tester) async {
    await capture(
      tester,
      '390-materials-analytics-products',
      MaterialsAnalyticsProductsScreen(
        repository: FakeAnalyticsRepository()..productsPage = productsPage,
        origin: origin,
        place: 'Quezon City site',
        window: const AnalyticsWindowChoice.preset(30),
        title: 'All materials',
        onOpenListing: (_, _) {},
      ),
    );
  });

  testWidgets('materials analytics product table at 320 px with 2x text', (
    tester,
  ) async {
    await capture(
      tester,
      '320-materials-analytics-products-2x-text',
      MaterialsAnalyticsProductsScreen(
        repository: FakeAnalyticsRepository()..productsPage = productsPage,
        origin: origin,
        place: 'Quezon City site',
        window: const AnalyticsWindowChoice.preset(30),
        title: 'All materials',
        onOpenListing: (_, _) {},
      ),
      scale: 2,
      width: 320,
    );
  });

  testWidgets('materials analytics product', (tester) async {
    await capture(
      tester,
      '390-materials-analytics-product',
      MaterialsAnalyticsProductScreen(
        repository: FakeAnalyticsRepository()..productDetail = productDetail,
        origin: origin,
        place: 'Quezon City site',
        window: const AnalyticsWindowChoice.preset(30),
        materialId: 'm-chb',
        name: 'Concrete hollow block',
        onOpenListing: (_, _) {},
      ),
    );
  });

  testWidgets('materials analytics product at 320 px with 2x text', (
    tester,
  ) async {
    await capture(
      tester,
      '320-materials-analytics-product-2x-text',
      MaterialsAnalyticsProductScreen(
        repository: FakeAnalyticsRepository()..productDetail = productDetail,
        origin: origin,
        place: 'Quezon City site',
        window: const AnalyticsWindowChoice.preset(30),
        materialId: 'm-chb',
        name: 'Concrete hollow block',
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
