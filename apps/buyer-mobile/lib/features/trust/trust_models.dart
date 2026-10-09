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
  });

  final String groupId;
  final String displayName;
  final String materialName;
  final String categoryName;
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
    this.videoMaxBytes = 100 * 1024 * 1024,
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
  });

  final String? average;
  final int count;
  final List<PublicReviewView> items;
}
