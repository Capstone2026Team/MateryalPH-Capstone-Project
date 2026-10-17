import 'package:test/test.dart';
import 'package:materyalph_api_client/materyalph_api_client.dart';

// tests for BuyerTwoFactorEnrollment
void main() {
  final instance = BuyerTwoFactorEnrollmentBuilder();
  // TODO add properties to the builder and call build()

  group(BuyerTwoFactorEnrollment, () {
    // Base32 setup key for manual entry in an authenticator app.
    // String secret
    test('to test the property `secret`', () async {
      // TODO
    });

    // otpauth://totp URI; render as a QR code or open in an installed authenticator app.
    // String provisioningUri
    test('to test the property `provisioningUri`', () async {
      // TODO
    });

    // String issuer
    test('to test the property `issuer`', () async {
      // TODO
    });

    // String accountName
    test('to test the property `accountName`', () async {
      // TODO
    });

  });
}
