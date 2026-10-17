//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_materials_analytics_request.g.dart';

/// Origins travel in the body. Any other field (a role, competitor id or include flag) is refused with 422.
///
/// Properties:
/// * [locationId]
/// * [latitude]
/// * [longitude]
/// * [originSource]
/// * [radiusKm]
/// * [presetDays]
/// * [startDate]
/// * [endDate]
/// * [categoryId]
/// * [q]
/// * [cursor]
/// * [perPage]
@BuiltValue()
abstract class BuyerMaterialsAnalyticsRequest implements Built<BuyerMaterialsAnalyticsRequest, BuyerMaterialsAnalyticsRequestBuilder> {
  @BuiltValueField(wireName: r'location_id')
  String? get locationId;

  @BuiltValueField(wireName: r'latitude')
  num? get latitude;

  @BuiltValueField(wireName: r'longitude')
  num? get longitude;

  @BuiltValueField(wireName: r'origin_source')
  BuyerMaterialsAnalyticsRequestOriginSourceEnum? get originSource;
  // enum originSourceEnum {  DEVICE,  MAP_PIN,  SEARCH,  };

  @BuiltValueField(wireName: r'radius_km')
  BuyerMaterialsAnalyticsRequestRadiusKmEnum? get radiusKm;
  // enum radiusKmEnum {  5,  10,  20,  30,  40,  50,  };

  @BuiltValueField(wireName: r'preset_days')
  BuyerMaterialsAnalyticsRequestPresetDaysEnum? get presetDays;
  // enum presetDaysEnum {  7,  30,  90,  };

  @BuiltValueField(wireName: r'start_date')
  Date? get startDate;

  @BuiltValueField(wireName: r'end_date')
  Date? get endDate;

  @BuiltValueField(wireName: r'category_id')
  String? get categoryId;

  @BuiltValueField(wireName: r'q')
  String? get q;

  @BuiltValueField(wireName: r'cursor')
  String? get cursor;

  @BuiltValueField(wireName: r'per_page')
  int? get perPage;

  BuyerMaterialsAnalyticsRequest._();

  factory BuyerMaterialsAnalyticsRequest([void updates(BuyerMaterialsAnalyticsRequestBuilder b)]) = _$BuyerMaterialsAnalyticsRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerMaterialsAnalyticsRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerMaterialsAnalyticsRequest> get serializer => _$BuyerMaterialsAnalyticsRequestSerializer();
}

class _$BuyerMaterialsAnalyticsRequestSerializer implements PrimitiveSerializer<BuyerMaterialsAnalyticsRequest> {
  @override
  final Iterable<Type> types = const [BuyerMaterialsAnalyticsRequest, _$BuyerMaterialsAnalyticsRequest];

  @override
  final String wireName = r'BuyerMaterialsAnalyticsRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerMaterialsAnalyticsRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.locationId != null) {
      yield r'location_id';
      yield serializers.serialize(
        object.locationId,
        specifiedType: const FullType(String),
      );
    }
    if (object.latitude != null) {
      yield r'latitude';
      yield serializers.serialize(
        object.latitude,
        specifiedType: const FullType(num),
      );
    }
    if (object.longitude != null) {
      yield r'longitude';
      yield serializers.serialize(
        object.longitude,
        specifiedType: const FullType(num),
      );
    }
    if (object.originSource != null) {
      yield r'origin_source';
      yield serializers.serialize(
        object.originSource,
        specifiedType: const FullType(BuyerMaterialsAnalyticsRequestOriginSourceEnum),
      );
    }
    if (object.radiusKm != null) {
      yield r'radius_km';
      yield serializers.serialize(
        object.radiusKm,
        specifiedType: const FullType(BuyerMaterialsAnalyticsRequestRadiusKmEnum),
      );
    }
    if (object.presetDays != null) {
      yield r'preset_days';
      yield serializers.serialize(
        object.presetDays,
        specifiedType: const FullType(BuyerMaterialsAnalyticsRequestPresetDaysEnum),
      );
    }
    if (object.startDate != null) {
      yield r'start_date';
      yield serializers.serialize(
        object.startDate,
        specifiedType: const FullType(Date),
      );
    }
    if (object.endDate != null) {
      yield r'end_date';
      yield serializers.serialize(
        object.endDate,
        specifiedType: const FullType(Date),
      );
    }
    if (object.categoryId != null) {
      yield r'category_id';
      yield serializers.serialize(
        object.categoryId,
        specifiedType: const FullType(String),
      );
    }
    if (object.q != null) {
      yield r'q';
      yield serializers.serialize(
        object.q,
        specifiedType: const FullType(String),
      );
    }
    if (object.cursor != null) {
      yield r'cursor';
      yield serializers.serialize(
        object.cursor,
        specifiedType: const FullType(String),
      );
    }
    if (object.perPage != null) {
      yield r'per_page';
      yield serializers.serialize(
        object.perPage,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerMaterialsAnalyticsRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerMaterialsAnalyticsRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'location_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.locationId = valueDes;
          break;
        case r'latitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.latitude = valueDes;
          break;
        case r'longitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.longitude = valueDes;
          break;
        case r'origin_source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuyerMaterialsAnalyticsRequestOriginSourceEnum),
          ) as BuyerMaterialsAnalyticsRequestOriginSourceEnum?;
          if (valueDes == null) continue;
          result.originSource = valueDes;
          break;
        case r'radius_km':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuyerMaterialsAnalyticsRequestRadiusKmEnum),
          ) as BuyerMaterialsAnalyticsRequestRadiusKmEnum?;
          if (valueDes == null) continue;
          result.radiusKm = valueDes;
          break;
        case r'preset_days':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuyerMaterialsAnalyticsRequestPresetDaysEnum),
          ) as BuyerMaterialsAnalyticsRequestPresetDaysEnum?;
          if (valueDes == null) continue;
          result.presetDays = valueDes;
          break;
        case r'start_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.startDate = valueDes;
          break;
        case r'end_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Date),
          ) as Date?;
          if (valueDes == null) continue;
          result.endDate = valueDes;
          break;
        case r'category_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.categoryId = valueDes;
          break;
        case r'q':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.q = valueDes;
          break;
        case r'cursor':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.cursor = valueDes;
          break;
        case r'per_page':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.perPage = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BuyerMaterialsAnalyticsRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerMaterialsAnalyticsRequestBuilder();
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


class BuyerMaterialsAnalyticsRequestOriginSourceEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DEVICE')
  static const BuyerMaterialsAnalyticsRequestOriginSourceEnum DEVICE = _$buyerMaterialsAnalyticsRequestOriginSourceEnum_DEVICE;
  @BuiltValueEnumConst(wireName: r'MAP_PIN')
  static const BuyerMaterialsAnalyticsRequestOriginSourceEnum MAP_PIN = _$buyerMaterialsAnalyticsRequestOriginSourceEnum_MAP_PIN;
  @BuiltValueEnumConst(wireName: r'SEARCH')
  static const BuyerMaterialsAnalyticsRequestOriginSourceEnum SEARCH = _$buyerMaterialsAnalyticsRequestOriginSourceEnum_SEARCH;

  static Serializer<BuyerMaterialsAnalyticsRequestOriginSourceEnum> get serializer => _$buyerMaterialsAnalyticsRequestOriginSourceEnumSerializer;

  const BuyerMaterialsAnalyticsRequestOriginSourceEnum._(String name): super(name);

  static BuiltSet<BuyerMaterialsAnalyticsRequestOriginSourceEnum> get values => _$buyerMaterialsAnalyticsRequestOriginSourceEnumValues;
  static BuyerMaterialsAnalyticsRequestOriginSourceEnum valueOf(String name) => _$buyerMaterialsAnalyticsRequestOriginSourceEnumValueOf(name);
}

class BuyerMaterialsAnalyticsRequestRadiusKmEnum extends EnumClass {

  @BuiltValueEnumConst(wireNumber: 5)
  static const BuyerMaterialsAnalyticsRequestRadiusKmEnum number5 = _$buyerMaterialsAnalyticsRequestRadiusKmEnum_number5;
  @BuiltValueEnumConst(wireNumber: 10)
  static const BuyerMaterialsAnalyticsRequestRadiusKmEnum number10 = _$buyerMaterialsAnalyticsRequestRadiusKmEnum_number10;
  @BuiltValueEnumConst(wireNumber: 20)
  static const BuyerMaterialsAnalyticsRequestRadiusKmEnum number20 = _$buyerMaterialsAnalyticsRequestRadiusKmEnum_number20;
  @BuiltValueEnumConst(wireNumber: 30)
  static const BuyerMaterialsAnalyticsRequestRadiusKmEnum number30 = _$buyerMaterialsAnalyticsRequestRadiusKmEnum_number30;
  @BuiltValueEnumConst(wireNumber: 40)
  static const BuyerMaterialsAnalyticsRequestRadiusKmEnum number40 = _$buyerMaterialsAnalyticsRequestRadiusKmEnum_number40;
  @BuiltValueEnumConst(wireNumber: 50)
  static const BuyerMaterialsAnalyticsRequestRadiusKmEnum number50 = _$buyerMaterialsAnalyticsRequestRadiusKmEnum_number50;

  static Serializer<BuyerMaterialsAnalyticsRequestRadiusKmEnum> get serializer => _$buyerMaterialsAnalyticsRequestRadiusKmEnumSerializer;

  const BuyerMaterialsAnalyticsRequestRadiusKmEnum._(String name): super(name);

  static BuiltSet<BuyerMaterialsAnalyticsRequestRadiusKmEnum> get values => _$buyerMaterialsAnalyticsRequestRadiusKmEnumValues;
  static BuyerMaterialsAnalyticsRequestRadiusKmEnum valueOf(String name) => _$buyerMaterialsAnalyticsRequestRadiusKmEnumValueOf(name);
}

class BuyerMaterialsAnalyticsRequestPresetDaysEnum extends EnumClass {

  @BuiltValueEnumConst(wireNumber: 7)
  static const BuyerMaterialsAnalyticsRequestPresetDaysEnum number7 = _$buyerMaterialsAnalyticsRequestPresetDaysEnum_number7;
  @BuiltValueEnumConst(wireNumber: 30)
  static const BuyerMaterialsAnalyticsRequestPresetDaysEnum number30 = _$buyerMaterialsAnalyticsRequestPresetDaysEnum_number30;
  @BuiltValueEnumConst(wireNumber: 90)
  static const BuyerMaterialsAnalyticsRequestPresetDaysEnum number90 = _$buyerMaterialsAnalyticsRequestPresetDaysEnum_number90;

  static Serializer<BuyerMaterialsAnalyticsRequestPresetDaysEnum> get serializer => _$buyerMaterialsAnalyticsRequestPresetDaysEnumSerializer;

  const BuyerMaterialsAnalyticsRequestPresetDaysEnum._(String name): super(name);

  static BuiltSet<BuyerMaterialsAnalyticsRequestPresetDaysEnum> get values => _$buyerMaterialsAnalyticsRequestPresetDaysEnumValues;
  static BuyerMaterialsAnalyticsRequestPresetDaysEnum valueOf(String name) => _$buyerMaterialsAnalyticsRequestPresetDaysEnumValueOf(name);
}

