import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:materyalph/design_system/theme.dart';
import 'package:materyalph/features/item_procurement/cart_controller.dart';
import 'package:materyalph/features/item_procurement/cart_screen.dart';
import 'package:materyalph/features/item_procurement/checkout_preview_screen.dart';
import 'package:materyalph/features/item_procurement/explore_controller.dart';
import 'package:materyalph/features/item_procurement/explore_screen.dart';
import 'package:materyalph/features/item_procurement/material_search_screen.dart';
import 'package:materyalph/features/item_procurement/procurement_navigation.dart';
import 'package:materyalph/features/item_procurement/product_details_screen.dart';
import 'package:materyalph/features/item_procurement/product_finalization_sheet.dart';
import 'package:materyalph/features/item_procurement/ranking_preferences_screen.dart';
import 'package:materyalph/features/item_procurement/search_results_screen.dart';
import 'package:materyalph/features/map_discovery/discovery_controller.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';

import 'item_procurement_fakes.dart';
import 'map_discovery_fakes.dart';

void main() {
  testWidgets('capture enhanced Phase 7 using labeled fixture data', (
    tester,
  ) async {
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
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final repository = FakeProcurementRepository()..detail = listingDetail();
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
    await explore.loadSummary();
    await explore.search(query: 'Roofing');
    await cart.load();
    final navigation = ProcurementNavigation(
      explore: explore,
      cart: cart,
      repository: repository,
      openStoreProfile: (_, _) {},
    );
    final detail = repository.detail!;
    final pages = <String, Widget>{
      'explore': ExploreScreen(
        controller: explore,
        cart: cart,
        navigation: navigation,
        onOpenMap: () {},
      ),
      'catalog': SearchResultsScreen(
        controller: explore,
        navigation: navigation,
      ),
      'details': ProductDetailsScreen(
        listingId: detail.listingId,
        repository: repository,
        explore: explore,
        cart: cart,
        navigation: navigation,
      ),
      'finalization': Scaffold(
        body: ProductFinalizationSheet(
          detail: () => detail,
          variantId: detail.variants.first.variantId,
          quantity: 1,
          fulfillment: 'PICKUP',
          buy: false,
          onConfirm: (_, _, _) async => null,
        ),
      ),
      'cart': CartScreen(controller: cart, navigation: navigation),
      'checkout': CheckoutPreviewScreen(
        controller: cart,
        savedLocations: () => [primaryLocation],
      ),
      'ranking': RankingPreferencesScreen(repository: repository),
      'search': MaterialSearchScreen(controller: explore),
    };
    for (final entry in pages.entries) {
      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: BuyerTheme.light,
          home: entry.value,
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile(
          '../../../docs/design/evidence/phase-7-enhancement/390-${entry.key}.png',
        ),
      );
    }
    await tester.pumpWidget(const SizedBox.shrink());
    explore.dispose();
    cart.dispose();
    discovery.dispose();
  }, skip: !const bool.fromEnvironment('CAPTURE_PHASE7'));
}
