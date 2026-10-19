//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/directory_vendor_profile_ratings.dart';
import 'package:materyalph_api_client/src/model/directory_vendor_profile_store.dart';
import 'package:materyalph_api_client/src/model/directory_sanction.dart';
import 'package:materyalph_api_client/src/model/directory_vendor_profile_owner.dart';
import 'package:materyalph_api_client/src/model/directory_vendor_profile_activity.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'directory_vendor_profile.g.dart';

/// DirectoryVendorProfile
///
/// Properties:
/// * [id]
/// * [subjectType]
/// * [storeName]
/// * [status]
/// * [store]
/// * [owner]
/// * [ratings]
/// * [activity]
/// * [sanctions] - Empty unless the caller also holds enforcement.view.
/// * [canViewEnforcement]
/// * [canViewVerification]
@BuiltValue()
abstract class DirectoryVendorProfile implements Built<DirectoryVendorProfile, DirectoryVendorProfileBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'subject_type')
  DirectoryVendorProfileSubjectTypeEnum get subjectType;
  // enum subjectTypeEnum {  VENDOR_ORGANIZATION,  };

  @BuiltValueField(wireName: r'store_name')
  String get storeName;

  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'store')
  DirectoryVendorProfileStore get store;

  @BuiltValueField(wireName: r'owner')
  DirectoryVendorProfileOwner? get owner;

  @BuiltValueField(wireName: r'ratings')
  DirectoryVendorProfileRatings get ratings;

  @BuiltValueField(wireName: r'activity')
  DirectoryVendorProfileActivity get activity;

  /// Empty unless the caller also holds enforcement.view.
  @BuiltValueField(wireName: r'sanctions')
  BuiltList<DirectorySanction> get sanctions;

  @BuiltValueField(wireName: r'can_view_enforcement')
  bool get canViewEnforcement;

  @BuiltValueField(wireName: r'can_view_verification')
  bool get canViewVerification;

  DirectoryVendorProfile._();

  factory DirectoryVendorProfile([void updates(DirectoryVendorProfileBuilder b)]) = _$DirectoryVendorProfile;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DirectoryVendorProfileBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DirectoryVendorProfile> get serializer => _$DirectoryVendorProfileSerializer();
}

class _$DirectoryVendorProfileSerializer implements PrimitiveSerializer<DirectoryVendorProfile> {
  @override
  final Iterable<Type> types = const [DirectoryVendorProfile, _$DirectoryVendorProfile];

  @override
  final String wireName = r'DirectoryVendorProfile';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DirectoryVendorProfile object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'subject_type';
    yield serializers.serialize(
      object.subjectType,
      specifiedType: const FullType(DirectoryVendorProfileSubjectTypeEnum),
    );
    yield r'store_name';
    yield serializers.serialize(
      object.storeName,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
    yield r'store';
    yield serializers.serialize(
      object.store,
      specifiedType: const FullType(DirectoryVendorProfileStore),
    );
    yield r'owner';
    yield object.owner == null ? null : serializers.serialize(
      object.owner,
      specifiedType: const FullType.nullable(DirectoryVendorProfileOwner),
    );
    yield r'ratings';
    yield serializers.serialize(
      object.ratings,
      specifiedType: const FullType(DirectoryVendorProfileRatings),
    );
    yield r'activity';
    yield serializers.serialize(
      object.activity,
      specifiedType: const FullType(DirectoryVendorProfileActivity),
    );
    yield r'sanctions';
    yield serializers.serialize(
      object.sanctions,
      specifiedType: const FullType(BuiltList, [FullType(DirectorySanction)]),
    );
    yield r'can_view_enforcement';
    yield serializers.serialize(
      object.canViewEnforcement,
      specifiedType: const FullType(bool),
    );
    yield r'can_view_verification';
    yield serializers.serialize(
      object.canViewVerification,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DirectoryVendorProfile object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DirectoryVendorProfileBuilder result,
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
        case r'subject_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DirectoryVendorProfileSubjectTypeEnum),
          ) as DirectoryVendorProfileSubjectTypeEnum;
          result.subjectType = valueDes;
          break;
        case r'store_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.storeName = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'store':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DirectoryVendorProfileStore),
          ) as DirectoryVendorProfileStore;
          result.store.replace(valueDes);
          break;
        case r'owner':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DirectoryVendorProfileOwner),
          ) as DirectoryVendorProfileOwner?;
          if (valueDes == null) continue;
          result.owner.replace(valueDes);
          break;
        case r'ratings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DirectoryVendorProfileRatings),
          ) as DirectoryVendorProfileRatings;
          result.ratings.replace(valueDes);
          break;
        case r'activity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DirectoryVendorProfileActivity),
          ) as DirectoryVendorProfileActivity;
          result.activity.replace(valueDes);
          break;
        case r'sanctions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DirectorySanction)]),
          ) as BuiltList<DirectorySanction>;
          result.sanctions.replace(valueDes);
          break;
        case r'can_view_enforcement':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canViewEnforcement = valueDes;
          break;
        case r'can_view_verification':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.canViewVerification = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DirectoryVendorProfile deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DirectoryVendorProfileBuilder();
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


class DirectoryVendorProfileSubjectTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VENDOR_ORGANIZATION')
  static const DirectoryVendorProfileSubjectTypeEnum VENDOR_ORGANIZATION = _$directoryVendorProfileSubjectTypeEnum_VENDOR_ORGANIZATION;

  static Serializer<DirectoryVendorProfileSubjectTypeEnum> get serializer => _$directoryVendorProfileSubjectTypeEnumSerializer;

  const DirectoryVendorProfileSubjectTypeEnum._(String name): super(name);

  static BuiltSet<DirectoryVendorProfileSubjectTypeEnum> get values => _$directoryVendorProfileSubjectTypeEnumValues;
  static DirectoryVendorProfileSubjectTypeEnum valueOf(String name) => _$directoryVendorProfileSubjectTypeEnumValueOf(name);
}

