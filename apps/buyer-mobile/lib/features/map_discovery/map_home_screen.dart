import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../design_system/components/discovery_controls.dart';
import '../../design_system/motion.dart';
import '../../design_system/theme.dart';
import '../../widgets/auth_content.dart';
import 'buyer_onboarding_screen.dart';
import 'device_location.dart';
import 'discovery_controller.dart';
import 'discovery_models.dart';
import 'discovery_repository.dart';
import 'location_welcome_screen.dart';
import 'select_location_screen.dart';
import 'supplier_map.dart';
import 'supplier_preview_sheet.dart';
import 'supplier_panels.dart';

typedef StoreProfileOpener =
    void Function(BuildContext context, SupplierResultView supplier);

/// Buyer Map Home: map-first discovery with the five-destination shell kept by the parent.
/// The synchronized list is a peer surface with the same data and order. GPS is optional and a
/// failed map never blocks the list, search or procurement.
class MapHomeScreen extends StatefulWidget {
  const MapHomeScreen({
    super.key,
    required this.repository,
    required this.deviceLocation,
    required this.onOpenStore,
    this.mapBuilder = defaultSupplierMapBuilder,
    this.onUnavailable,
    this.openLink,
    this.share,
    this.controller,
    this.onOpenSearch,
    this.onOpenCart,
  });

  final DiscoveryRepository repository;
  final DeviceLocationService deviceLocation;
  final StoreProfileOpener onOpenStore;
  final SupplierMapBuilder mapBuilder;
  final void Function(String title)? onUnavailable;
  final Future<void> Function(Uri uri)? openLink;
  final void Function(String text)? share;

  /// Shared with Explore so both use the same origin and radius; owned by the caller when given.
  final DiscoveryController? controller;
  final VoidCallback? onOpenSearch;
  final VoidCallback? onOpenCart;

  @override
  State<MapHomeScreen> createState() => _MapHomeScreenState();
}

class _MapHomeScreenState extends State<MapHomeScreen> {
  late final DiscoveryController _controller =
      widget.controller ?? DiscoveryController(repository: widget.repository);
  final DraggableScrollableController _sheet = DraggableScrollableController();
  SupplierListView _view = SupplierListView.all;
  bool? _listMode;
  int _recenter = 0;
  double _sheetExtent = 0.25;
  String? _lastSelected;
  bool _onboardingDismissed = false;
  bool _welcomeOpen = false;
  bool _welcomeDismissed = false;
  BaseMapStyle _baseMap = BaseMapStyle.standard;

  static const _peek = 0.16;
  static const _half = 0.5;
  static const _expanded = 0.92;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChanged);
    _controller.initialize().then((_) {
      if (mounted) _onChanged();
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    if (widget.controller == null) _controller.dispose();
    _sheet.dispose();
    super.dispose();
  }

  void _onChanged() {
    if (!mounted) return;
    final selected = _controller.selectedId;
    if (selected != null && selected != _lastSelected) {
      // Snap after the frame that swaps the list for the preview, so the rebuild cannot cancel it.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_sheet.isAttached) return;
        if (BuyerMotion.reduced(context)) {
          _sheet.jumpTo(_half);
        } else {
          _sheet.animateTo(
            _half,
            duration: MateryalMotionTokens.sheet,
            curve: BuyerMotion.enter,
          );
        }
      });
    }
    _lastSelected = selected;
    if (_controller.phase == DiscoveryPhase.needsOrigin &&
        !_welcomeOpen &&
        !_welcomeDismissed) {
      _welcomeOpen = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _openWelcome());
    }
    setState(() {});
  }

  /// First entry opens the full-screen location page above the bottom navigation. Leaving it
  /// without a choice shows a short prompt in Map Home instead of reopening it in a loop.
  Future<void> _openWelcome() async {
    if (!mounted) return;
    _welcomeOpen = true;
    final origin = await Navigator.of(context, rootNavigator: true)
        .push<DiscoveryOrigin>(
          MaterialPageRoute(
            builder: (_) => LocationWelcomeScreen(
              repository: widget.repository,
              deviceLocation: widget.deviceLocation,
              savedLocations: _controller.savedLocations,
              mapsAvailable: kMapsClientConfigured,
            ),
          ),
        );
    if (!mounted) return;
    if (origin == null) {
      _welcomeOpen = false;
      setState(() => _welcomeDismissed = true);
      return;
    }
    // Stay guarded until the origin is applied: reloading locations notifies while the phase
    // still needs an origin, which must not open the page a second time.
    try {
      await _controller.reloadLocations();
      await _controller.setOrigin(origin);
    } finally {
      _welcomeOpen = false;
    }
  }

  Future<void> _chooseLocation() async {
    final origin = await Navigator.of(context, rootNavigator: true)
        .push<DiscoveryOrigin>(
          MaterialPageRoute(
            builder: (_) => SelectLocationScreen(
              repository: widget.repository,
              deviceLocation: widget.deviceLocation,
              savedLocations: _controller.savedLocations,
              mapsAvailable: kMapsClientConfigured,
              initialPoint: _controller.origin?.point,
            ),
          ),
        );
    if (origin == null || !mounted) return;
    await _controller.reloadLocations();
    await _controller.setOrigin(origin);
  }

  Future<void> _expand() async {
    final page = _controller.page;
    final next = page?.suggestedRadiusKm;
    if (page == null || next == null) return;
    final confirmed = await confirmRadiusExpansion(
      context,
      fromKm: page.radiusKm,
      toKm: next,
      verifiedCount: page.eligibleVerifiedCount,
    );
    if (confirmed) await _controller.acceptExpansion();
  }

  Future<void> _openFilters() async {
    final next = await showModalBottomSheet<DiscoveryFilters>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => DiscoveryFilterSheet(
        filters: _controller.filters,
        categories: _controller.onboarding?.categories ?? const [],
      ),
    );
    if (next != null) await _controller.applyFilters(next);
  }

  Future<void> _openOnboarding() async {
    final onboarding = _controller.onboarding;
    if (onboarding == null) return;
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => BuyerOnboardingScreen(
          repository: widget.repository,
          initial: onboarding,
        ),
      ),
    );
    if (mounted) setState(() => _onboardingDismissed = true);
  }

  Future<void> _skipOnboarding() async {
    final onboarding = _controller.onboarding;
    setState(() => _onboardingDismissed = true);
    if (onboarding == null) return;
    try {
      await widget.repository.saveOnboarding(
        lockVersion: onboarding.lockVersion,
        action: 'SKIP',
      );
    } on DiscoveryFailure {
      // Skipping is optional; the banner simply returns next time.
    }
  }

  Future<void> _openLink(Uri uri) async {
    final open = widget.openLink;
    if (open != null) return open(uri);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void _share(String text) {
    final share = widget.share;
    if (share != null) return share(text);
    SharePlus.instance.share(ShareParams(text: text));
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final listMode = _listMode ?? media.accessibleNavigation;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _header(),
            if (_controller.onboarding?.status == 'NOT_STARTED' &&
                !_onboardingDismissed)
              _onboardingBanner(),
            Expanded(
              child: _controller.phase == DiscoveryPhase.needsOrigin
                  ? _needsOrigin()
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final split =
                            constraints.maxWidth >= 720 ||
                            (constraints.maxWidth > constraints.maxHeight &&
                                constraints.maxWidth >= 560);
                        if (listMode) return _listOnly();
                        return split
                            ? _split(constraints)
                            : _stacked(constraints);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    final origin = _controller.origin;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 4),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: LocationSelector(
                  label: origin?.label ?? 'Choose a location',
                  detail: origin == null
                      ? null
                      : '${_controller.radiusKm} km radius',
                  onPressed: _chooseLocation,
                ),
              ),

              IconButton(
                tooltip: 'Search',
                onPressed:
                    widget.onOpenSearch ??
                    () => widget.onUnavailable?.call('Search'),
                icon: const Icon(LucideIcons.search),
              ),

              IconButton(
                tooltip: 'Notifications',
                onPressed: () => widget.onUnavailable?.call('Notifications'),
                icon: const Icon(LucideIcons.bell),
              ),

              IconButton(
                tooltip: 'Cart',
                onPressed:
                    widget.onOpenCart ??
                    () => widget.onUnavailable?.call('Cart'),
                icon: const Icon(LucideIcons.shoppingCart),
              ),
            ],
          ),
          if (origin != null)
            Row(
              children: [
                Badge(
                  isLabelVisible: _controller.filters.activeCount > 0,
                  label: Text('${_controller.filters.activeCount}'),
                  child: IconButton(
                    tooltip: _controller.filters.activeCount > 0
                        ? 'Filters, ${_controller.filters.activeCount} active'
                        : 'Filters',
                    onPressed: _openFilters,
                    icon: const Icon(LucideIcons.slidersHorizontal),
                  ),
                ),
                Expanded(
                  child: RadiusSelector(
                    selectedKm: _controller.radiusKm,
                    onSelected: _controller.selectRadius,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _onboardingBanner() => Container(
    margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: BuyerTheme.canvas,
      border: Border.all(color: BuyerTheme.border),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tell us about your work (optional). It helps personalize categories; you can skip it anytime.',
        ),
        Wrap(
          spacing: 8,
          children: [
            TextButton(
              onPressed: _openOnboarding,
              child: const Text('Continue'),
            ),
            TextButton(onPressed: _skipOnboarding, child: const Text('Skip')),
          ],
        ),
      ],
    ),
  );

  /// Shown only after the Buyer leaves the location page without choosing.
  Widget _needsOrigin() => AuthContent(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Choose a location to see suppliers near it.',
          textAlign: TextAlign.center,
          style: TextStyle(color: BuyerTheme.muted),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: _openWelcome,
          icon: const Icon(LucideIcons.mapPin),
          label: const Text('Choose a location'),
        ),
      ],
    ),
  );

  SupplierMapProps _mapProps(double bottomInset) => SupplierMapProps(
    items: _controller.items,
    origin: _controller.origin?.point,
    radiusKm: _controller.radiusKm,
    selectedId: _controller.selectedId,
    routePath: _controller.route?.path,
    onSelect: _controller.select,
    bottomInset: bottomInset,
    recenterToken: _recenter,
    baseMap: _baseMap,
  );

  Widget _mapStack(double bottomInset) => Stack(
    children: [
      Positioned.fill(
        child: widget.mapBuilder(context, _mapProps(bottomInset)),
      ),
      Positioned(
        top: 8,
        right: 8,
        child: Column(
          children: [
            _floating(
              LucideIcons.locateFixed,
              'Recenter on your location',
              () => setState(() => _recenter++),
            ),
            const SizedBox(height: 8),
            _floating(LucideIcons.layers, 'Map type and legend', _showLayers),
            const SizedBox(height: 8),
            _floating(
              LucideIcons.list,
              'List view',
              () => setState(() => _listMode = true),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _floating(IconData icon, String label, VoidCallback onPressed) =>
      MapFloatingSurface(
        radius: 999,
        child: IconButton(
          tooltip: label,
          onPressed: onPressed,
          icon: Icon(icon),
        ),
      );

  Widget _panel(ScrollController? scroll) => _controller.selected == null
      ? SupplierListPanel(
          controller: _controller,
          view: _view,
          onViewChanged: (view) => setState(() => _view = view),
          onExpand: _expand,
          onChangeLocation: _chooseLocation,
          onAdjustFilters: _openFilters,
          onOpenLink: _openLink,
          scrollController: scroll,
        )
      : ListView(
          controller: scroll,
          children: [
            SupplierPreview(
              key: ValueKey(_controller.selectedId),
              controller: _controller,
              onViewStore: (supplier) => widget.onOpenStore(context, supplier),
              onMessage: (_) => widget.onUnavailable?.call('Messages'),
              onClose: _controller.clearSelection,
              onOpenLink: _openLink,
              onShare: _share,
            ),
          ],
        );

  Widget _stacked(BoxConstraints constraints) =>
      NotificationListener<DraggableScrollableNotification>(
        onNotification: (notification) {
          setState(() => _sheetExtent = notification.extent);
          return false;
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: _mapStack(constraints.maxHeight * _sheetExtent),
            ),
            SupplierPreviewSheet(
              cornerRadius: 16,
              controller: _sheet,
              initialSize: .25,
              minSize: _peek,
              maxSize: _expanded,
              snapSizes: const [_peek, _half, _expanded],
              builder: (context, scroll) => RefreshIndicator(
                onRefresh: _controller.refresh,
                child: _panel(scroll),
              ),
            ),
          ],
        ),
      );

  Widget _split(BoxConstraints constraints) => Row(
    children: [
      Expanded(child: _mapStack(0)),
      const VerticalDivider(width: 1),
      SizedBox(
        width: (constraints.maxWidth * 0.45).clamp(300.0, 420.0),
        child: RefreshIndicator(
          onRefresh: _controller.refresh,
          child: _panel(null),
        ),
      ),
    ],
  );

  Widget _listOnly() => Column(
    children: [
      Align(
        alignment: Alignment.centerRight,
        child: TextButton.icon(
          onPressed: () => setState(() => _listMode = false),
          icon: const Icon(LucideIcons.map, size: 18),
          label: const Text('Map view'),
        ),
      ),
      Expanded(
        child: RefreshIndicator(
          onRefresh: _controller.refresh,
          child: _panel(null),
        ),
      ),
    ],
  );

  Future<void> _showLayers() async {
    final choice = await showModalBottomSheet<Object>(
      context: context,
      showDragHandle: true,
      builder: (_) => MapLayersSheet(selected: _baseMap),
    );
    if (!mounted) return;
    if (choice is BaseMapStyle) setState(() => _baseMap = choice);
    if (choice == MapLayersSheet.legend) _showLegend();
  }

  void _showLegend() => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Map legend'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LegendRow(
            icon: LucideIcons.badgeCheck,
            text:
                'Verified Vendor: orange pin with a check, labelled VPS or New Vendor',
          ),
          _LegendRow(
            icon: LucideIcons.building2,
            text:
                'Directory Supplier: gray outlined pin with a building, labelled Directory',
          ),
          _LegendRow(
            icon: LucideIcons.star,
            text: 'Favorite Supplier: star tab on a Verified Vendor pin',
          ),
          _LegendRow(
            icon: LucideIcons.circleDot,
            text: 'Blue dot: your selected location',
          ),
          _LegendRow(
            icon: LucideIcons.circleDashed,
            text: 'Numbered circle: several suppliers. Select it to zoom in',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

/// Map layers: the basemap choice (Map or Satellite) plus the marker legend. Pops a
/// [BaseMapStyle], [legend], or nothing.
class MapLayersSheet extends StatelessWidget {
  const MapLayersSheet({super.key, required this.selected});

  final BaseMapStyle selected;

  static const legend = 'legend';

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            header: true,
            child: Text(
              'Map type',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final (style, icon, label) in [
                (BaseMapStyle.standard, LucideIcons.map, 'Map'),
                (BaseMapStyle.satellite, LucideIcons.satellite, 'Satellite'),
              ]) ...[
                if (style != BaseMapStyle.standard) const SizedBox(width: 12),
                Expanded(
                  child: _BaseMapOption(
                    icon: icon,
                    label: label,
                    selected: style == selected,
                    onTap: () => Navigator.of(context).pop(style),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () => Navigator.of(context).pop(legend),
            icon: const Icon(LucideIcons.info, size: 18),
            label: const Text('Map legend'),
          ),
        ],
      ),
    ),
  );
}

class _BaseMapOption extends StatelessWidget {
  const _BaseMapOption({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    label: '$label map${selected ? ', selected' : ''}',
    excludeSemantics: true,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        constraints: const BoxConstraints(minHeight: 88),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? BuyerTheme.brandSoft : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? BuyerTheme.action : BuyerTheme.border,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: selected ? BuyerTheme.action : BuyerTheme.ink),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (selected) ...[
                  const Icon(
                    LucideIcons.check,
                    size: 16,
                    color: BuyerTheme.action,
                  ),
                  const SizedBox(width: 4),
                ],
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(text)),
      ],
    ),
  );
}

/// The approved safe filter set: tier toggles, Favorites only, Supplier Type and Material
/// Category. There is deliberately no Open Now, rating or review-count filter.
class DiscoveryFilterSheet extends StatefulWidget {
  const DiscoveryFilterSheet({
    super.key,
    required this.filters,
    required this.categories,
  });
  final DiscoveryFilters filters;
  final List<CategoryOption> categories;

  @override
  State<DiscoveryFilterSheet> createState() => _DiscoveryFilterSheetState();
}

class _DiscoveryFilterSheetState extends State<DiscoveryFilterSheet> {
  late DiscoveryFilters _filters = widget.filters;

  static const _types = {
    'WHOLESALER_DISTRIBUTOR': 'Wholesaler or distributor',
    'RETAIL_HARDWARE_STORE': 'Retail hardware store',
    'SPECIALIZED_SUPPLIER': 'Specialized supplier',
    'OTHER': 'Other',
  };

  @override
  Widget build(BuildContext context) => SafeArea(
    child: ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      children: [
        Semantics(
          header: true,
          child: Text('Filters', style: Theme.of(context).textTheme.titleLarge),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show Verified Vendors'),
          value: _filters.includeVerified,
          onChanged: (value) => setState(
            () => _filters = _filters.copyWith(includeVerified: value),
          ),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Show Directory Suppliers'),
          subtitle: const Text('Informational listings from Google Maps'),
          value: _filters.includeDirectory,
          onChanged: (value) => setState(
            () => _filters = _filters.copyWith(includeDirectory: value),
          ),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Favorite Suppliers only'),
          value: _filters.favoritesOnly,
          onChanged: (value) => setState(
            () => _filters = _filters.copyWith(favoritesOnly: value),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String?>(
          initialValue: _filters.supplierType,
          isExpanded: true,
          decoration: const InputDecoration(labelText: 'Supplier type'),
          items: [
            const DropdownMenuItem(
              value: null,
              child: Text('Any supplier type'),
            ),
            for (final entry in _types.entries)
              DropdownMenuItem(value: entry.key, child: Text(entry.value)),
          ],
          onChanged: (value) => setState(
            () => _filters = _filters.copyWith(supplierType: () => value),
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String?>(
          initialValue: _filters.categoryId,
          isExpanded: true,
          decoration: const InputDecoration(labelText: 'Material category'),
          items: [
            const DropdownMenuItem(value: null, child: Text('Any category')),
            for (final category in widget.categories)
              DropdownMenuItem(value: category.id, child: Text(category.name)),
          ],
          onChanged: (value) => setState(
            () => _filters = _filters.copyWith(categoryId: () => value),
          ),
        ),
        if (_filters.tierSpecific) ...[
          const SizedBox(height: 12),
          const Text(
            'Favorite, supplier type and category filters apply to Verified Vendors only, so Directory Suppliers are hidden while they are on.',
            style: TextStyle(color: BuyerTheme.muted),
          ),
        ],
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () =>
                    setState(() => _filters = const DiscoveryFilters()),
                child: const Text('Reset'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(_filters),
                child: const Text('Apply'),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
