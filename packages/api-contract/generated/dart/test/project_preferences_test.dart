import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for ProjectPreferences
void main() {
  final instance = ProjectPreferencesBuilder();
  // TODO add properties to the builder and call build()

  group(ProjectPreferences, () {
    // Four independent integer importance values from 0 to 100: material_match, budget_fit, distance and vps. At least one above zero; persisted unchanged. Scores normalize by their sum.
    // BuiltMap<String, JsonObject> weights
    test('to test the property `weights`', () async {
      // TODO
    });

    // BuiltMap<String, JsonObject> defaultWeights
    test('to test the property `defaultWeights`', () async {
      // TODO
    });

    // bool personalized
    test('to test the property `personalized`', () async {
      // TODO
    });

    // int version
    test('to test the property `version`', () async {
      // TODO
    });

    // int defaultsVersion
    test('to test the property `defaultsVersion`', () async {
      // TODO
    });

    // String algorithmVersion
    test('to test the property `algorithmVersion`', () async {
      // TODO
    });

  });
}
