//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'account_membership_status.g.dart';

/// AccountMembershipStatus
///
/// Properties:
/// * [status]
@BuiltValue()
abstract class AccountMembershipStatus implements Built<AccountMembershipStatus, AccountMembershipStatusBuilder> {
  @BuiltValueField(wireName: r'status')
  AccountMembershipStatusStatusEnum get status;
  // enum statusEnum {  ACTIVE,  SUSPENDED,  DEACTIVATED,  };

  AccountMembershipStatus._();

  factory AccountMembershipStatus([void updates(AccountMembershipStatusBuilder b)]) = _$AccountMembershipStatus;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AccountMembershipStatusBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AccountMembershipStatus> get serializer => _$AccountMembershipStatusSerializer();
}

class _$AccountMembershipStatusSerializer implements PrimitiveSerializer<AccountMembershipStatus> {
  @override
  final Iterable<Type> types = const [AccountMembershipStatus, _$AccountMembershipStatus];

  @override
  final String wireName = r'AccountMembershipStatus';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AccountMembershipStatus object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AccountMembershipStatusStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AccountMembershipStatus object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AccountMembershipStatusBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AccountMembershipStatusStatusEnum),
          ) as AccountMembershipStatusStatusEnum;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AccountMembershipStatus deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AccountMembershipStatusBuilder();
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


class AccountMembershipStatusStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const AccountMembershipStatusStatusEnum ACTIVE = _$accountMembershipStatusStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'SUSPENDED')
  static const AccountMembershipStatusStatusEnum SUSPENDED = _$accountMembershipStatusStatusEnum_SUSPENDED;
  @BuiltValueEnumConst(wireName: r'DEACTIVATED')
  static const AccountMembershipStatusStatusEnum DEACTIVATED = _$accountMembershipStatusStatusEnum_DEACTIVATED;

  static Serializer<AccountMembershipStatusStatusEnum> get serializer => _$accountMembershipStatusStatusEnumSerializer;

  const AccountMembershipStatusStatusEnum._(String name): super(name);

  static BuiltSet<AccountMembershipStatusStatusEnum> get values => _$accountMembershipStatusStatusEnumValues;
  static AccountMembershipStatusStatusEnum valueOf(String name) => _$accountMembershipStatusStatusEnumValueOf(name);
}

