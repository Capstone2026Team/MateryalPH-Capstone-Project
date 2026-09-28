import 'package:flutter/material.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

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
  });

  final String storeId;
  final BuyerStoreRepository repository;

  @override
  State<BuyerPublicStoreProfileScreen> createState() =>
      _BuyerPublicStoreProfileScreenState();
}

class _BuyerPublicStoreProfileScreenState
    extends State<BuyerPublicStoreProfileScreen> {
  late Future<PublicStoreProfile> _profile = widget.repository.profile(
    widget.storeId,
  );
  static const _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  String _time(String value) {
    final parts = value.split(':');
    final hour = int.parse(parts[0]);
    return '${hour % 12 == 0 ? 12 : hour % 12}:${parts[1]} ${hour < 12 ? 'AM' : 'PM'}';
  }

  String _hours(StoreOperatingDay day) =>
      day.status == StoreOperatingDayStatusEnum.CLOSED
      ? 'Closed'
      : '${_time(day.opensAt!)} – ${_time(day.closesAt!)}';

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
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Store Profile could not be loaded.'),
                TextButton(
                  onPressed: () => setState(
                    () => _profile = widget.repository.profile(widget.storeId),
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        final profile = snapshot.data!;
        final schedule = profile.operatingSchedule.toList()
          ..sort((a, b) => a.dayOfWeek.compareTo(b.dayOfWeek));
        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              profile.publicStoreName,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            if (profile.vacationMode == true) ...[
              const SizedBox(height: 12),
              const Text('Vacation Mode · This store has paused new procurement. Existing orders and messaging remain available.'),
            ],
            if (profile.description != null) ...[
              const SizedBox(height: 12),
              Text(profile.description!),
            ],
            const SizedBox(height: 28),
            Text('Store Hours', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text(
              'Normal weekly schedule · Philippine local time. Hours are informational and do not guarantee staff availability.',
            ),
            const SizedBox(height: 12),
            if (profile.hoursStatus ==
                PublicStoreProfileHoursStatusEnum.UNAVAILABLE)
              const Text(
                'Hours unavailable. This store is still listed; check with the store before visiting.',
              ),
            for (final day in schedule)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(_days[day.dayOfWeek - 1]),
                trailing: Text(_hours(day)),
              ),
            if (profile.effectiveToday != null &&
                profile.effectiveSource ==
                    PublicStoreProfileEffectiveSourceEnum.DATE_OVERRIDE) ...[
              const Divider(),
              Text(
                'Today’s hours: ${_hours(profile.effectiveToday!)}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Text('Date-specific schedule'),
            ],
          ],
        );
      },
    ),
  );
}
