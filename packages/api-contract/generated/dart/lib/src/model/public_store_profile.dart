//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/store_operating_day.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_store_profile.g.dart';

/// PublicStoreProfile
///
/// Properties:
/// * [id]
/// * [publicStoreName]
/// * [description]
/// * [publicEmail]
/// * [publicPhone]
/// * [operatingSchedule]
/// * [effectiveToday]
/// * [effectiveDate]
/// * [effectiveSource]
/// * [timeZone]
@BuiltValue()
abstract class PublicStoreProfile implements Built<PublicStoreProfile, PublicStoreProfileBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'public_store_name')
  String get publicStoreName;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'public_email')
  String? get publicEmail;

  @BuiltValueField(wireName: r'public_phone')
  String? get publicPhone;

  @BuiltValueField(wireName: r'operating_schedule')
  BuiltList<StoreOperatingDay> get operatingSchedule;

  @BuiltValueField(wireName: r'effective_today')
  StoreOperatingDay? get effectiveToday;

  @BuiltValueField(wireName: r'effective_date')
  Date get effectiveDate;

  @BuiltValueField(wireName: r'effective_source')
  PublicStoreProfileEffectiveSourceEnum get effectiveSource;
  // enum effectiveSourceEnum {  WEEKLY,  DATE_OVERRIDE,  };

  @BuiltValueField(wireName: r'time_zone')
  PublicStoreProfileTimeZoneEnum get timeZone;
  // enum timeZoneEnum {  Asia/Manila,  };

  PublicStoreProfile._();

  factory PublicStoreProfile([void updates(PublicStoreProfileBuilder b)]) = _$PublicStoreProfile;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PublicStoreProfileBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PublicStoreProfile> get serializer => _$PublicStoreProfileSerializer();
}

class _$PublicStoreProfileSerializer implements PrimitiveSerializer<PublicStoreProfile> {
  @override
  final Iterable<Type> types = const [PublicStoreProfile, _$PublicStoreProfile];

  @override
  final String wireName = r'PublicStoreProfile';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PublicStoreProfile object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'public_store_name';
    yield serializers.serialize(
      object.publicStoreName,
      specifiedType: const FullType(String),
    );
    yield r'description';
    yield object.description == null ? null : serializers.serialize(
      object.description,
      specifiedType: const FullType.nullable(String),
    );
    yield r'public_email';
    yield object.publicEmail == null ? null : serializers.serialize(
      object.publicEmail,
      specifiedType: const FullType.nullable(String),
    );
    yield r'public_phone';
    yield object.publicPhone == null ? null : serializers.serialize(
      object.publicPhone,
      specifiedType: const FullType.nullable(String),
    );
    yield r'operating_schedule';
    yield serializers.serialize(
      object.operatingSchedule,
      specifiedType: const FullType(BuiltList, [FullType(StoreOperatingDay)]),
    );
    yield r'effective_today';
    yield object.effectiveToday == null ? null : serializers.serialize(
      object.effectiveToday,
      specifiedType: const FullType.nullable(StoreOperatingDay),
    );
    yield r'effective_date';
    yield serializers.serialize(
      object.effectiveDate,
      specifiedType: const FullType(Date),
    );
    yield r'effective_source';
    yield serializers.serialize(
      object.effectiveSource,
      specifiedType: const FullType(PublicStoreProfileEffectiveSourceEnum),
    );
    yield r'time_zone';
    yield serializers.serialize(
      object.timeZone,
      specifiedType: const FullType(PublicStoreProfileTimeZoneEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PublicStoreProfile object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PublicStoreProfileBuilder result,
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
        case r'public_store_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.publicStoreName = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'public_email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.publicEmail = valueDes;
          break;
        case r'public_phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.publicPhone = valueDes;
          break;
        case r'operating_schedule':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(StoreOperatingDay)]),
          ) as BuiltList<StoreOperatingDay>;
          result.operatingSchedule.replace(valueDes);
          break;
        case r'effective_today':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(StoreOperatingDay),
          ) as StoreOperatingDay?;
          if (valueDes == null) continue;
          result.effectiveToday.replace(valueDes);
          break;
        case r'effective_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.effectiveDate = valueDes;
          break;
        case r'effective_source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PublicStoreProfileEffectiveSourceEnum),
          ) as PublicStoreProfileEffectiveSourceEnum;
          result.effectiveSource = valueDes;
          break;
        case r'time_zone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PublicStoreProfileTimeZoneEnum),
          ) as PublicStoreProfileTimeZoneEnum;
          result.timeZone = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PublicStoreProfile deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PublicStoreProfileBuilder();
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


class PublicStoreProfileEffectiveSourceEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'WEEKLY')
  static const PublicStoreProfileEffectiveSourceEnum WEEKLY = _$publicStoreProfileEffectiveSourceEnum_WEEKLY;
  @BuiltValueEnumConst(wireName: r'DATE_OVERRIDE')
  static const PublicStoreProfileEffectiveSourceEnum DATE_OVERRIDE = _$publicStoreProfileEffectiveSourceEnum_DATE_OVERRIDE;

  static Serializer<PublicStoreProfileEffectiveSourceEnum> get serializer => _$publicStoreProfileEffectiveSourceEnumSerializer;

  const PublicStoreProfileEffectiveSourceEnum._(String name): super(name);

  static BuiltSet<PublicStoreProfileEffectiveSourceEnum> get values => _$publicStoreProfileEffectiveSourceEnumValues;
  static PublicStoreProfileEffectiveSourceEnum valueOf(String name) => _$publicStoreProfileEffectiveSourceEnumValueOf(name);
}

class PublicStoreProfileTimeZoneEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'Asia/Manila')
  static const PublicStoreProfileTimeZoneEnum asiaSlashManila = _$publicStoreProfileTimeZoneEnum_asiaSlashManila;

  static Serializer<PublicStoreProfileTimeZoneEnum> get serializer => _$publicStoreProfileTimeZoneEnumSerializer;

  const PublicStoreProfileTimeZoneEnum._(String name): super(name);

  static BuiltSet<PublicStoreProfileTimeZoneEnum> get values => _$publicStoreProfileTimeZoneEnumValues;
  static PublicStoreProfileTimeZoneEnum valueOf(String name) => _$publicStoreProfileTimeZoneEnumValueOf(name);
}

