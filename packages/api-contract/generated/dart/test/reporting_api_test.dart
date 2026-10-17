import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';


/// tests for ReportingApi
void main() {
  final instance = MateryalphApiClient().getReportingApi();

  group(ReportingApi, () {
    // download Document Export
    //
    //
    //
    //Future<Uint8List> downloadDocumentExport(String audience, String exportId) async
    test('test downloadDocumentExport', () async {
      // TODO
    });

    // get Tax Package
    //
    //
    //
    //Future<PrepareTaxPackage201Response> getTaxPackage(String packageId) async
    test('test getTaxPackage', () async {
      // TODO
    });

    // list Document Exports
    //
    // Lists the actor's currently authorized exports, optionally scoped to the document type, source record and format. READY artifacts past their download deadline are returned as EXPIRED.
    //
    //Future<ListDocumentExports200Response> listDocumentExports(String audience, { int page, String type, String resourceId, String format, Date from, Date to }) async
    test('test listDocumentExports', () async {
      // TODO
    });

    // list Tax Packages
    //
    //
    //
    //Future<ListTaxPackages200Response> listTaxPackages({ int page, Date from, Date to }) async
    test('test listTaxPackages', () async {
      // TODO
    });

    // prepare Tax Package
    //
    //
    //
    //Future<PrepareTaxPackage201Response> prepareTaxPackage(String idempotencyKey, TaxPackageInput taxPackageInput) async
    test('test prepareTaxPackage', () async {
      // TODO
    });

    // record Tax Simulation
    //
    // Only SIMULATED_SUBMISSION_RECORDED after export; never FILED or BIR_PAID, no government receipt.
    //
    //Future<RecordTaxSimulation200Response> recordTaxSimulation(String packageId) async
    test('test recordTaxSimulation', () async {
      // TODO
    });

    // request Document Export
    //
    // Private immutable snapshot. Current access checked at request, generation and download. Admin requires recent authentication. Files expire 24 hours after generation. MAT audience suppression applies.
    //
    //Future<RequestDocumentExport202Response> requestDocumentExport(String audience, String idempotencyKey, DocumentExportInput documentExportInput) async
    test('test requestDocumentExport', () async {
      // TODO
    });

    // review Tax Package
    //
    // Independent finance reviewer, source reconciliation and cited actual deadline required. Nominal deadline retained. No live tax filing.
    //
    //Future<PrepareTaxPackage201Response> reviewTaxPackage(String packageId, TaxPackageReview taxPackageReview) async
    test('test reviewTaxPackage', () async {
      // TODO
    });

  });
}
