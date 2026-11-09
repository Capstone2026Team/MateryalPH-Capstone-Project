import 'package:materyalph_api_client/materyalph_api_client.dart';

void check(bool condition, String message) {
  if (!condition) throw StateError(message);
}

void main() {
  const rated = <String, Object?>{
    'listing_id': '0192a000-0000-7000-8000-000000000001',
    'name': 'Sample cement',
    'category': 'Cement',
    'average': '4.80',
    'count': 12,
  };
  const delta = <String, Object?>{
    'value': 0,
    'previous': 0,
    'change_percent': null,
  };
  final base = <String, Object?>{
    'generated_at': '2026-11-06T03:00:00Z',
    'period': {'days': 30, 'from': '2026-10-08', 'to': '2026-11-06', 'timezone': 'Asia/Manila'},
    'access': {'sales_value': false},
    'definitions': <String, String>{},
    'tracking': {'views_since': null},
    'kpis': {
      'views': delta, 'viewers': delta, 'orders': delta,
      'products_viewed': {'value': 0, 'total': 0},
      'conversion': {'percent': null, 'numerator': 0, 'denominator': 0},
      'value_centavos': null,
    },
    'series': <Object?>[],
    'forecast': {
      'horizon_days': 7,
      'views': {'state': 'INSUFFICIENT_DATA', 'direction': 'UNKNOWN', 'observed_days': 0, 'points': <Object?>[], 'anomalies': <Object?>[]},
    },
    'top_selling': <Object?>[], 'top_performing': <Object?>[], 'most_viewed': <Object?>[],
    'categories': <Object?>[], 'suggestions': <Object?>[],
    'segments': {'state': 'INSUFFICIENT_DATA', 'features': <Object?>[], 'segments': <Object?>[], 'points': <Object?>[]},
    'basket_rules': {'baskets': 0, 'rules': <Object?>[], 'window_days': 90},
    'products': {'items': <Object?>[], 'meta': {'page': 1, 'per_page': 20, 'total': 0, 'last_page': 1, 'sort': 'views'}},
  };
  for (final input in <Map<String, Object?>>[
    {...base, 'top_rated': [rated]},
    {...base, 'top_rated': <Object?>[]},
    {...base, 'top_rated': null},
    base,
  ]) {
    final value = standardSerializers.deserializeWith(VendorProductAnalytics.serializer, input)!;
    final source = input['top_rated'] as List<Object?>?;
    check(value.topRated?.length == source?.length, 'Rated, empty, null and omitted rankings must deserialize distinctly');
    if (source?.isNotEmpty ?? false) {
      check(value.topRated!.first.average == '4.80', 'Product average retains its decimal precision');
      check(value.topRated!.first.count == 12, 'Rating count survives');
      check(value.topRated!.first.listingId == rated['listing_id'], 'Listing identity survives');
      final output = standardSerializers.serializeWith(VendorProductAnalytics.serializer, value) as Map<String, Object?>;
      final row = (output['top_rated']! as List<Object?>).first as Map<String, Object?>;
      check(row['average'] == rated['average'] && row['count'] == rated['count'], 'Rating facts round trip');
    }
  }
  print('Dart Product Analytics quality contract passed: ranked, empty, null and omitted products, decimal averages and counts.');
}
