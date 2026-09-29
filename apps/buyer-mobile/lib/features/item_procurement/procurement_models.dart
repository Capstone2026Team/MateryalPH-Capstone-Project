import 'package:flutter/foundation.dart';

enum LoadPhase { needsOrigin, loading, ready, failed }

/// Item-Based sorts. Browsing defaults to distance and a text query to Best Deal (SRS); Favorites
/// First is a separate explicit choice that never changes Best Deal.
enum ListingSort {
  bestDeal,
  distance,
  price,
  rating,
  favoritesFirst,
  distanceDescending,
  priceDescending,
  ratingAscending,
}

extension ListingSortWire on ListingSort {
  String get wire => switch (this) {
    ListingSort.bestDeal => 'BEST_DEAL',
    ListingSort.distance => 'DISTANCE',
    ListingSort.price => 'PRICE',
    ListingSort.rating => 'RATING',
    ListingSort.favoritesFirst => 'FAVORITES_FIRST',
    ListingSort.distanceDescending => 'DISTANCE_DESC',
    ListingSort.priceDescending => 'PRICE_DESC',
    ListingSort.ratingAscending => 'RATING_ASC',
  };

  String get label => switch (this) {
    ListingSort.bestDeal => 'Best Deal',
    ListingSort.distance => 'Distance',
    ListingSort.price => 'Price',
    ListingSort.rating => 'Rating',
    ListingSort.favoritesFirst => 'Favorites First',
    ListingSort.distanceDescending => 'Distance',
    ListingSort.priceDescending => 'Price',
    ListingSort.ratingAscending => 'Rating',
  };

  ListingSort get family => switch (this) {
    ListingSort.distanceDescending => ListingSort.distance,
    ListingSort.priceDescending => ListingSort.price,
    ListingSort.ratingAscending => ListingSort.rating,
    _ => this,
  };

  ListingSort get reversed => switch (this) {
    ListingSort.distance => ListingSort.distanceDescending,
    ListingSort.distanceDescending => ListingSort.distance,
    ListingSort.price => ListingSort.priceDescending,
    ListingSort.priceDescending => ListingSort.price,
    ListingSort.rating => ListingSort.ratingAscending,
    ListingSort.ratingAscending => ListingSort.rating,
    _ => this,
  };

  bool get descending =>
      this == ListingSort.distanceDescending ||
      this == ListingSort.priceDescending ||
      this == ListingSort.rating;

  static ListingSort parse(String value) => switch (value) {
    'BEST_DEAL' => ListingSort.bestDeal,
    'PRICE' => ListingSort.price,
    'RATING' => ListingSort.rating,
    'FAVORITES_FIRST' => ListingSort.favoritesFirst,
    'DISTANCE_DESC' => ListingSort.distanceDescending,
    'PRICE_DESC' => ListingSort.priceDescending,
    'RATING_ASC' => ListingSort.ratingAscending,
    _ => ListingSort.distance,
  };
}

/// Formats integer centavos as Philippine pesos with grouping, never through binary floating point.
String formatPeso(int centavos) {
  final negative = centavos < 0;
  final absolute = centavos.abs();
  final pesos = (absolute ~/ 100).toString();
  final grouped = pesos.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );
  final cents = (absolute % 100).toString().padLeft(2, '0');
  return '${negative ? '-' : ''}₱$grouped.$cents';
}

String formatDistance(int meters) =>
    meters < 1000 ? '$meters m' : '${(meters / 1000).toStringAsFixed(1)} km';

/// A decimal quantity string without trailing zeros ("12.5000" → "12.5", "3.0000" → "3").
String formatQuantity(String quantity) {
  if (!quantity.contains('.')) return quantity;
  final trimmed = quantity.replaceFirst(RegExp(r'0+$'), '');
  return trimmed.endsWith('.')
      ? trimmed.substring(0, trimmed.length - 1)
      : trimmed;
}

@immutable
class ListingFilters {
  const ListingFilters({
    this.categoryId,
    this.categoryName,
    this.favoritesOnly = false,
    this.fulfillment,
    this.inStockOnly = false,
    this.verifiedComplianceOnly = false,
    this.vendorId,
    this.vendorName,
  });

  final String? categoryId;
  final String? categoryName;
  final bool favoritesOnly;

  /// DELIVERY, PICKUP or null for any.
  final String? fulfillment;
  final bool inStockOnly;
  final bool verifiedComplianceOnly;
  final String? vendorId;
  final String? vendorName;

  int get activeCount =>
      (categoryId != null ? 1 : 0) +
      (favoritesOnly ? 1 : 0) +
      (fulfillment != null ? 1 : 0) +
      (inStockOnly ? 1 : 0) +
      (verifiedComplianceOnly ? 1 : 0) +
      (vendorId != null ? 1 : 0);

  ListingFilters copyWith({
    ValueGetter<String?>? categoryId,
    ValueGetter<String?>? categoryName,
    bool? favoritesOnly,
    ValueGetter<String?>? fulfillment,
    bool? inStockOnly,
    bool? verifiedComplianceOnly,
    ValueGetter<String?>? vendorId,
    ValueGetter<String?>? vendorName,
  }) => ListingFilters(
    categoryId: categoryId != null ? categoryId() : this.categoryId,
    categoryName: categoryName != null ? categoryName() : this.categoryName,
    favoritesOnly: favoritesOnly ?? this.favoritesOnly,
    fulfillment: fulfillment != null ? fulfillment() : this.fulfillment,
    inStockOnly: inStockOnly ?? this.inStockOnly,
    verifiedComplianceOnly:
        verifiedComplianceOnly ?? this.verifiedComplianceOnly,
    vendorId: vendorId != null ? vendorId() : this.vendorId,
    vendorName: vendorName != null ? vendorName() : this.vendorName,
  );

  @override
  bool operator ==(Object other) =>
      other is ListingFilters &&
      other.categoryId == categoryId &&
      other.favoritesOnly == favoritesOnly &&
      other.fulfillment == fulfillment &&
      other.inStockOnly == inStockOnly &&
      other.verifiedComplianceOnly == verifiedComplianceOnly &&
      other.vendorId == vendorId;

  @override
  int get hashCode => Object.hash(
    categoryId,
    favoritesOnly,
    fulfillment,
    inStockOnly,
    verifiedComplianceOnly,
    vendorId,
  );
}

@immutable
class CategoryCountView {
  const CategoryCountView({
    required this.id,
    required this.code,
    required this.name,
    required this.vendorListings,
  });

  final String id;
  final String code;
  final String name;
  final int vendorListings;
}

@immutable
class ExploreSummaryView {
  const ExploreSummaryView({
    required this.originVersion,
    required this.radiusKm,
    required this.scopeLabel,
    required this.currentAsOf,
    required this.verifiedVendors,
    required this.vendorListings,
    required this.vendorsLabel,
    required this.listingsLabel,
    required this.listingsUnit,
    required this.categories,
    required this.analyticsEnabled,
    required this.analyticsMessage,
    this.datasetLabel,
  });

  final String originVersion;
  final int radiusKm;
  final String scopeLabel;
  final DateTime currentAsOf;
  final int verifiedVendors;
  final int vendorListings;
  final String vendorsLabel;
  final String listingsLabel;
  final String listingsUnit;
  final List<CategoryCountView> categories;
  final bool analyticsEnabled;
  final String analyticsMessage;
  final String? datasetLabel;
}

@immutable
class RankingComponentView {
  const RankingComponentView({
    required this.key,
    required this.label,
    required this.weightPercent,
    required this.score,
    required this.weighted,
    required this.basis,
  });

  final String key;
  final String label;
  final int weightPercent;
  final String score;
  final String weighted;
  final String basis;
}

@immutable
class ListingCardView {
  const ListingCardView({
    required this.listingId,
    required this.variantId,
    required this.rank,
    required this.displayName,
    required this.unitPriceCentavos,
    required this.unitName,
    required this.vatLabel,
    required this.stockLabel,
    required this.stockConfirmedAt,
    required this.ratingLabel,
    required this.ratingAverage,
    required this.unitsSold,
    required this.distanceMeters,
    required this.badges,
    required this.isFavorite,
    required this.vendorId,
    required this.vendorName,
    required this.vendorScore,
    required this.pickupAvailable,
    required this.delivery,
    required this.optionsCount,
    required this.srs,
    required this.components,
    this.imageUrl,
    this.imageAlt,
    this.brand,
    this.variantLabel,
    this.normalizedUnitPrice,
    this.canonicalUnitCode,
  });

  final String listingId;
  final String variantId;
  final int rank;
  final String displayName;
  final int unitPriceCentavos;
  final String unitName;
  final String vatLabel;
  final String stockLabel;
  final DateTime stockConfirmedAt;
  final String ratingLabel;
  final String? ratingAverage;
  final String unitsSold;
  final int distanceMeters;
  final List<String> badges;
  final bool isFavorite;
  final String vendorId;
  final String vendorName;
  final String vendorScore;
  final bool pickupAvailable;
  final String delivery;
  final int optionsCount;
  final String srs;
  final List<RankingComponentView> components;
  final String? imageUrl;
  final String? imageAlt;
  final String? brand;
  final String? variantLabel;
  final String? normalizedUnitPrice;
  final String? canonicalUnitCode;

  bool get bestPrice => badges.contains('BEST_PRICE');
  bool get psIccVerified => badges.contains('PS_ICC_VERIFIED');
}

@immutable
class RankingWeights {
  const RankingWeights({
    required this.distance,
    required this.price,
    required this.vps,
    required this.stock,
    required this.productRating,
  });

  static const approvedDefault = RankingWeights(
    distance: 30,
    price: 25,
    vps: 20,
    stock: 15,
    productRating: 10,
  );

  final int distance;
  final int price;
  final int vps;
  final int stock;
  final int productRating;

  int get total => distance + price + vps + stock + productRating;
  bool get valid => total == 100;

  int valueOf(String key) => switch (key) {
    'distance' => distance,
    'price' => price,
    'vps' => vps,
    'stock' => stock,
    _ => productRating,
  };

  RankingWeights withValue(String key, int value) => RankingWeights(
    distance: key == 'distance' ? value : distance,
    price: key == 'price' ? value : price,
    vps: key == 'vps' ? value : vps,
    stock: key == 'stock' ? value : stock,
    productRating: key == 'product_rating' ? value : productRating,
  );

  /// Largest-remainder allocation with stable factor-order ties. A slider drag should
  /// use its starting weights as the basis to avoid cumulative rounding drift.
  RankingWeights rebalance(
    String key,
    int value, {
    required RankingWeights defaults,
  }) {
    const keys = ['distance', 'price', 'vps', 'stock', 'product_rating'];
    if (!keys.contains(key)) throw ArgumentError.value(key, 'key');
    final target = value.clamp(0, 100);
    final others = keys.where((item) => item != key).toList();
    var basis = this;
    var sum = others.fold(0, (sum, item) => sum + basis.valueOf(item));
    if (sum == 0) {
      basis = defaults;
      sum = others.fold(0, (sum, item) => sum + basis.valueOf(item));
    }
    final denominator = sum == 0 ? others.length : sum;
    final numerators = {
      for (final item in others)
        item: (100 - target) * (sum == 0 ? 1 : basis.valueOf(item)),
    };
    final allocated = {
      for (final item in others) item: numerators[item]! ~/ denominator,
    };
    final remaining = 100 - target - allocated.values.fold(0, (a, b) => a + b);
    final order = [...others]
      ..sort((a, b) {
        final remainder = (numerators[b]! % denominator).compareTo(
          numerators[a]! % denominator,
        );
        return remainder != 0
            ? remainder
            : keys.indexOf(a).compareTo(keys.indexOf(b));
      });
    for (var i = 0; i < remaining; i++) {
      allocated[order[i]] = allocated[order[i]]! + 1;
    }
    var result = withValue(key, target);
    for (final item in others) {
      result = result.withValue(item, allocated[item]!);
    }
    return result;
  }

  @override
  bool operator ==(Object other) =>
      other is RankingWeights &&
      other.distance == distance &&
      other.price == price &&
      other.vps == vps &&
      other.stock == stock &&
      other.productRating == productRating;

  @override
  int get hashCode => Object.hash(distance, price, vps, stock, productRating);
}

@immutable
class RankingPreferencesView {
  const RankingPreferencesView({
    required this.weights,
    required this.defaults,
    required this.personalized,
    required this.version,
  });

  final RankingWeights weights;
  final RankingWeights defaults;
  final bool personalized;
  final int version;
}

@immutable
class ListingSearchPage {
  const ListingSearchPage({
    required this.items,
    required this.sort,
    required this.defaultSort,
    required this.total,
    required this.hasMore,
    required this.currentAsOf,
    required this.personalized,
    required this.originVersion,
    this.nextCursor,
    this.suggestedRadiusKm,
  });

  final List<ListingCardView> items;
  final ListingSort sort;
  final ListingSort defaultSort;
  final int total;
  final bool hasMore;
  final DateTime currentAsOf;
  final bool personalized;
  final String originVersion;
  final String? nextCursor;
  final int? suggestedRadiusKm;
}

@immutable
class VolumeTierView {
  const VolumeTierView({
    required this.minimumQuantity,
    required this.amountCentavos,
  });

  final String minimumQuantity;
  final int amountCentavos;
}

@immutable
class VariantOfferView {
  const VariantOfferView({
    required this.variantId,
    required this.label,
    required this.unitName,
    required this.quantityStep,
    required this.available,
    required this.volumeTiers,
    required this.bestPrice,
    this.stockLabel,
    this.priceVersionId,
    this.unitPriceCentavos,
    this.vatLabel,
    this.includedVatCentavos,
    this.availabilityNote,
    this.comparable = false,
    this.attributes = const {},
    this.sku,
  });

  final String variantId;
  final String label;
  final String unitName;
  final String quantityStep;
  final bool available;
  final List<VolumeTierView> volumeTiers;
  final bool bestPrice;
  final String? stockLabel;
  final String? priceVersionId;
  final int? unitPriceCentavos;
  final String? vatLabel;
  final int? includedVatCentavos;
  final String? availabilityNote;
  final bool comparable;
  final Map<String, String> attributes;
  final String? sku;

  int? priceForQuantity(int quantity) {
    var price = unitPriceCentavos;
    var threshold = 0.0;
    for (final tier in volumeTiers) {
      final minimum = double.parse(tier.minimumQuantity);
      if (minimum <= quantity && minimum >= threshold) {
        price = tier.amountCentavos;
        threshold = minimum;
      }
    }
    return price;
  }

  bool get wholeUnits => quantityStep == '1';
}

@immutable
class ListingDetailView {
  const ListingDetailView({
    required this.listingId,
    required this.displayName,
    required this.images,
    required this.variants,
    required this.vendorId,
    required this.vendorName,
    required this.vendorScore,
    required this.vendorAddress,
    required this.vendorOpenStatus,
    required this.distanceMeters,
    required this.pickupAvailable,
    required this.delivery,
    required this.fulfillmentNotice,
    required this.complianceNotice,
    required this.ratingLabel,
    required this.unitsSold,
    required this.isFavorite,
    required this.purchasable,
    required this.attributes,
    required this.currentAsOf,
    this.description,
    this.brand,
    this.manufacturer,
    this.countryOfManufacture,
    this.categoryName,
    this.complianceBadge,
    this.notPurchasableReason,
    this.deliveryMaximumKm,
  });

  final String listingId;
  final String displayName;
  final List<({String url, String? alt})> images;
  final List<VariantOfferView> variants;
  final String vendorId;
  final String vendorName;
  final String vendorScore;
  final String? vendorAddress;
  final String vendorOpenStatus;
  final int distanceMeters;
  final bool pickupAvailable;
  final String delivery;
  final String fulfillmentNotice;
  final String complianceNotice;
  final String ratingLabel;
  final String unitsSold;
  final bool isFavorite;
  final bool purchasable;
  final Map<String, String> attributes;
  final DateTime currentAsOf;
  final String? description;
  final String? brand;
  final String? manufacturer;
  final String? countryOfManufacture;
  final String? categoryName;
  final String? complianceBadge;
  final String? notPurchasableReason;
  final int? deliveryMaximumKm;

  bool get deliveryOffered => delivery != 'NOT_OFFERED';
}

@immutable
class CartIssueView {
  const CartIssueView({
    required this.code,
    required this.severity,
    required this.message,
  });

  final String code;

  /// BLOCKING, ACTION_REQUIRED or INFO.
  final String severity;
  final String message;

  bool get blocking => severity == 'BLOCKING';
  bool get actionRequired => severity == 'ACTION_REQUIRED';
}

@immutable
class CartLineView {
  const CartLineView({
    required this.id,
    required this.listingId,
    required this.variantId,
    required this.vendorId,
    required this.displayName,
    required this.unitName,
    required this.quantity,
    required this.quantityStep,
    required this.savedForLater,
    required this.issues,
    required this.status,
    this.variantLabel,
    this.imageUrl,
    this.snapshotUnitPriceCentavos,
    this.currentUnitPriceCentavos,
    this.appliedUnitPriceCentavos,
    this.volumeTierApplied = false,
    this.stockLabel,
    this.lineTotalCentavos,
  });

  final String id;
  final String listingId;
  final String variantId;
  final String vendorId;
  final String displayName;
  final String unitName;
  final String quantity;
  final String quantityStep;
  final bool savedForLater;
  final List<CartIssueView> issues;

  /// READY, ACTION_REQUIRED or BLOCKED.
  final String status;
  final String? variantLabel;
  final String? imageUrl;
  final int? snapshotUnitPriceCentavos;
  final int? currentUnitPriceCentavos;
  final int? appliedUnitPriceCentavos;
  final bool volumeTierApplied;
  final String? stockLabel;
  final int? lineTotalCentavos;

  bool get available => currentUnitPriceCentavos != null;
  bool get priceChanged => issues.any((issue) => issue.code == 'PRICE_CHANGED');
}

@immutable
class CartGroupView {
  const CartGroupView({
    required this.vendorId,
    required this.vendorName,
    required this.vacationMode,
    required this.fulfillmentOptions,
    required this.lines,
    required this.materialsSubtotalCentavos,
    required this.status,
    this.fulfillmentMethod,
  });

  final String vendorId;
  final String vendorName;
  final bool vacationMode;
  final List<String> fulfillmentOptions;
  final List<CartLineView> lines;
  final int materialsSubtotalCentavos;
  final String status;
  final String? fulfillmentMethod;
}

@immutable
class CartLocationView {
  const CartLocationView({
    required this.locationId,
    required this.kind,
    required this.active,
    this.label,
    this.formattedAddress,
  });

  final String locationId;
  final String kind;
  final bool active;
  final String? label;
  final String? formattedAddress;

  String get title => label ?? formattedAddress ?? 'Saved location';
}

@immutable
class CartDestinationView {
  const CartDestinationView({
    required this.heavyVehicleRestriction,
    required this.intendedLabel,
    required this.endpointLabel,
    this.intended,
    this.alternateDropOff,
    this.vehicleEndpoint,
    this.accessInstructions,
  });

  /// UNANSWERED, NO or YES.
  final String heavyVehicleRestriction;
  final String intendedLabel;
  final String endpointLabel;
  final CartLocationView? intended;
  final CartLocationView? alternateDropOff;
  final String? vehicleEndpoint;
  final String? accessInstructions;

  static const empty = CartDestinationView(
    heavyVehicleRestriction: 'UNANSWERED',
    intendedLabel: 'Intended destination / Project site',
    endpointLabel: 'Actual vehicle drop-off',
  );
}

@immutable
class CartView {
  const CartView({
    required this.id,
    required this.lockVersion,
    required this.groups,
    required this.savedForLater,
    required this.destination,
    required this.lineCount,
    required this.materialsSubtotalCentavos,
    required this.notice,
    required this.currentAsOf,
  });

  final String id;
  final int lockVersion;
  final List<CartGroupView> groups;
  final List<CartLineView> savedForLater;
  final CartDestinationView destination;
  final int lineCount;
  final int materialsSubtotalCentavos;
  final String notice;
  final DateTime currentAsOf;

  bool get empty => groups.isEmpty && savedForLater.isEmpty;
  bool get anyDelivery =>
      groups.any((group) => group.fulfillmentMethod == 'DELIVERY');
}

@immutable
class DeliveryEstimateView {
  const DeliveryEstimateView({
    required this.feeMinCentavos,
    required this.feeMaxCentavos,
    required this.tripsMin,
    required this.tripsMax,
    required this.vehiclesMin,
    required this.vehiclesMax,
  });

  final int feeMinCentavos;
  final int feeMaxCentavos;
  final int tripsMin;
  final int tripsMax;
  final int vehiclesMin;
  final int vehiclesMax;
}

@immutable
class DeliveryPreviewView {
  const DeliveryPreviewView({
    required this.status,
    required this.issues,
    required this.manualReviewReasons,
    required this.confirmedOffer,
    this.endpoint,
    this.routeDistanceMeters,
    this.routeBasis,
    this.straightLineMeters,
    this.coverageKm,
    this.estimate,
    this.notice,
  });

  /// NOT_APPLICABLE, ACTION_REQUIRED, BLOCKED, MANUAL_REVIEW or ADVISORY_ESTIMATE.
  final String status;
  final List<CartIssueView> issues;
  final List<String> manualReviewReasons;

  /// Always false in a preview; a confirmed offer exists only after Vendor confirmation.
  final bool confirmedOffer;
  final String? endpoint;
  final int? routeDistanceMeters;
  final String? routeBasis;
  final int? straightLineMeters;
  final int? coverageKm;
  final DeliveryEstimateView? estimate;
  final String? notice;
}

@immutable
class PaymentMethodView {
  const PaymentMethodView({
    required this.method,
    required this.available,
    this.reason,
  });

  final String method;
  final bool available;
  final String? reason;

  String get label => switch (method) {
    'ONLINE' => 'Online payment',
    'CASH_ON_DELIVERY' => 'Cash on Delivery',
    _ => 'In-Store Payment',
  };
}

@immutable
class AmountsView {
  const AmountsView({
    required this.materialsSubtotalCentavos,
    required this.includedVatCentavos,
    required this.vatExclusiveCentavos,
    required this.vatIncluded,
    required this.deliveryStatus,
    required this.excludes,
    this.deliveryMinCentavos,
    this.deliveryMaxCentavos,
    this.totalMinCentavos,
    this.totalMaxCentavos,
  });

  final int materialsSubtotalCentavos;
  final int includedVatCentavos;
  final int vatExclusiveCentavos;
  final bool vatIncluded;

  /// ESTIMATE, NOT_APPLICABLE or PENDING_VENDOR_REVIEW.
  final String deliveryStatus;
  final List<String> excludes;
  final int? deliveryMinCentavos;
  final int? deliveryMaxCentavos;
  final int? totalMinCentavos;
  final int? totalMaxCentavos;
}

@immutable
class CheckoutGroupView {
  const CheckoutGroupView({
    required this.vendorId,
    required this.vendorName,
    required this.status,
    required this.issues,
    required this.lines,
    required this.delivery,
    required this.paymentMethods,
    required this.amounts,
    required this.fulfillmentOptions,
    this.fulfillmentMethod,
    this.pickupAddress,
  });

  final String vendorId;
  final String vendorName;

  /// READY, ACTION_REQUIRED or BLOCKED.
  final String status;
  final List<CartIssueView> issues;
  final List<CartLineView> lines;
  final DeliveryPreviewView delivery;
  final List<PaymentMethodView> paymentMethods;
  final AmountsView amounts;
  final List<String> fulfillmentOptions;
  final String? fulfillmentMethod;
  final String? pickupAddress;
}

@immutable
class CheckoutPreviewView {
  const CheckoutPreviewView({
    required this.requestVersion,
    required this.cartLockVersion,
    required this.destination,
    required this.groups,
    required this.readyGroups,
    required this.blockedGroups,
    required this.actionRequiredGroups,
    required this.requiresSplitConfirmation,
    required this.notice,
    required this.currentAsOf,
  });

  final String? requestVersion;
  final int cartLockVersion;
  final CartDestinationView destination;
  final List<CheckoutGroupView> groups;
  final int readyGroups;
  final int blockedGroups;
  final int actionRequiredGroups;
  final bool requiresSplitConfirmation;
  final String notice;
  final DateTime currentAsOf;
}

@immutable
class StoreHoursDayView {
  const StoreHoursDayView({
    required this.date,
    required this.weekday,
    required this.open,
    required this.fromOverride,
    this.opensAt,
    this.closesAt,
  });

  /// Asia/Manila calendar date as sent by the server ("2026-09-30"); never re-derived on the phone.
  final String date;
  final String weekday;
  final bool open;
  final bool fromOverride;
  final String? opensAt;
  final String? closesAt;
}

@immutable
class StoreHoursView {
  const StoreHoursView({
    required this.available,
    required this.week,
    required this.openNowStatus,
    required this.allClosed,
    required this.asOf,
    required this.notice,
    this.closesAt,
    this.nextOpeningDate,
    this.nextOpeningWeekday,
    this.nextOpeningTime,
  });

  final bool available;
  final List<StoreHoursDayView> week;

  /// OPEN, CLOSED or UNAVAILABLE.
  final String openNowStatus;
  final bool allClosed;
  final DateTime asOf;
  final String notice;
  final String? closesAt;
  final String? nextOpeningDate;
  final String? nextOpeningWeekday;
  final String? nextOpeningTime;
}

/// "08:30" → "8:30 AM"; the value is already Philippine local time from the server.
String formatClock(String value) {
  final parts = value.split(':');
  final hour = int.parse(parts[0]);
  return '${hour % 12 == 0 ? 12 : hour % 12}:${parts[1]} ${hour < 12 ? 'AM' : 'PM'}';
}

/// Formats an instant in Asia/Manila (UTC+8, no daylight saving) independent of the phone's zone.
String formatManilaTimestamp(DateTime instant) {
  final manila = instant.toUtc().add(const Duration(hours: 8));
  const months = [
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
  final hour = manila.hour % 12 == 0 ? 12 : manila.hour % 12;
  final minute = manila.minute.toString().padLeft(2, '0');
  return '${months[manila.month - 1]} ${manila.day}, $hour:$minute ${manila.hour < 12 ? 'AM' : 'PM'} PHT';
}
