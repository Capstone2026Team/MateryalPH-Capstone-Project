import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for AdminDisputesApi
void main() {
  final instance = MateryalphApiClient().getAdminDisputesApi();

  group(AdminDisputesApi, () {
    // disputes.decide. Take the case.
    //
    //Future<DisputeDetailEnvelope> assignAdminDispute(String caseId, String idempotencyKey) async
    test('test assignAdminDispute', () async {
      // TODO
    });

    // Authorize the current dispute channel.
    //
    //Future<BuiltMap<String, JsonObject>> authorizeAdminDisputeChannel(DisputeChannelAuthRequest disputeChannelAuthRequest) async
    test('test authorizeAdminDisputeChannel', () async {
      // TODO
    });

    // disputes.decide. Reasoned confirmation of a recorded replacement the Buyer did not acknowledge.
    //
    //Future<DisputeDetailEnvelope> confirmAdminDisputeRemedy(String caseId, String remedyId, String idempotencyKey, DisputeRemedyConfirmRequest disputeRemedyConfirmRequest) async
    test('test confirmAdminDisputeRemedy', () async {
      // TODO
    });

    // disputes.decide. A new immutable decision version with the remedy, reason and conflict check. A money award executes now when immediately enforceable, otherwise after the appeal window lapses.
    //
    //Future<DisputeDetailEnvelope> decideAdminDispute(String caseId, String idempotencyKey, AdminDisputeDecisionRequest adminDisputeDecisionRequest) async
    test('test decideAdminDispute', () async {
      // TODO
    });

    // disputes.decide by a different Admin than the appealed decision. Affirmed, Modified or Reversed; final.
    //
    //Future<DisputeDetailEnvelope> decideAdminDisputeAppeal(String caseId, String idempotencyKey, AdminDisputeAppealDecisionRequest adminDisputeAppealDecisionRequest) async
    test('test decideAdminDisputeAppeal', () async {
      // TODO
    });

    // disputes.decide. Direct safety or compliance escalation.
    //
    //Future<DisputeDetailEnvelope> escalateAdminDispute(String caseId, String idempotencyKey, DisputeEscalateRequest disputeEscalateRequest) async
    test('test escalateAdminDispute', () async {
      // TODO
    });

    // disputes.view. The case with decision support.
    //
    //Future<DisputeDetailEnvelope> getAdminDispute(String caseId) async
    test('test getAdminDispute', () async {
      // TODO
    });

    // disputes.view. Evidence behind a signed link.
    //
    //Future<Uint8List> getAdminDisputeEvidenceFile(String caseId, String fileId, int expires, String signature) async
    test('test getAdminDisputeEvidenceFile', () async {
      // TODO
    });

    // disputes.view. The caller's dispute channel.
    //
    //Future<DisputeRealtimeEnvelope> getAdminDisputeRealtime() async
    test('test getAdminDisputeRealtime', () async {
      // TODO
    });

    // disputes.view. Case ID, order, parties, issue, handler, deadline, status, requested remedy and refund state.
    //
    //Future<DisputeListEnvelope> listAdminDisputes({ String status, int page }) async
    test('test listAdminDisputes', () async {
      // TODO
    });

    // disputes.decide. Structured question with a 24-hour deadline per requested party.
    //
    //Future<DisputeDetailEnvelope> requestAdminDisputeClarification(String caseId, String idempotencyKey, AdminDisputeClarificationRequest adminDisputeClarificationRequest) async
    test('test requestAdminDisputeClarification', () async {
      // TODO
    });

  });
}
