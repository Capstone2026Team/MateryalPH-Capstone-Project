import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for ProjectCandidate
void main() {
  final instance = ProjectCandidateBuilder();
  // TODO add properties to the builder and call build()

  group(ProjectCandidate, () {
    // String id
    test('to test the property `id`', () async {
      // TODO
    });

    // String estimateId
    test('to test the property `estimateId`', () async {
      // TODO
    });

    // String vendorId
    test('to test the property `vendorId`', () async {
      // TODO
    });

    // String storeName
    test('to test the property `storeName`', () async {
      // TODO
    });

    // int rank
    test('to test the property `rank`', () async {
      // TODO
    });

    // num latitude
    test('to test the property `latitude`', () async {
      // TODO
    });

    // num longitude
    test('to test the property `longitude`', () async {
      // TODO
    });

    // String scoreLabel
    test('to test the property `scoreLabel`', () async {
      // TODO
    });

    // String vps
    test('to test the property `vps`', () async {
      // TODO
    });

    // BuiltMap<String, JsonObject> fms
    test('to test the property `fms`', () async {
      // TODO
    });

    // bool complete
    test('to test the property `complete`', () async {
      // TODO
    });

    // String fulfillmentPercent
    test('to test the property `fulfillmentPercent`', () async {
      // TODO
    });

    // BuiltList<BuiltMap<String, JsonObject>> missingLines
    test('to test the property `missingLines`', () async {
      // TODO
    });

    // One entry per Work Package line. Each line is filled from one specification option and never mixes two. `options` lists every option (ProjectSpecificationDetail `specifications`, lowest unit price, availability label) when there is more than one; `selection_required` is true until the Buyer chooses one, and until then the line is priced on a flagged basis option. Allocations carry `listing_id`, `variant_id`, `variant_label` and labelled `offered_specifications`.
    // BuiltList<BuiltMap<String, JsonObject>> lines
    test('to test the property `lines`', () async {
      // TODO
    });

    // Some line still needs the Buyer's specification choice.
    // bool selectionRequired
    test('to test the property `selectionRequired`', () async {
      // TODO
    });

    // Choices applied by selection-preview, keyed by line id.
    // BuiltMap<String, String> specificationSelections
    test('to test the property `specificationSelections`', () async {
      // TODO
    });

    // int materialsCentavos
    test('to test the property `materialsCentavos`', () async {
      // TODO
    });

    // int includedVatCentavos
    test('to test the property `includedVatCentavos`', () async {
      // TODO
    });

    // int deliveryCentavos
    test('to test the property `deliveryCentavos`', () async {
      // TODO
    });

    // int processingFeeCentavos
    test('to test the property `processingFeeCentavos`', () async {
      // TODO
    });

    // String processingFeeStatus
    test('to test the property `processingFeeStatus`', () async {
      // TODO
    });

    // int projectedTotalCentavos
    test('to test the property `projectedTotalCentavos`', () async {
      // TODO
    });

    // String budgetLabel
    test('to test the property `budgetLabel`', () async {
      // TODO
    });

    // int distanceMeters
    test('to test the property `distanceMeters`', () async {
      // TODO
    });

    // String distanceBasis
    test('to test the property `distanceBasis`', () async {
      // TODO
    });

    // int etaSeconds
    test('to test the property `etaSeconds`', () async {
      // TODO
    });

    // String fulfillmentMethod
    test('to test the property `fulfillmentMethod`', () async {
      // TODO
    });

    // String paymentMethod
    test('to test the property `paymentMethod`', () async {
      // TODO
    });

    // BuiltMap<String, JsonObject> delivery
    test('to test the property `delivery`', () async {
      // TODO
    });

    // BuiltMap<String, JsonObject> destination
    test('to test the property `destination`', () async {
      // TODO
    });

    // String expiresAt
    test('to test the property `expiresAt`', () async {
      // TODO
    });

    // bool stale
    test('to test the property `stale`', () async {
      // TODO
    });

    // String label
    test('to test the property `label`', () async {
      // TODO
    });

    // String currentQuotationState
    test('to test the property `currentQuotationState`', () async {
      // TODO
    });

    // The Buyer saved this store as a preferred seller.
    // bool isFavorite
    test('to test the property `isFavorite`', () async {
      // TODO
    });

  });
}
