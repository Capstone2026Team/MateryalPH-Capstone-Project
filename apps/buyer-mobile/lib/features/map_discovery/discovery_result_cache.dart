import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'discovery_models.dart';

/// A saved location's results older than this are never shown. Google Places content is cached on
/// the server for up to 7 days (see `GOOGLE_PLACES_CACHE_TTL_HOURS`); the app keeps its own copy for
/// a shorter 24 hours so a Buyer never sees listings older than a day without a refresh.
const Duration kDiscoveryCacheTtl = Duration(hours: 24);

/// Results younger than this are shown without any request. Older (still within the TTL) results are
/// shown at once and refreshed quietly in the background.
const Duration kDiscoveryFreshWindow = Duration(minutes: 10);

/// A complete, persisted result set for one saved location, radius and default filter set.
class CachedDiscovery {
  const CachedDiscovery({
    required this.items,
    required this.page,
    required this.savedAt,
  });

  final List<SupplierResultView> items;

  /// Counts, scope and attribution of the last full load. Its own `items` are not used.
  final DiscoveryResultPage page;
  final DateTime savedAt;

  bool isExpired(DateTime now) => now.difference(savedAt) >= kDiscoveryCacheTtl;
  bool isFresh(DateTime now) => now.difference(savedAt) < kDiscoveryFreshWindow;
}

/// Where completed searches are kept between app launches.
abstract interface class DiscoveryResultStore {
  Future<CachedDiscovery?> read(String key);
  Future<void> write(String key, CachedDiscovery value);

  /// Removes everything, for sign-out or an expired session.
  Future<void> clear();
}

/// The cache key. Only a saved location is cached: coordinates from the device GPS or a dropped pin
/// stay in memory only. Filtered searches are not cached because they are cheap and rarely repeated.
String? discoveryCacheKey(
  DiscoveryOrigin origin,
  int radiusKm,
  DiscoveryFilters filters,
) {
  if (origin.locationId == null || filters.activeCount > 0) return null;
  return 'loc-${origin.locationId}-r$radiusKm';
}

/// One small JSON file per key under the app's private support directory. At most [maxEntries] are
/// kept; the oldest are deleted first.
final class FileDiscoveryResultStore implements DiscoveryResultStore {
  FileDiscoveryResultStore({this.maxEntries = 12, Directory? directory})
    : _directory = directory;

  final int maxEntries;
  Directory? _directory;

  Future<Directory> _dir() async {
    final existing = _directory;
    if (existing != null) return existing;
    final base = await getApplicationSupportDirectory();
    final dir = Directory('${base.path}${Platform.pathSeparator}discovery_v1');
    if (!await dir.exists()) await dir.create(recursive: true);
    return _directory = dir;
  }

  File _file(Directory dir, String key) => File(
    '${dir.path}${Platform.pathSeparator}${key.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_')}.json',
  );

  @override
  Future<CachedDiscovery?> read(String key) async {
    try {
      final file = _file(await _dir(), key);
      if (!await file.exists()) return null;
      final value = decodeCachedDiscovery(await file.readAsString());
      if (value == null || value.isExpired(DateTime.now())) {
        await file.delete();
        return null;
      }
      return value;
    } catch (_) {
      // A corrupt or unreadable cache is never fatal; the app simply loads fresh results.
      return null;
    }
  }

  @override
  Future<void> write(String key, CachedDiscovery value) async {
    try {
      final dir = await _dir();
      await _file(dir, key).writeAsString(encodeCachedDiscovery(value));
      final files = <File, DateTime>{};
      await for (final entity in dir.list()) {
        if (entity is File) files[entity] = await entity.lastModified();
      }
      if (files.length > maxEntries) {
        final oldest = files.entries.toList()
          ..sort((a, b) => a.value.compareTo(b.value));
        for (final entry in oldest.take(files.length - maxEntries)) {
          await entry.key.delete();
        }
      }
    } catch (_) {
      // Failing to cache must never break discovery.
    }
  }

  @override
  Future<void> clear() async {
    try {
      final dir = await _dir();
      if (await dir.exists()) {
        await dir.delete(recursive: true);
        _directory = null;
      }
    } catch (_) {}
  }
}

String encodeCachedDiscovery(CachedDiscovery value) => jsonEncode({
  'v': 1,
  'saved_at': value.savedAt.toUtc().toIso8601String(),
  'page': _pageToJson(value.page),
  'items': [for (final item in value.items) _itemToJson(item)],
});

CachedDiscovery? decodeCachedDiscovery(String source) {
  try {
    final json = jsonDecode(source) as Map<String, dynamic>;
    if (json['v'] != 1) return null;
    final items = [
      for (final item in json['items'] as List<dynamic>)
        _itemFromJson(item as Map<String, dynamic>),
    ];
    return CachedDiscovery(
      items: items,
      page: _pageFromJson(json['page'] as Map<String, dynamic>, items),
      savedAt: DateTime.parse(json['saved_at'] as String),
    );
  } catch (_) {
    return null;
  }
}

Map<String, Object?> _pageToJson(DiscoveryResultPage page) => {
  'origin_version': page.originVersion,
  'radius_km': page.radiusKm,
  'current_as_of': page.currentAsOf.toUtc().toIso8601String(),
  'verified_count': page.verifiedCount,
  'directory_count': page.directoryCount,
  'favorite_count': page.favoriteCount,
  'eligible_verified_count': page.eligibleVerifiedCount,
  'suggested_radius_km': page.suggestedRadiusKm,
  'at_maximum': page.atMaximum,
  'directory_status': page.directoryStatus,
  'directory_attribution': page.directoryAttribution,
  'directory_as_of': page.directoryAsOf?.toUtc().toIso8601String(),
  'total': page.total,
};

DiscoveryResultPage _pageFromJson(
  Map<String, dynamic> json,
  List<SupplierResultView> items,
) => DiscoveryResultPage(
  items: items,
  originVersion: json['origin_version'] as String,
  radiusKm: json['radius_km'] as int,
  currentAsOf: DateTime.parse(json['current_as_of'] as String),
  verifiedCount: json['verified_count'] as int,
  directoryCount: json['directory_count'] as int,
  favoriteCount: json['favorite_count'] as int,
  eligibleVerifiedCount: json['eligible_verified_count'] as int,
  suggestedRadiusKm: json['suggested_radius_km'] as int?,
  atMaximum: json['at_maximum'] as bool,
  directoryStatus: json['directory_status'] as String,
  directoryAttribution: json['directory_attribution'] as String,
  directoryAsOf: json['directory_as_of'] == null
      ? null
      : DateTime.parse(json['directory_as_of'] as String),
  total: json['total'] as int,
  // A cached set is only written once every page was loaded.
  hasMore: false,
);

Map<String, Object?> _itemToJson(SupplierResultView item) => {
  'id': item.resultId,
  'tier': item.tier.name,
  'rank': item.rank,
  'name': item.name,
  'lat': item.point.latitude,
  'lng': item.point.longitude,
  'distance_m': item.distanceMeters,
  'score_kind': item.scoreKind.name,
  'score_text': item.scoreText,
  'score_value': item.scoreValue,
  'favorite': item.isFavorite,
  'logo_url': item.logoUrl,
  'supplier_type': item.supplierType,
  'niches': item.niches,
  'fulfillment': item.fulfillmentMethod,
  'vacation': item.vacationMode,
  'phone': item.publicPhone,
  'address': item.address,
  'open': item.openState == null
      ? null
      : {
          'status': item.openState!.status,
          'opens_at': item.openState!.opensAt,
          'closes_at': item.openState!.closesAt,
          'override': item.openState!.fromDateOverride,
        },
  'pickup': item.pickupAvailable,
  'delivery': item.delivery,
  'delivery_max_km': item.deliveryMaximumKm,
  'directory_address': item.directoryAddress,
  'directory_type': item.directoryType,
};

SupplierResultView _itemFromJson(Map<String, dynamic> json) {
  final open = json['open'] as Map<String, dynamic>?;
  return SupplierResultView(
    resultId: json['id'] as String,
    tier: SupplierTier.values.byName(json['tier'] as String),
    rank: json['rank'] as int,
    name: json['name'] as String,
    point: GeoPoint(
      (json['lat'] as num).toDouble(),
      (json['lng'] as num).toDouble(),
    ),
    distanceMeters: json['distance_m'] as int,
    scoreKind: ScoreKind.values.byName(json['score_kind'] as String),
    scoreText: json['score_text'] as String,
    scoreValue: json['score_value'] as String?,
    isFavorite: json['favorite'] as bool,
    logoUrl: json['logo_url'] as String?,
    supplierType: json['supplier_type'] as String?,
    niches: [for (final niche in json['niches'] as List<dynamic>) '$niche'],
    fulfillmentMethod: json['fulfillment'] as String?,
    vacationMode: json['vacation'] as bool,
    publicPhone: json['phone'] as String?,
    address: json['address'] as String?,
    openState: open == null
        ? null
        : SupplierOpenState(
            status: open['status'] as String,
            opensAt: open['opens_at'] as String?,
            closesAt: open['closes_at'] as String?,
            fromDateOverride: open['override'] as bool,
          ),
    pickupAvailable: json['pickup'] as bool,
    delivery: json['delivery'] as String?,
    deliveryMaximumKm: json['delivery_max_km'] as int?,
    directoryAddress: json['directory_address'] as String?,
    directoryType: json['directory_type'] as String?,
  );
}
