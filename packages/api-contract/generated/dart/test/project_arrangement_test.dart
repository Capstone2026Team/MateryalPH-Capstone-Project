import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for ProjectArrangement
void main() {
  final instance = ProjectArrangementBuilder();
  // TODO add properties to the builder and call build()

  group(ProjectArrangement, () {
    // Versioned arrangement FMS with score, normalized components, raw buyer weights, supplier material shares and calculation basis. Material coverage uses exact allocated quantities per requirement, budget fit uses all materials and delivery, and distance and normalized VPS use material-cost shares. Existing neutral treatment for New Vendors remains unchanged.
    // BuiltMap<String, JsonObject> fms
    test('to test the property `fms`', () async {
      // TODO
    });

    // Position in the filtered Best Match result before pagination; null for Price sort, incomplete coverage or unresolved costs/data.
    // int rank
    test('to test the property `rank`', () async {
      // TODO
    });

    // Opaque Buyer and Work Package scoped server-issued proposal. Pass unchanged when creating this computed arrangement; never parse it in clients.
    // String proposalToken
    test('to test the property `proposalToken`', () async {
      // TODO
    });

    // String id
    test('to test the property `id`', () async {
      // TODO
    });

    // String sourceCandidateId
    test('to test the property `sourceCandidateId`', () async {
      // TODO
    });

    // int version
    test('to test the property `version`', () async {
      // TODO
    });

    // String workPackageVersionId
    test('to test the property `workPackageVersionId`', () async {
      // TODO
    });

    // BuiltList<BuiltMap<String, JsonObject>> vendors
    test('to test the property `vendors`', () async {
      // TODO
    });

    // int vendorCount
    test('to test the property `vendorCount`', () async {
      // TODO
    });

    // BuiltMap<String, JsonObject> coverage
    test('to test the property `coverage`', () async {
      // TODO
    });

    // int materialsCentavos
    test('to test the property `materialsCentavos`', () async {
      // TODO
    });

    // int deliveryCentavos
    test('to test the property `deliveryCentavos`', () async {
      // TODO
    });

    // int totalCentavos
    test('to test the property `totalCentavos`', () async {
      // TODO
    });

    // String budgetLabel
    test('to test the property `budgetLabel`', () async {
      // TODO
    });

    // String fingerprint
    test('to test the property `fingerprint`', () async {
      // TODO
    });

    // BuiltList<String> issues
    test('to test the property `issues`', () async {
      // TODO
    });

    // bool submitted
    test('to test the property `submitted`', () async {
      // TODO
    });

    // bool stale
    test('to test the property `stale`', () async {
      // TODO
    });

    // BuiltList<BuiltMap<String, JsonObject>> previousVendors
    test('to test the property `previousVendors`', () async {
      // TODO
    });

  });
}
