import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';
import '../auth/auth_repository.dart';
import '../features/map_discovery/buyer_onboarding_screen.dart';
import '../features/map_discovery/buyer_places_screens.dart';
import '../features/map_discovery/device_location.dart';
import '../features/map_discovery/discovery_models.dart';
import '../features/map_discovery/discovery_repository.dart';
import '../widgets/auth_content.dart';
import '../widgets/buyer_account_widgets.dart';
import 'buyer_account_screen.dart';

class BuyerProfileScreen extends StatefulWidget {
  const BuyerProfileScreen({
    super.key,
    required this.repository,
    required this.onSignedOut,
    required this.onSignOut,
    this.discoveryRepository,
    this.onRankingPreferences,
    this.onOpenOrders,
    this.onOpenCart,
    this.onOpenSearch,
    this.onOpenNotifications,
    this.onRemoveFavorite,
    this.deviceLocation = const GeolocatorDeviceLocationService(),
  });
  final AuthRepository repository;
  final VoidCallback? onRankingPreferences;
  final VoidCallback? onOpenOrders;
  final VoidCallback? onOpenCart;
  final VoidCallback? onOpenSearch;
  final VoidCallback? onOpenNotifications;
  final Future<void> Function(String vendorId)? onRemoveFavorite;
  final DiscoveryRepository? discoveryRepository;
  final DeviceLocationService deviceLocation;
  final VoidCallback onSignedOut;
  final Future<void> Function() onSignOut;
  @override
  State<BuyerProfileScreen> createState() => _BuyerProfileScreenState();
}

class _BuyerProfileScreenState extends State<BuyerProfileScreen> {
  AccountProfile? _profile;
  String? _error;
  bool _busy = false;
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final response = await widget.repository.accountOperation(
        (api) => api.getAccountProfile(accountPortal: 'buyers'),
      );
      final profile = response.data?.data;
      if (profile == null || profile.accountType != 'BUYER') {
        throw const BuyerAuthException('Buyer access is unavailable.');
      }
      if (mounted) setState(() => _profile = profile);
    } catch (error) {
      if (error is BuyerSessionExpired) {
        if (mounted) widget.onSignedOut();
        return;
      }
      if (mounted) {
        setState(
          () => _error = error is BuyerAuthException
              ? error.message
              : 'Could not load your profile. Please retry.',
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _signOut() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await widget.onSignOut();
    } catch (_) {
      if (mounted) {
        setState(
          () => _error = 'Could not sign out. Check your connection and retry.',
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _unavailable(String title, [String artwork = 'not-implemented']) =>
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) =>
              BuyerUnavailableScreen(title: title, artwork: artwork),
        ),
      );

  /// Bell and Notification Settings share one destination, the same one the other tabs use.
  void _openNotifications() => widget.onOpenNotifications != null
      ? widget.onOpenNotifications!()
      : _unavailable('Notifications', 'notifications');

  void _open(
    Widget Function(DiscoveryRepository repository) builder,
    String title, [
    String artwork = 'not-implemented',
  ]) {
    final discovery = widget.discoveryRepository;
    if (discovery == null) return _unavailable(title, artwork);
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => builder(discovery)));
  }

  Future<void> _aboutWork() async {
    final discovery = widget.discoveryRepository;
    if (discovery == null) return _unavailable('About your work');
    try {
      final onboarding = await discovery.onboarding();
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) =>
              BuyerOnboardingScreen(repository: discovery, initial: onboarding),
        ),
      );
    } on DiscoveryFailure catch (error) {
      if (mounted) setState(() => _error = error.message);
    }
  }

  Future<void> _account(String section) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BuyerSettingsScreen(
          profile: _profile!,
          repository: widget.repository,
          onSignedOut: widget.onSignedOut,
          initialSection: section,
        ),
      ),
    );
    if (mounted) await _load();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          children: [
            if (_busy) const LinearProgressIndicator(),
            if (_error != null) ...[
              AuthNotice(message: _error!, isError: true),
              TextButton(
                onPressed: _busy ? null : _load,
                child: const Text('Retry'),
              ),
            ],
            if (_profile != null) ...[
              BuyerIdentity(
                profile: _profile!,
                onSearch:
                    widget.onOpenSearch ??
                    () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Not yet implemented.')),
                    ),
                onNotifications: _openNotifications,
              ),
              const BuyerSectionLabel('My purchases'),
              BuyerMenuRow(
                label: 'Orders',
                icon: LucideIcons.package,
                onTap: widget.onOpenOrders ?? () => _unavailable('Orders'),
              ),
              BuyerMenuRow(
                label: 'Cart',
                icon: LucideIcons.shoppingCart,
                onTap:
                    widget.onOpenCart ?? () => _unavailable('Cart', 'cart'),
              ),
              BuyerMenuRow(
                label: 'Cancellations & Refunds',
                icon: LucideIcons.rotateCcw,
                onTap: () => _unavailable('Cancellations & Refunds'),
              ),
              BuyerMenuRow(
                label: 'Disputes',
                icon: LucideIcons.scale,
                onTap: () => _unavailable('Disputes'),
              ),
              BuyerMenuRow(
                label: 'My Reviews',
                icon: LucideIcons.star,
                onTap: () => _unavailable('My Reviews'),
              ),
              const BuyerSectionLabel('Account'),
              BuyerMenuRow(
                label: 'Account Setting',
                icon: LucideIcons.settings,
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => BuyerSettingsScreen(
                        profile: _profile!,
                        repository: widget.repository,
                        onSignedOut: widget.onSignedOut,
                      ),
                    ),
                  );
                  if (mounted) await _load();
                },
              ),
              BuyerMenuRow(
                label: 'Favorite Suppliers',
                icon: LucideIcons.heart,
                onTap: () => _open(
                  (repository) => FavoriteSuppliersScreen(
                    repository: repository,
                    onRemove: widget.onRemoveFavorite,
                  ),
                  'Favorite Suppliers',
                ),
              ),
              BuyerMenuRow(
                label: 'Saved Locations',
                icon: LucideIcons.mapPin,
                onTap: () => _open(
                  (repository) => SavedLocationsScreen(
                    repository: repository,
                    deviceLocation: widget.deviceLocation,
                  ),
                  'Saved Locations',
                  'location',
                ),
              ),
              BuyerMenuRow(
                label: 'About your work',
                icon: LucideIcons.hardHat,
                onTap: _aboutWork,
              ),
              BuyerMenuRow(
                label: 'Ranking Preferences',
                icon: LucideIcons.slidersHorizontal,
                onTap:
                    widget.onRankingPreferences ??
                    () => _unavailable('Ranking Preferences'),
              ),
              BuyerMenuRow(
                label: 'Notification Settings',
                icon: LucideIcons.bell,
                onTap: _openNotifications,
              ),
              const BuyerSectionLabel('Support'),
              BuyerMenuRow(
                label: 'Help Center',
                icon: LucideIcons.circleHelp,
                onTap: () => _unavailable('Help Center'),
              ),
              BuyerMenuRow(
                label: 'Reports & Privacy Requests',
                icon: LucideIcons.shield,
                onTap: () => _unavailable('Reports & Privacy Requests'),
              ),
              BuyerMenuRow(
                label: 'Terms & Agreements',
                icon: LucideIcons.fileCheck,
                onTap: () => _account('Agreements'),
              ),
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: _busy ? null : _signOut,
                icon: const Icon(LucideIcons.logOut, size: 20),
                label: Text(_busy ? 'Please wait…' : 'Sign Out'),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

class BuyerSettingsScreen extends StatefulWidget {
  const BuyerSettingsScreen({
    super.key,
    required this.profile,
    required this.repository,
    required this.onSignedOut,
    this.initialSection,
  });
  final String? initialSection;
  final AccountProfile profile;
  final AuthRepository repository;
  final VoidCallback onSignedOut;
  @override
  State<BuyerSettingsScreen> createState() => _BuyerSettingsScreenState();
}

class _BuyerSettingsScreenState extends State<BuyerSettingsScreen> {
  late AccountProfile _profile = widget.profile;
  @override
  void initState() {
    super.initState();
    if (widget.initialSection != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _account(widget.initialSection!);
      });
    }
  }

  void _unavailable(String title) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => BuyerUnavailableScreen(title: title),
    ),
  );
  Future<void> _account(String section) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BuyerAccountScreen(
          repository: widget.repository,
          onSignedOut: widget.onSignedOut,
          initialSection: section,
        ),
      ),
    );
    if (!mounted) return;
    try {
      final result = await widget.repository.accountOperation(
        (api) => api.getAccountProfile(accountPortal: 'buyers'),
      );
      if (mounted && result.data?.data != null) {
        setState(() => _profile = result.data!.data);
      }
    } catch (error) {
      if (!mounted) return;
      if (error is BuyerSessionExpired) {
        widget.onSignedOut();
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not refresh your profile. Reopen Account Setting to retry.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: buyerAccountBar(context, 'Account Setting'),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: [
          BuyerIdentity(
            profile: _profile,
            centered: true,
            onEditPhoto: () => _unavailable('Edit Profile Picture'),
          ),
          const BuyerSectionLabel('Personal information'),
          BuyerMenuRow(
            label: 'Edit Account Details',
            icon: LucideIcons.pencil,
            onTap: () => _account('Profile'),
          ),
          const BuyerSectionLabel('Security'),
          BuyerMenuRow(
            label: 'Enable Two-Factor Authentication (2FA)',
            icon: LucideIcons.shieldCheck,
            onTap: () => _unavailable('Two-Factor Authentication'),
          ),
          BuyerMenuRow(
            label: 'Password Manager',
            icon: LucideIcons.lock,
            onTap: () => _account('Security'),
          ),
          BuyerMenuRow(
            label: 'Sessions / Devices',
            icon: LucideIcons.smartphone,
            onTap: () => _account('Sessions'),
          ),
          const BuyerSectionLabel('Agreements'),
          BuyerMenuRow(
            label: 'Terms & Agreements',
            icon: LucideIcons.fileCheck,
            onTap: () => _account('Agreements'),
          ),
          const BuyerSectionLabel('Connected accounts'),
          BuyerMenuRow(
            label: 'Connected Accounts',
            icon: LucideIcons.link,
            onTap: () => _unavailable('Connected Accounts'),
          ),
          const BuyerSectionLabel('Account actions'),
          BuyerMenuRow(
            label: 'Delete Account',
            icon: LucideIcons.trash2,
            destructive: true,
            onTap: () => _unavailable('Delete Account'),
          ),
        ],
      ),
    ),
  );
}
