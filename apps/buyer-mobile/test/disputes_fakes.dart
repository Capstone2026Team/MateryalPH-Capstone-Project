import 'dart:typed_data';

import 'package:materyalph/features/disputes/dispute_models.dart';
import 'package:materyalph/features/disputes/disputes_repository.dart';
import 'package:materyalph/features/map_discovery/discovery_models.dart';
import 'package:materyalph/features/orders/fulfillment_models.dart';

/// Synthetic case and invoice fixtures for widget tests. Not live marketplace or payment data.
const disputeLine = DisputeLineView(
  orderLineId: 'line-1',
  displayName: 'Concrete Hollow Block 4"',
  quantity: '10',
  lineTotalCentavos: 18000,
  refundableCentavos: 18000,
);

DisputeEligibilityView eligibility({
  bool available = true,
}) => DisputeEligibilityView(
  available: available,
  reason: available
      ? 'You can file a dispute for this order.'
      : 'This order already has an active case.',
  caseKind: 'TRANSACTION',
  issueTypes: const ['WRONG_ITEM', 'DEFECTIVE', 'INCOMPLETE_DELIVERY'],
  requestedRemedies: const ['REPLACEMENT', 'FULL_REFUND', 'PARTIAL_REFUND'],
  lines: const [disputeLine],
  methodLabel: 'GCash •••• 1234',
  methodPhysical: false,
  refundDestinationNotice:
      'Any refund returns only to this original payment method. You cannot choose another destination.',
);

DisputeDetailView disputeDetail({
  String status = 'OPEN_AWAITING_RESPONSE',
  Set<String> actions = const {'ADD_EVIDENCE', 'MESSAGE'},
  List<DisputeDeadlineView>? deadlines,
  List<DisputeProposalView> proposals = const [],
  List<DisputeClarificationView> clarifications = const [],
  List<DisputeDecisionView> decisions = const [],
  List<DisputeRemedyView> remedies = const [],
  RefundTimelineView refunds = const RefundTimelineView(
    refunds: [],
    reimbursements: [],
    noLongerDueCentavos: 0,
  ),
  List<DisputeEvidenceView> evidence = const [],
}) => DisputeDetailView(
  id: 'case-1',
  reference: 'CASE-261004-ABC123',
  orderId: 'order-1',
  orderReference: 'ORD-2026-ABCD1234',
  status: status,
  caseKind: 'TRANSACTION',
  issueType: 'DEFECTIVE',
  requestedRemedy: 'PARTIAL_REFUND',
  requestedAmountCentavos: 9000,
  filedByParty: 'BUYER',
  responsibleParty: 'VENDOR',
  vendorName: 'Alpha Construction Supply',
  description: 'Five blocks arrived cracked.',
  affectedLines: const [disputeLine],
  originalMethodLabel: 'GCash •••• 1234',
  originalMethodNotice:
      'Any refund returns only to this original payment method.',
  deadlines:
      deadlines ??
      [
        DisputeDeadlineView(
          kind: 'RESPONSE',
          at: DateTime.utc(2026, 10, 7, 2),
          responsibleParty: 'VENDOR',
          label: 'Oct 7, 2026, 10:00 AM',
        ),
      ],
  timeline: [
    DisputeTimelineEntryView(
      id: 'e1',
      sequence: 1,
      type: 'CASE_FILED',
      actorParty: 'BUYER',
      actorRole: 'BUYER',
      actorName: 'Juan D.',
      at: DateTime.utc(2026, 10, 5, 2),
      body: 'Five blocks arrived cracked.',
      evidence: evidence,
    ),
  ],
  proposals: proposals,
  clarifications: clarifications,
  decisions: decisions,
  remedies: remedies,
  refundTimeline: refunds,
  actions: actions,
  lockVersion: 2,
  filedAt: DateTime.utc(2026, 10, 5, 2),
);

BuyerInvoicesView invoicesView({
  List<InvoiceRecordItem> records = const [],
  List<InvoiceRequestItem> requests = const [],
}) => BuyerInvoicesView(
  orderId: 'order-1',
  orderReference: 'ORD-2026-ABCD1234',
  status: records.isEmpty ? 'NOT_YET_UPLOADED' : 'ISSUED',
  issuanceNotice:
      'The store issues its own invoice when it is legally due. MateryalPH stores the copy it uploads.',
  records: records,
  requests: requests,
  platformDocuments: const [
    PlatformDocumentItem(
      kind: 'PURCHASE_ORDER',
      title: 'MateryalPH purchase order',
      notTaxInvoice: true,
      label: 'Not a tax invoice',
      availability: 'Available in order details.',
    ),
  ],
  canEditBillingDetails: true,
  canRequestCopy: records.isEmpty,
  canRequestCorrection: records.isNotEmpty,
);

class FakeDisputesRepository implements DisputesRepository {
  DisputeDetailView? detail;
  DisputeEligibilityView? eligible;
  DisputeListPage? list;
  BuyerInvoicesView? invoiceData;
  DiscoveryFailure? failure;
  DiscoveryFailure? Function(String call)? failOnce;
  final Map<String, Uint8List> files = {};
  final List<String> calls = [];
  final List<String> keys = [];
  final List<Map<String, Object?>> filings = [];
  DisputeDetailView Function(String action)? onAction;

  Future<T> _answer<T>(String call, T Function() value) async {
    calls.add(call);
    final once = failOnce?.call(call);
    if (once != null) {
      failOnce = null;
      throw once;
    }
    if (failure != null) throw failure!;
    return value();
  }

  Future<DisputeDetailView> _act(String action, String key) {
    keys.add(key);
    return _answer(action, () => onAction?.call(action) ?? detail!);
  }

  @override
  Future<DisputeListPage> disputes({int page = 1}) =>
      _answer('disputes:$page', () => list!);

  @override
  Future<DisputeDetailView> dispute(String caseId) =>
      _answer('dispute:$caseId', () => detail!);

  @override
  Future<DisputeEligibilityView> eligibility(String orderId) =>
      _answer('eligibility:$orderId', () => eligible!);

  @override
  Future<DisputeDetailView> file({
    required String orderId,
    required String issueType,
    required String requestedRemedy,
    required String description,
    required String idempotencyKey,
    int? requestedAmountCentavos,
    List<String> affectedLineIds = const [],
    EvidenceFile? evidence,
  }) {
    filings.add({
      'issueType': issueType,
      'requestedRemedy': requestedRemedy,
      'amount': requestedAmountCentavos,
      'lines': affectedLineIds,
      'file': evidence?.filename,
    });
    return _act('file', idempotencyKey);
  }

  @override
  Future<DisputeDetailView> respond(
    String caseId, {
    required String position,
    required String body,
    required String idempotencyKey,
    EvidenceFile? evidence,
  }) => _act('respond:$position', idempotencyKey);

  @override
  Future<DisputeDetailView> propose(
    String caseId, {
    required String remedy,
    required String terms,
    required String idempotencyKey,
    int? amountCentavos,
  }) => _act('propose:$remedy:${amountCentavos ?? '-'}', idempotencyKey);

  @override
  Future<DisputeDetailView> answerProposal(
    String caseId, {
    required String proposalId,
    required bool accept,
    required String idempotencyKey,
  }) => _act(
    'answerProposal:$proposalId:${accept ? 'ACCEPT' : 'REJECT'}',
    idempotencyKey,
  );

  @override
  Future<DisputeDetailView> escalate(
    String caseId, {
    required String reason,
    required String idempotencyKey,
  }) => _act('escalate', idempotencyKey);

  @override
  Future<DisputeDetailView> addEvidence(
    String caseId, {
    required EvidenceFile evidence,
    required String idempotencyKey,
    String? description,
  }) => _act('evidence:${evidence.filename}', idempotencyKey);

  @override
  Future<DisputeDetailView> message(
    String caseId, {
    required String body,
    required String idempotencyKey,
  }) => _act('message', idempotencyKey);

  @override
  Future<DisputeDetailView> answerClarification(
    String caseId, {
    required String clarificationId,
    required String response,
    required String idempotencyKey,
    EvidenceFile? evidence,
  }) => _act('clarify:$clarificationId', idempotencyKey);

  @override
  Future<DisputeDetailView> appeal(
    String caseId, {
    required String grounds,
    required String statement,
    required String idempotencyKey,
    EvidenceFile? evidence,
  }) => _act('appeal:$grounds:${evidence?.filename ?? '-'}', idempotencyKey);

  @override
  Future<DisputeDetailView> confirmReplacement(
    String caseId, {
    required String remedyId,
    required String idempotencyKey,
  }) => _act('confirmReplacement:$remedyId', idempotencyKey);

  @override
  Future<Uint8List> evidenceFile(String url) =>
      _answer('evidenceFile', () => files[url] ?? Uint8List(0));

  @override
  Future<BuyerInvoicesView> invoices(String orderId) =>
      _answer('invoices:$orderId', () => invoiceData!);

  @override
  Future<BuyerInvoicesView> requestInvoice(
    String orderId, {
    required String kind,
    required String details,
    required String idempotencyKey,
    String? invoiceRecordId,
  }) {
    keys.add(idempotencyKey);
    return _answer('requestInvoice:$kind', () => invoiceData!);
  }

  @override
  Future<BuyerInvoicesView> saveBillingDetails(
    String orderId, {
    required String billingName,
    required String billingAddress,
    String? tin,
    int? lockVersion,
  }) => _answer('saveBilling:$billingName', () => invoiceData!);

  @override
  Future<BuyerInvoicesView> answerInvoiceRequest(
    String orderId, {
    required String requestId,
    required bool close,
    required String idempotencyKey,
    String? reason,
  }) {
    keys.add(idempotencyKey);
    return _answer(
      'answerInvoice:$requestId:${close ? 'CLOSE' : 'RETURN'}',
      () => invoiceData!,
    );
  }

  @override
  Future<Uint8List> invoiceFile(String url) =>
      _answer('invoiceFile', () => files[url] ?? Uint8List(0));
}
