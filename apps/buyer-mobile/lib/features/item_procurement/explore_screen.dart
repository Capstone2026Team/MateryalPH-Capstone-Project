import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design_system/components/buyer_app_bar.dart';
import '../../design_system/components/discovery_controls.dart';
import '../../design_system/components/procurement_components.dart';
import '../../design_system/theme.dart';
import '../map_discovery/discovery_models.dart';
import '../notifications/buyer_notification_button.dart';
import 'cart_controller.dart';
import 'explore_controller.dart';
import 'procurement_models.dart';
import 'procurement_navigation.dart';

/// Catalog search and radius, followed by Materials Analytics and categories.
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

  void _openCategory([CategoryCountView? category]) {
    _controller.search(
      query: '',
      filters: ListingFilters(
        categoryId: category?.id,
        categoryName: category?.name,
      ),
      sort: () => null,
    );
    widget.navigation.openResults(context);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: buyerTabAppBar(
      context,
      'Materials Catalog',
      actions: [
        ListenableBuilder(
          listenable: widget.cart,
          builder: (context, _) => BuyerHeaderIconButton(
            icon: LucideIcons.shoppingCart,
            tooltip: widget.cart.lineCount > 0
                ? 'Cart, ${widget.cart.lineCount} lines'
                : 'Cart',
            badgeCount: widget.cart.lineCount,
            onPressed: () => widget.navigation.openCart(context),
          ),
        ),
        BuyerNotificationButton(onPressed: widget.onOpenNotifications),
      ],
    ),
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
              Row(
                children: [
                  Expanded(
                    child: PillSearchField(
                      onTap: () => widget.navigation.openSearch(context),
                    ),
                  ),
                  if (_controller.origin != null &&
                      _controller.summaryPhase != LoadPhase.needsOrigin) ...[
                    const SizedBox(width: 8),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.sizeOf(context).width * 0.35,
                      ),
                      child: _location(),
                    ),
                  ],
                ],
              ),
              if (_controller.origin == null ||
                  _controller.summaryPhase == LoadPhase.needsOrigin) ...[
                const SizedBox(height: 12),
                _location(),
              ],
              ..._summaryStatus(),
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

  Widget _location() {
    final origin = _controller.origin;
    if (_controller.summaryPhase == LoadPhase.needsOrigin || origin == null) {
      return StateMessage(
        kind: StateKind.needsLocation,
        artwork: 'assets/states/location.png',
        title: 'Choose a location first',
        message:
            'Products and prices depend on where you are buying for. Pick a location on the Map; GPS is optional.',
        actionLabel: 'Go to Map',
        onAction: widget.onOpenMap,
      );
    }
    return LocationSelector(
      label: origin.label,
      caption: 'Radius · ${_controller.radiusKm} km',
      showAddress: false,
      detail: 'Within ${_controller.radiusKm} km',
      onPressed: widget.onOpenMap,
    );
  }

  List<Widget> _summaryStatus() {
    if (_controller.origin == null ||
        (_controller.summaryPhase != LoadPhase.failed &&
            !_controller.summaryStale)) {
      return [];
    }
    final failure = _controller.summaryFailure;
    return [
      Padding(
        padding: const EdgeInsets.only(top: 12),
        child: StatusBand(
          tone: BandTone.warning,
          title: _controller.summaryStale
              ? 'Showing the last successful update'
              : failure?.kind == DiscoveryFailureKind.offline
              ? 'You are offline'
              : 'Catalog is unavailable',
          message: failure?.message,
          action: TextButton(
            onPressed: _controller.loadSummary,
            child: const Text('Retry'),
          ),
        ),
      ),
    ];
  }

  Widget _analytics() {
    final summary = _controller.summary;
    final enabled =
        summary != null &&
        summary.analyticsEnabled &&
        widget.navigation.analytics != null &&
        _controller.origin != null;
    final message = summary == null
        ? 'Daily local listed-price averages for comparable materials.'
        : summary.analyticsMessage;
    return Semantics(
      button: true,
      enabled: enabled,
      label: 'View Materials Analytics. $message',
      excludeSemantics: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: enabled
            ? () => widget.navigation.openMaterialsAnalytics(context)
            : null,
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
              Icon(
                enabled ? LucideIcons.chevronRight : LucideIcons.lockKeyhole,
                size: 18,
                color: BuyerTheme.muted,
              ),
            ],
          ),
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
            SizedBox(
              width: width,
              child: _CategoryTile(
                name: 'All',
                icon: LucideIcons.layoutGrid,
                vendorListings: summary.vendorListings,
                onTap: () => _openCategory(),
              ),
            ),
            for (final category in summary.categories)
              SizedBox(
                width: width,
                child: _CategoryTile(
                  name: category.name,
                  icon: categoryIcon(category.code),
                  vendorListings: category.vendorListings,
                  onTap: () => _openCategory(category),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.name,
    required this.icon,
    required this.vendorListings,
    required this.onTap,
  });

  final String name;
  final IconData icon;
  final int vendorListings;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    button: true,
    label:
        '$name, $vendorListings Vendor listing${vendorListings == 1 ? '' : 's'}',
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
                  child: Icon(icon, size: 22, color: BuyerTheme.actionPressed),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: MediaQuery.textScalerOf(context).scale(12) * 1.25 * 2,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Text(
                  '$vendorListings listing${vendorListings == 1 ? '' : 's'}',
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
