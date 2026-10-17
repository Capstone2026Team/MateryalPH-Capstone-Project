import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for ComplianceExtraction
void main() {
  final instance = ComplianceExtractionBuilder();
  // TODO add properties to the builder and call build()

  group(ComplianceExtraction, () {
    // String source_
    test('to test the property `source_`', () async {
      // TODO
    });

    // Extraction provenance, such as TESSERACT, NONE or BROWSER_QR_DECODER. Null for manual entry.
    // String provider
    test('to test the property `provider`', () async {
      // TODO
    });

    // String status
    test('to test the property `status`', () async {
      // TODO
    });

    // Mean OCR word recognition confidence; never a probability of authenticity or approval.
    // num confidence
    test('to test the property `confidence`', () async {
      // TODO
    });

    // Editable marking_type, certificate_number (the PS License No. or ICC sticker serial), icc_certificate_number, verification_reference, manufacturer_name, manufacturer_address, importer_name, importer_address, country_of_manufacture, brand and batch_number where read unambiguously. PNS standard numbers are never marking numbers.
    // BuiltMap<String, String> suggestions
    test('to test the property `suggestions`', () async {
      // TODO
    });

    // True when the suggested certificate_number exists in the active DTI-BPS register snapshot. Still a suggestion: the Vendor confirms it against the physical marking.
    // bool registerListed
    test('to test the property `registerListed`', () async {
      // TODO
    });

    // Always true. The Vendor must review and confirm values before a separate official-register comparison or Admin decision.
    // bool assistanceOnly
    test('to test the property `assistanceOnly`', () async {
      // TODO
    });

  });
}
