import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for VendorInvitationAcceptance
void main() {
  final instance = VendorInvitationAcceptanceBuilder();
  // TODO add properties to the builder and call build()

  group(VendorInvitationAcceptance, () {
    // String token
    test('to test the property `token`', () async {
      // TODO
    });

    // String email
    test('to test the property `email`', () async {
      // TODO
    });

    // String fullName
    test('to test the property `fullName`', () async {
      // TODO
    });

    // New Vendor identities require at least 14 characters, mixed case, and a number. Existing ACTIVE or PENDING_VERIFICATION Vendor identities with no retained membership use their current password. Pending identities must complete email verification before signing in.
    // String password
    test('to test the property `password`', () async {
      // TODO
    });

    // String passwordConfirmation
    test('to test the property `passwordConfirmation`', () async {
      // TODO
    });

    // Required when Vendor bot protection is enabled. Use the invitation checkbox token or accessible email check; a verified single-use proof is supplied by HttpOnly cookie.
    // VendorBotProtectionEvidence botProtection
    test('to test the property `botProtection`', () async {
      // TODO
    });

  });
}
