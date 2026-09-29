//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_origin_request.g.dart';

/// Send location_id or latitude/longitude (never both). Omit both to use the primary saved location. radius_km defaults to the saved preference.
///
/// Properties:
/// * [locationId]
/// * [latitude]
/// * [longitude]
/// * [originSource]
/// * [radiusKm] - Must be one of 5, 10, 20, 30, 40 or 50; otherwise 422 RADIUS_UNSUPPORTED.
@BuiltValue()
abstract class BuyerOriginRequest implements Built<BuyerOriginRequest, BuyerOriginRequestBuilder> {
  @BuiltValueField(wireName: r'location_id')
  String? get locationId;

  @BuiltValueField(wireName: r'latitude')
  double? get latitude;

  @BuiltValueField(wireName: r'longitude')
  double? get longitude;

  @BuiltValueField(wireName: r'origin_source')
  BuyerOriginRequestOriginSourceEnum? get originSource;
  // enum originSourceEnum {  DEVICE,  MAP_PIN,  SEARCH,  };

  /// Must be one of 5, 10, 20, 30, 40 or 50; otherwise 422 RADIUS_UNSUPPORTED.
  @BuiltValueField(wireName: r'radius_km')
  int? get radiusKm;

  BuyerOriginRequest._();

  factory BuyerOriginRequest([void updates(BuyerOriginRequestBuilder b)]) = _$BuyerOriginRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerOriginRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerOriginRequest> get serializer => _$BuyerOriginRequestSerializer();
}

class _$BuyerOriginRequestSerializer implements PrimitiveSerializer<BuyerOriginRequest> {
  @override
  final Iterable<Type> types = const [BuyerOriginRequest, _$BuyerOriginRequest];

  @override
  final String wireName = r'BuyerOriginRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerOriginRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.locationId != null) {
      yield r'location_id';
      yield serializers.serialize(
        object.locationId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.latitude != null) {
      yield r'latitude';
      yield serializers.serialize(
        object.latitude,
        specifiedType: const FullType(double),
      );
    }
    if (object.longitude != null) {
      yield r'longitude';
      yield serializers.serialize(
        object.longitude,
        specifiedType: const FullType(double),
      );
    }
    if (object.originSource != null) {
      yield r'origin_source';
      yield serializers.serialize(
        object.originSource,
        specifiedType: const FullType(BuyerOriginRequestOriginSourceEnum),
      );
    }
    if (object.radiusKm != null) {
      yield r'radius_km';
      yield serializers.serialize(
        object.radiusKm,
        specifiedType: const FullType(int),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerOriginRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerOriginRequestBuilder result,
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
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.latitude = valueDes;
          break;
        case r'longitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(double),
          ) as double?;
          if (valueDes == null) continue;
          result.longitude = valueDes;
          break;
        case r'origin_source':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuyerOriginRequestOriginSourceEnum),
          ) as BuyerOriginRequestOriginSourceEnum?;
          if (valueDes == null) continue;
          result.originSource = valueDes;
          break;
        case r'radius_km':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.radiusKm = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BuyerOriginRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerOriginRequestBuilder();
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


class BuyerOriginRequestOriginSourceEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DEVICE')
  static const BuyerOriginRequestOriginSourceEnum DEVICE = _$buyerOriginRequestOriginSourceEnum_DEVICE;
  @BuiltValueEnumConst(wireName: r'MAP_PIN')
  static const BuyerOriginRequestOriginSourceEnum MAP_PIN = _$buyerOriginRequestOriginSourceEnum_MAP_PIN;
  @BuiltValueEnumConst(wireName: r'SEARCH')
  static const BuyerOriginRequestOriginSourceEnum SEARCH = _$buyerOriginRequestOriginSourceEnum_SEARCH;

  static Serializer<BuyerOriginRequestOriginSourceEnum> get serializer => _$buyerOriginRequestOriginSourceEnumSerializer;

  const BuyerOriginRequestOriginSourceEnum._(String name): super(name);

  static BuiltSet<BuyerOriginRequestOriginSourceEnum> get values => _$buyerOriginRequestOriginSourceEnumValues;
  static BuyerOriginRequestOriginSourceEnum valueOf(String name) => _$buyerOriginRequestOriginSourceEnumValueOf(name);
}

