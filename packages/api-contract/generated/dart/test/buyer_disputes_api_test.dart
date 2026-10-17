import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for BuyerDisputesApi
void main() {
  final instance = MateryalphApiClient().getBuyerDisputesApi();

  group(BuyerDisputesApi, () {
    // Labeled supplemental evidence; the original complaint is never edited.
    //
    //Future<DisputeDetailEnvelope> addBuyerDisputeEvidence(String caseId, String idempotencyKey, BuiltList<MultipartFile> files, { String description }) async
    test('test addBuyerDisputeEvidence', () async {
      // TODO
    });

    // Answer an Admin clarification within 24 hours.
    //
    //Future<DisputeDetailEnvelope> answerBuyerDisputeClarification(String caseId, String clarificationId, String idempotencyKey, String response, { BuiltList<MultipartFile> files }) async
    test('test answerBuyerDisputeClarification', () async {
      // TODO
    });

    // The other party accepts or rejects. Acceptance records the agreement as a final decision; a money agreement creates one DISPUTE_CONCLUSION refund per original payment and the case resolves only when it completes.
    //
    //Future<DisputeDetailEnvelope> answerBuyerDisputeProposal(String caseId, String proposalId, String idempotencyKey, DisputeProposalAnswer disputeProposalAnswer) async
    test('test answerBuyerDisputeProposal', () async {
      // TODO
    });

    // The case's one appeal, within five business days of an Admin decision, with new evidence or a material process error.
    //
    //Future<DisputeDetailEnvelope> appealBuyerDispute(String caseId, String idempotencyKey, String grounds, String statement, { BuiltList<MultipartFile> files }) async
    test('test appealBuyerDispute', () async {
      // TODO
    });

    // Authorize the current dispute channel; a stale or revoked channel is refused.
    //
    //Future<BuiltMap<String, JsonObject>> authorizeBuyerDisputeChannel(DisputeChannelAuthRequest disputeChannelAuthRequest) async
    test('test authorizeBuyerDisputeChannel', () async {
      // TODO
    });

    // Confirm receiving a replacement the Vendor recorded.
    //
    //Future<DisputeDetailEnvelope> confirmBuyerDisputeReplacement(String caseId, String remedyId, String idempotencyKey) async
    test('test confirmBuyerDisputeReplacement', () async {
      // TODO
    });

    // Ask for Admin review during mutual resolution (or as the responding party).
    //
    //Future<DisputeDetailEnvelope> escalateBuyerDispute(String caseId, String idempotencyKey, DisputeEscalateRequest disputeEscalateRequest) async
    test('test escalateBuyerDispute', () async {
      // TODO
    });

    // File a structured case. Creates a Case ID and the dispute state only — never a refund or REFUND_PENDING. A transaction case opens from PROCESSING; a post-completion return within seven days after COMPLETED. An active case on the order returns 409 DISPUTE_ALREADY_OPEN with its id.
    //
    //Future<DisputeDetailEnvelope> fileBuyerDispute(String idempotencyKey, String orderId, String issueType, String requestedRemedy, String description, { int requestedAmountCentavos, BuiltList<String> affectedLineIds, String preferredContactChannel, BuiltList<MultipartFile> files }) async
    test('test fileBuyerDispute', () async {
      // TODO
    });

    // The case with its single chronological timeline, signed evidence links, deadlines and server-computed actions.
    //
    //Future<DisputeDetailEnvelope> getBuyerDispute(String caseId) async
    test('test getBuyerDispute', () async {
      // TODO
    });

    // Whether a case can be filed, the read-only masked original payment method and the affected-line amounts. Never a refund destination.
    //
    //Future<DisputeEligibilityEnvelope> getBuyerDisputeEligibility(String orderId) async
    test('test getBuyerDisputeEligibility', () async {
      // TODO
    });

    // Evidence bytes behind a five-minute signed link; the caller is re-authorized against the case.
    //
    //Future<Uint8List> getBuyerDisputeEvidenceFile(String caseId, String fileId, int expires, String signature) async
    test('test getBuyerDisputeEvidenceFile', () async {
      // TODO
    });

    // The caller's private dispute channel. Its name changes whenever the caller's access changes; only \"case changed\" signals travel over it.
    //
    //Future<DisputeRealtimeEnvelope> getBuyerDisputeRealtime() async
    test('test getBuyerDisputeRealtime', () async {
      // TODO
    });

    // The Buyer's own cases. Paginated, active first.
    //
    //Future<DisputeListEnvelope> listBuyerDisputes({ String group, String q, int page }) async
    test('test listBuyerDisputes', () async {
      // TODO
    });

    // Propose a remedy during mutual resolution; it supersedes your earlier open proposal. Vendor refund proposals are Owner-only.
    //
    //Future<DisputeDetailEnvelope> proposeBuyerDisputeResolution(String caseId, String idempotencyKey, DisputeProposalRequest disputeProposalRequest) async
    test('test proposeBuyerDisputeResolution', () async {
      // TODO
    });

    // The responding party answers within 48 hours. A response opens 72 hours of mutual resolution; REQUEST_ADMIN_REVIEW escalates. A late response returns 409 RESPONSE_WINDOW_CLOSED.
    //
    //Future<DisputeDetailEnvelope> respondBuyerDispute(String caseId, String idempotencyKey, String position, String body, { int amountCentavos, BuiltList<MultipartFile> files }) async
    test('test respondBuyerDispute', () async {
      // TODO
    });

    // A case message, appended to the timeline.
    //
    //Future<DisputeDetailEnvelope> sendBuyerDisputeMessage(String caseId, String idempotencyKey, DisputeMessageRequest disputeMessageRequest) async
    test('test sendBuyerDisputeMessage', () async {
      // TODO
    });

  });
}
