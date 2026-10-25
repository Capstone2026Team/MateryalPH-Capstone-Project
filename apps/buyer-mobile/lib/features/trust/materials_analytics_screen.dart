import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../design_system/components/buyer_app_bar.dart';
import '../../design_system/components/category_tile.dart';
import '../../design_system/components/price_trend_chart.dart';
import '../../design_system/components/procurement_components.dart';
import '../../design_system/components/product_summary_row.dart'
    show ProductThumbnail;
import '../../design_system/theme.dart';
import '../item_procurement/explore_screen.dart' show categoryIcon;
import '../item_procurement/procurement_models.dart' show formatManilaTimestamp;
import '../map_discovery/discovery_models.dart';
import 'analytics_repository.dart';
import 'trust_models.dart';

const _periods = ['7 days', '30 days', '90 days', 'Custom'];
const _presetDays = [7, 30, 90];

/// Owner decision 2026-10-25: Buyer Materials Analytics always covers 50 km around the Explore
/// origin, with no radius choice, independent of the Explore browsing radius.
const kMaterialsAnalyticsRadiusKm = 50;

String _isoDay(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

String _periodLabel(AnalyticsWindowChoice window) => window.isCustom
    ? '${analyticsDayLabel(window.startDate!, year: true)} → ${analyticsDayLabel(window.endDate!, year: true)}'
    : 'Last ${window.presetDays} days';

String _plural(int count, String noun) => count == 1
    ? '1 $noun'
    : '$count ${noun.endsWith('y') ? '${noun.substring(0, noun.length - 1)}ies' : '${noun}s'}';

String _peso(String? value) => value == null ? '—' : pesoDecimal(value);

/// Table rows stack their price under the name instead of beside it under large text.
bool _largeText(BuildContext context) =>
    MediaQuery.textScalerOf(context).scale(1) > 1.3;

/// The variant part of a display name once its product is named above it:
/// "THHN building wire · Phelps Dodge · 2.0 mm" under "THHN building wire" → "Phelps Dodge · 2.0 mm".
String _variantLabel(String displayName, String materialName) {
  final prefix = '$materialName · '.toLowerCase();
  return displayName.toLowerCase().startsWith(prefix) &&
          displayName.length > prefix.length
      ? displayName.substring(prefix.length)
      : displayName;
}

/// Where every drill-down page came from: the 50 km area and the period chosen on the overview.
@immutable
class _Scope {
  const _Scope({
    required this.repository,
    required this.origin,
    required this.place,
    required this.window,
    required this.onOpenListing,
  });

  final AnalyticsRepository repository;
  final DiscoveryOrigin origin;
  final String place;
  final AnalyticsWindowChoice window;
  final void Function(BuildContext context, String listingId) onOpenListing;

  String get summary =>
      'Within $kMaterialsAnalyticsRadiusKm km of $place · ${_periodLabel(window)}';
}

/// Explore → Materials Analytics: the scope, period, search and category tiles. A tile (or a
/// search) opens the product table; a product opens its analytics; a variant opens its offers.
/// Daily averages are public listed prices with equal weight per seller; current seller counts and
/// history carry separate timestamps.
class MaterialsAnalyticsScreen extends StatefulWidget {
  const MaterialsAnalyticsScreen({
    super.key,
    required this.repository,
    required this.origin,
    required this.onOpenListing,
    this.originLabel,
  });

  final AnalyticsRepository repository;
  final DiscoveryOrigin origin;
  final String? originLabel;
  final void Function(BuildContext context, String listingId) onOpenListing;

  @override
  State<MaterialsAnalyticsScreen> createState() =>
      _MaterialsAnalyticsScreenState();
}

class _MaterialsAnalyticsScreenState extends State<MaterialsAnalyticsScreen> {
  AnalyticsWindowChoice _window = const AnalyticsWindowChoice.preset(30);
  final _search = TextEditingController();
  AnalyticsProductsPage? _page;
  DiscoveryFailure? _failure;
  bool _loading = true;
  int _request = 0;

  String get _place => widget.originLabel ?? widget.origin.label;

  _Scope get _scope => _Scope(
    repository: widget.repository,
    origin: widget.origin,
    place: _place,
    window: _window,
    onOpenListing: widget.onOpenListing,
  );

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

  Future<void> _load() async {
    final request = ++_request;
    setState(() {
      _loading = true;
      _failure = null;
    });
    try {
      final page = await widget.repository.products(
        origin: widget.origin,
        radiusKm: kMaterialsAnalyticsRadiusKm,
        window: _window,
      );
      // A newer period supersedes a slower response.
      if (!mounted || request != _request) return;
      setState(() => _page = page);
    } on DiscoveryFailure catch (failure) {
      if (mounted && request == _request) setState(() => _failure = failure);
    } finally {
      if (mounted && request == _request) setState(() => _loading = false);
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

  void _openProducts({AnalyticsCategorySummaryView? category, String? query}) =>
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => MaterialsAnalyticsProductsScreen._(
            _scope,
            title: query != null
                ? 'Results for “$query”'
                : category?.name ?? 'All materials',
            categoryId: category?.id,
            query: query,
          ),
        ),
      );

  void _submitSearch(String value) {
    final query = value.trim();
    if (query.isNotEmpty) _openProducts(query: query);
  }

  @override
  Widget build(BuildContext context) {
    final page = _page;
    final categories = page?.categories ?? const [];
    final products = categories.fold(0, (sum, c) => sum + c.productCount);
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
                place: _place,
                selected: _selectedPeriod,
                onPeriod: _choosePeriod,
                customRange: _window.isCustom ? _periodLabel(_window) : null,
              ),
              const SizedBox(height: 12),
              ListenableBuilder(
                listenable: _search,
                builder: (context, _) => PillSearchField(
                  controller: _search,
                  hintText: 'Search materials',
                  onSubmitted: _submitSearch,
                  onSearch: () => _submitSearch(_search.text),
                  onClear: _search.text.isEmpty ? null : _search.clear,
                ),
              ),
              if (page != null) ...[
                const SizedBox(height: 12),
                _DatasetBand(envelope: page.envelope),
              ],
              const SizedBox(height: 20),
              if (_loading)
                CategoryTileGrid(
                  children: [
                    for (var index = 0; index < 6; index++)
                      const SkeletonBox(height: 104),
                  ],
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
              else if (categories.isEmpty)
                StateMessage(
                  kind: StateKind.empty,
                  compact: true,
                  title: 'No comparable materials here yet',
                  message: page?.envelope.latestDate == null
                      ? 'No daily price snapshot has been published yet. Prices are captured daily at 00:10 Asia/Manila.'
                      : 'No comparable listing or recorded price matches this area and period. Try a longer period.',
                )
              else ...[
                _Heading(
                  'Categories',
                  trailing: _plural(categories.length, 'category'),
                ),
                const SizedBox(height: 12),
                CategoryTileGrid(
                  children: [
                    CategoryTile(
                      name: 'All',
                      icon: LucideIcons.layoutGrid,
                      countLabel: _plural(products, 'product'),
                      semanticsLabel:
                          'All, ${_plural(products, 'compared product')}',
                      onTap: _openProducts,
                    ),
                    for (final category in categories)
                      CategoryTile(
                        name: category.name,
                        icon: categoryIcon(category.code),
                        countLabel: _plural(category.productCount, 'product'),
                        semanticsLabel:
                            '${category.name}, ${_plural(category.productCount, 'compared product')}',
                        onTap: () => _openProducts(category: category),
                      ),
                  ],
                ),
              ],
              if (page != null && page.notYetComparable > 0) ...[
                const SizedBox(height: 16),
                _CoverageNote(notYetComparable: page.notYetComparable),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Why listings outnumber compared products: only listings matched to a standard material are
/// price-compared.
class _CoverageNote extends StatelessWidget {
  const _CoverageNote({required this.notYetComparable});

  final int notYetComparable;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.only(top: 2),
        child: Icon(LucideIcons.info, size: 14, color: BuyerTheme.muted),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          'Price comparison covers listings matched to a standard material, so stores selling the same item share one row. '
          '${_plural(notYetComparable, 'listing')} nearby — such as tools, hardware and custom-labelled items — '
          '${notYetComparable == 1 ? "isn't" : "aren't"} price-compared yet.',
          style: const TextStyle(
            fontSize: 12,
            color: BuyerTheme.muted,
            height: 1.4,
          ),
        ),
      ),
    ],
  );
}

/// One category, every category ("All") or a search: a table with one row per canonical product.
class MaterialsAnalyticsProductsScreen extends StatefulWidget {
  const MaterialsAnalyticsProductsScreen._(
    this._scope, {
    required this.title,
    this.categoryId,
    this.query,
  });

  /// The table for one category (or every category when [categoryId] is null).
  factory MaterialsAnalyticsProductsScreen({
    Key? key,
    required AnalyticsRepository repository,
    required DiscoveryOrigin origin,
    required String place,
    required AnalyticsWindowChoice window,
    required String title,
    required void Function(BuildContext context, String listingId)
    onOpenListing,
    String? categoryId,
    String? query,
  }) => MaterialsAnalyticsProductsScreen._(
    _Scope(
      repository: repository,
      origin: origin,
      place: place,
      window: window,
      onOpenListing: onOpenListing,
    ),
    title: title,
    categoryId: categoryId,
    query: query,
  );

  final _Scope _scope;
  final String title;
  final String? categoryId;
  final String? query;

  @override
  State<MaterialsAnalyticsProductsScreen> createState() =>
      _MaterialsAnalyticsProductsScreenState();
}

class _MaterialsAnalyticsProductsScreenState
    extends State<MaterialsAnalyticsProductsScreen> {
  AnalyticsProductsPage? _page;
  List<AnalyticsProductView> _items = const [];
  DiscoveryFailure? _failure;
  bool _loading = true;
  bool _loadingMore = false;
  int _request = 0;

  _Scope get _scope => widget._scope;

  @override
  void initState() {
    super.initState();
    _load();
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
      final page = await _scope.repository.products(
        origin: _scope.origin,
        radiusKm: kMaterialsAnalyticsRadiusKm,
        window: _scope.window,
        query: widget.query,
        categoryId: widget.categoryId,
        cursor: more ? _page?.nextCursor : null,
      );
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

  void _openProduct(AnalyticsProductView product) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => MaterialsAnalyticsProductScreen._(
        _scope,
        materialId: product.materialId,
        name: product.name,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final envelope = _page?.envelope;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buyerAppBar(context, widget.title),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _load,
          child: ListView(
            key: PageStorageKey('materials-analytics-products-${widget.title}'),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              _ScopeLine(_scope.summary),
              const SizedBox(height: 12),
              if (_loading)
                const SkeletonBox(height: 280)
              else if (_failure != null)
                _FailureBand(failure: _failure!, onRetry: _load)
              else if (_items.isEmpty)
                StateMessage(
                  kind: StateKind.empty,
                  compact: true,
                  title: widget.query == null
                      ? 'No comparable materials here yet'
                      : 'No materials match “${widget.query}”',
                  message: widget.query == null
                      ? 'No comparable listing or recorded price matches this area and period. Try a longer period.'
                      : 'Try another material name, brand or size.',
                )
              else ...[
                _ProductTable(
                  products: _items,
                  showCategory: widget.categoryId == null,
                  onOpen: _openProduct,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ranges span every variant of a product (sizes, brands, packs). Open a product for like-for-like averages per variant.',
                  style: TextStyle(fontSize: 12, color: BuyerTheme.muted),
                ),
                if (_page?.nextCursor != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: OutlinedButton(
                      onPressed: _loadingMore ? null : () => _load(more: true),
                      child: Text(_loadingMore ? 'Loading…' : 'Load more'),
                    ),
                  ),
              ],
              if (envelope != null) ...[
                const SizedBox(height: 20),
                _DatasetBand(envelope: envelope),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// The product table: a header, then one row per product with its regulation badge, counts and
/// current price range (median emphasized).
class _ProductTable extends StatelessWidget {
  const _ProductTable({
    required this.products,
    required this.showCategory,
    required this.onOpen,
  });

  final List<AnalyticsProductView> products;
  final bool showCategory;
  final ValueChanged<AnalyticsProductView> onOpen;

  @override
  Widget build(BuildContext context) => _TableCard(
    header: const _TableHeader(
      left: 'Product',
      right: 'Price per unit',
      rightCaption: 'median · min–max',
    ),
    rows: [
      for (final product in products)
        _ProductRow(
          product: product,
          showCategory: showCategory,
          onTap: () => onOpen(product),
        ),
    ],
  );
}

class _ProductRow extends StatelessWidget {
  const _ProductRow({
    required this.product,
    required this.showCategory,
    required this.onTap,
  });

  final AnalyticsProductView product;
  final bool showCategory;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final stacked = _largeText(context);
    final price = product.price;
    final meta = [
      if (showCategory) product.categoryName,
      _plural(product.variantCount, 'variant'),
      _plural(product.vendorCount, 'vendor'),
    ].join(' · ');
    return Semantics(
      button: true,
      label:
          '${product.name}, ${product.regulated ? 'regulated' : 'non-regulated'}, $meta, '
          '${price.isEmpty ? 'no current offers' : 'median ${_peso(price.median)}, from ${_peso(price.min)} to ${_peso(price.max)} per ${product.unitName}'}',
      hint: 'View product analytics',
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: BuyerTheme.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _RegulationBadge(regulated: product.regulated),
                    const SizedBox(height: 4),
                    Text(
                      meta,
                      style: const TextStyle(
                        fontSize: 12,
                        color: BuyerTheme.muted,
                      ),
                    ),
                    if (stacked) ...[
                      const SizedBox(height: 6),
                      _RangeCell(
                        range: price,
                        unit: product.unitName,
                        alignEnd: false,
                      ),
                    ],
                  ],
                ),
              ),
              if (!stacked) ...[
                const SizedBox(width: 12),
                _RangeCell(range: price, unit: product.unitName),
              ],
              const SizedBox(width: 4),
              const Icon(
                LucideIcons.chevronRight,
                size: 18,
                color: BuyerTheme.muted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Product analytics: summary strip, the most-offered variant's trend, then every variant.
class MaterialsAnalyticsProductScreen extends StatefulWidget {
  const MaterialsAnalyticsProductScreen._(
    this._scope, {
    required this.materialId,
    required this.name,
  });

  factory MaterialsAnalyticsProductScreen({
    Key? key,
    required AnalyticsRepository repository,
    required DiscoveryOrigin origin,
    required String place,
    required AnalyticsWindowChoice window,
    required String materialId,
    required String name,
    required void Function(BuildContext context, String listingId)
    onOpenListing,
  }) => MaterialsAnalyticsProductScreen._(
    _Scope(
      repository: repository,
      origin: origin,
      place: place,
      window: window,
      onOpenListing: onOpenListing,
    ),
    materialId: materialId,
    name: name,
  );

  final _Scope _scope;
  final String materialId;
  final String name;

  @override
  State<MaterialsAnalyticsProductScreen> createState() =>
      _MaterialsAnalyticsProductScreenState();
}

class _MaterialsAnalyticsProductScreenState
    extends State<MaterialsAnalyticsProductScreen> {
  AnalyticsProductDetailView? _detail;
  DiscoveryFailure? _failure;
  int _request = 0;

  _Scope get _scope => widget._scope;

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
      final detail = await _scope.repository.product(
        materialId: widget.materialId,
        origin: _scope.origin,
        radiusKm: kMaterialsAnalyticsRadiusKm,
        window: _scope.window,
      );
      if (mounted && request == _request) setState(() => _detail = detail);
    } on DiscoveryFailure catch (failure) {
      if (mounted && request == _request) setState(() => _failure = failure);
    }
  }

  void _openVariant(String groupId) => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => MaterialPriceDetailsScreen(
        repository: _scope.repository,
        origin: _scope.origin,
        radiusKm: kMaterialsAnalyticsRadiusKm,
        groupId: groupId,
        window: _scope.window,
        onOpenListing: _scope.onOpenListing,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final detail = _detail;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buyerAppBar(context, 'Product analytics'),
      body: SafeArea(
        child: _failure != null
            ? Padding(
                padding: const EdgeInsets.all(16),
                child: _FailureBand(failure: _failure!, onRetry: _load),
              )
            : detail == null
            ? const Padding(
                padding: EdgeInsets.all(16),
                child: SkeletonBox(height: 360),
              )
            : RefreshIndicator(onRefresh: _load, child: _productBody(detail)),
      ),
    );
  }

  Widget _productBody(AnalyticsProductDetailView detail) {
    final product = detail.product;
    final featured = detail.featured;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Semantics(
          header: true,
          child: Text(
            product.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: BuyerTheme.ink,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _RegulationBadge(regulated: product.regulated),
            Text(
              '${product.categoryName} · per ${product.unitName}',
              style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
            ),
          ],
        ),
        if (detail.description != null) ...[
          const SizedBox(height: 8),
          Text(
            detail.description!,
            style: const TextStyle(fontSize: 13, color: BuyerTheme.ink),
          ),
        ],
        const SizedBox(height: 8),
        _ScopeLine(_scope.summary),
        const SizedBox(height: 16),
        _StatStrip(
          stats: [
            _Stat(
              label: 'Average market price',
              value: featured != null && featured.endPoint.hasValue
                  ? pesoDecimal(featured.endPoint.average)
                  : '—',
              caption: 'per ${featured?.unitName ?? product.unitName}',
            ),
            _Stat(
              label: 'Lowest price',
              value: _peso(product.price.min),
              caption: 'per ${product.unitName}',
            ),
            _Stat(
              label: 'Vendors',
              value: '${product.vendorCount}',
              caption: 'selling now',
            ),
          ],
        ),
        if (featured != null) ...[
          const SizedBox(height: 8),
          Text(
            'Average and trend use the most-offered variant, ${_variantLabel(featured.displayName, product.name)}, so different sizes or brands are never mixed.',
            style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
          ),
          const SizedBox(height: 20),
          const _Heading('Price trend'),
          const SizedBox(height: 8),
          TrendText(trend: featured.trend),
          const SizedBox(height: 12),
          PriceTrendPanel(
            title: 'Daily average for ${featured.displayName}',
            unit: featured.unitName,
            points: detail.series,
            emptyReason:
                'No price was recorded for this variant within 50 km during this period.',
            collapsibleTable: true,
          ),
        ],
        const SizedBox(height: 24),
        _Heading(
          'Variants',
          trailing: _plural(detail.variants.length, 'variant'),
        ),
        const SizedBox(height: 4),
        const Text(
          'Each variant is one exact specification: brand, grade, size and pack.',
          style: TextStyle(fontSize: 12, color: BuyerTheme.muted),
        ),
        const SizedBox(height: 10),
        if (detail.variants.isEmpty)
          const AnalyticsNullCard(
            title: 'No variants in this area',
            reason:
                'No comparable variant of this product is listed within 50 km during this period.',
          )
        else
          _TableCard(
            header: const _TableHeader(
              left: 'Variant',
              right: 'Price per unit',
              rightCaption: 'min–max',
            ),
            rows: [
              for (final variant in detail.variants)
                _VariantRow(
                  variant: variant,
                  productName: product.name,
                  onTap: () => _openVariant(variant.groupId),
                ),
            ],
          ),
        const SizedBox(height: 20),
        _DatasetBand(envelope: detail.envelope),
      ],
    );
  }
}

class _VariantRow extends StatelessWidget {
  const _VariantRow({
    required this.variant,
    required this.productName,
    required this.onTap,
  });

  final AnalyticsProductVariantView variant;
  final String productName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = _variantLabel(variant.displayName, productName);
    final price = variant.price;
    final range = price.isEmpty
        ? 'No current offers'
        : price.min == price.max
        ? _peso(price.min)
        : '${_peso(price.min)} – ${_peso(price.max)}';
    final stacked = _largeText(context);
    final priceCell = Column(
      crossAxisAlignment: stacked
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      children: [
        Text(
          range,
          textAlign: stacked ? TextAlign.start : TextAlign.end,
          style: TextStyle(
            fontSize: price.isEmpty ? 12 : 14,
            fontWeight: price.isEmpty ? FontWeight.w500 : FontWeight.w800,
            color: price.isEmpty ? BuyerTheme.muted : BuyerTheme.ink,
          ),
        ),
        if (!price.isEmpty)
          Text(
            'per ${variant.unitName}',
            style: const TextStyle(fontSize: 11, color: BuyerTheme.muted),
          ),
      ],
    );
    return Semantics(
      button: true,
      label:
          '$label, $range per ${variant.unitName}, ${_plural(variant.vendorCount, 'vendor')}',
      hint: 'View vendor offers',
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExcludeSemantics(
                child: ProductThumbnail(
                  url: variant.imageUrl,
                  size: 48,
                  fallbackIcon: categoryIcon(variant.categoryCode),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ExcludeSemantics(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: BuyerTheme.ink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _plural(variant.vendorCount, 'vendor'),
                        style: const TextStyle(
                          fontSize: 12,
                          color: BuyerTheme.muted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      StockLabelText(
                        label: variant.availability,
                        compact: true,
                      ),
                      if (stacked) ...[const SizedBox(height: 6), priceCell],
                    ],
                  ),
                ),
              ),
              if (!stacked) ...[
                const SizedBox(width: 12),
                ExcludeSemantics(child: priceCell),
              ],
              const Padding(
                padding: EdgeInsets.only(left: 4, top: 2),
                child: Icon(
                  LucideIcons.chevronRight,
                  size: 18,
                  color: BuyerTheme.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A bordered table: a tinted header row and divided body rows.
class _TableCard extends StatelessWidget {
  const _TableCard({required this.header, required this.rows});

  final Widget header;
  final List<Widget> rows;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(color: BuyerTheme.border),
    ),
    clipBehavior: Clip.antiAlias,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        header,
        for (final (index, row) in rows.indexed) ...[
          if (index > 0) const Divider(height: 1, indent: 14),
          row,
        ],
      ],
    ),
  );
}

class _TableHeader extends StatelessWidget {
  const _TableHeader({
    required this.left,
    required this.right,
    required this.rightCaption,
  });

  final String left;
  final String right;
  final String rightCaption;

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: BuyerTheme.muted,
      letterSpacing: 0.2,
    );
    return ExcludeSemantics(
      child: Container(
        color: BuyerTheme.canvas,
        padding: const EdgeInsets.fromLTRB(14, 10, 30, 10),
        child: _largeText(context)
            // Rows stack their price under large text, so one heading line describes both.
            ? Text('$left · $right ($rightCaption)', style: style)
            : Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(child: Text(left, style: style)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(right, style: style),
                      Text(
                        rightCaption,
                        style: const TextStyle(
                          fontSize: 11,
                          color: BuyerTheme.muted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

/// Median emphasized with the min–max range beneath, or "No current offers".
class _RangeCell extends StatelessWidget {
  const _RangeCell({
    required this.range,
    required this.unit,
    this.alignEnd = true,
  });

  final PriceRangeView range;
  final String unit;

  /// False when the cell sits under the product name instead of beside it.
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    if (range.isEmpty) {
      return Text(
        alignEnd ? 'No current\noffers' : 'No current offers',
        textAlign: alignEnd ? TextAlign.end : TextAlign.start,
        style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
      );
    }
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          _peso(range.median),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: BuyerTheme.ink,
          ),
        ),
        Text(
          range.min == range.max
              ? 'per $unit'
              : '${_peso(range.min)}–${_peso(range.max)}',
          style: const TextStyle(fontSize: 11, color: BuyerTheme.muted),
        ),
      ],
    );
  }
}

class _RegulationBadge extends StatelessWidget {
  const _RegulationBadge({required this.regulated});

  final bool regulated;

  @override
  Widget build(BuildContext context) {
    final color = regulated ? BuyerTheme.actionPressed : BuyerTheme.muted;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: regulated ? BuyerTheme.brandSoft : BuyerTheme.canvas,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            regulated ? LucideIcons.shieldCheck : LucideIcons.circleDashed,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              regulated ? 'Regulated · PS/ICC' : 'Non-regulated',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

@immutable
class _Stat {
  const _Stat({
    required this.label,
    required this.value,
    required this.caption,
  });

  final String label;
  final String value;
  final String caption;
}

/// Summary figures side by side, stacking under large text or on narrow screens.
class _StatStrip extends StatelessWidget {
  const _StatStrip({required this.stats});

  final List<_Stat> stats;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final scale = MediaQuery.textScalerOf(context).scale(1);
      final columns = (constraints.maxWidth / (108 * scale)).floor().clamp(
        1,
        stats.length,
      );
      final width = (constraints.maxWidth - (columns - 1) * 8) / columns;
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final stat in stats)
            SizedBox(
              width: width,
              child: Semantics(
                container: true,
                label: '${stat.label}: ${stat.value} ${stat.caption}',
                excludeSemantics: true,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: BuyerTheme.canvas,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stat.label,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: BuyerTheme.muted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        stat.value,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: BuyerTheme.ink,
                        ),
                      ),
                      Text(
                        stat.caption,
                        style: const TextStyle(
                          fontSize: 11,
                          color: BuyerTheme.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      );
    },
  );
}

class _ScopeLine extends StatelessWidget {
  const _ScopeLine(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.only(top: 1),
        child: Icon(LucideIcons.mapPin, size: 16, color: BuyerTheme.action),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          text,
          style: const TextStyle(fontSize: 13, color: BuyerTheme.ink),
        ),
      ),
    ],
  );
}

class _FailureBand extends StatelessWidget {
  const _FailureBand({required this.failure, required this.onRetry});

  final DiscoveryFailure failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => StatusBand(
    tone: BandTone.warning,
    title: failure.kind == DiscoveryFailureKind.offline
        ? 'You are offline'
        : 'Materials Analytics is unavailable',
    message: failure.message,
    action: TextButton(onPressed: onRetry, child: const Text('Retry')),
  );
}

/// Where and when: the origin at the fixed analytics radius, then the history period.
class _ScopeCard extends StatelessWidget {
  const _ScopeCard({
    required this.place,
    required this.selected,
    required this.onPeriod,
    this.customRange,
  });

  final String place;
  final int selected;
  final ValueChanged<int> onPeriod;
  final String? customRange;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: BuyerTheme.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: BuyerTheme.brandSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.mapPin,
                size: 20,
                color: BuyerTheme.actionPressed,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Semantics(
                label: 'Within $kMaterialsAnalyticsRadiusKm km of $place',
                excludeSemantics: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Within $kMaterialsAnalyticsRadiusKm km of',
                      style: TextStyle(fontSize: 12, color: BuyerTheme.muted),
                    ),
                    Text(
                      place,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: BuyerTheme.ink,
                      ),
                    ),
                  ],
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

/// What the numbers are: dataset, capture timing and the not-an-index explanation (MAT-03 keeps
/// the explanation always visible).
class _DatasetBand extends StatelessWidget {
  const _DatasetBand({required this.envelope});

  final AnalyticsEnvelopeView envelope;

  @override
  Widget build(BuildContext context) {
    Widget line(IconData icon, String text) => Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(icon, size: 14, color: BuyerTheme.muted),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, color: BuyerTheme.ink),
            ),
          ),
        ],
      ),
    );
    return Semantics(
      container: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: BuyerTheme.canvas,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 1),
                  child: Icon(
                    LucideIcons.info,
                    size: 16,
                    color: BuyerTheme.action,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    envelope.datasetLabel,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: BuyerTheme.ink,
                    ),
                  ),
                ),
              ],
            ),
            line(
              LucideIcons.clock,
              [
                if (envelope.snapshotAt != null)
                  'Last capture ${formatManilaTimestamp(envelope.snapshotAt!)}',
                envelope.updateSchedule,
              ].join(' · '),
            ),
            line(
              LucideIcons.store,
              'Current sellers as of ${formatManilaTimestamp(envelope.currentAsOf)}',
            ),
            const SizedBox(height: 8),
            Text(
              envelope.explanation,
              style: const TextStyle(
                fontSize: 11.5,
                color: BuyerTheme.muted,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text, {this.trailing});

  final String text;
  final String? trailing;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Expanded(
        child: Semantics(
          header: true,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: BuyerTheme.ink,
            ),
          ),
        ),
      ),
      if (trailing != null)
        Text(
          trailing!,
          style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
        ),
    ],
  );
}

/// Variant detail: the current vendor offers first (each opens its Product Details), then the
/// variant's daily price history and specification.
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
      appBar: buyerAppBar(context, 'Variant offers'),
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
            : _variantBody(detail),
      ),
    );
  }

  Widget _variantBody(MaterialPriceDetailsView detail) {
    final group = detail.group;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(
              child: ProductThumbnail(
                url: group.imageUrl,
                size: 64,
                fallbackIcon: categoryIcon(group.categoryCode),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      group.displayName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Text(
                    '${group.categoryName} · ${group.materialName}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: BuyerTheme.muted,
                    ),
                  ),
                ],
              ),
            ),
          ],
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
        _StatStrip(
          stats: [
            _Stat(
              label: 'Daily average',
              value: group.endPoint.hasValue
                  ? pesoDecimal(group.endPoint.average)
                  : '—',
              caption:
                  'per ${group.unitName} · ${analyticsDayLabel(group.endPoint.date)}',
            ),
            _Stat(
              label: 'Vendors',
              value: '${group.currentVendors}',
              caption: 'selling now',
            ),
          ],
        ),
        const SizedBox(height: 20),
        _Heading('Vendor offers', trailing: _plural(_offers.length, 'offer')),
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
                'No seller within 50 km currently offers this variant. The price history below remains for planning.',
          )
        else
          _TableCard(
            header: const _TableHeader(
              left: 'Vendor',
              right: 'Unit price',
              rightCaption: 'cheapest first',
            ),
            rows: [
              for (final offer in _offers)
                _OfferRow(
                  offer: offer,
                  unitName: group.unitName,
                  categoryCode: group.categoryCode,
                  onTap: () => widget.onOpenListing(context, offer.listingId),
                ),
            ],
          ),
        const SizedBox(height: 24),
        const _Heading('Price history'),
        const SizedBox(height: 8),
        TrendText(trend: group.trend),
        const SizedBox(height: 12),
        PriceTrendPanel(
          title: 'Daily average for ${group.displayName}',
          unit: group.unitName,
          points: detail.series,
          emptyReason:
              'No price was recorded for this variant within 50 km during this period.',
        ),
        if (detail.description != null || group.specification.isNotEmpty) ...[
          const SizedBox(height: 20),
          const _Heading('Specification'),
          const SizedBox(height: 6),
          if (detail.description != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                detail.description!,
                style: const TextStyle(fontSize: 13),
              ),
            ),
          for (final spec in group.specification)
            Text('• $spec', style: const TextStyle(fontSize: 13)),
          Text('Unit: ${group.unitName}', style: const TextStyle(fontSize: 13)),
        ],
        const SizedBox(height: 20),
        _DatasetBand(envelope: detail.envelope),
      ],
    );
  }
}

/// One vendor's current offer: store, listing, tax/stock/distance, unit price and a View product
/// link to its Product Details.
class _OfferRow extends StatelessWidget {
  const _OfferRow({
    required this.offer,
    required this.unitName,
    required this.categoryCode,
    required this.onTap,
  });

  final MaterialOfferView offer;
  final String unitName;
  final String categoryCode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final stock = offer.availability == 'LIMITED_STOCK'
        ? 'Limited Stock'
        : 'In Stock';
    final distance = '${(offer.distanceMeters / 1000).toStringAsFixed(1)} km';
    return Semantics(
      button: true,
      label:
          '${offer.storeName}, ${pesoDecimal(offer.normalizedPhp)} per $unitName, ${offer.taxLabel}, $stock, $distance away. View product.',
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
          child: Row(
            children: [
              ProductThumbnail(
                url: offer.imageUrl,
                size: 48,
                fallbackIcon: categoryIcon(categoryCode),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.storeName,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '${offer.displayName}${offer.variantLabel == null ? '' : ' · ${offer.variantLabel}'}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: BuyerTheme.muted,
                      ),
                    ),
                    Text(
                      '${offer.taxLabel} · $stock · $distance',
                      style: const TextStyle(
                        fontSize: 12,
                        color: BuyerTheme.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    pesoDecimal(offer.normalizedPhp),
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  Text(
                    'per $unitName',
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
    );
  }
}
