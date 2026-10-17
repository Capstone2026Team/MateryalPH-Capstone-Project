import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for CheckoutSubmitRequest
void main() {
  final instance = CheckoutSubmitRequestBuilder();
  // TODO add properties to the builder and call build()

  group(CheckoutSubmitRequest, () {
    // int cartLockVersion
    test('to test the property `cartLockVersion`', () async {
      // TODO
    });

    // BuiltSet<String> vendorIds
    test('to test the property `vendorIds`', () async {
      // TODO
    });

    // Required when fewer Vendor groups are submitted than the cart holds.
    // bool splitConfirmed
    test('to test the property `splitConfirmed`', () async {
      // TODO
    });

    // Optional owned open Work Package under an Active Project. Each submitted child remains ITEM_BASED and contributes to its budget; this does not fulfill missing lines or select the Project Vendor. Tagged cart lines must belong to this version.
    // String workPackageId
    test('to test the property `workPackageId`', () async {
      // TODO
    });

    // Required with work_package_id; stale versions return PROJECT_VERSION_CONFLICT (409).
    // int workPackageLockVersion
    test('to test the property `workPackageLockVersion`', () async {
      // TODO
    });

    // Explicit Buyer acknowledgement when the combined submitted amount exceeds the Project or Work Package budget. Final acceptance rechecks committed spend.
    // String budgetOverrideReason
    test('to test the property `budgetOverrideReason`', () async {
      // TODO
    });

    // CheckoutInvoiceDetails invoiceDetails
    test('to test the property `invoiceDetails`', () async {
      // TODO
    });

    // Vendor id => chosen method; Online when omitted. COD pairs with Site Delivery, In-Store with Self-Pickup, each only when the Vendor enabled it.
    // BuiltMap<String, String> paymentMethods
    test('to test the property `paymentMethods`', () async {
      // TODO
    });

  });
}
