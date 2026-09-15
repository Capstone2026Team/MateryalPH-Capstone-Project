//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'account_profile.g.dart';

/// AccountProfile
///
/// Properties:
/// * [id]
/// * [fullName]
/// * [email]
/// * [accountType]
/// * [accountStatus]
/// * [lockVersion]
/// * [createdAt]
/// * [buyerType]
/// * [companyName]
/// * [organizationName]
/// * [role]
/// * [organizationId]
/// * [membershipId]
/// * [canManageStaff]
/// * [permissions]
@BuiltValue()
abstract class AccountProfile implements Built<AccountProfile, AccountProfileBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'full_name')
  String get fullName;

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'account_type')
  String get accountType;

  @BuiltValueField(wireName: r'account_status')
  String get accountStatus;

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'created_at')
  String? get createdAt;

  @BuiltValueField(wireName: r'buyer_type')
  String? get buyerType;

  @BuiltValueField(wireName: r'company_name')
  String? get companyName;

  @BuiltValueField(wireName: r'organization_name')
  String? get organizationName;

  @BuiltValueField(wireName: r'role')
  String get role;

  @BuiltValueField(wireName: r'organization_id')
  String? get organizationId;

  @BuiltValueField(wireName: r'membership_id')
  String? get membershipId;

  @BuiltValueField(wireName: r'can_manage_staff')
  bool get canManageStaff;

  @BuiltValueField(wireName: r'permissions')
  BuiltList<String> get permissions;

  AccountProfile._();

  factory AccountProfile([void updates(AccountProfileBuilder b)]) = _$AccountProfile;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AccountProfileBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AccountProfile> get serializer => _$AccountProfileSerializer();
}

class _$AccountProfileSerializer implements PrimitiveSerializer<AccountProfile> {
  @override
  final Iterable<Type> types = const [AccountProfile, _$AccountProfile];

  @override
  final String wireName = r'AccountProfile';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AccountProfile object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
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
    yield r'account_type';
    yield serializers.serialize(
      object.accountType,
      specifiedType: const FullType(String),
    );
    yield r'account_status';
    yield serializers.serialize(
      object.accountStatus,
      specifiedType: const FullType(String),
    );
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'created_at';
    yield object.createdAt == null ? null : serializers.serialize(
      object.createdAt,
      specifiedType: const FullType.nullable(String),
    );
    yield r'buyer_type';
    yield object.buyerType == null ? null : serializers.serialize(
      object.buyerType,
      specifiedType: const FullType.nullable(String),
    );
    yield r'company_name';
    yield object.companyName == null ? null : serializers.serialize(
      object.companyName,
      specifiedType: const FullType.nullable(String),
    );
    yield r'organization_name';
    yield object.organizationName == null ? null : serializers.serialize(
      object.organizationName,
      specifiedType: const FullType.nullable(String),
    );
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(String),
    );
    yield r'organization_id';
    yield object.organizationId == null ? null : serializers.serialize(
      object.organizationId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'membership_id';
    yield object.membershipId == null ? null : serializers.serialize(
      object.membershipId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'can_manage_staff';
    yield serializers.serialize(
      object.canManageStaff,
      specifiedType: const FullType(bool),
    );
    yield r'permissions';
    yield serializers.serialize(
      object.permissions,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AccountProfile object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AccountProfileBuilder result,
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
        case r'account_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.accountType = valueDes;
          break;
        case r'account_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.accountStatus = valueDes;
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.createdAt = valueDes;
          break;
        case r'buyer_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.buyerType = valueDes;
          break;
        case r'company_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.companyName = valueDes;
          break;
        case r'organization_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.organizationName = valueDes;
          break;
        case r'role':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.role = valueDes;
          break;
        case r'organization_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.organizationId = valueDes;
          break;
        case r'membership_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.membershipId = valueDes;
          break;
        case r'can_manage_staff':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canManageStaff = valueDes;
          break;
        case r'permissions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.permissions.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AccountProfile deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AccountProfileBuilder();
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


