import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for AdminInvitationRequest
void main() {
  final instance = AdminInvitationRequestBuilder();
  // TODO add properties to the builder and call build()

  group(AdminInvitationRequest, () {
    // String token
    test('to test the property `token`', () async {
      // TODO
    });

    // Must match the invited email when supplied. The server always derives the account and email-check recipient from the invitation.
    // String email
    test('to test the property `email`', () async {
      // TODO
    });

    // String fullName
    test('to test the property `fullName`', () async {
      // TODO
    });

    // String password
    test('to test the property `password`', () async {
      // TODO
    });

    // String passwordConfirmation
    test('to test the property `passwordConfirmation`', () async {
      // TODO
    });

    // bool termsAccepted
    test('to test the property `termsAccepted`', () async {
      // TODO
    });

    // bool privacyAccepted
    test('to test the property `privacyAccepted`', () async {
      // TODO
    });

    // Admin invitation acceptance; required when bot protection is enabled unless a matching single-use HttpOnly proof cookie is present.
    // VendorBotProtectionEvidence botProtection
    test('to test the property `botProtection`', () async {
      // TODO
    });

  });
}
