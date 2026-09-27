//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_team_invitation_record.g.dart';

/// VendorTeamInvitationRecord
///
/// Properties:
/// * [id]
/// * [inviteeName]
/// * [email]
/// * [inviteeMobile]
/// * [vendorOrganizationId]
/// * [role]
/// * [canManageStaff]
/// * [status]
/// * [invitedById]
/// * [invitedByName]
/// * [createdAt]
/// * [expiresAt]
/// * [acceptedAt]
@BuiltValue()
abstract class VendorTeamInvitationRecord implements Built<VendorTeamInvitationRecord, VendorTeamInvitationRecordBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'invitee_name')
  String? get inviteeName;

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'invitee_mobile')
  String? get inviteeMobile;

  @BuiltValueField(wireName: r'vendor_organization_id')
  String get vendorOrganizationId;

  @BuiltValueField(wireName: r'role')
  String get role;

  @BuiltValueField(wireName: r'can_manage_staff')
  bool get canManageStaff;

  @BuiltValueField(wireName: r'status')
  VendorTeamInvitationRecordStatusEnum get status;
  // enum statusEnum {  PENDING,  ACCEPTED,  REVOKED,  EXPIRED,  };

  @BuiltValueField(wireName: r'invited_by_id')
  String get invitedById;

  @BuiltValueField(wireName: r'invited_by_name')
  String get invitedByName;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'expires_at')
  DateTime get expiresAt;

  @BuiltValueField(wireName: r'accepted_at')
  DateTime? get acceptedAt;

  VendorTeamInvitationRecord._();

  factory VendorTeamInvitationRecord([void updates(VendorTeamInvitationRecordBuilder b)]) = _$VendorTeamInvitationRecord;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorTeamInvitationRecordBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorTeamInvitationRecord> get serializer => _$VendorTeamInvitationRecordSerializer();
}

class _$VendorTeamInvitationRecordSerializer implements PrimitiveSerializer<VendorTeamInvitationRecord> {
  @override
  final Iterable<Type> types = const [VendorTeamInvitationRecord, _$VendorTeamInvitationRecord];

  @override
  final String wireName = r'VendorTeamInvitationRecord';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorTeamInvitationRecord object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    if (object.inviteeName != null) {
      yield r'invitee_name';
      yield serializers.serialize(
        object.inviteeName,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    if (object.inviteeMobile != null) {
      yield r'invitee_mobile';
      yield serializers.serialize(
        object.inviteeMobile,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'vendor_organization_id';
    yield serializers.serialize(
      object.vendorOrganizationId,
      specifiedType: const FullType(String),
    );
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(String),
    );
    yield r'can_manage_staff';
    yield serializers.serialize(
      object.canManageStaff,
      specifiedType: const FullType(bool),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(VendorTeamInvitationRecordStatusEnum),
    );
    yield r'invited_by_id';
    yield serializers.serialize(
      object.invitedById,
      specifiedType: const FullType(String),
    );
    yield r'invited_by_name';
    yield serializers.serialize(
      object.invitedByName,
      specifiedType: const FullType(String),
    );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'expires_at';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.acceptedAt != null) {
      yield r'accepted_at';
      yield serializers.serialize(
        object.acceptedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorTeamInvitationRecord object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorTeamInvitationRecordBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'invitee_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.inviteeName = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'invitee_mobile':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.inviteeMobile = valueDes;
          break;
        case r'vendor_organization_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.vendorOrganizationId = valueDes;
          break;
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.role = valueDes;
          break;
        case r'can_manage_staff':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canManageStaff = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorTeamInvitationRecordStatusEnum),
          ) as VendorTeamInvitationRecordStatusEnum;
          result.status = valueDes;
          break;
        case r'invited_by_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.invitedById = valueDes;
          break;
        case r'invited_by_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.invitedByName = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'expires_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.expiresAt = valueDes;
          break;
        case r'accepted_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.acceptedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorTeamInvitationRecord deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorTeamInvitationRecordBuilder();
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


class VendorTeamInvitationRecordStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'PENDING')
  static const VendorTeamInvitationRecordStatusEnum PENDING = _$vendorTeamInvitationRecordStatusEnum_PENDING;
  @BuiltValueEnumConst(wireName: r'ACCEPTED')
  static const VendorTeamInvitationRecordStatusEnum ACCEPTED = _$vendorTeamInvitationRecordStatusEnum_ACCEPTED;
  @BuiltValueEnumConst(wireName: r'REVOKED')
  static const VendorTeamInvitationRecordStatusEnum REVOKED = _$vendorTeamInvitationRecordStatusEnum_REVOKED;
  @BuiltValueEnumConst(wireName: r'EXPIRED')
  static const VendorTeamInvitationRecordStatusEnum EXPIRED = _$vendorTeamInvitationRecordStatusEnum_EXPIRED;

  static Serializer<VendorTeamInvitationRecordStatusEnum> get serializer => _$vendorTeamInvitationRecordStatusEnumSerializer;

  const VendorTeamInvitationRecordStatusEnum._(String name): super(name);

  static BuiltSet<VendorTeamInvitationRecordStatusEnum> get values => _$vendorTeamInvitationRecordStatusEnumValues;
  static VendorTeamInvitationRecordStatusEnum valueOf(String name) => _$vendorTeamInvitationRecordStatusEnumValueOf(name);
}

