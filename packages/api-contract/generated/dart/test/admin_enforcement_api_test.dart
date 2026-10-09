import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for AdminEnforcementApi
void main() {
  final instance = MateryalphApiClient().getAdminEnforcementApi();

  group(AdminEnforcementApi, () {
    // enforcement.apply (ban: enforcement.ban plus recent re-authentication). Apply a referred sanction; 409 on a stale lock_version.
    //
    //Future<EnforcementDetailEnvelope> applyEnforcementAction(String actionId, EnforcementApplyRequest enforcementApplyRequest) async
    test('test applyEnforcementAction', () async {
      // TODO
    });

    // enforcement.apply. Decline a referred sanction with a reason.
    //
    //Future<EnforcementDetailEnvelope> declineEnforcementAction(String actionId, ReasonedVersionRequest reasonedVersionRequest) async
    test('test declineEnforcementAction', () async {
      // TODO
    });

    // enforcement.view. Sanction, subject review, append-only events and the actions your role may take.
    //
    //Future<EnforcementDetailEnvelope> getEnforcementAction(String actionId) async
    test('test getEnforcementAction', () async {
      // TODO
    });

    // enforcement.view. Account-review facts and the sanction history of one Buyer or Vendor.
    //
    //Future<EnforcementSubjectEnvelope> getEnforcementSubject(String type, String subjectId) async
    test('test getEnforcementSubject', () async {
      // TODO
    });

    // enforcement.apply (ban: enforcement.ban plus recent re-authentication). Lift an applied sanction; a store returns to READY or NOT_READY, never ACTIVE.
    //
    //Future<EnforcementDetailEnvelope> liftEnforcementAction(String actionId, ReasonedVersionRequest reasonedVersionRequest) async
    test('test liftEnforcementAction', () async {
      // TODO
    });

    // enforcement.view (Super Admin, User Management, Order and Dispute read-only). Referred sanctions first, oldest first.
    //
    //Future<EnforcementListEnvelope> listEnforcementActions({ String state, String subjectType, String action, String source_, String subjectId, int page }) async
    test('test listEnforcementActions', () async {
      // TODO
    });

    // enforcement.apply. Record a Warning or apply a restriction, suspension or (Super Admin) ban with a reason, restoration condition and continuation plan for open orders.
    //
    //Future<EnforcementDetailEnvelope> recordEnforcementAction(String idempotencyKey, EnforcementRecordRequest enforcementRecordRequest) async
    test('test recordEnforcementAction', () async {
      // TODO
    });

    // enforcement.view. A Vendor by store name or a Buyer by exact account email; minimal identity only.
    //
    //Future<EnforcementSubjectMatchListEnvelope> searchEnforcementSubjects(String type, String q) async
    test('test searchEnforcementSubjects', () async {
      // TODO
    });

  });
}
