import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for VendorDashboardApi
void main() {
  final instance = MateryalphApiClient().getVendorDashboardApi();

  group(VendorDashboardApi, () {
    // Any active Vendor member. Sections follow the fixed-role grants: orders.confirm, finance.view (peso values), scores.view_store, inventory.view and portal.disputes; a section without its grant is null. Unknown parameters return 422 DASHBOARD_FILTER_UNSUPPORTED.
    //
    //Future<VendorDashboardInsightsEnvelope> getVendorDashboardInsights({ int days, Date from, Date to }) async
    test('test getVendorDashboardInsights', () async {
      // TODO
    });

  });
}
