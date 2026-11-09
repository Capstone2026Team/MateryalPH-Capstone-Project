import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for ReviewListMeta
void main() {
  final instance = ReviewListMetaBuilder();
  // TODO add properties to the builder and call build()

  group(ReviewListMeta, () {
    // Admin moderation only. Full totals by moderation state, including ALL and NEEDS_ACTION, after submission date filters but before state selection and pagination. NEEDS_ACTION counts each review once using the queue's existing open-report or flagged/hidden criteria.
    // BuiltMap<String, int> counts
    test('to test the property `counts`', () async {
      // TODO
    });

    // int page
    test('to test the property `page`', () async {
      // TODO
    });

    // int perPage
    test('to test the property `perPage`', () async {
      // TODO
    });

    // int total
    test('to test the property `total`', () async {
      // TODO
    });

    // String type
    test('to test the property `type`', () async {
      // TODO
    });

    // BuiltMap<String, JsonObject> summary
    test('to test the property `summary`', () async {
      // TODO
    });

    // PublicScores scores
    test('to test the property `scores`', () async {
      // TODO
    });

    // String correlationId
    test('to test the property `correlationId`', () async {
      // TODO
    });

  });
}
