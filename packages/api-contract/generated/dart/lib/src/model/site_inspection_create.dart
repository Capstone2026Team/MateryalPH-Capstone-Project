//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'site_inspection_create.g.dart';

/// SiteInspectionCreate
///
/// Properties:
/// * [listingId] - A ready-mixed concrete listing.
/// * [listingVariantId] - The strength class (Required PSI) the Buyer has in mind.
/// * [locationId] - A saved Buyer location; becomes the conversation's delivery destination.
/// * [heavyVehicleRestriction]
/// * [alternateDropOffLocationId] - Required with YES.
/// * [accessInstructions] - Required with YES.
/// * [preferredDate]
/// * [notes]
@BuiltValue()
abstract class SiteInspectionCreate implements Built<SiteInspectionCreate, SiteInspectionCreateBuilder> {
  /// A ready-mixed concrete listing.
  @BuiltValueField(wireName: r'listing_id')
  String get listingId;

  /// The strength class (Required PSI) the Buyer has in mind.
  @BuiltValueField(wireName: r'listing_variant_id')
  String? get listingVariantId;

  /// A saved Buyer location; becomes the conversation's delivery destination.
  @BuiltValueField(wireName: r'location_id')
  String get locationId;

  @BuiltValueField(wireName: r'heavy_vehicle_restriction')
  SiteInspectionCreateHeavyVehicleRestrictionEnum? get heavyVehicleRestriction;
  // enum heavyVehicleRestrictionEnum {  NO,  YES,  };

  /// Required with YES.
  @BuiltValueField(wireName: r'alternate_drop_off_location_id')
  String? get alternateDropOffLocationId;

  /// Required with YES.
  @BuiltValueField(wireName: r'access_instructions')
  String? get accessInstructions;

  @BuiltValueField(wireName: r'preferred_date')
  Date get preferredDate;

  @BuiltValueField(wireName: r'notes')
  String? get notes;

  SiteInspectionCreate._();

  factory SiteInspectionCreate([void updates(SiteInspectionCreateBuilder b)]) = _$SiteInspectionCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SiteInspectionCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SiteInspectionCreate> get serializer => _$SiteInspectionCreateSerializer();
}

class _$SiteInspectionCreateSerializer implements PrimitiveSerializer<SiteInspectionCreate> {
  @override
  final Iterable<Type> types = const [SiteInspectionCreate, _$SiteInspectionCreate];

  @override
  final String wireName = r'SiteInspectionCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SiteInspectionCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'listing_id';
    yield serializers.serialize(
      object.listingId,
      specifiedType: const FullType(String),
    );
    if (object.listingVariantId != null) {
      yield r'listing_variant_id';
      yield serializers.serialize(
        object.listingVariantId,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'location_id';
    yield serializers.serialize(
      object.locationId,
      specifiedType: const FullType(String),
    );
    if (object.heavyVehicleRestriction != null) {
      yield r'heavy_vehicle_restriction';
      yield serializers.serialize(
        object.heavyVehicleRestriction,
        specifiedType: const FullType(SiteInspectionCreateHeavyVehicleRestrictionEnum),
      );
    }
    if (object.alternateDropOffLocationId != null) {
      yield r'alternate_drop_off_location_id';
      yield serializers.serialize(
        object.alternateDropOffLocationId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.accessInstructions != null) {
      yield r'access_instructions';
      yield serializers.serialize(
        object.accessInstructions,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'preferred_date';
    yield serializers.serialize(
      object.preferredDate,
      specifiedType: const FullType(Date),
    );
    if (object.notes != null) {
      yield r'notes';
      yield serializers.serialize(
        object.notes,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SiteInspectionCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SiteInspectionCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'listing_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.listingId = valueDes;
          break;
        case r'listing_variant_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.listingVariantId = valueDes;
          break;
        case r'location_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.locationId = valueDes;
          break;
        case r'heavy_vehicle_restriction':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(SiteInspectionCreateHeavyVehicleRestrictionEnum),
          ) as SiteInspectionCreateHeavyVehicleRestrictionEnum?;
          if (valueDes == null) continue;
          result.heavyVehicleRestriction = valueDes;
          break;
        case r'alternate_drop_off_location_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.alternateDropOffLocationId = valueDes;
          break;
        case r'access_instructions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.accessInstructions = valueDes;
          break;
        case r'preferred_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.preferredDate = valueDes;
          break;
        case r'notes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.notes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SiteInspectionCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SiteInspectionCreateBuilder();
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


class SiteInspectionCreateHeavyVehicleRestrictionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'NO')
  static const SiteInspectionCreateHeavyVehicleRestrictionEnum NO = _$siteInspectionCreateHeavyVehicleRestrictionEnum_NO;
  @BuiltValueEnumConst(wireName: r'YES')
  static const SiteInspectionCreateHeavyVehicleRestrictionEnum YES = _$siteInspectionCreateHeavyVehicleRestrictionEnum_YES;

  static Serializer<SiteInspectionCreateHeavyVehicleRestrictionEnum> get serializer => _$siteInspectionCreateHeavyVehicleRestrictionEnumSerializer;

  const SiteInspectionCreateHeavyVehicleRestrictionEnum._(String name): super(name);

  static BuiltSet<SiteInspectionCreateHeavyVehicleRestrictionEnum> get values => _$siteInspectionCreateHeavyVehicleRestrictionEnumValues;
  static SiteInspectionCreateHeavyVehicleRestrictionEnum valueOf(String name) => _$siteInspectionCreateHeavyVehicleRestrictionEnumValueOf(name);
}

