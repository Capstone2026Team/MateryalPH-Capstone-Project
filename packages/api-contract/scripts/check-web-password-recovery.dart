import 'package:materyalph_api_client/materyalph_api_client.dart';

void main() {
  final backup = VerifyWebPasswordRecoveryRequest((b) => b
    ..email = 'admin@example.test'
    ..portal = WebPasswordRecoveryPortal.ADMIN
    ..recoveryCode = 'TEST-ONLY');
  final backupWire = standardSerializers.serializeWith(
          VerifyWebPasswordRecoveryRequest.serializer, backup)
      as Map<String, Object?>;
  if (backupWire['recovery_code'] != 'TEST-ONLY' ||
      backupWire.containsKey('code')) {
    throw StateError('Backup recovery must use its separate request field.');
  }
  final email = VerifyWebPasswordRecoveryRequest((b) => b
    ..email = 'admin@example.test'
    ..portal = WebPasswordRecoveryPortal.ADMIN
    ..code = '123456'
    ..challengeId = 'test-challenge');
  final emailWire = standardSerializers.serializeWith(
          VerifyWebPasswordRecoveryRequest.serializer, email)
      as Map<String, Object?>;
  if (emailWire['challenge_id'] != 'test-challenge' ||
      emailWire['code'] != '123456') {
    throw StateError('Recovery challenge binding was lost.');
  }
  final verified = standardSerializers
      .deserializeWith(WebPasswordRecoveryEnvelopeAllOfData.serializer, {
    'verified': true,
    'expires_in': 600,
    'recovery_codes': ['TEST-ONLY']
  })!;
  if (!verified.verified ||
      verified.expiresIn != 600 ||
      verified.recoveryCodes!.single != 'TEST-ONLY') {
    throw StateError('Recovery verification response did not round trip.');
  }
  final vendor = VerifyWebPasswordRecoveryRequest((b) => b
    ..email = 'vendor@example.test'
    ..portal = WebPasswordRecoveryPortal.VENDOR
    ..code = '123456');
  final vendorWire = standardSerializers.serializeWith(
          VerifyWebPasswordRecoveryRequest.serializer, vendor)
      as Map<String, Object?>;
  if (vendorWire['portal'] != 'VENDOR') {
    throw StateError('Vendor recovery must retain its portal binding.');
  }
  print('Vendor/Admin password recovery Dart serialization passed.');
}
