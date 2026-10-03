import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for FleetSummary
void main() {
  final instance = FleetSummaryBuilder();
  // TODO add properties to the builder and call build()

  group(FleetSummary, () {
    // Saved configurations excluding removed records.
    // int configurations
    test('to test the property `configurations`', () async {
      // TODO
    });

    // Vehicle units in saved nonremoved configurations.
    // int totalVehicles
    test('to test the property `totalVehicles`', () async {
      // TODO
    });

    // Vehicle units in enabled nonremoved configurations.
    // int activeVehicles
    test('to test the property `activeVehicles`', () async {
      // TODO
    });

    // Vehicle units in enabled nonremoved configurations marked available. Does not imply eligibility or absence of delivery assignments.
    // int availableVehicles
    test('to test the property `availableVehicles`', () async {
      // TODO
    });

    // Sum of number_of_vehicles per confirmed snapshot entry on this Vendor's DELIVERY orders with order_state OUT_FOR_DELIVERY. Repeated assignments count separately.
    // int outForDeliveryVehicleAssignments
    test('to test the property `outForDeliveryVehicleAssignments`', () async {
      // TODO
    });

    // Distinct OUT_FOR_DELIVERY orders contributing confirmed vehicle assignments.
    // int outForDeliveryOrders
    test('to test the property `outForDeliveryOrders`', () async {
      // TODO
    });

  });
}
