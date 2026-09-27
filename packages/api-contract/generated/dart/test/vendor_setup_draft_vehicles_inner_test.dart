import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for VendorSetupDraftVehiclesInner
void main() {
  final instance = VendorSetupDraftVehiclesInnerBuilder();
  // TODO add properties to the builder and call build()

  group(VendorSetupDraftVehiclesInner, () {
    // String id
    test('to test the property `id`', () async {
      // TODO
    });

    // Separate category and type. Categorized configurations require applicable cargo dimensions or mixer capacity and heavy classification.
    // String vehicleCategory
    test('to test the property `vehicleCategory`', () async {
      // TODO
    });

    // String vehicleType
    test('to test the property `vehicleType`', () async {
      // TODO
    });

    // String customTypeName
    test('to test the property `customTypeName`', () async {
      // TODO
    });

    // String brand
    test('to test the property `brand`', () async {
      // TODO
    });

    // num mixerCapacityM3
    test('to test the property `mixerCapacityM3`', () async {
      // TODO
    });

    // Clean VEHICLE_IMAGE file owned by this Vendor.
    // String imageFileId
    test('to test the property `imageFileId`', () async {
      // TODO
    });

    // Disabled configurations are retained for history and excluded from recommendations.
    // bool active
    test('to test the property `active`', () async {
      // TODO
    });

    // String name
    test('to test the property `name`', () async {
      // TODO
    });

    // num capacityKg
    test('to test the property `capacityKg`', () async {
      // TODO
    });

    // int numberAvailable
    test('to test the property `numberAvailable`', () async {
      // TODO
    });

    // num cargoLengthM
    test('to test the property `cargoLengthM`', () async {
      // TODO
    });

    // num cargoWidthM
    test('to test the property `cargoWidthM`', () async {
      // TODO
    });

    // num cargoHeightM
    test('to test the property `cargoHeightM`', () async {
      // TODO
    });

    // String heavyClassification
    test('to test the property `heavyClassification`', () async {
      // TODO
    });

    // int baseFeeCentavos
    test('to test the property `baseFeeCentavos`', () async {
      // TODO
    });

    // int perKmCentavos
    test('to test the property `perKmCentavos`', () async {
      // TODO
    });

    // Omission retains the saved limit; new coverage defaults to the approved 50 km procurement limit. New vehicle rates inherit coverage.
    // int maximumDistanceKm
    test('to test the property `maximumDistanceKm`', () async {
      // TODO
    });

  });
}
