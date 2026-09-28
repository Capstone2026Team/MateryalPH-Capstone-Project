//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/supplier_tier.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'route_estimate_request.g.dart';

/// RouteEstimateRequest
///
/// Properties:
/// * [locationId]
/// * [latitude]
/// * [longitude]
/// * [originSource]
/// * [radiusKm]
/// * [tier]
/// * [supplierId]
/// * [requestVersion]
@BuiltValue()
abstract class RouteEstimateRequest implements Built<RouteEstimateRequest, RouteEstimateRequestBuilder> {
  @BuiltValueField(wireName: r'location_id')
  String? get locationId;

  @BuiltValueField(wireName: r'latitude')
  double? get latitude;

  @BuiltValueField(wireName: r'longitude')
  double? get longitude;

  @BuiltValueField(wireName: r'origin_source')
  RouteEstimateRequestOriginSourceEnum? get originSource;
  // enum originSourceEnum {  DEVICE,  MAP_PIN,  SEARCH,  };

  @BuiltValueField(wireName: r'radius_km')
  int? get radiusKm;

  @BuiltValueField(wireName: r'tier')
  SupplierTier get tier;
  // enum tierEnum {  VERIFIED_VENDOR,  DIRECTORY_SUPPLIER,  };

  @BuiltValueField(wireName: r'supplier_id')
  String get supplierId;

  @BuiltValueField(wireName: r'request_version')
  String get requestVersion;

  RouteEstimateRequest._();

  factory RouteEstimateRequest([void updates(RouteEstimateRequestBuilder b)]) = _$RouteEstimateRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RouteEstimateRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RouteEstimateRequest> get serializer => _$RouteEstimateRequestSerializer();
}

class _$RouteEstimateRequestSerializer implements PrimitiveSerializer<RouteEstimateRequest> {
  @override
  final Iterable<Type> types = const [RouteEstimateRequest, _$RouteEstimateRequest];

  @override
  final String wireName = r'RouteEstimateRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RouteEstimateRequest object, {
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
        specifiedType: const FullType(RouteEstimateRequestOriginSourceEnum),
      );
    }
    if (object.radiusKm != null) {
      yield r'radius_km';
      yield serializers.serialize(
        object.radiusKm,
        specifiedType: const FullType(int),
      );
    }
    yield r'tier';
    yield serializers.serialize(
      object.tier,
      specifiedType: const FullType(SupplierTier),
    );
    yield r'supplier_id';
    yield serializers.serialize(
      object.supplierId,
      specifiedType: const FullType(String),
    );
    yield r'request_version';
    yield serializers.serialize(
      object.requestVersion,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RouteEstimateRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RouteEstimateRequestBuilder result,
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
            specifiedType: const FullType.nullable(RouteEstimateRequestOriginSourceEnum),
          ) as RouteEstimateRequestOriginSourceEnum?;
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
        case r'tier':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SupplierTier),
          ) as SupplierTier;
          result.tier = valueDes;
          break;
        case r'supplier_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.supplierId = valueDes;
          break;
        case r'request_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.requestVersion = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RouteEstimateRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RouteEstimateRequestBuilder();
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


class RouteEstimateRequestOriginSourceEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'DEVICE')
  static const RouteEstimateRequestOriginSourceEnum DEVICE = _$routeEstimateRequestOriginSourceEnum_DEVICE;
  @BuiltValueEnumConst(wireName: r'MAP_PIN')
  static const RouteEstimateRequestOriginSourceEnum MAP_PIN = _$routeEstimateRequestOriginSourceEnum_MAP_PIN;
  @BuiltValueEnumConst(wireName: r'SEARCH')
  static const RouteEstimateRequestOriginSourceEnum SEARCH = _$routeEstimateRequestOriginSourceEnum_SEARCH;

  static Serializer<RouteEstimateRequestOriginSourceEnum> get serializer => _$routeEstimateRequestOriginSourceEnumSerializer;

  const RouteEstimateRequestOriginSourceEnum._(String name): super(name);

  static BuiltSet<RouteEstimateRequestOriginSourceEnum> get values => _$routeEstimateRequestOriginSourceEnumValues;
  static RouteEstimateRequestOriginSourceEnum valueOf(String name) => _$routeEstimateRequestOriginSourceEnumValueOf(name);
}

