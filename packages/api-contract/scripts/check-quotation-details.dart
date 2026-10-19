import 'package:materyalph_api_client/materyalph_api_client.dart';

void check(bool condition, String message) {
  if (!condition) throw StateError(message);
}

void main() {
  const lineJson = <String, Object?>{
    'variant_id': '019c6e27-e55b-73d1-87d8-4e01f1f75043',
    'quantity': '4.0000',
    'unit_price_centavos': 1700,
    'description': 'Quoted cement',
    'unit_code': 'bag',
    'tax_category': 'VAT_12',
    'source_price_version_id': 'price-version',
    'source_tax_version_id': 'tax-version',
  };
  final published = standardSerializers.deserializeWith(
    ChatQuotationLine.serializer,
    {
      ...lineJson,
      'brand': 'Quoted brand',
      'variant_label': '40 kg bag',
      'specifications': {
        'compressive_strength_mpa': '28',
        'cement_type': 'Type 1'
      },
    },
  )!;
  check(
      published.brand == 'Quoted brand' &&
          published.variantLabel == '40 kg bag',
      'Published brand and variant survive decoding');
  check(published.specifications?['compressive_strength_mpa'] == '28',
      'Technical specification values are retained');
  final encoded = standardSerializers.serializeWith(
      ChatQuotationLine.serializer, published) as Map<String, Object?>;
  check((encoded['specifications'] as Map)['cement_type'] == 'Type 1',
      'Technical details round trip without catalog lookups');
  final historical = standardSerializers.deserializeWith(
      ChatQuotationLine.serializer, lineJson)!;
  check(historical.brand == null && historical.specifications == null,
      'Older immutable versions remain readable');
  for (final empty in <Object>[<String, String>{}, <Object>[]]) {
    final line = standardSerializers.deserializeWith(
        ChatQuotationLine.serializer, {...lineJson, 'specifications': empty})!;
    check(line.specifications!.isEmpty,
        'Both PHP empty-array and empty-object specifications decode');
  }
  const moneyJson = <String, Object?>{
    'materials_payable_centavos': 90000,
    'materials_vat_centavos': 9643,
    'vendor_discount_centavos': 10000,
    'delivery_centavos': 20000,
    'nrpc_centavos': 5000,
    'commercial_total_centavos': 110000,
  };
  final money = standardSerializers.deserializeWith(
      ChatQuotationMoney.serializer,
      {...moneyJson, 'materials_gross_centavos': 100000})!;
  check(
      money.materialsGrossCentavos == 100000 &&
          money.materialsPayableCentavos == 90000,
      'Gross and net money are separate integer snapshot amounts');
  check(
      standardSerializers
              .deserializeWith(ChatQuotationMoney.serializer, moneyJson)!
              .materialsGrossCentavos ==
          null,
      'Historical totals do not require a gross subtotal');
  print(
      'Quotation details Dart codec passed: published specifications, empty PHP maps, historical versions and integer amounts.');
}
