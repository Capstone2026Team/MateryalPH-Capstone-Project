import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design_system/components/procurement_components.dart';
import '../../design_system/theme.dart';
import '../map_discovery/discovery_models.dart';
import 'cart_controller.dart';
import 'explore_controller.dart';
import 'procurement_models.dart';
import 'procurement_navigation.dart';

/// Explore Materials Catalog. The MAT-01 dashboard sits above the categories: Nearby Verified
/// Vendors and Available Products (Vendor listings) from one server snapshot with its own time and
/// scope, and an explicitly unavailable Materials Analytics entry until that feature ships.
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({
    super.key,
    required this.controller,
    required this.cart,
    required this.navigation,
    required this.onOpenMap,
  });

  final ExploreController controller;
  final CartController cart;
  final ProcurementNavigation navigation;
  final VoidCallback onOpenMap;

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late final ScrollController _scroll = ScrollController(
    initialScrollOffset: widget.controller.exploreScrollOffset,
  );
  final TextEditingController _query = TextEditingController();

  ExploreController get _controller => widget.controller;

  @override
  void initState() {
    super.initState();
    _query.text = _controller.query;
    _scroll.addListener(
      () => _controller.rememberExploreScroll(_scroll.offset),
    );
    if (_controller.summary == null) _controller.loadSummary();
  }

  @override
  void dispose() {
    _scroll.dispose();
    _query.dispose();
    super.dispose();
  }

  void _openSearch({String? query, ListingFilters? filters}) {
    _controller.search(
      query: query ?? _query.text,
      filters: filters ?? const ListingFilters(),
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
              const SizedBox(height: 12),
              _searchField(),
              const SizedBox(height: 8),
              _shortcuts(),
              ..._dashboard(),
              SectionHeading('All categories'),
              _categories(),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _header() {
    final origin = _controller.origin;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(
                  'Materials Catalog',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Row(
                children: [
                  const Icon(
                    LucideIcons.mapPin,
                    size: 16,
                    color: BuyerTheme.action,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      origin == null
                          ? 'No location selected'
                          : '${origin.label} · ${_controller.radiusKm} km',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: BuyerTheme.muted),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Badge(
          isLabelVisible: widget.cart.lineCount > 0,
          label: Text('${widget.cart.lineCount}'),
          child: IconButton(
            tooltip: widget.cart.lineCount > 0
                ? 'Cart, ${widget.cart.lineCount} lines'
                : 'Cart',
            onPressed: () => widget.navigation.openCart(context),
            icon: const Icon(LucideIcons.shoppingCart),
          ),
        ),
      ],
    );
  }

  Widget _searchField() => TextField(
    controller: _query,
    textInputAction: TextInputAction.search,
    onSubmitted: (value) => _openSearch(query: value),
    decoration: InputDecoration(
      labelText: 'Search materials',
      hintText: 'e.g. hollow block, deformed bar',
      prefixIcon: const Icon(LucideIcons.search),
      suffixIcon: IconButton(
        tooltip: 'Search',
        onPressed: () => _openSearch(),
        icon: const Icon(LucideIcons.arrowRight),
      ),
    ),
  );

  Widget _shortcuts() => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      ActionChip(
        avatar: const Icon(LucideIcons.slidersHorizontal, size: 18),
        label: const Text('Ranking preferences'),
        onPressed: () => widget.navigation.openPreferences(context),
      ),
      ActionChip(
        avatar: const Icon(LucideIcons.heart, size: 18),
        label: const Text('Favorite Suppliers'),
        onPressed: () => _openSearch(
          query: '',
          filters: const ListingFilters(favoritesOnly: true),
        ),
      ),
    ],
  );

  List<Widget> _dashboard() {
    final summary = _controller.summary;
    final failure = _controller.summaryFailure;
    if (_controller.summaryPhase == LoadPhase.needsOrigin) {
      return [
        StateMessage(
          kind: StateKind.needsLocation,
          title: 'Choose a location first',
          message:
              'Counts and products depend on where you are buying for. Pick a location on the Map; GPS is optional.',
          actionLabel: 'Go to Map',
          onAction: widget.onOpenMap,
        ),
      ];
    }
    if (_controller.summaryPhase == LoadPhase.failed && summary == null) {
      return [
        StateMessage(
          kind: failure?.kind == DiscoveryFailureKind.offline
              ? StateKind.offline
              : StateKind.error,
          title: failure?.kind == DiscoveryFailureKind.offline
              ? 'You are offline'
              : 'Nearby counts are unavailable',
          message: failure?.message ?? 'Please retry.',
          actionLabel: 'Retry',
          onAction: _controller.loadSummary,
        ),
      ];
    }
    final loading = _controller.summaryPhase == LoadPhase.loading;
    // While loading, never show the previous scope's numbers as if they were current.
    final shown = loading ? null : summary;
    return [
      const SizedBox(height: 16),
      if (_controller.summaryStale && summary != null)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
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
      LayoutBuilder(
        builder: (context, constraints) {
          final stacked =
              constraints.maxWidth < 340 ||
              MediaQuery.textScalerOf(context).scale(1) > 1.5;
          final cards = [
            SummaryCountCard(
              label: shown?.vendorsLabel ?? 'Nearby Verified Vendors',
              icon: LucideIcons.store,
              value: shown?.verifiedVendors,
            ),
            SummaryCountCard(
              label: shown?.listingsLabel ?? 'Available Products',
              icon: LucideIcons.package,
              value: shown?.vendorListings,
              unit: shown?.listingsUnit ?? 'Vendor listings',
            ),
          ];
          return stacked
              ? Column(
                  children: [cards[0], const SizedBox(height: 8), cards[1]],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: cards[0]),
                    const SizedBox(width: 8),
                    Expanded(child: cards[1]),
                  ],
                );
        },
      ),
      const SizedBox(height: 8),
      if (shown != null) ...[
        Text(
          '${shown.scopeLabel} · before category or search filters',
          style: const TextStyle(fontSize: 13, color: BuyerTheme.muted),
        ),
        Text(
          'Current as of ${formatManilaTimestamp(shown.currentAsOf)}',
          style: const TextStyle(fontSize: 13, color: BuyerTheme.muted),
        ),
        if (shown.datasetLabel != null)
          Text(
            shown.datasetLabel!,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: BuyerTheme.muted,
            ),
          ),
      ] else
        const SkeletonBox(height: 14, width: 220),
      const SizedBox(height: 12),
      Semantics(
        button: true,
        enabled: false,
        label:
            'View Materials Analytics, unavailable. ${shown?.analyticsMessage ?? 'Materials Analytics is not available yet.'}',
        excludeSemantics: true,
        child: OutlinedButton.icon(
          onPressed: shown?.analyticsEnabled == true ? () {} : null,
          icon: const Icon(LucideIcons.chartLine),
          label: const Text('View Materials Analytics'),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          shown?.analyticsMessage ??
              'Materials Analytics is not available yet.',
          style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
        ),
      ),
    ];
  }

  Widget _categories() {
    final summary = _controller.summaryPhase == LoadPhase.loading
        ? null
        : _controller.summary;
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = MediaQuery.textScalerOf(context).scale(1);
        final columns = constraints.maxWidth >= 720
            ? 4
            : constraints.maxWidth >= 340 && scale <= 1.5
            ? 2
            : 1;
        final width = (constraints.maxWidth - (columns - 1) * 8) / columns;
        if (summary == null) {
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var index = 0; index < 6; index++)
                SizedBox(width: width, child: const SkeletonBox(height: 64)),
            ],
          );
        }
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final category in summary.categories)
              SizedBox(
                width: width,
                child: _CategoryTile(
                  category: category,
                  onTap: () => _openSearch(
                    query: '',
                    filters: ListingFilters(
                      categoryId: category.id,
                      categoryName: category.name,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category, required this.onTap});

  final CategoryCountView category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label:
        '${category.name}, ${category.vendorListings} Vendor listing${category.vendorListings == 1 ? '' : 's'}',
    excludeSemantics: true,
    child: Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: BuyerTheme.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 64),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '${category.vendorListings} Vendor listing${category.vendorListings == 1 ? '' : 's'}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: BuyerTheme.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: BuyerTheme.brandSoft,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    categoryIcon(category.code),
                    size: 22,
                    color: BuyerTheme.actionPressed,
                  ),
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
