import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for VendorDashboardSeriesPoint
void main() {
  final instance = VendorDashboardSeriesPointBuilder();
  // TODO add properties to the builder and call build()

  group(VendorDashboardSeriesPoint, () {
    // Date date
    test('to test the property `date`', () async {
      // TODO
    });

    // int orders
    test('to test the property `orders`', () async {
      // TODO
    });

    // int orderRequests
    test('to test the property `orderRequests`', () async {
      // TODO
    });

    // num ordersAverage
    test('to test the property `ordersAverage`', () async {
      // TODO
    });

    // int grossSalesCentavos
    test('to test the property `grossSalesCentavos`', () async {
      // TODO
    });

    // Displayed as Earnings. Gross sales less completed online refund principal, confirmed physical reimbursements and cancelled-order value not already refunded. Before commission, other charges and business costs; not profit. Null without finance.view.
    // int netSalesCentavos
    test('to test the property `netSalesCentavos`', () async {
      // TODO
    });

    // Completed online refund principal and confirmed physical reimbursements deducted from this store's orders first confirmed on this Asia/Manila day, including cancellation refunds, capped at each confirmed sale value. Excludes Buyer processing fees, late-capture compensation and pending or failed refunds. Null without finance.view. Not grouped by refund payout date.
    // int refundsCentavos
    test('to test the property `refundsCentavos`', () async {
      // TODO
    });

    // Cancelled confirmed order value not already included in refunds_centavos, grouped by first confirmation day. Gross sales minus refunds minus these other cancellation deductions equals net sales (displayed as Earnings). Null without finance.view.
    // int cancellationDeductionsCentavos
    test('to test the property `cancellationDeductionsCentavos`', () async {
      // TODO
    });

    // int salesAverageCentavos
    test('to test the property `salesAverageCentavos`', () async {
      // TODO
    });

  });
}
