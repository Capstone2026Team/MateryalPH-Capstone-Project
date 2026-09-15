//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'invite_vendor_team.g.dart';

/// InviteVendorTeam
///
/// Properties:
/// * [fullName]
/// * [email]
/// * [telephoneE164]
/// * [role]
/// * [canManageStaff]
/// * [expiresAt]
@BuiltValue()
abstract class InviteVendorTeam implements Built<InviteVendorTeam, InviteVendorTeamBuilder> {
  @BuiltValueField(wireName: r'full_name')
  String get fullName;

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'telephone_e164')
  String? get telephoneE164;

  @BuiltValueField(wireName: r'role')
  InviteVendorTeamRoleEnum get role;
  // enum roleEnum {  STORE_MANAGER,  STORE_STAFF,  CUSTOMER_SERVICE,  INVENTORY,  FULFILLMENT,  };

  @BuiltValueField(wireName: r'can_manage_staff')
  bool? get canManageStaff;

  @BuiltValueField(wireName: r'expires_at')
  DateTime get expiresAt;

  InviteVendorTeam._();

  factory InviteVendorTeam([void updates(InviteVendorTeamBuilder b)]) = _$InviteVendorTeam;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InviteVendorTeamBuilder b) => b
      ..canManageStaff = false;

  @BuiltValueSerializer(custom: true)
  static Serializer<InviteVendorTeam> get serializer => _$InviteVendorTeamSerializer();
}

class _$InviteVendorTeamSerializer implements PrimitiveSerializer<InviteVendorTeam> {
  @override
  final Iterable<Type> types = const [InviteVendorTeam, _$InviteVendorTeam];

  @override
  final String wireName = r'InviteVendorTeam';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InviteVendorTeam object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'full_name';
    yield serializers.serialize(
      object.fullName,
      specifiedType: const FullType(String),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    if (object.telephoneE164 != null) {
      yield r'telephone_e164';
      yield serializers.serialize(
        object.telephoneE164,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(InviteVendorTeamRoleEnum),
    );
    if (object.canManageStaff != null) {
      yield r'can_manage_staff';
      yield serializers.serialize(
        object.canManageStaff,
        specifiedType: const FullType(bool),
      );
    }
    yield r'expires_at';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    InviteVendorTeam object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InviteVendorTeamBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'full_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fullName = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'telephone_e164':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.telephoneE164 = valueDes;
          break;
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(InviteVendorTeamRoleEnum),
          ) as InviteVendorTeamRoleEnum;
          result.role = valueDes;
          break;
        case r'can_manage_staff':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.canManageStaff = valueDes;
          break;
        case r'expires_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.expiresAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InviteVendorTeam deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InviteVendorTeamBuilder();
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


class InviteVendorTeamRoleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'STORE_MANAGER')
  static const InviteVendorTeamRoleEnum STORE_MANAGER = _$inviteVendorTeamRoleEnum_STORE_MANAGER;
  @BuiltValueEnumConst(wireName: r'STORE_STAFF')
  static const InviteVendorTeamRoleEnum STORE_STAFF = _$inviteVendorTeamRoleEnum_STORE_STAFF;
  @BuiltValueEnumConst(wireName: r'CUSTOMER_SERVICE')
  static const InviteVendorTeamRoleEnum CUSTOMER_SERVICE = _$inviteVendorTeamRoleEnum_CUSTOMER_SERVICE;
  @BuiltValueEnumConst(wireName: r'INVENTORY')
  static const InviteVendorTeamRoleEnum INVENTORY = _$inviteVendorTeamRoleEnum_INVENTORY;
  @BuiltValueEnumConst(wireName: r'FULFILLMENT')
  static const InviteVendorTeamRoleEnum FULFILLMENT = _$inviteVendorTeamRoleEnum_FULFILLMENT;

  static Serializer<InviteVendorTeamRoleEnum> get serializer => _$inviteVendorTeamRoleEnumSerializer;

  const InviteVendorTeamRoleEnum._(String name): super(name);

  static BuiltSet<InviteVendorTeamRoleEnum> get values => _$inviteVendorTeamRoleEnumValues;
  static InviteVendorTeamRoleEnum valueOf(String name) => _$inviteVendorTeamRoleEnumValueOf(name);
}

