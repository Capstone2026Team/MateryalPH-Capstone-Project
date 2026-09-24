import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for VendorVerificationDraft
void main() {
  final instance = VendorVerificationDraftBuilder();
  // TODO add properties to the builder and call build()

  group(VendorVerificationDraft, () {
    // Encrypted unvalidated form progress as a JSON object of field names to string arrays. Saving progress does not submit or update review records. Sensitive identity numbers are omitted on read and merged server-side on final validation.
    // String formState
    test('to test the property `formState`', () async {
      // TODO
    });

    // Workstream draft version; zero on first save. Send together with the required organization guard. Omission retains legacy behavior without draft-level comparison. A stale draft returns 409 STALE_VERSION; a stale organization returns 409 RESOURCE_VERSION_CONFLICT.
    // int draftLockVersion
    test('to test the property `draftLockVersion`', () async {
      // TODO
    });

    // int lockVersion
    test('to test the property `lockVersion`', () async {
      // TODO
    });

    // String businessType
    test('to test the property `businessType`', () async {
      // TODO
    });

    // String registeredName
    test('to test the property `registeredName`', () async {
      // TODO
    });

    // String legalBusinessName
    test('to test the property `legalBusinessName`', () async {
      // TODO
    });

    // String storeName
    test('to test the property `storeName`', () async {
      // TODO
    });

    // Date dateEstablished
    test('to test the property `dateEstablished`', () async {
      // TODO
    });

    // String storeEmail
    test('to test the property `storeEmail`', () async {
      // TODO
    });

    // String storePhone
    test('to test the property `storePhone`', () async {
      // TODO
    });

    // VendorVerificationDraftClassification classification
    test('to test the property `classification`', () async {
      // TODO
    });

    // New or changed addresses require province_code, city_code, psgc_code, street (2–200 characters), four-digit postal_code and canonical display names. source MANUAL is sufficient without geocoding or a token and stores null coordinates. Otherwise resolution_token from resolveVendorAddress is required. Client latitude and longitude are prohibited. Omit address to retain an existing record.
    // BuiltMap<String, JsonObject> address
    test('to test the property `address`', () async {
      // TODO
    });

    // VendorVerificationDraftRepresentative representative
    test('to test the property `representative`', () async {
      // TODO
    });

    // VendorVerificationDraftLegalIdentity legalIdentity
    test('to test the property `legalIdentity`', () async {
      // TODO
    });

    // VendorVerificationDraftTaxProfile taxProfile
    test('to test the property `taxProfile`', () async {
      // TODO
    });

  });
}
