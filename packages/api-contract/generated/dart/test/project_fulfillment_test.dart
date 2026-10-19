import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for ProjectFulfillment
void main() {
  final instance = ProjectFulfillmentBuilder();
  // TODO add properties to the builder and call build()

  group(ProjectFulfillment, () {
    // String status
    test('to test the property `status`', () async {
      // TODO
    });

    // int linesTotal
    test('to test the property `linesTotal`', () async {
      // TODO
    });

    // int linesFulfilled
    test('to test the property `linesFulfilled`', () async {
      // TODO
    });

    // int linesPartial
    test('to test the property `linesPartial`', () async {
      // TODO
    });

    // int linesUnfulfilled
    test('to test the property `linesUnfulfilled`', () async {
      // TODO
    });

    // Lines this Vendor supplies in full by itself.
    // int vendorLinesFulfilled
    test('to test the property `vendorLinesFulfilled`', () async {
      // TODO
    });

    // BuiltList<ProjectFulfillmentLine> lines
    test('to test the property `lines`', () async {
      // TODO
    });

    // BuiltList<ProjectSeparatePurchase> separateItems
    test('to test the property `separateItems`', () async {
      // TODO
    });

    // int separateTotalCentavos
    test('to test the property `separateTotalCentavos`', () async {
      // TODO
    });

    // Projected total (materials when delivery is under review) plus the separate purchases.
    // int combinedTotalCentavos
    test('to test the property `combinedTotalCentavos`', () async {
      // TODO
    });

  });
}
