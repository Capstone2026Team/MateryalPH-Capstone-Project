import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for PaymentWebhooksApi
void main() {
  final instance = MateryalphApiClient().getPaymentWebhooksApi();

  group(PaymentWebhooksApi, () {
    // Fast inbox. Verifies x-callback-token in constant time (Xendit documents no HMAC signature header), stores the raw event once by webhook-id, acknowledges, then processes asynchronously. Processing re-reads the session authoritatively and checks identifier, reference, amount, currency, account and transition before anything is PAID. Forged, duplicate, reordered, mismatched or unknown events never create a paid order.
    //
    //Future<PaymentWebhookAckEnvelope> receiveXenditPaymentWebhook(String xCallbackToken, PaymentWebhookPayload paymentWebhookPayload, { String webhookId }) async
    test('test receiveXenditPaymentWebhook', () async {
      // TODO
    });

    // Browser return page after the hosted payment page. Always renders Pending with a deep link back to the app; never reads or changes payment state.
    //
    //Future<String> showPaymentReturnPage({ String attempt }) async
    test('test showPaymentReturnPage', () async {
      // TODO
    });

  });
}
