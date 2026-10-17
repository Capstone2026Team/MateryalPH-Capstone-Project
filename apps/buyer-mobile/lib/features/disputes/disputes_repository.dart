import 'dart:typed_data';

import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart' show MultipartFile, Response;
import 'package:materyalph_api_client/materyalph_api_client.dart' as api;

import '../../core/api_guard.dart';
import '../map_discovery/discovery_models.dart';
import '../orders/fulfillment_models.dart' show RefundTimelineView;
import '../orders/orders_repository.dart' show refundTimelineFromApi;
import 'dispute_models.dart';

/// Buyer transaction disputes and the Vendor invoice copies of an order, through `/api/v1` only.
/// Filing creates a Case ID and a dispute state — never a refund; only a concluded money decision
/// creates a Dispute-Conclusion Refund, always to the original payment method. Every mutation
/// carries an Idempotency-Key. The generated client repeats the `files` key, which the API reads as
/// one part, so each submission carries at most one file.
abstract interface class DisputesRepository {
  Future<DisputeListPage> disputes({int page = 1});

  Future<DisputeDetailView> dispute(String caseId);

  Future<DisputeEligibilityView> eligibility(String orderId);

  Future<DisputeDetailView> file({
    required String orderId,
    required String issueType,
    required String requestedRemedy,
    required String description,
    required String idempotencyKey,
    int? requestedAmountCentavos,
    List<String> affectedLineIds = const [],
    EvidenceFile? evidence,
  });

  Future<DisputeDetailView> respond(
    String caseId, {
    required String position,
    required String body,
    required String idempotencyKey,
    EvidenceFile? evidence,
  });

  Future<DisputeDetailView> propose(
    String caseId, {
    required String remedy,
    required String terms,
    required String idempotencyKey,
    int? amountCentavos,
  });

  Future<DisputeDetailView> answerProposal(
    String caseId, {
    required String proposalId,
    required bool accept,
    required String idempotencyKey,
  });

  Future<DisputeDetailView> escalate(
    String caseId, {
    required String reason,
    required String idempotencyKey,
  });

  Future<DisputeDetailView> addEvidence(
    String caseId, {
    required EvidenceFile evidence,
    required String idempotencyKey,
    String? description,
  });

  Future<DisputeDetailView> message(
    String caseId, {
    required String body,
    required String idempotencyKey,
  });

  Future<DisputeDetailView> answerClarification(
    String caseId, {
    required String clarificationId,
    required String response,
    required String idempotencyKey,
    EvidenceFile? evidence,
  });

  Future<DisputeDetailView> appeal(
    String caseId, {
    required String grounds,
    required String statement,
    required String idempotencyKey,
    EvidenceFile? evidence,
  });

  Future<DisputeDetailView> confirmReplacement(
    String caseId, {
    required String remedyId,
    required String idempotencyKey,
  });

  /// Opens a signed, short-lived evidence link through the authenticated API.
  Future<Uint8List> evidenceFile(String url);

  Future<BuyerInvoicesView> invoices(String orderId);

  Future<BuyerInvoicesView> requestInvoice(
    String orderId, {
    required String kind,
    required String details,
    required String idempotencyKey,
    String? invoiceRecordId,
  });

  Future<BuyerInvoicesView> saveBillingDetails(
    String orderId, {
    required String billingName,
    required String billingAddress,
    String? tin,
    int? lockVersion,
  });

  Future<BuyerInvoicesView> answerInvoiceRequest(
    String orderId, {
    required String requestId,
    required bool close,
    required String idempotencyKey,
    String? reason,
  });

  /// Opens a signed, short-lived Vendor invoice copy through the authenticated API.
  Future<Uint8List> invoiceFile(String url);
}

final class ApiDisputesRepository implements DisputesRepository {
  ApiDisputesRepository({
    required api.MateryalphApiClient client,
    required ApiGuard guard,
  }) : _client = client,
       _api = guard;

  final api.MateryalphApiClient _client;
  final ApiGuard _api;

  api.BuyerDisputesApi get _disputes => _client.getBuyerDisputesApi();
  api.BuyerInvoicesApi get _invoices => _client.getBuyerInvoicesApi();

  static BuiltList<MultipartFile>? _files(EvidenceFile? file) => file == null
      ? null
      : BuiltList<MultipartFile>([
          MultipartFile.fromBytes(file.bytes, filename: file.filename),
        ]);

  Future<DisputeDetailView> _detailOf(
    Future<Response<api.DisputeDetailEnvelope>> Function() call,
  ) => _api(() async {
    final response = await call();
    return disputeDetailFromApi(_api.required(response.data?.data));
  });

  @override
  Future<DisputeListPage> disputes({int page = 1}) => _api(() async {
    final response = await _disputes.listBuyerDisputes(page: page);
    final envelope = _api.required(response.data);
    return DisputeListPage(
      items: envelope.data.map(_summary).toList(),
      page: envelope.meta.page ?? page,
      hasMore: envelope.meta.hasMore ?? false,
    );
  });

  @override
  Future<DisputeDetailView> dispute(String caseId) =>
      _detailOf(() => _disputes.getBuyerDispute(caseId: caseId));

  @override
  Future<DisputeEligibilityView> eligibility(String orderId) => _api(() async {
    final response = await _disputes.getBuyerDisputeEligibility(
      orderId: orderId,
    );
    final value = _api.required(response.data?.data);
    return DisputeEligibilityView(
      available: value.available,
      reason: value.reason,
      activeCaseId: value.activeCaseId,
      caseKind: value.caseKind.name,
      postCompletionDeadline: value.postCompletionDeadline,
      issueTypes: value.issueTypes.map((code) => code.name).toList(),
      requestedRemedies: value.requestedRemedies
          .map((code) => code.name)
          .toList(),
      lines: value.lines.map(_line).toList(),
      methodLabel: value.originalPaymentMethod.label,
      methodPhysical: value.originalPaymentMethod.physical,
      refundDestinationNotice: value.refundDestinationNotice,
    );
  });

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
  }) => _detailOf(
    () => _disputes.fileBuyerDispute(
      idempotencyKey: idempotencyKey,
      orderId: orderId,
      issueType: issueType,
      requestedRemedy: requestedRemedy,
      description: description,
      requestedAmountCentavos: requestedAmountCentavos,
      affectedLineIds: affectedLineIds.isEmpty
          ? null
          : BuiltList<String>(affectedLineIds),
      files: _files(evidence),
    ),
  );

  @override
  Future<DisputeDetailView> respond(
    String caseId, {
    required String position,
    required String body,
    required String idempotencyKey,
    EvidenceFile? evidence,
  }) => _detailOf(
    () => _disputes.respondBuyerDispute(
      caseId: caseId,
      idempotencyKey: idempotencyKey,
      position: position,
      body: body,
      files: _files(evidence),
    ),
  );

  @override
  Future<DisputeDetailView> propose(
    String caseId, {
    required String remedy,
    required String terms,
    required String idempotencyKey,
    int? amountCentavos,
  }) => _detailOf(
    () => _disputes.proposeBuyerDisputeResolution(
      caseId: caseId,
      idempotencyKey: idempotencyKey,
      disputeProposalRequest: api.DisputeProposalRequest(
        (b) => b
          ..remedy = api.DisputeProposalRequestRemedyEnum.valueOf(remedy)
          ..terms = terms
          ..amountCentavos = amountCentavos,
      ),
    ),
  );

  @override
  Future<DisputeDetailView> answerProposal(
    String caseId, {
    required String proposalId,
    required bool accept,
    required String idempotencyKey,
  }) => _detailOf(
    () => _disputes.answerBuyerDisputeProposal(
      caseId: caseId,
      proposalId: proposalId,
      idempotencyKey: idempotencyKey,
      disputeProposalAnswer: api.DisputeProposalAnswer(
        (b) => b
          ..decision = accept
              ? api.DisputeProposalAnswerDecisionEnum.ACCEPT
              : api.DisputeProposalAnswerDecisionEnum.REJECT,
      ),
    ),
  );

  @override
  Future<DisputeDetailView> escalate(
    String caseId, {
    required String reason,
    required String idempotencyKey,
  }) => _detailOf(
    () => _disputes.escalateBuyerDispute(
      caseId: caseId,
      idempotencyKey: idempotencyKey,
      disputeEscalateRequest: api.DisputeEscalateRequest(
        (b) => b..reason = reason,
      ),
    ),
  );

  @override
  Future<DisputeDetailView> addEvidence(
    String caseId, {
    required EvidenceFile evidence,
    required String idempotencyKey,
    String? description,
  }) => _detailOf(
    () => _disputes.addBuyerDisputeEvidence(
      caseId: caseId,
      idempotencyKey: idempotencyKey,
      files: _files(evidence)!,
      description: description,
    ),
  );

  @override
  Future<DisputeDetailView> message(
    String caseId, {
    required String body,
    required String idempotencyKey,
  }) => _detailOf(
    () => _disputes.sendBuyerDisputeMessage(
      caseId: caseId,
      idempotencyKey: idempotencyKey,
      disputeMessageRequest: api.DisputeMessageRequest((b) => b..body = body),
    ),
  );

  @override
  Future<DisputeDetailView> answerClarification(
    String caseId, {
    required String clarificationId,
    required String response,
    required String idempotencyKey,
    EvidenceFile? evidence,
  }) => _detailOf(
    () => _disputes.answerBuyerDisputeClarification(
      caseId: caseId,
      clarificationId: clarificationId,
      idempotencyKey: idempotencyKey,
      response: response,
      files: _files(evidence),
    ),
  );

  @override
  Future<DisputeDetailView> appeal(
    String caseId, {
    required String grounds,
    required String statement,
    required String idempotencyKey,
    EvidenceFile? evidence,
  }) => _detailOf(
    () => _disputes.appealBuyerDispute(
      caseId: caseId,
      idempotencyKey: idempotencyKey,
      grounds: grounds,
      statement: statement,
      files: _files(evidence),
    ),
  );

  @override
  Future<DisputeDetailView> confirmReplacement(
    String caseId, {
    required String remedyId,
    required String idempotencyKey,
  }) => _detailOf(
    () => _disputes.confirmBuyerDisputeReplacement(
      caseId: caseId,
      remedyId: remedyId,
      idempotencyKey: idempotencyKey,
    ),
  );

  @override
  Future<Uint8List> evidenceFile(String url) => _api(() async {
    // /buyers/disputes/{caseId}/files/{fileId}/content?expires=…&signature=…
    final signed = parseSignedUrl(url);
    final segments = signed?.segments ?? const <String>[];
    final at = segments.indexOf('disputes');
    if (signed == null || at < 0 || segments.length < at + 4) {
      throw const DiscoveryFailure(
        DiscoveryFailureKind.notFound,
        'This file link is no longer valid. Refresh the case and try again.',
      );
    }
    final response = await _disputes.getBuyerDisputeEvidenceFile(
      caseId: segments[at + 1],
      fileId: segments[at + 3],
      expires: signed.expires,
      signature: signed.signature,
    );
    return _api.required(response.data);
  });

  @override
  Future<BuyerInvoicesView> invoices(String orderId) => _api(() async {
    final response = await _invoices.getBuyerOrderInvoices(orderId: orderId);
    return _invoicesView(_api.required(response.data?.data));
  });

  @override
  Future<BuyerInvoicesView> requestInvoice(
    String orderId, {
    required String kind,
    required String details,
    required String idempotencyKey,
    String? invoiceRecordId,
  }) => _api(() async {
    final response = await _invoices.requestBuyerInvoice(
      orderId: orderId,
      idempotencyKey: idempotencyKey,
      invoiceRequestCreate: api.InvoiceRequestCreate(
        (b) => b
          ..kind = api.InvoiceRequestCreateKindEnum.valueOf(kind)
          ..details = details
          ..invoiceRecordId = invoiceRecordId,
      ),
    );
    return _invoicesView(_api.required(response.data?.data));
  });

  @override
  Future<BuyerInvoicesView> saveBillingDetails(
    String orderId, {
    required String billingName,
    required String billingAddress,
    String? tin,
    int? lockVersion,
  }) => _api(() async {
    final response = await _invoices.saveBuyerInvoiceDetails(
      orderId: orderId,
      invoiceBillingDetailsRequest: api.InvoiceBillingDetailsRequest(
        (b) => b
          ..billingName = billingName
          ..billingAddress = billingAddress
          ..tin = tin
          ..lockVersion = lockVersion,
      ),
    );
    return _invoicesView(_api.required(response.data?.data));
  });

  @override
  Future<BuyerInvoicesView> answerInvoiceRequest(
    String orderId, {
    required String requestId,
    required bool close,
    required String idempotencyKey,
    String? reason,
  }) => _api(() async {
    final response = await _invoices.answerBuyerInvoiceRequest(
      orderId: orderId,
      requestId: requestId,
      idempotencyKey: idempotencyKey,
      invoiceRequestAnswer: api.InvoiceRequestAnswer(
        (b) => b
          ..action = close
              ? api.InvoiceRequestAnswerActionEnum.CLOSE
              : api.InvoiceRequestAnswerActionEnum.RETURN
          ..reason = reason,
      ),
    );
    return _invoicesView(_api.required(response.data?.data));
  });

  @override
  Future<Uint8List> invoiceFile(String url) => _api(() async {
    // /buyers/invoice-records/{recordId}/content?expires=…&signature=…
    final signed = parseSignedUrl(url);
    final segments = signed?.segments ?? const <String>[];
    final at = segments.indexOf('invoice-records');
    if (signed == null || at < 0 || segments.length < at + 2) {
      throw const DiscoveryFailure(
        DiscoveryFailureKind.notFound,
        'This file link is no longer valid. Refresh and try again.',
      );
    }
    final response = await _invoices.getBuyerInvoiceFile(
      recordId: segments[at + 1],
      expires: signed.expires,
      signature: signed.signature,
    );
    return _api.required(response.data);
  });

  static DisputeDeadlineView _deadline(api.DisputeDeadline deadline) =>
      DisputeDeadlineView(
        kind: deadline.kind.name,
        at: deadline.at,
        responsibleParty: deadline.responsibleParty.name,
        label: deadline.label,
      );

  static DisputeLineView _line(api.DisputeAffectedLine line) => DisputeLineView(
    orderLineId: line.orderLineId,
    displayName: line.displayName,
    variantLabel: line.variantLabel,
    quantity: line.quantity,
    lineTotalCentavos: line.lineTotalCentavos,
    refundableCentavos: line.refundableCentavos,
  );

  static DisputeSummaryView _summary(api.DisputeSummary row) =>
      DisputeSummaryView(
        id: row.id,
        reference: row.reference,
        orderId: row.orderId,
        orderReference: row.orderReference,
        status: row.status.name,
        issueType: row.issueType.name,
        requestedRemedy: row.requestedRemedy.name,
        requestedAmountCentavos: row.requestedAmountCentavos,
        responsibleParty: row.responsibleParty.name,
        refundState: row.refundState,
        remedyState: row.remedyState.name,
        vendorName: row.vendorName,
        nextDeadline: row.nextDeadline == null
            ? null
            : _deadline(row.nextDeadline!),
        filedAt: row.filedAt,
      );

  static DisputeDetailView disputeDetailFromApi(api.DisputeDetail row) =>
      DisputeDetailView(
        id: row.id,
        reference: row.reference,
        orderId: row.order.id,
        orderReference: row.order.reference,
        status: row.status.name,
        caseKind: row.caseKind.name,
        issueType: row.issueType.name,
        requestedRemedy: row.requestedRemedy.name,
        requestedAmountCentavos: row.requestedAmountCentavos,
        filedByParty: row.filedByParty.name,
        responsibleParty: row.responsibleParty.name,
        vendorName: row.vendorName,
        description: row.description,
        affectedLines: row.affectedLines.map(_line).toList(),
        originalMethodLabel: row.originalPaymentMethod?.label,
        originalMethodNotice: row.originalPaymentMethod?.notice,
        deadlines: row.deadlines.map(_deadline).toList(),
        timeline: row.timeline
            .map(
              (entry) => DisputeTimelineEntryView(
                id: entry.id,
                sequence: entry.sequence,
                type: entry.type.name,
                actorParty: entry.actor.party.name,
                actorRole: entry.actor.role,
                actorName: entry.actor.displayName,
                at: entry.at,
                body: entry.body,
                evidence: entry.evidence
                    .map(
                      (file) => DisputeEvidenceView(
                        fileId: file.fileId,
                        label: file.label.name,
                        name: file.name,
                        contentType: file.contentType,
                        byteSize: file.byteSize,
                        url: file.url,
                        expiresAt: file.expiresAt,
                        description: file.description,
                      ),
                    )
                    .toList(),
              ),
            )
            .toList(),
        proposals: row.proposals
            .map(
              (proposal) => DisputeProposalView(
                id: proposal.id,
                proposedByParty: proposal.proposedByParty.name,
                remedy: proposal.remedy.name,
                amountCentavos: proposal.amountCentavos,
                terms: proposal.terms,
                state: proposal.state.name,
                canAnswer: proposal.canAnswer,
              ),
            )
            .toList(),
        clarifications: row.clarifications
            .map(
              (item) => DisputeClarificationView(
                id: item.id,
                requestedParty: item.requestedParty.name,
                question: item.question,
                dueAt: item.dueAt,
                state: item.state.name,
                response: item.response,
                canAnswer: item.canAnswer,
              ),
            )
            .toList(),
        decisions: row.decisions
            .map(
              (decision) => DisputeDecisionView(
                id: decision.id,
                version: decision.version,
                kind: decision.kind.name,
                outcome: decision.outcome.name,
                appealResult: decision.appealResult?.name,
                awardedCentavos: decision.awardedCentavos,
                reason: decision.reason,
                evidenceLimitation: decision.evidenceLimitation,
                enforceable: decision.enforceable,
                decidedAt: decision.decidedAt,
                appealDueAt: decision.appealDueAt,
                current: decision.current,
              ),
            )
            .toList(),
        appeal: row.appeal == null
            ? null
            : DisputeAppealView(
                appellantParty: row.appeal!.appellantParty.name,
                grounds: row.appeal!.grounds.name,
                state: row.appeal!.state.name,
              ),
        remedies: row.remedies
            .map(
              (remedy) => DisputeRemedyView(
                id: remedy.id,
                kind: remedy.kind.name,
                state: remedy.state.name,
                amountCentavos: remedy.amountCentavos,
                note: remedy.note,
                canConfirm: remedy.canConfirm,
              ),
            )
            .toList(),
        refundTimeline: _refunds(row),
        actions: {...row.availableActions.map((action) => action.name)},
        lockVersion: row.lockVersion,
        filedAt: row.filedAt,
      );

  static RefundTimelineView _refunds(api.DisputeDetail row) {
    final items = refundTimelineFromApi(
      refunds: row.refunds,
      reimbursements: row.reimbursements ?? BuiltList(),
    );
    return RefundTimelineView(
      refunds: items.refunds,
      reimbursements: items.reimbursements,
      noLongerDueCentavos: 0,
    );
  }

  static BuyerInvoicesView _invoicesView(api.BuyerOrderInvoices value) =>
      BuyerInvoicesView(
        orderId: value.orderId,
        orderReference: value.orderReference,
        status: value.status.name,
        issuanceNotice: value.issuanceNotice,
        records: value.records
            .map(
              (record) => InvoiceRecordItem(
                id: record.id,
                invoiceType: record.invoiceType.name,
                issuer: record.issuer,
                invoiceNumber: record.invoiceNumber,
                issuedOn: record.issuedOn,
                amountCentavos: record.amountCentavos,
                originLabel: record.originLabel,
                complianceNote: record.complianceNote,
                reconciliationState: record.reconciliationState.name,
                reconciliationDifferenceCentavos:
                    record.reconciliationDifferenceCentavos,
                reconciliationNote: record.reconciliationNote,
                downloadUrl: record.download?.url,
                buyerTotalUnchanged: record.buyerTotalUnchanged,
              ),
            )
            .toList(),
        requests: value.requests
            .map(
              (request) => InvoiceRequestItem(
                id: request.id,
                kind: request.kind.name,
                state: request.state.name,
                details: request.details,
                serviceTargetAt: request.serviceTargetAt,
                serviceTargetLabel: request.serviceTargetLabel,
                overdue: request.overdue,
                canReturn: request.canReturn,
                canClose: request.canClose,
              ),
            )
            .toList(),
        platformDocuments: value.platformDocuments
            .map(
              (document) => PlatformDocumentItem(
                kind: document.kind.name,
                title: document.title,
                notTaxInvoice: document.notTaxInvoice,
                label: document.label.name,
                availability: document.availability,
              ),
            )
            .toList(),
        billingName: value.billingDetails?.billingName,
        billingAddress: value.billingDetails?.billingAddress,
        tinMasked: value.billingDetails?.tinMasked,
        billingLockVersion: value.billingDetails?.lockVersion,
        canEditBillingDetails: value.canEditBillingDetails,
        canRequestCopy: value.canRequestCopy,
        canRequestCorrection: value.canRequestCorrection,
      );
}
