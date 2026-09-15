//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'account_delegation.g.dart';

/// AccountDelegation
///
/// Properties:
/// * [canManageStaff]
@BuiltValue()
abstract class AccountDelegation implements Built<AccountDelegation, AccountDelegationBuilder> {
  @BuiltValueField(wireName: r'can_manage_staff')
  bool get canManageStaff;

  AccountDelegation._();

  factory AccountDelegation([void updates(AccountDelegationBuilder b)]) = _$AccountDelegation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AccountDelegationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AccountDelegation> get serializer => _$AccountDelegationSerializer();
}

class _$AccountDelegationSerializer implements PrimitiveSerializer<AccountDelegation> {
  @override
  final Iterable<Type> types = const [AccountDelegation, _$AccountDelegation];

  @override
  final String wireName = r'AccountDelegation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AccountDelegation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'can_manage_staff';
    yield serializers.serialize(
      object.canManageStaff,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AccountDelegation object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AccountDelegationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'can_manage_staff':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canManageStaff = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AccountDelegation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AccountDelegationBuilder();
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


