import 'package:flutter/foundation.dart';

/// One step of the server-computed milestone stepper. The Buyer never edits a milestone.
@immutable
class FulfillmentStepView {
  const FulfillmentStepView({
    required this.key,
    required this.label,
    required this.status,
    required this.proofRequired,
    this.at,
    this.actorRole,
    this.proof,
  });

  final String key;
  final String label;

  /// COMPLETE, CURRENT or UPCOMING.
  final String status;
  final bool proofRequired;
  final DateTime? at;
  final String? actorRole;
  final FulfillmentProofView? proof;
}

/// Delivery or pickup proof. File paths are order-scoped API paths fetched through the repository.
@immutable
class FulfillmentProofView {
  const FulfillmentProofView({
    required this.milestone,
    required this.handoverConfirmed,
    this.recordedAt,
    this.receiverName,
    this.receiverKind,
    this.photoPath,
    this.signaturePath,
  });

  /// DELIVERED or PICKED_UP.
  final String milestone;
  final bool handoverConfirmed;
  final DateTime? recordedAt;
  final String? receiverName;

  /// BUYER or AUTHORIZED_RECEIVER.
  final String? receiverKind;
  final String? photoPath;
  final String? signaturePath;
}

@immutable
class FulfillmentReceiptView {
  const FulfillmentReceiptView({
    required this.paused,
    required this.windowHours,
    this.dueAt,
    this.remainingSeconds,
    this.confirmedAt,
    this.confirmationSource,
  });

  final bool paused;
  final int windowHours;
  final DateTime? dueAt;
  final int? remainingSeconds;
  final DateTime? confirmedAt;

  /// BUYER or AUTO_CONFIRMATION.
  final String? confirmationSource;
}

@immutable
class FulfillmentIssueView {
  const FulfillmentIssueView({
    required this.id,
    required this.category,
    required this.description,
    required this.state,
    this.reportedAt,
    this.vendorResponse,
    this.resolution,
  });

  final String id;
  final String category;
  final String description;

  /// OPEN or RESOLVED.
  final String state;
  final DateTime? reportedAt;
  final String? vendorResponse;
  final String? resolution;
}

@immutable
class FulfillmentThreadView {
  const FulfillmentThreadView({
    required this.available,
    required this.readOnly,
    this.conversationId,
    this.notice,
  });

  final bool available;
  final bool readOnly;
  final String? conversationId;
  final String? notice;
}

@immutable
class FulfillmentView {
  const FulfillmentView({
    required this.method,
    required this.state,
    required this.late,
    required this.steps,
    required this.trackingNotice,
    required this.receipt,
    required this.thread,
    required this.nextAction,
    this.expectedDate,
    this.proof,
    this.issue,
    this.assigneeName,
  });

  /// DELIVERY or PICKUP.
  final String method;
  final String state;
  final bool late;
  final List<FulfillmentStepView> steps;
  final String trackingNotice;
  final FulfillmentReceiptView receipt;
  final FulfillmentThreadView thread;
  final String nextAction;
  final String? expectedDate;
  final FulfillmentProofView? proof;
  final FulfillmentIssueView? issue;

  /// Public display name of the assigned Fulfillment Staff; never a private contact.
  final String? assigneeName;
}

@immutable
class CancellationRemedyView {
  const CancellationRemedyView({
    required this.code,
    required this.available,
    required this.note,
  });

  final String code;
  final bool available;
  final String note;
}

/// Server-decided cancellation availability. The explanation is always shown, including when disabled.
@immutable
class CancellationView {
  const CancellationView({
    required this.mode,
    required this.available,
    required this.explanation,
    required this.requiresReason,
    required this.reasonCodes,
    required this.nrpcRetainableCentavos,
    required this.canWithdrawRequest,
    required this.remedies,
    this.responseDueAt,
    this.openRequestReason,
  });

  /// WITHDRAW, USE_REJECT, CANCEL_BEFORE_PAYMENT, CANCEL_NOW, REQUEST, REQUEST_OPEN, UNAVAILABLE or CLOSED.
  final String mode;
  final bool available;
  final String explanation;
  final bool requiresReason;
  final List<String> reasonCodes;
  final int nrpcRetainableCentavos;
  final bool canWithdrawRequest;
  final List<CancellationRemedyView> remedies;
  final DateTime? responseDueAt;
  final String? openRequestReason;
}

@immutable
class CancellationPlanView {
  const CancellationPlanView({
    required this.onlineRefundTotalCentavos,
    required this.cashReimbursementCentavos,
    required this.releasedUnpaidCentavos,
    required this.nrpcRetainedCentavos,
    required this.paidTotalCentavos,
    required this.payments,
  });

  final int onlineRefundTotalCentavos;
  final int cashReimbursementCentavos;
  final int releasedUnpaidCentavos;
  final int nrpcRetainedCentavos;
  final int paidTotalCentavos;
  final List<CancellationPlanPaymentView> payments;
}

@immutable
class CancellationPlanPaymentView {
  const CancellationPlanPaymentView({
    required this.purpose,
    required this.refundCentavos,
    required this.processingFeeCentavos,
    this.channelName,
  });

  final String purpose;
  final int refundCentavos;
  final int processingFeeCentavos;
  final String? channelName;
}

@immutable
class CancellationPreviewView {
  const CancellationPreviewView({
    required this.availability,
    required this.fullRefund,
    required this.nrpcRetainableCentavos,
    required this.notice,
    this.withNrpcRetained,
  });

  final CancellationView availability;
  final CancellationPlanView fullRefund;
  final CancellationPlanView? withNrpcRetained;
  final int nrpcRetainableCentavos;
  final String notice;
}

/// A provider refund. [displayState] separates initiation (QUEUED/INITIATED) from success (PROCESSED).
@immutable
class RefundItemView {
  const RefundItemView({
    required this.id,
    required this.trigger,
    required this.state,
    required this.displayState,
    required this.amountCentavos,
    required this.processingFeeCentavos,
    required this.originalMethod,
    required this.message,
    this.principalCentavos,
    this.requestedAt,
    this.completedAt,
    this.arrivalNote,
  });

  final String id;
  final String trigger;
  final String state;

  /// QUEUED, INITIATED, PROCESSED or FAILED.
  final String displayState;
  final int amountCentavos;
  final int processingFeeCentavos;
  final String originalMethod;
  final String message;
  final int? principalCentavos;
  final DateTime? requestedAt;
  final DateTime? completedAt;
  final String? arrivalNote;
}

/// A Vendor cash reimbursement; never a provider refund state.
@immutable
class ReimbursementItemView {
  const ReimbursementItemView({
    required this.id,
    required this.state,
    required this.amountCentavos,
    required this.method,
    required this.message,
    required this.confirmedByReview,
    this.hasEvidence = false,
    this.reimbursedAt,
    this.buyerAcknowledgedAt,
  });

  final String id;

  /// VENDOR_REIMBURSEMENT_PENDING or REIMBURSEMENT_CONFIRMED.
  final String state;
  final int amountCentavos;
  final String method;
  final String message;
  final bool confirmedByReview;

  /// The Vendor recorded the reimbursement with evidence, so the Buyer may confirm receipt.
  final bool hasEvidence;
  final DateTime? reimbursedAt;
  final DateTime? buyerAcknowledgedAt;
}

@immutable
class CancellationDecisionSummary {
  const CancellationDecisionSummary({
    required this.cause,
    required this.decidedBy,
    required this.nrpcRetainedCentavos,
    required this.refundTotalCentavos,
    required this.cashReimbursementCentavos,
    this.reason,
    this.decidedAt,
  });

  final String cause;
  final String decidedBy;
  final int nrpcRetainedCentavos;
  final int refundTotalCentavos;
  final int cashReimbursementCentavos;
  final String? reason;
  final DateTime? decidedAt;
}

@immutable
class RefundTimelineView {
  const RefundTimelineView({
    required this.refunds,
    required this.reimbursements,
    required this.noLongerDueCentavos,
    this.decision,
  });

  final List<RefundItemView> refunds;
  final List<ReimbursementItemView> reimbursements;
  final int noLongerDueCentavos;
  final CancellationDecisionSummary? decision;

  bool get isEmpty =>
      refunds.isEmpty &&
      reimbursements.isEmpty &&
      noLongerDueCentavos == 0 &&
      decision == null;
}

/// A Buyer-chosen problem photo, already read into memory by the picker.
@immutable
class ProblemPhoto {
  const ProblemPhoto({required this.bytes, required this.filename});

  final Uint8List bytes;
  final String filename;
}

const buyerCancellationReasonLabels = <String, String>{
  'CHANGE_OF_REQUIREMENT': 'Project requirement changed',
  'DUPLICATE_ORDER': 'Duplicate order',
  'BUDGET_CHANGE': 'Budget changed',
  'PROJECT_DELAY': 'Project delayed',
  'SCHEDULE_CONFLICT': 'Schedule conflict',
  'VENDOR_AGREEMENT': 'Agreed with the Vendor',
  'OTHER': 'Other',
};

const problemCategoryLabels = <String, String>{
  'NOT_RECEIVED': 'Not received',
  'INCOMPLETE': 'Incomplete quantity',
  'DAMAGED': 'Damaged item',
  'WRONG_ITEM': 'Wrong item',
  'LATE': 'Late delivery',
  'ACCESS_PROBLEM': 'Site access problem',
  'OTHER': 'Other',
};
