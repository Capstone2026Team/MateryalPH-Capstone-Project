import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for ExploreCounts
void main() {
  final instance = ExploreCountsBuilder();
  // TODO add properties to the builder and call build()

  group(ExploreCounts, () {
    // Distinct active Tier 2 organizations with at least one eligible listing in scope.
    // int verifiedVendors
    test('to test the property `verifiedVendors`', () async {
      // TODO
    });

    // Distinct Vendor listings with at least one eligible variant; variants never inflate it.
    // int vendorListings
    test('to test the property `vendorListings`', () async {
      // TODO
    });

  });
}
