//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'account_admin_change.g.dart';

/// AccountAdminChange
///
/// Properties:
/// * [lockVersion]
/// * [reason]
/// * [status]
/// * [roleId]
@BuiltValue()
abstract class AccountAdminChange implements Built<AccountAdminChange, AccountAdminChangeBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'status')
  AccountAdminChangeStatusEnum? get status;
  // enum statusEnum {  ACTIVE,  SUSPENDED,  DEACTIVATED,  };

  @BuiltValueField(wireName: r'role_id')
  String? get roleId;

  AccountAdminChange._();

  factory AccountAdminChange([void updates(AccountAdminChangeBuilder b)]) = _$AccountAdminChange;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AccountAdminChangeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AccountAdminChange> get serializer => _$AccountAdminChangeSerializer();
}

class _$AccountAdminChangeSerializer implements PrimitiveSerializer<AccountAdminChange> {
  @override
  final Iterable<Type> types = const [AccountAdminChange, _$AccountAdminChange];

  @override
  final String wireName = r'AccountAdminChange';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AccountAdminChange object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    if (object.status != null) {
      yield r'status';
      yield serializers.serialize(
        object.status,
        specifiedType: const FullType(AccountAdminChangeStatusEnum),
      );
    }
    if (object.roleId != null) {
      yield r'role_id';
      yield serializers.serialize(
        object.roleId,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AccountAdminChange object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AccountAdminChangeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.reason = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AccountAdminChangeStatusEnum),
          ) as AccountAdminChangeStatusEnum?;
          if (valueDes == null) continue;
          result.status = valueDes;
          break;
        case r'role_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.roleId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AccountAdminChange deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AccountAdminChangeBuilder();
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


class AccountAdminChangeStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const AccountAdminChangeStatusEnum ACTIVE = _$accountAdminChangeStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'SUSPENDED')
  static const AccountAdminChangeStatusEnum SUSPENDED = _$accountAdminChangeStatusEnum_SUSPENDED;
  @BuiltValueEnumConst(wireName: r'DEACTIVATED')
  static const AccountAdminChangeStatusEnum DEACTIVATED = _$accountAdminChangeStatusEnum_DEACTIVATED;

  static Serializer<AccountAdminChangeStatusEnum> get serializer => _$accountAdminChangeStatusEnumSerializer;

  const AccountAdminChangeStatusEnum._(String name): super(name);

  static BuiltSet<AccountAdminChangeStatusEnum> get values => _$accountAdminChangeStatusEnumValues;
  static AccountAdminChangeStatusEnum valueOf(String name) => _$accountAdminChangeStatusEnumValueOf(name);
}

