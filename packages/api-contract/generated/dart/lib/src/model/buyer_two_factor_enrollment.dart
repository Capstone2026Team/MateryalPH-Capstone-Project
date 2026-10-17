//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_two_factor_enrollment.g.dart';

/// BuyerTwoFactorEnrollment
///
/// Properties:
/// * [secret] - Base32 setup key for manual entry in an authenticator app.
/// * [provisioningUri] - otpauth://totp URI; render as a QR code or open in an installed authenticator app.
/// * [issuer]
/// * [accountName]
@BuiltValue()
abstract class BuyerTwoFactorEnrollment implements Built<BuyerTwoFactorEnrollment, BuyerTwoFactorEnrollmentBuilder> {
  /// Base32 setup key for manual entry in an authenticator app.
  @BuiltValueField(wireName: r'secret')
  String get secret;

  /// otpauth://totp URI; render as a QR code or open in an installed authenticator app.
  @BuiltValueField(wireName: r'provisioning_uri')
  String get provisioningUri;

  @BuiltValueField(wireName: r'issuer')
  String get issuer;

  @BuiltValueField(wireName: r'account_name')
  String get accountName;

  BuyerTwoFactorEnrollment._();

  factory BuyerTwoFactorEnrollment([void updates(BuyerTwoFactorEnrollmentBuilder b)]) = _$BuyerTwoFactorEnrollment;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerTwoFactorEnrollmentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerTwoFactorEnrollment> get serializer => _$BuyerTwoFactorEnrollmentSerializer();
}

class _$BuyerTwoFactorEnrollmentSerializer implements PrimitiveSerializer<BuyerTwoFactorEnrollment> {
  @override
  final Iterable<Type> types = const [BuyerTwoFactorEnrollment, _$BuyerTwoFactorEnrollment];

  @override
  final String wireName = r'BuyerTwoFactorEnrollment';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerTwoFactorEnrollment object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'secret';
    yield serializers.serialize(
      object.secret,
      specifiedType: const FullType(String),
    );
    yield r'provisioning_uri';
    yield serializers.serialize(
      object.provisioningUri,
      specifiedType: const FullType(String),
    );
    yield r'issuer';
    yield serializers.serialize(
      object.issuer,
      specifiedType: const FullType(String),
    );
    yield r'account_name';
    yield serializers.serialize(
      object.accountName,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerTwoFactorEnrollment object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerTwoFactorEnrollmentBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'secret':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.secret = valueDes;
          break;
        case r'provisioning_uri':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.provisioningUri = valueDes;
          break;
        case r'issuer':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.issuer = valueDes;
          break;
        case r'account_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.accountName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BuyerTwoFactorEnrollment deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerTwoFactorEnrollmentBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}


