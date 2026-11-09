import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for VendorInvoicesApi
void main() {
  final instance = MateryalphApiClient().getVendorInvoicesApi();

  group(VendorInvoicesApi, () {
    // invoices.upload. Authorized, short-lived private draft preview. Reauthorizes the current Vendor role, store, order and current file. A replaced file link fails closed. Never available to Buyers.
    //
    //Future<Uint8List> downloadVendorInvoiceDraft(String draftId, String fileId, int expires, String signature) async
    test('test downloadVendorInvoiceDraft', () async {
      // TODO
    });

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

    // invoices.view. Returns the store invoice defaults and current lock_version. Invoice dates default to today in Asia/Manila.
    //
    //Future<VendorInvoicePresetEnvelope> getVendorInvoicePreset() async
    test('test getVendorInvoicePreset', () async {
      // TODO
    });

    // invoices.view. Customer Service sees status and metadata only; the full Buyer TIN only for roles that upload. can_upload permits a private linked correction of the latest sent version after a Buyer return, correction request or unresolved amount/VAT mismatch, including an explained difference. Sent document fields and files remain immutable.
    //
    //Future<VendorOrderInvoicesEnvelope> getVendorOrderInvoices(String orderId) async
    test('test getVendorOrderInvoices', () async {
      // TODO
    });

    // invoices.view. REQUESTS contains only requested first copies awaiting Send; uploaded and downloaded requests are excluded. RECONCILIATION contains the latest sent version per order with an amount/VAT mismatch (including explained differences), a Buyer return or a pending correction request. Earlier versions remain in RECORDS. Counts use these same rules before date filtering. Never Earnings or other protected finance. Every Vendor list row includes its authorized order_id for opening the order invoice details.
    //
    //Future<InvoiceLogEnvelope> listVendorInvoices({ String view, int page, Date from, Date to }) async
    test('test listVendorInvoices', () async {
      // TODO
    });

    // invoices.upload. Saves the store invoice defaults with current lock_version and Idempotency-Key. Presets apply to future preparations only; sent records never change. Invoice dates default to today in Asia/Manila, while invoice numbers and amounts stay document-specific.
    //
    //Future<VendorInvoicePresetEnvelope> saveVendorInvoicePreset(String idempotencyKey, InvoicePresetInput invoicePresetInput) async
    test('test saveVendorInvoicePreset', () async {
      // TODO
    });

    // invoices.upload. Sends the saved, clean draft exactly once, creates an immutable invoice version, fulfills the applicable Buyer request and notifies the Buyer after commit. The Buyer email includes the exact uploaded invoice file and a summary of the sent invoice. Delivery rechecks current Buyer access, clean private storage and attachment integrity. Requires the current lock_version. No file means no send. A sent version cannot be edited or resent with a new key. A Buyer return, correction request or unresolved amount/VAT mismatch (including an explained difference) permits a linked new correction draft.
    //
    //Future<VendorOrderInvoicesEnvelope> sendVendorInvoice(String orderId, String idempotencyKey, InvoiceSendInput invoiceSendInput) async
    test('test sendVendorInvoice', () async {
      // TODO
    });

    // invoices.upload. Save or replace the private invoice draft with optimistic concurrency and Idempotency-Key. Uploading never sends to the Buyer. After Send, preparation is locked unless the Buyer requests a correction, returns the latest copy or the latest invoice has an unresolved amount/VAT mismatch, including an explained difference. Corrections may retain the current private attachment or upload a replacement. No accepted Buyer total changes.
    //
    //Future<VendorOrderInvoicesEnvelope> uploadVendorInvoice(String orderId, String idempotencyKey, String invoiceType, String issuerName, String invoiceNumber, Date issuedOn, int amountCentavos, String sourceSystem, String invoicingMethod, int lockVersion, { int vatCentavos, int vatExemptCentavos, int zeroRatedCentavos, BuiltList<String> relatedLineIds, String amendsInvoiceRecordId, String invoiceRequestId, MultipartFile file }) async
    test('test uploadVendorInvoice', () async {
      // TODO
    });

  });
}
