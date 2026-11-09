import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for AssessedOnlinePayment
void main() {
  final instance = AssessedOnlinePaymentBuilder();
  // TODO add properties to the builder and call build()

  group(AssessedOnlinePayment, () {
    // Assessment record ID, not a provider identifier.
    // String id
    test('to test the property `id`', () async {
      // TODO
    });

    // String orderReference
    test('to test the property `orderReference`', () async {
      // TODO
    });

    // DateTime assessedAt
    test('to test the property `assessedAt`', () async {
      // TODO
    });

    // Original posted tax basis; later refunds do not rewrite it.
    // int grossBasisCentavos
    test('to test the property `grossBasisCentavos`', () async {
      // TODO
    });

    // Recorded effective withholding rate in basis points; 50 is 0.5 percent, 0 is recorded relief.
    // int rateBasisPoints
    test('to test the property `rateBasisPoints`', () async {
      // TODO
    });

    // Original tax amount rounded half-up per assessment; never recomputed from retained principal or an annual basis.
    // int withheldCentavos
    test('to test the property `withheldCentavos`', () async {
      // TODO
    });

    // Original assessment collection minus its recorded pre-assessment refunds and provider charge, before delivery and material VAT exclusions. Matches the annual tax-basis calculation's Online payments line; later refunds do not change this amount.
    // int assessedPaymentCentavos
    test('to test the property `assessedPaymentCentavos`', () async {
      // TODO
    });

    // Separately billed delivery excluded in the original posted tax assessment.
    // int deliveryCentavos
    test('to test the property `deliveryCentavos`', () async {
      // TODO
    });

    // Included material VAT excluded in the original posted tax assessment.
    // int materialVatCentavos
    test('to test the property `materialVatCentavos`', () async {
      // TODO
    });

    // int paymentPrincipalCentavos
    test('to test the property `paymentPrincipalCentavos`', () async {
      // TODO
    });

    // int buyerProcessingFeesCentavos
    test('to test the property `buyerProcessingFeesCentavos`', () async {
      // TODO
    });

    // int collectionsCentavos
    test('to test the property `collectionsCentavos`', () async {
      // TODO
    });

  });
}
