import 'package:materyalph_api_client/materyalph_api_client.dart';

void check(bool condition, String message) {
  if (!condition) throw StateError(message);
}

void main() {
  for (final evidence in <Map<String, Object?>>[
    {'recaptcha_token': 'test-checkbox'},
    {'request_email_step_up': true},
    {},
  ]) {
    final input = <String, Object?>{
      'token': 'test-invitation',
      'email': 'admin@example.test',
      'full_name': 'Test Admin',
      'password': 'TestPassword123',
      'password_confirmation': 'TestPassword123',
      'terms_accepted': true,
      'privacy_accepted': true,
      'bot_protection': evidence,
    };
    final invitation = standardSerializers.deserializeWith(
      AdminInvitationRequest.serializer,
      input,
    )!;
    final json = standardSerializers.serializeWith(
      AdminInvitationRequest.serializer,
      invitation,
    ) as Map<String, Object?>;
    check(json['email'] == input['email'], 'Invited email is retained.');
    check(json['terms_accepted'] == true, 'Consent remains a JSON boolean.');
    final serializedEvidence = json['bot_protection'] as Map<String, Object?>;
    check(
      serializedEvidence.length == evidence.length &&
          evidence.entries
              .every((entry) => serializedEvidence[entry.key] == entry.value),
      'Bot evidence must round-trip without adding a method.',
    );
  }
  final web = standardSerializers.deserializeWith(
    WebVerifyBotChallengeRequest.serializer,
    {'email': 'admin@example.test', 'code': '123456', 'portal': 'ADMIN'},
  )!;
  final webJson = standardSerializers.serializeWith(
    WebVerifyBotChallengeRequest.serializer,
    web,
  ) as Map<String, Object?>;
  check(webJson['portal'] == 'ADMIN',
      'Web email verification retains the Admin portal.');
  final native = standardSerializers.deserializeWith(
    VerifyBotChallengeRequest.serializer,
    {'email': 'buyer@example.test', 'code': '123456'},
  )!;
  final nativeJson = standardSerializers.serializeWith(
    VerifyBotChallengeRequest.serializer,
    native,
  ) as Map<String, Object?>;
  check(!nativeJson.containsKey('portal'),
      'Buyer-native verification omits the browser portal.');
  print('Bot-protection generated Dart serialization checks passed.');
}
