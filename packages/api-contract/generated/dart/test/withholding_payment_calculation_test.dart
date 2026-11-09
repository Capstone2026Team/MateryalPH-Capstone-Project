import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for WithholdingPaymentCalculation
void main() {
  final instance = WithholdingPaymentCalculationBuilder();
  // TODO add properties to the builder and call build()

  group(WithholdingPaymentCalculation, () {
    // String id
    test('to test the property `id`', () async {
      // TODO
    });

    // String orderReference
    test('to test the property `orderReference`', () async {
      // TODO
    });

    // int grossBasisCentavos
    test('to test the property `grossBasisCentavos`', () async {
      // TODO
    });

    // Saved effective rate. 50 basis points means 0.5%; zero may reflect approved relief.
    // int rateBasisPoints
    test('to test the property `rateBasisPoints`', () async {
      // TODO
    });

    // Original tax amount rounded half-up per assessment; never recomputed after later refunds.
    // int withheldCentavos
    test('to test the property `withheldCentavos`', () async {
      // TODO
    });

  });
}
