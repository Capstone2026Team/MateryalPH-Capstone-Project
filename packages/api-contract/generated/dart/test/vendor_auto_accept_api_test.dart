import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for VendorAutoAcceptApi
void main() {
  final instance = MateryalphApiClient().getVendorAutoAcceptApi();

  group(VendorAutoAcceptApi, () {
    // Owner or Store Manager enables or disables Item-Based auto-accept and sets the independent allotment, unit and amount safeguards. Disabled by default; enabling needs an ACTIVE listing, a validated price-tax classification and a whole-number allotment above zero. Reconfiguring a paused policy never resumes it. Project-Based procurement and NRPC orders are never auto-accepted.
    //
    //Future<AutoAcceptPolicyDetailEnvelope> configureAutoAcceptPolicy(String variantId, AutoAcceptPolicyConfigure autoAcceptPolicyConfigure) async
    test('test configureAutoAcceptPolicy', () async {
      // TODO
    });

    // Vendor-only Item-Based auto-accept configuration with the private stock context and immutable version history. Store Staff and Customer Service Staff view outcomes only; Fulfillment Staff are denied.
    //
    //Future<AutoAcceptPolicyDetailEnvelope> getAutoAcceptPolicy(String variantId) async
    test('test getAutoAcceptPolicy', () async {
      // TODO
    });

    //Future<AutoAcceptPolicyDetailEnvelope> pauseAutoAcceptPolicy(String variantId, AutoAcceptPause autoAcceptPause) async
    test('test pauseAutoAcceptPolicy', () async {
      // TODO
    });

    // Deliberate Owner or Store Manager resume. confirmed_allotment_quantity must equal the remaining allotment being restored (409 AUTO_ACCEPT_ALLOTMENT_CHANGED otherwise); a zero allotment returns 422 AUTO_ACCEPT_ALLOTMENT_REQUIRED.
    //
    //Future<AutoAcceptPolicyDetailEnvelope> resumeAutoAcceptPolicy(String variantId, String idempotencyKey, AutoAcceptResume autoAcceptResume) async
    test('test resumeAutoAcceptPolicy', () async {
      // TODO
    });

    // Sets the remaining allotment only (Inventory Staff grant; Owner and Store Manager also). Zero pauses an active policy and notifies permitted users. A higher allotment never resumes a paused policy.
    //
    //Future<AutoAcceptPolicyDetailEnvelope> updateAutoAcceptAllotment(String variantId, AutoAcceptAllotmentUpdate autoAcceptAllotmentUpdate) async
    test('test updateAutoAcceptAllotment', () async {
      // TODO
    });

  });
}
