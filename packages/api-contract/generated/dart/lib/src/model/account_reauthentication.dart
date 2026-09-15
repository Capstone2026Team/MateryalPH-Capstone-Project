//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'account_reauthentication.g.dart';

/// AccountReauthentication
///
/// Properties:
/// * [password]
/// * [code]
/// * [emailCode]
@BuiltValue()
abstract class AccountReauthentication implements Built<AccountReauthentication, AccountReauthenticationBuilder> {
  @BuiltValueField(wireName: r'password')
  String? get password;

  @BuiltValueField(wireName: r'code')
  String? get code;

  @BuiltValueField(wireName: r'email_code')
  String? get emailCode;

  AccountReauthentication._();

  factory AccountReauthentication([void updates(AccountReauthenticationBuilder b)]) = _$AccountReauthentication;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AccountReauthenticationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AccountReauthentication> get serializer => _$AccountReauthenticationSerializer();
}

class _$AccountReauthenticationSerializer implements PrimitiveSerializer<AccountReauthentication> {
  @override
  final Iterable<Type> types = const [AccountReauthentication, _$AccountReauthentication];

  @override
  final String wireName = r'AccountReauthentication';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AccountReauthentication object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.password != null) {
      yield r'password';
      yield serializers.serialize(
        object.password,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.code != null) {
      yield r'code';
      yield serializers.serialize(
        object.code,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.emailCode != null) {
      yield r'email_code';
      yield serializers.serialize(
        object.emailCode,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AccountReauthentication object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AccountReauthenticationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'password':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.password = valueDes;
          break;
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.code = valueDes;
          break;
        case r'email_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.emailCode = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AccountReauthentication deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AccountReauthenticationBuilder();
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


