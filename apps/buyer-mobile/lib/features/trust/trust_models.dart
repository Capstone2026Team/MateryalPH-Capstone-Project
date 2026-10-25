import 'package:flutter/foundation.dart';

/// One daily point of a comparable group. A null [average] is a gap (missing day or no local
/// observation) and is never drawn as zero or joined across.
@immutable
class AnalyticsPointView {
  const AnalyticsPointView({
    required this.date,
    required this.status,
    this.label,
    this.average,
    this.vendorCount,
    this.participantsChanged,
  });

  final String date;
  final String status;
  final String? label;
  final String? average;
  final int? vendorCount;
  final bool? participantsChanged;

  bool get hasValue => average != null;
}

@immutable
class AnalyticsTrendView {
  const AnalyticsTrendView({
    this.changePercent,
    this.direction,
    this.reason,
    this.label,
    this.compositionChanged,
    this.compositionNote,
    this.startDate,
    this.endDate,
  });

  final String? changePercent;
  final String? direction;
  final String? reason;
  final String? label;
  final bool? compositionChanged;
  final String? compositionNote;
  final String? startDate;
  final String? endDate;
}

@immutable
class ComparableGroupView {
  const ComparableGroupView({
    required this.groupId,
    required this.displayName,
    required this.materialName,
    required this.categoryName,
    required this.unitName,
    required this.specification,
    required this.startPoint,
    required this.endPoint,
    required this.trend,
    required this.currentVendors,
    required this.currentListings,
    this.categoryId = '',
    this.categoryCode = '',
    this.imageUrl,
  });

  final String groupId;
  final String displayName;
  final String materialName;
  final String categoryName;

  /// Opaque taxonomy id, sent back as the list's `category_id` filter.
  final String categoryId;
  final String categoryCode;

  /// One public listing photo so the variant is recognizable (MAT-05: for a Buyer, the cheapest current offer
  /// that has one), or null.
  final String? imageUrl;
  final String unitName;
  final List<String> specification;
  final AnalyticsPointView startPoint;
  final AnalyticsPointView endPoint;
  final AnalyticsTrendView trend;
  final int currentVendors;
  final int currentListings;
}

@immutable
class AnalyticsEnvelopeView {
  const AnalyticsEnvelopeView({
    required this.datasetLabel,
    required this.updateSchedule,
    required this.explanation,
    required this.currentAsOf,
    this.snapshotAt,
    this.latestDate,
    this.earliestDate,
    this.startDate,
    this.endDate,
  });

  final String datasetLabel;
  final String updateSchedule;
  final String explanation;
  final DateTime currentAsOf;
  final DateTime? snapshotAt;
  final String? latestDate;
  final String? earliestDate;
  final String? startDate;
  final String? endDate;
}

@immutable
class MaterialsAnalyticsPage {
  const MaterialsAnalyticsPage({
    required this.envelope,
    required this.items,
    this.nextCursor,
  });

  final AnalyticsEnvelopeView envelope;
  final List<ComparableGroupView> items;
  final String? nextCursor;
}

/// Current per-Vendor prices per canonical unit (each Vendor once per variant); all null without offers.
@immutable
class PriceRangeView {
  const PriceRangeView({this.min, this.median, this.max});

  final String? min;
  final String? median;
  final String? max;

  bool get isEmpty => min == null;
}

/// One canonical product (material) across its comparable variants in the Buyer's scope.
@immutable
class AnalyticsProductView {
  const AnalyticsProductView({
    required this.materialId,
    required this.name,
    required this.categoryId,
    required this.categoryName,
    required this.categoryCode,
    required this.regulated,
    required this.unitName,
    required this.variantCount,
    required this.vendorCount,
    required this.price,
  });

  final String materialId;
  final String name;
  final String categoryId;
  final String categoryName;
  final String categoryCode;
  final bool regulated;
  final String unitName;
  final int variantCount;
  final int vendorCount;
  final PriceRangeView price;
}

@immutable
class AnalyticsCategorySummaryView {
  const AnalyticsCategorySummaryView({
    required this.id,
    required this.name,
    required this.code,
    required this.productCount,
    required this.variantCount,
  });

  final String id;
  final String name;
  final String code;
  final int productCount;
  final int variantCount;
}

@immutable
class AnalyticsProductsPage {
  const AnalyticsProductsPage({
    required this.envelope,
    required this.categories,
    required this.items,
    required this.notYetComparable,
    this.nextCursor,
  });

  final AnalyticsEnvelopeView envelope;

  /// Every category in scope, independent of the category or search filter.
  final List<AnalyticsCategorySummaryView> categories;
  final List<AnalyticsProductView> items;

  /// Current listings in scope that no comparable variant covers yet.
  final int notYetComparable;
  final String? nextCursor;
}

/// One comparable variant of a product: its own range, sellers and best stock label.
@immutable
class AnalyticsProductVariantView {
  const AnalyticsProductVariantView({
    required this.groupId,
    required this.displayName,
    required this.materialName,
    required this.specification,
    required this.unitName,
    required this.vendorCount,
    required this.listingCount,
    required this.price,
    required this.availability,
    this.categoryCode = '',
    this.imageUrl,
  });

  final String groupId;
  final String displayName;
  final String materialName;
  final List<String> specification;
  final String unitName;
  final int vendorCount;
  final int listingCount;
  final PriceRangeView price;

  /// IN_STOCK, LIMITED_STOCK or NO_CURRENT_OFFERS.
  final String availability;
  final String categoryCode;
  final String? imageUrl;
}

/// Product analytics: the product row, the most-offered variant (its average and trend stand in
/// for the product without blending variants) and every variant.
@immutable
class AnalyticsProductDetailView {
  const AnalyticsProductDetailView({
    required this.envelope,
    required this.product,
    required this.variants,
    this.description,
    this.featured,
    this.series = const [],
  });

  final AnalyticsEnvelopeView envelope;
  final AnalyticsProductView product;
  final String? description;
  final ComparableGroupView? featured;
  final List<AnalyticsPointView> series;
  final List<AnalyticsProductVariantView> variants;
}

@immutable
class MaterialPriceDetailsView {
  const MaterialPriceDetailsView({
    required this.envelope,
    required this.group,
    required this.description,
    required this.variants,
    required this.series,
  });

  final AnalyticsEnvelopeView envelope;
  final ComparableGroupView group;
  final String? description;
  final List<({String groupId, String displayName})> variants;
  final List<AnalyticsPointView> series;
}

@immutable
class MaterialOfferView {
  const MaterialOfferView({
    required this.vendorId,
    required this.storeName,
    required this.listingId,
    required this.displayName,
    required this.variantLabel,
    required this.priceCentavos,
    required this.normalizedPhp,
    required this.taxLabel,
    required this.availability,
    required this.distanceMeters,
    this.imageUrl,
  });

  final String vendorId;
  final String storeName;
  final String listingId;
  final String displayName;
  final String? variantLabel;
  final int priceCentavos;
  final String normalizedPhp;
  final String taxLabel;
  final String availability;
  final int distanceMeters;

  /// The listing's first public photo, or null.
  final String? imageUrl;
}

/// The analytics window the Buyer chose: a 7/30/90-day preset or an explicit custom range.
@immutable
class AnalyticsWindowChoice {
  const AnalyticsWindowChoice.preset(this.presetDays)
    : startDate = null,
      endDate = null;
  const AnalyticsWindowChoice.custom(this.startDate, this.endDate)
    : presetDays = null;

  final int? presetDays;
  final String? startDate;
  final String? endDate;

  bool get isCustom => startDate != null;

  @override
  bool operator ==(Object other) =>
      other is AnalyticsWindowChoice &&
      other.presetDays == presetDays &&
      other.startDate == startDate &&
      other.endDate == endDate;

  @override
  int get hashCode => Object.hash(presetDays, startDate, endDate);
}

@immutable
class ReviewRatingsView {
  const ReviewRatingsView({
    this.serviceQuality,
    this.speedRating,
    this.speedKind,
    this.productQuality,
    this.inquirySeriousness,
    this.communicationQuality,
    this.paymentReliability,
  });

  final int? serviceQuality;
  final int? speedRating;
  final String? speedKind;
  final int? productQuality;
  final int? inquirySeriousness;
  final int? communicationQuality;
  final int? paymentReliability;
}

@immutable
class ReviewMediaView {
  const ReviewMediaView({
    required this.id,
    required this.url,
    required this.contentType,
    this.byteSize,
  });
  final String id;
  final String url;
  final String contentType;
  final int? byteSize;
  bool get video => contentType.startsWith('video/');
}

@immutable
class OwnReviewView {
  const OwnReviewView({
    required this.id,
    required this.ratings,
    required this.comment,
    required this.displayName,
    required this.canEdit,
    required this.correctionRequested,
    required this.visibility,
    required this.lockVersion,
    this.editableUntilLabel,
    this.media = const [],
  });

  final String id;
  final ReviewRatingsView ratings;
  final String? comment;
  final String displayName;
  final bool canEdit;
  final bool correctionRequested;
  final String visibility;
  final int lockVersion;
  final String? editableUntilLabel;
  final List<ReviewMediaView> media;
}

@immutable
class ReviewLineView {
  const ReviewLineView({
    required this.orderLineId,
    required this.listingId,
    required this.displayName,
    required this.variantLabel,
    required this.review,
    required this.canReview,
  });

  final String orderLineId;
  final String listingId;
  final String displayName;
  final String? variantLabel;
  final OwnReviewView? review;
  final bool canReview;
}

@immutable
class OrderReviewsView {
  const OrderReviewsView({
    required this.orderId,
    required this.orderReference,
    required this.state,
    required this.closesAtLabel,
    required this.revealed,
    required this.withheldForDispute,
    required this.blindRevealText,
    required this.speedLabel,
    required this.displayOptions,
    required this.vendorRating,
    required this.canSubmitVendorRating,
    required this.lines,
    this.counterpartRating,
    this.mediaMax = 3,
    this.photoMaxBytes = 10 * 1024 * 1024,
    this.videoMaxBytes = 25 * 1024 * 1024,
  });

  final String orderId;
  final String orderReference;
  final String state;
  final String? closesAtLabel;
  final bool revealed;
  final bool withheldForDispute;
  final String blindRevealText;
  final String speedLabel;
  final List<({String choice, String preview})> displayOptions;
  final OwnReviewView? vendorRating;
  final bool canSubmitVendorRating;
  final List<ReviewLineView> lines;
  final ReviewRatingsView? counterpartRating;
  final int mediaMax;
  final int photoMaxBytes;
  final int videoMaxBytes;

  bool get open => state == 'OPEN';
}

@immutable
class PublicReviewView {
  const PublicReviewView({
    required this.id,
    required this.ratings,
    required this.comment,
    required this.displayName,
    required this.edited,
    this.variantLabel,
    this.submittedAt,
    this.media = const [],
  });

  final String id;
  final ReviewRatingsView ratings;
  final String? comment;
  final String displayName;
  final bool edited;
  final String? variantLabel;
  final DateTime? submittedAt;
  final List<ReviewMediaView> media;
}

@immutable
class ListingReviewsView {
  const ListingReviewsView({
    required this.average,
    required this.count,
    required this.items,
    this.distribution = const {},
    this.page = 1,
    this.perPage = 20,
  });

  final String? average;
  final int count;
  final List<PublicReviewView> items;

  /// Counts across all visible Product Reviews, never inferred from one page.
  final Map<int, int> distribution;
  final int page;
  final int perPage;

  bool get hasMore => page < 500 && page * perPage < count;
}

/// One active, unsuppressed automatic badge with its public rule text.
@immutable
class StoreBadgeView {
  const StoreBadgeView({
    required this.code,
    required this.name,
    required this.description,
    this.scopeLabel,
  });

  final String code;
  final String name;
  final String description;
  final String? scopeLabel;
}

/// A store's public rating summary: averages of its visible verified Vendor ratings (Service Quality
/// and Delivery/Processing Speed) beside the published VCS, MQS and VPS. A score below its sample
/// gate is null, and the store then reads "New Vendor — Building Track Record".
@immutable
class StoreRatingView {
  const StoreRatingView({
    required this.ratingCount,
    required this.scoreLabel,
    required this.newVendor,
    this.serviceQuality,
    this.speed,
    this.vcs,
    this.mqs,
    this.vps,
    this.badges = const [],
  });

  final int ratingCount;
  final String? serviceQuality;
  final String? speed;
  final String scoreLabel;
  final bool newVendor;
  final String? vcs;
  final String? mqs;
  final String? vps;
  final List<StoreBadgeView> badges;
}
