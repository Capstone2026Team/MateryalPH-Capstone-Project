//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/score_label.dart';
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/store_operating_day.dart';
import 'package:materyalph_api_client/src/model/store_open_now.dart';
import 'package:materyalph_api_client/src/model/public_address_summary.dart';
import 'package:materyalph_api_client/src/model/store_hours_day.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'public_store_profile.g.dart';

/// PublicStoreProfile
///
/// Properties:
/// * [id]
/// * [vacationMode] - True when all new procurement is paused; existing work remains available.
/// * [publicStoreName]
/// * [description]
/// * [publicEmail]
/// * [publicPhone]
/// * [operatingSchedule]
/// * [effectiveToday]
/// * [effectiveDate]
/// * [effectiveSource]
/// * [timeZone]
/// * [logoUrl] - Validated public media only.
/// * [bannerUrl]
/// * [address]
/// * [supplierType]
/// * [niches]
/// * [fulfillmentMethod]
/// * [scoreLabel]
/// * [hoursStatus] - UNAVAILABLE shows Hours Unavailable; the store stays visible and hours are never fabricated.
/// * [week] - Today and the next six Asia/Manila dates, a unique dated override applied before the weekly rule; explicit Closed days kept. Empty when hours are unavailable.
/// * [openNow]
/// * [allClosed] - True when every weekly day is explicitly Closed, which is a valid saved schedule.
/// * [hoursAsOf]
/// * [hoursNotice]
/// * [hoursUnavailableReason]
@BuiltValue()
abstract class PublicStoreProfile implements Built<PublicStoreProfile, PublicStoreProfileBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  /// True when all new procurement is paused; existing work remains available.
  @BuiltValueField(wireName: r'vacation_mode')
  bool get vacationMode;

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

  /// Validated public media only.
  @BuiltValueField(wireName: r'logo_url')
  String? get logoUrl;

  @BuiltValueField(wireName: r'banner_url')
  String? get bannerUrl;

  @BuiltValueField(wireName: r'address')
  PublicAddressSummary get address;

  @BuiltValueField(wireName: r'supplier_type')
  String? get supplierType;

  @BuiltValueField(wireName: r'niches')
  BuiltList<String> get niches;

  @BuiltValueField(wireName: r'fulfillment_method')
  String? get fulfillmentMethod;

  @BuiltValueField(wireName: r'score_label')
  ScoreLabel get scoreLabel;

  /// UNAVAILABLE shows Hours Unavailable; the store stays visible and hours are never fabricated.
  @BuiltValueField(wireName: r'hours_status')
  PublicStoreProfileHoursStatusEnum get hoursStatus;
  // enum hoursStatusEnum {  AVAILABLE,  UNAVAILABLE,  };

  /// Today and the next six Asia/Manila dates, a unique dated override applied before the weekly rule; explicit Closed days kept. Empty when hours are unavailable.
  @BuiltValueField(wireName: r'week')
  BuiltList<StoreHoursDay> get week;

  @BuiltValueField(wireName: r'open_now')
  StoreOpenNow get openNow;

  /// True when every weekly day is explicitly Closed, which is a valid saved schedule.
  @BuiltValueField(wireName: r'all_closed')
  bool get allClosed;

  @BuiltValueField(wireName: r'hours_as_of')
  DateTime get hoursAsOf;

  @BuiltValueField(wireName: r'hours_notice')
  String get hoursNotice;

  @BuiltValueField(wireName: r'hours_unavailable_reason')
  PublicStoreProfileHoursUnavailableReasonEnum? get hoursUnavailableReason;
  // enum hoursUnavailableReasonEnum {  SCHEDULE_NOT_AVAILABLE,  };

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
    yield r'vacation_mode';
    yield serializers.serialize(
      object.vacationMode,
      specifiedType: const FullType(bool),
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
    yield r'logo_url';
    yield object.logoUrl == null ? null : serializers.serialize(
      object.logoUrl,
      specifiedType: const FullType.nullable(String),
    );
    yield r'banner_url';
    yield object.bannerUrl == null ? null : serializers.serialize(
      object.bannerUrl,
      specifiedType: const FullType.nullable(String),
    );
    yield r'address';
    yield serializers.serialize(
      object.address,
      specifiedType: const FullType(PublicAddressSummary),
    );
    yield r'supplier_type';
    yield object.supplierType == null ? null : serializers.serialize(
      object.supplierType,
      specifiedType: const FullType.nullable(String),
    );
    yield r'niches';
    yield serializers.serialize(
      object.niches,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'fulfillment_method';
    yield object.fulfillmentMethod == null ? null : serializers.serialize(
      object.fulfillmentMethod,
      specifiedType: const FullType.nullable(String),
    );
    yield r'score_label';
    yield serializers.serialize(
      object.scoreLabel,
      specifiedType: const FullType(ScoreLabel),
    );
    yield r'hours_status';
    yield serializers.serialize(
      object.hoursStatus,
      specifiedType: const FullType(PublicStoreProfileHoursStatusEnum),
    );
    yield r'week';
    yield serializers.serialize(
      object.week,
      specifiedType: const FullType(BuiltList, [FullType(StoreHoursDay)]),
    );
    yield r'open_now';
    yield serializers.serialize(
      object.openNow,
      specifiedType: const FullType(StoreOpenNow),
    );
    yield r'all_closed';
    yield serializers.serialize(
      object.allClosed,
      specifiedType: const FullType(bool),
    );
    yield r'hours_as_of';
    yield serializers.serialize(
      object.hoursAsOf,
      specifiedType: const FullType(DateTime),
    );
    yield r'hours_notice';
    yield serializers.serialize(
      object.hoursNotice,
      specifiedType: const FullType(String),
    );
    if (object.hoursUnavailableReason != null) {
      yield r'hours_unavailable_reason';
      yield serializers.serialize(
        object.hoursUnavailableReason,
        specifiedType: const FullType(PublicStoreProfileHoursUnavailableReasonEnum),
      );
    }
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
        case r'vacation_mode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.vacationMode = valueDes;
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
        case r'logo_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.logoUrl = valueDes;
          break;
        case r'banner_url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.bannerUrl = valueDes;
          break;
        case r'address':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PublicAddressSummary),
          ) as PublicAddressSummary;
          result.address.replace(valueDes);
          break;
        case r'supplier_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.supplierType = valueDes;
          break;
        case r'niches':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.niches.replace(valueDes);
          break;
        case r'fulfillment_method':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.fulfillmentMethod = valueDes;
          break;
        case r'score_label':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ScoreLabel),
          ) as ScoreLabel;
          result.scoreLabel.replace(valueDes);
          break;
        case r'hours_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PublicStoreProfileHoursStatusEnum),
          ) as PublicStoreProfileHoursStatusEnum;
          result.hoursStatus = valueDes;
          break;
        case r'week':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(StoreHoursDay)]),
          ) as BuiltList<StoreHoursDay>;
          result.week.replace(valueDes);
          break;
        case r'open_now':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(StoreOpenNow),
          ) as StoreOpenNow;
          result.openNow.replace(valueDes);
          break;
        case r'all_closed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.allClosed = valueDes;
          break;
        case r'hours_as_of':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.hoursAsOf = valueDes;
          break;
        case r'hours_notice':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.hoursNotice = valueDes;
          break;
        case r'hours_unavailable_reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(PublicStoreProfileHoursUnavailableReasonEnum),
          ) as PublicStoreProfileHoursUnavailableReasonEnum?;
          if (valueDes == null) continue;
          result.hoursUnavailableReason = valueDes;
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

/// UNAVAILABLE shows Hours Unavailable; the store stays visible and hours are never fabricated.
class PublicStoreProfileHoursStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'AVAILABLE')
  static const PublicStoreProfileHoursStatusEnum AVAILABLE = _$publicStoreProfileHoursStatusEnum_AVAILABLE;
  @BuiltValueEnumConst(wireName: r'UNAVAILABLE')
  static const PublicStoreProfileHoursStatusEnum UNAVAILABLE = _$publicStoreProfileHoursStatusEnum_UNAVAILABLE;

  static Serializer<PublicStoreProfileHoursStatusEnum> get serializer => _$publicStoreProfileHoursStatusEnumSerializer;

  const PublicStoreProfileHoursStatusEnum._(String name): super(name);

  static BuiltSet<PublicStoreProfileHoursStatusEnum> get values => _$publicStoreProfileHoursStatusEnumValues;
  static PublicStoreProfileHoursStatusEnum valueOf(String name) => _$publicStoreProfileHoursStatusEnumValueOf(name);
}

class PublicStoreProfileHoursUnavailableReasonEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SCHEDULE_NOT_AVAILABLE')
  static const PublicStoreProfileHoursUnavailableReasonEnum SCHEDULE_NOT_AVAILABLE = _$publicStoreProfileHoursUnavailableReasonEnum_SCHEDULE_NOT_AVAILABLE;

  static Serializer<PublicStoreProfileHoursUnavailableReasonEnum> get serializer => _$publicStoreProfileHoursUnavailableReasonEnumSerializer;

  const PublicStoreProfileHoursUnavailableReasonEnum._(String name): super(name);

  static BuiltSet<PublicStoreProfileHoursUnavailableReasonEnum> get values => _$publicStoreProfileHoursUnavailableReasonEnumValues;
  static PublicStoreProfileHoursUnavailableReasonEnum valueOf(String name) => _$publicStoreProfileHoursUnavailableReasonEnumValueOf(name);
}

