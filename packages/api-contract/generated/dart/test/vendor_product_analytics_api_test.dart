import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for VendorProductAnalyticsApi
void main() {
  final instance = MateryalphApiClient().getVendorProductAnalyticsApi();

  group(VendorProductAnalyticsApi, () {
    // Vendor members holding catalog.manage (Owner, Store Manager, Store Staff, Inventory Staff); others receive 403 PRODUCT_ANALYTICS_DENIED. Peso values are null unless the caller holds finance.view (Owner). Unknown parameters return 422 PRODUCT_ANALYTICS_FILTER_UNSUPPORTED. The products table is paginated (20 per page); sort=value falls back to orders without finance.view.
    //
    //Future<VendorProductAnalyticsEnvelope> getVendorProductAnalytics({ int days, Date from, Date to, String sort, int page }) async
    test('test getVendorProductAnalytics', () async {
      // TODO
    });

    // Vendor members holding catalog.manage (Owner, Store Manager, Store Staff, Inventory Staff); others receive 403 PRODUCT_ANALYTICS_DENIED. Peso values are null unless the caller holds finance.view (Owner). Unknown parameters return 422 PRODUCT_ANALYTICS_FILTER_UNSUPPORTED. A listing outside the caller’s store returns 404 LISTING_NOT_FOUND.
    //
    //Future<VendorProductAnalyticsDetailEnvelope> getVendorProductAnalyticsDetail(String listingId, { int days, Date from, Date to }) async
    test('test getVendorProductAnalyticsDetail', () async {
      // TODO
    });

    // Vendor members holding catalog.manage (Owner, Store Manager, Store Staff, Inventory Staff); others receive 403 PRODUCT_ANALYTICS_DENIED. Peso values are null unless the caller holds finance.view (Owner). Unknown parameters return 422 PRODUCT_ANALYTICS_FILTER_UNSUPPORTED. Up to 50 comma-separated listing IDs.
    //
    //Future<VendorProductAnalyticsSummariesEnvelope> getVendorProductAnalyticsSummaries(String listingIds, { int days }) async
    test('test getVendorProductAnalyticsSummaries', () async {
      // TODO
    });

  });
}
