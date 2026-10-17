import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for AdminPrivacyRequestsApi
void main() {
  final instance = MateryalphApiClient().getAdminPrivacyRequestsApi();

  group(AdminPrivacyRequestsApi, () {
    // Assigned handler or privacy.manage; each opening is audited. Unassigned handlers receive 404.
    //
    //Future<PrivacyRequestDetailEnvelope> getPrivacyRequest(String requestId) async
    test('test getPrivacyRequest', () async {
      // TODO
    });

    // privacy.manage sees every request; privacy.handle sees only requests assigned to you.
    //
    //Future<PrivacyRequestListEnvelope> listPrivacyRequests({ String state, String requestType, String handler, int page, Date from, Date to }) async
    test('test listPrivacyRequests', () async {
      // TODO
    });

    // privacy.manage. Record a request received through an official channel.
    //
    //Future<PrivacyRequestDetailEnvelope> recordPrivacyRequest(String idempotencyKey, PrivacyRequestCreateRequest privacyRequestCreateRequest) async
    test('test recordPrivacyRequest', () async {
      // TODO
    });

    // Assign (privacy.manage), verify identity, start, complete, reject or withdraw with the current lock_version; closed requests are final.
    //
    //Future<PrivacyRequestDetailEnvelope> transitionPrivacyRequest(String requestId, String command, PrivacyTransitionRequest privacyTransitionRequest) async
    test('test transitionPrivacyRequest', () async {
      // TODO
    });

  });
}
