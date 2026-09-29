import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/components/procurement_components.dart';
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
import 'package:materyalph/features/item_procurement/material_search_screen.dart';
import 'package:materyalph/features/item_procurement/product_finalization_sheet.dart';
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

/// Removes lines like the server: each call returns the cart without that line and a new version.
class _RemovingRepository extends FakeProcurementRepository {
  final List<String> removed = [];
  final List<int> versions = [];

  @override
  Future<CartView> removeLine(
    CartLineView line, {
    required int cartLockVersion,
  }) async {
    removed.add(line.id);
    versions.add(cartLockVersion);
    final groups = [
      for (final group in cartView.groups)
        if (group.lines.any((item) => item.id != line.id))
          CartGroupView(
            vendorId: group.vendorId,
            vendorName: group.vendorName,
            vacationMode: group.vacationMode,
            fulfillmentOptions: group.fulfillmentOptions,
            fulfillmentMethod: group.fulfillmentMethod,
            lines: [
              for (final item in group.lines)
                if (item.id != line.id) item,
            ],
            materialsSubtotalCentavos: group.materialsSubtotalCentavos,
            status: group.status,
          ),
    ];
    return cartView = CartView(
      id: cartView.id,
      lockVersion: cartView.lockVersion + 1,
      groups: groups,
      savedForLater: cartView.savedForLater,
      destination: cartView.destination,
      lineCount: groups.fold(0, (sum, group) => sum + group.lines.length),
      materialsSubtotalCentavos: 0,
      notice: cartView.notice,
      currentAsOf: cartView.currentAsOf,
    );
  }
}

class _FulfillmentRepository extends FakeProcurementRepository {
  final List<String> fulfillment = [];

  @override
  Future<CartView> setFulfillment(
    String vendorId,
    String method, {
    required int cartLockVersion,
  }) async {
    fulfillment.add('$vendorId:$method');
    return cartView;
  }
}

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
        expect(
          find.bySemanticsLabel('Nearby Verified Vendors: 12'),
          findsOneWidget,
        );
        expect(
          find.bySemanticsLabel('Available Products: 48 Vendor listings'),
          findsOneWidget,
        );
        expect(
          find.text('48 Vendor listings', findRichText: true),
          findsOneWidget,
        );
        expect(
          find.textContaining(' · 5 km'),
          findsOneWidget,
          reason: 'The active location and radius stay visible.',
        );
        expect(find.text('Updated Sep 30, 9:15 AM PHT'), findsOneWidget);
        expect(
          find.bySemanticsLabel('DEMO — Simulated Marketplace Data'),
          findsOneWidget,
        );
        expect(
          tester.getSemantics(
            find.bySemanticsLabel(RegExp('^View Materials Analytics')),
          ),
          matchesSemantics(
            isButton: true,
            hasEnabledState: true,
            isEnabled: false,
          ),
          reason: 'Materials Analytics stays disabled until its feature ships.',
        );
        expect(find.text('Roofing Materials'), findsOneWidget);
        expect(
          find.bySemanticsLabel('Masonry, 0 Vendor listings'),
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

        expect(
          find.bySemanticsLabel('Nearby Verified Vendors: 3'),
          findsOneWidget,
        );
        expect(
          find.bySemanticsLabel('Nearby Verified Vendors: 99'),
          findsNothing,
        );
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
        expect(
          find.bySemanticsLabel('Nearby Verified Vendors: 12'),
          findsOneWidget,
        );
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

        await tester.tap(find.text('Search any materials'));
        await tester.pumpAndSettle();
        expect(find.byType(MaterialSearchScreen), findsOneWidget);
        await tester.enterText(find.byType(TextField), 'roofing');
        await tester.testTextInput.receiveAction(TextInputAction.search);
        await tester.pumpAndSettle();
        expect(find.byType(SearchResultsScreen), findsOneWidget);
        expect(repository.searches.last.query, 'roofing');
        expect(h.explore.effectiveSort, ListingSort.bestDeal);
        expect(
          find.bySemanticsLabel('Sort by Best Deal'),
          findsOneWidget,
          reason: 'The relevance tab is labelled with the active sort.',
        );
        final card = find.byType(ListingCard);
        expect(
          find.descendant(of: card, matching: find.text('Best Price')),
          findsOneWidget,
        );
        expect(
          find.descendant(of: card, matching: find.text('PS/ICC verified')),
          findsOneWidget,
        );

        await tester.tap(find.widgetWithText(FilterPill, 'Favorite Suppliers'));
        await tester.pumpAndSettle();
        expect(repository.searches.last.filters.favoritesOnly, isTrue);
        await tester.tap(find.text('Best Deal'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Favorites First'));
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
        Navigator.of(tester.element(find.byType(RankingExplanation))).pop();
        await tester.pumpAndSettle();

        Navigator.of(tester.element(find.byType(SearchResultsScreen))).pop();
        await tester.pumpAndSettle();
        h.navigation.openResults(tester.element(find.byType(ExploreScreen)));
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<FilterPill>(
                find.widgetWithText(FilterPill, 'Favorite Suppliers'),
              )
              .selected,
          isTrue,
        );
        expect(
          find.bySemanticsLabel('Sort by Favorites First'),
          findsOneWidget,
        );
        expect(h.explore.effectiveSort, ListingSort.favoritesFirst);
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
        expect(find.text('Search not found'), findsOneWidget);
        expect(
          find.textContaining('No Verified Vendor listings match'),
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
      'automatically balance to 100%, save personalization and reset',
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
        expect(find.text('Total 100%'), findsOneWidget);
        expect(save().onPressed, isNotNull);
        await tester.tap(find.byTooltip('Decrease Distance'));
        await tester.pump();
        expect(find.text('Total 100%'), findsOneWidget);
        final slider = tester.widget<Slider>(find.byType(Slider).first);
        slider.onChanged!(40);
        await tester.pump();
        await tester.tap(find.widgetWithText(FilledButton, 'Save preferences'));
        await tester.pumpAndSettle();
        expect(repository.savedWeights.single.total, 100);
        expect(repository.savedWeights.single.distance, 40);
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
      'Buy opens finalization and continues to the existing checkout preview',
      (tester) async {
        final repository = FakeProcurementRepository()
          ..detail = listingDetail();
        final source = repository.cartView;
        final line = CartLineView(
          id: 'buy-line',
          listingId: 'listing-1',
          variantId: 'variant-red',
          vendorId: 'vendor-1',
          displayName: source.groups.first.lines.first.displayName,
          unitName: 'Piece',
          quantity: '1.0000',
          quantityStep: '1',
          savedForLater: false,
          issues: const [],
          status: 'READY',
          currentUnitPriceCentavos: 137500,
          lineTotalCentavos: 137500,
        );
        repository.cartView = CartView(
          id: source.id,
          lockVersion: source.lockVersion,
          groups: [
            CartGroupView(
              vendorId: 'vendor-1',
              vendorName: source.groups.first.vendorName,
              vacationMode: false,
              fulfillmentOptions: const ['PICKUP'],
              lines: [line],
              materialsSubtotalCentavos: 137500,
              status: 'READY',
              fulfillmentMethod: 'PICKUP',
            ),
          ],
          savedForLater: const [],
          destination: source.destination,
          lineCount: 1,
          materialsSubtotalCentavos: 137500,
          notice: source.notice,
          currentAsOf: source.currentAsOf,
        );
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
        await tester.tap(find.widgetWithText(FilledButton, 'Buy'));
        await tester.pumpAndSettle();
        expect(find.byType(ProductFinalizationSheet), findsOneWidget);
        expect(repository.addKeys, isEmpty);
        await tester.tap(find.widgetWithText(FilterPill, 'Self-Pickup').last);
        await tester.pump();
        await tester.tap(find.widgetWithText(FilledButton, 'Checkout'));
        await tester.pumpAndSettle();
        expect(repository.addKeys, hasLength(1));
        expect(find.byType(CheckoutPreviewScreen), findsOneWidget);
        expect(find.byType(ProductFinalizationSheet), findsNothing);
      },
    );

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
      'Delete asks first, then removes each selected line with the latest cart version',
      (tester) async {
        final repository = _RemovingRepository();
        final h = await _harness(repository);
        await h.cart.load();
        await _pump(
          tester,
          CartScreen(controller: h.cart, navigation: h.navigation),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.widgetWithText(TextButton, 'Delete'));
        await tester.pumpAndSettle();
        expect(find.text('Remove 2 selected items?'), findsOneWidget);
        await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
        await tester.pumpAndSettle();
        expect(repository.removed, isEmpty);

        await tester.tap(find.widgetWithText(TextButton, 'Delete'));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(TextButton, 'Remove'));
        await tester.pumpAndSettle();
        expect(repository.removed, ['a', 'b']);
        expect(repository.versions, [3, 4]);
        expect(find.text('Your cart is empty'), findsOneWidget);
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
          find.text('Intended destination / Project site'),
          findsOneWidget,
        );
        expect(find.text('629 J Nepomuceno St'), findsOneWidget);
        expect(find.text('Project site'), findsOneWidget);
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
      'Delivery Mode switches per store, unoffered modes are disabled, and the design previews send nothing',
      (tester) async {
        final repository = _FulfillmentRepository();
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
          find.bySemanticsLabel('Site Delivery (not offered)'),
          findsOneWidget,
          reason: 'Bravo Builders Depot offers Self-Pickup only.',
        );
        await tester.tap(find.bySemanticsLabel('Self-Pickup').first);
        await tester.pumpAndSettle();
        expect(repository.fulfillment, ['vendor-1:PICKUP']);
        expect(find.byType(CheckoutPreviewScreen), findsOneWidget);

        await tester.scrollUntilVisible(
          find.text('Request E-Invoice'),
          300,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.ensureVisible(find.text('Request E-Invoice'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Request E-Invoice'));
        await tester.pumpAndSettle();
        expect(
          find.text('Design preview — nothing is saved or sent'),
          findsOneWidget,
        );
        expect(
          tester
              .widget<FilledButton>(
                find.widgetWithText(FilledButton, 'Submit Request'),
              )
              .onPressed,
          isNull,
        );
        await tester.tap(find.byTooltip('Back'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Preview confirmation'));
        await tester.pumpAndSettle();
        expect(
          find.text('Design preview — no order was created'),
          findsOneWidget,
        );
        expect(find.text('Assigned when submitted'), findsOneWidget);
        expect(
          tester
              .widget<FilledButton>(
                find.widgetWithText(FilledButton, 'Track Order'),
              )
              .onPressed,
          isNull,
        );
        expect(repository.destinations, isEmpty);
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

        await tester.tap(find.widgetWithText(FilterPill, 'Self-Pickup'));
        await tester.pump();
        repository.addFailure = const DiscoveryFailure(
          DiscoveryFailureKind.offline,
          'You appear to be offline. Check your connection and retry.',
        );
        await tester.tap(find.widgetWithText(FilledButton, 'Add to Cart').last);
        await tester.pumpAndSettle();
        expect(find.byType(ProductFinalizationSheet), findsOneWidget);
        await tester.tap(find.widgetWithText(FilledButton, 'Add to Cart').last);
        await tester.pumpAndSettle();
        repository.addFailure = null;
        await tester.tap(find.widgetWithText(FilledButton, 'Add to Cart').last);
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
      '375 px': (const Size(375, 812), 1.0),
      '768 px': (const Size(768, 1024), 1.0),
      '1024 px': (const Size(1024, 768), 1.0),
      '1280 px': (const Size(1280, 800), 1.0),
      '1440 px': (const Size(1440, 900), 1.0),
      '1920 px': (const Size(1920, 1080), 1.0),
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
