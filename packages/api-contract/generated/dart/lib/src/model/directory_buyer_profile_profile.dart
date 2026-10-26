//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'directory_buyer_profile_profile.g.dart';

/// DirectoryBuyerProfileProfile
///
/// Properties:
/// * [avatarUrl] - Five-minute signed private photo URL, bound to the viewing Admin and current Buyer profile version. Fetch with authenticated cookie transport; null when absent or the account is deleted.
/// * [email]
/// * [emailVerified]
/// * [mobile]
/// * [buyerType]
/// * [companyName]
/// * [positionTitle]
/// * [industry]
/// * [area] - City and province of the primary saved location; never coordinates or site instructions.
/// * [onboardingStatus]
/// * [joinedAt]
/// * [deletedAt]
/// * [commerceRestrictedUntil]
@BuiltValue()
abstract class DirectoryBuyerProfileProfile implements Built<DirectoryBuyerProfileProfile, DirectoryBuyerProfileProfileBuilder> {
  /// Five-minute signed private photo URL, bound to the viewing Admin and current Buyer profile version. Fetch with authenticated cookie transport; null when absent or the account is deleted.
  @BuiltValueField(wireName: r'avatar_url')
  String? get avatarUrl;

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'email_verified')
  bool get emailVerified;

  @BuiltValueField(wireName: r'mobile')
  String? get mobile;

  @BuiltValueField(wireName: r'buyer_type')
  String get buyerType;

  @BuiltValueField(wireName: r'company_name')
  String? get companyName;

  @BuiltValueField(wireName: r'position_title')
  String? get positionTitle;

  @BuiltValueField(wireName: r'industry')
  String? get industry;

  /// City and province of the primary saved location; never coordinates or site instructions.
  @BuiltValueField(wireName: r'area')
  String? get area;

  @BuiltValueField(wireName: r'onboarding_status')
  String get onboardingStatus;

  @BuiltValueField(wireName: r'joined_at')
  DateTime get joinedAt;

  @BuiltValueField(wireName: r'deleted_at')
  DateTime? get deletedAt;

  @BuiltValueField(wireName: r'commerce_restricted_until')
  DateTime? get commerceRestrictedUntil;

  DirectoryBuyerProfileProfile._();

  factory DirectoryBuyerProfileProfile([void updates(DirectoryBuyerProfileProfileBuilder b)]) = _$DirectoryBuyerProfileProfile;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DirectoryBuyerProfileProfileBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DirectoryBuyerProfileProfile> get serializer => _$DirectoryBuyerProfileProfileSerializer();
}

class _$DirectoryBuyerProfileProfileSerializer implements PrimitiveSerializer<DirectoryBuyerProfileProfile> {
  @override
  final Iterable<Type> types = const [DirectoryBuyerProfileProfile, _$DirectoryBuyerProfileProfile];

  @override
  final String wireName = r'DirectoryBuyerProfileProfile';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DirectoryBuyerProfileProfile object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'avatar_url';
    yield object.avatarUrl == null ? null : serializers.serialize(
      object.avatarUrl,
      specifiedType: const FullType.nullable(String),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'email_verified';
    yield serializers.serialize(
      object.emailVerified,
      specifiedType: const FullType(bool),
    );
    yield r'mobile';
    yield object.mobile == null ? null : serializers.serialize(
      object.mobile,
      specifiedType: const FullType.nullable(String),
    );
    yield r'buyer_type';
    yield serializers.serialize(
      object.buyerType,
      specifiedType: const FullType(String),
    );
    yield r'company_name';
    yield object.companyName == null ? null : serializers.serialize(
      object.companyName,
      specifiedType: const FullType.nullable(String),
    );
    yield r'position_title';
    yield object.positionTitle == null ? null : serializers.serialize(
      object.positionTitle,
      specifiedType: const FullType.nullable(String),
    );
    yield r'industry';
    yield object.industry == null ? null : serializers.serialize(
      object.industry,
      specifiedType: const FullType.nullable(String),
    );
    yield r'area';
    yield object.area == null ? null : serializers.serialize(
      object.area,
      specifiedType: const FullType.nullable(String),
    );
    yield r'onboarding_status';
    yield serializers.serialize(
      object.onboardingStatus,
      specifiedType: const FullType(String),
    );
    yield r'joined_at';
    yield serializers.serialize(
      object.joinedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'deleted_at';
    yield object.deletedAt == null ? null : serializers.serialize(
      object.deletedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'commerce_restricted_until';
    yield object.commerceRestrictedUntil == null ? null : serializers.serialize(
      object.commerceRestrictedUntil,
      specifiedType: const FullType.nullable(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DirectoryBuyerProfileProfile object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DirectoryBuyerProfileProfileBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'avatar_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.avatarUrl = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'email_verified':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.emailVerified = valueDes;
          break;
        case r'mobile':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.mobile = valueDes;
          break;
        case r'buyer_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
        case r'position_title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.positionTitle = valueDes;
          break;
        case r'industry':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.industry = valueDes;
          break;
        case r'area':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.area = valueDes;
          break;
        case r'onboarding_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.onboardingStatus = valueDes;
          break;
        case r'joined_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.joinedAt = valueDes;
          break;
        case r'deleted_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.deletedAt = valueDes;
          break;
        case r'commerce_restricted_until':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.commerceRestrictedUntil = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DirectoryBuyerProfileProfile deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DirectoryBuyerProfileProfileBuilder();
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


