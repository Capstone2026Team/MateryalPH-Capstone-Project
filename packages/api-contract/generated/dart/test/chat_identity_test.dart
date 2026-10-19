import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for ChatIdentity
void main() {
  final instance = ChatIdentityBuilder();
  // TODO add properties to the builder and call build()

  group(ChatIdentity, () {
    // Current public profile name. Historical messages fall back to the stored public name when no current profile name exists. System messages retain their system identity.
    // String displayName
    test('to test the property `displayName`', () async {
      // TODO
    });

    // Public role. For historical messages, this is the role recorded when the message was sent, even after a handler transfer or role change.
    // String role
    test('to test the property `role`', () async {
      // TODO
    });

    // String avatarPath
    test('to test the property `avatarPath`', () async {
      // TODO
    });

  });
}
