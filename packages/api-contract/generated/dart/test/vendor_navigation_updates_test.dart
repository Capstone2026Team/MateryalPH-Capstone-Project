import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for VendorNavigationUpdates
void main() {
  final instance = VendorNavigationUpdatesBuilder();
  // TODO add properties to the builder and call build()

  group(VendorNavigationUpdates, () {
    // Fixed Vendor sidebar paths mapped to section counts. Orders counts currently visible nonterminal orders; completed, declined, expired and cancelled orders are excluded. Team Accounts counts manageable active non-Owner memberships with active user accounts; deleted memberships and unaccepted invitations are excluded. Without current staff-management permission its count is zero. Notifications counts unread notices only; Messages counts received messages without a read receipt. Store Profile is omitted. Zero or missing counts have no indicator.
    // BuiltMap<String, int> sections
    test('to test the property `sections`', () async {
      // TODO
    });

  });
}
