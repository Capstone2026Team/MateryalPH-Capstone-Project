import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for SupportPageMeta
void main() {
  final instance = SupportPageMetaBuilder();
  // TODO add properties to the builder and call build()

  group(SupportPageMeta, () {
    // Admin ticket lists only. Full totals for all five support statuses after search, category, user type and date filters but before status selection and cursor pagination. Includes zeroes for empty statuses; absent from Buyer, Vendor, history and handler lists.
    // BuiltMap<String, int> counts
    test('to test the property `counts`', () async {
      // TODO
    });

    // String nextCursor
    test('to test the property `nextCursor`', () async {
      // TODO
    });

    // String correlationId
    test('to test the property `correlationId`', () async {
      // TODO
    });

  });
}
