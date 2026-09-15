//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'account_admin_invitation.g.dart';

/// AccountAdminInvitation
///
/// Properties:
/// * [email]
/// * [roleId]
@BuiltValue()
abstract class AccountAdminInvitation implements Built<AccountAdminInvitation, AccountAdminInvitationBuilder> {
  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'role_id')
  String get roleId;

  AccountAdminInvitation._();

  factory AccountAdminInvitation([void updates(AccountAdminInvitationBuilder b)]) = _$AccountAdminInvitation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AccountAdminInvitationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AccountAdminInvitation> get serializer => _$AccountAdminInvitationSerializer();
}

class _$AccountAdminInvitationSerializer implements PrimitiveSerializer<AccountAdminInvitation> {
  @override
  final Iterable<Type> types = const [AccountAdminInvitation, _$AccountAdminInvitation];

  @override
  final String wireName = r'AccountAdminInvitation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AccountAdminInvitation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'role_id';
    yield serializers.serialize(
      object.roleId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AccountAdminInvitation object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AccountAdminInvitationBuilder result,
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
        case r'role_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
  AccountAdminInvitation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AccountAdminInvitationBuilder();
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


