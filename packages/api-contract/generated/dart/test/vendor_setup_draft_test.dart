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

    // String publicEmail
    test('to test the property `publicEmail`', () async {
      // TODO
    });

    // String publicPhone
    test('to test the property `publicPhone`', () async {
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
