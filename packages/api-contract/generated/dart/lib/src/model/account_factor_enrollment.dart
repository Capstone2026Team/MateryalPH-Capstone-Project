//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'account_factor_enrollment.g.dart';

/// AccountFactorEnrollment
///
/// Properties:
/// * [id]
/// * [expiresAt]
/// * [secret]
/// * [provisioningUri]
@BuiltValue()
abstract class AccountFactorEnrollment implements Built<AccountFactorEnrollment, AccountFactorEnrollmentBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'expires_at')
  String get expiresAt;

  @BuiltValueField(wireName: r'secret')
  String get secret;

  @BuiltValueField(wireName: r'provisioning_uri')
  String get provisioningUri;

  AccountFactorEnrollment._();

  factory AccountFactorEnrollment([void updates(AccountFactorEnrollmentBuilder b)]) = _$AccountFactorEnrollment;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AccountFactorEnrollmentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AccountFactorEnrollment> get serializer => _$AccountFactorEnrollmentSerializer();
}

class _$AccountFactorEnrollmentSerializer implements PrimitiveSerializer<AccountFactorEnrollment> {
  @override
  final Iterable<Type> types = const [AccountFactorEnrollment, _$AccountFactorEnrollment];

  @override
  final String wireName = r'AccountFactorEnrollment';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AccountFactorEnrollment object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'expires_at';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(String),
    );
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
  }

  @override
  Object serialize(
    Serializers serializers,
    AccountFactorEnrollment object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AccountFactorEnrollmentBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'expires_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.expiresAt = valueDes;
          break;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AccountFactorEnrollment deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AccountFactorEnrollmentBuilder();
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


