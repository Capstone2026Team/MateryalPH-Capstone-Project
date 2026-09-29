import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/item_procurement/explore_controller.dart';
import 'package:materyalph/features/item_procurement/cart_controller.dart';
import 'package:materyalph/features/item_procurement/material_search_screen.dart';
import 'package:materyalph/features/item_procurement/procurement_models.dart';
import 'package:materyalph/features/item_procurement/product_finalization_sheet.dart';
import 'package:materyalph/features/item_procurement/ranking_preferences_screen.dart';
import 'package:materyalph/screens/buyer_home_screen.dart';
import 'package:materyalph/features/map_discovery/discovery_controller.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';

import 'item_procurement_fakes.dart';
import 'map_discovery_fakes.dart';
import 'buyer_account_test.dart' as account_fixtures;

void main() {
  testWidgets(
    'Profile Ranking Preferences opens the real persisted preference page',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: BuyerTheme.light,
          home: BuyerHomeScreen(
            repository: account_fixtures.repository(),
            discoveryRepository: FakeDiscoveryRepository(),
            procurementRepository: FakeProcurementRepository(),
            onSignOut: () async {},
          ),
        ),
      );
      await tester.tap(find.bySemanticsLabel('Profile'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(find.text('Ranking Preferences'), 180);
      await tester.tap(find.text('Ranking Preferences'));
      await tester.pumpAndSettle();
      expect(find.byType(RankingPreferencesScreen), findsOneWidget);
      expect(find.text('Using the platform default weights'), findsOneWidget);
      expect(find.text('Total 100%'), findsOneWidget);
      expect(find.text('This feature is not available yet.'), findsNothing);
    },
  );

  test('rapid favorites coalesce and synchronize the catalog', () async {
    final repository = _DelayedFavorites();
    final discovery = DiscoveryController(repository: repository);
    final explore = ExploreController(
      repository: FakeProcurementRepository(),
      discovery: discovery,
    );
    explore.results = [listingCard('a')];
    final vendor = explore.results.single.vendorId;
    final pending = explore.setFavorite(vendor, favorite: true);
    await explore.setFavorite(vendor, favorite: true);
    expect(repository.calls, 1);
    expect(explore.favoriteBusy(vendor), isTrue);
    repository.done.complete();
    await pending;
    expect(explore.results.single.isFavorite, isTrue);
    expect(explore.favoriteBusy(vendor), isFalse);
    explore.dispose();
    discovery.dispose();
  });

  test(
    'rapid cart quantity taps send one versioned mutation and invalidate preview',
    () async {
      final repository = _DelayedCart();
      final cart = CartController(repository: repository);
      await cart.load();
      final line = cart.cart!.groups.first.lines.first;
      final pending = cart.changeQuantity(line, '3');
      await cart.changeQuantity(line, '4');
      expect(repository.calls, 1);
      expect(cart.busy, isTrue);
      repository.done.complete(twoVendorCart(lockVersion: 4));
      await pending;
      expect(cart.cart!.lockVersion, 4);
      expect(cart.busy, isFalse);
      expect(cart.preview, isNull);
      cart.dispose();
    },
  );
  test(
    'every one-percent adjustment stays exactly 100 including single-factor allocations',
    () {
      const defaults = RankingWeights.approvedDefault;
      const keys = ['distance', 'price', 'vps', 'stock', 'product_rating'];
      for (final start in [
        defaults,
        defaults.rebalance('distance', 100, defaults: defaults),
      ]) {
        for (final key in keys) {
          for (var value = 0; value <= 100; value++) {
            final weights = start.rebalance(key, value, defaults: defaults);
            expect(weights.total, 100);
            expect(weights.valueOf(key), value);
            expect(
              keys.every(
                (item) =>
                    weights.valueOf(item) >= 0 && weights.valueOf(item) <= 100,
              ),
              isTrue,
            );
            expect(weights, start.rebalance(key, value, defaults: defaults));
          }
        }
      }
      expect(
        defaults.rebalance('distance', 40, defaults: defaults),
        const RankingWeights(
          distance: 40,
          price: 21,
          vps: 17,
          stock: 13,
          productRating: 9,
        ),
      );
      expect(
        defaults.rebalance('distance', 20, defaults: defaults),
        const RankingWeights(
          distance: 20,
          price: 29,
          vps: 23,
          stock: 17,
          productRating: 11,
        ),
      );
    },
  );

  test('sort wire values round trip and explicit direction is independent', () {
    for (final sort in ListingSort.values) {
      expect(ListingSortWire.parse(sort.wire), sort);
      expect(sort.reversed.reversed, sort);
    }
    expect(ListingSort.bestDeal.reversed, ListingSort.bestDeal);
    expect(ListingSort.favoritesFirst.reversed, ListingSort.favoritesFirst);
  });

  Future<ExploreController> controller(
    FakeProcurementRepository repository,
  ) async {
    final discovery = DiscoveryController(
      repository: FakeDiscoveryRepository(),
    );
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
    addTearDown(() {
      explore.dispose();
      discovery.dispose();
    });
    return explore;
  }

  test(
    'history records only submitted queries, deduplicates and clears',
    () async {
      final repository = FakeProcurementRepository();
      final explore = await controller(repository);
      await explore.search(query: ' Roof ');
      await explore.search(query: 'cement');
      await explore.search(query: 'roof');
      await explore.suggestions('wood');
      expect(explore.recentSearches, ['roof', 'cement']);
      explore.clearRecentSearches();
      expect(explore.recentSearches, isEmpty);
    },
  );

  test(
    'a failed category or radius change never displays the previous scope as matching products',
    () async {
      final repository = FakeProcurementRepository();
      final explore = await controller(repository);
      await explore.search(
        filters: const ListingFilters(categoryId: 'roofing'),
      );
      expect(explore.results, isNotEmpty);
      repository.searchFailure = const DiscoveryFailure(
        DiscoveryFailureKind.offline,
        'Offline',
      );
      await explore.search(filters: const ListingFilters(categoryId: 'cement'));
      expect(explore.results, isEmpty);
      expect(explore.searchPhase, LoadPhase.failed);
      repository.searchFailure = null;
      await explore.retrySearch();
      expect(explore.results, isNotEmpty);
      repository.searchFailure = const DiscoveryFailure(
        DiscoveryFailureKind.offline,
        'Offline',
      );
      await explore.discovery.selectRadius(20);
      await Future<void>.delayed(Duration.zero);
      expect(explore.results, isEmpty);
      expect(explore.radiusKm, 20);
    },
  );

  test(
    'all supported radii remain shared with Map and preserve category and sort',
    () async {
      final repository = FakeProcurementRepository();
      final explore = await controller(repository);
      await explore.search(
        query: 'roof',
        filters: const ListingFilters(categoryId: 'roofing'),
        sort: () => ListingSort.priceDescending,
      );
      for (final km in [5, 10, 20, 30, 40, 50]) {
        await explore.discovery.selectRadius(km);
        expect(explore.radiusKm, km);
        expect(explore.filters.categoryId, 'roofing');
        expect(explore.sort, ListingSort.priceDescending);
        expect(repository.searches.last.filters.categoryId, 'roofing');
      }
    },
  );

  testWidgets(
    'suggestions debounce and discard stale replies without changing catalog state',
    (tester) async {
      final repository = FakeProcurementRepository()..manualSearch = true;
      final explore = await controller(repository);
      await tester.pumpWidget(
        MaterialApp(
          theme: BuyerTheme.light,
          home: MaterialSearchScreen(controller: explore),
        ),
      );
      await tester.enterText(find.byType(TextField), 'ro');
      await tester.pump(const Duration(milliseconds: 200));
      expect(repository.searches, isEmpty);
      await tester.enterText(find.byType(TextField), 'roof');
      await tester.pump(const Duration(milliseconds: 350));
      expect(repository.searches.length, 1);
      await tester.enterText(find.byType(TextField), 'cement');
      await tester.pump(const Duration(milliseconds: 350));
      repository.searchCalls[1].complete(
        searchPage([listingCard('new', name: 'Cement bag')]),
      );
      await tester.pump();
      repository.searchCalls[0].complete(
        searchPage([listingCard('old', name: 'Roof sheet')]),
      );
      await tester.pumpAndSettle();
      expect(find.text('Cement bag'), findsOneWidget);
      expect(find.text('Roof sheet'), findsNothing);
      expect(explore.query, '');
      expect(explore.recentSearches, isEmpty);
    },
  );

  testWidgets(
    'finalization applies volume price, prevents zero, and retains stock errors',
    (tester) async {
      final detail = listingDetail();
      final variant = detail.variants.firstWhere((item) => item.available);
      var calls = 0;
      await tester.pumpWidget(
        MaterialApp(
          theme: BuyerTheme.light,
          home: Scaffold(
            body: ProductFinalizationSheet(
              detail: () => detail,
              variantId: variant.variantId,
              quantity: 49,
              fulfillment: 'PICKUP',
              buy: false,
              onConfirm: (id, quantity, fulfillment) async {
                calls++;
                expect(id, variant.variantId);
                expect(quantity, 50);
                expect(fulfillment, 'PICKUP');
                return 'The requested quantity is no longer available.';
              },
            ),
          ),
        ),
      );
      await tester.tap(find.byTooltip('Increase quantity'));
      await tester.pump();
      // The header price and the Unit price row both switch to the 50+ volume tier.
      expect(find.text('₱1,300.00 / Piece'), findsNWidgets(2));
      expect(find.text('50 Piece'), findsOneWidget);
      expect(find.text('₱65,000.00'), findsOneWidget);
      await tester.ensureVisible(
        find.widgetWithText(FilledButton, 'Add to Cart'),
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Add to Cart'));
      await tester.pumpAndSettle();
      expect(calls, 1);
      expect(
        find.text('The requested quantity is no longer available.'),
        findsOneWidget,
      );
    },
  );
}

class _DelayedFavorites extends FakeDiscoveryRepository {
  final done = Completer<void>();
  int calls = 0;
  @override
  Future<void> setFavorite(String vendorId, {required bool favorite}) {
    calls++;
    return done.future;
  }
}

class _DelayedCart extends FakeProcurementRepository {
  final done = Completer<CartView>();
  int calls = 0;
  @override
  Future<CartView> updateLine(
    CartLineView line, {
    required int cartLockVersion,
    String? quantity,
    bool? savedForLater,
    bool acceptCurrentPrice = false,
  }) {
    calls++;
    return done.future;
  }
}
