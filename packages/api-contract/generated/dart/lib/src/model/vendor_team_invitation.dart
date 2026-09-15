//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_team_invitation.g.dart';

/// VendorTeamInvitation
///
/// Properties:
/// * [id]
/// * [fullName]
/// * [normalizedEmail]
/// * [role]
/// * [canManageStaff]
/// * [expiresAt]
/// * [acceptedAt]
/// * [revokedAt]
/// * [lockVersion]
@BuiltValue()
abstract class VendorTeamInvitation implements Built<VendorTeamInvitation, VendorTeamInvitationBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'full_name')
  String? get fullName;

  @BuiltValueField(wireName: r'normalized_email')
  String get normalizedEmail;

  @BuiltValueField(wireName: r'role')
  String get role;

  @BuiltValueField(wireName: r'can_manage_staff')
  bool get canManageStaff;

  @BuiltValueField(wireName: r'expires_at')
  String get expiresAt;

  @BuiltValueField(wireName: r'accepted_at')
  String? get acceptedAt;

  @BuiltValueField(wireName: r'revoked_at')
  String? get revokedAt;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  VendorTeamInvitation._();

  factory VendorTeamInvitation([void updates(VendorTeamInvitationBuilder b)]) = _$VendorTeamInvitation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorTeamInvitationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorTeamInvitation> get serializer => _$VendorTeamInvitationSerializer();
}

class _$VendorTeamInvitationSerializer implements PrimitiveSerializer<VendorTeamInvitation> {
  @override
  final Iterable<Type> types = const [VendorTeamInvitation, _$VendorTeamInvitation];

  @override
  final String wireName = r'VendorTeamInvitation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorTeamInvitation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'full_name';
    yield object.fullName == null ? null : serializers.serialize(
      object.fullName,
      specifiedType: const FullType.nullable(String),
    );
    yield r'normalized_email';
    yield serializers.serialize(
      object.normalizedEmail,
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
    yield r'expires_at';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(String),
    );
    yield r'accepted_at';
    yield object.acceptedAt == null ? null : serializers.serialize(
      object.acceptedAt,
      specifiedType: const FullType.nullable(String),
    );
    yield r'revoked_at';
    yield object.revokedAt == null ? null : serializers.serialize(
      object.revokedAt,
      specifiedType: const FullType.nullable(String),
    );
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorTeamInvitation object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorTeamInvitationBuilder result,
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
        case r'full_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.fullName = valueDes;
          break;
        case r'normalized_email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.normalizedEmail = valueDes;
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
        case r'expires_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.expiresAt = valueDes;
          break;
        case r'accepted_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.acceptedAt = valueDes;
          break;
        case r'revoked_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.revokedAt = valueDes;
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorTeamInvitation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorTeamInvitationBuilder();
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


