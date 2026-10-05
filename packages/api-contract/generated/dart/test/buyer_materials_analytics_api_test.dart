import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for BuyerMaterialsAnalyticsApi
void main() {
  final instance = MateryalphApiClient().getBuyerMaterialsAnalyticsApi();

  group(BuyerMaterialsAnalyticsApi, () {
    // Material Price Details: every date in the window (gaps are MISSING_DAY), the trend and the comparable variant selector.
    //
    //Future<BuyerMaterialsAnalyticsDetailEnvelope> getBuyerMaterialPriceDetails(String groupId, BuyerMaterialsAnalyticsRequest buyerMaterialsAnalyticsRequest) async
    test('test getBuyerMaterialPriceDetails', () async {
      // TODO
    });

    // Current public offers (Buyer only), cheapest per canonical unit first; each opens the existing Product Details.
    //
    //Future<MaterialOfferListEnvelope> listBuyerMaterialOffers(String groupId, BuyerMaterialsAnalyticsRequest buyerMaterialsAnalyticsRequest) async
    test('test listBuyerMaterialOffers', () async {
      // TODO
    });

    // Categorized comparable variants within your origin and radius: daily equal-Vendor averages (one-Vendor limited data), exact-endpoint trends needing two Vendors at each endpoint, and current offering counts. Read-only; POST keeps the origin out of URLs.
    //
    //Future<BuyerMaterialsAnalyticsListEnvelope> listBuyerMaterialsAnalytics(BuyerMaterialsAnalyticsRequest buyerMaterialsAnalyticsRequest) async
    test('test listBuyerMaterialsAnalytics', () async {
      // TODO
    });

  });
}
