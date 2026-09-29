import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../auth/auth_repository.dart';
import '../design_system/theme.dart';
import '../features/item_procurement/cart_controller.dart';
import '../features/item_procurement/explore_controller.dart';
import '../features/item_procurement/explore_screen.dart';
import '../features/item_procurement/procurement_navigation.dart';
import '../features/item_procurement/procurement_repository.dart';
import '../features/map_discovery/device_location.dart';
import '../features/map_discovery/discovery_controller.dart';
import '../features/map_discovery/discovery_repository.dart';
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
    this.deviceLocation = const GeolocatorDeviceLocationService(),
    this.mapBuilder = defaultSupplierMapBuilder,
  });

  final Future<void> Function() onSignOut;
  final AuthRepository? repository;
  final VoidCallback? onSessionEnded;
  final DiscoveryRepository? discoveryRepository;
  final ProcurementRepository? procurementRepository;
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
  late final DiscoveryController? _discoveryController = _discovery == null
      ? null
      : DiscoveryController(repository: _discovery);
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
          onOpenMap: () => _select(0),
        );
  bool _cartLoaded = false;

  @override
  void dispose() {
    _explore?.dispose();
    _cart?.dispose();
    _discoveryController?.dispose();
    super.dispose();
  }

  Future<void> _expireSession() async {
    await widget.repository?.clearAccountSession();
    if (mounted) _sessionEnded();
  }

  void _sessionEnded() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    widget.onSessionEnded?.call();
  }

  void _unavailable(String title) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => BuyerUnavailableScreen(title: title),
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
                          : () => _select(1),
                      onOpenCart: navigation == null
                          ? null
                          : () => navigation.openCart(context),
                      onOpenStore: (context, supplier) =>
                          _openStore(context, supplier.resultId),
                    ),
            ),
          ),
          if (_destination != 0) Positioned.fill(child: _destinationPage()),
        ],
      ),
      bottomNavigationBar: _navigationBar(),
    );
  }

  Widget _destinationPage() {
    if (_destination == 4 && widget.repository != null) {
      return BuyerProfileScreen(
        repository: widget.repository!,
        discoveryRepository: _discovery,
        onRemoveFavorite: _discoveryController == null
            ? null
            : (vendorId) =>
                  _discoveryController.setFavorite(vendorId, favorite: false),
        onRankingPreferences: _navigation == null
            ? null
            : () => _navigation.openPreferences(context),
        deviceLocation: widget.deviceLocation,
        onSignedOut: _sessionEnded,
        onSignOut: widget.onSignOut,
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
        appBar: AppBar(title: const Text('Explore stores')),
        body: const BuyerStoreBrowseScreen(),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(_labels[_destination]), centerTitle: true),
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
