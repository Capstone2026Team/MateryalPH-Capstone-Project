import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for VendorEarnings
void main() {
  final instance = VendorEarningsBuilder();
  // TODO add properties to the builder and call build()

  group(VendorEarnings, () {
    // bool demo
    test('to test the property `demo`', () async {
      // TODO
    });

    // String environment
    test('to test the property `environment`', () async {
      // TODO
    });

    // String notice
    test('to test the property `notice`', () async {
      // TODO
    });

    // Latest financial-snapshot total (materials after vendor discount, VAT included, plus delivery) of orders accepted in the range, leaving out declined, expired, cancelled and unconfirmed orders and orders whose payment was fully refunded. The Dashboard's Product sales value uses the same rule.
    // int commercialSalesCentavos
    test('to test the property `commercialSalesCentavos`', () async {
      // TODO
    });

    // int includedVatCentavos
    test('to test the property `includedVatCentavos`', () async {
      // TODO
    });

    // Verified online principal less confirmed refunded principal, attributed to the original payment date; fully refunded principal contributes zero.
    // int onlineCollectionsCentavos
    test('to test the property `onlineCollectionsCentavos`', () async {
      // TODO
    });

    // Confirmed online refunds, including their refunded Buyer fees, attributed to the original payment date. Pending and failed refunds do not reduce collections.
    // int onlineRefundsCentavos
    test('to test the property `onlineRefundsCentavos`', () async {
      // TODO
    });

    // int buyerProcessingFeesCentavos
    test('to test the property `buyerProcessingFeesCentavos`', () async {
      // TODO
    });

    // int physicalCollectionsCentavos
    test('to test the property `physicalCollectionsCentavos`', () async {
      // TODO
    });

    // int providerChargesCentavos
    test('to test the property `providerChargesCentavos`', () async {
      // TODO
    });

    // int simulatedCwtCentavos
    test('to test the property `simulatedCwtCentavos`', () async {
      // TODO
    });

    // int estimatedRemittanceCashCentavos
    test('to test the property `estimatedRemittanceCashCentavos`', () async {
      // TODO
    });

    // Original collected amounts, including Buyer processing fees, of POSTED assessments and confirmed fully refunded VOIDED assessments in the selected assessment-date range. Fully refunded amounts appear in both collections and refunds and cancel out; their provider charge, CWT and net cash remain zero.
    // int remittanceCollectionsCentavos
    test('to test the property `remittanceCollectionsCentavos`', () async {
      // TODO
    });

    // Refund allocations already applied to remittances plus subsequent confirmed full and partial refunds, counted once and allocated up to the original collection. Includes fully refunded VOIDED assessments, so refund visibility is preserved without counting refunded money as earnings. Pending and failed refunds do not reduce cash. Uses the same assessment-date range as estimated_remittance_cash_centavos.
    // int remittanceRefundsCentavos
    test('to test the property `remittanceRefundsCentavos`', () async {
      // TODO
    });

    // Signed commission earnings less approved credits, by earned_at and approved_at respectively; shared with Admin Finance. Can be negative in a credit-only period.
    // int earnedCommissionCentavos
    test('to test the property `earnedCommissionCentavos`', () async {
      // TODO
    });

    // int estimatedCommissionCentavos
    test('to test the property `estimatedCommissionCentavos`', () async {
      // TODO
    });

    // int unpaidStatementsCentavos
    test('to test the property `unpaidStatementsCentavos`', () async {
      // TODO
    });

    // VendorEarningsBreakdown breakdown
    test('to test the property `breakdown`', () async {
      // TODO
    });

    // VendorEarningsProducts products
    test('to test the property `products`', () async {
      // TODO
    });

    // VendorEarningsTrend trend
    test('to test the property `trend`', () async {
      // TODO
    });

  });
}
