import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for AdminBudgetOverridesApi
void main() {
  final instance = MateryalphApiClient().getAdminBudgetOverridesApi();

  group(AdminBudgetOverridesApi, () {
    // budget_overrides.view. Read-only Buyer budget overrides; Buyer decisions need no Admin approval.
    //
    //Future<BudgetOverrideListEnvelope> listBudgetOverrides({ int page }) async
    test('test listBudgetOverrides', () async {
      // TODO
    });

  });
}
