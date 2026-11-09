import 'package:materyalph_api_client/materyalph_api_client.dart';

void main() {
  final totals = <String, Object?>{
    'assessed_payments': 1,
    'payment_principal_centavos': 28550,
    'buyer_processing_fees_centavos': 755,
    'collections_centavos': 29305,
    'withheld_centavos': 127,
  };
  final wire = <String, Object?>{
    'taxable_year': 2026,
    'totals': totals,
    'other_store_totals': null,
    'payments': [
      {
        'id': 'sample-assessment',
        'order_reference': 'ORD-SAMPLE',
        'assessed_at': '2026-10-02T10:00:00.000Z',
        'payment_principal_centavos': 28550,
        'buyer_processing_fees_centavos': 755,
        'collections_centavos': 29305,
        'gross_basis_centavos': 25491,
        'rate_basis_points': 50,
        'withheld_centavos': 127,
      }
    ],
  };
  final data = standardSerializers.deserializeWith(
      VendorThresholdPayments.serializer, wire)!;
  final payment = data.payments.single;
  if (data.otherStoreTotals != null ||
      payment.grossBasisCentavos != 25491 ||
      payment.rateBasisPoints != 50 ||
      payment.withheldCentavos != data.totals.withheldCentavos ||
      payment.paymentPrincipalCentavos + payment.buyerProcessingFeesCentavos !=
          data.totals.collectionsCentavos) {
    throw StateError('Annual payment sources must preserve centavo amounts.');
  }
  final withOther = standardSerializers.deserializeWith(
      VendorThresholdPayments.serializer,
      {...wire, 'other_store_totals': totals})!;
  if (withOther.otherStoreTotals?.assessedPayments != 1 ||
      withOther.otherStoreTotals?.withheldCentavos != 127) {
    throw StateError('Other stores must remain aggregate-only.');
  }
  final restored = standardSerializers.serializeWith(
      VendorThresholdPayments.serializer, data) as Map<String, Object?>;
  if (restored['taxable_year'] != 2026 ||
      (restored['totals'] as Map)['collections_centavos'] != 29305) {
    throw StateError('Annual source totals must survive JSON serialization.');
  }
  final withholdingWire = <String, Object?>{
    'payments': ['A', 'B', 'C', 'D'].map((id) => {
      'id': id,
      'order_reference': 'ORD-$id',
      'gross_basis_centavos': 25491,
      'rate_basis_points': 50,
      'withheld_centavos': 127,
    }).toList(),
    'remaining_payments': 0,
    'remaining_basis_centavos': 0,
    'remaining_withheld_centavos': 0,
  };
  final withholding = standardSerializers.deserializeWith(
      WithholdingCalculationBreakdown.serializer, withholdingWire)!;
  if (withholding.payments.first.rateBasisPoints != 50 ||
      withholding.payments.first.grossBasisCentavos != 25491 ||
      withholding.payments.fold<int>(withholding.remainingWithheldCentavos,
          (sum, payment) => sum + payment.withheldCentavos) != 508) {
    throw StateError('Recorded per-payment tax rounding must be preserved.');
  }
  final withholdingRestored = standardSerializers.serializeWith(
      WithholdingCalculationBreakdown.serializer, withholding) as Map<String, Object?>;
  if ((withholdingRestored['payments'] as List).length != 4 ||
      withholdingRestored['remaining_withheld_centavos'] != 0) {
    throw StateError('Withholding calculations must survive JSON serialization.');
  }
  print('Dart annual payment-source and withholding calculation contract checks passed.');
}
