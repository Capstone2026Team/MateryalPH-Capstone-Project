import '../messaging/chat_delivery_dialog.dart';
import '../messaging/messaging_repository.dart';
import '../messaging/messaging_screen.dart';
import '../map_discovery/discovery_repository.dart' show newIdempotencyKey;
import 'package:flutter/material.dart';

import '../orders/orders_repository.dart';
import 'cart_controller.dart';
import 'cart_screen.dart';
import 'checkout_preview_screen.dart';
import 'explore_controller.dart';
import 'procurement_models.dart';
import 'procurement_repository.dart';
import 'product_details_screen.dart';
import 'ranking_preferences_screen.dart';
import 'search_results_screen.dart';
import 'material_search_screen.dart';

/// One place that opens the Item-Based pages with the shared controllers, so Search Results,
/// Product Details, Cart and Checkout always see the same origin, radius, filters and cart.
class ProcurementNavigation {
  ProcurementNavigation({
    required this.explore,
    required this.cart,
    required this.repository,
    required this.openStoreProfile,
    this.onOpenMap,
    this.orders,
    this.messaging,
  });

  final ExploreController explore;
  final CartController cart;
  final ProcurementRepository repository;
  final VoidCallback? onOpenMap;

  /// Order submission from Checkout; absent in contexts that only preview.
  final OrdersRepository? orders;
  final MessagingRepository? messaging;
  Future<void> openMessage(
    BuildContext context,
    String vendorId,
    String? variantId,
  ) async {
    final repository = messaging;
    if (repository == null) return;
    try {
      final id = await repository.create(
        vendorId,
        variantId,
        newIdempotencyKey(),
      );
      if (context.mounted) {
        await _push(
          context,
          MessagingScreen(
            repository: repository,
            conversationId: id,
            initialProductId: variantId,
            onSetDelivery: (id, version) =>
                setChatDelivery(context, id, version),
            onOpenProduct: (listingId) => openListing(context, listingId),
            orders: orders,
            onOpenCart: () => openCart(context),
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to open the conversation. Please retry.'),
          ),
        );
      }
    }
  }

  Future<void> setChatDelivery(
    BuildContext context,
    String id,
    int version,
  ) async {
    if (messaging == null) return;
    await showChatDeliveryDialog(
      context,
      repository: messaging!,
      conversationId: id,
      lockVersion: version,
      locations: explore.savedLocations,
      initialLocation: explore.origin?.locationId,
    );
  }

  void openLocation(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    onOpenMap?.call();
  }

  /// Opens the public Store Profile (saved hours, store details) for a Verified Vendor.
  final void Function(BuildContext context, String vendorId) openStoreProfile;

  Future<void> _push(BuildContext context, Widget page) =>
      Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));

  Future<void> openResults(BuildContext context) => _push(
    context,
    SearchResultsScreen(controller: explore, navigation: this),
  );

  Future<void> openSearch(
    BuildContext context, {
    bool fromResults = false,
  }) async {
    final query = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => MaterialSearchScreen(
          controller: explore,
          filters: fromResults ? explore.filters : const ListingFilters(),
          onSetLocation: () => openLocation(context),
        ),
      ),
    );
    if (query == null || !context.mounted) return;
    explore.search(
      query: query,
      filters: fromResults ? null : const ListingFilters(),
      sort: () => null,
    );
    if (!fromResults) await openResults(context);
  }

  Future<void> openListing(BuildContext context, String listingId) => _push(
    context,
    ProductDetailsScreen(
      listingId: listingId,
      repository: repository,
      explore: explore,
      cart: cart,
      navigation: this,
    ),
  );

  Future<void> openCart(BuildContext context) {
    cart.load();
    return _push(context, CartScreen(controller: cart, navigation: this));
  }

  Future<void> openCheckout(BuildContext context) => _push(
    context,
    CheckoutPreviewScreen(
      controller: cart,
      savedLocations: () => explore.savedLocations,
      orders: orders,
    ),
  );

  Future<void> openPreferences(BuildContext context) async {
    var changed = false;
    await _push(
      context,
      RankingPreferencesScreen(
        repository: repository,
        onChanged: () => changed = true,
      ),
    );
    // Saved weights re-rank the current Best Deal results.
    if (changed &&
        explore.searchActive &&
        (explore.effectiveSort == ListingSort.bestDeal ||
            explore.effectiveSort == ListingSort.favoritesFirst)) {
      await explore.retrySearch();
    }
  }

  Future<void> browseStore(
    BuildContext context, {
    required String vendorId,
    required String vendorName,
  }) {
    explore.search(
      query: '',
      filters: ListingFilters(vendorId: vendorId, vendorName: vendorName),
      sort: () => null,
    );
    return openResults(context);
  }
}
