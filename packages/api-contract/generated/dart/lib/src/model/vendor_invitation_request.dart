//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'vendor_invitation_request.g.dart';

/// VendorInvitationRequest
///
/// Properties:
/// * [email]
/// * [inviteeName]
/// * [inviteeMobile]
/// * [role]
/// * [canManageStaff] - Owner-only setting for Store Manager invitations. Enabling requires recent authentication. Invitations are permitted during Store Setup and never grant marketplace activation.
@BuiltValue()
abstract class VendorInvitationRequest implements Built<VendorInvitationRequest, VendorInvitationRequestBuilder> {
  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'invitee_name')
  String get inviteeName;

  @BuiltValueField(wireName: r'invitee_mobile')
  String? get inviteeMobile;

  @BuiltValueField(wireName: r'role')
  VendorInvitationRequestRoleEnum get role;
  // enum roleEnum {  STORE_MANAGER,  STORE_STAFF,  CUSTOMER_SERVICE,  INVENTORY,  FULFILLMENT,  };

  /// Owner-only setting for Store Manager invitations. Enabling requires recent authentication. Invitations are permitted during Store Setup and never grant marketplace activation.
  @BuiltValueField(wireName: r'can_manage_staff')
  bool? get canManageStaff;

  VendorInvitationRequest._();

  factory VendorInvitationRequest([void updates(VendorInvitationRequestBuilder b)]) = _$VendorInvitationRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VendorInvitationRequestBuilder b) => b
      ..canManageStaff = false;

  @BuiltValueSerializer(custom: true)
  static Serializer<VendorInvitationRequest> get serializer => _$VendorInvitationRequestSerializer();
}

class _$VendorInvitationRequestSerializer implements PrimitiveSerializer<VendorInvitationRequest> {
  @override
  final Iterable<Type> types = const [VendorInvitationRequest, _$VendorInvitationRequest];

  @override
  final String wireName = r'VendorInvitationRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VendorInvitationRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'invitee_name';
    yield serializers.serialize(
      object.inviteeName,
      specifiedType: const FullType(String),
    );
    if (object.inviteeMobile != null) {
      yield r'invitee_mobile';
      yield serializers.serialize(
        object.inviteeMobile,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(VendorInvitationRequestRoleEnum),
    );
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
    VendorInvitationRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VendorInvitationRequestBuilder result,
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
        case r'invitee_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.inviteeName = valueDes;
          break;
        case r'invitee_mobile':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.inviteeMobile = valueDes;
          break;
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(VendorInvitationRequestRoleEnum),
          ) as VendorInvitationRequestRoleEnum;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VendorInvitationRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VendorInvitationRequestBuilder();
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


class VendorInvitationRequestRoleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'STORE_MANAGER')
  static const VendorInvitationRequestRoleEnum STORE_MANAGER = _$vendorInvitationRequestRoleEnum_STORE_MANAGER;
  @BuiltValueEnumConst(wireName: r'STORE_STAFF')
  static const VendorInvitationRequestRoleEnum STORE_STAFF = _$vendorInvitationRequestRoleEnum_STORE_STAFF;
  @BuiltValueEnumConst(wireName: r'CUSTOMER_SERVICE')
  static const VendorInvitationRequestRoleEnum CUSTOMER_SERVICE = _$vendorInvitationRequestRoleEnum_CUSTOMER_SERVICE;
  @BuiltValueEnumConst(wireName: r'INVENTORY')
  static const VendorInvitationRequestRoleEnum INVENTORY = _$vendorInvitationRequestRoleEnum_INVENTORY;
  @BuiltValueEnumConst(wireName: r'FULFILLMENT')
  static const VendorInvitationRequestRoleEnum FULFILLMENT = _$vendorInvitationRequestRoleEnum_FULFILLMENT;

  static Serializer<VendorInvitationRequestRoleEnum> get serializer => _$vendorInvitationRequestRoleEnumSerializer;

  const VendorInvitationRequestRoleEnum._(String name): super(name);

  static BuiltSet<VendorInvitationRequestRoleEnum> get values => _$vendorInvitationRequestRoleEnumValues;
  static VendorInvitationRequestRoleEnum valueOf(String name) => _$vendorInvitationRequestRoleEnumValueOf(name);
}

