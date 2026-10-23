import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for CommissionTrendPoint
void main() {
  final instance = CommissionTrendPointBuilder();
  // TODO add properties to the builder and call build()

  group(CommissionTrendPoint, () {
    // Asia/Manila day, or month start when the trend is monthly.
    // Date period
    test('to test the property `period`', () async {
      // TODO
    });

    // int earnedCentavos
    test('to test the property `earnedCentavos`', () async {
      // TODO
    });

    // int creditsCentavos
    test('to test the property `creditsCentavos`', () async {
      // TODO
    });

    // int collectedCentavos
    test('to test the property `collectedCentavos`', () async {
      // TODO
    });

    // int refundedCentavos
    test('to test the property `refundedCentavos`', () async {
      // TODO
    });

    // Posted fee revenue net of credits and fee VAT, less platform commission payment processing expense. Can be negative in a refund period.
    // int netEarningsCentavos
    test('to test the property `netEarningsCentavos`', () async {
      // TODO
    });

    // Gross merchandise value of orders confirmed in the period (Vendor money, never platform revenue).
    // int gmvCentavos
    test('to test the property `gmvCentavos`', () async {
      // TODO
    });

    // Verified online Buyer payments plus recorded Cash on Delivery and In-Store cash, received by Vendors.
    // int buyerPaymentsCentavos
    test('to test the property `buyerPaymentsCentavos`', () async {
      // TODO
    });

    // Confirmed online refunds and cash reimbursements to Buyers.
    // int buyerRefundsCentavos
    test('to test the property `buyerRefundsCentavos`', () async {
      // TODO
    });

  });
}
