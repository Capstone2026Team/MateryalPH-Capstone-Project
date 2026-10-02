import 'package:flutter/foundation.dart';

/// Immutable Buyer payment view models. A payment reads `PAID` only after the provider verified it;
/// everything before that is `PENDING`, and returning from the payment page never changes that.

@immutable
class PaymentChannelView {
  const PaymentChannelView({
    required this.code,
    required this.displayName,
    required this.kind,
    required this.available,
    required this.rateLabel,
    this.unavailableReason,
    this.feeCentavos,
    this.totalCentavos,
  });

  final String code;
  final String displayName;
  final String kind;
  final bool available;
  final String rateLabel;
  final String? unavailableReason;
  final int? feeCentavos;
  final int? totalCentavos;

  String get unavailableText => switch (unavailableReason) {
    'REFUND_ROUTE_UNAVAILABLE' => 'Not offered: no approved refund route',
    'PROVIDER_NOT_CONFIGURED' => 'Temporarily unavailable',
    'BELOW_CHANNEL_MINIMUM' || 'ABOVE_CHANNEL_MAXIMUM' => 'Outside this channel’s limits',
    _ => 'Unavailable',
  };
}

@immutable
class PaymentAttemptView {
  const PaymentAttemptView({
    required this.id,
    required this.purpose,
    required this.status,
    required this.principalCentavos,
    required this.processingFeeCentavos,
    required this.totalCentavos,
    required this.evidenceOrigin,
    required this.canCheckStatus,
    required this.message,
    this.orderId,
    this.channelName,
    this.checkoutUrl,
    this.expiresAt,
    this.paidAt,
  });

  final String id;

  /// FULL_ORDER_PAYMENT, NRPC_ASSURANCE_PAYMENT or ORDER_BALANCE_PAYMENT.
  final String purpose;

  /// PENDING, PAID, FAILED, EXPIRED or CAPTURED_LATE_REFUND_PENDING.
  final String status;
  final int principalCentavos;
  final int processingFeeCentavos;
  final int totalCentavos;

  /// XENDIT_TEST or SIMULATED.
  final String evidenceOrigin;
  final bool canCheckStatus;
  final String message;
  final String? orderId;
  final String? channelName;
  final String? checkoutUrl;
  final DateTime? expiresAt;
  final DateTime? paidAt;

  bool get pending => status == 'PENDING';
  bool get paid => status == 'PAID';

  /// A failed or expired checkout. The order itself stays Pending Payment, so paying again is allowed.
  bool get retryable => status == 'FAILED' || status == 'EXPIRED';
}

@immutable
class PaymentOptionsView {
  const PaymentOptionsView({
    required this.orderId,
    required this.orderReference,
    required this.paymentDue,
    required this.channels,
    required this.providerReady,
    required this.notice,
    this.purpose,
    this.principalCentavos,
    this.payBy,
    this.latestAttempt,
  });

  final String orderId;
  final String orderReference;
  final bool paymentDue;
  final List<PaymentChannelView> channels;
  final bool providerReady;
  final String notice;
  final String? purpose;
  final int? principalCentavos;
  final DateTime? payBy;
  final PaymentAttemptView? latestAttempt;
}

@immutable
class PhysicalRecordView {
  const PhysicalRecordView({
    required this.id,
    required this.kind,
    required this.amountCentavos,
    required this.remainingCentavos,
    required this.recordedAt,
    required this.source,
    this.acknowledgedAt,
  });

  final String id;

  /// OBLIGATION_OPENED, COLLECTION, ONLINE_BALANCE_CREDIT, CORRECTION or CANCELLATION_RELEASE.
  final String kind;
  final int amountCentavos;
  final int remainingCentavos;
  final DateTime recordedAt;

  /// VENDOR_RECORD, VERIFIED_ONLINE_PAYMENT or SYSTEM.
  final String source;
  final DateTime? acknowledgedAt;
}

@immutable
class OrderPaymentView {
  const OrderPaymentView({
    required this.available,
    required this.physicalApplicable,
    required this.physicalRecords,
    required this.onlineBalanceApproved,
    this.purpose,
    this.principalCentavos,
    this.latestAttempt,
    this.verifiedPayment,
    this.physicalMethod,
    this.physicalRemainingCentavos,
    this.notice,
  });

  final bool available;
  final bool physicalApplicable;
  final List<PhysicalRecordView> physicalRecords;
  final bool onlineBalanceApproved;
  final String? purpose;
  final int? principalCentavos;
  final PaymentAttemptView? latestAttempt;
  final PaymentAttemptView? verifiedPayment;
  final String? physicalMethod;
  final int? physicalRemainingCentavos;
  final String? notice;
}

String paymentPurposeLabel(String? purpose) => switch (purpose) {
  'NRPC_ASSURANCE_PAYMENT' => 'NRPC assurance payment',
  'ORDER_BALANCE_PAYMENT' => 'Remaining balance',
  _ => 'Full order payment',
};
