//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'change_vendor_team_member.g.dart';

/// Exactly one of role, status, or can_manage_staff is required. Delegation is Owner-only; Managers may manage only the four non-manager staff roles.
///
/// Properties:
/// * [lockVersion]
/// * [role]
/// * [status]
/// * [canManageStaff]
@BuiltValue()
abstract class ChangeVendorTeamMember implements Built<ChangeVendorTeamMember, ChangeVendorTeamMemberBuilder> {
  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'role')
  ChangeVendorTeamMemberRoleEnum? get role;
  // enum roleEnum {  STORE_MANAGER,  STORE_STAFF,  CUSTOMER_SERVICE,  INVENTORY,  FULFILLMENT,  };

  @BuiltValueField(wireName: r'status')
  ChangeVendorTeamMemberStatusEnum? get status;
  // enum statusEnum {  ACTIVE,  SUSPENDED,  DEACTIVATED,  };

  @BuiltValueField(wireName: r'can_manage_staff')
  bool? get canManageStaff;

  ChangeVendorTeamMember._();

  factory ChangeVendorTeamMember([void updates(ChangeVendorTeamMemberBuilder b)]) = _$ChangeVendorTeamMember;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ChangeVendorTeamMemberBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ChangeVendorTeamMember> get serializer => _$ChangeVendorTeamMemberSerializer();
}

class _$ChangeVendorTeamMemberSerializer implements PrimitiveSerializer<ChangeVendorTeamMember> {
  @override
  final Iterable<Type> types = const [ChangeVendorTeamMember, _$ChangeVendorTeamMember];

  @override
  final String wireName = r'ChangeVendorTeamMember';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ChangeVendorTeamMember object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    if (object.role != null) {
      yield r'role';
      yield serializers.serialize(
        object.role,
        specifiedType: const FullType(ChangeVendorTeamMemberRoleEnum),
      );
    }
    if (object.status != null) {
      yield r'status';
      yield serializers.serialize(
        object.status,
        specifiedType: const FullType(ChangeVendorTeamMemberStatusEnum),
      );
    }
    if (object.canManageStaff != null) {
      yield r'can_manage_staff';
      yield serializers.serialize(
        object.canManageStaff,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ChangeVendorTeamMember object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ChangeVendorTeamMemberBuilder result,
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
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ChangeVendorTeamMemberRoleEnum),
          ) as ChangeVendorTeamMemberRoleEnum?;
          if (valueDes == null) continue;
          result.role = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ChangeVendorTeamMemberStatusEnum),
          ) as ChangeVendorTeamMemberStatusEnum?;
          if (valueDes == null) continue;
          result.status = valueDes;
          break;
        case r'can_manage_staff':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
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
  ChangeVendorTeamMember deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChangeVendorTeamMemberBuilder();
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


class ChangeVendorTeamMemberRoleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'STORE_MANAGER')
  static const ChangeVendorTeamMemberRoleEnum STORE_MANAGER = _$changeVendorTeamMemberRoleEnum_STORE_MANAGER;
  @BuiltValueEnumConst(wireName: r'STORE_STAFF')
  static const ChangeVendorTeamMemberRoleEnum STORE_STAFF = _$changeVendorTeamMemberRoleEnum_STORE_STAFF;
  @BuiltValueEnumConst(wireName: r'CUSTOMER_SERVICE')
  static const ChangeVendorTeamMemberRoleEnum CUSTOMER_SERVICE = _$changeVendorTeamMemberRoleEnum_CUSTOMER_SERVICE;
  @BuiltValueEnumConst(wireName: r'INVENTORY')
  static const ChangeVendorTeamMemberRoleEnum INVENTORY = _$changeVendorTeamMemberRoleEnum_INVENTORY;
  @BuiltValueEnumConst(wireName: r'FULFILLMENT')
  static const ChangeVendorTeamMemberRoleEnum FULFILLMENT = _$changeVendorTeamMemberRoleEnum_FULFILLMENT;

  static Serializer<ChangeVendorTeamMemberRoleEnum> get serializer => _$changeVendorTeamMemberRoleEnumSerializer;

  const ChangeVendorTeamMemberRoleEnum._(String name): super(name);

  static BuiltSet<ChangeVendorTeamMemberRoleEnum> get values => _$changeVendorTeamMemberRoleEnumValues;
  static ChangeVendorTeamMemberRoleEnum valueOf(String name) => _$changeVendorTeamMemberRoleEnumValueOf(name);
}

class ChangeVendorTeamMemberStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const ChangeVendorTeamMemberStatusEnum ACTIVE = _$changeVendorTeamMemberStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'SUSPENDED')
  static const ChangeVendorTeamMemberStatusEnum SUSPENDED = _$changeVendorTeamMemberStatusEnum_SUSPENDED;
  @BuiltValueEnumConst(wireName: r'DEACTIVATED')
  static const ChangeVendorTeamMemberStatusEnum DEACTIVATED = _$changeVendorTeamMemberStatusEnum_DEACTIVATED;

  static Serializer<ChangeVendorTeamMemberStatusEnum> get serializer => _$changeVendorTeamMemberStatusEnumSerializer;

  const ChangeVendorTeamMemberStatusEnum._(String name): super(name);

  static BuiltSet<ChangeVendorTeamMemberStatusEnum> get values => _$changeVendorTeamMemberStatusEnumValues;
  static ChangeVendorTeamMemberStatusEnum valueOf(String name) => _$changeVendorTeamMemberStatusEnumValueOf(name);
}

