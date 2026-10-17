import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/components/price_trend_chart.dart';
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
  testWidgets(
    'analytics list inherits the radius, labels DEMO data, shows trends and limited data, and opens details',
    (tester) async {
      final repository = FakeAnalyticsRepository()
        ..page = MaterialsAnalyticsPage(
          envelope: _envelope,
          items: [
            _group(),
            _group(
              id: 'g2',
              end: const AnalyticsPointView(
                date: '2026-10-04',
                status: 'LIMITED_DATA',
                label: 'Limited Local Data — 1 Vendor',
                average: '95.00',
                vendorCount: 1,
              ),
              trend: const AnalyticsTrendView(
                reason: 'INSUFFICIENT_LOCAL_DATA',
                label: 'Insufficient Local Data',
              ),
              vendors: 0,
            ),
          ],
        );
      await tester.pumpWidget(
        _app(
          MaterialsAnalyticsScreen(
            repository: repository,
            origin: _origin,
            radiusKm: 10,
            onOpenListing: (_, _) {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Within 10 km of Quezon City site'), findsOneWidget);
      expect(find.text('DEMO — Simulated Marketplace Data'), findsOneWidget);
      expect(find.text('+10.00% · Increasing'), findsOneWidget);
      expect(find.text('Insufficient Local Data'), findsOneWidget);
      expect(find.text('Limited Local Data — 1 seller'), findsOneWidget);
      expect(find.text('No Current Offers'), findsOneWidget);
      expect(repository.radii, [10]);
      expect(repository.windows.single, const AnalyticsWindowChoice.preset(30));

      await tester.tap(find.text('7 days'));
      await tester.pumpAndSettle();
      expect(repository.windows.last, const AnalyticsWindowChoice.preset(7));
    },
  );

  testWidgets(
    'an empty history renders an explicit null state instead of an empty chart',
    (tester) async {
      final repository = FakeAnalyticsRepository()
        ..page = MaterialsAnalyticsPage(envelope: _envelope, items: const []);
      await tester.pumpWidget(
        _app(
          MaterialsAnalyticsScreen(
            repository: repository,
            origin: _origin,
            radiusKm: 5,
            onOpenListing: (_, _) {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('No comparable materials here yet'), findsOneWidget);
      expect(
        find
            .byType(CustomPaint)
            .evaluate()
            .where(
              (element) => (element.widget as CustomPaint).painter != null,
            ),
        isEmpty,
      );
    },
  );

  testWidgets(
    'offline failures offer a retry and never show stale numbers as current',
    (tester) async {
      final repository = FakeAnalyticsRepository()
        ..failure = const DiscoveryFailure(
          DiscoveryFailureKind.offline,
          'You appear to be offline.',
        );
      await tester.pumpWidget(
        _app(
          MaterialsAnalyticsScreen(
            repository: repository,
            origin: _origin,
            radiusKm: 5,
            onOpenListing: (_, _) {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('You are offline'), findsOneWidget);
      repository
        ..failure = null
        ..page = MaterialsAnalyticsPage(envelope: _envelope, items: [_group()]);
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(find.text('4-inch CHB — DemoBlock'), findsOneWidget);
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
      await tester.scrollUntilVisible(find.text('DEMO — Santos Hardware'), 300);
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
      expect(find.textContaining('“Verified Buyer”'), findsOneWidget);
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
