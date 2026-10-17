import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for AdminDashboardApi
void main() {
  final instance = MateryalphApiClient().getAdminDashboardApi();

  group(AdminDashboardApi, () {
    // Any active Admin. marketplace needs analytics.view_aggregates and the geo_analytics flag; vendor_health needs scores.view. Unknown parameters return 422 DASHBOARD_FILTER_UNSUPPORTED; no point or radius filter exists.
    //
    //Future<AdminDashboardInsightsEnvelope> getAdminDashboardInsights({ int days, String dataset, String area, Date from, Date to }) async
    test('test getAdminDashboardInsights', () async {
      // TODO
    });

  });
}
