import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for VendorStorePerformanceApi
void main() {
  final instance = MateryalphApiClient().getVendorStorePerformanceApi();

  group(VendorStorePerformanceApi, () {
    // scores.view_store (Owner, Store Manager). VPS, VCS, MQS, OHS, CRR, FRR, sample gates, windows, OHS components and badge states.
    //
    //Future<StorePerformanceEnvelope> getVendorStorePerformance() async
    test('test getVendorStorePerformance', () async {
      // TODO
    });

  });
}
