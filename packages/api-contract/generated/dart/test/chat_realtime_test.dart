import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for ChatRealtime
void main() {
  final instance = ChatRealtimeBuilder();
  // TODO add properties to the builder and call build()

  group(ChatRealtime, () {
    // Viewer-bound inbox invalidation channel. Notification realtime also supports Admin accounts through a dedicated notifications channel. Re-fetch configuration on reconnect. No message or notification contents are broadcast. Authorized Team Tracking viewers also receive payload-free team.activity.changed invalidations on messaging inbox channels; activity details require the separately authorized Vendor team activity endpoint.
    // String inboxChannel
    test('to test the property `inboxChannel`', () async {
      // TODO
    });

    // bool enabled
    test('to test the property `enabled`', () async {
      // TODO
    });

    // String key
    test('to test the property `key`', () async {
      // TODO
    });

    // String host
    test('to test the property `host`', () async {
      // TODO
    });

    // int port
    test('to test the property `port`', () async {
      // TODO
    });

    // String scheme
    test('to test the property `scheme`', () async {
      // TODO
    });

  });
}
