import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for BuyerPaymentsApi
void main() {
  final instance = MateryalphApiClient().getBuyerPaymentsApi();

  group(BuyerPaymentsApi, () {
    // Acknowledge one Vendor-recorded direct collection. Set once; never an online payment confirmation.
    //
    //Future<PhysicalPaymentSummaryEnvelope> acknowledgePhysicalPayment(String orderId, String recordId, String idempotencyKey) async
    test('test acknowledgePhysicalPayment', () async {
      // TODO
    });

    // Opens one provider session for the due purpose through the reconciled Vendor TEST sub-account. expected_total_centavos must equal the server total (409 PAYMENT_AMOUNT_CHANGED). An open attempt blocks another charge (409 PAYMENT_ATTEMPT_IN_PROGRESS). Payment and provisioning idempotency are separate scopes.
    //
    //Future<PaymentAttemptEnvelope> createBuyerPayment(String orderId, String idempotencyKey, PaymentCreateRequest paymentCreateRequest) async
    test('test createBuyerPayment', () async {
      // TODO
    });

    // The Buyer's own attempt. Pending until a verified event or authoritative reconciliation.
    //
    //Future<PaymentAttemptEnvelope> getBuyerPayment(String paymentId) async
    test('test getBuyerPayment', () async {
      // TODO
    });

    // Server-computed purpose, principal and per-channel Payment Processing Fee (versioned DEMO schedule, grossed up, no markup). Refund-incompatible channels are listed as unavailable with a reason.
    //
    //Future<PaymentOptionsEnvelope> getBuyerPaymentOptions(String orderId) async
    test('test getBuyerPaymentOptions', () async {
      // TODO
    });

    // Asks the provider for the authoritative session state; a provider outage keeps the attempt pending.
    //
    //Future<PaymentAttemptEnvelope> refreshBuyerPayment(String paymentId) async
    test('test refreshBuyerPayment', () async {
      // TODO
    });

  });
}
