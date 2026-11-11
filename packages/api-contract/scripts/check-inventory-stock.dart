import 'package:materyalph_api_client/materyalph_api_client.dart';

void check(bool condition, String message) {
  if (!condition) throw StateError(message);
}

void main() {
  final stock =
      standardSerializers.deserializeWith(VendorDashboardStock.serializer, {
    'variants': 19,
    'active': 7,
    'inactive': 12,
    'in_stock': 19,
    'limited_stock': 0,
    'out_of_stock': 0,
    'attention': <Object?>[],
  })!;
  check(stock.active + stock.inactive == stock.variants,
      'Listing status partitions the same inventory variants');
  check(stock.inStock == 19 && stock.inactive == 12,
      'Available stock and inactive listings stay independent');
  final stockJson = standardSerializers.serializeWith(
      VendorDashboardStock.serializer, stock) as Map<String, Object?>;
  check(stockJson['active'] == 7 && stockJson['inactive'] == 12,
      'Active and inactive counts round trip');

  final row = standardSerializers.deserializeWith(InventoryRow.serializer, {
    'listing_variant_id': 'v1',
    'listing_id': 'l1',
    'listing_name': 'Sample cement',
    'listing_status': 'TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED',
    'sku': 'CEM-40',
    'unit_code': 'BAG',
    'lock_version': 4,
    'inventory': null,
    'public_label': 'OUT_OF_STOCK',
    'price': null,
    'stock_confirmation': {'state': 'CONFIRMED'},
    'listing_confirmation': {'state': 'OVERDUE'},
    'listing_visibility_blockers': [
      'Confirm every active variant.',
      'Upload a product photo.'
    ],
    'comparability': {'status': 'NOT_YET_COMPARABLE', 'rule_version': 'test'},
    'auto_accept': {
      'status': 'DISABLED',
      'enabled': false,
      'paused': false,
      'allotment_quantity': '0',
      'remaining_allotment_quantity': '0',
      'current_version': 0,
      'lock_version': 0
    },
  })!;
  check(row.listingVisibilityBlockers.length == 2,
      'Private visibility reasons survive decoding');
  final rowJson = standardSerializers.serializeWith(
      InventoryRow.serializer, row) as Map<String, Object?>;
  check((rowJson['listing_visibility_blockers'] as List<Object?>).length == 2,
      'Visibility reasons round trip');
  print(
      'Dart inventory stock contract passed: independent status counts and listing visibility reasons.');
}
