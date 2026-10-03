import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design_system/components/discovery_controls.dart';
import '../../design_system/components/procurement_components.dart';
import '../../design_system/generated/color_tokens.dart';
import '../../design_system/theme.dart';
import '../map_discovery/discovery_models.dart';
import 'explore_controller.dart';
import 'procurement_models.dart';
import 'procurement_navigation.dart';

/// Search state and pagination remain in the shared controller across navigation.
class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({
    super.key,
    required this.controller,
    required this.navigation,
  });
  final ExploreController controller;
  final ProcurementNavigation navigation;
  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late final _scroll = ScrollController(
    initialScrollOffset: _controller.resultsScrollOffset,
  );
  ExploreController get _controller => widget.controller;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      _controller.rememberResultsScroll(_scroll.offset);
      if (_scroll.position.extentAfter < 400) _controller.loadMore();
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _expandRadius(int next) async {
    final confirmed = await confirmRadiusExpansion(
      context,
      fromKm: _controller.radiusKm,
      toKm: next,
      verifiedCount: 0,
    );
    if (confirmed) await _controller.discovery.selectRadius(next);
  }

  Future<void> _favorite(ListingCardView card) async {
    try {
      await _controller.setFavorite(card.vendorId, favorite: !card.isFavorite);
    } on DiscoveryFailure catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      }
    }
  }

  void _sortBy(ListingSort option) {
    final sort = _controller.effectiveSort;
    _controller.search(
      sort: () => sort.family == option ? sort.reversed : option,
    );
  }

  Future<void> _chooseRelevance() async {
    final current = _controller.effectiveSort;
    final choice = await showModalBottomSheet<ListingSort>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _SheetTitle('Sort by relevance'),
            for (final (option, detail) in const [
              (
                ListingSort.bestDeal,
                'Ranked by the Best Deal score: distance, price, VPS, stock and product rating.',
              ),
              (
                ListingSort.favoritesFirst,
                'Your Favorite Suppliers first, then Best Deal. Best Deal itself never changes.',
              ),
            ])
              ListTile(
                selected: current == option,
                leading: Icon(
                  current == option
                      ? LucideIcons.circleCheck
                      : LucideIcons.circle,
                ),
                title: Text(option.label),
                subtitle: Text(detail),
                onTap: () => Navigator.pop(context, option),
              ),
            const Divider(height: 16),
            ListTile(
              leading: const Icon(LucideIcons.slidersHorizontal),
              title: const Text('Ranking preferences'),
              subtitle: const Text('Adjust the Best Deal weights'),
              trailing: const Icon(LucideIcons.chevronRight),
              onTap: () {
                Navigator.pop(context);
                widget.navigation.openPreferences(this.context);
              },
            ),
          ],
        ),
      ),
    );
    if (choice != null && choice != current) {
      _controller.search(sort: () => choice);
    }
  }

  Future<void> _chooseRadius() async {
    final selected = await showModalBottomSheet<int>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _SheetTitle('Search radius'),
            for (final km in kDiscoveryRadiiKm)
              ListTile(
                selected: km == _controller.radiusKm,
                leading: Icon(
                  km == _controller.radiusKm
                      ? LucideIcons.circleCheck
                      : LucideIcons.circle,
                ),
                title: Text('Within $km km'),
                onTap: () => Navigator.pop(context, km),
              ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Text(
                'The same radius is used on the Map.',
                style: TextStyle(fontSize: 12, color: BuyerTheme.muted),
              ),
            ),
          ],
        ),
      ),
    );
    if (selected != null && selected != _controller.radiusKm) {
      await _controller.discovery.selectRadius(selected);
    }
  }

  void _explain(ListingCardView card) => showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (context) => SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: RankingExplanation(card: card),
    ),
  );

  String? get _title {
    final filters = _controller.filters;
    if (filters.categoryName != null) return '${filters.categoryName} Catalog';
    if (filters.vendorName != null) return '${filters.vendorName} Catalog';
    return _controller.query.isEmpty ? 'Product Catalog' : null;
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: Listenable.merge([_controller, widget.navigation.cart]),
    builder: (context, _) => Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _controller.retrySearch,
          child: CustomScrollView(
            controller: _scroll,
            slivers: [
              SliverToBoxAdapter(child: _header()),
              SliverToBoxAdapter(child: _status()),
              ..._results(),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _cartButton() => IconButton(
    tooltip: 'Cart',
    onPressed: () => widget.navigation.openCart(context),
    icon: Badge(
      isLabelVisible: widget.navigation.cart.lineCount > 0,
      backgroundColor: BuyerTheme.ink,
      label: Text('${widget.navigation.cart.lineCount}'),
      child: const Icon(LucideIcons.shoppingCart, color: BuyerTheme.ink),
    ),
  );

  Widget _header() {
    final filters = _controller.filters;
    final sort = _controller.effectiveSort;
    final personalized = _controller.page?.personalized ?? false;
    final title = _title;
    final canPop = ModalRoute.of(context)?.canPop ?? false;
    return ColoredBox(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 4, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Semantics(
                      header: true,
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  _cartButton(),
                ],
              ),
            ),
          Padding(
            padding: EdgeInsets.fromLTRB(canPop ? 4 : 16, 8, 4, 8),
            child: Row(
              children: [
                if (canPop)
                  RoundIconButton(
                    icon: LucideIcons.arrowLeft,
                    tooltip: 'Back',
                    filled: true,
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                Expanded(
                  child: PillSearchField(
                    text: _controller.query,
                    onTap: () => widget.navigation.openSearch(
                      context,
                      fromResults: true,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: personalized
                      ? 'Ranking preferences, personalization active'
                      : 'Ranking preferences',
                  onPressed: () => widget.navigation.openPreferences(context),
                  icon: Badge(
                    isLabelVisible: personalized,
                    smallSize: 8,
                    backgroundColor: BuyerTheme.ink,
                    child: const Icon(
                      LucideIcons.slidersHorizontal,
                      color: BuyerTheme.action,
                    ),
                  ),
                ),
                if (title == null) _cartButton(),
              ],
            ),
          ),
          SortTabBar(
            items: [
              SortTabItem(
                label: sort == ListingSort.favoritesFirst
                    ? ListingSort.favoritesFirst.label
                    : ListingSort.bestDeal.label,
                selected:
                    sort == ListingSort.bestDeal ||
                    sort == ListingSort.favoritesFirst,
                menu: true,
                onTap: _chooseRelevance,
              ),
              for (final option in const [
                ListingSort.distance,
                ListingSort.rating,
                ListingSort.price,
              ])
                SortTabItem(
                  label: option.label,
                  selected: sort.family == option,
                  directional: true,
                  descending: sort.descending,
                  onTap: () => _sortBy(option),
                ),
            ],
          ),
          FilterPillRow(
            pills: [
              FilterPill(
                label: 'Radius ${_controller.radiusKm} km',
                selected: false,
                trailingIcon: LucideIcons.chevronDown,
                onTap: _chooseRadius,
              ),
              FilterPill(
                label: 'Favorite Suppliers',
                selected: filters.favoritesOnly,
                onTap: () => _controller.search(
                  filters: filters.copyWith(
                    favoritesOnly: !filters.favoritesOnly,
                  ),
                ),
              ),
              for (final (method, label) in const [
                ('DELIVERY', 'Site Delivery'),
                ('PICKUP', 'Self-Pickup'),
              ])
                FilterPill(
                  label: label,
                  selected: filters.fulfillment == method,
                  onTap: () => _controller.search(
                    filters: filters.copyWith(
                      fulfillment: () =>
                          filters.fulfillment == method ? null : method,
                    ),
                  ),
                ),
              FilterPill(
                label: 'In Stock only',
                selected: filters.inStockOnly,
                onTap: () => _controller.search(
                  filters: filters.copyWith(inStockOnly: !filters.inStockOnly),
                ),
              ),
              FilterPill(
                label: 'PS/ICC verified',
                selected: filters.verifiedComplianceOnly,
                onTap: () => _controller.search(
                  filters: filters.copyWith(
                    verifiedComplianceOnly: !filters.verifiedComplianceOnly,
                  ),
                ),
              ),
              if (filters.categoryId != null)
                FilterPill(
                  label: filters.categoryName ?? 'Category',
                  selected: true,
                  onTap: null,
                  deleteTooltip: 'Remove category filter',
                  onDeleted: () => _controller.search(
                    filters: filters.copyWith(
                      categoryId: () => null,
                      categoryName: () => null,
                    ),
                  ),
                ),
              if (filters.vendorId != null)
                FilterPill(
                  label: filters.vendorName ?? 'Store',
                  selected: true,
                  onTap: null,
                  deleteTooltip: 'Remove store filter',
                  onDeleted: () => _controller.search(
                    filters: filters.copyWith(
                      vendorId: () => null,
                      vendorName: () => null,
                    ),
                  ),
                ),
            ],
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }

  Widget _status() {
    final page = _controller.page;
    final sort = _controller.effectiveSort;
    final personalized = page?.personalized ?? false;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (page != null && _controller.searchPhase == LoadPhase.ready)
            Text(
              '${page.total} result${page.total == 1 ? '' : 's'} within ${_controller.radiusKm} km · ${sort.label} · updated ${formatManilaTimestamp(page.currentAsOf)}',
              style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
            ),
          if (personalized &&
              (sort == ListingSort.bestDeal ||
                  sort == ListingSort.favoritesFirst))
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Text(
                'Personalized ranking weights are active.',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          if (_controller.searchFailure != null &&
              _controller.results.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: StatusBand(
                tone: BandTone.warning,
                title: 'These results may be out of date',
                message: _controller.searchFailure!.message,
                action: TextButton(
                  onPressed: _controller.retrySearch,
                  child: const Text('Retry'),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Columns follow the available width and text size, so cards never squeeze text at 2x.
  int _columns(double width) {
    final scale = MediaQuery.textScalerOf(context).scale(1);
    final minimum = scale > 1.3 ? 300.0 : 160.0;
    return (width / minimum).floor().clamp(1, 6);
  }

  Widget _grid({
    required int count,
    required Widget Function(int index) item,
  }) => SliverLayoutBuilder(
    builder: (context, constraints) {
      final columns = _columns(constraints.crossAxisExtent - 24);
      return SliverPadding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
        sliver: SliverList.builder(
          itemCount: (count / columns).ceil(),
          itemBuilder: (context, row) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var column = 0; column < columns; column++) ...[
                    if (column > 0) const SizedBox(width: 10),
                    Expanded(
                      child: row * columns + column < count
                          ? item(row * columns + column)
                          : const SizedBox.shrink(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    },
  );

  List<Widget> _results() {
    final phase = _controller.searchPhase;
    final failure = _controller.searchFailure;
    if (phase == LoadPhase.needsOrigin) {
      return [
        SliverToBoxAdapter(
          child: StateMessage(
            kind: StateKind.needsLocation,
            artwork: 'assets/states/location.png',
            title: 'Choose a location first',
            message:
                'Select a location on the Map to search nearby Verified Vendors.',
            actionLabel: 'Set location',
            onAction: () => widget.navigation.openLocation(context),
          ),
        ),
      ];
    }
    if (phase == LoadPhase.loading) {
      return [_grid(count: 4, item: (_) => const SkeletonBox(height: 250))];
    }
    if (phase == LoadPhase.failed) {
      return [
        SliverToBoxAdapter(
          child: StateMessage(
            kind: failure?.kind == DiscoveryFailureKind.offline
                ? StateKind.offline
                : StateKind.error,
            title: failure?.kind == DiscoveryFailureKind.offline
                ? 'You are offline'
                : 'Results could not load',
            message: failure?.message ?? 'Please retry.',
            actionLabel: 'Retry',
            onAction: _controller.retrySearch,
          ),
        ),
      ];
    }
    final results = _controller.results;
    if (results.isEmpty) {
      final next = _controller.page?.suggestedRadiusKm;
      final filtered = _controller.filters.activeCount > 0;
      return [
        SliverToBoxAdapter(
          child: StateMessage(
            kind: StateKind.empty,
            artwork: 'assets/states/location.png',
            title: 'Search not found',
            message: filtered
                ? 'No Verified Vendor listings match the current filters within ${_controller.radiusKm} km. Try removing a filter.'
                : 'No matching Verified Vendor listings within ${_controller.radiusKm} km. Try another search or a wider radius.',
            actionLabel: filtered
                ? 'Remove filters'
                : next != null
                ? 'Search within $next km'
                : 'Change search',
            onAction: filtered
                ? _controller.clearFilters
                : next != null
                ? () => _expandRadius(next)
                : () =>
                      widget.navigation.openSearch(context, fromResults: true),
          ),
        ),
      ];
    }
    return [
      _grid(
        count: results.length,
        item: (index) => ListingCard(
          card: results[index],
          onOpen: () =>
              widget.navigation.openListing(context, results[index].listingId),
          onFavorite: _controller.favoriteBusy(results[index].vendorId)
              ? null
              : () => _favorite(results[index]),
          onExplain: () => _explain(results[index]),
        ),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          child: _controller.loadingMore
              ? const Center(child: CircularProgressIndicator())
              : _controller.page?.hasMore == true
              ? OutlinedButton(
                  onPressed: _controller.loadMore,
                  child: const Text('Load more results'),
                )
              : const SizedBox.shrink(),
        ),
      ),
    ];
  }
}

class _SheetTitle extends StatelessWidget {
  const _SheetTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
    child: Semantics(
      header: true,
      child: Text(text, style: Theme.of(context).textTheme.titleLarge),
    ),
  );
}

/// One Tier 2 listing as a catalog card, using its server-selected variant under the active sort.
class ListingCard extends StatelessWidget {
  const ListingCard({
    super.key,
    required this.card,
    required this.onOpen,
    this.onFavorite,
    this.onExplain,
    this.showFavorite = true,
  });

  /// False where the card is already inside one store's page, where a store Favorite adds nothing.
  final bool showFavorite;
  final ListingCardView card;
  final VoidCallback onOpen;
  final VoidCallback? onFavorite;
  final VoidCallback? onExplain;

  @override
  Widget build(BuildContext context) {
    final sold = formatQuantity(card.unitsSold);
    final delivery = card.delivery != 'NOT_OFFERED';
    return Material(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: BuyerTheme.border),
      ),
      child: Semantics(
        button: true,
        label: 'Open product details',
        child: InkWell(
          onTap: onOpen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 1.15,
                    child: ColoredBox(
                      color: BuyerTheme.canvas,
                      child: card.imageUrl == null
                          ? const Icon(
                              LucideIcons.package,
                              size: 36,
                              color: BuyerTheme.muted,
                            )
                          : Image.network(
                              card.imageUrl!,
                              fit: BoxFit.cover,
                              cacheWidth: 480,
                              semanticLabel: card.imageAlt,
                              errorBuilder: (_, _, _) => const Icon(
                                LucideIcons.imageOff,
                                color: BuyerTheme.muted,
                              ),
                            ),
                    ),
                  ),
                  if (card.bestPrice)
                    const Positioned(
                      left: 8,
                      top: 8,
                      right: 52,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: ListingBadge(code: 'BEST_PRICE', solid: true),
                      ),
                    ),
                  if (showFavorite)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: RoundIconButton(
                        icon: card.isFavorite
                            ? LucideIcons.heartOff
                            : LucideIcons.heart,
                        tooltip: card.isFavorite
                            ? 'Remove Favorite Supplier ${card.vendorName}'
                            : 'Save ${card.vendorName} as a Favorite Supplier',
                        onPressed: onFavorite,
                      ),
                    ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.displayName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.3,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (card.variantLabel != null || card.optionsCount > 1)
                        Text(
                          [
                            ?card.variantLabel,
                            if (card.optionsCount > 1)
                              '+${card.optionsCount - 1} more option${card.optionsCount == 2 ? '' : 's'}',
                          ].join(' · '),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: BuyerTheme.muted,
                          ),
                        ),
                      const SizedBox(height: 4),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: formatPeso(card.unitPriceCentavos),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            TextSpan(
                              text: ' / ${card.unitName}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        style: const TextStyle(color: BuyerTheme.action),
                      ),
                      Text(
                        card.normalizedUnitPrice == null
                            ? '${card.vatLabel} · Not Yet Comparable'
                            : '${card.vatLabel} · ₱${double.parse(card.normalizedUnitPrice!).toStringAsFixed(2)} per ${card.canonicalUnitCode}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: BuyerTheme.muted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 8,
                        runSpacing: 2,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          StockLabelText(label: card.stockLabel, compact: true),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                LucideIcons.star,
                                size: 13,
                                color: Color(MateryalColorTokens.statusWarning),
                              ),
                              const SizedBox(width: 2),
                              Flexible(
                                child: Text(
                                  '${card.ratingAverage == null ? 'New' : card.ratingLabel}${sold == '0' ? '' : ' | $sold sold'}',
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        card.vendorName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${card.vendorScore} · ${formatDistance(card.distanceMeters)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: BuyerTheme.muted,
                        ),
                      ),
                      const Spacer(),
                      const Divider(height: 14),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          if (delivery)
                            const _Fulfillment(
                              icon: LucideIcons.truck,
                              label: 'Site Delivery',
                            ),
                          if (card.pickupAvailable)
                            const _Fulfillment(
                              icon: LucideIcons.store,
                              label: 'Self-Pickup',
                            ),
                          if (card.psIccVerified)
                            const ListingBadge(
                              code: 'PS_ICC_VERIFIED',
                              solid: true,
                            ),
                        ],
                      ),
                      Text(
                        'Stock confirmed ${formatManilaTimestamp(card.stockConfirmedAt)}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: BuyerTheme.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (onExplain != null)
                TextButton.icon(
                  onPressed: onExplain,
                  style: TextButton.styleFrom(
                    minimumSize: const Size(0, 44),
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    textStyle: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  icon: const Icon(LucideIcons.info, size: 16),
                  label: const Text('Why this ranking'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Fulfillment extends StatelessWidget {
  const _Fulfillment({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 13, color: BuyerTheme.successStrong),
      const SizedBox(width: 3),
      Flexible(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: BuyerTheme.successStrong,
          ),
        ),
      ),
    ],
  );
}

class RankingExplanation extends StatelessWidget {
  const RankingExplanation({super.key, required this.card});
  final ListingCardView card;
  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Semantics(
        header: true,
        child: Text(
          'Why this ranking',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        '${card.displayName} · Best Deal score ${card.srs}',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      const Divider(height: 24),
      for (final component in card.components)
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${component.label}: ${component.score} × ${component.weightPercent}% = ${component.weighted}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                component.basis,
                style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
              ),
            ],
          ),
        ),
      const Text(
        'Scores are normalized to 0–100 and combined as a weighted sum. Ties break by distance, then price, then listing.',
        style: TextStyle(fontSize: 12, color: BuyerTheme.muted),
      ),
    ],
  );
}
