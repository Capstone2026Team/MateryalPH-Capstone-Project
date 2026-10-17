//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/site_inspection_site.dart';
import 'package:materyalph_api_client/src/model/site_inspection_listing.dart';
import 'package:materyalph_api_client/src/model/site_inspection_variant.dart';
import 'package:materyalph_api_client/src/model/site_inspection_actions.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'site_inspection.g.dart';

/// SiteInspection
///
/// Properties:
/// * [id]
/// * [status]
/// * [lockVersion]
/// * [listing]
/// * [variant]
/// * [site]
/// * [preferredDate]
/// * [buyerNotes] - Shown only to the Buyer and the store's sales roles.
/// * [scheduledFor]
/// * [vendorNote]
/// * [measuredVolumeM3] - Three-decimal cubic meters once COMPLETED.
/// * [requestedAt]
/// * [closedAt]
/// * [free] - Always true; inspections are never charged.
/// * [actions]
@BuiltValue()
abstract class SiteInspection implements Built<SiteInspection, SiteInspectionBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'status')
  SiteInspectionStatusEnum get status;
  // enum statusEnum {  REQUESTED,  SCHEDULED,  COMPLETED,  DECLINED,  CANCELLED,  };

  @BuiltValueField(wireName: r'lock_version')
  int get lockVersion;

  @BuiltValueField(wireName: r'listing')
  SiteInspectionListing get listing;

  @BuiltValueField(wireName: r'variant')
  SiteInspectionVariant? get variant;

  @BuiltValueField(wireName: r'site')
  SiteInspectionSite get site;

  @BuiltValueField(wireName: r'preferred_date')
  Date get preferredDate;

  /// Shown only to the Buyer and the store's sales roles.
  @BuiltValueField(wireName: r'buyer_notes')
  String? get buyerNotes;

  @BuiltValueField(wireName: r'scheduled_for')
  DateTime? get scheduledFor;

  @BuiltValueField(wireName: r'vendor_note')
  String? get vendorNote;

  /// Three-decimal cubic meters once COMPLETED.
  @BuiltValueField(wireName: r'measured_volume_m3')
  String? get measuredVolumeM3;

  @BuiltValueField(wireName: r'requested_at')
  DateTime get requestedAt;

  @BuiltValueField(wireName: r'closed_at')
  DateTime? get closedAt;

  /// Always true; inspections are never charged.
  @BuiltValueField(wireName: r'free')
  bool get free;

  @BuiltValueField(wireName: r'actions')
  SiteInspectionActions get actions;

  SiteInspection._();

  factory SiteInspection([void updates(SiteInspectionBuilder b)]) = _$SiteInspection;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SiteInspectionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SiteInspection> get serializer => _$SiteInspectionSerializer();
}

class _$SiteInspectionSerializer implements PrimitiveSerializer<SiteInspection> {
  @override
  final Iterable<Type> types = const [SiteInspection, _$SiteInspection];

  @override
  final String wireName = r'SiteInspection';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SiteInspection object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(SiteInspectionStatusEnum),
    );
    yield r'lock_version';
    yield serializers.serialize(
      object.lockVersion,
      specifiedType: const FullType(int),
    );
    yield r'listing';
    yield serializers.serialize(
      object.listing,
      specifiedType: const FullType(SiteInspectionListing),
    );
    yield r'variant';
    yield object.variant == null ? null : serializers.serialize(
      object.variant,
      specifiedType: const FullType.nullable(SiteInspectionVariant),
    );
    yield r'site';
    yield serializers.serialize(
      object.site,
      specifiedType: const FullType(SiteInspectionSite),
    );
    yield r'preferred_date';
    yield serializers.serialize(
      object.preferredDate,
      specifiedType: const FullType(Date),
    );
    yield r'buyer_notes';
    yield object.buyerNotes == null ? null : serializers.serialize(
      object.buyerNotes,
      specifiedType: const FullType.nullable(String),
    );
    yield r'scheduled_for';
    yield object.scheduledFor == null ? null : serializers.serialize(
      object.scheduledFor,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'vendor_note';
    yield object.vendorNote == null ? null : serializers.serialize(
      object.vendorNote,
      specifiedType: const FullType.nullable(String),
    );
    yield r'measured_volume_m3';
    yield object.measuredVolumeM3 == null ? null : serializers.serialize(
      object.measuredVolumeM3,
      specifiedType: const FullType.nullable(String),
    );
    yield r'requested_at';
    yield serializers.serialize(
      object.requestedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'closed_at';
    yield object.closedAt == null ? null : serializers.serialize(
      object.closedAt,
      specifiedType: const FullType.nullable(DateTime),
    );
    yield r'free';
    yield serializers.serialize(
      object.free,
      specifiedType: const FullType(bool),
    );
    yield r'actions';
    yield serializers.serialize(
      object.actions,
      specifiedType: const FullType(SiteInspectionActions),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SiteInspection object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SiteInspectionBuilder result,
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
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SiteInspectionStatusEnum),
          ) as SiteInspectionStatusEnum;
          result.status = valueDes;
          break;
        case r'lock_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.lockVersion = valueDes;
          break;
        case r'listing':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SiteInspectionListing),
          ) as SiteInspectionListing;
          result.listing.replace(valueDes);
          break;
        case r'variant':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(SiteInspectionVariant),
          ) as SiteInspectionVariant?;
          if (valueDes == null) continue;
          result.variant.replace(valueDes);
          break;
        case r'site':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SiteInspectionSite),
          ) as SiteInspectionSite;
          result.site.replace(valueDes);
          break;
        case r'preferred_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.preferredDate = valueDes;
          break;
        case r'buyer_notes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.buyerNotes = valueDes;
          break;
        case r'scheduled_for':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.scheduledFor = valueDes;
          break;
        case r'vendor_note':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.vendorNote = valueDes;
          break;
        case r'measured_volume_m3':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.measuredVolumeM3 = valueDes;
          break;
        case r'requested_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.requestedAt = valueDes;
          break;
        case r'closed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.closedAt = valueDes;
          break;
        case r'free':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.free = valueDes;
          break;
        case r'actions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SiteInspectionActions),
          ) as SiteInspectionActions;
          result.actions.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SiteInspection deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SiteInspectionBuilder();
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


class SiteInspectionStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'REQUESTED')
  static const SiteInspectionStatusEnum REQUESTED = _$siteInspectionStatusEnum_REQUESTED;
  @BuiltValueEnumConst(wireName: r'SCHEDULED')
  static const SiteInspectionStatusEnum SCHEDULED = _$siteInspectionStatusEnum_SCHEDULED;
  @BuiltValueEnumConst(wireName: r'COMPLETED')
  static const SiteInspectionStatusEnum COMPLETED = _$siteInspectionStatusEnum_COMPLETED;
  @BuiltValueEnumConst(wireName: r'DECLINED')
  static const SiteInspectionStatusEnum DECLINED = _$siteInspectionStatusEnum_DECLINED;
  @BuiltValueEnumConst(wireName: r'CANCELLED')
  static const SiteInspectionStatusEnum CANCELLED = _$siteInspectionStatusEnum_CANCELLED;

  static Serializer<SiteInspectionStatusEnum> get serializer => _$siteInspectionStatusEnumSerializer;

  const SiteInspectionStatusEnum._(String name): super(name);

  static BuiltSet<SiteInspectionStatusEnum> get values => _$siteInspectionStatusEnumValues;
  static SiteInspectionStatusEnum valueOf(String name) => _$siteInspectionStatusEnumValueOf(name);
}

