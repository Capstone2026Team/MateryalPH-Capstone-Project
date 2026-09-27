import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for StoreOperatingDay
void main() {
  final instance = StoreOperatingDayBuilder();
  // TODO add properties to the builder and call build()

  group(StoreOperatingDay, () {
    // ISO weekday; Monday is 1 and Sunday is 7.
    // int dayOfWeek
    test('to test the property `dayOfWeek`', () async {
      // TODO
    });

    // String status
    test('to test the property `status`', () async {
      // TODO
    });

    // Philippine local time; null when Closed.
    // String opensAt
    test('to test the property `opensAt`', () async {
      // TODO
    });

    // Later than opens_at on the same day; overnight periods are unsupported.
    // String closesAt
    test('to test the property `closesAt`', () async {
      // TODO
    });

  });
}
