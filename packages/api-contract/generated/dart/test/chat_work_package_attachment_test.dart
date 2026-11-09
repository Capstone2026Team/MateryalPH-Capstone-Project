import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for ChatWorkPackageAttachment
void main() {
  final instance = ChatWorkPackageAttachmentBuilder();
  // TODO add properties to the builder and call build()

  group(ChatWorkPackageAttachment, () {
    // Private quotation linkage used by the attachment action, not a separate user-facing chat subject.
    // String inquiryId
    test('to test the property `inquiryId`', () async {
      // TODO
    });

    // String orderId
    test('to test the property `orderId`', () async {
      // TODO
    });

    // int orderLockVersion
    test('to test the property `orderLockVersion`', () async {
      // TODO
    });

    // Vendor-scoped read projection of the locked Work Package. Only this store's assigned quantities or its order snapshot items are included; other suppliers' materials and the package-wide budget are excluded. material_scope is VENDOR_ALLOCATION or VENDOR_ORDER; work_package contains the scoped lines and fulfillment details. order, when present, identifies the order and whether its terms were accepted. Source version/hash identify the retained complete original, not a hash of the filtered projection.
    // BuiltMap<String, JsonObject> reference
    test('to test the property `reference`', () async {
      // TODO
    });

    // Authorized Vendor may prepare the quotation directly from this attachment. Accepted orders cannot be replaced.
    // bool canPrepareQuotation
    test('to test the property `canPrepareQuotation`', () async {
      // TODO
    });

  });
}
