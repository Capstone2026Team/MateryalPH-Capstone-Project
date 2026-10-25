import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for VendorMaterialsAnalyticsApi
void main() {
  final instance = MateryalphApiClient().getVendorMaterialsAnalyticsApi();

  group(VendorMaterialsAnalyticsApi, () {
    // materials_analytics.view_competitors. Aggregate-only CSV with the same suppression; re-authorized on every request.
    //
    //Future<Uint8List> exportVendorMaterialsAnalytics({ int presetDays, Date startDate, Date endDate, int radiusKm, String q, String categoryId }) async
    test('test exportVendorMaterialsAnalytics', () async {
      // TODO
    });

    // materials_analytics.view_competitors. The aggregate graph/table for one comparable variant; there is no competitor-offers child.
    //
    //Future<VendorMaterialsAnalyticsDetailEnvelope> getVendorMaterialPriceDetails(String groupId, { int presetDays, Date startDate, Date endDate, int radiusKm }) async
    test('test getVendorMaterialPriceDetails', () async {
      // TODO
    });

    // materials_analytics.view_competitors (Owner, Store Manager only). Competitor aggregates excluding your organization, suppressed below three competitors at every point and endpoint, and your own price separately. No offers, identities or protected finance.
    //
    //Future<VendorMaterialsAnalyticsListEnvelope> listVendorMaterialsAnalytics({ int presetDays, Date startDate, Date endDate, String categoryId, String q, String cursor, int perPage, int radiusKm }) async
    test('test listVendorMaterialsAnalytics', () async {
      // TODO
    });

  });
}
