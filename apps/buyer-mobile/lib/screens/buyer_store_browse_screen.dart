import 'package:flutter/material.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

import '../design_system/components/procurement_components.dart';
import '../features/item_procurement/procurement_models.dart';
import '../features/item_procurement/procurement_repository.dart';

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
  });

  final String storeId;
  final BuyerStoreRepository repository;

  /// Opens this store's eligible listings in Search Results; null where browsing is unavailable.
  final void Function(BuildContext context, String storeId, String storeName)?
  onBrowseProducts;

  @override
  State<BuyerPublicStoreProfileScreen> createState() =>
      _BuyerPublicStoreProfileScreenState();
}

class _BuyerPublicStoreProfileScreenState
    extends State<BuyerPublicStoreProfileScreen>
    with WidgetsBindingObserver {
  late Future<PublicStoreProfile> _profile = widget.repository.profile(
    widget.storeId,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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
    appBar: AppBar(title: const Text('Store Profile')),
    body: FutureBuilder<PublicStoreProfile>(
      future: _profile,
      builder: (context, snapshot) {
        if (!snapshot.hasData && !snapshot.hasError) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return StateMessage(
            kind: StateKind.error,
            title: 'Store Profile could not be loaded.',
            message: 'Check your connection and retry.',
            actionLabel: 'Retry',
            onAction: _reload,
          );
        }
        final profile = snapshot.data!;
        final hours = storeHoursFromProfile(profile);
        return RefreshIndicator(
          onRefresh: () async => _reload(),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                profile.publicStoreName,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              if (profile.vacationMode == true) ...[
                const SizedBox(height: 12),
                const Text(
                  'Vacation Mode · This store has paused new procurement. Existing orders and messaging remain available.',
                ),
              ],
              if (profile.description != null) ...[
                const SizedBox(height: 12),
                Text(profile.description!),
              ],
              if (widget.onBrowseProducts != null) ...[
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => widget.onBrowseProducts!(
                    context,
                    profile.id,
                    profile.publicStoreName,
                  ),
                  icon: const Icon(Icons.inventory_2_outlined),
                  label: const Text('Browse this store’s products'),
                ),
              ],
              const SizedBox(height: 28),
              StoreHoursSection(hours: hours, onRetry: _reload),
            ],
          ),
        );
      },
    ),
  );
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
