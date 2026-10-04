import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for VendorInvoicesApi
void main() {
  final instance = MateryalphApiClient().getVendorInvoicesApi();

  group(VendorInvoicesApi, () {
    // invoices.upload. Explain a reconciliation difference.
    //
    //Future<VendorOrderInvoicesEnvelope> explainVendorInvoiceDifference(String orderId, String recordId, String idempotencyKey, InvoiceExplanationRequest invoiceExplanationRequest) async
    test('test explainVendorInvoiceDifference', () async {
      // TODO
    });

    // Owner, Store Manager, Store Staff, or the assigned Fulfillment Staff; signed link; recorded.
    //
    //Future<Uint8List> getVendorInvoiceFile(String recordId, int expires, String signature) async
    test('test getVendorInvoiceFile', () async {
      // TODO
    });

    // invoices.view. Customer Service sees status and metadata only; the full Buyer TIN only for roles that upload.
    //
    //Future<VendorOrderInvoicesEnvelope> getVendorOrderInvoices(String orderId) async
    test('test getVendorOrderInvoices', () async {
      // TODO
    });

    // invoices.view. Open requests, orders without an invoice copy yet, uploaded records and reconciliation items. Never Earnings or other protected finance.
    //
    //Future<InvoiceLogEnvelope> listVendorInvoices({ String view, int page }) async
    test('test listVendorInvoices', () async {
      // TODO
    });

    // invoices.upload (Owner, Store Manager, Store Staff). Validates type and issuer; a total or VAT difference opens INVOICE_RECONCILIATION_REQUIRED without changing the accepted Buyer total.
    //
    //Future<VendorOrderInvoicesEnvelope> uploadVendorInvoice(String orderId, String idempotencyKey, String invoiceType, String issuerName, String invoiceNumber, Date issuedOn, int amountCentavos, String sourceSystem, String invoicingMethod, MultipartFile file, { int vatCentavos, int vatExemptCentavos, int zeroRatedCentavos, BuiltList<String> relatedLineIds, String amendsInvoiceRecordId, String invoiceRequestId }) async
    test('test uploadVendorInvoice', () async {
      // TODO
    });

  });
}
