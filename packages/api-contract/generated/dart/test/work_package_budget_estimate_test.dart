import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for WorkPackageBudgetEstimate
void main() {
  final instance = WorkPackageBudgetEstimateBuilder();
  // TODO add properties to the builder and call build()

  group(WorkPackageBudgetEstimate, () {
    // Actual route/vehicle estimate for a representative exact-match supplier plan, consolidated per supplier. Zero for pickup-only supplies; ready-mixed concrete includes mixer delivery even under PICKUP. Null when delivery or supplier availability needs review.
    // int deliveryCentavos
    test('to test the property `deliveryCentavos`', () async {
      // TODO
    });

    // Average eligible material prices plus applicable supplier delivery. Null until every material and delivery fee can be estimated.
    // int estimatedTotalCentavos
    test('to test the property `estimatedTotalCentavos`', () async {
      // TODO
    });

    // String deliveryStatus
    test('to test the property `deliveryStatus`', () async {
      // TODO
    });

    // BuiltList<String> deliveryIssues
    test('to test the property `deliveryIssues`', () async {
      // TODO
    });

    // Both is budgeted using the Site Delivery scenario.
    // String fulfillmentMethod
    test('to test the property `fulfillmentMethod`', () async {
      // TODO
    });

    // BuiltList<WorkPackageBudgetEstimateLine> lines
    test('to test the property `lines`', () async {
      // TODO
    });

    // int materialsTotalCentavos
    test('to test the property `materialsTotalCentavos`', () async {
      // TODO
    });

    // int pricedLineCount
    test('to test the property `pricedLineCount`', () async {
      // TODO
    });

    // int unpricedLineCount
    test('to test the property `unpricedLineCount`', () async {
      // TODO
    });

    // int radiusKm
    test('to test the property `radiusKm`', () async {
      // TODO
    });

    // String basis
    test('to test the property `basis`', () async {
      // TODO
    });

    // BuiltList<String> excludes
    test('to test the property `excludes`', () async {
      // TODO
    });

    // String computedAt
    test('to test the property `computedAt`', () async {
      // TODO
    });

  });
}
