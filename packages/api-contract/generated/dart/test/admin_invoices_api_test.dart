import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for AdminInvoicesApi
void main() {
  final instance = MateryalphApiClient().getAdminInvoicesApi();

  group(AdminInvoicesApi, () {
    // invoices.view. Signed link; recorded.
    //
    //Future<Uint8List> getAdminInvoiceFile(String recordId, int expires, String signature) async
    test('test getAdminInvoiceFile', () async {
      // TODO
    });

    // invoices.view. Read-only Invoice Request Log with records, mismatches and download events.
    //
    //Future<InvoiceLogEnvelope> listAdminInvoiceLog({ String view, int page }) async
    test('test listAdminInvoiceLog', () async {
      // TODO
    });

  });
}
