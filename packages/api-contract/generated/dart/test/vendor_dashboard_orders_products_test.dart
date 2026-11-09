import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for VendorDashboardOrdersProducts
void main() {
  final instance = VendorDashboardOrdersProductsBuilder();
  // TODO add properties to the builder and call build()

  group(VendorDashboardOrdersProducts, () {
    // Owner-only reconciliation for the same surviving confirmed orders, latest financial snapshots and Manila dates as Finance and Product Analytics. Product/category values include discounts and VAT and are before partial refunds. Materials plus delivery less completed partial refunds equal Net sales.
    // VendorProductSalesBreakdown salesBreakdown
    test('to test the property `salesBreakdown`', () async {
      // TODO
    });

    // BuiltList<VendorDashboardProduct> top
    test('to test the property `top`', () async {
      // TODO
    });

    // BuiltList<VendorDashboardOrdersProductsCategoriesInner> categories
    test('to test the property `categories`', () async {
      // TODO
    });

    // VendorDashboardOrdersProductsSegments segments
    test('to test the property `segments`', () async {
      // TODO
    });

    // VendorDashboardOrdersProductsBasketRules basketRules
    test('to test the property `basketRules`', () async {
      // TODO
    });

  });
}
