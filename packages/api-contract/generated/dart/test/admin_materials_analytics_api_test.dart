import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for AdminMaterialsAnalyticsApi
void main() {
  final instance = MateryalphApiClient().getAdminMaterialsAnalyticsApi();

  group(AdminMaterialsAnalyticsApi, () {
    // materials_analytics.inspect_sources. Append a reviewed replacement revision excluding proven-invalid observations; originals are retained.
    //
    //Future<AnalyticsCorrectionEnvelope> correctAdminMaterialPriceRun(String runId, String idempotencyKey, AnalyticsCorrectionRequest analyticsCorrectionRequest) async
    test('test correctAdminMaterialPriceRun', () async {
      // TODO
    });

    // analytics.view_aggregates and analytics.export. Aggregate CSV.
    //
    //Future<Uint8List> exportAdminMaterialsAnalytics({ int presetDays, Date startDate, Date endDate, String psgcCode, String psgcVersionId }) async
    test('test exportAdminMaterialsAnalytics', () async {
      // TODO
    });

    // analytics.view_aggregates. Graph/table with counts and exact means.
    //
    //Future<AdminMaterialsAnalyticsDetailEnvelope> getAdminMaterialPriceDetails(String groupId, { int presetDays, Date startDate, Date endDate, String psgcCode, String psgcVersionId }) async
    test('test getAdminMaterialPriceDetails', () async {
      // TODO
    });

    // analytics.view_aggregates. Snapshot health: state, revision, actual capture time and delay.
    //
    //Future<AnalyticsRunListEnvelope> listAdminMaterialPriceRuns() async
    test('test listAdminMaterialPriceRuns', () async {
      // TODO
    });

    // materials_analytics.inspect_sources. Public listing identity, price/version, capture time and recorded geography for one published date; audited with your reason.
    //
    //Future<AnalyticsSourceListEnvelope> listAdminMaterialPriceSources(String groupId, Date snapshotDate, String reason, { String psgcCode }) async
    test('test listAdminMaterialPriceSources', () async {
      // TODO
    });

    // analytics.view_aggregates. PSGC-scoped (or Philippines-wide) aggregates; payment/order filters do not apply to listed-price history.
    //
    //Future<AdminMaterialsAnalyticsListEnvelope> listAdminMaterialsAnalytics({ int presetDays, Date startDate, Date endDate, String categoryId, String q, String cursor, int perPage, String psgcCode, String psgcVersionId }) async
    test('test listAdminMaterialsAnalytics', () async {
      // TODO
    });

  });
}
