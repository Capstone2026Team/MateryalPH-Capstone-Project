import 'package:flutter/foundation.dart';

import 'fulfillment_models.dart';
import 'payment_models.dart';

export 'fulfillment_models.dart';
export 'payment_models.dart';

/// Immutable Buyer order view models. Order, payment, fulfillment, refund and dispute stay separate
/// fields; money is integer centavos; deadlines are UTC instants shown in Asia/Manila.

const _months = [
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

/// The exact Asia/Manila date and time of an instant, with the year: "Oct 5, 2026, 9:45 AM PHT".
/// Asia/Manila has no daylight saving, so the fixed UTC+8 offset is exact.
String formatManilaDateTime(DateTime instant) {
  final manila = instant.toUtc().add(const Duration(hours: 8));
  final hour = manila.hour % 12 == 0 ? 12 : manila.hour % 12;
  final minute = manila.minute.toString().padLeft(2, '0');
  return '${_months[manila.month - 1]} ${manila.day}, ${manila.year}, $hour:$minute ${manila.hour < 12 ? 'AM' : 'PM'} PHT';
}

/// The Asia/Manila calendar date of an instant: "Oct 5, 2026".
String formatManilaDate(DateTime instant) {
  final manila = instant.toUtc().add(const Duration(hours: 8));
  return '${_months[manila.month - 1]} ${manila.day}, ${manila.year}';
}

/// A Philippine calendar date sent as YYYY-MM-DD, shown as "Oct 7, 2026"; anything else as sent.
String formatCalendarDate(String date) {
  final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})').firstMatch(date);
  final month = match == null ? 0 : int.parse(match[2]!);
  if (month < 1 || month > 12) return date;
  return '${_months[month - 1]} ${int.parse(match![3]!)}, ${match[1]}';
}

@immutable
class OrderStateRowView {
  const OrderStateRowView(this.family, this.state);

  /// ORDER, PAYMENT, FULFILLMENT, REFUND or DISPUTE.
  final String family;
  final String state;
}

String orderFamilyLabel(String family) => switch (family) {
  'ORDER' => 'Order',
  'PAYMENT' => 'Payment',
  'FULFILLMENT' => 'Fulfillment',
  'REFUND' => 'Refund',
  'DISPUTE' => 'Dispute',
  _ => family,
};

String orderStateLabel(String state) => switch (state) {
  'AWAITING_VENDOR_CONFIRMATION' => 'Waiting for the Vendor',
  'AWAITING_BUYER_APPROVAL' => 'Needs your approval',
  'AWAITING_NRPC_ACCEPTANCE' => 'Review preparation cost',
  'AWAITING_PAYMENT' => 'Pending payment',
  'CONFIRMED' => 'Confirmed',
  'PROCESSING' => 'Preparing',
  'READY_FOR_PICKUP' => 'Ready for pickup',
  'OUT_FOR_DELIVERY' => 'Out for delivery',
  'DELIVERED' => 'Delivered',
  'PICKED_UP' => 'Picked up',
  'COMPLETED' => 'Completed',
  'CANCELLATION_REQUESTED' => 'Cancellation requested',
  'DECLINED' => 'Declined by the Vendor',
  'EXPIRED' => 'Expired',
  'CANCELLED' => 'Cancelled',
  'DISPUTED' => 'Disputed',
  'NOT_REQUIRED' => 'No payment due',
  'PENDING' => 'Payment due',
  'PAID' => 'Paid (verified)',
  'FAILED' => 'Payment failed',
  'NOT_STARTED' => 'Not started',
  'NOT_REQUESTED' => 'None',
  'REFUND_PENDING' => 'Refund pending',
  'PARTIALLY_REFUNDED' => 'Partially refunded',
  'REFUNDED' => 'Refunded',
  'REFUND_FAILED' => 'Refund failed',
  'NONE' => 'None',
  _ =>
    state
        .toLowerCase()
        .replaceAll('_', ' ')
        .replaceFirstMapped(RegExp('^.'), (match) => match[0]!.toUpperCase()),
};

enum StateTone { success, warning, danger, neutral, info }

StateTone orderStateTone(String state) {
  if (const [
    'COMPLETED',
    'PAID',
    'CONFIRMED',
    'DELIVERED',
    'PICKED_UP',
    'REFUNDED',
    'RESOLVED',
  ].contains(state)) {
    return StateTone.success;
  }
  if (const [
    'DECLINED',
    'EXPIRED',
    'CANCELLED',
    'FAILED',
    'REFUND_FAILED',
    'DISPUTED',
  ].contains(state)) {
    return StateTone.danger;
  }
  if (state.startsWith('AWAITING') ||
      const ['PENDING', 'REFUND_PENDING'].contains(state)) {
    return StateTone.warning;
  }
  if (const [
    'NONE',
    'NOT_STARTED',
    'NOT_REQUESTED',
    'NOT_REQUIRED',
  ].contains(state)) {
    return StateTone.neutral;
  }
  return StateTone.info;
}

@immutable
class OrderDeadlineView {
  const OrderDeadlineView({required this.kind, required this.at});

  /// VENDOR_RESPONSE, BUYER_RESPONSE or PAYMENT.
  final String kind;
  final DateTime at;
}

@immutable
class OrderSummaryView {
  const OrderSummaryView({
    required this.id,
    required this.reference,
    required this.vendorName,
    required this.submittedAt,
    required this.states,
    required this.fulfillmentMethod,
    required this.lineCount,
    required this.firstLineName,
    required this.firstLineImageUrl,
    required this.commercialTotalCentavos,
    required this.deliveryPending,
    required this.deadline,
    required this.nextAction,
    required this.autoAccepted,
    this.paymentRetryable = false,
    this.procurementType = 'ITEM_BASED',
    this.paymentMethod = 'ONLINE',
    this.paymentChannelName,
    this.expectedFulfillmentDate,
    this.fulfillmentConversation,
    this.cardActions = const {},
    this.returnRefundDueAt,
    this.disputeCaseId,
    this.closureReason,
  });

  final String id;
  final String reference;
  final String vendorName;
  final DateTime? submittedAt;
  final List<OrderStateRowView> states;
  final String fulfillmentMethod;
  final int lineCount;
  final String firstLineName;
  final String? firstLineImageUrl;
  final int commercialTotalCentavos;
  final bool deliveryPending;
  final OrderDeadlineView? deadline;

  /// REVIEW_REVISION, REVIEW_NRPC, PAY, CONFIRM_RECEIPT or null.
  final String? nextAction;
  final bool paymentRetryable;
  final bool autoAccepted;

  /// ITEM_BASED or PROJECT_BASED.
  final String procurementType;

  /// ONLINE, CASH_ON_DELIVERY or IN_STORE.
  final String paymentMethod;

  /// Channel of the latest verified online payment, for example GCash.
  final String? paymentChannelName;

  /// Philippine calendar date (YYYY-MM-DD) the Vendor expects to be ready or to deliver.
  final String? expectedFulfillmentDate;

  /// The order's Fulfillment Messages thread; null only for orders submitted before threads
  /// opened at submission.
  final OrderConversationRefView? fulfillmentConversation;

  /// Server-allowed card shortcuts: CONFIRM_RECEIPT, REPORT_PROBLEM, FILE_DISPUTE, VIEW_DISPUTE,
  /// BUY_AGAIN, VIEW_CANCELLATION.
  final Set<String> cardActions;

  /// End of the post-completion return and dispute window while FILE_DISPUTE is offered.
  final DateTime? returnRefundDueAt;
  final String? disputeCaseId;

  /// Why a cancelled, declined or expired order ended, in Buyer-facing words.
  final String? closureReason;

  String state(String family) =>
      states.firstWhere((row) => row.family == family).state;
}

@immutable
class OrderConversationRefView {
  const OrderConversationRefView({
    required this.id,
    required this.readOnly,
    this.unreadCount = 0,
  });

  final String id;
  final bool readOnly;
  final int unreadCount;
}

@immutable
class BuyAgainSkippedView {
  const BuyAgainSkippedView({required this.displayName, required this.message});

  final String displayName;
  final String message;
}

@immutable
class BuyAgainResultView {
  const BuyAgainResultView({required this.added, required this.skipped});

  /// Display names of the lines added to the cart at today's prices.
  final List<String> added;
  final List<BuyAgainSkippedView> skipped;
}

@immutable
class OrderListPage {
  const OrderListPage({
    required this.items,
    required this.counts,
    required this.page,
    required this.hasMore,
    required this.total,
  });

  final List<OrderSummaryView> items;
  final Map<String, int> counts;
  final int page;
  final bool hasMore;
  final int total;
}

@immutable
class OrderLineView {
  const OrderLineView({
    required this.id,
    required this.displayName,
    required this.variantLabel,
    required this.imageUrl,
    required this.unitName,
    required this.requestedQuantity,
    required this.confirmedQuantity,
    required this.unitPriceCentavos,
    required this.lineTotalCentavos,
    required this.discountCentavos,
    required this.vatLabel,
    required this.change,
    required this.volumeTierApplied,
  });

  final String id;
  final String displayName;
  final String? variantLabel;
  final String? imageUrl;
  final String unitName;
  final String requestedQuantity;
  final String? confirmedQuantity;
  final int unitPriceCentavos;
  final int lineTotalCentavos;
  final int discountCentavos;
  final String vatLabel;

  /// QUANTITY_REDUCED, LINE_REMOVED or null.
  final String? change;
  final bool volumeTierApplied;
}

@immutable
class OrderPointView {
  const OrderPointView({this.label, this.formattedAddress});

  final String? label;
  final String? formattedAddress;
}

@immutable
class OrderDestinationView {
  const OrderDestinationView({
    required this.type,
    this.storeAddress,
    this.intended,
    this.alternateDropOff,
    this.heavyVehicleRestriction,
    this.vehicleEndpoint,
    this.accessInstructions,
  });

  /// DELIVERY or PICKUP.
  final String type;
  final String? storeAddress;
  final OrderPointView? intended;
  final OrderPointView? alternateDropOff;
  final String? heavyVehicleRestriction;

  /// INTENDED_LOCATION or ALTERNATE_DROP_OFF.
  final String? vehicleEndpoint;
  final String? accessInstructions;
}

@immutable
class ConfirmedVehicleView {
  const ConfirmedVehicleView({
    required this.name,
    required this.vehicles,
    required this.trips,
    required this.perTripCentavos,
    this.brand,
  });

  final String name;
  final String? brand;
  final int vehicles;
  final int trips;
  final int perTripCentavos;
}

@immutable
class ConfirmedDeliveryView {
  const ConfirmedDeliveryView({
    required this.vehicles,
    required this.distanceMeters,
    required this.endpoint,
    required this.finalFeeCentavos,
    this.fulfillmentDate,
    this.arrangement,
    this.changeReason,
    this.intended,
    this.alternateDropOff,
  });

  final List<ConfirmedVehicleView> vehicles;
  final int distanceMeters;
  final String? endpoint;
  final int finalFeeCentavos;
  final String? fulfillmentDate;
  final String? arrangement;
  final String? changeReason;
  final OrderPointView? intended;
  final OrderPointView? alternateDropOff;
}

@immutable
class VendorDiscountView {
  const VendorDiscountView({
    required this.scope,
    required this.percent,
    required this.basisCentavos,
    required this.deductionCentavos,
  });
  final String scope;
  final String percent;
  final int basisCentavos;
  final int deductionCentavos;
}

@immutable
class MoneyView {
  const MoneyView({
    required this.status,
    this.discount,
    required this.materialsGrossCentavos,
    required this.vendorDiscountCentavos,
    required this.materialsSubtotalCentavos,
    required this.includedVatCentavos,
    required this.pricesIncludeVat,
    required this.deliveryStatus,
    required this.deliveryCentavos,
    required this.deliveryEstimateMin,
    required this.deliveryEstimateMax,
    required this.nrpcCentavos,
    required this.processingFeeStatus,
    required this.processingFeeCentavos,
    required this.commercialTotalCentavos,
    required this.amountDueOnlineCentavos,
    required this.physicalBalanceCentavos,
    required this.paymentPurpose,
  });

  /// ADVISORY_UNTIL_VENDOR_CONFIRMATION, AWAITING_BUYER_ACCEPTANCE or ACCEPTED.
  final String status;
  final VendorDiscountView? discount;
  final int materialsGrossCentavos;
  final int vendorDiscountCentavos;
  final int materialsSubtotalCentavos;
  final int includedVatCentavos;
  final bool pricesIncludeVat;

  /// NOT_APPLICABLE, PENDING_VENDOR_CONFIRMATION or CONFIRMED.
  final String deliveryStatus;
  final int? deliveryCentavos;
  final int? deliveryEstimateMin;
  final int? deliveryEstimateMax;
  final int nrpcCentavos;

  /// PENDING_PAYMENT_CHANNEL, QUOTED or NOT_APPLICABLE.
  final String processingFeeStatus;
  final int? processingFeeCentavos;
  final int? commercialTotalCentavos;
  final int? amountDueOnlineCentavos;
  final int? physicalBalanceCentavos;
  final String? paymentPurpose;
}

@immutable
class NrpcLineView {
  const NrpcLineView({
    required this.label,
    required this.principalCentavos,
    required this.linePayableCentavos,
  });

  final String label;
  final int principalCentavos;
  final int linePayableCentavos;
}

@immutable
class NrpcTermsView {
  const NrpcTermsView({
    required this.id,
    required this.version,
    required this.title,
    required this.content,
  });

  final String id;
  final int version;
  final String title;

  /// Plain text; null when the approved text is unavailable, which blocks acceptance.
  final String? content;
}

@immutable
class NrpcView {
  const NrpcView({
    required this.id,
    required this.amountCentavos,
    required this.reason,
    required this.affectedLines,
    required this.terms,
    required this.cancellationEffect,
    required this.status,
    required this.flagged,
    this.acceptedAt,
  });

  final String id;
  final int amountCentavos;
  final String reason;
  final List<NrpcLineView> affectedLines;
  final NrpcTermsView? terms;
  final String cancellationEffect;

  /// PROPOSED, ACCEPTED or REJECTED.
  final String status;
  final bool flagged;
  final DateTime? acceptedAt;
}

@immutable
class OrderEventView {
  const OrderEventView({
    required this.family,
    required this.toState,
    required this.source,
    required this.at,
  });

  final String family;
  final String toState;
  final String source;
  final DateTime? at;
}

@immutable
class OrderChangeView {
  const OrderChangeView({
    required this.type,
    required this.label,
    required this.from,
    required this.to,
  });

  final String type;
  final String label;
  final String from;
  final String to;
}

@immutable
class OrderDetailView {
  const OrderDetailView({
    required this.id,
    required this.reference,
    required this.vendorName,
    required this.fulfillmentMethod,
    required this.submittedAt,
    required this.states,
    required this.snapshotVersion,
    required this.lines,
    required this.changes,
    required this.money,
    required this.timeline,
    required this.actions,
    required this.autoAccepted,
    this.destination,
    this.confirmedDelivery,
    this.deliveryRecommendation = const [],
    this.nrpc,
    this.vendorResponseDueAt,
    this.buyerResponseDueAt,
    this.paymentExpiresAt,
    this.expectedFulfillmentDate,
    this.terminalReasonCode,
    this.paymentNotice,
    this.projectContext,
    this.payment,
    this.lockVersion = 1,
    this.fulfillment,
    this.cancellation,
    this.refundTimeline,
    this.dispute,
    this.invoice,
  });

  final String id;
  final String reference;
  final String vendorName;
  final String fulfillmentMethod;
  final DateTime? submittedAt;
  final List<OrderStateRowView> states;
  final int snapshotVersion;
  final List<OrderLineView> lines;
  final List<OrderChangeView> changes;
  final MoneyView money;
  final List<OrderEventView> timeline;

  /// Server-calculated: APPROVE_REVISION, REJECT_REVISION, ACCEPT_NRPC, REJECT_NRPC, FLAG_NRPC.
  final Set<String> actions;
  final bool autoAccepted;
  final OrderDestinationView? destination;
  final ConfirmedDeliveryView? confirmedDelivery;
  final List<String> deliveryRecommendation;
  final NrpcView? nrpc;
  final DateTime? vendorResponseDueAt;
  final DateTime? buyerResponseDueAt;
  final DateTime? paymentExpiresAt;
  final String? expectedFulfillmentDate;
  final String? terminalReasonCode;
  final String? paymentNotice;
  final Map<String, Object?>? projectContext;

  /// Payment state for this order. Null only for responses that carry no payment block.
  final OrderPaymentView? payment;

  /// Optimistic-concurrency version sent with a cancellation.
  final int lockVersion;
  final FulfillmentView? fulfillment;
  final CancellationView? cancellation;
  final RefundTimelineView? refundTimeline;

  /// The order's active or latest case, with whether a new one may be filed now.
  final OrderDisputeRefView? dispute;

  /// Vendor invoice copy status; MateryalPH documents are never the Vendor's tax invoice.
  final OrderInvoiceRefView? invoice;

  String state(String family) =>
      states.firstWhere((row) => row.family == family).state;
}

@immutable
class CheckoutChildView {
  const CheckoutChildView({
    required this.id,
    required this.reference,
    required this.vendorName,
    required this.orderState,
    required this.fulfillmentMethod,
    required this.autoAccepted,
    required this.commercialTotalCentavos,
    required this.deliveryPending,
    this.vendorResponseDueAt,
    this.paymentExpiresAt,
  });

  final String id;
  final String reference;
  final String vendorName;
  final String orderState;
  final String fulfillmentMethod;
  final bool autoAccepted;
  final int commercialTotalCentavos;
  final bool deliveryPending;
  final DateTime? vendorResponseDueAt;
  final DateTime? paymentExpiresAt;
}

@immutable
class CheckoutView {
  const CheckoutView({
    required this.id,
    required this.reference,
    required this.submittedAt,
    required this.orders,
    required this.notice,
  });

  final String id;
  final String reference;
  final DateTime submittedAt;
  final List<CheckoutChildView> orders;
  final String notice;
}

class OrderDisputeRefView {
  const OrderDisputeRefView({
    required this.caseId,
    required this.reference,
    required this.status,
    required this.filedByParty,
    this.filingAvailable = false,
    this.filingNote,
  });

  final String caseId;
  final String reference;
  final String status;
  final String filedByParty;
  final bool filingAvailable;
  final String? filingNote;
}

class OrderInvoiceRefView {
  const OrderInvoiceRefView({
    required this.status,
    required this.records,
    required this.openRequests,
  });

  /// ISSUED, NOT_YET_UPLOADED or NOT_DUE.
  final String status;
  final int records;
  final int openRequests;
}
