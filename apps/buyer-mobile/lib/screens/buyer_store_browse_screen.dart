import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';
import 'package:url_launcher/url_launcher.dart';

import '../design_system/components/buyer_overlays.dart'
    show showBuyerBottomSheet;
import '../design_system/components/discovery_controls.dart' show ScoreBadge;
import '../design_system/components/procurement_components.dart';
import '../design_system/theme.dart';
import '../features/item_procurement/procurement_models.dart';
import '../features/item_procurement/procurement_repository.dart';
import '../features/item_procurement/search_results_screen.dart'
    show ListingCard;
import '../features/map_discovery/discovery_models.dart' show ScoreKind;
import '../features/trust/trust_models.dart';

class BuyerStoreRepository {
  BuyerStoreRepository({MateryalphApiClient? client})
    : _client =
          client ??
          MateryalphApiClient(
            basePathOverride: const String.fromEnvironment(
              'API_BASE_URL',
              defaultValue: 'http://10.0.2.2:8080/api/v1',
            ),
          );

  final MateryalphApiClient _client;

  Future<PublicStoreListEnvelope> stores(int page) async {
    final response = await _client.getStoresApi().listPublicStores(page: page);
    final result = response.data;
    if (result == null) throw StateError('Stores are unavailable.');
    return result;
  }

  Future<PublicStoreProfile> profile(String id) async {
    final response = await _client.getStoresApi().getPublicStoreProfile(
      storeId: id,
    );
    final profile = response.data?.data;
    if (profile == null) throw StateError('Store Profile is unavailable.');
    return profile;
  }
}

class BuyerStoreBrowseScreen extends StatefulWidget {
  const BuyerStoreBrowseScreen({super.key, this.repository});

  final BuyerStoreRepository? repository;

  @override
  State<BuyerStoreBrowseScreen> createState() => _BuyerStoreBrowseScreenState();
}

class _BuyerStoreBrowseScreenState extends State<BuyerStoreBrowseScreen> {
  late final BuyerStoreRepository _repository =
      widget.repository ?? BuyerStoreRepository();
  final List<PublicStoreSummary> _stores = [];
  int _page = 1;
  int _lastPage = 1;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await _repository.stores(_page);
      if (!mounted) return;
      setState(() {
        _stores.addAll(result.data);
        _lastPage = result.meta.lastPage;
        _loading = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = 'Stores could not be loaded.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: _loading && _stores.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : _error != null && _stores.isEmpty
        ? StatePage(
            child: StateMessage(
              kind: StateKind.error,
              title: _error!,
              message: 'Check your connection and retry.',
              actionLabel: 'Retry',
              onAction: _load,
            ),
          )
        : _stores.isEmpty
        ? StatePage(
            onRefresh: _load,
            child: const StateMessage(
              kind: StateKind.empty,
              title: 'No stores yet',
              message: 'No public stores are available yet.',
            ),
          )
        : ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount:
                _stores.length +
                (_page < _lastPage || _loading || _error != null ? 1 : 0),
            separatorBuilder: (_, _) => const Divider(),
            itemBuilder: (context, index) {
              if (index == _stores.length) {
                return _loading
                    ? const Center(child: CircularProgressIndicator())
                    : TextButton(
                        onPressed: () {
                          if (_error == null) {
                            _page++;
                          }
                          _load();
                        },
                        child: Text(
                          _error == null
                              ? 'Load more stores'
                              : 'Retry loading stores',
                        ),
                      );
              }
              final store = _stores[index];
              return ListTile(
                title: Text(store.publicStoreName),
                subtitle: store.vacationMode == true
                    ? const Text('Vacation Mode · New procurement paused')
                    : store.description == null
                    ? null
                    : Text(
                        store.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => BuyerPublicStoreProfileScreen(
                      storeId: store.id,
                      repository: _repository,
                    ),
                  ),
                ),
              );
            },
          ),
  );
}

class BuyerPublicStoreProfileScreen extends StatefulWidget {
  const BuyerPublicStoreProfileScreen({
    super.key,
    required this.storeId,
    required this.repository,
    this.onBrowseProducts,
    this.onMessage,
    this.loadProducts,
    this.onOpenListing,
    this.loadRating,
    this.distanceMeters,
    this.onShowOnMap,
    this.openExternal,
  });

  /// Straight-line distance from the Buyer's current Map location, when the Map already has it.
  /// Otherwise the distance of this store's loaded listings is shown, or none at all.
  final int? distanceMeters;

  /// Opens the Map with this store selected; null where the Map is not available.
  final void Function(BuildContext context)? onShowOnMap;

  /// Hands a tel: or sms: link to the device; injectable for tests.
  final Future<bool> Function(Uri uri)? openExternal;

  /// Loads one page of this store's eligible listings; null result means no location is chosen yet.
  final Future<ListingSearchPage?> Function(ListingSort sort, String? cursor)?
  loadProducts;

  /// Opens Product Details for a listing.
  final void Function(BuildContext context, String listingId)? onOpenListing;

  /// Loads the store's public rating summary and published scores; null where it is not offered.
  final Future<StoreRatingView> Function()? loadRating;

  final String storeId;
  final BuyerStoreRepository repository;
  final VoidCallback? onMessage;

  /// Opens this store's eligible listings in Search Results; null where browsing is unavailable.
  final void Function(BuildContext context, String storeId, String storeName)?
  onBrowseProducts;

  @override
  State<BuyerPublicStoreProfileScreen> createState() =>
      _BuyerPublicStoreProfileScreenState();
}

class _BuyerPublicStoreProfileScreenState
    extends State<BuyerPublicStoreProfileScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late Future<PublicStoreProfile> _profile = widget.repository.profile(
    widget.storeId,
  );
  late Future<StoreRatingView>? _rating = widget.loadRating?.call();

  // Each list is held here so switching tabs never reloads it.
  late final _StoreProducts? _products = _listings(ListingSort.bestDeal);
  late final TabController _tabs = TabController(length: 2, vsync: this)
    ..addListener(() {
      if (!_tabs.indexIsChanging && mounted) setState(() {});
    });

  _StoreProducts? _listings(ListingSort sort) => widget.loadProducts == null
      ? null
      : _StoreProducts(widget.loadProducts!, sort: sort);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabs.dispose();
    _products?.dispose();
    super.dispose();
  }

  // A cached view shows its freshness and refreshes on resume.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _reload();
  }

  void _reload() => setState(() {
    _profile = widget.repository.profile(widget.storeId);
    _rating = widget.loadRating?.call();
  });

  Future<void> _refresh() async {
    _reload();
    final products = _products;
    if (products != null && products.started) await products.reload();
  }

  /// Every listing card carries the same store distance, so a loaded list can stand in for it.
  int? get _distance {
    if (widget.distanceMeters != null) return widget.distanceMeters;
    final items = _products?.items ?? const <ListingCardView>[];
    return items.isEmpty ? null : items.first.distanceMeters;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: FutureBuilder<PublicStoreProfile>(
      future: _profile,
      builder: (context, snapshot) {
        if (!snapshot.hasData && !snapshot.hasError) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return SafeArea(
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: _BackButton(),
                  ),
                ),
                Expanded(
                  child: StateMessage(
                    kind: StateKind.error,
                    title: 'Store Profile could not be loaded.',
                    message: 'Check your connection and retry.',
                    actionLabel: 'Retry',
                    onAction: _reload,
                  ),
                ),
              ],
            ),
          );
        }
        final profile = snapshot.data!;
        final hours = storeHoursFromProfile(profile);
        // Large text scrolls the tabs instead of clipping "Store Profile".
        final scaled = MediaQuery.textScalerOf(context).scale(1) > 1.15;
        return RefreshIndicator(
          onRefresh: _refresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: ListenableBuilder(
                  listenable: Listenable.merge([_products]),
                  builder: (context, _) => _StoreHeader(
                    profile: profile,
                    hours: hours,
                    distanceMeters: _distance,
                    onShowOnMap: widget.onShowOnMap,
                    onMessage: widget.onMessage,
                    onSearch: widget.onBrowseProducts == null
                        ? null
                        : () => widget.onBrowseProducts!(
                            context,
                            profile.id,
                            profile.publicStoreName,
                          ),
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _TabBarDelegate(
                  TabBar(
                    controller: _tabs,
                    isScrollable: scaled,
                    tabAlignment: scaled
                        ? TabAlignment.start
                        : TabAlignment.fill,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                    labelColor: BuyerTheme.action,
                    unselectedLabelColor: BuyerTheme.ink,
                    indicatorColor: BuyerTheme.action,
                    indicatorWeight: 3,
                    dividerColor: Colors.transparent,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    tabs: const [
                      Tab(text: 'Products'),
                      Tab(text: 'Store Profile'),
                    ],
                  ),
                  topInset: MediaQuery.paddingOf(context).top,
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                sliver: SliverToBoxAdapter(
                  child: switch (_tabs.index) {
                    0 => _ProductsTab(
                      profile: profile,
                      products: _products,
                      onOpen: widget.onOpenListing,
                      onBrowseProducts: widget.onBrowseProducts,
                    ),
                    _ => _StoreDetailsTab(
                      profile: profile,
                      hours: hours,
                      rating: _rating,
                      onRetry: _reload,
                      openExternal: widget.openExternal ?? _launchExternal,
                    ),
                  },
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}

Future<bool> _launchExternal(Uri uri) =>
    launchUrl(uri, mode: LaunchMode.externalApplication);

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) => RoundIconButton(
    icon: LucideIcons.arrowLeft,
    tooltip: 'Back',
    filled: true,
    onPressed: () => Navigator.of(context).maybePop(),
  );
}

/// The pinned tabs. [topInset] keeps them below the status bar once pinned; before that it is the
/// gap between the store identity and the tabs.
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  _TabBarDelegate(this.tabBar, {required this.topInset});

  final TabBar tabBar;
  final double topInset;

  double get _extent => topInset + tabBar.preferredSize.height + 1;

  @override
  double get minExtent => _extent;

  @override
  double get maxExtent => _extent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => Material(
    color: Theme.of(context).scaffoldBackgroundColor,
    elevation: overlapsContent ? 1 : 0,
    child: Column(
      children: [
        SizedBox(height: topInset),
        Expanded(child: tabBar),
        const Divider(height: 1, color: BuyerTheme.border),
      ],
    ),
  );

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) =>
      oldDelegate.tabBar != tabBar || oldDelegate.topInset != topInset;
}

/// Banner with Back and the store actions (show on Map, Message, search the store's products), the
/// overlapping logo and the store identity: name, VPS / New Vendor label, then one compact line of
/// open-now status, distance, supplier type and location.
class _StoreHeader extends StatelessWidget {
  const _StoreHeader({
    required this.profile,
    required this.hours,
    required this.distanceMeters,
    required this.onShowOnMap,
    required this.onMessage,
    required this.onSearch,
  });

  final PublicStoreProfile profile;
  final StoreHoursView hours;
  final int? distanceMeters;
  final void Function(BuildContext context)? onShowOnMap;
  final VoidCallback? onMessage;
  final VoidCallback? onSearch;

  static const _logo = 72.0;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final city = [
      profile.address.cityMunicipality,
      profile.address.province,
    ].whereType<String>().where((part) => part.isNotEmpty).join(', ');
    final open = hours.available ? hours.openNowStatus == 'OPEN' : null;
    final kind = profile.scoreLabel.kind;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              height: 132 + top,
              child: _Media(
                url: profile.bannerUrl,
                fallbackIcon: LucideIcons.store,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(top: top + 4, left: 8, child: const _BackButton()),
            Positioned(
              top: top + 4,
              right: 8,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (onShowOnMap != null)
                    RoundIconButton(
                      icon: LucideIcons.mapPin,
                      tooltip: 'Show ${profile.publicStoreName} on the Map',
                      onPressed: () => onShowOnMap!(context),
                    ),
                  if (onMessage != null)
                    RoundIconButton(
                      icon: LucideIcons.messageSquare,
                      tooltip: 'Message ${profile.publicStoreName}',
                      onPressed: onMessage,
                    ),
                  if (onSearch != null)
                    RoundIconButton(
                      icon: LucideIcons.search,
                      tooltip: 'Search ${profile.publicStoreName} products',
                      onPressed: onSearch,
                    ),
                ],
              ),
            ),
            Positioned(
              left: 16,
              bottom: -_logo / 2,
              child: Container(
                width: _logo,
                height: _logo,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: const [
                    BoxShadow(color: Color(0x33000000), blurRadius: 6),
                  ],
                ),
                child: ClipOval(
                  child: _Media(
                    url: profile.logoUrl,
                    fallbackIcon: LucideIcons.store,
                    fit: BoxFit.cover,
                    semanticLabel: '${profile.publicStoreName} logo',
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16 + _logo + 12, 8, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text(
                  profile.publicStoreName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              ScoreBadge(
                kind: kind == ScoreLabelKindEnum.VPS
                    ? ScoreKind.vps
                    : kind == ScoreLabelKindEnum.DIRECTORY
                    ? ScoreKind.directory
                    : ScoreKind.newVendor,
                text: profile.scoreLabel.text,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          child: Wrap(
            spacing: 16,
            runSpacing: 6,
            children: [
              if (open != null)
                _MetaItem(
                  icon: open ? LucideIcons.circleCheck : LucideIcons.clock,
                  label: open ? 'Open now' : 'Closed now',
                  color: open ? BuyerTheme.successStrong : BuyerTheme.muted,
                  strong: true,
                ),
              if (distanceMeters != null)
                Semantics(
                  label:
                      '${formatDistance(distanceMeters!)} straight-line distance from your location',
                  excludeSemantics: true,
                  child: _MetaItem(
                    icon: LucideIcons.navigation,
                    label: '${formatDistance(distanceMeters!)} away',
                  ),
                ),
              if (profile.supplierType != null &&
                  profile.supplierType!.isNotEmpty)
                _MetaItem(
                  icon: LucideIcons.building2,
                  label: _humanize(profile.supplierType!),
                ),
              if (city.isNotEmpty)
                _MetaItem(icon: LucideIcons.mapPin, label: city),
            ],
          ),
        ),
        if (profile.vacationMode)
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: StatusBand(
              tone: BandTone.warning,
              title: 'Vacation Mode',
              message:
                  'This store has paused new procurement. Existing orders and messaging remain available.',
            ),
          ),
        const SizedBox(height: 4),
      ],
    );
  }
}

/// One icon-and-text fact in the header's compact line; no border, so facts never stack as pills.
class _MetaItem extends StatelessWidget {
  const _MetaItem({
    required this.icon,
    required this.label,
    this.color = BuyerTheme.muted,
    this.strong = false,
  });

  final IconData icon;
  final String label;
  final Color color;
  final bool strong;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 16, color: color),
      const SizedBox(width: 6),
      Flexible(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: strong ? FontWeight.w700 : FontWeight.w500,
            color: strong ? color : BuyerTheme.ink,
          ),
        ),
      ),
    ],
  );
}

String _humanize(String code) {
  final words = code.toLowerCase().split('_');
  return [
    for (final (index, word) in words.indexed)
      if (word.isNotEmpty)
        index == 0 ? '${word[0].toUpperCase()}${word.substring(1)}' : word,
  ].join(' ');
}

class _Media extends StatelessWidget {
  const _Media({
    required this.url,
    required this.fallbackIcon,
    required this.fit,
    this.semanticLabel,
  });

  final String? url;
  final IconData fallbackIcon;
  final BoxFit fit;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final fallback = ColoredBox(
      color: BuyerTheme.brandSoft,
      child: Center(child: Icon(fallbackIcon, color: BuyerTheme.action)),
    );
    if (url == null) return fallback;
    return Image.network(
      url!,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      semanticLabel: semanticLabel,
      excludeFromSemantics: semanticLabel == null,
      errorBuilder: (_, _, _) => fallback,
      loadingBuilder: (_, child, progress) =>
          progress == null ? child : fallback,
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: BuyerTheme.canvas,
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: BuyerTheme.border),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: BuyerTheme.action),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  );
}

List<String> _services(String? method) => switch (method) {
  'SELF_PICKUP' => const ['Self-Pickup'],
  'VENDOR_DELIVERY' => const ['Site Delivery'],
  'BOTH' => const ['Site Delivery', 'Self-Pickup'],
  _ => const [],
};

class _Chips extends StatelessWidget {
  const _Chips(this.labels);

  final List<String> labels;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      for (final label in labels) _Pill(icon: LucideIcons.tag, label: label),
    ],
  );
}

/// A white Store Profile section with an optional heading.
class _ProfileCard extends StatelessWidget {
  const _ProfileCard({this.title, required this.child});

  final String? title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: BuyerTheme.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title != null) ...[
          Semantics(
            header: true,
            child: Text(
              title!,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 12),
        ],
        child,
      ],
    ),
  );
}

/// A short muted line in place of an empty or failed highlight, so one section never blanks the page.
class _InlineNote extends StatelessWidget {
  const _InlineNote(this.text, {this.onRetry});

  final String text;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      color: BuyerTheme.canvas,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: BuyerTheme.border),
    ),
    child: Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              height: 1.4,
              color: BuyerTheme.muted,
            ),
          ),
        ),
        if (onRetry != null)
          TextButton(onPressed: onRetry, child: const Text('Retry')),
      ],
    ),
  );
}

/// Two columns of equal-height listing cards; one column under large text.
class _ListingGrid extends StatelessWidget {
  const _ListingGrid({required this.items, required this.onOpen});

  final List<ListingCardView> items;
  final ValueChanged<ListingCardView> onOpen;

  @override
  Widget build(BuildContext context) {
    final columns = MediaQuery.textScalerOf(context).scale(1) > 1.3 ? 1 : 2;
    final rows = (items.length / columns).ceil();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var row = 0; row < rows; row++)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var column = 0; column < columns; column++) ...[
                    if (column > 0) const SizedBox(width: 10),
                    Expanded(
                      child: row * columns + column < items.length
                          ? ListingCard(
                              card: items[row * columns + column],
                              showFavorite: false,
                              onOpen: () =>
                                  onOpen(items[row * columns + column]),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _StoreDetailsTab extends StatelessWidget {
  const _StoreDetailsTab({
    required this.profile,
    required this.hours,
    required this.rating,
    required this.onRetry,
    required this.openExternal,
  });

  final PublicStoreProfile profile;
  final StoreHoursView hours;
  final Future<StoreRatingView>? rating;
  final VoidCallback onRetry;
  final Future<bool> Function(Uri uri) openExternal;

  /// The approved public number as a dialable string: digits with an optional leading +.
  static String _dialable(String phone) {
    final digits = phone.replaceAll(RegExp(r'[^0-9+]'), '');
    return digits.startsWith('+')
        ? '+${digits.substring(1).replaceAll('+', '')}'
        : digits.replaceAll('+', '');
  }

  Future<void> _contact(BuildContext context, String phone) async {
    final number = _dialable(phone);
    final choice = await showBuyerBottomSheet<String>(
      context: context,
      builder: (sheet) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Text(
                phone,
                style: Theme.of(
                  sheet,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            ListTile(
              minTileHeight: 52,
              leading: const Icon(LucideIcons.phone, color: BuyerTheme.action),
              title: const Text('Call'),
              onTap: () => Navigator.pop(sheet, 'tel'),
            ),
            ListTile(
              minTileHeight: 52,
              leading: const Icon(
                LucideIcons.messageSquareText,
                color: BuyerTheme.action,
              ),
              title: const Text('Send SMS'),
              onTap: () => Navigator.pop(sheet, 'sms'),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (choice == null || !context.mounted) return;
    var opened = false;
    try {
      opened = await openExternal(Uri(scheme: choice, path: number));
    } catch (_) {
      opened = false;
    }
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            choice == 'tel'
                ? 'This device cannot place calls. The number is $phone.'
                : 'This device cannot send SMS. The number is $phone.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final services = _services(profile.fulfillmentMethod);
    final phone = profile.publicPhone;
    final rows = <(IconData, String, String, VoidCallback?)>[
      if (profile.address.formattedAddress != null)
        (
          LucideIcons.mapPin,
          'Address',
          profile.address.formattedAddress!,
          null,
        ),
      if (phone != null && _dialable(phone).replaceAll('+', '').isNotEmpty)
        (LucideIcons.phone, 'Phone', phone, () => _contact(context, phone)),
      if (profile.publicEmail != null && profile.publicEmail!.isNotEmpty)
        (LucideIcons.mail, 'Email', profile.publicEmail!, null),
      if (services.isNotEmpty)
        (LucideIcons.truck, 'Services', services.join(' · '), null),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (rating != null)
          _ProfileCard(
            title: 'Store rating',
            child: _StoreRatingSection(rating: rating!, onRetry: onRetry),
          ),
        if (profile.description != null && profile.description!.isNotEmpty)
          _ProfileCard(
            title: 'About this store',
            child: Text(
              profile.description!,
              style: const TextStyle(height: 1.5),
            ),
          ),
        if (profile.niches.isNotEmpty)
          _ProfileCard(
            title: 'What this store supplies',
            child: _Chips(profile.niches.toList()),
          ),
        if (rows.isNotEmpty)
          _ProfileCard(
            title: 'Contact and services',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final (index, (icon, label, value, onTap)) in rows.indexed)
                  Semantics(
                    container: true,
                    button: onTap != null,
                    label: onTap == null
                        ? '$label: $value'
                        : '$label: $value. Call or send SMS',
                    excludeSemantics: true,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onTap,
                        child: Container(
                          constraints: const BoxConstraints(minHeight: 44),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            border: index == rows.length - 1
                                ? null
                                : const Border(
                                    bottom: BorderSide(
                                      color: BuyerTheme.border,
                                    ),
                                  ),
                          ),
                          child: Row(
                            children: [
                              Icon(icon, size: 20, color: BuyerTheme.action),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      label,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: BuyerTheme.muted,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      value,
                                      style: TextStyle(
                                        height: 1.4,
                                        fontWeight: onTap == null
                                            ? FontWeight.w400
                                            : FontWeight.w700,
                                        color: onTap == null
                                            ? BuyerTheme.ink
                                            : BuyerTheme.actionPressed,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (onTap != null) ...[
                                const SizedBox(width: 8),
                                const Icon(
                                  LucideIcons.phoneOutgoing,
                                  size: 18,
                                  color: BuyerTheme.action,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        _ProfileCard(
          child: StoreHoursSection(hours: hours, onRetry: onRetry),
        ),
      ],
    );
  }
}

/// The store's rating summary. The headline is the published Vendor Community Score; below its
/// sample gate the store reads "New Vendor — Building Track Record" and no combined number is shown.
/// Service Quality and Speed are averages of the visible verified store ratings.
class _StoreRatingSection extends StatelessWidget {
  const _StoreRatingSection({required this.rating, required this.onRetry});

  final Future<StoreRatingView> rating;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => FutureBuilder<StoreRatingView>(
    future: rating,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return _InlineNote('Store rating could not load.', onRetry: onRetry);
      }
      final view = snapshot.data;
      if (view == null) {
        return Semantics(
          label: 'Loading store rating',
          child: const LinearProgressIndicator(),
        );
      }
      final count = view.ratingCount;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            container: true,
            label: view.vcs == null
                ? '${view.newVendor ? 'New Vendor — Building Track Record' : 'Vendor Community Score not yet published'}, $count verified store rating${count == 1 ? '' : 's'}'
                : 'Vendor Community Score ${view.vcs} of 5, $count verified store rating${count == 1 ? '' : 's'}',
            excludeSemantics: true,
            child: Row(
              children: [
                Text(
                  view.vcs ?? 'New',
                  style: const TextStyle(
                    fontSize: 32,
                    height: 1.1,
                    fontWeight: FontWeight.w800,
                    color: BuyerTheme.action,
                  ),
                ),
                if (view.vcs != null) ...[
                  const SizedBox(width: 4),
                  const Icon(
                    LucideIcons.star,
                    size: 22,
                    color: BuyerTheme.action,
                    fill: 1,
                  ),
                ],
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        view.vcs != null
                            ? 'Vendor Community Score'
                            : view.newVendor
                            ? 'New Vendor — Building Track Record'
                            : 'Vendor Community Score not yet published',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '$count verified store rating${count == 1 ? '' : 's'}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: BuyerTheme.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (count > 0) ...[
            const SizedBox(height: 14),
            _ScoreBar(label: 'Service Quality', value: view.serviceQuality),
            _ScoreBar(label: 'Delivery / Processing Speed', value: view.speed),
          ],
          if (view.mqs != null)
            _ScoreBar(label: 'Material Quality Score', value: view.mqs),
          if (view.vps != null)
            _ScoreBar(label: 'Vendor Performance Score', value: view.vps),
          if (view.badges.isNotEmpty) ...[
            const SizedBox(height: 10),
            for (final badge in view.badges)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      LucideIcons.badgeCheck,
                      size: 18,
                      color: BuyerTheme.action,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            badge.scopeLabel == null
                                ? badge.name
                                : '${badge.name} · ${badge.scopeLabel}',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            badge.description,
                            style: const TextStyle(
                              fontSize: 12,
                              height: 1.4,
                              color: BuyerTheme.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
          const SizedBox(height: 10),
          const Text(
            'From verified purchases only. Published scores use a rolling 90-day window and appear once enough eligible ratings exist.',
            style: TextStyle(
              fontSize: 12,
              height: 1.5,
              color: BuyerTheme.muted,
            ),
          ),
        ],
      );
    },
  );
}

/// One 1–5 value as text and a bar; the text carries the meaning, the bar is decoration.
class _ScoreBar extends StatelessWidget {
  const _ScoreBar({required this.label, required this.value});

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final number = value == null ? null : double.tryParse(value!);
    return Semantics(
      container: true,
      label: number == null ? '$label: not available' : '$label: $value of 5',
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(label, style: const TextStyle(fontSize: 13)),
                ),
                Text(
                  value ?? '—',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: number == null ? 0 : (number / 5).clamp(0, 1),
              minHeight: 6,
              borderRadius: BorderRadius.circular(4),
              backgroundColor: BuyerTheme.brandSoft,
              color: BuyerTheme.action,
            ),
          ],
        ),
      ),
    );
  }
}

/// Saved Store Operation schedule in Asia/Manila: today and the next six dates with explicit Closed
/// days and date-specific hours marked. Dates and times are displayed exactly as the server sent
/// them, so a phone set to another time zone still shows the Philippine schedule.
class StoreHoursSection extends StatelessWidget {
  const StoreHoursSection({
    super.key,
    required this.hours,
    required this.onRetry,
  });

  final StoreHoursView hours;
  final VoidCallback onRetry;

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static String _date(String iso) {
    final parts = iso.split('-');
    return '${_months[int.parse(parts[1]) - 1]} ${int.parse(parts[2])}';
  }

  String get _openNow {
    if (hours.allClosed) return 'Closed on all days of the saved schedule';
    return switch (hours.openNowStatus) {
      'OPEN' => 'Open now · closes ${formatClock(hours.closesAt!)}',
      _ =>
        hours.nextOpeningDate == null
            ? 'Closed now · no opening in the next 7 days'
            : 'Closed now · opens ${hours.nextOpeningWeekday} ${_date(hours.nextOpeningDate!)}, ${formatClock(hours.nextOpeningTime!)}',
    };
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Semantics(
        header: true,
        child: Text(
          'Store Hours',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
      ),
      const SizedBox(height: 8),
      if (!hours.available)
        StatusBand(
          tone: BandTone.warning,
          title: 'Hours unavailable',
          message:
              'This store is still listed; check with the store before visiting.',
          action: TextButton(onPressed: onRetry, child: const Text('Retry')),
        )
      else ...[
        Row(
          children: [
            Icon(
              hours.openNowStatus == 'OPEN'
                  ? Icons.check_circle_outline
                  : Icons.schedule,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _openNow,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        for (final (index, day) in hours.week.indexed)
          Semantics(
            container: true,
            label:
                '${index == 0 ? 'Today, ' : ''}${day.weekday} ${_date(day.date)}: ${day.open ? '${formatClock(day.opensAt!)} to ${formatClock(day.closesAt!)}' : 'Closed'}${day.fromOverride ? ', date-specific hours' : ''}',
            excludeSemantics: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 12,
                children: [
                  Text(
                    '${index == 0 ? 'Today · ' : ''}${day.weekday}, ${_date(day.date)}',
                    style: TextStyle(
                      fontWeight: index == 0
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                  Text(
                    '${day.open ? '${formatClock(day.opensAt!)} – ${formatClock(day.closesAt!)}' : 'Closed'}${day.fromOverride ? ' · date-specific' : ''}',
                  ),
                ],
              ),
            ),
          ),
      ],
      const SizedBox(height: 8),
      Text(
        '${hours.notice} Philippine time (Asia/Manila) · as of ${formatManilaTimestamp(hours.asOf)}.',
        style: const TextStyle(fontSize: 12, color: BuyerTheme.muted),
      ),
    ],
  );
}

/// One store's listings under one server sort, cursor-paged, and held by the profile screen so
/// switching tabs does not reload them.
class _StoreProducts extends ChangeNotifier {
  _StoreProducts(this._load, {this.sort = ListingSort.bestDeal});

  final Future<ListingSearchPage?> Function(ListingSort sort, String? cursor)
  _load;

  ListingSort sort;
  LoadPhase phase = LoadPhase.loading;
  List<ListingCardView> items = const [];
  ListingSearchPage? page;
  bool loadingMore = false;
  bool _started = false;
  bool _disposed = false;
  int _sequence = 0;

  bool get started => _started;

  Future<void> ensureLoaded() => _started ? Future.value() : reload();

  Future<void> reload({ListingSort? sort}) async {
    _started = true;
    if (sort != null) this.sort = sort;
    final sequence = ++_sequence;
    phase = LoadPhase.loading;
    items = const [];
    notifyListeners();
    try {
      final result = await _load(this.sort, null);
      if (_disposed || sequence != _sequence) return;
      page = result;
      items = result?.items ?? const [];
      phase = result == null ? LoadPhase.needsOrigin : LoadPhase.ready;
    } catch (_) {
      if (_disposed || sequence != _sequence) return;
      phase = LoadPhase.failed;
    }
    notifyListeners();
  }

  Future<void> loadMore() async {
    final cursor = page?.nextCursor;
    if (loadingMore || cursor == null) return;
    final sequence = _sequence;
    loadingMore = true;
    notifyListeners();
    try {
      final result = await _load(sort, cursor);
      if (_disposed || sequence != _sequence) return;
      if (result != null) {
        page = result;
        items = [...items, ...result.items];
      }
    } catch (_) {
      // Keep the loaded cards; the button stays available to retry.
    }
    if (_disposed || sequence != _sequence) return;
    loadingMore = false;
    notifyListeners();
  }

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

class _ProductsTab extends StatefulWidget {
  const _ProductsTab({
    required this.profile,
    required this.products,
    required this.onOpen,
    required this.onBrowseProducts,
  });

  final PublicStoreProfile profile;
  final _StoreProducts? products;
  final void Function(BuildContext context, String listingId)? onOpen;
  final void Function(BuildContext context, String storeId, String storeName)?
  onBrowseProducts;

  @override
  State<_ProductsTab> createState() => _ProductsTabState();
}

class _ProductsTabState extends State<_ProductsTab> {
  @override
  void initState() {
    super.initState();
    final products = widget.products;
    if (products != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) products.ensureLoaded();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = widget.products;
    if (products == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Browsing this store’s products is not available from here.',
            style: TextStyle(height: 1.45),
          ),
          if (widget.onBrowseProducts != null) ...[
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => widget.onBrowseProducts!(
                context,
                widget.profile.id,
                widget.profile.publicStoreName,
              ),
              icon: const Icon(LucideIcons.packageSearch),
              label: const Text('Browse this store’s products'),
            ),
          ],
        ],
      );
    }
    return ListenableBuilder(
      listenable: products,
      builder: (context, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sortRow(products),
          const SizedBox(height: 12),
          ..._body(context, products),
        ],
      ),
    );
  }

  Widget _sortRow(_StoreProducts products) {
    final sort = products.sort;
    final price = sort.family == ListingSort.price;
    // Wraps instead of scrolling, so the sort a "See all" opened is always in view.
    return Wrap(
      spacing: 8,
      children: [
        for (final option in const [
          ListingSort.bestDeal,
          ListingSort.topSelling,
          ListingSort.rating,
        ])
          FilterPill(
            label: option == ListingSort.rating ? 'Top Rated' : option.label,
            selected: sort == option,
            onTap: () => products.reload(sort: option),
          ),
        FilterPill(
          label: 'Price',
          selected: price,
          trailingIcon: !price || !sort.descending
              ? LucideIcons.arrowUpNarrowWide
              : LucideIcons.arrowDownWideNarrow,
          onTap: () =>
              products.reload(sort: price ? sort.reversed : ListingSort.price),
        ),
      ],
    );
  }

  List<Widget> _body(BuildContext context, _StoreProducts products) {
    switch (products.phase) {
      case LoadPhase.needsOrigin:
        return const [
          StateMessage(
            kind: StateKind.needsLocation,
            title: 'Choose a location first',
            message:
                'Select a location on the Map to see this store’s products with distance and delivery.',
          ),
        ];
      case LoadPhase.loading:
        return const [
          Row(
            children: [
              Expanded(child: SkeletonBox(height: 250)),
              SizedBox(width: 10),
              Expanded(child: SkeletonBox(height: 250)),
            ],
          ),
        ];
      case LoadPhase.failed:
        return [
          StateMessage(
            kind: StateKind.error,
            title: 'Products could not load',
            message: 'Check your connection and retry.',
            actionLabel: 'Retry',
            onAction: products.reload,
          ),
        ];
      case LoadPhase.ready:
        if (products.items.isEmpty) {
          return const [
            StateMessage(
              kind: StateKind.empty,
              title: 'No products to show',
              message:
                  'This store has no products with confirmed stock right now.',
            ),
          ];
        }
        return [
          _ListingGrid(
            items: products.items,
            onOpen: (card) => widget.onOpen?.call(context, card.listingId),
          ),
          if (products.loadingMore)
            const Center(child: CircularProgressIndicator())
          else if (products.page?.hasMore == true)
            OutlinedButton(
              onPressed: products.loadMore,
              child: const Text('Load more products'),
            ),
        ];
    }
  }
}
