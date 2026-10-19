import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for ProjectCandidateRequest
void main() {
  //final instance = ProjectCandidateRequestBuilder();
  // TODO add properties to the builder and call build()

  group(ProjectCandidateRequest, () {
    // int lockVersion
    test('to test the property `lockVersion`', () async {
      // TODO
    });

    // String candidateId
    test('to test the property `candidateId`', () async {
      // TODO
    });

    // String note
    test('to test the property `note`', () async {
      // TODO
    });

    // String budgetOverrideReason
    test('to test the property `budgetOverrideReason`', () async {
      // TODO
    });

    // The Buyer's specification choice for each line whose `selection_required` is true. Selection and inquiry are rejected with SPECIFICATION_SELECTION_REQUIRED until every such line has one.
    // BuiltList<ProjectSpecificationSelection> selections
    test('to test the property `selections`', () async {
      // TODO
    });

    // The Buyer's method for a Vendor whose candidate lists more than one `fulfillment_options` entry (Both packages). Required then, or the request is rejected with FULFILLMENT_CHOICE_REQUIRED; a method the Vendor does not offer is rejected with FULFILLMENT_NOT_OFFERED.
    // String fulfillmentMethod
    test('to test the property `fulfillmentMethod`', () async {
      // TODO
    });

    // Required for direct selection; explicitly chosen in the checklist and revalidated against current Vendor and fulfillment rules. Inquiry may omit it.
    // String paymentMethod
    test('to test the property `paymentMethod`', () async {
      // TODO
    });

  });
}
