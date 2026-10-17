import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for WorkPackageLineInput
void main() {
  final instance = WorkPackageLineInputBuilder();
  // TODO add properties to the builder and call build()

  group(WorkPackageLineInput, () {
    // Canonical catalog material; omitted or null for an unlisted material the Buyer names. Unlisted lines accept any normalized unit and are always missing lines.
    // String materialId
    test('to test the property `materialId`', () async {
      // TODO
    });

    // String name
    test('to test the property `name`', () async {
      // TODO
    });

    // String description
    test('to test the property `description`', () async {
      // TODO
    });

    // String color
    test('to test the property `color`', () async {
      // TODO
    });

    // String unitId
    test('to test the property `unitId`', () async {
      // TODO
    });

    // Positive quantity within the selected normalized unit precision; maximum 1,000,000.
    // String quantity
    test('to test the property `quantity`', () async {
      // TODO
    });

    // BuiltMap<String, String> specifications
    test('to test the property `specifications`', () async {
      // TODO
    });

    // String preferredBrand
    test('to test the property `preferredBrand`', () async {
      // TODO
    });

  });
}
