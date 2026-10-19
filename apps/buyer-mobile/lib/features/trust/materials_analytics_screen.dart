import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design_system/components/buyer_app_bar.dart';
import '../../design_system/components/price_trend_chart.dart';
import '../../design_system/components/procurement_components.dart';
import '../../design_system/theme.dart';
import '../item_procurement/procurement_models.dart' show formatManilaTimestamp;
import '../map_discovery/discovery_models.dart';
import 'analytics_repository.dart';
import 'trust_models.dart';

const _periods = ['7 days', '30 days', '90 days', 'Custom'];
const _presetDays = [7, 30, 90];

String _isoDay(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

/// Explore → Materials Analytics: comparable variants grouped by category for the origin and exact
/// radius inherited from Explore. Daily averages are public listed prices with equal weight per
/// seller; current seller counts and history carry separate timestamps.
class MaterialsAnalyticsScreen extends StatefulWidget {
  const MaterialsAnalyticsScreen({
    super.key,
    required this.repository,
    required this.origin,
    required this.radiusKm,
    required this.onOpenListing,
    this.originLabel,
  });

  final AnalyticsRepository repository;
  final DiscoveryOrigin origin;
  final int radiusKm;
  final String? originLabel;
  final void Function(BuildContext context, String listingId) onOpenListing;

  @override
  State<MaterialsAnalyticsScreen> createState() =>
      _MaterialsAnalyticsScreenState();
}

class _MaterialsAnalyticsScreenState extends State<MaterialsAnalyticsScreen> {
  AnalyticsWindowChoice _window = const AnalyticsWindowChoice.preset(30);
  final _search = TextEditingController();
  String _query = '';
  MaterialsAnalyticsPage? _page;
  List<ComparableGroupView> _items = const [];
  DiscoveryFailure? _failure;
  bool _loading = true;
  bool _loadingMore = false;
  int _request = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _load({bool more = false}) async {
    final request = ++_request;
    setState(() {
      if (more) {
        _loadingMore = true;
      } else {
        _loading = true;
        _failure = null;
      }
    });
    try {
      final page = await widget.repository.list(
        origin: widget.origin,
        radiusKm: widget.radiusKm,
        window: _window,
        query: _query,
        cursor: more ? _page?.nextCursor : null,
      );
      // A newer scope supersedes a slower response.
      if (!mounted || request != _request) return;
      setState(() {
        _page = page;
        _items = more ? [..._items, ...page.items] : page.items;
      });
    } on DiscoveryFailure catch (failure) {
      if (mounted && request == _request) setState(() => _failure = failure);
    } finally {
      if (mounted && request == _request) {
        setState(() {
          _loading = false;
          _loadingMore = false;
        });
      }
    }
  }

  Future<void> _choosePeriod(int index) async {
    if (index < 3) {
      setState(
        () => _window = AnalyticsWindowChoice.preset(_presetDays[index]),
      );
      return _load();
    }
    final today = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: today.subtract(const Duration(days: 730)),
      lastDate: today,
      helpText: 'Choose up to 365 days',
    );
    if (range == null || !mounted) return;
    if (!range.end.isAfter(range.start) ||
        range.end.difference(range.start).inDays > 365) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Choose a start date before the end date, at most 365 days apart.',
          ),
        ),
      );
      return;
    }
    setState(
      () => _window = AnalyticsWindowChoice.custom(
        _isoDay(range.start),
        _isoDay(range.end),
      ),
    );
    await _load();
  }

  int get _selectedPeriod =>
      _window.isCustom ? 3 : _presetDays.indexOf(_window.presetDays ?? 30);

  void _submitSearch(String value) {
    _query = value.trim();
    _load();
  }

  void _clearSearch() {
    _search.clear();
    _submitSearch('');
  }

  void _openDetails(ComparableGroupView item) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => MaterialPriceDetailsScreen(
        repository: widget.repository,
        origin: widget.origin,
        radiusKm: widget.radiusKm,
        groupId: item.groupId,
        window: _window,
        onOpenListing: widget.onOpenListing,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final groups = <String, List<ComparableGroupView>>{};
    for (final item in _items) {
      groups.putIfAbsent(item.categoryName, () => []).add(item);
    }
    final envelope = _page?.envelope;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buyerAppBar(context, 'Materials Analytics'),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _load,
          child: ListView(
            key: const PageStorageKey('materials-analytics'),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              _ScopeCard(
                area:
                    'Within ${widget.radiusKm} km of ${widget.originLabel ?? widget.origin.label}',
                selected: _selectedPeriod,
                onPeriod: _choosePeriod,
                customRange: _window.isCustom
                    ? '${analyticsDayLabel(_window.startDate!, year: true)} → ${analyticsDayLabel(_window.endDate!, year: true)}'
                    : null,
              ),
              const SizedBox(height: 12),
              PillSearchField(
                controller: _search,
                hintText: 'Search materials',
                onSubmitted: _submitSearch,
                onSearch: () => _submitSearch(_search.text),
                onClear: _query.isEmpty ? null : _clearSearch,
              ),
              const SizedBox(height: 12),
              if (envelope != null) _DatasetBand(envelope: envelope),
              const SizedBox(height: 4),
              if (_loading)
                ...List.generate(
                  3,
                  (_) => const Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: SkeletonBox(height: 132),
                  ),
                )
              else if (_failure != null)
                StatusBand(
                  tone: BandTone.warning,
                  title: _failure!.kind == DiscoveryFailureKind.offline
                      ? 'You are offline'
                      : 'Materials Analytics is unavailable',
                  message: _failure!.message,
                  action: TextButton(
                    onPressed: _load,
                    child: const Text('Retry'),
                  ),
                )
              else if (_items.isEmpty)
                StateMessage(
                  kind: StateKind.empty,
                  compact: true,
                  title: 'No comparable materials here yet',
                  message: envelope?.latestDate == null
                      ? 'No daily price snapshot has been published yet. Prices are captured daily at 00:10 Asia/Manila.'
                      : 'No comparable listing or recorded price matches this area and period. Try a larger radius on the Map or a longer period.',
                  actionLabel: _query.isEmpty ? null : 'Clear search',
                  onAction: _query.isEmpty ? null : _clearSearch,
                )
              else ...[
                for (final entry in groups.entries) ...[
                  _CategoryHeading(name: entry.key, count: entry.value.length),
                  for (final item in entry.value)
                    _AnalyticsRow(item: item, onOpen: () => _openDetails(item)),
                ],
                if (_page?.nextCursor != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: OutlinedButton(
                      onPressed: _loadingMore ? null : () => _load(more: true),
                      child: Text(_loadingMore ? 'Loading…' : 'Load more'),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// The inherited area and the history period, kept together so the scope reads as one choice.
class _ScopeCard extends StatelessWidget {
  const _ScopeCard({
    required this.area,
    required this.selected,
    required this.onPeriod,
    this.customRange,
  });

  final String area;
  final int selected;
  final ValueChanged<int> onPeriod;
  final String? customRange;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: BuyerTheme.canvas,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Icon(
                LucideIcons.mapPin,
                size: 18,
                color: BuyerTheme.action,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                area,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: BuyerTheme.ink,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SegmentedTabs(
          labels: _periods,
          selected: selected,
          onChanged: onPeriod,
        ),
        if (customRange != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                LucideIcons.calendar,
                size: 16,
                color: BuyerTheme.muted,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  customRange!,
                  style: const TextStyle(fontSize: 13, color: BuyerTheme.ink),
                ),
              ),
              TextButton(
                onPressed: () => onPeriod(3),
                style: TextButton.styleFrom(minimumSize: const Size(44, 44)),
                child: const Text(
                  'Change',
                  semanticsLabel: 'Change custom period',
                ),
              ),
            ],
          ),
        ],
      ],
    ),
  );
}

class _CategoryHeading extends StatelessWidget {
  const _CategoryHeading({required this.name, required this.count});

  final String name;
  final int count;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Semantics(
            header: true,
            child: Text(
              name,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$count variant${count == 1 ? '' : 's'}',
          style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
        ),
      ],
    ),
  );
}

/// What the numbers are: dataset, capture timing and the not-a-quotation explanation.
class _DatasetBand extends StatelessWidget {
  const _DatasetBand({required this.envelope});

  final AnalyticsEnvelopeView envelope;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BuyerTheme.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(LucideIcons.info, size: 18, color: BuyerTheme.action),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  envelope.datasetLabel,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: BuyerTheme.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  [
                    envelope.updateSchedule,
                    if (envelope.snapshotAt != null)
                      'Last capture ${formatManilaTimestamp(envelope.snapshotAt!)}',
                    'Current sellers as of ${formatManilaTimestamp(envelope.currentAsOf)}',
                  ].join(' · '),
                  style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
                ),
                const SizedBox(height: 6),
                Text(
                  envelope.explanation,
                  style: const TextStyle(
                    fontSize: 12,
                    color: BuyerTheme.muted,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/// One comparable variant: name and unit, the latest average with its date, the trend, and how
/// many sellers offer it now. The whole card opens Material Price Details.
class _AnalyticsRow extends StatelessWidget {
  const _AnalyticsRow({required this.item, required this.onOpen});

  final ComparableGroupView item;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final end = item.endPoint;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Semantics(
        button: true,
        hint: 'View details',
        child: Material(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: BuyerTheme.border),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onOpen,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 10, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.displayName,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: BuyerTheme.ink,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${item.materialName} · PHP per ${item.unitName}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: BuyerTheme.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const ExcludeSemantics(
                        child: Icon(
                          LucideIcons.chevronRight,
                          size: 20,
                          color: BuyerTheme.muted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 16,
                    runSpacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            end.hasValue ? pesoDecimal(end.average) : '—',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: BuyerTheme.ink,
                            ),
                          ),
                          Text(
                            end.hasValue
                                ? 'Average on ${analyticsDayLabel(end.date, year: true)}'
                                : (end.label ??
                                      'No average on ${analyticsDayLabel(end.date, year: true)}'),
                            style: const TextStyle(
                              fontSize: 12,
                              color: BuyerTheme.muted,
                            ),
                          ),
                          if (end.status == 'LIMITED_DATA')
                            const Text(
                              'Limited Local Data — 1 seller',
                              style: TextStyle(
                                fontSize: 12,
                                color: BuyerTheme.muted,
                              ),
                            ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: BuyerTheme.canvas,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: TrendText(trend: item.trend, compact: true),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        LucideIcons.store,
                        size: 16,
                        color: item.currentVendors > 0
                            ? BuyerTheme.successStrong
                            : BuyerTheme.muted,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          item.currentVendors > 0
                              ? '${item.currentVendors} seller${item.currentVendors == 1 ? '' : 's'} offering now'
                              : 'No Current Offers',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: item.currentVendors > 0
                                ? BuyerTheme.ink
                                : BuyerTheme.muted,
                          ),
                        ),
                      ),
                      const Text(
                        'View details',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: BuyerTheme.action,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Material Price Details: one canonical comparable variant with its graph/table, specifications and
/// the current public offers. An offer opens the existing single-seller Product Details.
class MaterialPriceDetailsScreen extends StatefulWidget {
  const MaterialPriceDetailsScreen({
    super.key,
    required this.repository,
    required this.origin,
    required this.radiusKm,
    required this.groupId,
    required this.window,
    required this.onOpenListing,
  });

  final AnalyticsRepository repository;
  final DiscoveryOrigin origin;
  final int radiusKm;
  final String groupId;
  final AnalyticsWindowChoice window;
  final void Function(BuildContext context, String listingId) onOpenListing;

  @override
  State<MaterialPriceDetailsScreen> createState() =>
      _MaterialPriceDetailsScreenState();
}

class _MaterialPriceDetailsScreenState
    extends State<MaterialPriceDetailsScreen> {
  late String _groupId = widget.groupId;
  MaterialPriceDetailsView? _detail;
  List<MaterialOfferView> _offers = const [];
  DiscoveryFailure? _failure;
  int _request = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final request = ++_request;
    setState(() {
      _detail = null;
      _failure = null;
    });
    try {
      final results = await Future.wait([
        widget.repository.details(
          groupId: _groupId,
          origin: widget.origin,
          radiusKm: widget.radiusKm,
          window: widget.window,
        ),
        widget.repository.offers(
          groupId: _groupId,
          origin: widget.origin,
          radiusKm: widget.radiusKm,
        ),
      ]);
      if (!mounted || request != _request) return;
      setState(() {
        _detail = results[0] as MaterialPriceDetailsView;
        _offers = results[1] as List<MaterialOfferView>;
      });
    } on DiscoveryFailure catch (failure) {
      if (mounted && request == _request) setState(() => _failure = failure);
    }
  }

  @override
  Widget build(BuildContext context) {
    final detail = _detail;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buyerAppBar(context, 'Material Price Details'),
      body: SafeArea(
        child: _failure != null
            ? Padding(
                padding: const EdgeInsets.all(16),
                child: StatusBand(
                  tone: BandTone.warning,
                  title: _failure!.kind == DiscoveryFailureKind.offline
                      ? 'You are offline'
                      : 'Price details are unavailable',
                  message: _failure!.message,
                  action: TextButton(
                    onPressed: _load,
                    child: const Text('Retry'),
                  ),
                ),
              )
            : detail == null
            ? const Padding(
                padding: EdgeInsets.all(16),
                child: SkeletonBox(height: 320),
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      detail.group.displayName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Text(
                    '${detail.group.categoryName} · ${detail.group.materialName}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: BuyerTheme.muted,
                    ),
                  ),
                  if (detail.description != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      detail.description!,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                  const SizedBox(height: 8),
                  for (final spec in detail.group.specification)
                    Text('• $spec', style: const TextStyle(fontSize: 13)),
                  Text(
                    'Unit: ${detail.group.unitName}',
                    style: const TextStyle(fontSize: 13),
                  ),
                  if (detail.variants.length > 1) ...[
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _groupId,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Comparable variant',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        for (final variant in detail.variants)
                          DropdownMenuItem(
                            value: variant.groupId,
                            child: Text(
                              variant.displayName,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        if (value == null || value == _groupId) return;
                        setState(() => _groupId = value);
                        _load();
                      },
                    ),
                  ],
                  const SizedBox(height: 16),
                  _DatasetBand(envelope: detail.envelope),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 24,
                    runSpacing: 12,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            detail.group.endPoint.hasValue
                                ? pesoDecimal(detail.group.endPoint.average)
                                : '—',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'Average per ${detail.group.unitName} on ${analyticsDayLabel(detail.group.endPoint.date, year: true)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: BuyerTheme.muted,
                            ),
                          ),
                        ],
                      ),
                      TrendText(trend: detail.group.trend),
                    ],
                  ),
                  const SizedBox(height: 16),
                  PriceTrendPanel(
                    title: 'Daily average for ${detail.group.displayName}',
                    unit: detail.group.unitName,
                    points: detail.series,
                    emptyReason:
                        'No price was recorded for this material within your radius during this period.',
                  ),
                  const SizedBox(height: 20),
                  const SectionHeading('Current offers'),
                  const SizedBox(height: 4),
                  const Text(
                    'Prices include any applicable VAT and exclude delivery and processing fees. An analytics price does not reserve stock or become a quotation.',
                    style: TextStyle(fontSize: 12, color: BuyerTheme.muted),
                  ),
                  const SizedBox(height: 8),
                  if (_offers.isEmpty)
                    const AnalyticsNullCard(
                      title: 'No Current Offers',
                      reason:
                          'No seller within your radius currently offers this variant. The price history above remains for planning.',
                    )
                  else
                    for (final offer in _offers)
                      Semantics(
                        button: true,
                        label:
                            '${offer.storeName}, ${pesoDecimal(offer.normalizedPhp)} per ${detail.group.unitName}, ${offer.taxLabel}, ${offer.availability == 'LIMITED_STOCK' ? 'Limited Stock' : 'In Stock'}, ${(offer.distanceMeters / 1000).toStringAsFixed(1)} km away. View product.',
                        excludeSemantics: true,
                        child: InkWell(
                          onTap: () =>
                              widget.onOpenListing(context, offer.listingId),
                          child: Container(
                            constraints: const BoxConstraints(minHeight: 64),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: BuyerTheme.border),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        offer.storeName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        '${offer.displayName}${offer.variantLabel == null ? '' : ' · ${offer.variantLabel}'}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: BuyerTheme.muted,
                                        ),
                                      ),
                                      Text(
                                        '${offer.taxLabel} · ${offer.availability == 'LIMITED_STOCK' ? 'Limited Stock' : 'In Stock'} · ${(offer.distanceMeters / 1000).toStringAsFixed(1)} km',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: BuyerTheme.muted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      pesoDecimal(offer.normalizedPhp),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Text(
                                      'per ${detail.group.unitName}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: BuyerTheme.muted,
                                      ),
                                    ),
                                    const Text(
                                      'View product',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: BuyerTheme.action,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
