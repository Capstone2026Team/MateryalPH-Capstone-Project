import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for VendorSetupDraft
void main() {
  final instance = VendorSetupDraftBuilder();
  // TODO add properties to the builder and call build()

  group(VendorSetupDraft, () {
    // Workstream draft version; zero on first save. Send together with the required organization guard. Omission retains legacy behavior without draft-level comparison. A stale draft returns 409 STALE_VERSION; a stale organization returns 409 RESOURCE_VERSION_CONFLICT.
    // int draftLockVersion
    test('to test the property `draftLockVersion`', () async {
      // TODO
    });

    // int organizationLockVersion
    test('to test the property `organizationLockVersion`', () async {
      // TODO
    });

    // Encrypted JSON setup form progress. Unfinished vehicle entries are not operational configurations. Returned privately as setup.form_state.
    // String formState
    test('to test the property `formState`', () async {
      // TODO
    });

    // Owner-only pause of all new procurement over the Asia/Manila date window in vacation_starts_on to vacation_ends_on, both required when true. Existing work and messaging remain available. False clears the window. Does not alter weekly hours or activation.
    // bool vacationMode
    test('to test the property `vacationMode`', () async {
      // TODO
    });

    // First Asia/Manila day of the pause. Today or later, unless an active window keeps its saved start. Today starts the pause immediately; a later date schedules it.
    // String vacationStartsOn
    test('to test the property `vacationStartsOn`', () async {
      // TODO
    });

    // Last Asia/Manila day of the pause, inclusive; on or after vacation_starts_on. Procurement reopens at the next midnight.
    // String vacationEndsOn
    test('to test the property `vacationEndsOn`', () async {
      // TODO
    });

    // String publicStoreName
    test('to test the property `publicStoreName`', () async {
      // TODO
    });

    // String description
    test('to test the property `description`', () async {
      // TODO
    });

    // bool bulkCapability
    test('to test the property `bulkCapability`', () async {
      // TODO
    });

    // String fulfillmentMethod
    test('to test the property `fulfillmentMethod`', () async {
      // TODO
    });

    // True activates delivery only after current staff, vehicle, location and service requirements pass; otherwise 422 VENDOR_DELIVERY_SETUP_REQUIRED. False saves a draft or pauses new deliveries. Omission preserves saved intent. Switching to SELF_PICKUP while delivery obligations remain returns 409 ACTIVE_DELIVERY_OBLIGATIONS. Accepted orders and assignments remain unchanged.
    // bool vendorDeliveryEnabled
    test('to test the property `vendorDeliveryEnabled`', () async {
      // TODO
    });

    // String publicEmail
    test('to test the property `publicEmail`', () async {
      // TODO
    });

    // String publicPhone
    test('to test the property `publicPhone`', () async {
      // TODO
    });

    // Complete replacement of the normal weekly schedule. All seven distinct weekdays are required. Closed days have null times; Open days need a same-day opening and later closing time.
    // BuiltList<StoreOperatingDay> operatingSchedule
    test('to test the property `operatingSchedule`', () async {
      // TODO
    });

    // VendorSetupDraftDelivery delivery
    test('to test the property `delivery`', () async {
      // TODO
    });

    // BuiltList<VendorSetupDraftVehiclesInner> vehicles
    test('to test the property `vehicles`', () async {
      // TODO
    });

  });
}
