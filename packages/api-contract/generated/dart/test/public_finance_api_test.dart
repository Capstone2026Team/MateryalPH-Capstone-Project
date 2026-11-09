import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for PublicFinanceApi
void main() {
  final instance = MateryalphApiClient().getPublicFinanceApi();

  group(PublicFinanceApi, () {
    // Public, no-store projection of the current and next effective commercial policy and rendered TEST terms. No Admin reason, staff identity, acceptance or delivery data. Resolved by timestamp, independently of scheduler execution.
    //
    //Future<PublicCommissionPolicyEnvelope> getPublicCommissionPolicy({ String policy }) async
    test('test getPublicCommissionPolicy', () async {
      // TODO
    });

  });
}
