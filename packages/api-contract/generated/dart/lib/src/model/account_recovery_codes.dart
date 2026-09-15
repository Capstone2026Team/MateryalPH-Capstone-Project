//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'account_recovery_codes.g.dart';

/// AccountRecoveryCodes
///
/// Properties:
/// * [recoveryCodes]
/// * [signInRequired]
@BuiltValue()
abstract class AccountRecoveryCodes implements Built<AccountRecoveryCodes, AccountRecoveryCodesBuilder> {
  @BuiltValueField(wireName: r'recovery_codes')
  BuiltList<String> get recoveryCodes;

  @BuiltValueField(wireName: r'sign_in_required')
  bool? get signInRequired;

  AccountRecoveryCodes._();

  factory AccountRecoveryCodes([void updates(AccountRecoveryCodesBuilder b)]) = _$AccountRecoveryCodes;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AccountRecoveryCodesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AccountRecoveryCodes> get serializer => _$AccountRecoveryCodesSerializer();
}

class _$AccountRecoveryCodesSerializer implements PrimitiveSerializer<AccountRecoveryCodes> {
  @override
  final Iterable<Type> types = const [AccountRecoveryCodes, _$AccountRecoveryCodes];

  @override
  final String wireName = r'AccountRecoveryCodes';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AccountRecoveryCodes object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'recovery_codes';
    yield serializers.serialize(
      object.recoveryCodes,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    if (object.signInRequired != null) {
      yield r'sign_in_required';
      yield serializers.serialize(
        object.signInRequired,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AccountRecoveryCodes object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AccountRecoveryCodesBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'recovery_codes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.recoveryCodes.replace(valueDes);
          break;
        case r'sign_in_required':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.signInRequired = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AccountRecoveryCodes deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AccountRecoveryCodesBuilder();
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


