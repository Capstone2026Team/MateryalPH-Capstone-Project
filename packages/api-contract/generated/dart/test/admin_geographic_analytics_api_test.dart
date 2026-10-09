import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for AdminGeographicAnalyticsApi
void main() {
  final instance = MateryalphApiClient().getAdminGeographicAnalyticsApi();

  group(AdminGeographicAnalyticsApi, () {
    // analytics.view_aggregates. KPIs, trends, rates, response time, DAU/WAU/MAU and the child-area table from daily facts, after small-cell suppression. Unknown parameters return 422 ANALYTICS_FILTER_UNSUPPORTED.
    //
    //Future<GeoDashboardEnvelope> getGeoAnalyticsDashboard({ String dataset, String area, Date from, Date to, String granularity, String procurementType, String categoryId, String materialId, String fulfillmentMethod, String paymentMethod, String orderState }) async
    test('test getGeoAnalyticsDashboard', () async {
      // TODO
    });

    // analytics.view_aggregates. Simplified PSGC boundaries of the selection's children for the map.
    //
    //Future<GeoBoundaryEnvelope> getGeoBoundaries({ String area }) async
    test('test getGeoBoundaries', () async {
      // TODO
    });

    // analytics.view_aggregates. Category or material demand by child area; quantity needs one material (422 QUANTITY_NEEDS_MATERIAL).
    //
    //Future<GeoDemandEnvelope> getGeoDemandHeatmap({ String dataset, String area, Date from, Date to, String granularity, String procurementType, String categoryId, String materialId, String fulfillmentMethod, String paymentMethod, String orderState, String measure }) async
    test('test getGeoDemandHeatmap', () async {
      // TODO
    });

  });
}
