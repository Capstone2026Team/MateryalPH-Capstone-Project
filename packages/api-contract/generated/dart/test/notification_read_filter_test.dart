import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for NotificationReadFilter
void main() {
  final instance = NotificationReadFilterBuilder();
  // TODO add properties to the builder and call build()

  group(NotificationReadFilter, () {
    // Newest notification ID in the captured client inbox snapshot. Later arrivals remain unread.
    // String throughId
    test('to test the property `throughId`', () async {
      // TODO
    });

    // Exact notification category selected in the dynamic Type filter. Omit for All types. New categories are supported without a client enum change.
    // String category
    test('to test the property `category`', () async {
      // TODO
    });

    // Legacy exact display-title filter retained for older clients. New clients use category. When both filters are supplied, both must match.
    // String title
    test('to test the property `title`', () async {
      // TODO
    });

  });
}
