import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for TutorialsApi
void main() {
  final instance = MateryalphApiClient().getTutorialsApi();

  group(TutorialsApi, () {
    // Save completion or dismissal for the signed-in user
    //
    // Idempotent acknowledgment. COMPLETED cannot be downgraded by a replay. Keys are role-scoped; Buyer supports overview/discovery/procurement/projects/messages/orders and Vendor supports overview/store/products/inventory/messages/orders/dashboard/fulfillment/invoices/disputes/reviews/vehicles/finance/commissions/transactions/remittance/performance/analytics/team/tracking/settings/notifications/support. Page acknowledgments are per person and do not grant access to the corresponding workspace. Vendor requests require the existing CSRF header. Replay never resets persisted progress. No other user ID is accepted.
    //
    //Future<TutorialProgressEnvelope> acknowledgeTutorial(String tutorialPortal, String tutorialKey, TutorialAcknowledgment tutorialAcknowledgment) async
    test('test acknowledgeTutorial', () async {
      // TODO
    });

    // Read the signed-in user's tutorial acknowledgments
    //
    // Bounded to six Buyer keys or 23 Vendor overview/page keys for this account type. An absent key is unseen. Buyer uses native bearer transport; Vendor uses cookie transport. Does not alter account or store onboarding.
    //
    //Future<TutorialProgressEnvelope> getTutorialProgress(String tutorialPortal) async
    test('test getTutorialProgress', () async {
      // TODO
    });

  });
}
