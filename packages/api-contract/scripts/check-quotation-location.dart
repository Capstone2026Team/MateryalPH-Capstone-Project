import 'package:materyalph_api_client/materyalph_api_client.dart';

void check(bool condition, String message) {
  if (!condition) throw StateError(message);
}

void main() {
  final selections = <Map<String, Object>>[
    {'query': 'Buyer-confirmed street, Manila'},
    {'latitude': 14.65, 'longitude': 121.02},
    {'address_id': '019a0000-0000-7000-8000-000000000001'},
  ];
  for (final selection in selections) {
    final value = standardSerializers.deserializeWith(
      QuotationLocationSearch.serializer, selection,
    )!;
    final encoded = standardSerializers.serializeWith(
      QuotationLocationSearch.serializer, value,
    ) as Map;
    check(encoded.length == selection.length, 'Only the selected lookup mode is encoded');
    for (final entry in selection.entries) {
      check(encoded[entry.key] == entry.value, 'Preserve ${entry.key} on the wire');
    }
  }
  final location = standardSerializers.deserializeWith(QuotationLocation.serializer, {
    'id': '019a0000-0000-7000-8000-000000000001',
    'formatted_address': 'Pinned delivery gate, Manila',
    'latitude': 14.65,
    'longitude': 121.02,
  })!;
  check(location.latitude == 14.65 && location.longitude == 121.02, 'Resolved coordinates position the map pin');
  check(location.formattedAddress == 'Pinned delivery gate, Manila', 'Resolved address stays reviewable');
  print('Quotation location codec passed: address search, map pin and scoped saved location.');
}
