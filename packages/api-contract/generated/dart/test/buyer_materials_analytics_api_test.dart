import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for BuyerMaterialsAnalyticsApi
void main() {
  final instance = MateryalphApiClient().getBuyerMaterialsAnalyticsApi();

  group(BuyerMaterialsAnalyticsApi, () {
    // Product analytics: the product summary, its variants (each with its own price range, Vendor count and best stock label) and the most-offered variant's average, trend and daily series. Averages never blend different variants (MAT-03).
    //
    //Future<BuyerAnalyticsProductDetailEnvelope> getBuyerAnalyticsProduct(String materialId, BuyerMaterialsAnalyticsRequest buyerMaterialsAnalyticsRequest) async
    test('test getBuyerAnalyticsProduct', () async {
      // TODO
    });

    // Material Price Details: every date in the window (gaps are MISSING_DAY), the trend and the comparable variant selector.
    //
    //Future<BuyerMaterialsAnalyticsDetailEnvelope> getBuyerMaterialPriceDetails(String groupId, BuyerMaterialsAnalyticsRequest buyerMaterialsAnalyticsRequest) async
    test('test getBuyerMaterialPriceDetails', () async {
      // TODO
    });

    // One row per canonical product (material) within your origin and radius: comparable variant count, distinct current Vendor count and the min / median / max current price per canonical unit (each Vendor once per variant at its lowest price; ranges span variants and are not like-for-like). `categories` counts every product in scope for the overview tiles regardless of category_id or q. Read-only; POST keeps the origin out of URLs.
    //
    //Future<BuyerAnalyticsProductListEnvelope> listBuyerAnalyticsProducts(BuyerMaterialsAnalyticsRequest buyerMaterialsAnalyticsRequest) async
    test('test listBuyerAnalyticsProducts', () async {
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
