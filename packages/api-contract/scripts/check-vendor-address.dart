import 'package:materyalph_api_client/materyalph_api_client.dart';

void check(bool condition, String message) {
  if (!condition) throw StateError(message);
}

void main() {
  final address = VendorAddressSelection((builder) => builder
    ..province = 'Metro Manila'
    ..cityMunicipality = 'Quezon City'
    ..barangay = 'Alicia'
    ..street = '1 Test Street'
    ..postalCode = '1100'
    ..pinToken = 'fixture-pin');
  final wire = standardSerializers.serializeWith(
      VendorAddressSelection.serializer, address) as Map<String, Object?>;
  check(
      wire['city_municipality'] == 'Quezon City' &&
          wire['postal_code'] == '1100' &&
          wire['pin_token'] == 'fixture-pin',
      'Named address fields must use the API wire names');
  check(
      !wire.containsKey('province_code') &&
          !wire.containsKey('city_code') &&
          !wire.containsKey('psgc_code'),
      'Named addresses must not require codes');
  final restored = standardSerializers.deserializeWith(
      VendorAddressSelection.serializer, wire)!;
  check(
      restored.cityMunicipality == address.cityMunicipality &&
          restored.provinceCode == null,
      'Named addresses must round trip');
  print(
      'Vendor address contract passed: named address codecs without PSGC inputs.');
}
