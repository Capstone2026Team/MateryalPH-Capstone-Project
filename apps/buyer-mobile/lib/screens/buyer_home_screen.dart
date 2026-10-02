import '../features/messaging/messaging_repository.dart';
import '../features/messaging/messaging_screen.dart';
import 'package:flutter/material.dart';
import '../design_system/components/buyer_app_bar.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../auth/auth_repository.dart';
import '../design_system/theme.dart';
import '../features/item_procurement/cart_controller.dart';
import '../features/item_procurement/explore_controller.dart';
import '../features/item_procurement/explore_screen.dart';
import '../features/item_procurement/procurement_navigation.dart';
import '../features/item_procurement/procurement_repository.dart';
import '../features/map_discovery/device_location.dart';
import '../features/orders/orders_repository.dart';
import '../features/orders/orders_screen.dart';
import '../features/orders/order_details_screen.dart';
import '../features/projects/projects_repository.dart';
import '../features/projects/projects_screen.dart';
import '../features/map_discovery/discovery_models.dart';
import '../features/map_discovery/discovery_controller.dart';
import '../features/map_discovery/discovery_repository.dart';
import '../features/map_discovery/discovery_result_cache.dart';
import '../features/map_discovery/map_home_screen.dart';
import '../features/map_discovery/supplier_map.dart';
import '../widgets/buyer_account_widgets.dart';
import 'buyer_profile_screen.dart';
import 'buyer_store_browse_screen.dart';

/// The five-destination Buyer shell. Map is the default authenticated destination and stays
/// mounted while another tab is open, so the selected location, radius and selection survive.
/// Map and Explore share one DiscoveryController: Explore always uses the Map's origin and radius.
class BuyerHomeScreen extends StatefulWidget {
  const BuyerHomeScreen({
    super.key,
    required this.onSignOut,
    this.repository,
    this.onSessionEnded,
    this.discoveryRepository,
    this.procurementRepository,
    this.ordersRepository,
    this.messagingRepository,
    this.deviceLocation = const GeolocatorDeviceLocationService(),
    this.mapBuilder = defaultSupplierMapBuilder,
    this.resultStore,
  });

  /// Where completed map searches are kept between launches; the on-disk store when omitted.
  final DiscoveryResultStore? resultStore;
  final Future<void> Function() onSignOut;
  final AuthRepository? repository;
  final VoidCallback? onSessionEnded;
  final DiscoveryRepository? discoveryRepository;
  final ProcurementRepository? procurementRepository;
  final OrdersRepository? ordersRepository;
  final MessagingRepository? messagingRepository;
  final DeviceLocationService deviceLocation;
  final SupplierMapBuilder mapBuilder;

  @override
  State<BuyerHomeScreen> createState() => _BuyerHomeScreenState();
}

class _BuyerHomeScreenState extends State<BuyerHomeScreen> {
  static const _labels = ['Map', 'Explore', 'Projects', 'Messages', 'Profile'];
  int _destination = 0;
  late final DiscoveryRepository? _discovery =
      widget.discoveryRepository ??
      (widget.repository == null
          ? null
          : ApiDiscoveryRepository(
              client: widget.repository!.apiClient,
              onSessionExpired: _expireSession,
            ));
  late final ProcurementRepository? _procurement =
      widget.procurementRepository ??
      (widget.repository == null
          ? null
          : ApiProcurementRepository(
              client: widget.repository!.apiClient,
              onSessionExpired: _expireSession,
            ));
  late final OrdersRepository? _orders =
      widget.ordersRepository ??
      (widget.repository == null
          ? null
          : ApiOrdersRepository(
              client: widget.repository!.apiClient,
              onSessionExpired: _expireSession,
            ));
  /// Completed searches for saved locations, kept on disk so the Map opens instantly. Removed on
  /// sign-out and session expiry because the lists carry this Buyer's favorites.
  late final DiscoveryResultStore _resultStore =
      widget.resultStore ?? FileDiscoveryResultStore();
  late final DiscoveryController? _discoveryController = _discovery == null
      ? null
      : DiscoveryController(repository: _discovery, store: _resultStore);
  late final ExploreController? _explore =
      _procurement == null || _discoveryController == null
      ? null
      : ExploreController(
          repository: _procurement,
          discovery: _discoveryController,
        );
  late final CartController? _cart = _procurement == null
      ? null
      : CartController(repository: _procurement);
  late final ProcurementNavigation? _navigation =
      _explore == null || _cart == null
      ? null
      : ProcurementNavigation(
          explore: _explore,
          cart: _cart,
          repository: _procurement!,
          openStoreProfile: _openStore,
          messaging: _messaging,
          orders: _orders,
          onOpenMap: () => _select(0),
        );
  late final MessagingRepository? _messaging =
      widget.messagingRepository ??
      (widget.repository == null
          ? null
          : ApiMessagingRepository(
              client: widget.repository!.apiClient,
              onSessionExpired: _expireSession,
            ));
  bool _cartLoaded = false;
  bool _projectsVisited = false;
  late final ProjectsRepository? _projects = widget.repository == null
      ? null
      : ProjectsRepository(
          client: widget.repository!.apiClient,
          onSessionExpired: _expireSession,
        );

  Future<void> _projectAnalysis(BuildContext context, ProjectData site) async {
    final point = projectObject(site['point']);
    final discovery = DiscoveryController(repository: _discovery!);
    await discovery.setOrigin(
      DiscoveryOrigin.point(
        point: GeoPoint(
          double.parse(projectText(point['latitude'])),
          double.parse(projectText(point['longitude'])),
        ),
        source: OriginSource.savedLocation,
        label: projectText(site['name']),
      ),
    );
    if (!context.mounted) {
      discovery.dispose();
      return;
    }
    final explore = ExploreController(
      repository: _procurement!,
      discovery: discovery,
    );
    final navigation = ProcurementNavigation(
      explore: explore,
      cart: _cart!,
      repository: _procurement,
      openStoreProfile: _openStore,
      messaging: _messaging,
      orders: _orders,
      onOpenMap: () {},
    );
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: buyerAppBar(context, 'Market analysis · ${site['name']}'),
          body: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Browse current listings for this selected Project site. Historical Materials Analytics becomes available in Phase 14.',
                ),
              ),
              Expanded(
                child: ExploreScreen(
                  controller: explore,
                  cart: _cart,
                  navigation: navigation,
                  onOpenMap: () => Navigator.pop(context),
                  onOpenNotifications: () => _unavailable('Notifications'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    explore.dispose();
    discovery.dispose();
  }

  @override
  void dispose() {
    _explore?.dispose();
    _cart?.dispose();
    _discoveryController?.dispose();
    super.dispose();
  }

  Future<void> _expireSession() async {
    await _resultStore.clear();
    await widget.repository?.clearAccountSession();
    if (mounted) _sessionEnded();
  }

  void _sessionEnded() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    widget.onSessionEnded?.call();
  }

  /// The one placeholder destination for features that are not built yet, so every entry point to
  /// the same feature (for example the bell on each tab) opens the same page.
  void _unavailable(String title) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => BuyerUnavailableScreen(
        title: title,
        artwork: title == 'Notifications' ? 'notifications' : 'not-implemented',
      ),
    ),
  );

  void _openStore(BuildContext context, String storeId) =>
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => BuyerPublicStoreProfileScreen(
            storeId: storeId,
            repository: BuyerStoreRepository(),
            onBrowseProducts: _navigation == null
                ? null
                : (context, id, name) => _navigation.browseStore(
                    context,
                    vendorId: id,
                    vendorName: name,
                  ),
          ),
        ),
      );

  void _select(int index) {
    if (index == 2) _projectsVisited = true;
    if (index == 1 && !_cartLoaded) {
      _cartLoaded = true;
      _cart?.load();
    }
    setState(() => _destination = index);
  }

  @override
  Widget build(BuildContext context) {
    final discovery = _discovery;
    final navigation = _navigation;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        // Expand so a destination still fills the body while the Map stays mounted offstage.
        fit: StackFit.expand,
        children: [
          Offstage(
            offstage: _destination != 0,
            child: TickerMode(
              enabled: _destination == 0,
              child: discovery == null
                  ? const SafeArea(child: BuyerUnavailableContent())
                  : MapHomeScreen(
                      repository: discovery,
                      controller: _discoveryController,
                      deviceLocation: widget.deviceLocation,
                      mapBuilder: widget.mapBuilder,
                      onUnavailable: _unavailable,
                      onOpenSearch: navigation == null
                          ? null
                          : () => navigation.openSearch(context),
                      onOpenCart: navigation == null
                          ? null
                          : () => navigation.openCart(context),
                      onMessageStore: navigation == null
                          ? null
                          : (context, supplier) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Choose a product to start a conversation with this store.',
                                  ),
                                ),
                              );
                              navigation.browseStore(
                                context,
                                vendorId: supplier.resultId,
                                vendorName: supplier.name,
                              );
                            },
                      onOpenStore: (context, supplier) =>
                          _openStore(context, supplier.resultId),
                    ),
            ),
          ),
          if (_projectsVisited)
            Offstage(
              offstage: _destination != 2,
              child: TickerMode(
                enabled: _destination == 2,
                child: _projectsPage(),
              ),
            ),
          if (_destination != 0 && _destination != 2)
            Positioned.fill(child: _destinationPage()),
        ],
      ),
      bottomNavigationBar: _navigationBar(),
    );
  }

  Widget _projectsPage() {
    if (_projects != null && _discovery != null) {
      return ProjectsScreen(
        active: _destination == 2,
        repository: _projects,
        discovery: _discovery,
        deviceLocation: widget.deviceLocation,
        mapBuilder: widget.mapBuilder,
        openConversation: (context, id) => Navigator.of(context).push<void>(
          MaterialPageRoute(
            builder: (_) => MessagingScreen(
              repository: _messaging!,
              conversationId: id,
              orders: _orders,
              onOpenCart: _navigation == null
                  ? null
                  : () => _navigation.openCart(context),
              onOpenNotifications: () => _unavailable('Notifications'),
            ),
          ),
        ),
        openOrder: (context, id) => Navigator.of(context).push<void>(
          MaterialPageRoute(
            builder: (_) =>
                OrderDetailsScreen(orderId: id, repository: _orders!),
          ),
        ),
        openStore: _openStore,
        openAnalysis: _projectAnalysis,
      );
    }
    return const SafeArea(child: BuyerUnavailableContent());
  }

  Widget _destinationPage() {
    if (_destination == 3 && _messaging != null) {
      return MessagingScreen(
        repository: _messaging,
        orders: _orders,
        onOpenCart: _navigation == null
            ? null
            : () => _navigation.openCart(context),
        onOpenNotifications: () => _unavailable('Notifications'),
      );
    }
    if (_destination == 4 && widget.repository != null) {
      return BuyerProfileScreen(
        repository: widget.repository!,
        discoveryRepository: _discovery,
        onRemoveFavorite: _discoveryController == null
            ? null
            : (vendorId) =>
                  _discoveryController.setFavorite(vendorId, favorite: false),
        onOpenOrders: _orders == null
            ? null
            : () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => OrdersScreen(repository: _orders),
                ),
              ),
        onOpenCart: _navigation == null
            ? null
            : () => _navigation.openCart(context),
        onOpenSearch: _navigation == null
            ? null
            : () => _navigation.openSearch(context),
        onOpenNotifications: () => _unavailable('Notifications'),
        onRankingPreferences: _navigation == null
            ? null
            : () => _navigation.openPreferences(context),
        deviceLocation: widget.deviceLocation,
        onSignedOut: _sessionEnded,
        onSignOut: () async {
          await _resultStore.clear();
          await widget.onSignOut();
        },
      );
    }
    if (_destination == 1) {
      final explore = _explore;
      final cart = _cart;
      final navigation = _navigation;
      if (explore != null && cart != null && navigation != null) {
        return ExploreScreen(
          controller: explore,
          cart: cart,
          navigation: navigation,
          onOpenMap: () => _select(0),
          onOpenNotifications: () => _unavailable('Notifications'),
        );
      }
      return Scaffold(
        appBar: buyerAppBar(context, 'Explore stores'),
        body: const BuyerStoreBrowseScreen(),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buyerAppBar(context, _labels[_destination]),
      body: SafeArea(
        child: BuyerUnavailableContent(
          artwork: _destination == 3 ? 'inbox' : 'not-implemented',
        ),
      ),
    );
  }

  Widget _navigationBar() {
    const icons = [
      LucideIcons.compass,
      LucideIcons.layoutGrid,
      LucideIcons.clipboardList,
      LucideIcons.messageCircle,
      LucideIcons.user,
    ];
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: BuyerTheme.border)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var index = 0; index < _labels.length; index++)
              Expanded(
                child: Semantics(
                  selected: index == _destination,
                  onTap: () => _select(index),
                  button: true,
                  label: _labels[index],
                  child: ExcludeSemantics(
                    child: InkWell(
                      onTap: () => _select(index),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 76),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 3,
                              width: 28,
                              color: index == _destination
                                  ? BuyerTheme.action
                                  : Colors.transparent,
                            ),
                            const SizedBox(height: 12),
                            Icon(
                              icons[index],
                              size: 24,
                              color: index == _destination
                                  ? BuyerTheme.action
                                  : BuyerTheme.muted,
                            ),
                            const SizedBox(height: 6),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(2, 0, 2, 10),
                              child: Text(
                                _labels[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: index == _destination
                                      ? BuyerTheme.action
                                      : BuyerTheme.muted,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
