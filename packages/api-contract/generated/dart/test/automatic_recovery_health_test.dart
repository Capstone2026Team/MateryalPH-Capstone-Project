import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for AutomaticRecoveryHealth
void main() {
  final instance = AutomaticRecoveryHealthBuilder();
  // TODO add properties to the builder and call build()

  group(AutomaticRecoveryHealth, () {
    // String status
    test('to test the property `status`', () async {
      // TODO
    });

    // int maxCycles
    test('to test the property `maxCycles`', () async {
      // TODO
    });

    // Recovery cooldowns: 15, 60 and 360 minutes after the most recent failure; active dispatcher leases can delay eligibility.
    // BuiltList<int> delaysMinutes
    test('to test the property `delaysMinutes`', () async {
      // TODO
    });

    // DateTime lastStartedAt
    test('to test the property `lastStartedAt`', () async {
      // TODO
    });

  });
}
