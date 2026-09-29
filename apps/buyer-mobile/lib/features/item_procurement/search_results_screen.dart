import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design_system/components/discovery_controls.dart';
import '../../design_system/components/procurement_components.dart';
import '../../design_system/theme.dart';
import '../map_discovery/discovery_models.dart';
import 'explore_controller.dart';
import 'procurement_models.dart';
import 'procurement_navigation.dart';

/// Search Results for Tier 2 listings only. Sort, filters and the scroll position live in the
/// shared controller and survive navigation; each card explains its ranking in text.
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
  late final ScrollController _scroll = ScrollController(
    initialScrollOffset: widget.controller.resultsScrollOffset,
  );
  late final TextEditingController _query = TextEditingController(
    text: widget.controller.query,
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
    _query.dispose();
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

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _controller,
    builder: (context, _) {
      final page = _controller.page;
      final personalized = page?.personalized ?? false;
      return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: TextField(
            controller: _query,
            textInputAction: TextInputAction.search,
            onSubmitted: (value) =>
                _controller.search(query: value, sort: () => null),
            decoration: const InputDecoration(
              hintText: 'Search materials',
              isDense: true,
              prefixIcon: Icon(LucideIcons.search),
            ),
          ),
          actions: [
            Badge(
              isLabelVisible: personalized,
              smallSize: 10,
              child: IconButton(
                tooltip: personalized
                    ? 'Ranking preferences, personalization active'
                    : 'Ranking preferences',
                onPressed: () => widget.navigation.openPreferences(context),
                icon: const Icon(LucideIcons.slidersHorizontal),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _controller.retrySearch,
            child: CustomScrollView(
              controller: _scroll,
              slivers: [
                SliverToBoxAdapter(child: _controls(personalized)),
                ..._results(),
              ],
            ),
          ),
        ),
      );
    },
  );

  Widget _controls(bool personalized) {
    final filters = _controller.filters;
    final sort = _controller.effectiveSort;
    final page = _controller.page;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            container: true,
            label: 'Sort results',
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final option in ListingSort.values)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        selected: option == sort,
                        showCheckmark: true,
                        label: Text(option.label),
                        onSelected: (_) =>
                            _controller.search(sort: () => option),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              FilterChip(
                label: const Text('Favorite Suppliers'),
                selected: filters.favoritesOnly,
                onSelected: (value) => _controller.search(
                  filters: filters.copyWith(favoritesOnly: value),
                ),
              ),
              FilterChip(
                label: const Text('Site Delivery'),
                selected: filters.fulfillment == 'DELIVERY',
                onSelected: (value) => _controller.search(
                  filters: filters.copyWith(
                    fulfillment: () => value ? 'DELIVERY' : null,
                  ),
                ),
              ),
              FilterChip(
                label: const Text('Self-Pickup'),
                selected: filters.fulfillment == 'PICKUP',
                onSelected: (value) => _controller.search(
                  filters: filters.copyWith(
                    fulfillment: () => value ? 'PICKUP' : null,
                  ),
                ),
              ),
              FilterChip(
                label: const Text('In Stock only'),
                selected: filters.inStockOnly,
                onSelected: (value) => _controller.search(
                  filters: filters.copyWith(inStockOnly: value),
                ),
              ),
              FilterChip(
                label: const Text('PS/ICC verified'),
                selected: filters.verifiedComplianceOnly,
                onSelected: (value) => _controller.search(
                  filters: filters.copyWith(verifiedComplianceOnly: value),
                ),
              ),
              if (filters.categoryId != null)
                InputChip(
                  label: Text(filters.categoryName ?? 'Category'),
                  onDeleted: () => _controller.search(
                    filters: filters.copyWith(
                      categoryId: () => null,
                      categoryName: () => null,
                    ),
                  ),
                  deleteButtonTooltipMessage: 'Remove category filter',
                ),
              if (filters.vendorId != null)
                InputChip(
                  label: Text(filters.vendorName ?? 'Store'),
                  onDeleted: () => _controller.search(
                    filters: filters.copyWith(
                      vendorId: () => null,
                      vendorName: () => null,
                    ),
                  ),
                  deleteButtonTooltipMessage: 'Remove store filter',
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (page != null && _controller.searchPhase == LoadPhase.ready)
            Semantics(
              liveRegion: true,
              child: Text(
                '${page.total} result${page.total == 1 ? '' : 's'} within ${_controller.radiusKm} km · ${sort.label} · updated ${formatManilaTimestamp(page.currentAsOf)}',
                style: const TextStyle(color: BuyerTheme.muted),
              ),
            ),
          if (personalized &&
              (sort == ListingSort.bestDeal ||
                  sort == ListingSort.favoritesFirst))
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  Icon(LucideIcons.userCog, size: 16, color: BuyerTheme.action),
                  SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      'Personalized ranking weights are active.',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
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
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  List<Widget> _results() {
    final phase = _controller.searchPhase;
    final failure = _controller.searchFailure;
    if (phase == LoadPhase.needsOrigin) {
      return [
        const SliverToBoxAdapter(
          child: StateMessage(
            kind: StateKind.needsLocation,
            title: 'Choose a location first',
            message:
                'Select a location on the Map to search nearby Verified Vendors.',
          ),
        ),
      ];
    }
    if (phase == LoadPhase.loading) {
      return [
        SliverList.builder(
          itemCount: 4,
          itemBuilder: (_, _) => const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SkeletonBox(height: 120),
          ),
        ),
      ];
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
      return [
        SliverToBoxAdapter(
          child: StateMessage(
            kind: StateKind.empty,
            title: 'No matching Verified Vendor listings',
            message: _controller.filters.activeCount > 0
                ? 'Try removing a filter.'
                : next != null
                ? 'Nothing matched within ${_controller.radiusKm} km.'
                : 'Nothing matched at the maximum radius.',
            actionLabel: _controller.filters.activeCount > 0
                ? 'Remove filters'
                : next != null
                ? 'Search within $next km'
                : null,
            onAction: _controller.filters.activeCount > 0
                ? _controller.clearFilters
                : next != null
                ? () => _expandRadius(next)
                : null,
          ),
        ),
      ];
    }
    return [
      SliverLayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.crossAxisExtent >= 720 ? 2 : 1;
          if (columns == 1) {
            return SliverList.builder(
              itemCount: results.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: ListingCard(
                  card: results[index],
                  onOpen: () => widget.navigation.openListing(
                    context,
                    results[index].listingId,
                  ),
                ),
              ),
            );
          }
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList.builder(
              itemCount: (results.length / 2).ceil(),
              itemBuilder: (context, row) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var column = 0; column < 2; column++) ...[
                        if (column == 1) const SizedBox(width: 12),
                        Expanded(
                          child: row * 2 + column < results.length
                              ? ListingCard(
                                  card: results[row * 2 + column],
                                  onOpen: () => widget.navigation.openListing(
                                    context,
                                    results[row * 2 + column].listingId,
                                  ),
                                )
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
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: _controller.loadingMore
              ? const Center(child: CircularProgressIndicator())
              : _controller.page?.hasMore == true
              ? OutlinedButton(
                  onPressed: _controller.loadMore,
                  child: const Text('Load more results'),
                )
              : const Text(
                  'Only Verified Vendor listings can be purchased. Directory Suppliers are never shown as inventory.',
                  style: TextStyle(fontSize: 12, color: BuyerTheme.muted),
                ),
        ),
      ),
    ];
  }
}

/// One Tier 2 listing with its best variant under the active sort.
class ListingCard extends StatelessWidget {
  const ListingCard({super.key, required this.card, required this.onOpen});

  final ListingCardView card;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final rating = card.ratingAverage == null ? 'New' : card.ratingLabel;
    final sold = formatQuantity(card.unitsSold);
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: BuyerTheme.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            button: true,
            label:
                '${card.displayName}, ${formatPeso(card.unitPriceCentavos)} per ${card.unitName}, ${card.stockLabel == 'IN_STOCK' ? 'In Stock' : 'Limited Stock'}, ${card.vendorName}, ${formatDistance(card.distanceMeters)} away${card.bestPrice ? ', Best Price' : ''}${card.isFavorite ? ', Favorite Supplier' : ''}. Open product details',
            excludeSemantics: true,
            child: InkWell(
              onTap: onOpen,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _thumbnail(),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            card.displayName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          if (card.variantLabel != null ||
                              card.optionsCount > 1)
                            Text(
                              [
                                ?card.variantLabel,
                                if (card.optionsCount > 1)
                                  '+${card.optionsCount - 1} more option${card.optionsCount == 2 ? '' : 's'}',
                              ].join(' · '),
                              style: const TextStyle(
                                fontSize: 12,
                                color: BuyerTheme.muted,
                              ),
                            ),
                          const SizedBox(height: 4),
                          Text(
                            '${formatPeso(card.unitPriceCentavos)} / ${card.unitName}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: BuyerTheme.actionPressed,
                            ),
                          ),
                          Text(
                            card.normalizedUnitPrice == null
                                ? '${card.vatLabel} · Not Yet Comparable'
                                : '${card.vatLabel} · ₱${double.parse(card.normalizedUnitPrice!).toStringAsFixed(2)} per ${card.canonicalUnitCode}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: BuyerTheme.muted,
                            ),
                          ),
                          const SizedBox(height: 4),
                          StockLabelText(label: card.stockLabel),
                          Text(
                            '$rating${sold == '0' ? '' : ' · $sold sold'}',
                            style: const TextStyle(fontSize: 13),
                          ),
                          Text(
                            '${card.vendorName} · ${card.vendorScore} · ${formatDistance(card.distanceMeters)}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13),
                          ),
                          Text(
                            [
                              if (card.pickupAvailable) 'Self-Pickup',
                              if (card.delivery == 'WITHIN_STATED_AREA')
                                'Site Delivery',
                              if (card.delivery == 'OUTSIDE_STATED_AREA')
                                'Delivery outside stated area',
                            ].join(' · '),
                            style: const TextStyle(
                              fontSize: 12,
                              color: BuyerTheme.muted,
                            ),
                          ),
                          if (card.badges.isNotEmpty || card.isFavorite) ...[
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: [
                                for (final badge in card.badges)
                                  ListingBadge(code: badge),
                                if (card.isFavorite)
                                  const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        LucideIcons.heart,
                                        size: 14,
                                        color: BuyerTheme.action,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Favorite Supplier',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 4),
                          Text(
                            'Stock confirmed ${formatManilaTimestamp(card.stockConfirmedAt)}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: BuyerTheme.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(height: 1),
          RankingExplanation(card: card),
        ],
      ),
    );
  }

  Widget _thumbnail() => ClipRRect(
    borderRadius: BorderRadius.circular(8),
    child: SizedBox(
      width: 72,
      height: 72,
      child: card.imageUrl == null
          ? const ColoredBox(
              color: BuyerTheme.canvas,
              child: Icon(LucideIcons.package, color: BuyerTheme.muted),
            )
          : Image.network(
              card.imageUrl!,
              fit: BoxFit.cover,
              semanticLabel: card.imageAlt,
              errorBuilder: (_, _, _) => const ColoredBox(
                color: BuyerTheme.canvas,
                child: Icon(LucideIcons.imageOff, color: BuyerTheme.muted),
              ),
            ),
    ),
  );
}

/// Ranking explanation as text rows in a disclosure panel, never a chart.
class RankingExplanation extends StatelessWidget {
  const RankingExplanation({super.key, required this.card});

  final ListingCardView card;

  @override
  Widget build(BuildContext context) => Theme(
    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
    child: ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 12),
      childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      title: Text(
        'Why this ranking · Best Deal score ${card.srs}',
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
      children: [
        for (final component in card.components)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Semantics(
              container: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${component.label}: ${component.score} × ${component.weightPercent}% = ${component.weighted}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    component.basis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: BuyerTheme.muted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        const Text(
          'Scores are normalized to 0–100 and combined as a weighted sum. Ties break by distance, then price, then listing.',
          style: TextStyle(fontSize: 12, color: BuyerTheme.muted),
        ),
      ],
    ),
  );
}
