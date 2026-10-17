import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for SiteInspectionDecision
void main() {
  final instance = SiteInspectionDecisionBuilder();
  // TODO add properties to the builder and call build()

  group(SiteInspectionDecision, () {
    // int lockVersion
    test('to test the property `lockVersion`', () async {
      // TODO
    });

    // Required for schedule; must be in the future.
    // DateTime scheduledFor
    test('to test the property `scheduledFor`', () async {
      // TODO
    });

    // Optional note shown to the Buyer for schedule and complete.
    // String note
    test('to test the property `note`', () async {
      // TODO
    });

    // Required for decline.
    // String reason
    test('to test the property `reason`', () async {
      // TODO
    });

    // Required for complete; above zero.
    // String measuredVolumeM3
    test('to test the property `measuredVolumeM3`', () async {
      // TODO
    });

  });
}
