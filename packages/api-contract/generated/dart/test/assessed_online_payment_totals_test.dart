import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for AssessedOnlinePaymentTotals
void main() {
  final instance = AssessedOnlinePaymentTotalsBuilder();
  // TODO add properties to the builder and call build()

  group(AssessedOnlinePaymentTotals, () {
    // int assessedPayments
    test('to test the property `assessedPayments`', () async {
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

    // Sum of original per-assessment withholding for retained payments in this scope, independent of pagination. Fully refunded payments are omitted even if their posted tax remains in annual tax history.
    // int withheldCentavos
    test('to test the property `withheldCentavos`', () async {
      // TODO
    });

  });
}
