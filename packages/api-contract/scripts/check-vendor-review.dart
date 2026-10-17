import 'package:materyalph_api_client/materyalph_api_client.dart';

void check(bool condition, String message) {
  if (!condition) throw StateError(message);
}

void main() {
  const product = <String, Object?>{
    'listing_id': '019c6e27-e55b-73d1-87d8-4e01f1f75043',
    'name': 'Purchased steel bar',
    'variant_label': null,
  };
  for (final inputProduct in <Map<String, Object?>?>[product, null]) {
    final detail = standardSerializers.deserializeWith(
      VendorReviewEnvelope.serializer,
      <String, Object?>{
        'data': <String, Object?>{
          'type': inputProduct == null ? 'VENDOR' : 'PRODUCT',
          'product': inputProduct,
          'display_name': 'Verified Buyer',
          'ratings': <String, Object?>{'product_quality': 4},
          'comment': 'Consistent quality.',
          'media': <Object?>[],
        },
        'meta': <String, Object?>{},
        'errors': <Object?>[],
      },
    )!;
    check(detail.data.product?.name == inputProduct?['name'],
        'Nullable purchased product must deserialize');
    check(detail.data.product?.variantLabel == null,
        'Nullable purchased variant must deserialize');
    final output = standardSerializers.serializeWith(
        VendorReviewEnvelope.serializer, detail) as Map<String, Object?>;
    final row = output['data']! as Map<String, Object?>;
    final savedProduct = row['product'] as Map<String, Object?>?;
    check(savedProduct?['listing_id'] == inputProduct?['listing_id'],
        'Product identity must round trip');
    check(savedProduct?['name'] == inputProduct?['name'],
        'Purchased product name must round trip');
  }

  for (final rated in <bool>[false, true]) {
    final summary = <String, Object?>{
      'count': rated ? 24 : 0,
      'average': rated ? 4.25 : null,
      'distribution': <Map<String, Object?>>[
        for (var stars = 5; stars >= 1; stars--)
          <String, Object?>{
            'stars': stars,
            'count': rated ? <int, int>{5: 12, 4: 6, 3: 6}[stars] ?? 0 : 0,
          },
      ],
    };
    final list = standardSerializers.deserializeWith(
      VendorReviewListEnvelope.serializer,
      <String, Object?>{
        'data': <Object?>[],
        'meta': <String, Object?>{
          'page': 1,
          'per_page': 20,
          'total': rated ? 24 : 0,
          'type': 'PRODUCT',
          'summary': summary,
        },
        'errors': <Object?>[],
      },
    )!;
    check(list.meta.summary!.count == summary['count'],
        'Summary count must survive independently of paginated data');
    check(list.meta.summary!.average == summary['average'],
        'Empty and fractional numeric averages must deserialize');
    check(list.meta.summary!.distribution.length == 5,
        'All five star buckets must deserialize');
    final output = standardSerializers.serializeWith(
        VendorReviewListEnvelope.serializer, list) as Map<String, Object?>;
    final meta = output['meta']! as Map<String, Object?>;
    final savedSummary = meta['summary']! as Map<String, Object?>;
    check(savedSummary['average'] == summary['average'],
        'Numeric and null averages must round trip');
    check((savedSummary['distribution']! as List<Object?>).length == 5,
        'Five star distribution must round trip');
  }
  print('Dart Vendor review contract passed: nullable purchase snapshots, '
      'empty and fractional rating summaries, and all five star buckets.');
}
