import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

import '../design_system/components/procurement_components.dart';
import '../design_system/theme.dart';
import '../features/item_procurement/procurement_models.dart';
import '../features/item_procurement/procurement_repository.dart';
import '../features/item_procurement/search_results_screen.dart'
    show ListingCard;

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
        ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_error!),
                TextButton(onPressed: _load, child: const Text('Retry')),
              ],
            ),
          )
        : _stores.isEmpty
        ? const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text('No public stores are available yet.'),
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
  });

  /// Loads one page of this store's eligible listings; null result means no location is chosen yet.
  final Future<ListingSearchPage?> Function(ListingSort sort, String? cursor)?
  loadProducts;

  /// Opens Product Details for a listing.
  final void Function(BuildContext context, String listingId)? onOpenListing;

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
  late final _StoreProducts? _products = widget.loadProducts == null
      ? null
      : _StoreProducts(widget.loadProducts!);
  late final TabController _tabs = TabController(length: 3, vsync: this)
    ..addListener(() {
      if (!_tabs.indexIsChanging && mounted) setState(() {});
    });

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

  void _reload() =>
      setState(() => _profile = widget.repository.profile(widget.storeId));

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
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
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
        return RefreshIndicator(
          onRefresh: () async => _reload(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _StoreHeader(profile: profile, hours: hours),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _TabBarDelegate(
                  TabBar(
                    controller: _tabs,
                    labelColor: BuyerTheme.action,
                    unselectedLabelColor: BuyerTheme.ink,
                    indicatorColor: BuyerTheme.action,
                    indicatorWeight: 3,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                    tabs: const [
                      Tab(text: 'Shop Front'),
                      Tab(text: 'Products'),
                      Tab(text: 'Store Profile'),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                sliver: SliverToBoxAdapter(
                  child: switch (_tabs.index) {
                    0 => _ShopFrontTab(
                      profile: profile,
                      onMessage: widget.onMessage,
                      onBrowseProducts: widget.onBrowseProducts,
                      onProfile: () => _tabs.animateTo(2),
                    ),
                    1 => _ProductsTab(
                      profile: profile,
                      products: _products,
                      onOpen: widget.onOpenListing,
                      onBrowseProducts: widget.onBrowseProducts,
                    ),
                    _ => _StoreDetailsTab(
                      profile: profile,
                      hours: hours,
                      onRetry: _reload,
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

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: 'Back',
    child: Material(
      color: BuyerTheme.action,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => Navigator.of(context).maybePop(),
        child: const SizedBox(
          width: 44,
          height: 44,
          child: Icon(LucideIcons.arrowLeft, color: Colors.white, size: 22),
        ),
      ),
    ),
  );
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  _TabBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

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
        Expanded(child: tabBar),
        const Divider(height: 1, color: BuyerTheme.border),
      ],
    ),
  );

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) =>
      oldDelegate.tabBar != tabBar;
}

/// Banner with the back control, the overlapping logo and the store identity: name, VPS / New
/// Vendor label, supplier type, location and an informational open-now label.
class _StoreHeader extends StatelessWidget {
  const _StoreHeader({required this.profile, required this.hours});

  final PublicStoreProfile profile;
  final StoreHoursView hours;

  static const _logo = 68.0;

  @override
  Widget build(BuildContext context) {
    final city = [
      profile.address.cityMunicipality,
      profile.address.province,
    ].whereType<String>().where((part) => part.isNotEmpty).join(', ');
    final openNow = hours.available
        ? (hours.openNowStatus == 'OPEN' ? 'Open now' : 'Closed now')
        : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              height: 168,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
                child: _Media(
                  url: profile.bannerUrl,
                  fallbackIcon: LucideIcons.store,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.paddingOf(context).top + 8,
              left: 16,
              child: _BackButton(),
            ),
            Positioned(
              left: 20,
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
          padding: EdgeInsets.fromLTRB(20 + _logo + 12, 10, 20, 0),
          child: Semantics(
            header: true,
            child: Text(
              profile.publicStoreName,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _Pill(
                icon: LucideIcons.badgeCheck,
                label: profile.scoreLabel.text,
                emphasis: true,
              ),
              if (profile.supplierType != null &&
                  profile.supplierType!.isNotEmpty)
                _Pill(
                  icon: LucideIcons.building2,
                  label: _humanize(profile.supplierType!),
                ),
              if (openNow != null)
                _Pill(
                  icon: hours.openNowStatus == 'OPEN'
                      ? LucideIcons.circleCheck
                      : LucideIcons.clock,
                  label: openNow,
                ),
              if (city.isNotEmpty) _Pill(icon: LucideIcons.mapPin, label: city),
            ],
          ),
        ),
        if (profile.vacationMode)
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: StatusBand(
              tone: BandTone.warning,
              title: 'Vacation Mode',
              message:
                  'This store has paused new procurement. Existing orders and messaging remain available.',
            ),
          ),
        const SizedBox(height: 8),
      ],
    );
  }
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
  const _Pill({required this.icon, required this.label, this.emphasis = false});

  final IconData icon;
  final String label;
  final bool emphasis;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: emphasis ? BuyerTheme.brandSoft : Colors.white,
      borderRadius: BorderRadius.circular(999),
      border: Border.all(
        color: emphasis ? BuyerTheme.action : BuyerTheme.border,
      ),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: emphasis ? BuyerTheme.action : BuyerTheme.ink,
        ),
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Semantics(
      header: true,
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
      ),
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
  const _Chips(this.labels, {this.icon});

  final List<String> labels;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      for (final label in labels)
        _Pill(icon: icon ?? LucideIcons.tag, label: label),
    ],
  );
}

class _ShopFrontTab extends StatelessWidget {
  const _ShopFrontTab({
    required this.profile,
    required this.onMessage,
    required this.onBrowseProducts,
    required this.onProfile,
  });

  final PublicStoreProfile profile;
  final VoidCallback? onMessage;
  final void Function(BuildContext context, String storeId, String storeName)?
  onBrowseProducts;
  final VoidCallback onProfile;

  @override
  Widget build(BuildContext context) {
    final services = _services(profile.fulfillmentMethod);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (onBrowseProducts != null)
          FilledButton.icon(
            onPressed: () =>
                onBrowseProducts!(context, profile.id, profile.publicStoreName),
            icon: const Icon(LucideIcons.packageSearch),
            label: const Text('Browse this store’s products'),
          ),
        if (onMessage != null) ...[
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onMessage,
            icon: const Icon(LucideIcons.messageSquare),
            label: const Text('Message store'),
          ),
        ],
        if (profile.description != null && profile.description!.isNotEmpty) ...[
          const SizedBox(height: 24),
          const _SectionTitle('About this store'),
          Text(profile.description!, style: const TextStyle(height: 1.45)),
        ],
        if (profile.niches.isNotEmpty) ...[
          const SizedBox(height: 24),
          const _SectionTitle('What this store supplies'),
          _Chips(profile.niches.toList()),
        ],
        if (services.isNotEmpty) ...[
          const SizedBox(height: 24),
          const _SectionTitle('Services'),
          _Chips(services, icon: LucideIcons.truck),
        ],
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: onProfile,
            icon: const Icon(LucideIcons.clock),
            label: const Text('See address and store hours'),
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
    required this.onRetry,
  });

  final PublicStoreProfile profile;
  final StoreHoursView hours;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final services = _services(profile.fulfillmentMethod);
    final rows = <(IconData, String, String)>[
      if (profile.address.formattedAddress != null)
        (LucideIcons.mapPin, 'Address', profile.address.formattedAddress!),
      if (profile.publicPhone != null && profile.publicPhone!.isNotEmpty)
        (LucideIcons.phone, 'Phone', profile.publicPhone!),
      if (profile.publicEmail != null && profile.publicEmail!.isNotEmpty)
        (LucideIcons.mail, 'Email', profile.publicEmail!),
      if (services.isNotEmpty)
        (LucideIcons.truck, 'Services', services.join(' | ')),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (profile.niches.isNotEmpty) ...[
          _Chips(profile.niches.toList()),
          const SizedBox(height: 16),
        ],
        if (profile.description != null && profile.description!.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: BuyerTheme.ink, width: 1.2),
            ),
            child: Text(
              profile.description!,
              style: const TextStyle(height: 1.45),
            ),
          ),
        const SizedBox(height: 8),
        for (final (icon, label, value) in rows)
          Semantics(
            container: true,
            label: '$label: $value',
            excludeSemantics: true,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: BuyerTheme.border)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 20, color: BuyerTheme.action),
                  const SizedBox(width: 14),
                  Expanded(child: Text(value)),
                ],
              ),
            ),
          ),
        const SizedBox(height: 24),
        StoreHoursSection(hours: hours, onRetry: onRetry),
      ],
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
          style: Theme.of(context).textTheme.titleLarge,
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
        style: const TextStyle(fontSize: 12),
      ),
    ],
  );
}

/// One store's listings for the Products tab: server-sorted, cursor-paged, and held by the profile
/// screen so switching tabs does not reload them.
class _StoreProducts extends ChangeNotifier {
  _StoreProducts(this._load);

  final Future<ListingSearchPage?> Function(ListingSort sort, String? cursor)
  _load;

  ListingSort sort = ListingSort.bestDeal;
  LoadPhase phase = LoadPhase.loading;
  List<ListingCardView> items = const [];
  ListingSearchPage? page;
  bool loadingMore = false;
  bool _started = false;
  bool _disposed = false;
  int _sequence = 0;

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
          const _SectionTitle('Products'),
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
    return SizedBox(
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (final option in const [ListingSort.bestDeal, ListingSort.rating])
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterPill(
                label: option == ListingSort.rating
                    ? 'Top Rated'
                    : option.label,
                selected: sort == option,
                onTap: () => products.reload(sort: option),
              ),
            ),
          FilterPill(
            label: 'Price',
            selected: price,
            trailingIcon: !price || !sort.descending
                ? LucideIcons.arrowUpNarrowWide
                : LucideIcons.arrowDownWideNarrow,
            onTap: () => products.reload(
              sort: price ? sort.reversed : ListingSort.price,
            ),
          ),
        ],
      ),
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
        final columns = MediaQuery.textScalerOf(context).scale(1) > 1.3 ? 1 : 2;
        final rows = (products.items.length / columns).ceil();
        return [
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
                        child: row * columns + column < products.items.length
                            ? ListingCard(
                                card: products.items[row * columns + column],
                                showFavorite: false,
                                onOpen: () => widget.onOpen?.call(
                                  context,
                                  products
                                      .items[row * columns + column]
                                      .listingId,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ],
                ),
              ),
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
