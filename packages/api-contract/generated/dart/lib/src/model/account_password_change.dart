//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'account_password_change.g.dart';

/// AccountPasswordChange
///
/// Properties:
/// * [password]
/// * [passwordConfirmation]
@BuiltValue()
abstract class AccountPasswordChange implements Built<AccountPasswordChange, AccountPasswordChangeBuilder> {
  @BuiltValueField(wireName: r'password')
  String get password;

  @BuiltValueField(wireName: r'password_confirmation')
  String get passwordConfirmation;

  AccountPasswordChange._();

  factory AccountPasswordChange([void updates(AccountPasswordChangeBuilder b)]) = _$AccountPasswordChange;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AccountPasswordChangeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AccountPasswordChange> get serializer => _$AccountPasswordChangeSerializer();
}

class _$AccountPasswordChangeSerializer implements PrimitiveSerializer<AccountPasswordChange> {
  @override
  final Iterable<Type> types = const [AccountPasswordChange, _$AccountPasswordChange];

  @override
  final String wireName = r'AccountPasswordChange';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AccountPasswordChange object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'password';
    yield serializers.serialize(
      object.password,
      specifiedType: const FullType(String),
    );
    yield r'password_confirmation';
    yield serializers.serialize(
      object.passwordConfirmation,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AccountPasswordChange object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AccountPasswordChangeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'password':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.password = valueDes;
          break;
        case r'password_confirmation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.passwordConfirmation = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AccountPasswordChange deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AccountPasswordChangeBuilder();
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


