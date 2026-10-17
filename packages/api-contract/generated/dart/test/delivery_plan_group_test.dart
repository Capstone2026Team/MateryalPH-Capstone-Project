import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for DeliveryPlanGroup
void main() {
  final instance = DeliveryPlanGroupBuilder();
  // TODO add properties to the builder and call build()

  group(DeliveryPlanGroup, () {
    // String key
    test('to test the property `key`', () async {
      // TODO
    });

    // String label
    test('to test the property `label`', () async {
      // TODO
    });

    // String status
    test('to test the property `status`', () async {
      // TODO
    });

    // BuiltList<String> manualReviewReasons
    test('to test the property `manualReviewReasons`', () async {
      // TODO
    });

    // BuiltList<DeliveryPlanVehicle> candidates
    test('to test the property `candidates`', () async {
      // TODO
    });

    // Configured vehicles permitted for a recorded Owner or Store Manager manual load review, including an automatic dimensional-fit rejection. Availability, material compatibility, known payload, route range and access still apply. Trip counts cover known payload or mixer volume only and do not prove cargo fit. Empty outside MANUAL_REVIEW_REQUIRED; automatic candidates remain separate.
    // BuiltList<DeliveryPlanVehicle> manualReviewVehicles
    test('to test the property `manualReviewVehicles`', () async {
      // TODO
    });

  });
}
