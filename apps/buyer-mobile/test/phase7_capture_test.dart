import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/item_procurement/cart_controller.dart';
import 'package:materyalph/features/item_procurement/cart_screen.dart';
import 'package:materyalph/features/item_procurement/checkout_preview_screen.dart';
import 'package:materyalph/features/item_procurement/explore_controller.dart';
import 'package:materyalph/features/item_procurement/explore_screen.dart';
import 'package:materyalph/features/item_procurement/procurement_navigation.dart';
import 'package:materyalph/features/item_procurement/product_details_screen.dart';
import 'package:materyalph/features/item_procurement/ranking_preferences_screen.dart';
import 'package:materyalph/features/item_procurement/search_results_screen.dart';
import 'package:materyalph/features/map_discovery/discovery_controller.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';

import 'item_procurement_fakes.dart';
import 'map_discovery_fakes.dart';

/// Phase 7 layout evidence from synthetic fixtures. Screenshots illustrate layout and states only;
/// they are not live marketplace data, provider readiness or confirmed delivery offers.
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

  const gate = SavedLocationView(
    id: 'loc-2',
    label: 'North gate',
    kind: 'DELIVERY',
    isPrimary: false,
    formattedAddress: 'North gate, Quiapo, Manila',
    point: GeoPoint(14.6, 120.985),
    psgc: PsgcSummary(resolution: 'RESOLVED', version: '2025Q2'),
    lockVersion: 1,
  );

  Future<
    (
      ExploreController,
      CartController,
      ProcurementNavigation,
      FakeProcurementRepository,
    )
  >
  setup() async {
    final repository = FakeProcurementRepository(
      page: searchPage([
        listingCard('l-1', badges: const ['BEST_PRICE', 'PS_ICC_VERIFIED']),
        listingCard(
          'l-2',
          name: 'Apo Longspan Roofing - Ribtype',
          price: 117500,
          vendor: 'Bravo Builders Depot',
          vendorId: 'vendor-2',
          favorite: true,
          distance: 2400,
          stock: 'LIMITED_STOCK',
          rank: 2,
        ),
      ], personalized: true),
    )..detail = listingDetail();
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
    final cart = CartController(repository: repository);
    await cart.load();
    await explore.search(query: 'roofing');
    final navigation = ProcurementNavigation(
      explore: explore,
      cart: cart,
      repository: repository,
      openStoreProfile: (_, _) {},
    );
    return (explore, cart, navigation, repository);
  }

  Future<void> capture(
    WidgetTester tester,
    String name,
    Widget page,
    Size size, {
    double scale = 1,
    Future<void> Function()? act,
  }) async {
    await tester.binding.setSurfaceSize(size);
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
    if (act != null) await act();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('../../../docs/design/evidence/phase-7/$name.png'),
    );
  }

  testWidgets('explore dashboard at 390 px', (tester) async {
    final (explore, cart, navigation, _) = await setup();
    await capture(
      tester,
      '390-explore-dashboard',
      ExploreScreen(
        controller: explore,
        cart: cart,
        navigation: navigation,
        onOpenMap: () {},
      ),
      const Size(390, 844),
    );
  });

  testWidgets('explore dashboard at 320 px with 2x text', (tester) async {
    final (explore, cart, navigation, _) = await setup();
    await capture(
      tester,
      '320-explore-2x-text',
      ExploreScreen(
        controller: explore,
        cart: cart,
        navigation: navigation,
        onOpenMap: () {},
      ),
      const Size(320, 700),
      scale: 2,
    );
  });

  testWidgets('search results with the ranking explanation open', (
    tester,
  ) async {
    final (explore, _, navigation, _) = await setup();
    await capture(
      tester,
      '390-search-ranking-explained',
      SearchResultsScreen(controller: explore, navigation: navigation),
      const Size(390, 1100),
      act: () async {
        await tester.tap(find.textContaining('Why this ranking').first);
      },
    );
  });

  testWidgets('search results in landscape', (tester) async {
    final (explore, _, navigation, _) = await setup();
    await capture(
      tester,
      '844x390-search-landscape',
      SearchResultsScreen(controller: explore, navigation: navigation),
      const Size(844, 390),
    );
  });

  testWidgets('product details', (tester) async {
    final (explore, cart, navigation, repository) = await setup();
    await capture(
      tester,
      '390-product-details',
      ProductDetailsScreen(
        listingId: 'listing-1',
        repository: repository,
        explore: explore,
        cart: cart,
        navigation: navigation,
      ),
      const Size(390, 1300),
    );
  });

  testWidgets('ranking preferences with a live total', (tester) async {
    final (_, _, _, repository) = await setup();
    await capture(
      tester,
      '390-ranking-preferences',
      RankingPreferencesScreen(repository: repository),
      const Size(390, 1300),
      act: () async {
        await tester.tap(find.byTooltip('Increase Distance'));
      },
    );
  });

  testWidgets('cart with a stale price on one Vendor group', (tester) async {
    final (_, cart, navigation, _) = await setup();
    await capture(
      tester,
      '390-cart-stale-group',
      CartScreen(controller: cart, navigation: navigation),
      const Size(390, 1200),
    );
  });

  testWidgets(
    'checkout preview with alternate drop-off and advisory delivery',
    (tester) async {
      final (_, cart, _, _) = await setup();
      await capture(
        tester,
        '390-checkout-advisory-delivery',
        CheckoutPreviewScreen(
          controller: cart,
          savedLocations: () => const [primaryLocation, gate],
        ),
        const Size(390, 2200),
      );
    },
  );

  testWidgets('checkout preview with a blocked route', (tester) async {
    final (_, cart, _, repository) = await setup();
    repository.preview = previewFixture(deliveryStatus: 'BLOCKED');
    await capture(
      tester,
      '390-checkout-blocked-route',
      CheckoutPreviewScreen(
        controller: cart,
        savedLocations: () => const [primaryLocation, gate],
      ),
      const Size(390, 2200),
    );
  });
}
