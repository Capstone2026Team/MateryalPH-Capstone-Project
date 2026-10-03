import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for VendorFinanceApi
void main() {
  final instance = MateryalphApiClient().getVendorFinanceApi();

  group(VendorFinanceApi, () {
    // Owner, Manager or Store Staff approve paying the uncollected physical balance online (ORDER_BALANCE_PAYMENT).
    //
    //Future<FinanceActionResultEnvelope> approveVendorOnlineBalance(String orderId, String idempotencyKey) async
    test('test approveVendorOnlineBalance', () async {
      // TODO
    });

    // Owner-only audited CSV export: Internal Operational Report — Not a Tax Invoice.
    //
    //Future<String> exportVendorTransactions(String tab) async
    test('test exportVendorTransactions', () async {
      // TODO
    });

    // Owner-only FIN-11 Earnings with separate sales, collections, charges, simulated CWT and commission.
    //
    //Future<VendorEarningsEnvelope> getVendorEarnings() async
    test('test getVendorEarnings', () async {
      // TODO
    });

    // Owner-only platform-fee payment attempt.
    //
    //Future<PaymentAttemptEnvelope> getVendorFeePayment(String paymentId) async
    test('test getVendorFeePayment', () async {
      // TODO
    });

    // Owner-only issued commission statement with lines, payments and payable channels (platform absorbs its bill processing charge).
    //
    //Future<FeeStatementDetailEnvelope> getVendorFeeStatement(String statementId) async
    test('test getVendorFeeStatement', () async {
      // TODO
    });

    // Owner-only. Separate Xendit connection, Vendor Tax Profile summary, withholding arrangement (Production assignment unconfirmed), FIN-04A threshold panel, Commission Terms, online channels, physical payments and refund capability. Every simulated figure is DEMO.
    //
    //Future<VendorFinanceOverviewEnvelope> getVendorFinanceOverview() async
    test('test getVendorFinanceOverview', () async {
      // TODO
    });

    // Owner-only read-only Transaction History (former Wallet label). No balance, wallet or escrow.
    //
    //Future<FinanceTransactionListEnvelope> listVendorTransactions({ String tab, int page }) async
    test('test listVendorTransactions', () async {
      // TODO
    });

    // Owner-only PLATFORM_FEE_PAYMENT to the platform TEST account, 45-minute attempt, optional installment amount. No auto debit or split. Open attempts are reconciled first.
    //
    //Future<PaymentAttemptEnvelope> payVendorFeeStatement(String statementId, String idempotencyKey, StatementPaymentRequest statementPaymentRequest) async
    test('test payVendorFeeStatement', () async {
      // TODO
    });

    // Owner, Store Manager or Store Staff (payments.record_physical) record cash received with private evidence. Partial collection leaves an outstanding balance; never above it; never an online success.
    //
    //Future<PhysicalPaymentSummaryEnvelope> recordVendorPhysicalPayment(String orderId, String idempotencyKey, int amountCentavos, MultipartFile file, { DateTime receivedAt, String note }) async
    test('test recordVendorPhysicalPayment', () async {
      // TODO
    });

    // Owner-only authoritative status check.
    //
    //Future<PaymentAttemptEnvelope> refreshVendorFeePayment(String paymentId) async
    test('test refreshVendorFeePayment', () async {
      // TODO
    });

    // Owner-only. Enable Cash on Delivery (Site Delivery) or In-Store Payment (Self-Pickup) for future orders; both default off. lock_version 0 before the first save.
    //
    //Future<PhysicalPaymentSettingsEnvelope> updateVendorPhysicalPayments(PhysicalPaymentSettingsUpdate physicalPaymentSettingsUpdate) async
    test('test updateVendorPhysicalPayments', () async {
      // TODO
    });

  });
}
