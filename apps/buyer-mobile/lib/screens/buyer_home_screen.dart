import '../features/messaging/messaging_repository.dart';
import 'dart:async';
import '../features/notifications/notifications_repository.dart';
import '../features/notifications/notifications_screen.dart';
import '../features/notifications/buyer_push.dart';
import '../features/notifications/notification_scope.dart';
import '../features/disputes/dispute_screens.dart';
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
import '../features/trust/analytics_repository.dart';
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
    this.analyticsRepository,
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
  final AnalyticsRepository? analyticsRepository;
  final DeviceLocationService deviceLocation;
  final SupplierMapBuilder mapBuilder;

  @override
  State<BuyerHomeScreen> createState() => _BuyerHomeScreenState();
}

class _BuyerHomeScreenState extends State<BuyerHomeScreen> {
  NotificationsRepository? _notifications;
  void Function()? _detachNotificationExpiry;
  BuyerPush? _push;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final repository = NotificationScope.of(context);
    if (repository == _notifications) return;
    _detachNotificationExpiry?.call();
    _push?.dispose();
    _notifications = repository;
    _detachNotificationExpiry = repository?.attachSessionExpiry(_expireSession);
    _push = repository == null
        ? null
        : BuyerPush(repository, (id) => _openNotifications(id));
    unawaited(_push?.start().catchError((Object _) {}));
  }

  void _openNotifications([String? notice]) {
    if (_notifications == null) return;
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => NotificationsScreen(
          repository: _notifications!,
          initialNotice: notice,
          enablePush: BuyerPush.enabled ? _push?.enable : null,
          open: _openNoticeTarget,
        ),
      ),
    );
  }

  Future<void> _openNoticeTarget(String path) async {
    final segments = Uri.parse(path).pathSegments;
    Widget? destination;
    if (segments.length == 2 && segments[0] == 'orders' && _orders != null) {
      destination = OrderDetailsScreen(
        orderId: segments[1],
        repository: _orders,
        openConversation: _messaging == null ? null : _openConversation,
      );
    } else if (segments.length == 2 &&
        segments[0] == 'disputes' &&
        _orders != null) {
      destination = DisputeDetailScreen(
        caseId: segments[1],
        repository: _orders.disputes,
      );
    } else if (segments.length == 2 &&
        segments[0] == 'projects' &&
        _projects != null &&
        _discovery != null) {
      destination = ProjectsScreen(
        repository: _projects,
        discovery: _discovery,
        initialProjectId: segments[1],
        deviceLocation: widget.deviceLocation,
        mapBuilder: widget.mapBuilder,
        openConversation: _openConversation,
        openOrder: (context, id) {
          unawaited(_openNoticeTarget('/orders/$id'));
        },
        openStore: _openStore,
        openAnalysis: _projectAnalysis,
      );
    } else if (path == '/settings') {
      Navigator.of(context).popUntil((route) => route.isFirst);
      _select(4);
      return;
    }
    if (destination == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'This resource is unavailable or your permission has changed.',
            ),
          ),
        );
      }
      return;
    }
    if (mounted) {
      await Navigator.of(
        context,
      ).push<void>(MaterialPageRoute(builder: (_) => destination!));
    }
  }

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
          discovery: _discovery,
          analytics: _analytics,
          deviceLocation: widget.deviceLocation,
          onOpenMap: () => _select(0),
        );
  late final AnalyticsRepository? _analytics =
      widget.analyticsRepository ??
      (widget.repository == null
          ? null
          : ApiAnalyticsRepository(
              client: widget.repository!.apiClient,
              onSessionExpired: _expireSession,
            ));
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
  final Set<int> _visitedDestinations = {};
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
      analytics: _analytics,
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
                  'Browse current listings and Materials Analytics for this Project site. The site is used only for this view and does not replace your saved locations.',
                ),
              ),
              Expanded(
                child: ExploreScreen(
                  controller: explore,
                  cart: _cart,
                  navigation: navigation,
                  onOpenMap: () => Navigator.pop(context),
                  onOpenNotifications: _openNotifications,
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
    _detachNotificationExpiry?.call();
    _push?.dispose();
    _explore?.dispose();
    _cart?.dispose();
    _discoveryController?.dispose();
    super.dispose();
  }

  Future<void> _expireSession() async {
    _notifications?.inbox.setActive(false, clear: true);
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
            onMessage: _navigation == null
                ? null
                : () => _navigation.openMessage(context, storeId, null),
            onBrowseProducts: _navigation == null
                ? null
                : (context, id, name) => _navigation.browseStore(
                    context,
                    vendorId: id,
                    vendorName: name,
                  ),
            loadProducts: _navigation == null
                ? null
                : (sort, cursor) =>
                      _navigation.storeListings(storeId, sort, cursor),
            onOpenListing: _navigation == null
                ? null
                : (context, listingId) =>
                      _navigation.openListing(context, listingId),
          ),
        ),
      );

  void _select(int index) {
    if (_destination == index) return;
    _visitedDestinations.add(index);
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
                      onUnavailable: (title) => title == 'Notifications'
                          ? _openNotifications()
                          : _unavailable(title),
                      onOpenSearch: navigation == null
                          ? null
                          : () => navigation.openSearch(context),
                      onOpenCart: navigation == null
                          ? null
                          : () => navigation.openCart(context),
                      onMessageStore: navigation == null
                          ? null
                          : (context, supplier) => navigation.openMessage(
                              context,
                              supplier.resultId,
                              null,
                            ),
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
          for (final index in [1, 3, 4])
            if (_visitedDestinations.contains(index))
              Offstage(
                key: ValueKey('buyer-destination-$index'),
                offstage: _destination != index,
                child: TickerMode(
                  enabled: _destination == index,
                  child: _destinationPage(index),
                ),
              ),
        ],
      ),
      bottomNavigationBar: _navigationBar(),
    );
  }

  Future<void> _openConversation(BuildContext context, String id) =>
      Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (_) => MessagingScreen(
            repository: _messaging!,
            conversationId: id,
            onOpenProduct: _navigation == null
                ? null
                : (id) => _navigation.openListing(context, id),
            orders: _orders,
            onOpenCart: _navigation == null
                ? null
                : () => _navigation.openCart(context),
            onOpenNotifications: _openNotifications,
          ),
        ),
      );

  Widget _projectsPage() {
    if (_projects != null && _discovery != null) {
      return ProjectsScreen(
        active: _destination == 2,
        repository: _projects,
        discovery: _discovery,
        deviceLocation: widget.deviceLocation,
        mapBuilder: widget.mapBuilder,
        openConversation: _openConversation,
        openOrder: (context, id) => Navigator.of(context).push<void>(
          MaterialPageRoute(
            builder: (_) => OrderDetailsScreen(
              orderId: id,
              repository: _orders!,
              openConversation: _messaging == null ? null : _openConversation,
            ),
          ),
        ),
        openStore: _openStore,
        openAnalysis: _projectAnalysis,
      );
    }
    return const SafeArea(child: BuyerUnavailableContent());
  }

  Widget _destinationPage(int index) {
    if (index == 3 && _messaging != null) {
      return MessagingScreen(
        active: _destination == index,
        repository: _messaging,
        onSetDelivery: _navigation == null
            ? null
            : (id, version) =>
                  _navigation.setChatDelivery(context, id, version),
        onOpenProduct: _navigation == null
            ? null
            : (id) => _navigation.openListing(context, id),
        orders: _orders,
        onOpenCart: _navigation == null
            ? null
            : () => _navigation.openCart(context),
        onOpenNotifications: _openNotifications,
      );
    }
    if (index == 4 && widget.repository != null) {
      return BuyerProfileScreen(
        active: _destination == index,
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
                  builder: (_) => OrdersScreen(
                    repository: _orders,
                    openConversation: _messaging == null
                        ? null
                        : _openConversation,
                  ),
                ),
              ),
        onOpenCart: _navigation == null
            ? null
            : () => _navigation.openCart(context),
        onOpenSearch: _navigation == null
            ? null
            : () => _navigation.openSearch(context),
        onOpenNotifications: _openNotifications,
        onRankingPreferences: _navigation == null
            ? null
            : () => _navigation.openPreferences(context),
        deviceLocation: widget.deviceLocation,
        onSignedOut: _sessionEnded,
        onSignOut: () async {
          try {
            await _push?.revoke();
          } catch (_) {}
          await _resultStore.clear();
          await widget.onSignOut();
        },
      );
    }
    if (index == 1) {
      final explore = _explore;
      final cart = _cart;
      final navigation = _navigation;
      if (explore != null && cart != null && navigation != null) {
        return ExploreScreen(
          controller: explore,
          cart: cart,
          navigation: navigation,
          onOpenMap: () => _select(0),
          onOpenNotifications: _openNotifications,
        );
      }
      return Scaffold(
        appBar: buyerAppBar(context, 'Explore stores'),
        body: const BuyerStoreBrowseScreen(),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buyerAppBar(context, _labels[index]),
      body: SafeArea(
        child: BuyerUnavailableContent(
          artwork: index == 3 ? 'inbox' : 'not-implemented',
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
