import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for DiscoverySearchRequest
void main() {
  final instance = DiscoverySearchRequestBuilder();
  // TODO add properties to the builder and call build()

  group(DiscoverySearchRequest, () {
    // String locationId
    test('to test the property `locationId`', () async {
      // TODO
    });

    // double latitude
    test('to test the property `latitude`', () async {
      // TODO
    });

    // double longitude
    test('to test the property `longitude`', () async {
      // TODO
    });

    // String originSource
    test('to test the property `originSource`', () async {
      // TODO
    });

    // Must be one of 5, 10, 20, 30, 40 or 50; otherwise 422 RADIUS_UNSUPPORTED.
    // int radiusKm
    test('to test the property `radiusKm`', () async {
      // TODO
    });

    // bool includeVerified
    test('to test the property `includeVerified`', () async {
      // TODO
    });

    // bool includeDirectory
    test('to test the property `includeDirectory`', () async {
      // TODO
    });

    // bool favoritesOnly
    test('to test the property `favoritesOnly`', () async {
      // TODO
    });

    // WHOLESALER_DISTRIBUTOR, RETAIL_HARDWARE_STORE, SPECIALIZED_SUPPLIER or OTHER. Tier-specific filters hide Directory Suppliers.
    // String supplierType
    test('to test the property `supplierType`', () async {
      // TODO
    });

    // String categoryId
    test('to test the property `categoryId`', () async {
      // TODO
    });

    // int page
    test('to test the property `page`', () async {
      // TODO
    });

    // int perPage
    test('to test the property `perPage`', () async {
      // TODO
    });

  });
}
