import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for WithholdingThresholdCalculation
void main() {
  final instance = WithholdingThresholdCalculationBuilder();
  // TODO add properties to the builder and call build()

  group(WithholdingThresholdCalculation, () {
    // Number of POSTED merchant online-payment assessments included for this taxpayer and taxable year. Direct COD and In-Store cash records are excluded.
    // int assessedPayments
    test('to test the property `assessedPayments`', () async {
      // TODO
    });

    // Original online order principal in the included assessments, before refunds. Not the all-method, date-filtered Net sales figure.
    // int paymentPrincipalCentavos
    test('to test the property `paymentPrincipalCentavos`', () async {
      // TODO
    });

    // Buyer fees included in the assessed online collections. Payment principal plus these fees equals collections_centavos; Buyer fees are not sales revenue.
    // int buyerProcessingFeesCentavos
    test('to test the property `buyerProcessingFeesCentavos`', () async {
      // TODO
    });

    // int collectionsCentavos
    test('to test the property `collectionsCentavos`', () async {
      // TODO
    });

    // int refundsCentavos
    test('to test the property `refundsCentavos`', () async {
      // TODO
    });

    // int deliveryCentavos
    test('to test the property `deliveryCentavos`', () async {
      // TODO
    });

    // int materialVatCentavos
    test('to test the property `materialVatCentavos`', () async {
      // TODO
    });

    // int providerChargesCentavos
    test('to test the property `providerChargesCentavos`', () async {
      // TODO
    });

    // int grossBasisCentavos
    test('to test the property `grossBasisCentavos`', () async {
      // TODO
    });

    // int withheldCentavos
    test('to test the property `withheldCentavos`', () async {
      // TODO
    });

    // int assessedCashCentavos
    test('to test the property `assessedCashCentavos`', () async {
      // TODO
    });

    // Optional read-only preview for explaining the recorded withholding total. Null when concurrent source changes prevent a consistent preview; the recorded total is retained. Other stores remain aggregate-only.
    // WithholdingCalculationBreakdown withholdingBreakdown
    test('to test the property `withholdingBreakdown`', () async {
      // TODO
    });

  });
}
