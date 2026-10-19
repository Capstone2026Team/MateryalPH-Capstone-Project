//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/directory_buyer_profile_ratings.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/directory_buyer_profile_activity.dart';
import 'package:materyalph_api_client/src/model/directory_buyer_profile_recent_orders_inner.dart';
import 'package:materyalph_api_client/src/model/directory_sanction.dart';
import 'package:materyalph_api_client/src/model/directory_buyer_profile_profile.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'directory_buyer_profile.g.dart';

/// DirectoryBuyerProfile
///
/// Properties:
/// * [id]
/// * [subjectType]
/// * [name]
/// * [status]
/// * [profile]
/// * [ratings]
/// * [activity]
/// * [recentOrders]
/// * [sanctions] - Empty unless the caller also holds enforcement.view.
/// * [canViewEnforcement]
@BuiltValue()
abstract class DirectoryBuyerProfile implements Built<DirectoryBuyerProfile, DirectoryBuyerProfileBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'subject_type')
  DirectoryBuyerProfileSubjectTypeEnum get subjectType;
  // enum subjectTypeEnum {  BUYER,  };

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'status')
  DirectoryBuyerProfileStatusEnum get status;
  // enum statusEnum {  ACTIVE,  PENDING_VERIFICATION,  SUSPENDED,  DEACTIVATED,  DELETED,  };

  @BuiltValueField(wireName: r'profile')
  DirectoryBuyerProfileProfile get profile;

  @BuiltValueField(wireName: r'ratings')
  DirectoryBuyerProfileRatings get ratings;

  @BuiltValueField(wireName: r'activity')
  DirectoryBuyerProfileActivity get activity;

  @BuiltValueField(wireName: r'recent_orders')
  BuiltList<DirectoryBuyerProfileRecentOrdersInner> get recentOrders;

  /// Empty unless the caller also holds enforcement.view.
  @BuiltValueField(wireName: r'sanctions')
  BuiltList<DirectorySanction> get sanctions;

  @BuiltValueField(wireName: r'can_view_enforcement')
  bool get canViewEnforcement;

  DirectoryBuyerProfile._();

  factory DirectoryBuyerProfile([void updates(DirectoryBuyerProfileBuilder b)]) = _$DirectoryBuyerProfile;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DirectoryBuyerProfileBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DirectoryBuyerProfile> get serializer => _$DirectoryBuyerProfileSerializer();
}

class _$DirectoryBuyerProfileSerializer implements PrimitiveSerializer<DirectoryBuyerProfile> {
  @override
  final Iterable<Type> types = const [DirectoryBuyerProfile, _$DirectoryBuyerProfile];

  @override
  final String wireName = r'DirectoryBuyerProfile';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DirectoryBuyerProfile object, {
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
      specifiedType: const FullType(DirectoryBuyerProfileSubjectTypeEnum),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(DirectoryBuyerProfileStatusEnum),
    );
    yield r'profile';
    yield serializers.serialize(
      object.profile,
      specifiedType: const FullType(DirectoryBuyerProfileProfile),
    );
    yield r'ratings';
    yield serializers.serialize(
      object.ratings,
      specifiedType: const FullType(DirectoryBuyerProfileRatings),
    );
    yield r'activity';
    yield serializers.serialize(
      object.activity,
      specifiedType: const FullType(DirectoryBuyerProfileActivity),
    );
    yield r'recent_orders';
    yield serializers.serialize(
      object.recentOrders,
      specifiedType: const FullType(BuiltList, [FullType(DirectoryBuyerProfileRecentOrdersInner)]),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    DirectoryBuyerProfile object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DirectoryBuyerProfileBuilder result,
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
            specifiedType: const FullType(DirectoryBuyerProfileSubjectTypeEnum),
          ) as DirectoryBuyerProfileSubjectTypeEnum;
          result.subjectType = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DirectoryBuyerProfileStatusEnum),
          ) as DirectoryBuyerProfileStatusEnum;
          result.status = valueDes;
          break;
        case r'profile':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DirectoryBuyerProfileProfile),
          ) as DirectoryBuyerProfileProfile;
          result.profile.replace(valueDes);
          break;
        case r'ratings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DirectoryBuyerProfileRatings),
          ) as DirectoryBuyerProfileRatings;
          result.ratings.replace(valueDes);
          break;
        case r'activity':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DirectoryBuyerProfileActivity),
          ) as DirectoryBuyerProfileActivity;
          result.activity.replace(valueDes);
          break;
        case r'recent_orders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DirectoryBuyerProfileRecentOrdersInner)]),
          ) as BuiltList<DirectoryBuyerProfileRecentOrdersInner>;
          result.recentOrders.replace(valueDes);
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DirectoryBuyerProfile deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DirectoryBuyerProfileBuilder();
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


class DirectoryBuyerProfileSubjectTypeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'BUYER')
  static const DirectoryBuyerProfileSubjectTypeEnum BUYER = _$directoryBuyerProfileSubjectTypeEnum_BUYER;

  static Serializer<DirectoryBuyerProfileSubjectTypeEnum> get serializer => _$directoryBuyerProfileSubjectTypeEnumSerializer;

  const DirectoryBuyerProfileSubjectTypeEnum._(String name): super(name);

  static BuiltSet<DirectoryBuyerProfileSubjectTypeEnum> get values => _$directoryBuyerProfileSubjectTypeEnumValues;
  static DirectoryBuyerProfileSubjectTypeEnum valueOf(String name) => _$directoryBuyerProfileSubjectTypeEnumValueOf(name);
}

class DirectoryBuyerProfileStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ACTIVE')
  static const DirectoryBuyerProfileStatusEnum ACTIVE = _$directoryBuyerProfileStatusEnum_ACTIVE;
  @BuiltValueEnumConst(wireName: r'PENDING_VERIFICATION')
  static const DirectoryBuyerProfileStatusEnum PENDING_VERIFICATION = _$directoryBuyerProfileStatusEnum_PENDING_VERIFICATION;
  @BuiltValueEnumConst(wireName: r'SUSPENDED')
  static const DirectoryBuyerProfileStatusEnum SUSPENDED = _$directoryBuyerProfileStatusEnum_SUSPENDED;
  @BuiltValueEnumConst(wireName: r'DEACTIVATED')
  static const DirectoryBuyerProfileStatusEnum DEACTIVATED = _$directoryBuyerProfileStatusEnum_DEACTIVATED;
  @BuiltValueEnumConst(wireName: r'DELETED')
  static const DirectoryBuyerProfileStatusEnum DELETED = _$directoryBuyerProfileStatusEnum_DELETED;

  static Serializer<DirectoryBuyerProfileStatusEnum> get serializer => _$directoryBuyerProfileStatusEnumSerializer;

  const DirectoryBuyerProfileStatusEnum._(String name): super(name);

  static BuiltSet<DirectoryBuyerProfileStatusEnum> get values => _$directoryBuyerProfileStatusEnumValues;
  static DirectoryBuyerProfileStatusEnum valueOf(String name) => _$directoryBuyerProfileStatusEnumValueOf(name);
}

