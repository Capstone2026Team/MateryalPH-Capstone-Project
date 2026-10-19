import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for WorkPackageInput
void main() {
  final instance = WorkPackageInputBuilder();
  // TODO add properties to the builder and call build()

  group(WorkPackageInput, () {
    // int lockVersion
    test('to test the property `lockVersion`', () async {
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

    // int budgetCentavos
    test('to test the property `budgetCentavos`', () async {
      // TODO
    });

    // String siteId
    test('to test the property `siteId`', () async {
      // TODO
    });

    // Optional. 50 km is the only Project-Based vendor-selection radius; the server applies it whether or not it is sent.
    // int radiusKm
    test('to test the property `radiusKm`', () async {
      // TODO
    });

    // BOTH means the Buyer is open to either. The scan lists every Vendor offering Site Delivery, Self-Pickup or both; each candidate then lists its `fulfillment_options` and the Buyer picks one when inquiring or selecting. BOTH requires `payment_method` ONLINE and the delivery details (`site_contact`, `access_instructions`, `heavy_vehicle_restriction`).
    // String fulfillmentMethod
    test('to test the property `fulfillmentMethod`', () async {
      // TODO
    });

    // Optional legacy value. New authoring omits payment; it is explicitly chosen in the selection checklist.
    // String paymentMethod
    test('to test the property `paymentMethod`', () async {
      // TODO
    });

    // String siteContact
    test('to test the property `siteContact`', () async {
      // TODO
    });

    // String heavyVehicleRestriction
    test('to test the property `heavyVehicleRestriction`', () async {
      // TODO
    });

    // String alternateDropOffLocationId
    test('to test the property `alternateDropOffLocationId`', () async {
      // TODO
    });

    // String accessInstructions
    test('to test the property `accessInstructions`', () async {
      // TODO
    });

    // BuiltList<WorkPackageLineInput> lines
    test('to test the property `lines`', () async {
      // TODO
    });

  });
}
