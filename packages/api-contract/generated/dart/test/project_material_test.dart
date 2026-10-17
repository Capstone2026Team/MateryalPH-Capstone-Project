import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for ProjectMaterial
void main() {
  final instance = ProjectMaterialBuilder();
  // TODO add properties to the builder and call build()

  group(ProjectMaterial, () {
    // String id
    test('to test the property `id`', () async {
      // TODO
    });

    // String code
    test('to test the property `code`', () async {
      // TODO
    });

    // String name
    test('to test the property `name`', () async {
      // TODO
    });

    // String categoryId
    test('to test the property `categoryId`', () async {
      // TODO
    });

    // String categoryName
    test('to test the property `categoryName`', () async {
      // TODO
    });

    // bool regulated
    test('to test the property `regulated`', () async {
      // TODO
    });

    // String matchType
    test('to test the property `matchType`', () async {
      // TODO
    });

    // String matchedText
    test('to test the property `matchedText`', () async {
      // TODO
    });

    // 1 for exact or alias matches; pg_trgm similarity for close matches.
    // num similarity
    test('to test the property `similarity`', () async {
      // TODO
    });

    // BuiltList<ProjectMaterialUnit> compatibleUnits
    test('to test the property `compatibleUnits`', () async {
      // TODO
    });

    // Category technical details the Buyer may state, keyed by code.
    // BuiltList<ProjectMaterialAttribute> attributes
    test('to test the property `attributes`', () async {
      // TODO
    });

  });
}
