//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'account_email_change.g.dart';

/// AccountEmailChange
///
/// Properties:
/// * [email]
@BuiltValue()
abstract class AccountEmailChange implements Built<AccountEmailChange, AccountEmailChangeBuilder> {
  @BuiltValueField(wireName: r'email')
  String get email;

  AccountEmailChange._();

  factory AccountEmailChange([void updates(AccountEmailChangeBuilder b)]) = _$AccountEmailChange;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AccountEmailChangeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AccountEmailChange> get serializer => _$AccountEmailChangeSerializer();
}

class _$AccountEmailChangeSerializer implements PrimitiveSerializer<AccountEmailChange> {
  @override
  final Iterable<Type> types = const [AccountEmailChange, _$AccountEmailChange];

  @override
  final String wireName = r'AccountEmailChange';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AccountEmailChange object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AccountEmailChange object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AccountEmailChangeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AccountEmailChange deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AccountEmailChangeBuilder();
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


