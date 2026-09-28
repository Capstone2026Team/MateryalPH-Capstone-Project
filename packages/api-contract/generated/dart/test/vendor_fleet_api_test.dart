import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for VendorFleetApi
void main() {
  final instance = MateryalphApiClient().getVendorFleetApi();

  group(VendorFleetApi, () {
    //Future<Uint8List> downloadFleetVehicleImage(String fileId) async
    test('test downloadFleetVehicleImage', () async {
      // TODO
    });

    //Future<VendorFileEnvelope> getFleetVehicleImageUrl(String fileId) async
    test('test getFleetVehicleImageUrl', () async {
      // TODO
    });

    // Owner and Store Manager receive every saved vehicle configuration with its eligibility reasons. Fulfillment Staff receive only confirmed vehicles on assigned orders (meta.scope ASSIGNED_ONLY). Other roles are denied.
    //
    //Future<FleetVehicleListEnvelope> listVendorFleetVehicles() async
    test('test listVendorFleetVehicles', () async {
      // TODO
    });

    // Owner or Store Manager saves a repeatable vehicle row set on the same records Store Setup uses. Every per-vehicle field error returns together keyed vehicles.{index}.{field}; a saved vehicle needs its lock_version (409 STALE_VERSION when stale). Changes append immutable configuration and rate versions and affect future proposals only; accepted delivery snapshots never change.
    //
    //Future<FleetVehicleListEnvelope> saveVendorFleetVehicles(FleetVehiclesSave fleetVehiclesSave) async
    test('test saveVendorFleetVehicles', () async {
      // TODO
    });

    // Stores a private, scanned and content-validated vehicle image for Owner or Store Manager.
    //
    //Future<FleetVehicleImageEnvelope> uploadFleetVehicleImage(MultipartFile file) async
    test('test uploadFleetVehicleImage', () async {
      // TODO
    });

  });
}
