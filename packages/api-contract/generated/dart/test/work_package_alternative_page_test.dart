import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for WorkPackageAlternativePage
void main() {
  final instance = WorkPackageAlternativePageBuilder();
  // TODO add properties to the builder and call build()

  group(WorkPackageAlternativePage, () {
    // BuiltMap<String, JsonObject> line
    test('to test the property `line`', () async {
      // TODO
    });

    // NO_SUITABLE_ALTERNATIVE: no eligible store within the radius can supply the quantity still needed (see `excluded`). COVERED: separate purchases already satisfy the line. A failed request is an error response, never one of these.
    // String status
    test('to test the property `status`', () async {
      // TODO
    });

    // The quantity still to source: the compared Vendor's gap less the separate purchases that satisfy the line (the full line quantity when no `candidate_id` is sent).
    // String neededQuantity
    test('to test the property `neededQuantity`', () async {
      // TODO
    });

    // WorkPackageAlternativePageExcluded excluded
    test('to test the property `excluded`', () async {
      // TODO
    });

    // The Project site's saved location, for display only. The server scopes the purchase from the package's locked site point.
    // String locationId
    test('to test the property `locationId`', () async {
      // TODO
    });

    // The fixed Project-Based radius.
    // int radiusKm
    test('to test the property `radiusKm`', () async {
      // TODO
    });

    // BuiltList<WorkPackageAlternative> items
    test('to test the property `items`', () async {
      // TODO
    });

    // int page
    test('to test the property `page`', () async {
      // TODO
    });

    // bool hasMore
    test('to test the property `hasMore`', () async {
      // TODO
    });

    // int total
    test('to test the property `total`', () async {
      // TODO
    });

  });
}
