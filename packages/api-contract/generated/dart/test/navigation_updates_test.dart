import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for NavigationUpdates
void main() {
  final instance = NavigationUpdatesBuilder();
  // TODO add properties to the builder and call build()

  group(NavigationUpdates, () {
    // Authorized navigation paths mapped to unread messages/notices, active records or pending actions. Team headcounts are retained only in the legacy Vendor summary and are not displayed as attention badges.
    // BuiltMap<String, int> sections
    test('to test the property `sections`', () async {
      // TODO
    });

    // Buyer only. Exact sum of active selected line quantities, excluding saved-for-later; never a line or unread count.
    // String cartQuantity
    test('to test the property `cartQuantity`', () async {
      // TODO
    });

    // Buyer only. Current active cart lock_version, zero when no cart exists.
    // int cartVersion
    test('to test the property `cartVersion`', () async {
      // TODO
    });

  });
}
