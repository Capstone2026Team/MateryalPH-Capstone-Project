import 'package:flutter/material.dart';

import 'cart_controller.dart';
import 'cart_screen.dart';
import 'checkout_preview_screen.dart';
import 'explore_controller.dart';
import 'procurement_models.dart';
import 'procurement_repository.dart';
import 'product_details_screen.dart';
import 'ranking_preferences_screen.dart';
import 'search_results_screen.dart';

/// One place that opens the Item-Based pages with the shared controllers, so Search Results,
/// Product Details, Cart and Checkout always see the same origin, radius, filters and cart.
class ProcurementNavigation {
  ProcurementNavigation({
    required this.explore,
    required this.cart,
    required this.repository,
    required this.openStoreProfile,
  });

  final ExploreController explore;
  final CartController cart;
  final ProcurementRepository repository;

  /// Opens the public Store Profile (saved hours, store details) for a Verified Vendor.
  final void Function(BuildContext context, String vendorId) openStoreProfile;

  Future<void> _push(BuildContext context, Widget page) =>
      Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));

  Future<void> openResults(BuildContext context) => _push(
    context,
    SearchResultsScreen(controller: explore, navigation: this),
  );

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
    ),
  );

  Future<void> openPreferences(BuildContext context) async {
    await _push(context, RankingPreferencesScreen(repository: repository));
    // Saved weights re-rank the current Best Deal results.
    if (explore.searchActive) await explore.retrySearch();
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
