import 'package:materyalph_api_client/materyalph_api_client.dart';

void check(bool condition, String message) {
  if (!condition) throw StateError(message);
}

void main() {
  const name = 'Sample Buyer';
  const phone = '+639170000001';
  const photo =
      '/vendor/orders/019c6e27-e55b-73d1-87d8-4e01f1f75043/fulfillment/buyer-photo?version=2';
  for (final input in <Map<String, Object?>>[
    {'display_name': name},
    {'display_name': name, 'mobile_e164': null, 'avatar_path': null},
    {'display_name': name, 'mobile_e164': phone, 'avatar_path': photo},
  ]) {
    final buyer =
        standardSerializers.deserializeWith(OrderBuyerRef.serializer, input)!;
    check(buyer.displayName == name, 'Buyer name must be retained');
    check(buyer.mobileE164 == input['mobile_e164'],
        'Nullable delivery phone must deserialize');
    check(buyer.avatarPath == input['avatar_path'],
        'Nullable protected photo path must deserialize');
    final output = standardSerializers.serializeWith(
        OrderBuyerRef.serializer, buyer) as Map<String, Object?>;
    check(output['display_name'] == name, 'Buyer name must serialize');
    check(output['mobile_e164'] == input['mobile_e164'],
        'Delivery phone must round trip');
    check(output['avatar_path'] == input['avatar_path'],
        'Photo path must round trip');
    check(
        !output.containsKey('email') &&
            !output.containsKey('user_id') &&
            !output.containsKey('profile_photo_key'),
        'Private account and storage fields are excluded');
  }
  print(
      'Dart delivery contact contract passed: missing, null and populated contact fields.');
}
