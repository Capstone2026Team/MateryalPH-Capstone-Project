import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for VendorInvoicePreset
void main() {
  final instance = VendorInvoicePresetBuilder();
  // TODO add properties to the builder and call build()

  group(VendorInvoicePreset, () {
    // String invoiceType
    test('to test the property `invoiceType`', () async {
      // TODO
    });

    // Must equal the registered business name.
    // String issuerName
    test('to test the property `issuerName`', () async {
      // TODO
    });

    // String sourceSystem
    test('to test the property `sourceSystem`', () async {
      // TODO
    });

    // String invoicingMethod
    test('to test the property `invoicingMethod`', () async {
      // TODO
    });

    // Current lock version; zero creates a new draft or preset.
    // int lockVersion
    test('to test the property `lockVersion`', () async {
      // TODO
    });

    // New copies start with today in Asia/Manila. Each invoice date remains editable; numbers and amounts are never preset.
    // String dateMode
    test('to test the property `dateMode`', () async {
      // TODO
    });

  });
}
