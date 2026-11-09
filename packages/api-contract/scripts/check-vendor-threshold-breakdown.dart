import 'package:materyalph_api_client/materyalph_api_client.dart';

void main() {
  for (final rate in [50, 0]) {
    final recorded = <String, Object?>{
      'id': '019a0f2a-9500-7000-8000-000000000001',
      'order_reference': 'ORD-SAMPLE',
      'assessed_at': '2026-10-02T10:00:00.000Z',
      'payment_principal_centavos': 10000,
      'buyer_processing_fees_centavos': 0,
      'collections_centavos': 10000,
      'assessed_payment_centavos': 42825,
      'delivery_centavos': 14275,
      'material_vat_centavos': 3059,
      'gross_basis_centavos': 25491,
      'rate_basis_points': rate,
      'withheld_centavos': rate == 0 ? 0 : 127,
    };
    final payment = standardSerializers.deserializeWith(
      AssessedOnlinePayment.serializer,
      recorded,
    )!;
    final encoded = standardSerializers.serializeWith(
      AssessedOnlinePayment.serializer,
      payment,
    )! as Map;
    for (final key in recorded.keys.where(
        (key) => key.endsWith('_centavos') || key == 'rate_basis_points')) {
      if (encoded[key] != recorded[key]) {
        throw StateError('The generated annual payment client changed $key.');
      }
    }
  }
  print(
      'Dart annual payment breakdown passed: original deductions, partial refund and zero relief preserved.');
}
