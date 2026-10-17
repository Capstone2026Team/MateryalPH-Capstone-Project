import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for BuyerInvoicesApi
void main() {
  final instance = MateryalphApiClient().getBuyerInvoicesApi();

  group(BuyerInvoicesApi, () {
    // Return an uploaded document for correction, or close the request.
    //
    //Future<BuyerOrderInvoicesEnvelope> answerBuyerInvoiceRequest(String orderId, String requestId, String idempotencyKey, InvoiceRequestAnswer invoiceRequestAnswer) async
    test('test answerBuyerInvoiceRequest', () async {
      // TODO
    });

    // Invoice copy behind a signed link; the download is recorded.
    //
    //Future<Uint8List> getBuyerInvoiceFile(String recordId, int expires, String signature) async
    test('test getBuyerInvoiceFile', () async {
      // TODO
    });

    // Invoice copies as soon as the Vendor uploads them (not only after completion), requests with their three-business-day target and MateryalPH documents labelled not a tax invoice.
    //
    //Future<BuyerOrderInvoicesEnvelope> getBuyerOrderInvoices(String orderId) async
    test('test getBuyerOrderInvoices', () async {
      // TODO
    });

    // Request a copy or a correction. The service target never extends the Vendor's legal issuance deadline.
    //
    //Future<BuyerOrderInvoicesEnvelope> requestBuyerInvoice(String orderId, String idempotencyKey, InvoiceRequestCreate invoiceRequestCreate) async
    test('test requestBuyerInvoice', () async {
      // TODO
    });

    // Billing name, address and optional TIN for the Vendor's invoice. Stale lock_version returns 409.
    //
    //Future<BuyerOrderInvoicesEnvelope> saveBuyerInvoiceDetails(String orderId, InvoiceBillingDetailsRequest invoiceBillingDetailsRequest) async
    test('test saveBuyerInvoiceDetails', () async {
      // TODO
    });

  });
}
