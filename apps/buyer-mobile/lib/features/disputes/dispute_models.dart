import 'dart:typed_data';

import '../orders/fulfillment_models.dart' show RefundTimelineView;

/// Buyer dispute and invoice view models. Every state, deadline, amount and action comes from the
/// server; the client never computes a refund, a timer or who may act.

const disputeStatusLabels = <String, String>{
  'OPEN_AWAITING_RESPONSE': 'Awaiting response',
  'MUTUAL_RESOLUTION': 'Mutual resolution',
  'ESCALATED_ADMIN_REVIEW': 'MateryalPH review',
  'AWAITING_CLARIFICATION': 'Clarification requested',
  'DECIDED': 'Decided',
  'APPEAL_OPEN': 'Appeal under review',
  'RESOLVED': 'Resolved',
  'CLOSED_INCONCLUSIVE': 'Closed — inconclusive',
};

const disputeIssueLabels = <String, String>{
  'WRONG_ITEM': 'Wrong item',
  'DEFECTIVE': 'Defective or damaged',
  'INCOMPLETE_DELIVERY': 'Incomplete delivery',
  'LATE_OR_MISSING': 'Late or missing',
  'MISLEADING_LISTING': 'Misleading listing',
  'PAYMENT': 'Payment problem',
  'INVOICE': 'Invoice problem',
  'OTHER_TRANSACTION': 'Other transaction issue',
  'PHYSICAL_PAYMENT_NOT_RECEIVED': 'Physical payment not received',
  'PICKUP_NO_SHOW': 'Pickup no-show',
  'ABUSIVE_COMMUNICATION': 'Abusive communication',
  'FALSE_EVIDENCE': 'False evidence',
  'INACCESSIBLE_DELIVERY_SITE': 'Inaccessible delivery site',
};

const disputeRemedyLabels = <String, String>{
  'REPLACEMENT': 'Replacement',
  'FULL_REFUND': 'Full refund',
  'PARTIAL_REFUND': 'Partial refund',
  'RETURN_AND_REFUND': 'Return and refund',
  'INVOICE_CORRECTION': 'Invoice correction',
  'PAYMENT_OF_BALANCE': 'Payment of balance',
  'WARNING_ONLY': 'Warning only',
  'OTHER': 'Other',
  'DISMISSED': 'Dismissed',
  'INCONCLUSIVE': 'Inconclusive',
  'NO_FURTHER_ACTION': 'No further action',
};

const disputeDeadlineLabels = <String, String>{
  'RESPONSE': 'Response due in',
  'MUTUAL_RESOLUTION': 'Mutual resolution ends in',
  'CLARIFICATION': 'Clarification due in',
  'APPEAL': 'Appeal window ends in',
};

String disputeStatusLabel(String status) =>
    disputeStatusLabels[status] ?? status.replaceAll('_', ' ').toLowerCase();
String disputeIssueLabel(String code) =>
    disputeIssueLabels[code] ?? code.replaceAll('_', ' ').toLowerCase();
String disputeRemedyLabel(String code) =>
    disputeRemedyLabels[code] ?? code.replaceAll('_', ' ').toLowerCase();

const _concluded = {'RESOLVED', 'CLOSED_INCONCLUSIVE'};

class DisputeDeadlineView {
  const DisputeDeadlineView({
    required this.kind,
    required this.at,
    required this.responsibleParty,
    required this.label,
  });

  final String kind;
  final DateTime at;
  final String responsibleParty;

  /// The exact Asia/Manila date and time, formatted by the server.
  final String label;
}

class DisputeSummaryView {
  const DisputeSummaryView({
    required this.id,
    required this.reference,
    required this.orderId,
    required this.orderReference,
    required this.status,
    required this.issueType,
    required this.requestedRemedy,
    required this.responsibleParty,
    required this.refundState,
    required this.remedyState,
    required this.vendorName,
    this.requestedAmountCentavos,
    this.nextDeadline,
    this.filedAt,
  });

  final String id;
  final String reference;
  final String orderId;
  final String orderReference;
  final String status;
  final String issueType;
  final String requestedRemedy;
  final int? requestedAmountCentavos;
  final String responsibleParty;
  final String refundState;
  final String remedyState;
  final String vendorName;
  final DisputeDeadlineView? nextDeadline;
  final DateTime? filedAt;

  bool get concluded => _concluded.contains(status);
}

class DisputeListPage {
  const DisputeListPage({
    required this.items,
    required this.page,
    required this.hasMore,
  });

  final List<DisputeSummaryView> items;
  final int page;
  final bool hasMore;
}

class DisputeEvidenceView {
  const DisputeEvidenceView({
    required this.fileId,
    required this.label,
    required this.name,
    required this.contentType,
    required this.byteSize,
    required this.url,
    required this.expiresAt,
    this.description,
  });

  final String fileId;
  final String label;
  final String name;
  final String contentType;
  final int byteSize;

  /// Authenticated, signed and short-lived. Reload the case for a fresh link once it expires.
  final String url;
  final DateTime expiresAt;
  final String? description;

  bool get isImage => contentType.startsWith('image/');
}

class DisputeTimelineEntryView {
  const DisputeTimelineEntryView({
    required this.id,
    required this.sequence,
    required this.type,
    required this.actorParty,
    required this.actorName,
    required this.evidence,
    this.actorRole,
    this.at,
    this.body,
  });

  final String id;
  final int sequence;
  final String type;
  final String actorParty;
  final String? actorRole;
  final String actorName;
  final DateTime? at;
  final String? body;
  final List<DisputeEvidenceView> evidence;
}

class DisputeProposalView {
  const DisputeProposalView({
    required this.id,
    required this.proposedByParty,
    required this.remedy,
    required this.terms,
    required this.state,
    required this.canAnswer,
    this.amountCentavos,
  });

  final String id;
  final String proposedByParty;
  final String remedy;
  final int? amountCentavos;
  final String terms;
  final String state;
  final bool canAnswer;
}

class DisputeClarificationView {
  const DisputeClarificationView({
    required this.id,
    required this.requestedParty,
    required this.question,
    required this.state,
    required this.canAnswer,
    this.dueAt,
    this.response,
  });

  final String id;
  final String requestedParty;
  final String question;
  final DateTime? dueAt;
  final String state;
  final String? response;
  final bool canAnswer;
}

class DisputeDecisionView {
  const DisputeDecisionView({
    required this.id,
    required this.version,
    required this.kind,
    required this.outcome,
    required this.awardedCentavos,
    required this.enforceable,
    required this.current,
    this.appealResult,
    this.reason,
    this.evidenceLimitation,
    this.decidedAt,
    this.appealDueAt,
  });

  final String id;
  final int version;
  final String kind;
  final String outcome;
  final String? appealResult;
  final int awardedCentavos;
  final String? reason;
  final String? evidenceLimitation;
  final bool enforceable;
  final DateTime? decidedAt;
  final DateTime? appealDueAt;
  final bool current;
}

class DisputeAppealView {
  const DisputeAppealView({
    required this.appellantParty,
    required this.grounds,
    required this.state,
  });

  final String appellantParty;
  final String grounds;
  final String state;
}

class DisputeRemedyView {
  const DisputeRemedyView({
    required this.id,
    required this.kind,
    required this.state,
    required this.amountCentavos,
    required this.canConfirm,
    this.note,
  });

  final String id;
  final String kind;
  final String state;
  final int amountCentavos;
  final String? note;
  final bool canConfirm;
}

class DisputeLineView {
  const DisputeLineView({
    required this.orderLineId,
    required this.displayName,
    required this.quantity,
    required this.lineTotalCentavos,
    required this.refundableCentavos,
    this.variantLabel,
  });

  final String orderLineId;
  final String displayName;
  final String? variantLabel;
  final String quantity;
  final int lineTotalCentavos;
  final int refundableCentavos;
}

class DisputeDetailView {
  const DisputeDetailView({
    required this.id,
    required this.reference,
    required this.orderId,
    required this.orderReference,
    required this.status,
    required this.caseKind,
    required this.issueType,
    required this.requestedRemedy,
    required this.filedByParty,
    required this.responsibleParty,
    required this.vendorName,
    required this.affectedLines,
    required this.deadlines,
    required this.timeline,
    required this.proposals,
    required this.clarifications,
    required this.decisions,
    required this.remedies,
    required this.refundTimeline,
    required this.actions,
    required this.lockVersion,
    this.requestedAmountCentavos,
    this.description,
    this.originalMethodLabel,
    this.originalMethodNotice,
    this.appeal,
    this.filedAt,
  });

  final String id;
  final String reference;
  final String orderId;
  final String orderReference;
  final String status;
  final String caseKind;
  final String issueType;
  final String requestedRemedy;
  final int? requestedAmountCentavos;
  final String filedByParty;
  final String responsibleParty;
  final String vendorName;
  final String? description;
  final List<DisputeLineView> affectedLines;

  /// Read-only, masked. Never a refund destination.
  final String? originalMethodLabel;
  final String? originalMethodNotice;
  final List<DisputeDeadlineView> deadlines;
  final List<DisputeTimelineEntryView> timeline;
  final List<DisputeProposalView> proposals;
  final List<DisputeClarificationView> clarifications;
  final List<DisputeDecisionView> decisions;
  final DisputeAppealView? appeal;
  final List<DisputeRemedyView> remedies;
  final RefundTimelineView refundTimeline;

  /// Server-calculated: RESPOND, PROPOSE, ANSWER_PROPOSAL, ESCALATE, ADD_EVIDENCE, MESSAGE,
  /// ANSWER_CLARIFICATION, APPEAL, CONFIRM_REPLACEMENT.
  final Set<String> actions;
  final int lockVersion;
  final DateTime? filedAt;

  bool get concluded => _concluded.contains(status);
}

class DisputeEligibilityView {
  const DisputeEligibilityView({
    required this.available,
    required this.reason,
    required this.caseKind,
    required this.issueTypes,
    required this.requestedRemedies,
    required this.lines,
    required this.methodLabel,
    required this.methodPhysical,
    required this.refundDestinationNotice,
    this.activeCaseId,
    this.postCompletionDeadline,
  });

  final bool available;
  final String reason;
  final String? activeCaseId;
  final String caseKind;
  final DateTime? postCompletionDeadline;
  final List<String> issueTypes;
  final List<String> requestedRemedies;
  final List<DisputeLineView> lines;
  final String methodLabel;
  final bool methodPhysical;
  final String refundDestinationNotice;
}

/// A Buyer-chosen evidence file, already read into memory by the picker.
class EvidenceFile {
  const EvidenceFile({required this.bytes, required this.filename});

  final Uint8List bytes;
  final String filename;
}

// ── Invoices ────────────────────────────────────────────────────────────────────────────────────

class InvoiceRecordItem {
  const InvoiceRecordItem({
    required this.id,
    required this.invoiceType,
    required this.issuer,
    required this.invoiceNumber,
    required this.issuedOn,
    required this.amountCentavos,
    required this.originLabel,
    required this.complianceNote,
    required this.reconciliationState,
    required this.reconciliationDifferenceCentavos,
    required this.buyerTotalUnchanged,
    this.reconciliationNote,
    this.downloadUrl,
  });

  final String id;
  final String invoiceType;
  final String issuer;
  final String invoiceNumber;
  final String issuedOn;
  final int amountCentavos;
  final String originLabel;
  final String complianceNote;
  final String reconciliationState;
  final int reconciliationDifferenceCentavos;
  final String? reconciliationNote;
  final String? downloadUrl;
  final bool buyerTotalUnchanged;

  bool get differs => reconciliationState == 'INVOICE_RECONCILIATION_REQUIRED';
}

class InvoiceRequestItem {
  const InvoiceRequestItem({
    required this.id,
    required this.kind,
    required this.state,
    required this.serviceTargetAt,
    required this.serviceTargetLabel,
    required this.overdue,
    required this.canReturn,
    required this.canClose,
    this.details,
  });

  final String id;
  final String kind;
  final String state;
  final String? details;
  final DateTime serviceTargetAt;
  final String serviceTargetLabel;
  final bool overdue;
  final bool canReturn;
  final bool canClose;

  bool get open => state != 'CLOSED';
}

class PlatformDocumentItem {
  const PlatformDocumentItem({
    required this.kind,
    required this.title,
    required this.notTaxInvoice,
    required this.label,
    required this.availability,
  });

  final String kind;
  final String title;
  final bool notTaxInvoice;
  final String label;
  final String availability;
}

class BuyerInvoicesView {
  const BuyerInvoicesView({
    required this.orderId,
    required this.orderReference,
    required this.status,
    required this.issuanceNotice,
    required this.records,
    required this.requests,
    required this.platformDocuments,
    required this.canEditBillingDetails,
    required this.canRequestCopy,
    required this.canRequestCorrection,
    this.billingName,
    this.billingAddress,
    this.tinMasked,
    this.billingLockVersion,
  });

  final String orderId;
  final String orderReference;
  final String status;
  final String issuanceNotice;
  final List<InvoiceRecordItem> records;
  final List<InvoiceRequestItem> requests;
  final List<PlatformDocumentItem> platformDocuments;
  final String? billingName;
  final String? billingAddress;
  final String? tinMasked;
  final int? billingLockVersion;
  final bool canEditBillingDetails;
  final bool canRequestCopy;
  final bool canRequestCorrection;
}

/// Splits a signed file URL into the path ids and the `expires`/`signature` query values the
/// generated client needs. Returns null for anything that is not a signed link.
({List<String> segments, int expires, String signature})? parseSignedUrl(
  String url,
) {
  final uri = Uri.tryParse(url);
  final expires = int.tryParse(uri?.queryParameters['expires'] ?? '');
  final signature = uri?.queryParameters['signature'];
  if (uri == null || expires == null || signature == null) return null;
  return (segments: uri.pathSegments, expires: expires, signature: signature);
}
