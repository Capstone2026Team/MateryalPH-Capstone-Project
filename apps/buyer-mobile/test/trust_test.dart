import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/components/category_tile.dart';
import 'package:materyalph/design_system/components/price_trend_chart.dart';
import 'package:materyalph/design_system/components/product_summary_row.dart';
import 'package:materyalph/features/item_procurement/explore_screen.dart'
    show categoryIcon;
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';
import 'package:materyalph/features/trust/listing_reviews_section.dart';
import 'package:materyalph/features/trust/materials_analytics_screen.dart';
import 'package:materyalph/features/trust/order_reviews_screen.dart';
import 'package:materyalph/features/trust/trust_models.dart';

import 'trust_fakes.dart';

const _origin = DiscoveryOrigin.point(
  point: GeoPoint(14.5995, 120.9842),
  source: OriginSource.mapPin,
  label: 'Quezon City site',
);

final _envelope = AnalyticsEnvelopeView(
  datasetLabel: 'DEMO — Simulated Marketplace Data',
  updateSchedule: 'Updated daily at 00:10 Asia/Manila',
  explanation: 'Listed-price movement, not an official index.',
  currentAsOf: DateTime.utc(2026, 10, 4, 2),
  snapshotAt: DateTime.utc(2026, 10, 3, 16, 10),
  latestDate: '2026-10-04',
);

ComparableGroupView _group({
  String id = 'g1',
  AnalyticsPointView? end,
  AnalyticsTrendView trend = const AnalyticsTrendView(
    changePercent: '10.00',
    direction: 'INCREASING',
    startDate: '2026-09-04',
    endDate: '2026-10-04',
  ),
  int vendors = 3,
}) => ComparableGroupView(
  groupId: id,
  displayName: '4-inch CHB — DemoBlock',
  materialName: 'Concrete hollow block',
  categoryName: 'Masonry',
  categoryId: 'cat-masonry',
  categoryCode: 'MASONRY',
  unitName: 'Piece',
  specification: const ['DemoBlock', 'thickness mm: 100'],
  startPoint: const AnalyticsPointView(
    date: '2026-09-04',
    status: 'OK',
    average: '100.00',
    vendorCount: 2,
  ),
  endPoint:
      end ??
      const AnalyticsPointView(
        date: '2026-10-04',
        status: 'OK',
        average: '110.00',
        vendorCount: 3,
      ),
  trend: trend,
  currentVendors: vendors,
  currentListings: vendors,
);

Widget _app(Widget child) => MaterialApp(theme: BuyerTheme.light, home: child);

void main() {
  const masonry = AnalyticsCategorySummaryView(
    id: 'cat-masonry',
    name: 'Masonry',
    code: 'MASONRY',
    productCount: 1,
    variantCount: 2,
  );
  const electrical = AnalyticsCategorySummaryView(
    id: 'cat-electrical',
    name: 'Electrical Supplies',
    code: 'ELECTRICAL_SUPPLIES',
    productCount: 1,
    variantCount: 2,
  );
  const chb = AnalyticsProductView(
    materialId: 'm-chb',
    name: 'Concrete hollow block',
    categoryId: 'cat-masonry',
    categoryName: 'Masonry',
    categoryCode: 'MASONRY',
    regulated: false,
    unitName: 'Piece',
    variantCount: 2,
    vendorCount: 4,
    price: PriceRangeView(min: '100.00', median: '115.00', max: '150.00'),
  );
  const thhn = AnalyticsProductView(
    materialId: 'm-thhn',
    name: 'THHN building wire',
    categoryId: 'cat-electrical',
    categoryName: 'Electrical Supplies',
    categoryCode: 'ELECTRICAL_SUPPLIES',
    regulated: false,
    unitName: 'Meter',
    variantCount: 2,
    vendorCount: 1,
    price: PriceRangeView(min: '31.99', median: '31.99', max: '31.99'),
  );
  final cement = AnalyticsProductView(
    materialId: 'm-cement',
    name: 'Portland cement',
    categoryId: 'cat-masonry',
    categoryName: 'Masonry',
    categoryCode: 'MASONRY',
    regulated: true,
    unitName: 'Bag',
    variantCount: 1,
    vendorCount: 0,
    price: const PriceRangeView(),
  );

  FakeAnalyticsRepository productsRepository() =>
      FakeAnalyticsRepository()
        ..productsPage = AnalyticsProductsPage(
          envelope: _envelope,
          categories: const [masonry, electrical],
          items: [chb, thhn, cement],
          notYetComparable: 117,
        );

  Future<void> pumpOverview(
    WidgetTester tester,
    FakeAnalyticsRepository repository,
  ) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      _app(
        MaterialsAnalyticsScreen(
          repository: repository,
          origin: _origin,
          onOpenListing: (_, _) {},
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'the overview is fixed at 50 km, shows category tiles and why listings outnumber compared products',
    (tester) async {
      final repository = productsRepository();
      await pumpOverview(tester, repository);
      expect(find.text('Within 50 km of'), findsOneWidget);
      expect(find.text('Quezon City site'), findsOneWidget);
      expect(find.text('DEMO — Simulated Marketplace Data'), findsOneWidget);
      expect(find.byTooltip('Change radius'), findsNothing);
      expect(find.byType(CategoryTile), findsNWidgets(3));
      expect(find.text('2 products'), findsOneWidget);
      expect(find.textContaining('117 listings nearby'), findsOneWidget);
      // Products only appear after a tile is opened.
      expect(find.text('Concrete hollow block'), findsNothing);
      expect(repository.radii, [50]);
      expect(repository.windows.single, const AnalyticsWindowChoice.preset(30));

      await tester.tap(find.text('7 days'));
      await tester.pumpAndSettle();
      expect(repository.windows.last, const AnalyticsWindowChoice.preset(7));
    },
  );

  testWidgets(
    'a category opens its product table with regulation badges, counts and the median and range',
    (tester) async {
      final repository = productsRepository();
      await pumpOverview(tester, repository);
      await tester.tap(find.widgetWithText(CategoryTile, 'Masonry'));
      await tester.pumpAndSettle();

      expect(repository.categoryIds.last, 'cat-masonry');
      expect(find.text('Masonry'), findsOneWidget, reason: 'App bar title');
      expect(find.text('Concrete hollow block'), findsOneWidget);
      expect(find.text('Portland cement'), findsOneWidget);
      expect(find.text('THHN building wire'), findsNothing);
      expect(find.text('Non-regulated'), findsOneWidget);
      expect(find.text('Regulated · PS/ICC'), findsOneWidget);
      expect(find.text('2 variants · 4 vendors'), findsOneWidget);
      expect(find.text('₱115.00'), findsOneWidget);
      expect(find.text('₱100.00–₱150.00'), findsOneWidget);
      expect(find.text('No current\noffers'), findsOneWidget);
      expect(
        find.text('Within 50 km of Quezon City site · Last 30 days'),
        findsOneWidget,
      );

      // All lists every category, naming each product's category.
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(CategoryTile, 'All'));
      await tester.pumpAndSettle();
      expect(repository.categoryIds.last, isNull);
      expect(find.text('All materials'), findsOneWidget);
      expect(
        find.text('Electrical Supplies · 2 variants · 1 vendor'),
        findsOneWidget,
      );

      // A search opens the same table for its matches.
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'thhn');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();
      expect(repository.queries.last, 'thhn');
      expect(find.text('Results for “thhn”'), findsOneWidget);
      expect(find.text('THHN building wire'), findsOneWidget);
      expect(find.text('Concrete hollow block'), findsNothing);
    },
  );

  testWidgets(
    'product analytics shows the summary strip, the most-offered variant trend and the variants table',
    (tester) async {
      String? opened;
      final repository = productsRepository()
        ..productDetail = AnalyticsProductDetailView(
          envelope: _envelope,
          product: chb,
          description: 'Load-bearing masonry unit.',
          featured: _group(),
          series: const [
            AnalyticsPointView(
              date: '2026-10-04',
              status: 'OK',
              average: '110.00',
              vendorCount: 3,
            ),
          ],
          variants: const [
            AnalyticsProductVariantView(
              groupId: 'g1',
              displayName: 'Concrete hollow block · BrandCo · 100 mm',
              materialName: 'Concrete hollow block',
              specification: ['BrandCo', 'thickness mm: 100'],
              unitName: 'Piece',
              vendorCount: 3,
              listingCount: 3,
              price: PriceRangeView(
                min: '100.00',
                median: '110.00',
                max: '120.00',
              ),
              availability: 'IN_STOCK',
              categoryCode: 'MASONRY',
            ),
            AnalyticsProductVariantView(
              groupId: 'g2',
              displayName: 'Concrete hollow block · BrandCo · 150 mm',
              materialName: 'Concrete hollow block',
              specification: ['BrandCo', 'thickness mm: 150'],
              unitName: 'Piece',
              vendorCount: 1,
              listingCount: 1,
              price: PriceRangeView(
                min: '150.00',
                median: '150.00',
                max: '150.00',
              ),
              availability: 'LIMITED_STOCK',
              categoryCode: 'MASONRY',
            ),
          ],
        )
        ..detail = MaterialPriceDetailsView(
          envelope: _envelope,
          group: _group(),
          description: null,
          variants: const [
            (groupId: 'g1', displayName: '4-inch CHB — DemoBlock'),
          ],
          series: const [],
        )
        ..currentOffers = const [
          MaterialOfferView(
            vendorId: 'v1',
            storeName: 'DEMO — Santos Hardware',
            listingId: 'l1',
            displayName: 'CHB',
            variantLabel: null,
            priceCentavos: 10500,
            normalizedPhp: '105.00',
            taxLabel: 'Non-VAT seller',
            availability: 'IN_STOCK',
            distanceMeters: 1200,
          ),
        ];
      tester.view.physicalSize = const Size(800, 2400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        _app(
          MaterialsAnalyticsProductsScreen(
            repository: repository,
            origin: _origin,
            place: 'Quezon City site',
            window: const AnalyticsWindowChoice.preset(30),
            title: 'Masonry',
            categoryId: 'cat-masonry',
            onOpenListing: (_, id) => opened = id,
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Concrete hollow block'));
      await tester.pumpAndSettle();

      expect(repository.productIds, ['m-chb']);
      expect(find.text('Product analytics'), findsOneWidget);
      expect(
        find.bySemanticsLabel('Average market price: ₱110.00 per Piece'),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel('Lowest price: ₱100.00 per Piece'),
        findsOneWidget,
      );
      expect(find.bySemanticsLabel('Vendors: 4 selling now'), findsOneWidget);
      expect(find.textContaining('most-offered variant'), findsOneWidget);
      expect(find.text('+10.00% · Increasing'), findsOneWidget);
      expect(find.byType(PriceTrendPanel), findsOneWidget);
      expect(find.text('BrandCo · 100 mm'), findsOneWidget);
      expect(find.text('₱100.00 – ₱120.00'), findsOneWidget);
      expect(find.text('₱150.00'), findsOneWidget);
      expect(find.text('3 vendors'), findsOneWidget);
      expect(find.text('Limited Stock'), findsOneWidget);
      expect(find.text('In Stock'), findsOneWidget);
      // Each variant row shows its photo, falling back to its category icon.
      final thumbnails = tester
          .widgetList<ProductThumbnail>(find.byType(ProductThumbnail))
          .toList();
      expect(thumbnails, hasLength(2));
      expect(thumbnails.first.url, isNull);
      expect(thumbnails.first.fallbackIcon, categoryIcon('MASONRY'));

      // A variant opens its vendor offers first; an offer opens Product Details.
      await tester.tap(find.text('BrandCo · 100 mm'));
      await tester.pumpAndSettle();
      expect(find.text('Variant offers'), findsOneWidget);
      expect(find.text('Vendor offers'), findsOneWidget);
      expect(
        tester.getTopLeft(find.text('Vendor offers')).dy,
        lessThan(tester.getTopLeft(find.text('Price history')).dy),
      );
      expect(repository.radii.toSet(), {50});
      await tester.tap(find.text('DEMO — Santos Hardware'));
      expect(opened, 'l1');
    },
  );

  testWidgets(
    'an empty scope renders an explicit null state instead of tiles or a chart',
    (tester) async {
      final repository = FakeAnalyticsRepository()
        ..productsPage = AnalyticsProductsPage(
          envelope: _envelope,
          categories: const [],
          items: const [],
          notYetComparable: 0,
        );
      await pumpOverview(tester, repository);
      expect(find.text('No comparable materials here yet'), findsOneWidget);
      expect(find.byType(CategoryTile), findsNothing);
      expect(find.byType(PriceTrendPanel), findsNothing);
      expect(find.textContaining('listings nearby'), findsNothing);
    },
  );

  testWidgets(
    'offline failures offer a retry and never show stale numbers as current',
    (tester) async {
      final repository = productsRepository()
        ..failure = const DiscoveryFailure(
          DiscoveryFailureKind.offline,
          'You appear to be offline.',
        );
      await pumpOverview(tester, repository);
      expect(find.text('You are offline'), findsOneWidget);
      expect(find.byType(CategoryTile), findsNothing);
      repository.failure = null;
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(CategoryTile, 'Masonry'), findsOneWidget);
    },
  );

  testWidgets(
    'price details: gaps stay gaps, the table syncs with the graph and an offer opens Product Details',
    (tester) async {
      String? opened;
      final repository = FakeAnalyticsRepository()
        ..detail = MaterialPriceDetailsView(
          envelope: _envelope,
          group: _group(),
          description: 'Load-bearing masonry unit.',
          variants: const [
            (groupId: 'g1', displayName: '4-inch CHB — DemoBlock'),
          ],
          series: const [
            AnalyticsPointView(
              date: '2026-10-02',
              status: 'OK',
              average: '100.00',
              vendorCount: 2,
            ),
            AnalyticsPointView(
              date: '2026-10-03',
              status: 'MISSING_DAY',
              label: 'No snapshot recorded for this date',
            ),
            AnalyticsPointView(
              date: '2026-10-04',
              status: 'OK',
              average: '110.00',
              vendorCount: 3,
              participantsChanged: true,
            ),
          ],
        )
        ..currentOffers = const [
          MaterialOfferView(
            vendorId: 'v1',
            storeName: 'DEMO — Santos Hardware',
            listingId: 'l1',
            displayName: 'CHB',
            variantLabel: 'Standard',
            priceCentavos: 10500,
            normalizedPhp: '105.00',
            taxLabel: 'Non-VAT seller',
            availability: 'IN_STOCK',
            distanceMeters: 1200,
          ),
        ];
      await tester.pumpWidget(
        _app(
          MaterialPriceDetailsScreen(
            repository: repository,
            origin: _origin,
            radiusKm: 5,
            groupId: 'g1',
            window: const AnalyticsWindowChoice.preset(7),
            onOpenListing: (_, id) => opened = id,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.textContaining('No snapshot recorded for this date'),
        findsOneWidget,
      );
      final row = find.bySemanticsLabel(
        RegExp(
          r'^Oct 4, 2026, ₱110\.00 per Piece, 3 sellers, sellers changed$',
        ),
      );
      await tester.ensureVisible(row);
      await tester.pumpAndSettle();
      await tester.tap(row);
      await tester.pump();
      final exact = find.text(
        'Oct 4, 2026 · ₱110.00 per Piece · 3 sellers · Sellers changed',
      );
      await tester.ensureVisible(exact);
      expect(exact, findsOneWidget);
      // Offers sit above the price history now, so scroll back up to them.
      await tester.scrollUntilVisible(
        find.text('DEMO — Santos Hardware'),
        -300,
      );
      await tester.tap(find.text('DEMO — Santos Hardware'));
      expect(opened, 'l1');
    },
  );

  testWidgets(
    'the graph shows its reason instead of a line when no day has a value',
    (tester) async {
      await tester.pumpWidget(
        _app(
          const Scaffold(
            body: PriceTrendPanel(
              title: 'Average',
              unit: 'bag',
              emptyReason: 'Fewer than one seller recorded.',
              points: [
                AnalyticsPointView(date: '2026-10-01', status: 'MISSING_DAY'),
              ],
            ),
          ),
        ),
      );
      expect(find.text('No graph for this period'), findsOneWidget);
      expect(find.text('Fewer than one seller recorded.'), findsOneWidget);
    },
  );

  testWidgets(
    'rating needs both seller criteria, previews the public name and submits once',
    (tester) async {
      final repository = FakeReviewsRepository()
        ..order = const OrderReviewsView(
          orderId: 'o1',
          orderReference: 'ORD-1',
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
              displayName: 'CHB',
              variantLabel: 'Standard',
              review: null,
              canReview: true,
            ),
          ],
        );
      tester.view.physicalSize = const Size(800, 3200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      await tester.pumpWidget(
        _app(OrderReviewsScreen(repository: repository, orderId: 'o1')),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.bySemanticsLabel('Service Quality: 5 of 5'));
      await tester.pump();
      await tester.scrollUntilVisible(
        find.text('Preview and submit'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Preview and submit'));
      await tester.pump();
      expect(
        find.text('Rate both Service Quality and Processing Speed.'),
        findsOneWidget,
      );
      for (final label in [
        'Processing Speed: 4 of 5',
        'Product Quality: 3 of 5',
      ]) {
        await tester.ensureVisible(find.bySemanticsLabel(label));
        await tester.tap(find.bySemanticsLabel(label));
      }
      await tester.ensureVisible(find.text('Verified Buyer'));
      await tester.tap(find.text('Verified Buyer'));
      await tester.pump();
      await tester.ensureVisible(find.text('Preview and submit'));
      await tester.tap(find.text('Preview and submit'));
      await tester.pumpAndSettle();
      expect(
        find.text('Shown as Verified Buyer · Verified purchase'),
        findsOneWidget,
      );
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();
      expect(repository.submissions, hasLength(1));
      expect(repository.submissions.single['choice'], 'VERIFIED_BUYER');
      expect(repository.submissions.single['vendor'], (
        service: 5,
        speed: 4,
        comment: null,
      ));
    },
  );

  testWidgets(
    'published listing reviews are labelled verified and can be reported',
    (tester) async {
      final repository = FakeReviewsRepository()
        ..listing = const ListingReviewsView(
          average: '4.00',
          count: 1,
          items: [
            PublicReviewView(
              id: 'r1',
              ratings: ReviewRatingsView(productQuality: 4),
              comment: 'Solid blocks.',
              displayName: 'Ana R.',
              edited: false,
            ),
          ],
        );
      await tester.pumpWidget(
        _app(
          Scaffold(
            body: ListingReviewsSection(
              repository: repository,
              listingId: 'l1',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Ana R. · Verified purchase'), findsOneWidget);
      expect(find.bySemanticsLabel('Product Quality: 4 of 5'), findsOneWidget);
      await tester.tap(find.byTooltip('Report review by Ana R.'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Personal information'));
      await tester.pumpAndSettle();
      expect(repository.reports, ['r1:PERSONAL_INFORMATION']);
    },
  );
}
