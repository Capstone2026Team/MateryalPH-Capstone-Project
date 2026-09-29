import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design_system/components/procurement_components.dart';
import '../../design_system/theme.dart';
import '../map_discovery/discovery_models.dart';
import 'cart_controller.dart';
import 'explore_controller.dart';
import 'procurement_models.dart';
import 'procurement_navigation.dart';

/// Explore Materials Catalog: header with notifications and Cart, search, one slim scope line (active
/// location, radius and the MAT-01 counts from one server snapshot, labelled as Vendor listings),
/// the not-yet-available Materials Analytics entry, and the category grid.
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({
    super.key,
    required this.controller,
    required this.cart,
    required this.navigation,
    required this.onOpenMap,
    this.onOpenNotifications,
  });

  final ExploreController controller;
  final CartController cart;
  final ProcurementNavigation navigation;
  final VoidCallback onOpenMap;
  final VoidCallback? onOpenNotifications;

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late final ScrollController _scroll = ScrollController(
    initialScrollOffset: widget.controller.exploreScrollOffset,
  );

  ExploreController get _controller => widget.controller;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(
      () => _controller.rememberExploreScroll(_scroll.offset),
    );
    if (_controller.summary == null) _controller.loadSummary();
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _openCategory(CategoryCountView category) {
    _controller.search(
      query: '',
      filters: ListingFilters(
        categoryId: category.id,
        categoryName: category.name,
      ),
      sort: () => null,
    );
    widget.navigation.openResults(context);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: ListenableBuilder(
        listenable: Listenable.merge([_controller, widget.cart]),
        builder: (context, _) => RefreshIndicator(
          onRefresh: _controller.loadSummary,
          child: ListView(
            key: const PageStorageKey('explore-list'),
            controller: _scroll,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              _header(),
              const SizedBox(height: 4),
              ..._scope(),
              const SizedBox(height: 12),
              PillSearchField(
                onTap: () => widget.navigation.openSearch(context),
              ),
              const SizedBox(height: 16),
              _analytics(),
              const SizedBox(height: 24),
              Semantics(
                header: true,
                child: const Text(
                  'All categories',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(height: 12),
              _categories(),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _header() => Row(
    children: [
      Expanded(
        child: Semantics(
          header: true,
          child: const Text(
            'Materials Catalog',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
        ),
      ),
      IconButton(
        tooltip: 'Notifications',
        onPressed: widget.onOpenNotifications,
        icon: const Icon(LucideIcons.bell, color: BuyerTheme.ink),
      ),
      IconButton(
        tooltip: widget.cart.lineCount > 0
            ? 'Cart, ${widget.cart.lineCount} lines'
            : 'Cart',
        onPressed: () => widget.navigation.openCart(context),
        icon: Badge(
          isLabelVisible: widget.cart.lineCount > 0,
          backgroundColor: BuyerTheme.ink,
          label: Text('${widget.cart.lineCount}'),
          child: const Icon(LucideIcons.shoppingCart, color: BuyerTheme.ink),
        ),
      ),
    ],
  );

  /// Location, radius and the two MAT-01 counts in one slim line. Loading never shows a false zero;
  /// a failed refresh keeps the last snapshot and says so.
  List<Widget> _scope() {
    final origin = _controller.origin;
    final summary = _controller.summary;
    final failure = _controller.summaryFailure;
    if (_controller.summaryPhase == LoadPhase.needsOrigin || origin == null) {
      return [
        StateMessage(
          kind: StateKind.needsLocation,
          artwork: 'assets/states/location.png',
          title: 'Choose a location first',
          message:
              'Products and prices depend on where you are buying for. Pick a location on the Map; GPS is optional.',
          actionLabel: 'Go to Map',
          onAction: widget.onOpenMap,
        ),
      ];
    }
    final loading = _controller.summaryPhase == LoadPhase.loading;
    // While loading, never show the previous scope's numbers as if they were current.
    final shown = loading ? null : summary;
    final muted = const TextStyle(fontSize: 12, color: BuyerTheme.muted);
    return [
      Semantics(
        button: true,
        label:
            'Buying for ${origin.label} within ${_controller.radiusKm} km. Change location on the Map',
        excludeSemantics: true,
        child: InkWell(
          onTap: widget.onOpenMap,
          borderRadius: BorderRadius.circular(8),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 32),
            child: Row(
              children: [
                const Icon(
                  LucideIcons.mapPin,
                  size: 14,
                  color: BuyerTheme.action,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    '${origin.label} · ${_controller.radiusKm} km',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                const Icon(LucideIcons.chevronDown, size: 14),
              ],
            ),
          ),
        ),
      ),
      if (_controller.summaryPhase == LoadPhase.failed && summary == null)
        StatusBand(
          tone: BandTone.warning,
          title: failure?.kind == DiscoveryFailureKind.offline
              ? 'You are offline'
              : 'Nearby counts are unavailable',
          message: failure?.message,
          action: TextButton(
            onPressed: _controller.loadSummary,
            child: const Text('Retry'),
          ),
        )
      else
        Wrap(
          spacing: 6,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _Count(
              label: shown?.vendorsLabel ?? 'Nearby Verified Vendors',
              value: shown?.verifiedVendors,
              unit: 'Verified Vendors',
              announceUnit: false,
            ),
            Text('·', style: muted),
            _Count(
              label: shown?.listingsLabel ?? 'Available Products',
              value: shown?.vendorListings,
              unit: shown?.listingsUnit ?? 'Vendor listings',
            ),
            if (shown != null)
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  spacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'Updated ${formatManilaTimestamp(shown.currentAsOf)}',
                      style: muted,
                    ),
                    if (shown.datasetLabel != null)
                      _demoChip(shown.datasetLabel!),
                  ],
                ),
              ),
          ],
        ),
      if (_controller.summaryStale && summary != null)
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: StatusBand(
            tone: BandTone.warning,
            title: 'Showing the last successful update',
            message:
                'Counts from ${formatManilaTimestamp(summary.currentAsOf)} could not be refreshed. ${failure?.message ?? ''}',
            action: TextButton(
              onPressed: _controller.loadSummary,
              child: const Text('Retry'),
            ),
          ),
        ),
    ];
  }

  /// TEST data is always marked; the full label is announced to screen readers.
  Widget _demoChip(String label) => Semantics(
    container: true,
    label: label,
    excludeSemantics: true,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: BuyerTheme.canvas,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: BuyerTheme.border),
      ),
      child: const Text(
        'DEMO',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: BuyerTheme.muted,
        ),
      ),
    ),
  );

  Widget _analytics() {
    final message =
        _controller.summary?.analyticsMessage ??
        'Materials Analytics is not available yet.';
    return Semantics(
      button: true,
      enabled: false,
      label: 'View Materials Analytics. $message',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: BuyerTheme.border),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: BuyerTheme.brandSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                LucideIcons.chartLine,
                color: BuyerTheme.action,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'View Materials Analytics',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 12,
                      color: BuyerTheme.muted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              LucideIcons.lockKeyhole,
              size: 18,
              color: BuyerTheme.muted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _categories() {
    final summary = _controller.summaryPhase == LoadPhase.loading
        ? null
        : _controller.summary;
    if (_controller.origin == null) return const SizedBox.shrink();
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = MediaQuery.textScalerOf(context).scale(1);
        final minimum = scale > 1.3 ? 150.0 : 100.0;
        final columns = (constraints.maxWidth / minimum).floor().clamp(1, 8);
        final width = (constraints.maxWidth - (columns - 1) * 10) / columns;
        if (summary == null) {
          return Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (var index = 0; index < 6; index++)
                SizedBox(width: width, child: const SkeletonBox(height: 104)),
            ],
          );
        }
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final category in summary.categories)
              SizedBox(
                width: width,
                child: _CategoryTile(
                  category: category,
                  onTap: () => _openCategory(category),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _Count extends StatelessWidget {
  const _Count({
    required this.label,
    required this.value,
    required this.unit,
    this.announceUnit = true,
  });

  final String label;
  final int? value;
  final String unit;

  /// False when the unit only repeats the label (Nearby Verified Vendors: 12).
  final bool announceUnit;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: value == null
        ? '$label, loading'
        : '$label: $value${announceUnit ? ' $unit' : ''}',
    excludeSemantics: true,
    child: value == null
        ? const SkeletonBox(height: 12, width: 90)
        : Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$value',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                TextSpan(text: ' $unit'),
              ],
            ),
            style: const TextStyle(fontSize: 12, color: BuyerTheme.ink),
          ),
  );
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category, required this.onTap});

  final CategoryCountView category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    button: true,
    label:
        '${category.name}, ${category.vendorListings} Vendor listing${category.vendorListings == 1 ? '' : 's'}',
    excludeSemantics: true,
    child: Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: BuyerTheme.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 104),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 10),
            child: Column(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: BuyerTheme.brandSoft,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    categoryIcon(category.code),
                    size: 22,
                    color: BuyerTheme.actionPressed,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  category.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${category.vendorListings} listing${category.vendorListings == 1 ? '' : 's'}',
                  style: const TextStyle(fontSize: 11, color: BuyerTheme.muted),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

IconData categoryIcon(String code) => switch (code) {
  'CEMENT_AND_CONCRETE' || 'MASONRY' => LucideIcons.brickWall,
  'ROOFING_MATERIALS' => LucideIcons.house,
  'WOOD_AND_LUMBER' || 'LANDSCAPING_AND_EXTERIOR' => LucideIcons.trees,
  'STEEL_AND_REINFORCEMENT' ||
  'FORMWORKS_AND_SCAFFOLDING' => LucideIcons.construction,
  'TOOLS_AND_ACCESSORIES' || 'TOOLS_AND_EQUIPMENT' => LucideIcons.hammer,
  'FASTENERS_AND_HARDWARE' => LucideIcons.wrench,
  'ELECTRICAL_SUPPLIES' => LucideIcons.zap,
  'PLUMBING_AND_SANITARY' || 'DRAINAGE_AND_SEPTIC' => LucideIcons.droplets,
  'SANITARY_FIXTURES' => LucideIcons.bath,
  'FIRE_PROTECTION' => LucideIcons.flame,
  'PAINTS_AND_FINISHES' || 'FINISHING_MATERIALS' => LucideIcons.paintbrush,
  'ADHESIVES_AND_SEALANTS' ||
  'CONSTRUCTION_CHEMICALS' => LucideIcons.flaskConical,
  'DOORS_WINDOWS_AND_GLASS' => LucideIcons.doorOpen,
  'HVAC_MATERIALS' => LucideIcons.fan,
  'AGGREGATES' => LucideIcons.mountain,
  'FLOORING_MATERIALS' || 'WALL_AND_CEILING' => LucideIcons.layoutGrid,
  'INSULATION_AND_WATERPROOFING' => LucideIcons.umbrella,
  _ => LucideIcons.package,
};
