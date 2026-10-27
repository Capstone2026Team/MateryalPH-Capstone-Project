import '../messaging/chat_delivery_dialog.dart';
import '../messaging/messaging_repository.dart';
import '../messaging/messaging_screen.dart';
import '../map_discovery/device_location.dart';
import '../map_discovery/discovery_models.dart';
import '../map_discovery/discovery_repository.dart'
    show DiscoveryRepository, newIdempotencyKey;
import '../map_discovery/select_location_screen.dart';
import '../map_discovery/supplier_map.dart' show kMapsClientConfigured;
import 'package:flutter/material.dart';

import '../../design_system/components/buyer_overlays.dart';
import '../orders/orders_repository.dart';
import '../projects/projects_repository.dart';
import 'cart_controller.dart';
import 'cart_screen.dart';
import 'checkout_preview_screen.dart';
import 'explore_controller.dart';
import 'procurement_models.dart';
import 'procurement_repository.dart';
import 'product_details_screen.dart';
import 'ranking_preferences_screen.dart';
import 'search_results_screen.dart';
import 'site_inspection_sheet.dart';
import 'material_search_screen.dart';
import '../trust/analytics_repository.dart';
import '../trust/materials_analytics_screen.dart';

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
    this.projects,
    this.messaging,
    this.discovery,
    this.analytics,
    this.deviceLocation = const GeolocatorDeviceLocationService(),
  });

  /// Materials Analytics (Phase 14); absent where the entry point is not offered.
  final AnalyticsRepository? analytics;

  /// Explore → Materials Analytics, inheriting the Explore origin and exact radius.
  Future<void> openMaterialsAnalytics(
    BuildContext context, {
    String? originLabel,
  }) async {
    final repository = analytics;
    // Only the origin carries over; analytics always covers 50 km.
    final origin = explore.origin;
    if (repository == null || origin == null) return;
    await _push(
      context,
      MaterialsAnalyticsScreen(
        repository: repository,
        origin: origin,
        originLabel: originLabel,
        onOpenListing: openListing,
      ),
    );
  }

  /// Location lookup and saving for the Checkout drop-off; absent where only a preview is shown.
  final DiscoveryRepository? discovery;
  final DeviceLocationService deviceLocation;

  final ExploreController explore;
  final CartController cart;
  final ProcurementRepository repository;
  final VoidCallback? onOpenMap;

  /// Order submission from Checkout; absent in contexts that only preview.
  final OrdersRepository? orders;
  final ProjectsRepository? projects;
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
        await openConversation(context, id, productId: variantId);
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

  Future<void> openConversation(
    BuildContext context,
    String id, {
    String? productId,
  }) {
    final repository = messaging;
    if (repository == null) return Future.value();
    return _push(
      context,
      MessagingScreen(
        repository: repository,
        conversationId: id,
        initialProductId: productId,
        onSetDelivery: (id, version) => setChatDelivery(context, id, version),
        onOpenProduct: (listingId) => openListing(context, listingId),
        orders: orders,
        onOpenCart: () => openCart(context),
      ),
    );
  }

  /// Ready-mixed concrete: ask the store for a free site inspection when the
  /// volume is unknown, then follow it in the store conversation. Null when
  /// messaging is not available in this context.
  Future<void> Function(
    BuildContext context,
    ListingDetailView detail,
    String? variantId,
  )?
  get requestSiteInspection => messaging == null
      ? null
      : (context, detail, variantId) async {
          final repository = messaging!;
          final conversation = await showBuyerBottomSheet<String>(
            context: context,
            builder: (_) => SiteInspectionSheet(
              productName: detail.displayName,
              storeName: detail.vendorName,
              locations: explore.savedLocations,
              initialLocationId: explore.origin?.locationId,
              submit:
                  ({
                    required locationId,
                    required preferredDate,
                    required key,
                    notes,
                  }) => repository.requestSiteInspection(
                    listingId: detail.listingId,
                    variantId: variantId,
                    locationId: locationId,
                    preferredDate: preferredDate,
                    key: key,
                    notes: notes,
                  ),
            ),
          );
          if (conversation != null && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Inspection requested. The store replies in Messages.',
                ),
              ),
            );
            await openConversation(context, conversation);
          }
        };

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

  /// [variantId] opens Product Details on that variant (e.g. the one a Work
  /// Package quotation priced) while it is available.
  Future<void> openListing(
    BuildContext context,
    String listingId, {
    String? variantId,
  }) => _push(
    context,
    ProductDetailsScreen(
      listingId: listingId,
      initialVariantId: variantId,
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
      chooseDropOff: discovery == null ? null : chooseDropOff,
      projects: projects,
      openConversation: messaging == null ? null : openConversation,
    ),
  );

  /// Opens the location picker for the vehicle drop-off: either straight to the device location
  /// or to a searchable map pin. The chosen point is saved through the Buyer location API.
  Future<DiscoveryOrigin?> chooseDropOff(
    BuildContext context, {
    required bool useCurrent,
  }) => Navigator.of(context).push<DiscoveryOrigin>(
    MaterialPageRoute(
      builder: (_) => SelectLocationScreen(
        repository: discovery!,
        deviceLocation: deviceLocation,
        savedLocations: explore.savedLocations,
        mapsAvailable: kMapsClientConfigured,
        requireSave: true,
        autoUseCurrentLocation: useCurrent,
      ),
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

  /// One page of a single store's eligible listings for its Store Profile Products tab. The widest
  /// platform radius is used so the store's own catalog is not cut off by the Map radius; returns
  /// null while no origin is chosen, because distance and delivery need one.
  Future<ListingSearchPage?> storeListings(
    String vendorId,
    ListingSort sort,
    String? cursor,
  ) async {
    final origin = explore.origin;
    if (origin == null) return null;
    return repository.search(
      origin: origin,
      radiusKm: kDiscoveryRadiiKm.last,
      query: '',
      filters: ListingFilters(vendorId: vendorId),
      sort: sort,
      cursor: cursor,
    );
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
