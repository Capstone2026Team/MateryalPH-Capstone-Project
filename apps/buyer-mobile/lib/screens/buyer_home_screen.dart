import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../auth/auth_repository.dart';
import '../design_system/theme.dart';
import '../features/map_discovery/device_location.dart';
import '../features/map_discovery/discovery_repository.dart';
import '../features/map_discovery/map_home_screen.dart';
import '../features/map_discovery/supplier_map.dart';
import '../widgets/buyer_account_widgets.dart';
import 'buyer_profile_screen.dart';
import 'buyer_store_browse_screen.dart';

/// The five-destination Buyer shell. Map is the default authenticated destination and stays
/// mounted while another tab is open, so the selected location, radius and selection survive.
class BuyerHomeScreen extends StatefulWidget {
  const BuyerHomeScreen({
    super.key,
    required this.onSignOut,
    this.repository,
    this.onSessionEnded,
    this.discoveryRepository,
    this.deviceLocation = const GeolocatorDeviceLocationService(),
    this.mapBuilder = defaultSupplierMapBuilder,
  });

  final Future<void> Function() onSignOut;
  final AuthRepository? repository;
  final VoidCallback? onSessionEnded;
  final DiscoveryRepository? discoveryRepository;
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

  @override
  Widget build(BuildContext context) {
    final discovery = _discovery;
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
                      deviceLocation: widget.deviceLocation,
                      mapBuilder: widget.mapBuilder,
                      onUnavailable: _unavailable,
                      onOpenStore: (context, supplier) =>
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => BuyerPublicStoreProfileScreen(
                                storeId: supplier.resultId,
                                repository: BuyerStoreRepository(),
                              ),
                            ),
                          ),
                    ),
            ),
          ),
          if (_destination != 0) Positioned.fill(child: _destinationPage()),
        ],
      ),
      bottomNavigationBar: _navigation(),
    );
  }

  Widget _destinationPage() {
    if (_destination == 4 && widget.repository != null) {
      return BuyerProfileScreen(
        repository: widget.repository!,
        discoveryRepository: _discovery,
        deviceLocation: widget.deviceLocation,
        onSignedOut: _sessionEnded,
        onSignOut: widget.onSignOut,
      );
    }
    if (_destination == 1) {
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

  Widget _navigation() {
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
                  onTap: () => setState(() => _destination = index),
                  button: true,
                  label: _labels[index],
                  child: ExcludeSemantics(
                    child: InkWell(
                      onTap: () => setState(() => _destination = index),
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
