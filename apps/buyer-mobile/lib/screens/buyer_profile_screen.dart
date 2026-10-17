import '../features/notifications/notification_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';
import '../auth/auth_repository.dart';
import '../features/map_discovery/buyer_onboarding_screen.dart';
import '../features/map_discovery/buyer_places_screens.dart';
import '../features/map_discovery/device_location.dart';
import '../features/map_discovery/discovery_models.dart';
import '../features/map_discovery/discovery_repository.dart';
import '../design_system/components/procurement_components.dart';
import '../widgets/auth_content.dart';
import '../widgets/buyer_account_widgets.dart';
import 'buyer_account_screen.dart';
import 'buyer_delete_account_screen.dart';
import 'buyer_help_center_screen.dart';
import 'buyer_two_factor_screen.dart';

class BuyerProfileScreen extends StatefulWidget {
  const BuyerProfileScreen({
    super.key,
    this.active = true,
    required this.repository,
    required this.onSignedOut,
    required this.onSignOut,
    this.discoveryRepository,
    this.onRankingPreferences,
    this.onOpenOrders,
    this.onOpenCancellationsAndRefunds,
    this.onOpenDisputes,
    this.onOpenReviews,
    this.onOpenCart,
    this.onOpenSearch,
    this.onOpenNotifications,
    this.onOpenNotificationSettings,
    this.onRemoveFavorite,
    this.onOpenStore,
    this.onMessageStore,
    this.deviceLocation = const GeolocatorDeviceLocationService(),
  });
  final AuthRepository repository;
  final bool active;
  final VoidCallback? onRankingPreferences;
  final VoidCallback? onOpenOrders;
  final VoidCallback? onOpenCancellationsAndRefunds;
  final VoidCallback? onOpenDisputes;
  final VoidCallback? onOpenReviews;
  final VoidCallback? onOpenCart;
  final VoidCallback? onOpenSearch;
  final VoidCallback? onOpenNotifications;
  final VoidCallback? onOpenNotificationSettings;
  final Future<void> Function(String vendorId)? onRemoveFavorite;
  final void Function(BuildContext context, String vendorId)? onOpenStore;
  final void Function(BuildContext context, String vendorId)? onMessageStore;
  final DiscoveryRepository? discoveryRepository;
  final DeviceLocationService deviceLocation;
  final VoidCallback onSignedOut;
  final Future<void> Function() onSignOut;
  @override
  State<BuyerProfileScreen> createState() => _BuyerProfileScreenState();
}

class _BuyerProfileScreenState extends State<BuyerProfileScreen> {
  AccountProfile? _profile;
  Uint8List? _photo;
  String? _error;
  bool _busy = false;
  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant BuyerProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !oldWidget.active) _load();
  }

  Future<void> _load() async {
    if (_busy) return;
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
      if (!mounted) return;
      setState(() {
        _profile = profile;
        _photo = null;
      });
      try {
        final photo = await widget.repository.profilePhoto(profile);
        if (mounted) setState(() => _photo = photo);
      } on BuyerSessionExpired {
        rethrow;
      } catch (_) {
        if (mounted) {
          setState(
            () => _error = 'Could not load your photo. Refresh to retry.',
          );
        }
      }
    } catch (error) {
      if (error is BuyerSessionExpired) {
        if (mounted) {
          setState(() {
            _profile = null;
            _photo = null;
          });
          widget.onSignedOut();
        }
        return;
      }
      if (mounted) {
        _profile = null;
        _photo = null;
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

  void _unavailable(
    String title, [
    StateArtwork artwork = StateArtwork.noResults,
  ]) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => BuyerUnavailableScreen(title: title, artwork: artwork),
    ),
  );

  /// The bell opens the inbox, the same destination the other tabs use.
  void _openNotifications() => widget.onOpenNotifications != null
      ? widget.onOpenNotifications!()
      : _unavailable('Notifications', StateArtwork.notifications);

  /// Notification Settings is where the Buyer edits delivery channels; it is not the inbox.
  void _openNotificationSettings() => widget.onOpenNotificationSettings != null
      ? widget.onOpenNotificationSettings!()
      : _unavailable('Notification Settings', StateArtwork.notifications);

  void _open(
    Widget Function(DiscoveryRepository repository) builder,
    String title, [
    StateArtwork artwork = StateArtwork.noResults,
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

  /// Opens the agreements page directly so Back returns to Profile.
  void _openAgreements() => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => BuyerAccountScreen(
        repository: widget.repository,
        onSignedOut: widget.onSignedOut,
        initialSection: 'Agreements',
      ),
    ),
  );

  void _openHelpCenter() => Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => const BuyerHelpCenterScreen()),
  );

  @override
  Widget build(BuildContext context) {
    final counts = NotificationScope.of(context)?.navigation;
    return ListenableBuilder(
      listenable: counts ?? const AlwaysStoppedAnimation<int>(0),
      builder: (context, _) => _content(context),
    );
  }

  Widget _content(BuildContext context) => Scaffold(
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
                photoBytes: _photo,
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
                badgeQuantity:
                    '${NotificationScope.of(context)?.navigation.value.orders ?? 0}',
                badgeMeaning: 'active orders',
                icon: LucideIcons.package,
                onTap: widget.onOpenOrders ?? () => _unavailable('Orders'),
              ),
              BuyerMenuRow(
                label: 'Cart',
                badgeQuantity:
                    NotificationScope.of(
                      context,
                    )?.navigation.value.cartQuantity ??
                    '0',
                badgeMeaning: 'items in cart',
                icon: LucideIcons.shoppingCart,
                onTap:
                    widget.onOpenCart ??
                    () => _unavailable('Cart', StateArtwork.cart),
              ),
              BuyerMenuRow(
                label: 'Cancellations & Refunds',
                icon: LucideIcons.rotateCcw,
                onTap:
                    widget.onOpenCancellationsAndRefunds ??
                    () => _unavailable('Cancellations & Refunds'),
              ),
              BuyerMenuRow(
                label: 'Disputes',
                badgeQuantity:
                    '${NotificationScope.of(context)?.navigation.value.disputes ?? 0}',
                badgeMeaning: 'active disputes',
                icon: LucideIcons.scale,
                onTap: widget.onOpenDisputes ?? () => _unavailable('Disputes'),
              ),
              BuyerMenuRow(
                label: 'My Reviews',
                icon: LucideIcons.star,
                onTap: widget.onOpenReviews ?? () => _unavailable('My Reviews'),
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
                    onOpenStore: widget.onOpenStore,
                    onMessage: widget.onMessageStore,
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
                  StateArtwork.location,
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
                onTap: _openNotificationSettings,
              ),
              const BuyerSectionLabel('Support'),
              BuyerMenuRow(
                label: 'Help Center',
                icon: LucideIcons.circleHelp,
                onTap: _openHelpCenter,
              ),
              BuyerMenuRow(
                label: 'Terms & Agreements',
                icon: LucideIcons.fileCheck,
                onTap: _openAgreements,
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
  });
  final AccountProfile profile;
  final AuthRepository repository;
  final VoidCallback onSignedOut;
  @override
  State<BuyerSettingsScreen> createState() => _BuyerSettingsScreenState();
}

class _BuyerSettingsScreenState extends State<BuyerSettingsScreen> {
  late AccountProfile _profile = widget.profile;
  Uint8List? _photo;
  bool _refreshing = false;
  bool _uploading = false;
  bool? _twoFactorOn;
  String? _photoError;
  @override
  void initState() {
    super.initState();
    _refreshProfile();
  }

  /// The On/Off label is a convenience; the 2FA page loads the status itself.
  Future<bool?> _twoFactorStatus() async {
    try {
      final response = await widget.repository.accountOperation(
        (api) => api.getAccountSecurity(accountPortal: 'buyers'),
      );
      return response.data?.data.totpEnrolled;
    } on BuyerSessionExpired {
      rethrow;
    } catch (_) {
      return null;
    }
  }

  Future<void> _openSecurityPage(WidgetBuilder builder) async {
    await Navigator.of(context).push(MaterialPageRoute<void>(builder: builder));
    if (mounted) await _refreshProfile();
  }

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
    await _refreshProfile();
  }

  Future<void> _refreshProfile() async {
    if (_refreshing || _uploading) return;
    setState(() {
      _refreshing = true;
      _photoError = null;
    });
    try {
      final result = await widget.repository.accountOperation(
        (api) => api.getAccountProfile(accountPortal: 'buyers'),
      );
      final profile = result.data?.data;
      if (profile == null || profile.accountType != 'BUYER') {
        throw const BuyerAuthException('Buyer access is unavailable.');
      }
      if (!mounted) return;
      setState(() {
        _profile = profile;
        _photo = null;
      });
      final twoFactorOn = await _twoFactorStatus();
      if (mounted) setState(() => _twoFactorOn = twoFactorOn);
      final photo = await widget.repository.profilePhoto(profile);
      if (mounted) setState(() => _photo = photo);
    } catch (error) {
      if (!mounted) return;
      setState(() => _photo = null);
      if (error is BuyerSessionExpired) {
        widget.onSignedOut();
        return;
      }
      setState(
        () => _photoError = error is BuyerAuthException
            ? error.message
            : 'Could not refresh your profile. Pull down to retry.',
      );
    } finally {
      if (mounted) setState(() => _refreshing = false);
    }
  }

  Future<void> _uploadPhoto() async {
    if (_uploading || _refreshing) return;
    setState(() {
      _uploading = true;
      _photoError = null;
    });
    var saved = false;
    try {
      final file = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (file == null || !mounted) return;
      final size = await file.length();
      if (size < 1 || size > 2 * 1024 * 1024) {
        throw const BuyerAuthException(
          'Choose a JPEG, PNG or WebP up to 2 MB.',
        );
      }
      final bytes = await file.readAsBytes();
      if (!mounted) return;
      final profile = await widget.repository.uploadProfilePhoto(
        bytes,
        file.name,
        _profile.lockVersion,
      );
      saved = true;
      if (!mounted) return;
      setState(() {
        _profile = profile;
        _photo = null;
      });
      final photo = await widget.repository.profilePhoto(profile);
      if (!mounted) return;
      setState(() => _photo = photo);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile photo uploaded.')));
    } on PlatformException {
      if (mounted) {
        setState(
          () => _photoError =
              'Your photos could not open. Check gallery access in Settings and retry.',
        );
      }
    } catch (error) {
      if (!mounted) return;
      if (error is BuyerSessionExpired) {
        setState(() => _photo = null);
        widget.onSignedOut();
        return;
      }
      setState(
        () => _photoError = saved
            ? 'Your photo was saved. Pull down to reload it.'
            : error is BuyerAuthException
            ? error.message
            : 'Could not upload your photo. Please try again.',
      );
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final counts = NotificationScope.of(context)?.navigation;
    return ListenableBuilder(
      listenable: counts ?? const AlwaysStoppedAnimation<int>(0),
      builder: (context, _) => _content(context),
    );
  }

  Widget _content(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: buyerAccountBar(context, 'Account Setting'),
    body: SafeArea(
      child: RefreshIndicator(
        onRefresh: _refreshProfile,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            if (_refreshing)
              const LinearProgressIndicator(
                semanticsLabel: 'Refreshing profile',
              ),
            BuyerIdentity(
              profile: _profile,
              photoBytes: _photo,
              centered: true,
              onUploadPhoto: _uploadPhoto,
              uploadingPhoto: _uploading,
              photoUploadEnabled: !_refreshing,
            ),
            if (_photoError != null) ...[
              const SizedBox(height: 12),
              AuthNotice(message: _photoError!, isError: true),
              TextButton(
                onPressed: _refreshing || _uploading ? null : _refreshProfile,
                child: const Text('Refresh profile'),
              ),
            ],
            const BuyerSectionLabel('Personal information'),
            BuyerMenuRow(
              label: 'Edit Account Details',
              icon: LucideIcons.pencil,
              onTap: () => _account('Profile'),
            ),
            const BuyerSectionLabel('Security'),
            BuyerMenuRow(
              label: 'Two-Factor Authentication (2FA)',
              icon: LucideIcons.shieldCheck,
              status: _twoFactorOn == null
                  ? null
                  : _twoFactorOn!
                  ? 'On'
                  : 'Off',
              statusPositive: _twoFactorOn == true,
              onTap: () => _openSecurityPage(
                (_) => BuyerTwoFactorScreen(
                  repository: widget.repository,
                  onSignedOut: widget.onSignedOut,
                ),
              ),
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
            const BuyerSectionLabel('Account actions'),
            BuyerMenuRow(
              label: 'Delete Account',
              icon: LucideIcons.trash2,
              destructive: true,
              onTap: () => _openSecurityPage(
                (_) => BuyerDeleteAccountScreen(
                  repository: widget.repository,
                  onSignedOut: widget.onSignedOut,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
