import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for VendorVerificationDraftClassification
void main() {
  final instance = VendorVerificationDraftClassificationBuilder();
  // TODO add properties to the builder and call build()

  group(VendorVerificationDraftClassification, () {
    // WHOLESALER_DISTRIBUTOR or RETAIL_HARDWARE_STORE or SPECIALIZED_SUPPLIER.
    // String supplierType
    test('to test the property `supplierType`', () async {
      // TODO
    });

    // BuiltList<String> niches
    test('to test the property `niches`', () async {
      // TODO
    });

    // Legacy single label; used when custom_labels is omitted.
    // String customLabel
    test('to test the property `customLabel`', () async {
      // TODO
    });

    // Vendor-provided labels for Other Category, kept separate from canonical taxonomy. Returned in onboarding classification; legacy custom_label mirrors the first label. Empty when Other Category is not selected.
    // BuiltSet<String> customLabels
    test('to test the property `customLabels`', () async {
      // TODO
    });

  });
}
