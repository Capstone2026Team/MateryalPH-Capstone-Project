import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for VendorDisputesApi
void main() {
  final instance = MateryalphApiClient().getVendorDisputesApi();

  group(VendorDisputesApi, () {
    // Labeled supplemental evidence; the original complaint is never edited.
    //
    //Future<DisputeDetailEnvelope> addVendorDisputeEvidence(String caseId, String idempotencyKey, BuiltList<MultipartFile> files, { String description }) async
    test('test addVendorDisputeEvidence', () async {
      // TODO
    });

    // Answer an Admin clarification within 24 hours.
    //
    //Future<DisputeDetailEnvelope> answerVendorDisputeClarification(String caseId, String clarificationId, String idempotencyKey, String response, { BuiltList<MultipartFile> files }) async
    test('test answerVendorDisputeClarification', () async {
      // TODO
    });

    // The other party accepts or rejects. Acceptance records the agreement as a final decision; a money agreement creates one DISPUTE_CONCLUSION refund per original payment and the case resolves only when it completes.
    //
    //Future<DisputeDetailEnvelope> answerVendorDisputeProposal(String caseId, String proposalId, String idempotencyKey, DisputeProposalAnswer disputeProposalAnswer) async
    test('test answerVendorDisputeProposal', () async {
      // TODO
    });

    // The case's one appeal, within five business days of an Admin decision, with new evidence or a material process error.
    //
    //Future<DisputeDetailEnvelope> appealVendorDispute(String caseId, String idempotencyKey, String grounds, String statement, { BuiltList<MultipartFile> files }) async
    test('test appealVendorDispute', () async {
      // TODO
    });

    // Authorize the current dispute channel; a stale or revoked channel is refused.
    //
    //Future<BuiltMap<String, JsonObject>> authorizeVendorDisputeChannel(DisputeChannelAuthRequest disputeChannelAuthRequest) async
    test('test authorizeVendorDisputeChannel', () async {
      // TODO
    });

    // Download a ready, unexpired export (audited).
    //
    //Future<Uint8List> downloadVendorDisputeExport(String exportId) async
    test('test downloadVendorDisputeExport', () async {
      // TODO
    });

    // Ask for Admin review during mutual resolution (or as the responding party).
    //
    //Future<DisputeDetailEnvelope> escalateVendorDispute(String caseId, String idempotencyKey, DisputeEscalateRequest disputeEscalateRequest) async
    test('test escalateVendorDispute', () async {
      // TODO
    });

    // File a structured case. Creates a Case ID and the dispute state only — never a refund or REFUND_PENDING. A transaction case opens from PROCESSING; a post-completion return within seven days after COMPLETED. An active case on the order returns 409 DISPUTE_ALREADY_OPEN with its id.
    //
    //Future<DisputeDetailEnvelope> fileVendorDispute(String idempotencyKey, String orderId, String issueType, String requestedRemedy, String description, { int requestedAmountCentavos, BuiltList<String> affectedLineIds, String preferredContactChannel, BuiltList<MultipartFile> files }) async
    test('test fileVendorDispute', () async {
      // TODO
    });

    // The case with its single chronological timeline, signed evidence links, deadlines and server-computed actions.
    //
    //Future<DisputeDetailEnvelope> getVendorDispute(String caseId) async
    test('test getVendorDispute', () async {
      // TODO
    });

    // Whether a case can be filed, the read-only masked original payment method and the affected-line amounts. Never a refund destination.
    //
    //Future<DisputeEligibilityEnvelope> getVendorDisputeEligibility(String orderId) async
    test('test getVendorDisputeEligibility', () async {
      // TODO
    });

    // Evidence bytes behind a five-minute signed link; the caller is re-authorized against the case.
    //
    //Future<Uint8List> getVendorDisputeEvidenceFile(String caseId, String fileId, int expires, String signature) async
    test('test getVendorDisputeEvidenceFile', () async {
      // TODO
    });

    // The caller's private dispute channel. Its name changes whenever the caller's access changes; only \"case changed\" signals travel over it.
    //
    //Future<DisputeRealtimeEnvelope> getVendorDisputeRealtime() async
    test('test getVendorDisputeRealtime', () async {
      // TODO
    });

    // Your recent case exports.
    //
    //Future<DisputeExportListEnvelope> listVendorDisputeExports() async
    test('test listVendorDisputeExports', () async {
      // TODO
    });

    // Owner and Store Manager; Store Staff and Customer Service while the Owner's staff dispute flag is on (403 otherwise); assigned Fulfillment Staff see a limited case and add fulfillment evidence only; Inventory Staff are denied. Paginated, active first.
    //
    //Future<DisputeListEnvelope> listVendorDisputes({ String group, String q, int page, Date from, Date to }) async
    test('test listVendorDisputes', () async {
      // TODO
    });

    // Propose a remedy during mutual resolution; it supersedes your earlier open proposal. Vendor refund proposals are Owner-only.
    //
    //Future<DisputeDetailEnvelope> proposeVendorDisputeResolution(String caseId, String idempotencyKey, DisputeProposalRequest disputeProposalRequest) async
    test('test proposeVendorDisputeResolution', () async {
      // TODO
    });

    // Record the replacement; the Buyer confirms it.
    //
    //Future<DisputeDetailEnvelope> recordVendorDisputeReplacement(String caseId, String remedyId, String idempotencyKey, String note, { BuiltList<MultipartFile> files }) async
    test('test recordVendorDisputeReplacement', () async {
      // TODO
    });

    // Queue a CSV of case headers. The job re-checks access when it runs and on download; switching the staff dispute flag off revokes staff exports.
    //
    //Future<DisputeExportEnvelope> requestVendorDisputeExport(DisputeExportRequest disputeExportRequest) async
    test('test requestVendorDisputeExport', () async {
      // TODO
    });

    // The responding party answers within 48 hours. A response opens 72 hours of mutual resolution; REQUEST_ADMIN_REVIEW escalates. A late response returns 409 RESPONSE_WINDOW_CLOSED.
    //
    //Future<DisputeDetailEnvelope> respondVendorDispute(String caseId, String idempotencyKey, String position, String body, { int amountCentavos, BuiltList<MultipartFile> files }) async
    test('test respondVendorDispute', () async {
      // TODO
    });

    // A case message, appended to the timeline.
    //
    //Future<DisputeDetailEnvelope> sendVendorDisputeMessage(String caseId, String idempotencyKey, DisputeMessageRequest disputeMessageRequest) async
    test('test sendVendorDisputeMessage', () async {
      // TODO
    });

  });
}
