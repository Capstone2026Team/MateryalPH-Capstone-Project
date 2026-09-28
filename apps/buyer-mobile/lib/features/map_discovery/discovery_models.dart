import 'package:flutter/foundation.dart';

/// Approved Buyer radius allowlist; 5 km is the default and 50 km the platform maximum.
const List<int> kDiscoveryRadiiKm = [5, 10, 20, 30, 40, 50];
const int kDefaultRadiusKm = 5;

@immutable
class GeoPoint {
  const GeoPoint(this.latitude, this.longitude);
  final double latitude;
  final double longitude;

  @override
  bool operator ==(Object other) =>
      other is GeoPoint &&
      other.latitude == latitude &&
      other.longitude == longitude;

  @override
  int get hashCode => Object.hash(latitude, longitude);
}

enum SupplierTier { verified, directory }

enum ScoreKind { vps, newVendor, directory }

enum OriginSource { savedLocation, device, mapPin, search }

/// The active discovery origin. Device coordinates live only in memory for the
/// session and are never persisted unless the Buyer explicitly saves them.
@immutable
class DiscoveryOrigin {
  const DiscoveryOrigin.saved({
    required String this.locationId,
    required this.label,
    required this.point,
  }) : source = OriginSource.savedLocation;

  const DiscoveryOrigin.point({
    required GeoPoint this.point,
    required this.source,
    required this.label,
  }) : locationId = null;

  final String? locationId;
  final GeoPoint? point;
  final OriginSource source;
  final String label;

  /// Stable client identity used to reject responses for an earlier origin.
  String get identity => locationId != null
      ? 'loc:$locationId'
      : 'pt:${point!.latitude.toStringAsFixed(5)},${point!.longitude.toStringAsFixed(5)}';
}

/// A formatted address for the Location header: the country suffix adds nothing in a
/// Philippines-only app and would push the useful part out of the single line.
String displayAddress(String formattedAddress) => formattedAddress
    .replaceFirst(RegExp(r',\s*Philippines$', caseSensitive: false), '')
    .trim();

@immutable
class DiscoveryFilters {
  const DiscoveryFilters({
    this.includeVerified = true,
    this.includeDirectory = true,
    this.favoritesOnly = false,
    this.supplierType,
    this.categoryId,
  });

  final bool includeVerified;
  final bool includeDirectory;
  final bool favoritesOnly;
  final String? supplierType;
  final String? categoryId;

  bool get tierSpecific =>
      favoritesOnly || supplierType != null || categoryId != null;

  int get activeCount =>
      (includeVerified ? 0 : 1) +
      (includeDirectory ? 0 : 1) +
      (favoritesOnly ? 1 : 0) +
      (supplierType != null ? 1 : 0) +
      (categoryId != null ? 1 : 0);

  DiscoveryFilters copyWith({
    bool? includeVerified,
    bool? includeDirectory,
    bool? favoritesOnly,
    ValueGetter<String?>? supplierType,
    ValueGetter<String?>? categoryId,
  }) => DiscoveryFilters(
    includeVerified: includeVerified ?? this.includeVerified,
    includeDirectory: includeDirectory ?? this.includeDirectory,
    favoritesOnly: favoritesOnly ?? this.favoritesOnly,
    supplierType: supplierType != null ? supplierType() : this.supplierType,
    categoryId: categoryId != null ? categoryId() : this.categoryId,
  );
}

@immutable
class SupplierOpenState {
  const SupplierOpenState({
    required this.status,
    this.opensAt,
    this.closesAt,
    this.fromDateOverride = false,
  });

  /// OPEN, CLOSED or UNAVAILABLE. Descriptive only; never filters or ranks.
  final String status;
  final String? opensAt;
  final String? closesAt;
  final bool fromDateOverride;
}

@immutable
class SupplierResultView {
  const SupplierResultView({
    required this.resultId,
    required this.tier,
    required this.rank,
    required this.name,
    required this.point,
    required this.distanceMeters,
    required this.scoreKind,
    required this.scoreText,
    this.scoreValue,
    this.isFavorite = false,
    this.logoUrl,
    this.supplierType,
    this.niches = const [],
    this.fulfillmentMethod,
    this.vacationMode = false,
    this.publicPhone,
    this.address,
    this.openState,
    this.pickupAvailable = false,
    this.delivery,
    this.deliveryMaximumKm,
    this.directoryAddress,
    this.directoryType,
  });

  final String resultId;
  final SupplierTier tier;
  final int rank;
  final String name;
  final GeoPoint point;
  final int distanceMeters;
  final ScoreKind scoreKind;
  final String scoreText;
  final String? scoreValue;
  final bool isFavorite;
  final String? logoUrl;
  final String? supplierType;
  final List<String> niches;
  final String? fulfillmentMethod;
  final bool vacationMode;
  final String? publicPhone;
  final String? address;
  final SupplierOpenState? openState;
  final bool pickupAvailable;

  /// WITHIN_STATED_AREA, OUTSIDE_STATED_AREA or NOT_OFFERED (advisory).
  final String? delivery;
  final int? deliveryMaximumKm;
  final String? directoryAddress;

  /// Google primary place type of a Directory Supplier, e.g. `hardware_store`.
  final String? directoryType;

  bool get isVerified => tier == SupplierTier.verified;

  /// Label shown with the store name on the marker and list row.
  String get markerLabel => '$name · $scoreText';

  SupplierResultView withFavorite(bool favorite) => SupplierResultView(
    resultId: resultId,
    tier: tier,
    rank: rank,
    name: name,
    point: point,
    distanceMeters: distanceMeters,
    scoreKind: scoreKind,
    scoreText: scoreText,
    scoreValue: scoreValue,
    isFavorite: favorite,
    logoUrl: logoUrl,
    supplierType: supplierType,
    niches: niches,
    fulfillmentMethod: fulfillmentMethod,
    vacationMode: vacationMode,
    publicPhone: publicPhone,
    address: address,
    openState: openState,
    pickupAvailable: pickupAvailable,
    delivery: delivery,
    deliveryMaximumKm: deliveryMaximumKm,
    directoryAddress: directoryAddress,
    directoryType: directoryType,
  );
}

@immutable
class DiscoveryResultPage {
  const DiscoveryResultPage({
    required this.items,
    required this.originVersion,
    required this.radiusKm,
    required this.currentAsOf,
    required this.verifiedCount,
    required this.directoryCount,
    required this.favoriteCount,
    required this.eligibleVerifiedCount,
    required this.suggestedRadiusKm,
    required this.atMaximum,
    required this.directoryStatus,
    required this.directoryAttribution,
    required this.total,
    required this.hasMore,
    this.directoryAsOf,
  });

  final List<SupplierResultView> items;
  final String originVersion;
  final int radiusKm;
  final DateTime currentAsOf;
  final int verifiedCount;
  final int directoryCount;
  final int favoriteCount;
  final int eligibleVerifiedCount;
  final int? suggestedRadiusKm;
  final bool atMaximum;

  /// AVAILABLE, CACHED, UNAVAILABLE, NOT_CONFIGURED, FILTERED_OUT or HIDDEN.
  final String directoryStatus;
  final String directoryAttribution;
  final DateTime? directoryAsOf;
  final int total;
  final bool hasMore;
}

@immutable
class RouteEstimateView {
  const RouteEstimateView({
    required this.requestVersion,
    required this.originVersion,
    required this.supplierId,
    required this.distanceMeters,
    required this.durationSeconds,
    required this.straightLineMeters,
    required this.path,
    required this.computedAt,
    required this.trafficAware,
  });

  final String requestVersion;
  final String originVersion;
  final String supplierId;
  final int distanceMeters;
  final int durationSeconds;
  final int straightLineMeters;
  final List<GeoPoint> path;
  final DateTime computedAt;
  final bool trafficAware;
}

@immutable
class DirectoryDetailsView {
  const DirectoryDetailsView({
    required this.resultId,
    required this.name,
    required this.attribution,
    required this.fetchedAt,
    required this.actions,
    this.formattedAddress,
    this.publicPhone,
    this.websiteUri,
    this.googleMapsUri,
    this.openingHours = const [],
    this.googleRatingValue,
    this.googleRatingCount,
  });

  final String resultId;
  final String name;
  final String attribution;
  final DateTime fetchedAt;

  /// Subset of CALL, OPEN_IN_MAPS, WEBSITE and SHARE.
  final List<String> actions;
  final String? formattedAddress;
  final String? publicPhone;
  final String? websiteUri;
  final String? googleMapsUri;
  final List<String> openingHours;
  final String? googleRatingValue;
  final int? googleRatingCount;
}

@immutable
class PsgcSummary {
  const PsgcSummary({
    required this.resolution,
    this.version,
    this.region,
    this.province,
    this.city,
    this.barangay,
  });

  /// RESOLVED, PARTIAL or UNRESOLVED.
  final String resolution;
  final String? version;
  final String? region;
  final String? province;
  final String? city;
  final String? barangay;

  String get description {
    if (resolution == 'UNRESOLVED') {
      return 'PSGC area not resolved. The pinned point is still used for distance.';
    }
    final parts = [
      barangay,
      city,
      province == city ? null : province,
      region,
    ].whereType<String>().where((part) => part.isNotEmpty);
    return '${parts.join(', ')}${version == null ? '' : ' · PSGC $version'}';
  }
}

@immutable
class SavedLocationView {
  const SavedLocationView({
    required this.id,
    required this.label,
    required this.kind,
    required this.isPrimary,
    required this.formattedAddress,
    required this.point,
    required this.psgc,
    required this.lockVersion,
  });

  final String id;
  final String label;
  final String kind;
  final bool isPrimary;
  final String formattedAddress;
  final GeoPoint point;
  final PsgcSummary psgc;
  final int lockVersion;
}

@immutable
class LocationPreviewView {
  const LocationPreviewView({
    required this.point,
    required this.providerStatus,
    required this.psgc,
    required this.resolutionToken,
    this.formattedAddress,
  });

  final GeoPoint point;

  /// AVAILABLE, UNAVAILABLE or NOT_FOUND.
  final String providerStatus;
  final PsgcSummary psgc;
  final String resolutionToken;
  final String? formattedAddress;

  bool get needsManualDescription => formattedAddress == null;
}

@immutable
class CategoryOption {
  const CategoryOption(this.id, this.name);
  final String id;
  final String name;
}

@immutable
class BuyerOnboardingView {
  const BuyerOnboardingView({
    required this.status,
    required this.radiusKm,
    required this.hasPrimaryLocation,
    required this.lockVersion,
    required this.categories,
    this.companyName,
    this.positionTitle,
    this.industry,
    this.industryOtherLabel,
    this.preferredCategoryIds = const [],
  });

  /// NOT_STARTED, SKIPPED or COMPLETED.
  final String status;
  final int radiusKm;
  final bool hasPrimaryLocation;
  final int lockVersion;
  final List<CategoryOption> categories;
  final String? companyName;
  final String? positionTitle;
  final String? industry;
  final String? industryOtherLabel;
  final List<String> preferredCategoryIds;
}

@immutable
class FavoriteSupplierView {
  const FavoriteSupplierView({
    required this.vendorId,
    required this.name,
    required this.scoreText,
    required this.currentlyDiscoverable,
  });

  final String vendorId;
  final String name;
  final String scoreText;
  final bool currentlyDiscoverable;
}

enum DiscoveryFailureKind {
  offline,
  provider,
  sessionExpired,
  forbidden,
  validation,
  notFound,
  conflict,
  rateLimited,
  unknown,
}

class DiscoveryFailure implements Exception {
  const DiscoveryFailure(
    this.kind,
    this.message, {
    this.code,
    this.details = const {},
  });

  final DiscoveryFailureKind kind;
  final String message;
  final String? code;
  final Map<String, Object?> details;

  @override
  String toString() => 'DiscoveryFailure($kind, $code)';
}
