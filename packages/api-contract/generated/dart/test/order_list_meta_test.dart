import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for OrderListMeta
void main() {
  final instance = OrderListMetaBuilder();
  // TODO add properties to the builder and call build()

  group(OrderListMeta, () {
    // String group
    test('to test the property `group`', () async {
      // TODO
    });

    // BuiltMap<String, int> counts
    test('to test the property `counts`', () async {
      // TODO
    });

    // Buyer lists include ITEM_BASED and PROJECT_BASED active order totals across all pages and status chips, regardless of procurement_type. Excludes COMPLETED, CANCELLED, DECLINED and EXPIRED; includes DISPUTED. Omitted on Vendor and Admin lists.
    // BuiltMap<String, int> activeCounts
    test('to test the property `activeCounts`', () async {
      // TODO
    });

    // int page
    test('to test the property `page`', () async {
      // TODO
    });

    // int perPage
    test('to test the property `perPage`', () async {
      // TODO
    });

    // int total
    test('to test the property `total`', () async {
      // TODO
    });

    // bool hasMore
    test('to test the property `hasMore`', () async {
      // TODO
    });

    // DateTime currentAsOf
    test('to test the property `currentAsOf`', () async {
      // TODO
    });

  });
}
