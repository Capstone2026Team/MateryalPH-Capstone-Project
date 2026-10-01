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
    String variantId,
  ) async {
    final repository = messaging;
    if (repository == null) return;
    var restriction = 'UNANSWERED';
    String? alternate;
    final instructions = TextEditingController();
    if (explore.origin?.locationId != null) {
      final proceed = await showDialog<bool>(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, update) => AlertDialog(
            title: const Text('Delivery access for this inquiry'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'If you request delivery, are heavy vehicles restricted at your selected location?',
                  ),
                  DropdownButtonFormField<String>(
                    initialValue: restriction,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                        value: 'UNANSWERED',
                        child: Text('Pickup / decide later'),
                      ),
                      DropdownMenuItem(
                        value: 'NO',
                        child: Text('No restriction'),
                      ),
                      DropdownMenuItem(
                        value: 'YES',
                        child: Text('Heavy vehicles restricted'),
                      ),
                    ],
                    onChanged: (value) => update(() => restriction = value!),
                  ),
                  if (restriction == 'YES') ...[
                    DropdownButtonFormField<String>(
                      initialValue: alternate,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Alternative vehicle drop-off',
                      ),
                      items: [
                        for (final location in explore.savedLocations.where(
                          (l) => l.id != explore.origin?.locationId,
                        ))
                          DropdownMenuItem(
                            value: location.id,
                            child: Text(
                              location.label,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                      onChanged: (value) => update(() => alternate = value),
                    ),
                    TextField(
                      controller: instructions,
                      maxLength: 500,
                      decoration: const InputDecoration(
                        labelText: 'Access and unloading instructions',
                      ),
                      onChanged: (_) => update(() {}),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed:
                    restriction == 'YES' &&
                        (alternate == null ||
                            instructions.text.trim().length < 5)
                    ? null
                    : () => Navigator.pop(context, true),
                child: const Text('Open conversation'),
              ),
            ],
          ),
        ),
      );
      if (proceed != true || !context.mounted) {
        instructions.dispose();
        return;
      }
    }
    try {
      final id = await repository.create(
        vendorId,
        variantId,
        newIdempotencyKey(),
        locationId: explore.origin?.locationId,
        heavyVehicleRestriction: restriction,
        alternateDropOffLocationId: restriction == 'YES' ? alternate : null,
        accessInstructions: restriction == 'YES'
            ? instructions.text.trim()
            : null,
      );
      if (context.mounted) {
        await _push(
          context,
          MessagingScreen(
            repository: repository,
            conversationId: id,
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
    } finally {
      instructions.dispose();
    }
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
