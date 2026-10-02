import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for OrderDeadlines
void main() {
  final instance = OrderDeadlinesBuilder();
  // TODO add properties to the builder and call build()

  group(OrderDeadlines, () {
    // DateTime vendorResponseDueAt
    test('to test the property `vendorResponseDueAt`', () async {
      // TODO
    });

    // DateTime buyerResponseDueAt
    test('to test the property `buyerResponseDueAt`', () async {
      // TODO
    });

    // 24 hours after the order entered AWAITING_PAYMENT (Pending Payment). The server clock decides; clients only display it.
    // DateTime paymentExpiresAt
    test('to test the property `paymentExpiresAt`', () async {
      // TODO
    });

    // DateTime serverTime
    test('to test the property `serverTime`', () async {
      // TODO
    });

    // String timezone
    test('to test the property `timezone`', () async {
      // TODO
    });

  });
}
