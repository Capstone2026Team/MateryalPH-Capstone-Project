import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for VendorEarningsTrend
void main() {
  final instance = VendorEarningsTrendBuilder();
  // TODO add properties to the builder and call build()

  group(VendorEarningsTrend, () {
    // String granularity
    test('to test the property `granularity`', () async {
      // TODO
    });

    // String timezone
    test('to test the property `timezone`', () async {
      // TODO
    });

    // Date from
    test('to test the property `from`', () async {
      // TODO
    });

    // Date to
    test('to test the property `to`', () async {
      // TODO
    });

    // int days
    test('to test the property `days`', () async {
      // TODO
    });

    // One point per day or month in order; a bucket with no records is zero. Empty when the period starts after today.
    // BuiltList<VendorEarningsTrendPoint> points
    test('to test the property `points`', () async {
      // TODO
    });

    // Totals of the equal-length period just before this one, for comparison; null when the period is empty.
    // VendorEarningsTrendComparison previous
    test('to test the property `previous`', () async {
      // TODO
    });

  });
}
