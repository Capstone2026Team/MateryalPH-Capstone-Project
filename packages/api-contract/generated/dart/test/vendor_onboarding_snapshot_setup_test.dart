import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for VendorOnboardingSnapshotSetup
void main() {
  final instance = VendorOnboardingSnapshotSetupBuilder();
  // TODO add properties to the builder and call build()

  group(VendorOnboardingSnapshotSetup, () {
    // BuiltList<StoreOperatingDay> operatingSchedule
    test('to test the property `operatingSchedule`', () async {
      // TODO
    });

    // VendorDeliverySetup deliverySetup
    test('to test the property `deliverySetup`', () async {
      // TODO
    });

    // True while new procurement is paused.
    // bool vacationMode
    test('to test the property `vacationMode`', () async {
      // TODO
    });

    // SCHEDULED when a future start date is saved. ACTIVE with null dates is a legacy open-ended pause the Owner can turn off.
    // String vacationStatus
    test('to test the property `vacationStatus`', () async {
      // TODO
    });

    // Asia/Manila calendar date.
    // String vacationStartsOn
    test('to test the property `vacationStartsOn`', () async {
      // TODO
    });

    // Inclusive last Asia/Manila day.
    // String vacationEndsOn
    test('to test the property `vacationEndsOn`', () async {
      // TODO
    });

  });
}
