import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for VendorFinanceReviewsApi
void main() {
  final instance = MateryalphApiClient().getVendorFinanceReviewsApi();

  group(VendorFinanceReviewsApi, () {
    // Vendor Owner only (finance.view). FIN-10 review status for this store.
    //
    //Future<VendorFinanceReviewsEnvelope> getVendorFinanceReviews() async
    test('test getVendorFinanceReviews', () async {
      // TODO
    });

  });
}
