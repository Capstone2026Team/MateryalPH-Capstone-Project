import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for WorkPackageView
void main() {
  final instance = WorkPackageViewBuilder();
  // TODO add properties to the builder and call build()

  group(WorkPackageView, () {
    // String selectedArrangementId
    test('to test the property `selectedArrangementId`', () async {
      // TODO
    });

    // String procurementCandidateId
    test('to test the property `procurementCandidateId`', () async {
      // TODO
    });

    // BuiltList<BuiltMap<String, JsonObject>> vendorOrders
    test('to test the property `vendorOrders`', () async {
      // TODO
    });

    // String id
    test('to test the property `id`', () async {
      // TODO
    });

    // String projectId
    test('to test the property `projectId`', () async {
      // TODO
    });

    // String projectStatus
    test('to test the property `projectStatus`', () async {
      // TODO
    });

    // String name
    test('to test the property `name`', () async {
      // TODO
    });

    // String status
    test('to test the property `status`', () async {
      // TODO
    });

    // int budgetCentavos
    test('to test the property `budgetCentavos`', () async {
      // TODO
    });

    // int lockVersion
    test('to test the property `lockVersion`', () async {
      // TODO
    });

    // String currentVersionId
    test('to test the property `currentVersionId`', () async {
      // TODO
    });

    // Current active Vendor selection; null when the corresponding order is cancelled, declined or expired. The order itself remains available as history.
    // String selectedVendorId
    test('to test the property `selectedVendorId`', () async {
      // TODO
    });

    // String orderId
    test('to test the property `orderId`', () async {
      // TODO
    });

    // WorkPackageVersion version
    test('to test the property `version`', () async {
      // TODO
    });

    // ProjectBudget budget
    test('to test the property `budget`', () async {
      // TODO
    });

    // BuiltList<BuiltMap<String, JsonObject>> missingLines
    test('to test the property `missingLines`', () async {
      // TODO
    });

    // BuiltMap<String, JsonObject> document
    test('to test the property `document`', () async {
      // TODO
    });

    // True while a non-cancelled, non-declined, non-expired order or tagged purchase is tied to this package, or a Vendor selection has no matching closed order. A historical closed order and its old selection do not block editing, reactivation or deletion. Completed commercial work remains protected.
    // bool hasOrder
    test('to test the property `hasOrder`', () async {
      // TODO
    });

    // True when has_order is false and the Project is Active. Cancelled order history is retained; deleting a package with locked history hides it instead of deleting commercial records.
    // bool canDelete
    test('to test the property `canDelete`', () async {
      // TODO
    });

  });
}
