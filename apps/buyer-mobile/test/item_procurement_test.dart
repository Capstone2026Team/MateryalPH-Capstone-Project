import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/item_procurement/cart_controller.dart';
import 'package:materyalph/features/item_procurement/cart_screen.dart';
import 'package:materyalph/features/item_procurement/checkout_preview_screen.dart';
import 'package:materyalph/features/item_procurement/explore_controller.dart';
import 'package:materyalph/features/item_procurement/explore_screen.dart';
import 'package:materyalph/features/item_procurement/procurement_models.dart';
import 'package:materyalph/features/item_procurement/procurement_navigation.dart';
import 'package:materyalph/features/item_procurement/product_details_screen.dart';
import 'package:materyalph/features/item_procurement/ranking_preferences_screen.dart';
import 'package:materyalph/features/item_procurement/search_results_screen.dart';
import 'package:materyalph/features/map_discovery/discovery_controller.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';
import 'package:materyalph/screens/buyer_store_browse_screen.dart';

import 'item_procurement_fakes.dart';
import 'map_discovery_fakes.dart';

const _gateLocation = SavedLocationView(
  id: 'loc-2',
  label: 'North gate',
  kind: 'DELIVERY',
  isPrimary: false,
  formattedAddress: 'North gate, Quiapo, Manila',
  point: GeoPoint(14.6, 120.985),
  psgc: PsgcSummary(resolution: 'RESOLVED', version: '2025Q2'),
  lockVersion: 1,
);

class _Harness {
  _Harness(
    this.repository,
    this.discovery,
    this.explore,
    this.cart,
    this.navigation,
  );

  final FakeProcurementRepository repository;
  final DiscoveryController discovery;
  final ExploreController explore;
  final CartController cart;
  final ProcurementNavigation navigation;
}

Future<_Harness> _harness(FakeProcurementRepository repository) async {
  final discovery = DiscoveryController(repository: FakeDiscoveryRepository());
  await discovery.setOrigin(
    DiscoveryOrigin.saved(
      locationId: primaryLocation.id,
      label: primaryLocation.label,
      point: primaryLocation.point,
    ),
  );
  final explore = ExploreController(
    repository: repository,
    discovery: discovery,
  );
  final cart = CartController(repository: repository);
  final navigation = ProcurementNavigation(
    explore: explore,
    cart: cart,
    repository: repository,
    openStoreProfile: (_, _) {},
  );
  return _Harness(repository, discovery, explore, cart, navigation);
}

Future<void> _pump(
  WidgetTester tester,
  Widget home, {
  Size size = const Size(390, 2400),
  double textScale = 1,
}) async {
  await tester.binding.setSurfaceSize(size);
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(() {
    tester.platformDispatcher.clearTextScaleFactorTestValue();
    return tester.binding.setSurfaceSize(null);
  });
  await tester.pumpWidget(MaterialApp(theme: BuyerTheme.light, home: home));
  await tester.pump();
}

Widget _explore(_Harness h) => ExploreScreen(
  controller: h.explore,
  cart: h.cart,
  navigation: h.navigation,
  onOpenMap: () {},
);

void main() {
  group('Explore dashboard', () {
    testWidgets(
      'loads without a false zero, then shows one snapshot with scope, time and Vendor listings',
      (tester) async {
        final repository = FakeProcurementRepository()..manualSummary = true;
        final h = await _harness(repository);
        await _pump(tester, _explore(h));

        expect(
          find.bySemanticsLabel('Nearby Verified Vendors, loading'),
          findsOneWidget,
        );
        expect(
          find.bySemanticsLabel('Available Products, loading'),
          findsOneWidget,
        );
        expect(find.text('0'), findsNothing);

        repository.summaryCalls.single.complete(summaryFixture());
        await tester.pumpAndSettle();
        expect(find.text('12'), findsOneWidget);
        expect(find.text('48'), findsOneWidget);
        expect(find.text('Vendor listings'), findsOneWidget);
        expect(
          find.bySemanticsLabel('Available Products: 48 Vendor listings'),
          findsOneWidget,
        );
        expect(
          find.textContaining('before category or search filters'),
          findsOneWidget,
        );
        expect(find.text('Current as of Sep 30, 9:15 AM PHT'), findsOneWidget);
        expect(find.text('DEMO — Simulated Marketplace Data'), findsOneWidget);
        final analytics = tester.widget<OutlinedButton>(
          find.widgetWithText(OutlinedButton, 'View Materials Analytics'),
        );
        expect(
          analytics.onPressed,
          isNull,
          reason: 'Materials Analytics stays disabled until its feature ships.',
        );
        expect(find.text('Roofing Materials'), findsOneWidget);
        expect(
          find.text('0 Vendor listings'),
          findsOneWidget,
          reason: 'A real zero appears only after loading.',
        );
      },
    );

    testWidgets(
      'a slower response for an earlier location or radius is discarded',
      (tester) async {
        final repository = FakeProcurementRepository()..manualSummary = true;
        final h = await _harness(repository);
        await _pump(tester, _explore(h));
        expect(repository.summaryCalls, hasLength(1));

        await h.discovery.selectRadius(10);
        await tester.pump();
        expect(repository.summaryCalls, hasLength(2));
        repository.summaryCalls[1].complete(
          summaryFixture(vendors: 3, radiusKm: 10),
        );
        await tester.pumpAndSettle();
        repository.summaryCalls[0].complete(summaryFixture(vendors: 99));
        await tester.pumpAndSettle();

        expect(find.text('3'), findsOneWidget);
        expect(find.text('99'), findsNothing);
      },
    );

    testWidgets(
      'a failed refresh keeps the earlier counts labelled as stale with a retry',
      (tester) async {
        final repository = FakeProcurementRepository();
        final h = await _harness(repository);
        await _pump(tester, _explore(h));
        await tester.pumpAndSettle();
        repository.summaryFailure = const DiscoveryFailure(
          DiscoveryFailureKind.offline,
          'You appear to be offline. Check your connection and retry.',
        );
        await h.explore.loadSummary();
        await tester.pumpAndSettle();

        expect(find.text('Showing the last successful update'), findsOneWidget);
        expect(find.text('12'), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
      },
    );
  });

  group('Search results and ranking', () {
    testWidgets(
      'filters and sort survive navigation, Favorites First is explicit and ranking is explained in text',
      (tester) async {
        final repository = FakeProcurementRepository(
          page: searchPage([
            listingCard('l-1', badges: const ['BEST_PRICE', 'PS_ICC_VERIFIED']),
          ]),
        );
        final h = await _harness(repository);
        await _pump(tester, _explore(h));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.widgetWithText(TextField, 'Search materials'),
          'roofing',
        );
        await tester.testTextInput.receiveAction(TextInputAction.search);
        await tester.pumpAndSettle();
        expect(find.byType(SearchResultsScreen), findsOneWidget);
        expect(repository.searches.last.query, 'roofing');
        expect(
          tester
              .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Best Deal'))
              .selected,
          isTrue,
        );
        expect(find.text('Best Price'), findsOneWidget);
        expect(find.text('PS/ICC evidence verified'), findsOneWidget);

        await tester.tap(find.widgetWithText(FilterChip, 'Favorite Suppliers'));
        await tester.pumpAndSettle();
        expect(repository.searches.last.filters.favoritesOnly, isTrue);
        await tester.ensureVisible(
          find.widgetWithText(ChoiceChip, 'Favorites First'),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(ChoiceChip, 'Favorites First'));
        await tester.pumpAndSettle();
        expect(repository.searches.last.sort, ListingSort.favoritesFirst);

        await tester.tap(find.textContaining('Why this ranking'));
        await tester.pumpAndSettle();
        expect(find.text('Distance: 80.00 × 30% = 24.00'), findsOneWidget);
        expect(find.text('Price: 83.33 × 25% = 20.83'), findsOneWidget);
        expect(
          find.text('New — no product ratings yet (internal neutral score)'),
          findsOneWidget,
        );

        Navigator.of(tester.element(find.byType(SearchResultsScreen))).pop();
        await tester.pumpAndSettle();
        h.navigation.openResults(tester.element(find.byType(ExploreScreen)));
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<FilterChip>(
                find.widgetWithText(FilterChip, 'Favorite Suppliers'),
              )
              .selected,
          isTrue,
        );
        expect(
          tester
              .widget<ChoiceChip>(
                find.widgetWithText(ChoiceChip, 'Favorites First'),
              )
              .selected,
          isTrue,
        );
      },
    );

    testWidgets('a stale search response never replaces newer results', (
      tester,
    ) async {
      final repository = FakeProcurementRepository()..manualSearch = true;
      final h = await _harness(repository);
      await _pump(
        tester,
        SearchResultsScreen(controller: h.explore, navigation: h.navigation),
      );
      final first = h.explore.search(query: 'block');
      final second = h.explore.search(query: 'roof');
      repository.searchCalls[1].complete(
        searchPage([listingCard('new', name: 'Roof sheet newer')]),
      );
      repository.searchCalls[0].complete(
        searchPage([listingCard('old', name: 'Hollow block older')]),
      );
      await Future.wait([first, second]);
      await tester.pumpAndSettle();

      expect(find.text('Roof sheet newer'), findsOneWidget);
      expect(find.text('Hollow block older'), findsNothing);
    });

    testWidgets(
      'empty results offer filter removal and offline failures offer retry',
      (tester) async {
        final repository = FakeProcurementRepository(
          page: searchPage(const [], suggested: 10),
        );
        final h = await _harness(repository);
        await _pump(
          tester,
          SearchResultsScreen(controller: h.explore, navigation: h.navigation),
        );
        await h.explore.search(
          query: 'x',
          filters: const ListingFilters(inStockOnly: true),
        );
        await tester.pumpAndSettle();
        expect(
          find.text('No matching Verified Vendor listings'),
          findsOneWidget,
        );
        await tester.tap(find.text('Remove filters'));
        await tester.pumpAndSettle();
        expect(repository.searches.last.filters, const ListingFilters());
        expect(find.text('Search within 10 km'), findsOneWidget);

        repository.searchFailure = const DiscoveryFailure(
          DiscoveryFailureKind.offline,
          'You appear to be offline. Check your connection and retry.',
        );
        h.explore.results = const [];
        await h.explore.retrySearch();
        await tester.pumpAndSettle();
        expect(find.text('You are offline'), findsOneWidget);
        expect(find.text('Retry'), findsOneWidget);
      },
    );
  });

  group('Ranking preferences', () {
    testWidgets(
      'require a 100% total with live feedback, reject all-zero, show personalization and reset',
      (tester) async {
        final repository = FakeProcurementRepository();
        await _pump(tester, RankingPreferencesScreen(repository: repository));
        await tester.pumpAndSettle();
        expect(find.text('Using the platform default weights'), findsOneWidget);
        expect(find.text('Total 100%'), findsOneWidget);
        FilledButton save() => tester.widget<FilledButton>(
          find.widgetWithText(FilledButton, 'Save preferences'),
        );
        expect(save().onPressed, isNull, reason: 'Nothing changed yet.');

        await tester.tap(find.byTooltip('Increase Distance'));
        await tester.pump();
        expect(
          find.text('Total 101% — remove 1% to reach 100%'),
          findsOneWidget,
        );
        expect(save().onPressed, isNull);
        await tester.tap(find.byTooltip('Decrease Price'));
        await tester.pump();
        expect(find.text('Total 100%'), findsOneWidget);
        expect(save().onPressed, isNotNull);

        for (final slider
            in tester.widgetList<Slider>(find.byType(Slider)).toList()) {
          slider.onChanged!(0);
        }
        await tester.pump();
        expect(
          find.text('Total 0%. At least one weight must be above zero.'),
          findsOneWidget,
        );
        expect(save().onPressed, isNull);

        final sliders = tester.widgetList<Slider>(find.byType(Slider)).toList();
        sliders[0].onChanged!(60);
        sliders[1].onChanged!(40);
        await tester.pump();
        await tester.ensureVisible(
          find.widgetWithText(FilledButton, 'Save preferences'),
        );
        await tester.tap(find.widgetWithText(FilledButton, 'Save preferences'));
        await tester.pumpAndSettle();
        expect(
          repository.savedWeights.single,
          const RankingWeights(
            distance: 60,
            price: 40,
            vps: 0,
            stock: 0,
            productRating: 0,
          ),
        );
        expect(find.text('Personalized ranking is active'), findsOneWidget);

        await tester.tap(find.text('Reset to Default'));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(FilledButton, 'Reset to Default'));
        await tester.pumpAndSettle();
        expect(find.text('Using the platform default weights'), findsOneWidget);
        expect(find.text('30%'), findsOneWidget);
      },
    );
  });

  group('Cart and checkout preview', () {
    testWidgets(
      'a stale price is shown inline on its own Vendor group and the rest of the cart stays',
      (tester) async {
        final repository = FakeProcurementRepository();
        final h = await _harness(repository);
        await h.cart.load();
        await _pump(
          tester,
          CartScreen(controller: h.cart, navigation: h.navigation),
        );
        await tester.pumpAndSettle();

        expect(
          find.text('L&D Hardware & Construction Supplies'),
          findsOneWidget,
        );
        expect(find.text('Bravo Builders Depot'), findsOneWidget);
        expect(find.text('This store group needs your review'), findsOneWidget);
        expect(
          find.text('You added it at ₱1,175.00; it is now ₱1,200.00.'),
          findsOneWidget,
        );
        expect(
          find.textContaining('separate order request for each Vendor'),
          findsOneWidget,
        );

        await tester.ensureVisible(find.text('Accept current price'));
        await tester.tap(find.text('Accept current price'));
        await tester.pumpAndSettle();
        expect(repository.acceptedLines, ['b']);
        expect(find.text('This store group needs your review'), findsNothing);
        expect(find.text('Apo Longspan Roofing - Tilespan'), findsOneWidget);
      },
    );

    testWidgets(
      'delivery preview labels both destinations and an estimate that is not a confirmed offer',
      (tester) async {
        final repository = FakeProcurementRepository();
        final h = await _harness(repository);
        await h.cart.load();
        await _pump(
          tester,
          CheckoutPreviewScreen(
            controller: h.cart,
            savedLocations: () => const [primaryLocation, _gateLocation],
          ),
        );
        await tester.pumpAndSettle();

        expect(
          find.text('Intended destination / Project site: 629 J Nepomuceno St'),
          findsOneWidget,
        );
        expect(
          find.text(
            'Actual vehicle drop-off: North gate — used for route distance and the delivery fee',
          ),
          findsOneWidget,
        );
        expect(find.text('Estimated delivery ₱605.00–₱705.00'), findsOneWidget);
        expect(
          find.textContaining('Estimate only — not an offer.'),
          findsOneWidget,
        );
        expect(
          find.textContaining('Confirmed offer: none yet.'),
          findsOneWidget,
        );
        expect(
          find.text(
            'Route basis: road route from the store to the alternative drop-off, 4.2 km.',
          ),
          findsOneWidget,
        );
        expect(
          find.text('Cash on Delivery — not offered by this store'),
          findsOneWidget,
        );
        expect(
          find.textContaining(
            '2% commission and withholding are not Buyer charges',
          ),
          findsWidgets,
        );
        expect(find.text('Includes VAT'), findsWidgets);
        final submit = tester.widget<FilledButton>(
          find.widgetWithText(FilledButton, 'Submit order requests'),
        );
        expect(
          submit.onPressed,
          isNull,
          reason: 'Order submission ships with Phase 8.',
        );
      },
    );

    testWidgets(
      'a heavy-vehicle restriction requires an alternate drop-off before it is saved',
      (tester) async {
        final repository = FakeProcurementRepository(
          preview: previewFixture(
            destination: false,
            deliveryStatus: 'ACTION_REQUIRED',
            withAlternate: false,
          ),
        );
        final h = await _harness(repository);
        await h.cart.load();
        await _pump(
          tester,
          CheckoutPreviewScreen(
            controller: h.cart,
            savedLocations: () => const [primaryLocation, _gateLocation],
          ),
          size: const Size(390, 1400),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(DropdownButtonFormField<String>).first);
        await tester.pumpAndSettle();
        await tester.tap(find.textContaining('629 J Nepomuceno St · ').last);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Yes, trucks cannot reach it'));
        await tester.pumpAndSettle();
        await tester.tap(
          find.widgetWithText(OutlinedButton, 'Save destination'),
        );
        await tester.pumpAndSettle();
        expect(
          find.text(
            'A heavy-vehicle restriction needs an alternative drop-off location.',
          ),
          findsOneWidget,
        );
        expect(
          find.text(
            'Describe access and unloading at the alternative drop-off.',
          ),
          findsOneWidget,
        );
        expect(repository.destinations, isEmpty);

        await tester.tap(find.byType(DropdownButtonFormField<String>).last);
        await tester.pumpAndSettle();
        await tester.tap(find.textContaining('North gate · ').last);
        await tester.pumpAndSettle();
        await tester.enterText(
          find.widgetWithText(
            TextField,
            'Access and unloading instructions (required)',
          ),
          'Forklift at the north gate.',
        );
        await tester.tap(
          find.widgetWithText(OutlinedButton, 'Save destination'),
        );
        await tester.pumpAndSettle();
        final saved = repository.destinations.single;
        expect(
          [saved.intended, saved.restriction, saved.alternate],
          ['loc-1', 'YES', 'loc-2'],
        );
        expect(saved.instructions, 'Forklift at the north gate.');
      },
    );

    testWidgets(
      'manual review and a blocked route never show a fictitious delivery fee',
      (tester) async {
        final repository = FakeProcurementRepository(
          preview: previewFixture(deliveryStatus: 'MANUAL_REVIEW'),
        );
        final h = await _harness(repository);
        await h.cart.load();
        await _pump(
          tester,
          CheckoutPreviewScreen(
            controller: h.cart,
            savedLocations: () => const [primaryLocation],
          ),
        );
        await tester.pumpAndSettle();
        expect(
          find.text('The Vendor will review this delivery manually'),
          findsOneWidget,
        );
        expect(find.text('Pending Vendor review'), findsOneWidget);
        expect(find.textContaining('Estimated delivery'), findsNothing);

        repository.preview = previewFixture(deliveryStatus: 'BLOCKED');
        await h.cart.loadPreview();
        await tester.pumpAndSettle();
        expect(find.text('Blocked — stays in your cart'), findsOneWidget);
        expect(
          find.textContaining('Only ready groups can continue'),
          findsOneWidget,
        );
        await tester.scrollUntilVisible(
          find.text('Bravo Builders Depot'),
          300,
          scrollable: find.byType(Scrollable).first,
        );
        expect(
          find.text('Bravo Builders Depot'),
          findsOneWidget,
          reason: 'Other groups stay previewable.',
        );
      },
    );

    testWidgets(
      'Add to Cart retries with the same idempotency key after a network failure',
      (tester) async {
        final repository = FakeProcurementRepository()
          ..detail = listingDetail();
        final h = await _harness(repository);
        await _pump(
          tester,
          ProductDetailsScreen(
            listingId: 'listing-1',
            repository: repository,
            explore: h.explore,
            cart: h.cart,
            navigation: h.navigation,
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('₱1,375.00 / Piece'), findsOneWidget);
        expect(find.text('Buy 50+ Piece: ₱1,300.00 each'), findsOneWidget);
        expect(
          find.textContaining('Green · 12 ft · Not currently offered'),
          findsOneWidget,
        );

        await tester.tap(find.widgetWithText(ChoiceChip, 'Self-Pickup'));
        await tester.pump();
        repository.addFailure = const DiscoveryFailure(
          DiscoveryFailureKind.offline,
          'You appear to be offline. Check your connection and retry.',
        );
        await tester.tap(find.widgetWithText(FilledButton, 'Add to Cart'));
        await tester.pumpAndSettle();
        repository.addFailure = null;
        await tester.tap(find.widgetWithText(FilledButton, 'Add to Cart'));
        await tester.pumpAndSettle();
        expect(repository.addKeys, hasLength(2));
        expect(repository.addKeys[0], repository.addKeys[1]);
        expect(
          find.textContaining('Nothing is reserved until the Vendor confirms'),
          findsOneWidget,
        );
      },
    );
  });

  group('Public Store Operation', () {
    StoreHoursView hours({bool allClosed = false, bool available = true}) =>
        StoreHoursView(
          available: available,
          week: available
              ? [
                  StoreHoursDayView(
                    date: '2026-09-30',
                    weekday: 'Wednesday',
                    open: false,
                    fromOverride: true,
                  ),
                  for (final (date, weekday) in [
                    ('2026-10-01', 'Thursday'),
                    ('2026-10-02', 'Friday'),
                    ('2026-10-03', 'Saturday'),
                    ('2026-10-04', 'Sunday'),
                    ('2026-10-05', 'Monday'),
                    ('2026-10-06', 'Tuesday'),
                  ])
                    StoreHoursDayView(
                      date: date,
                      weekday: weekday,
                      open: !allClosed,
                      fromOverride: false,
                      opensAt: allClosed ? null : '08:00',
                      closesAt: allClosed ? null : '17:00',
                    ),
                ]
              : const [],
          openNowStatus: available ? 'CLOSED' : 'UNAVAILABLE',
          allClosed: allClosed,
          asOf: DateTime.utc(2026, 9, 29, 16, 30),
          notice: 'Hours are informational only.',
          nextOpeningDate: allClosed || !available ? null : '2026-10-01',
          nextOpeningWeekday: allClosed || !available ? null : 'Thursday',
          nextOpeningTime: allClosed || !available ? null : '08:00',
        );

    testWidgets(
      'shows the server Manila dates, a dated override and the next opening regardless of the phone zone',
      (tester) async {
        // 16:30 UTC on 29 September is already 30 September in Asia/Manila; the page shows the server's date.
        await _pump(
          tester,
          Scaffold(
            body: ListView(
              children: [StoreHoursSection(hours: hours(), onRetry: () {})],
            ),
          ),
        );
        expect(find.text('Today · Wednesday, Sep 30'), findsOneWidget);
        expect(find.text('Closed · date-specific'), findsOneWidget);
        expect(
          find.text('Closed now · opens Thursday Oct 1, 8:00 AM'),
          findsOneWidget,
        );
        expect(
          find.textContaining('as of Sep 30, 12:30 AM PHT'),
          findsOneWidget,
        );
        expect(find.text('8:00 AM – 5:00 PM'), findsNWidgets(6));
      },
    );

    testWidgets(
      'all-Closed is shown as a valid schedule and missing hours are never fabricated',
      (tester) async {
        await _pump(
          tester,
          Scaffold(
            body: ListView(
              children: [
                StoreHoursSection(
                  hours: hours(allClosed: true),
                  onRetry: () {},
                ),
              ],
            ),
          ),
        );
        expect(
          find.text('Closed on all days of the saved schedule'),
          findsOneWidget,
        );
        expect(find.text('Closed'), findsNWidgets(6));

        await _pump(
          tester,
          Scaffold(
            body: ListView(
              children: [
                StoreHoursSection(
                  hours: hours(available: false),
                  onRetry: () {},
                ),
              ],
            ),
          ),
        );
        expect(find.text('Hours unavailable'), findsOneWidget);
        expect(find.textContaining('8:00'), findsNothing);
        expect(find.text('Retry'), findsOneWidget);
      },
    );
  });

  group('Layouts', () {
    final sizes = <String, (Size, double)>{
      '320 px at 2x text': (const Size(320, 700), 2.0),
      'landscape': (const Size(844, 390), 1.0),
      '390 px': (const Size(390, 844), 1.0),
    };
    for (final entry in sizes.entries) {
      testWidgets(
        'Explore, results, details, cart and checkout render without overflow at ${entry.key}',
        (tester) async {
          final (size, scale) = entry.value;
          final repository = FakeProcurementRepository(
            page: searchPage([
              listingCard('l-1', badges: const ['BEST_PRICE']),
              listingCard('l-2', favorite: true),
            ]),
          )..detail = listingDetail();
          final h = await _harness(repository);
          await h.cart.load();
          await h.explore.search(query: 'roofing');
          for (final page in <Widget>[
            _explore(h),
            SearchResultsScreen(
              controller: h.explore,
              navigation: h.navigation,
            ),
            ProductDetailsScreen(
              listingId: 'listing-1',
              repository: repository,
              explore: h.explore,
              cart: h.cart,
              navigation: h.navigation,
            ),
            CartScreen(controller: h.cart, navigation: h.navigation),
            CheckoutPreviewScreen(
              controller: h.cart,
              savedLocations: () => const [primaryLocation, _gateLocation],
            ),
            RankingPreferencesScreen(repository: repository),
          ]) {
            await _pump(tester, page, size: size, textScale: scale);
            await tester.pumpAndSettle();
            expect(
              tester.takeException(),
              isNull,
              reason: '${page.runtimeType} at ${entry.key}',
            );
          }
        },
      );
    }
  });
}
