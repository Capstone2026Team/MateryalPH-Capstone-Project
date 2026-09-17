//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_invitation.g.dart';

/// VendorInvitation
///
/// Properties:
/// * [queued]
/// * [invitationId]
/// * [role]
/// * [expiresAt]
@BuiltValue()
abstract class VendorInvitation implements Built<VendorInvitation, VendorInvitationBuilder> {
  @BuiltValueField(wireName: r'queued')
  bool get queued;

  @BuiltValueField(wireName: r'invitation_id')
  String? get invitationId;

  @BuiltValueField(wireName: r'role')
  String get role;

  @BuiltValueField(wireName: r'expires_at')
  DateTime? get expiresAt;

  VendorInvitation._();

  factory VendorInvitation([void updates(VendorInvitationBuilder b)]) = _$VendorInvitation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorInvitationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorInvitation> get serializer => _$VendorInvitationSerializer();
}

class _$VendorInvitationSerializer implements PrimitiveSerializer<VendorInvitation> {
  @override
  final Iterable<Type> types = const [VendorInvitation, _$VendorInvitation];

  @override
  final String wireName = r'VendorInvitation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorInvitation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'queued';
    yield serializers.serialize(
      object.queued,
      specifiedType: const FullType(bool),
    );
    if (object.invitationId != null) {
      yield r'invitation_id';
      yield serializers.serialize(
        object.invitationId,
        specifiedType: const FullType(String),
      );
    }
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(String),
    );
    if (object.expiresAt != null) {
      yield r'expires_at';
      yield serializers.serialize(
        object.expiresAt,
        specifiedType: const FullType(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    VendorInvitation object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorInvitationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'queued':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.queued = valueDes;
          break;
        case r'invitation_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.invitationId = valueDes;
          break;
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.role = valueDes;
          break;
        case r'expires_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
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
  VendorInvitation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorInvitationBuilder();
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


