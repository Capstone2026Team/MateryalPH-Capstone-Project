//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'account_security.g.dart';

/// AccountSecurity
///
/// Properties:
/// * [totpEnrolled]
/// * [recentAuthenticationExpiresAt]
@BuiltValue()
abstract class AccountSecurity implements Built<AccountSecurity, AccountSecurityBuilder> {
  @BuiltValueField(wireName: r'totp_enrolled')
  bool get totpEnrolled;

  @BuiltValueField(wireName: r'recent_authentication_expires_at')
  String? get recentAuthenticationExpiresAt;

  AccountSecurity._();

  factory AccountSecurity([void updates(AccountSecurityBuilder b)]) = _$AccountSecurity;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AccountSecurityBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AccountSecurity> get serializer => _$AccountSecuritySerializer();
}

class _$AccountSecuritySerializer implements PrimitiveSerializer<AccountSecurity> {
  @override
  final Iterable<Type> types = const [AccountSecurity, _$AccountSecurity];

  @override
  final String wireName = r'AccountSecurity';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AccountSecurity object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'totp_enrolled';
    yield serializers.serialize(
      object.totpEnrolled,
      specifiedType: const FullType(bool),
    );
    yield r'recent_authentication_expires_at';
    yield object.recentAuthenticationExpiresAt == null ? null : serializers.serialize(
      object.recentAuthenticationExpiresAt,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AccountSecurity object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AccountSecurityBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'totp_enrolled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.totpEnrolled = valueDes;
          break;
        case r'recent_authentication_expires_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.recentAuthenticationExpiresAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AccountSecurity deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AccountSecurityBuilder();
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


